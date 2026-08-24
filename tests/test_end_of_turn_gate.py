"""Executes the end-of-turn gate helper under a real Thumb CPU emulator, with
units in the state they are actually in when the gate runs: already acted.

TurnLoopMaster used to gate the whole end-of-turn skill table on
GetPhaseAbleUnitCount (0x8023810), which masks unit->state with 0x000100AE --
and 0x02 in that mask is "has moved/acted". End of turn runs *after* every unit
of the allegiance has acted, so the count was always 0 and the loop took
`beq SkipEndOfTurn` before ever consulting EndOfTurn_HealSkillTable. Every
end-of-turn skill (Hoarder's Bane, Soul Sap, Dark Bargain) was silently dead:
each individual routine tested correct in isolation, because the defect was the
gate above them, not the skills.

The gate now asks CountUnitsOnField instead. The assertion that matters is the
one no per-skill test could make: units that have already acted must still be
counted, or the table stays unreachable.

GetUnit is hooked and IsUnitOnField is stubbed, so this tests the helper's
own loop arithmetic and its indifference to the "acted" bit, not the vanilla
routines it calls.
"""
import struct
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

SRC = ROOT / "EngineHacks/Necessary/CalcLoops/TurnLoop/StartOfTurn_CalcLoop.s"

UNIT_STATE = 0x0C
STATE_ACTED = 0x02      # the bit GetPhaseAbleUnitCount masks out
STATE_HIDDEN = 0x01
UNITS = 0x02020000
UNIT_SIZE = 0x48


def _assemble_and_link(src, tmpdir):
    """Assemble + link + objcopy; returns (bytes, {label: offset}).

    Linking is what distinguishes this from thumb_harness.assemble(): the probe
    calls stubs by label, and those relocations only get applied by ld.
    """
    import subprocess
    from Tools.thumb_harness import AS, OBJCOPY, NM, CODE_BASE

    LD = Path(AS).with_name("arm-none-eabi-ld.exe")
    if not LD.exists():
        raise unittest.SkipTest("arm-none-eabi-ld not installed")
    obj = tmpdir / "probe.o"
    elf = tmpdir / "probe.elf"
    binf = tmpdir / "probe.bin"
    subprocess.run([str(AS), "-mcpu=arm7tdmi", "-mthumb", "-mthumb-interwork",
                    f"-I{src.parent}", str(src), "-o", str(obj)],
                   check=True, capture_output=True, text=True)
    subprocess.run([str(LD), "-Ttext", hex(CODE_BASE), "--oformat", "elf32-littlearm",
                    str(obj), "-o", str(elf)],
                   check=True, capture_output=True, text=True)
    subprocess.run([str(OBJCOPY), "-O", "binary", str(elf), str(binf)],
                   check=True, capture_output=True, text=True)
    out = subprocess.run([str(NM), str(elf)], check=True,
                         capture_output=True, text=True).stdout
    offsets = {}
    for line in out.splitlines():
        parts = line.split()
        if len(parts) == 3:
            offsets[parts[2]] = int(parts[0], 16) - CODE_BASE
    return binf.read_bytes(), offsets


def _require():
    try:
        import unicorn  # noqa: F401
    except ImportError as exc:
        raise unittest.SkipTest(f"unicorn unavailable: {exc}")
    from Tools.thumb_harness import AS
    if not Path(AS).exists():
        raise unittest.SkipTest("devkitARM not installed")


class EndOfTurnGate(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        _require()
        if not SRC.exists():
            raise unittest.SkipTest(f"missing {SRC}")
        import re
        import tempfile
        from Tools.thumb_harness import assemble, symbol_offsets

        src = SRC.read_bytes()
        # CountUnitsOnField is file-local; export it. IsUnitOnField is an
        # unresolved extern here, so give it a stub that reports "on field"
        # for any non-null unit -- the helper's own logic is what's under test.
        src = re.sub(rb"(?m)^CountUnitsOnField:",
                     b".global CountUnitsOnField\nCountUnitsOnField:", src, count=1)
        # The project's `blh` macro ends in a bare `.short 0xf800`, which Unicorn
        # refuses to decode. Redefine it as a plain `bl` for the probe, so the
        # helper's call to GetUnit lands on the stub below as a normal branch.
        # NB: the parameter must not be named `to` -- `as` expands `\t` inside
        # `\to` to a tab, leaving the operand as the bare symbol `o`.
        src = re.sub(rb"(?s)\.macro blh.*?\.endm",
                     lambda _m: b".macro blh dest, reg=r3\n  bl \\dest\n.endm",
                     src, count=1)
        # `.equ GetUnit, 0x8018d0c` would collide with the stub label below, and
        # an absolute address is not `bl`-reachable from the probe anyway.
        src = re.sub(rb"(?m)^\.equ GetUnit,.*$", b"", src, count=1)
        # GetUnit(index) -> unit pointer, read from a caller-seeded table.
        src += (b"\n.global IsUnitOnField\n.type IsUnitOnField, %function\n"
                b"IsUnitOnField:\ncmp r0, #0\nbeq _iuof_no\nmov r0, #1\nbx lr\n"
                b"_iuof_no:\nmov r0, #0\nbx lr\n.ltorg\n"
                b"\n.global GetUnit\n.type GetUnit, %function\n"
                b"GetUnit:\nldr r1, =0x02030000\nlsl r0, #2\n"
                b"ldr r0, [r1, r0]\nbx lr\n.ltorg\n"
                # The rest of the file references symbols supplied by the
                # Event Assembler at install time. Only CountUnitsOnField is
                # executed here, but the link still has to resolve them.
                b"\nMakeSkillBuffer:\nbx lr\n"
                b"EndOfTurnCalcLoop:\nStartOfTurnCalcLoop:\n"
                b"TurnCalcLoop_Proc:\nTurnCalcLoop_Silent:\n"
                b"BuffAnimationSkillProc:\nFindMapAuraProc:\n"
                b"StartOfTurn_BuffSkillTable:\n"
                b".word 0, 0, 0, 0\n")
        cls._tmp = tempfile.TemporaryDirectory()
        probe = Path(cls._tmp.name) / "calcloop_probe.s"
        probe.write_bytes(src)
        # thumb_harness.assemble() stops at objcopy on an unlinked object, so
        # `bl <label>` stays an unapplied relocation (F7FF FFFE, a branch to
        # itself). Link first so the calls to the stubs actually resolve.
        cls.code, cls.offsets = _assemble_and_link(probe, Path(cls._tmp.name))
        if "CountUnitsOnField" not in cls.offsets:
            raise unittest.SkipTest("CountUnitsOnField not present in source")

    @classmethod
    def tearDownClass(cls):
        if hasattr(cls, "_tmp"):
            cls._tmp.cleanup()

    def count(self, states, first=1, stop=0x40):
        """Run CountUnitsOnField over [first, stop) with `states` keyed by index."""
        from unicorn import Uc, UC_ARCH_ARM, UC_MODE_THUMB
        from unicorn.arm_const import (UC_ARM_REG_R0, UC_ARM_REG_R1,
                                       UC_ARM_REG_LR, UC_ARM_REG_SP)
        from Tools.thumb_harness import CODE_BASE

        UNIT_TABLE = 0x02030000  # matches the GetUnit stub

        code = self.code
        uc = Uc(UC_ARCH_ARM, UC_MODE_THUMB)
        uc.mem_map(CODE_BASE, ((len(code) + 0xFFF) & ~0xFFF) or 0x1000)
        uc.mem_write(CODE_BASE, code)
        uc.mem_map(0x02000000, 0x40000)
        uc.mem_map(0x03000000, 0x8000)
        uc.reg_write(UC_ARM_REG_SP, 0x03007F00)

        # Unit structs, plus the index -> pointer table the GetUnit stub reads.
        table = bytearray(4 * 0x100)
        for idx, state in states.items():
            addr = UNITS + idx * UNIT_SIZE
            u = bytearray(UNIT_SIZE)
            u[0x0B] = idx
            struct.pack_into("<I", u, UNIT_STATE, state)
            uc.mem_write(addr, bytes(u))
            struct.pack_into("<I", table, 4 * idx, addr)
        uc.mem_write(UNIT_TABLE, bytes(table))

        ret = CODE_BASE + len(code) + 0x100
        uc.reg_write(UC_ARM_REG_LR, ret | 1)
        uc.reg_write(UC_ARM_REG_R0, first)
        uc.reg_write(UC_ARM_REG_R1, stop)
        uc.emu_start(CODE_BASE + self.offsets["CountUnitsOnField"] | 1, ret,
                     timeout=1_000_000)
        return uc.reg_read(UC_ARM_REG_R0)

    def test_counts_units_that_have_already_acted(self):
        """The regression: end of turn runs when everyone has acted."""
        self.assertEqual(self.count({1: STATE_ACTED, 2: STATE_ACTED, 3: STATE_ACTED}), 3)

    def test_acted_and_fresh_units_count_the_same(self):
        acted = self.count({1: STATE_ACTED, 2: STATE_ACTED})
        fresh = self.count({1: 0x0000, 2: 0x0000})
        self.assertEqual(acted, fresh)
        self.assertEqual(acted, 2)

    def test_no_units_reports_zero(self):
        """Other side of the branch: an empty phase must still short-circuit."""
        self.assertEqual(self.count({}), 0)

    def test_counts_only_within_the_deployment_range(self):
        """Units outside [first, stop) must not be counted."""
        states = {1: STATE_ACTED, 2: STATE_ACTED, 0x41: STATE_ACTED}
        self.assertEqual(self.count(states, first=1, stop=0x40), 2)

    def test_single_unit_is_enough_to_open_the_gate(self):
        self.assertEqual(self.count({7: STATE_ACTED}), 1)


if __name__ == "__main__":
    unittest.main()
