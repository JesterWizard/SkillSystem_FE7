"""Executes SkillActivationFlags.s (DEC-85) on a Thumb CPU emulator.

The sixteen per-unit "this skill already fired" bits live in unit+0x3A/0x3B.
Every routine here either indexes a table or branches on a bit, which is
exactly the class of code a source read cannot verify -- so each branch is
executed and the resulting halfword (or returned register) is asserted.
"""
import re
import struct
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

FLAGS_DIR = ROOT / "EngineHacks/SkillSystem/Internals/SkillActivationFlags"
SRC = FLAGS_DIR / "SkillActivationFlags.c"
LYN = FLAGS_DIR / "SkillActivationFlags.lyn.event"

HOOK_SRC = ROOT / "EngineHacks/SkillSystem/Internals/asm/HookUnitLoading.s"
HOOK_LYN = ROOT / "EngineHacks/SkillSystem/Internals/asm/HookUnitLoading.lyn.event"

sys.path.insert(0, str(Path(__file__).resolve().parent))
from lyn_bytes import lyn_to_bytes  # noqa: E402

try:
    from Tools.thumb_harness import CODE_BASE, Harness, symbol_offsets
except ImportError as exc:  # unicorn not installed locally
    raise unittest.SkipTest(f"thumb harness unavailable: {exc}")

FLAG_TABLE = 0x02100000  # skillID -> bit + 1
FLAG_SCOPE = 0x02110000  # bit -> 1 when once-per-map
UNIT_LOOKUP = 0x02120000  # stand-in for the FE7 unit-pointer array GetUnit reads
UNIT_BASE = 0x02130000
UNIT_STRIDE = 0x100
ACT_FLAGS = 0x3A

GET_UNIT_LITERAL = struct.pack("<I", 0x08018D0D)  # thumb bit set by the C build
GET_UNIT_STUB = 0x02140000

# lsls r0,r0,#2 ; ldr r1,[pc,#4] ; ldr r0,[r1,r0] ; bx lr ; .word UNIT_LOOKUP
# The literal must land at offset 8: a Thumb PC-relative load rounds PC down to
# a word boundary, so `[pc, #4]` at offset 2 reads offset 8.
GET_UNIT_STUB_CODE = bytes.fromhex("8000014908587047") + struct.pack("<I", UNIT_LOOKUP)
TRAMPOLINE_TAIL = b"\x00\xf8"

# skillID -> (bit, scope) used by every test in this file
SKILL_BITS = {
    7: (3, "turn"),   # once per turn, inside the 0x3A byte
    9: (0, "map"),    # once per map, lowest bit
    11: (15, "map"),  # once per map, top bit -- lands in the 0x3B byte
    12: (8, "turn"),  # once per turn, lowest bit of the 0x3B byte
}
PER_MAP_MASK = (1 << 0) | (1 << 15)


def _rom_blob():
    """The activation-flag routines as they sit in the built FE7_Hack.gba.

    The routines are compiled from C now, so there is no .s whose label offsets
    could be read and no EALiterals block at the end -- gcc scatters literal
    pools through the code. Both the code bounds and the entry points come from
    FE7_Hack.sym instead, and the bytes executed are the ones EA actually wrote.
    """
    sys.path.insert(0, str(Path(__file__).resolve().parent))
    import built_rom

    rom = built_rom.load()
    sym = built_rom.symbols()
    needed = ("SkillActivationFlagRoutines", "SkillActivationFlagTurnResetProc",
              "SkillActivationFlagTable", "SkillActivationFlagScope")
    for name in needed:
        if name not in sym:
            raise unittest.SkipTest(f"{name} missing from FE7_Hack.sym")

    base = sym["SkillActivationFlagRoutines"] & ~1
    start = built_rom.offset(rom, base)
    end = built_rom.offset(rom, sym["SkillActivationFlagTurnResetProc"] & ~1)

    code = bytearray(rom[start:end])

    # Redirect GetUnit at the literal; the real call thunk still runs.
    pool = code.find(GET_UNIT_LITERAL)
    if pool == -1:
        raise unittest.SkipTest("GetUnit literal not found in the ROM blob")
    code[pool:pool + 4] = struct.pack("<I", GET_UNIT_STUB | 1)

    offsets = {n: (sym[n] & ~1) - base
               for n in ("GetSkillActivationBit", "GetPerMapActivationFlagMask",
                         "IsSkillActivationFlagSet", "CanSkillActivationFlagProc",
                         "SetSkillActivationFlag", "ClearSkillActivationFlag",
                         "ClearUnitActivationFlags", "ClearUnitTurnActivationFlags",
                         "ResetTurnActivationFlags")
               if n in sym}
    return bytes(code), offsets, sym["SkillActivationFlagTable"], sym["SkillActivationFlagScope"]


def _linked_code():
    """The linked bytes EA writes into the ROM.

    Not the raw `as` output: internal `bl`s to .global symbols stay unresolved
    in the object file, so only lyn output actually branches anywhere.
    """
    if not LYN.is_file():
        raise unittest.SkipTest(f"{LYN.name} not built; run Tools/build_skill_asm.py")
    return lyn_to_bytes(LYN)


def _harness(skill_bits, units):
    """Load the ROM's own routine bytes, seed the ROM's tables and the units."""
    code, offsets, table, scope = _rom_blob()
    h = Harness(code)

    h.seed(GET_UNIT_STUB, GET_UNIT_STUB_CODE)

    # Seed the addresses the build actually baked into the literal pools.
    h.seed(table, bytes(256))
    h.seed(scope, bytes(16))
    for skill, (bit, scope_kind) in skill_bits.items():
        h.seed(table + skill, bytes([bit + 1]))
        if scope_kind == "map":
            h.seed(scope + bit, bytes([1]))

    h.seed(UNIT_LOOKUP, bytes(0x100 * 4))
    for dep_id, flags in units.items():
        unit = UNIT_BASE + dep_id * UNIT_STRIDE
        h.seed(UNIT_LOOKUP + dep_id * 4, struct.pack("<I", unit))
        h.seed(unit, struct.pack("<I", 0x08000000))  # pCharacterData, non-null
        h.seed(unit + ACT_FLAGS, struct.pack("<H", flags))
    offsets = dict(offsets, _end=len(code))
    return h, offsets


def _build(units=None):
    return _harness(SKILL_BITS, units or {})


def _call(h, offsets, name, **regs):
    if name not in offsets:
        raise unittest.SkipTest(f"{name} missing from FE7_Hack.sym")
    stop = offsets["_end"]  # past the last routine; reached only by the final bx
    regs["lr"] = (CODE_BASE + stop) | 1
    return h.run(stop, regs=regs, entry_offset=offsets[name])


def _unit_flags(h, dep_id):
    addr = UNIT_BASE + dep_id * UNIT_STRIDE + ACT_FLAGS
    return struct.unpack("<H", h.read(addr, 2))[0]


class ActivationBitLookupTests(unittest.TestCase):
    def test_registered_skill_returns_its_bit(self):
        h, off = _build()
        for skill, (bit, _scope) in SKILL_BITS.items():
            with self.subTest(skill=skill):
                out = _call(h, off, "GetSkillActivationBit", r0=skill)
                self.assertEqual(out["r0"], bit)

    def test_unregistered_skill_returns_minus_one(self):
        h, off = _build()
        out = _call(h, off, "GetSkillActivationBit", r0=8)
        self.assertEqual(out["r0"] & 0xFFFFFFFF, 0xFFFFFFFF)

    def test_skill_id_zero_is_unregistered(self):
        h, off = _build()
        out = _call(h, off, "GetSkillActivationBit", r0=0)
        self.assertEqual(out["r0"] & 0xFFFFFFFF, 0xFFFFFFFF)


class SetAndQueryTests(unittest.TestCase):
    def test_set_then_query_reports_fired(self):
        h, off = _build(units={1: 0x0000})
        unit = UNIT_BASE + UNIT_STRIDE
        _call(h, off, "SetSkillActivationFlag", r0=unit, r1=7)
        self.assertEqual(_unit_flags(h, 1), 1 << 3)
        out = _call(h, off, "IsSkillActivationFlagSet", r0=unit, r1=7)
        self.assertEqual(out["r0"], 1)
        out = _call(h, off, "CanSkillActivationFlagProc", r0=unit, r1=7)
        self.assertEqual(out["r0"], 0, "a set flag must block the skill from proccing")

    def test_unset_flag_allows_proc(self):
        h, off = _build(units={1: 0x0000})
        unit = UNIT_BASE + UNIT_STRIDE
        out = _call(h, off, "IsSkillActivationFlagSet", r0=unit, r1=7)
        self.assertEqual(out["r0"], 0)
        out = _call(h, off, "CanSkillActivationFlagProc", r0=unit, r1=7)
        self.assertEqual(out["r0"], 1)

    def test_top_bit_lands_in_byte_0x3b(self):
        h, off = _build(units={1: 0x0000})
        unit = UNIT_BASE + UNIT_STRIDE
        _call(h, off, "SetSkillActivationFlag", r0=unit, r1=11)  # bit 15
        self.assertEqual(h.read(unit + 0x3A, 1), b"\x00")
        self.assertEqual(h.read(unit + 0x3B, 1), b"\x80")

    def test_set_does_not_disturb_other_bits(self):
        h, off = _build(units={1: 0b0000_0000_0100_0001})
        unit = UNIT_BASE + UNIT_STRIDE
        _call(h, off, "SetSkillActivationFlag", r0=unit, r1=7)  # bit 3
        self.assertEqual(_unit_flags(h, 1), 0b0000_0000_0100_1001)

    def test_clear_only_drops_its_own_bit(self):
        h, off = _build(units={1: 0xFFFF})
        unit = UNIT_BASE + UNIT_STRIDE
        _call(h, off, "ClearSkillActivationFlag", r0=unit, r1=7)  # bit 3
        self.assertEqual(_unit_flags(h, 1), 0xFFF7)
        out = _call(h, off, "CanSkillActivationFlagProc", r0=unit, r1=7)
        self.assertEqual(out["r0"], 1)

    def test_unregistered_skill_never_blocked_and_never_written(self):
        h, off = _build(units={1: 0x0000})
        unit = UNIT_BASE + UNIT_STRIDE
        out = _call(h, off, "SetSkillActivationFlag", r0=unit, r1=8)
        self.assertEqual(out["r0"], unit)
        self.assertEqual(_unit_flags(h, 1), 0x0000, "an unmapped skill must not touch the flags")
        out = _call(h, off, "CanSkillActivationFlagProc", r0=unit, r1=8)
        self.assertEqual(out["r0"], 1)


class ScopeMaskTests(unittest.TestCase):
    def test_mask_holds_exactly_the_once_per_map_bits(self):
        h, off = _build()
        out = _call(h, off, "GetPerMapActivationFlagMask")
        self.assertEqual(out["r0"], PER_MAP_MASK)

    def test_mask_is_zero_when_no_bit_is_once_per_map(self):
        h, off = _harness({7: (3, "turn")}, {})
        out = _call(h, off, "GetPerMapActivationFlagMask")
        self.assertEqual(out["r0"], 0)


class UnitResetTests(unittest.TestCase):
    def test_clear_all_wipes_both_bytes(self):
        h, off = _build(units={1: 0xFFFF})
        _call(h, off, "ClearUnitActivationFlags", r0=UNIT_BASE + UNIT_STRIDE)
        self.assertEqual(_unit_flags(h, 1), 0x0000)

    def test_turn_clear_keeps_once_per_map_bits(self):
        h, off = _build(units={1: 0xFFFF})
        _call(h, off, "ClearUnitTurnActivationFlags", r0=UNIT_BASE + UNIT_STRIDE)
        self.assertEqual(_unit_flags(h, 1), PER_MAP_MASK)

    def test_turn_clear_leaves_already_clear_flags_alone(self):
        h, off = _build(units={1: 0x0000})
        _call(h, off, "ClearUnitTurnActivationFlags", r0=UNIT_BASE + UNIT_STRIDE)
        self.assertEqual(_unit_flags(h, 1), 0x0000)


class PhaseResetLoopTests(unittest.TestCase):
    """ResetTurnActivationFlags runs from the top of gProcScr_PlayerPhase."""

    def test_clears_turn_bits_on_every_faction(self):
        units = {1: 0xFFFF, 0x3F: 0xFFFF, 0x41: 0xFFFF, 0x81: 0xFFFF, 0xBF: 0xFFFF}
        h, off = _build(units=units)
        out = _call(h, off, "ResetTurnActivationFlags")
        self.assertEqual(out["r0"], 0, "proc routine must report no blocking work")
        for dep_id in units:
            with self.subTest(dep_id=dep_id):
                self.assertEqual(_unit_flags(h, dep_id), PER_MAP_MASK)

    def test_leaves_a_unit_with_no_flags_untouched(self):
        h, off = _build(units={1: 0x0000})
        _call(h, off, "ResetTurnActivationFlags")
        self.assertEqual(_unit_flags(h, 1), 0x0000)

    def test_skips_units_without_character_data(self):
        h, off = _build(units={1: 0xFFFF})
        ghost = UNIT_BASE + 2 * UNIT_STRIDE  # in the lookup, but pCharacterData is NULL
        h.seed(UNIT_LOOKUP + 2 * 4, struct.pack("<I", ghost))
        h.seed(ghost, struct.pack("<I", 0))
        h.seed(ghost + ACT_FLAGS, struct.pack("<H", 0xFFFF))
        _call(h, off, "ResetTurnActivationFlags")
        self.assertEqual(_unit_flags(h, 1), PER_MAP_MASK)
        self.assertEqual(_unit_flags(h, 2), 0xFFFF, "a unit with no character data must be skipped")

    def test_deployment_id_zero_is_never_visited(self):
        h, off = _build(units={0: 0xFFFF, 1: 0xFFFF})
        _call(h, off, "ResetTurnActivationFlags")
        self.assertEqual(_unit_flags(h, 0), 0xFFFF, "slot 0 is not a unit")
        self.assertEqual(_unit_flags(h, 1), PER_MAP_MASK)

    def test_all_bits_cleared_when_nothing_is_once_per_map(self):
        h, off = _harness({7: (3, "turn")}, {1: 0xFFFF})
        _call(h, off, "ResetTurnActivationFlags")
        self.assertEqual(_unit_flags(h, 1), 0x0000)


class UnitLoadResetTests(unittest.TestCase):
    """HookUnitLoading is the once-per-map reset: a unit loaded for a chapter
    must owe nothing, so both activation bytes are dropped."""

    UNIT = 0x02140000
    NEW_UNIT_COUNT = 0x0202BBE6  # halfword the hook also zeroes

    def _run_hook(self, initial_flags):
        if not HOOK_LYN.is_file():
            raise unittest.SkipTest("HookUnitLoading.lyn.event not built")
        code = bytearray(lyn_to_bytes(HOOK_LYN))
        offsets = symbol_offsets(HOOK_SRC)
        end = offsets["EALiterals"]
        self.assertEqual(end, len(code), "EALiterals must sit at the end of .text")

        # The hook tail-calls AutoloadSkills and InitBwlSupportsForUnit through
        # two EA-appended pointers. Neither is modelled here, so both are aimed
        # at a `bx lr` stub parked just past the literals.
        stub = end + 8
        code += struct.pack("<II", (CODE_BASE + stub) | 1, (CODE_BASE + stub) | 1)
        code += struct.pack("<H", 0x4770)  # bx lr
        stop = stub + 4

        h = Harness(bytes(code))
        h.seed(self.NEW_UNIT_COUNT, bytes([0xFF, 0xFF]))
        h.seed(self.UNIT, bytes(0x48))
        h.seed(self.UNIT + ACT_FLAGS, struct.pack("<H", initial_flags))
        h.run(stop, regs={"r0": self.UNIT, "lr": (CODE_BASE + stop) | 1})
        return struct.unpack("<H", h.read(self.UNIT + ACT_FLAGS, 2))[0]

    def test_loading_a_unit_drops_every_activation_flag(self):
        self.assertEqual(self._run_hook(0xFFFF), 0x0000)

    def test_loading_a_unit_with_no_flags_stays_clear(self):
        self.assertEqual(self._run_hook(0x0000), 0x0000)

    def test_once_per_map_bits_are_dropped_too(self):
        self.assertEqual(self._run_hook(PER_MAP_MASK), 0x0000)


class FlagAssignmentTableTests(unittest.TestCase):
    """The comment table in flag_assignments.event is the thing a human reads
    when deciding which bit to take next, so it must match the macro calls
    underneath it -- including the resolved skill ID."""

    ASSIGNMENTS = ROOT / "EngineHacks/SkillSystem/Internals/SkillActivationFlags/flag_assignments.event"
    DEFS = ROOT / "EngineHacks/SkillSystem/skill_definitions.event"
    BIT_COUNT = 16

    @staticmethod
    def _skill_ids():
        ids = {}
        for line in FlagAssignmentTableTests.DEFS.read_text(encoding="utf-8").splitlines():
            body = line.split("//")[0].strip()
            m = re.match(r"#define\s+(\w+ID)\s+(\d+|SKILL_OFF)\s*$", body)
            if m:
                ids[m.group(1)] = 255 if m.group(2) == "SKILL_OFF" else int(m.group(2))
        return ids

    def _macro_calls(self):
        """bit -> (skill name, scope) from the live ActivationFlag* lines."""
        out = {}
        for line in self.ASSIGNMENTS.read_text(encoding="utf-8").splitlines():
            body = line.split("//")[0].strip()
            m = re.match(r"ActivationFlagOncePer(Turn|Map)\(\s*(\w+)\s*,\s*(\d+)\s*\)", body)
            if m:
                scope = "once per turn" if m.group(1) == "Turn" else "once per map"
                bit = int(m.group(3))
                self.assertNotIn(bit, out, f"bit {bit} is claimed twice")
                out[bit] = (m.group(2), scope)
        return out

    def _table_rows(self):
        """bit -> (skill label, id text, scope text) from the comment table."""
        rows = {}
        for line in self.ASSIGNMENTS.read_text(encoding="utf-8").splitlines():
            m = re.match(r"//\s*(\d+)\s*\|\s*([^|]+?)\s*\|\s*([^|]+?)\s*\|\s*(.*?)\s*$", line)
            if m:
                rows[int(m.group(1))] = (m.group(2), m.group(3), m.group(4))
        return rows

    def test_table_lists_every_bit_once(self):
        rows = self._table_rows()
        self.assertEqual(sorted(rows), list(range(self.BIT_COUNT)),
                         "the comment table must list bits 0..15 exactly once each")

    def test_every_assigned_bit_matches_its_table_row(self):
        ids = self._skill_ids()
        rows = self._table_rows()
        for bit, (name, scope) in self._macro_calls().items():
            with self.subTest(bit=bit):
                self.assertIn(bit, rows, f"bit {bit} is assigned but missing from the table")
                label, id_text, scope_text = rows[bit]
                self.assertIn(name.removesuffix("ID").lower(), label.lower().replace(" ", ""),
                              f"bit {bit} row says {label!r}, macro assigns {name}")
                self.assertEqual(id_text, str(ids[name]),
                                 f"bit {bit} row says ID {id_text}, {name} resolves to {ids[name]}")
                self.assertEqual(scope_text, scope)

    def test_free_rows_have_no_macro(self):
        assigned = set(self._macro_calls())
        for bit, (label, id_text, scope_text) in self._table_rows().items():
            if bit in assigned:
                continue
            with self.subTest(bit=bit):
                self.assertEqual(label, "(free)", f"bit {bit} has no macro but is not marked free")
                self.assertEqual(id_text, "-")
                self.assertEqual(scope_text, "")

    def test_assigned_skills_are_enabled(self):
        ids = self._skill_ids()
        for bit, (name, _scope) in self._macro_calls().items():
            with self.subTest(bit=bit, skill=name):
                self.assertIn(name, ids, f"{name} is not defined in skill_definitions.event")
                self.assertNotEqual(
                    ids[name], 255,
                    f"{name} is SKILL_OFF but still holds bit {bit}; free the bit or enable the skill",
                )


if __name__ == "__main__":
    unittest.main()
