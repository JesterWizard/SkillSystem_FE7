"""DEC-85 activation flags, verified against the built FE7_Hack.gba.

The source-level twin (test_skill_activation_flags.py) proves the arithmetic.
This one proves the arithmetic is *reachable*: it walks gProcScr_PlayerPhase in
the assembled ROM to the reset routine, then executes those ROM bytes under
Unicorn. That is the form of check that would have caught the Defiant chain
never being installed.
"""
import struct
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))
sys.path.insert(0, str(Path(__file__).resolve().parent))

import built_rom  # noqa: E402  (FE7_Hack.gba loader with an assembled-ROM check)

BUILT = built_rom.BUILT
SRC = ROOT / "EngineHacks/SkillSystem/Internals/SkillActivationFlags/SkillActivationFlags.c"

# gProcScr_PlayerPhase is started fresh by the phase dispatcher at 0x080153E0
# when gPlaySt+0x0F (phase) is 0, so the commands above its first PROC_LABEL
# run exactly once per player phase.
PLAYER_PHASE_SCRIPT = 0x08B93374
HOOKED_COMMAND = 0x08B93384   # PROC_YIELD, the last command before LABEL(0)
RESUME_COMMAND = 0x08B9338C   # LABEL(0)
DISPLACED_COMMAND = (0x0E, 0x0000)  # PROC_YIELD, replayed inside our proc

PROC_CALL_ROUTINE = 0x02
PROC_LABEL = 0x0B
PROC_GOTO = 0x0C
PROC_JUMP = 0x0D
PROC_END = 0x00
PROC_SLEEP = 0x0E

FREESPACE = range(0x09000000, 0x0A000000)  # CustomDefinitions.event FreeSpace window

FLAG_TABLE_SEED = 0x02100000  # not used by the ROM; the real pointers are read below
UNIT_LOOKUP = 0x02120000
GET_UNIT_STUB = 0x02140000  # stand-in GetUnit for the harness
UNIT_BASE = 0x02130000
UNIT_STRIDE = 0x100
ACT_FLAGS = 0x3A

GET_UNIT_LITERAL = struct.pack("<I", 0x08018D0D)  # thumb bit set
TRAMPOLINE_TAIL = b"\x00\xf8"

PER_MAP_BIT = 15
PER_TURN_BIT = 3


_rom = built_rom.load


def _at(rom, addr, size=4):
    off = built_rom.offset(rom, addr, size)
    return rom[off:off + size]


def _word(rom, addr):
    return struct.unpack("<I", _at(rom, addr))[0]


def _full_command(rom, addr):
    """One 8-byte proc command: (opcode, inline param, argument word)."""
    op, arg = struct.unpack("<II", _at(rom, addr, 8))
    return op & 0xFFFF, (op >> 16) & 0xFFFF, arg


def _command(rom, addr):
    """One 8-byte proc command: (opcode, argument word)."""
    op, _param, arg = _full_command(rom, addr)
    return op, arg


class PlayerPhaseHookTests(unittest.TestCase):
    """The once-per-turn reset has to actually be spliced into the player phase."""

    def test_first_player_phase_command_jumps_into_freespace(self):
        rom = _rom()
        op, target = _command(rom, HOOKED_COMMAND)
        self.assertEqual(op, PROC_JUMP, "gProcScr_PlayerPhase must open with a jump to our proc")
        self.assertIn(target, FREESPACE, f"jump target {target:#010x} is not in FreeSpace")

    def test_reset_proc_calls_a_routine_then_replays_and_returns(self):
        rom = _rom()
        _op, proc = _command(rom, HOOKED_COMMAND)

        op, routine = _command(rom, proc)
        self.assertEqual(op, PROC_CALL_ROUTINE)
        self.assertIn(routine & ~1, FREESPACE, "reset routine must live in FreeSpace")
        self.assertTrue(routine & 1, "proc routine pointers need the Thumb bit")

        op, param, _arg = _full_command(rom, proc + 8)
        self.assertEqual(
            (op, param), DISPLACED_COMMAND,
            "the vanilla command we displaced must still run, or the player phase loses it",
        )

        op, resume = _command(rom, proc + 16)
        self.assertEqual(op, PROC_JUMP)
        self.assertEqual(resume, RESUME_COMMAND, "must resume at the displaced command's slot")

    def test_reset_hook_is_above_every_label_so_it_cannot_re_run(self):
        """The once-per-turn reset must run once per phase, not once per action.

        gProcScr_PlayerPhase's labels mark the per-action idle loop, and several
        PROC_GOTOs jump back to them every time a unit finishes acting. A hook
        placed at or below the first PROC_LABEL therefore re-runs mid-turn and
        silently recharges every once-per-turn skill.
        """
        rom = _rom()
        reset_proc = built_rom.symbols().get("SkillActivationFlagTurnResetProc")
        if reset_proc is None:
            raise unittest.SkipTest("SkillActivationFlagTurnResetProc not in FE7_Hack.sym")
        first_label = None
        gotos = []
        hooks = []
        addr = PLAYER_PHASE_SCRIPT
        for _ in range(128):
            op, param, arg = _full_command(rom, addr)
            if op == PROC_END:
                break
            if op == PROC_LABEL and first_label is None:
                first_label = addr
            if op == PROC_GOTO:
                gotos.append(param)
            if op == PROC_JUMP and arg == reset_proc:
                hooks.append(addr)
            addr += 8

        self.assertIsNotNone(first_label, "no PROC_LABEL found; script layout changed")
        self.assertTrue(gotos, "no PROC_GOTO found; script layout changed")
        self.assertEqual(
            len(hooks), 1,
            "gProcScr_PlayerPhase must jump to the reset proc from exactly one "
            f"command, found {len(hooks)}: {[hex(h) for h in hooks]}",
        )
        self.assertLess(
            hooks[0], first_label,
            f"hook at {hooks[0]:#010x} is at or inside the loop that starts at "
            f"{first_label:#010x}; it would re-run on every PROC_GOTO and recharge "
            "once-per-turn skills mid-turn",
        )
        self.assertEqual(hooks[0], HOOKED_COMMAND, "hook moved; update HOOKED_COMMAND")

    def test_flag_tables_are_wired_into_the_routine(self):
        """Both tables must be real FreeSpace addresses the routine can reach.

        The C build puts each table pointer in the literal pool of whichever
        function uses it, so rather than reading one fixed literal block this
        checks the addresses the linker resolved and confirms the routine's own
        bytes reference them.
        """
        rom = _rom()
        blob, offsets = _locate_blob(rom)
        table = offsets["SkillActivationFlagTable"]
        scope = offsets["SkillActivationFlagScope"]

        self.assertIn(table, FREESPACE, "SkillActivationFlagTable is not in FreeSpace")
        self.assertIn(scope, FREESPACE, "SkillActivationFlagScope is not in FreeSpace")
        self.assertNotEqual(table, scope)

        # The reset routine reads the scope table; the whole blob must literally
        # contain that pointer, otherwise nothing links the code to the data.
        body = rom[blob:offsets["blob_end"]]
        self.assertIn(struct.pack("<I", scope), body,
                      "no literal reference to SkillActivationFlagScope in the routines")
        self.assertIn(struct.pack("<I", table), body,
                      "no literal reference to SkillActivationFlagTable in the routines")


def _locate_blob(rom):
    """File offset of the activation-flag code blob in FE7_Hack.gba, plus a
    symbol map relative to it.

    The routines are compiled from C, so their addresses come from FE7_Hack.sym
    rather than from label offsets in a hand-written .s. The blob is still found
    by *following the installed proc*, not by a fixed offset, so this keeps
    proving the reset routine is actually reachable from the player phase
    script -- that is the whole point of this file.
    """
    sym = built_rom.symbols()
    for name in ("SkillActivationFlagRoutines", "ResetTurnActivationFlags",
                 "SkillActivationFlagTable", "SkillActivationFlagScope",
                 "SkillActivationFlagTurnResetProc"):
        if name not in sym:
            raise unittest.SkipTest(f"{name} missing from FE7_Hack.sym")

    _op, proc = _command(rom, HOOKED_COMMAND)
    _op, routine = _command(rom, proc)

    # The pointer the installed proc calls must be the reset routine itself.
    if (routine & ~1) != (sym["ResetTurnActivationFlags"] & ~1):
        raise AssertionError(
            "player phase proc does not call ResetTurnActivationFlags "
            f"(calls {routine:#010x}, expected {sym['ResetTurnActivationFlags']:#010x})")

    base = sym["SkillActivationFlagRoutines"] & ~1
    blob = built_rom.offset(rom, base)
    # Layout in FreeSpace: the two tables, then the routines, then the proc
    # script the player-phase hook jumps to. The routines run to that proc.
    offsets = {
        "ResetTurnActivationFlags": (sym["ResetTurnActivationFlags"] & ~1) - base,
        "SkillActivationFlagTable": sym["SkillActivationFlagTable"],
        "SkillActivationFlagScope": sym["SkillActivationFlagScope"],
        "blob_end": built_rom.offset(
            rom, sym["SkillActivationFlagTurnResetProc"] & ~1),
    }
    return blob, offsets


class RomResetExecutionTests(unittest.TestCase):
    """Executes the reset routine's bytes as they sit in FE7_Hack.gba."""

    def _run(self, initial_flags, per_map_bits=(PER_MAP_BIT,)):
        try:
            from Tools.thumb_harness import CODE_BASE, Harness
        except ImportError as exc:
            raise unittest.SkipTest(f"thumb harness unavailable: {exc}")

        rom = _rom()
        blob, offsets = _locate_blob(rom)
        code = bytearray(rom[blob:offsets["blob_end"]])

        table = offsets["SkillActivationFlagTable"]
        scope = offsets["SkillActivationFlagScope"]

        # The C build calls GetUnit through a normal long-call thunk (bl to a
        # `bx r5`), which Unicorn decodes fine -- so unlike the old hand-written
        # assembly there is no `.short 0xf800` to rewrite. Only the destination
        # needs redirecting: point the GetUnit literal at a stub that indexes a
        # stand-in unit array, and let the real call sequence run.
        pool = code.find(GET_UNIT_LITERAL)
        self.assertNotEqual(pool, -1, "GetUnit literal missing from the ROM blob")
        code[pool:pool + 4] = struct.pack("<I", GET_UNIT_STUB | 1)

        h = Harness(bytes(code))

        # GetUnit stand-in, reached through the routine's own real call thunk:
        #   lsls r0, r0, #2 ; ldr r1, [pc, #4] ; ldr r0, [r1, r0] ; bx lr
        # The literal must sit at offset 8: a Thumb PC-relative load rounds PC
        # down to a word boundary, so `[pc, #4]` at offset 2 reads offset 8.
        h.seed(GET_UNIT_STUB,
               bytes.fromhex("8000014908587047") + struct.pack("<I", UNIT_LOOKUP))

        # Seed the ROM's own table addresses, so the routine reads through the
        # pointers the build actually installed.
        h.seed(table, b"\x00" * 256)
        h.seed(scope, bytes(1 if i in per_map_bits else 0 for i in range(16)))
        h.seed(UNIT_LOOKUP, b"\x00" * (0x100 * 4))
        unit = UNIT_BASE + UNIT_STRIDE
        h.seed(UNIT_LOOKUP + 4, struct.pack("<I", unit))
        h.seed(unit, struct.pack("<I", 0x08000000))  # pCharacterData, non-null
        h.seed(unit + ACT_FLAGS, struct.pack("<H", initial_flags))

        stop = len(code)
        out = h.run(stop,
                    regs={"lr": (CODE_BASE + stop) | 1},
                    entry_offset=offsets["ResetTurnActivationFlags"])
        return out, struct.unpack("<H", h.read(unit + ACT_FLAGS, 2))[0]

    def test_rom_routine_clears_per_turn_and_keeps_per_map(self):
        out, flags = self._run(0xFFFF)
        self.assertEqual(out["r0"], 0, "proc routine must report no blocking work")
        self.assertEqual(flags, 1 << PER_MAP_BIT)

    def test_rom_routine_clears_everything_when_no_bit_is_per_map(self):
        _out, flags = self._run(0xFFFF, per_map_bits=())
        self.assertEqual(flags, 0x0000)

    def test_rom_routine_leaves_a_clean_unit_clean(self):
        _out, flags = self._run(0x0000)
        self.assertEqual(flags, 0x0000)

    def test_rom_routine_clears_a_single_per_turn_bit(self):
        _out, flags = self._run(1 << PER_TURN_BIT)
        self.assertEqual(flags, 0x0000)


if __name__ == "__main__":
    unittest.main()
