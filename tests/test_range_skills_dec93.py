"""DEC-93: BowRange, PointBlank, StaffSavant, TomeRange."""
import re
import struct
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

DEFS = ROOT / "EngineHacks" / "SkillSystem" / "skill_definitions.event"
MASTER = ROOT / "EngineHacks" / "SkillSystem" / "Skills" / "MasterSkillInstaller.event"
CALCS = ROOT / "EngineHacks" / "Necessary" / "CalcLoops" / "CalcLoops.event"
RANGE_EVENT = (
    ROOT
    / "EngineHacks"
    / "Necessary"
    / "CalcLoops"
    / "RangeCalcLoop"
    / "RangeCalcLoop.event"
)
SKILLS = ROOT / "EngineHacks" / "SkillSystem" / "Skills" / "RangeSkills"
HACK = ROOT / "FE7_Hack.gba"

BOWRANGE_ID, TOMERANGE_ID, STAFFSAVANT_ID, POINTBLANK_ID = 136, 135, 134, 137
GET_WTYPE = 0x0801725C
GET_MIN, GET_MAX, GET_REACH = 0x1736C, 0x17384, 0x16EBC
GET_COVER, GET_STAFF, GET_STAFF_ALL, GET_MAG2 = 0x167C8, 0x16F10, 0x16FCC, 0x184B4
GET_HEAL_FILL = 0x23A74
JUMP = bytes.fromhex("004b1847")
WTYPE_BOW, WTYPE_STAFF, WTYPE_SWORD = 3, 4, 0
WTYPE_ANIMA, WTYPE_LIGHT, WTYPE_DARK = 5, 6, 7
PACKED = lambda mn, mx: (mn << 16) | (mx & 0xFFFF)


def _active(path: Path) -> str:
    return "\n".join(
        line
        for line in path.read_text(encoding="utf-8").splitlines()
        if not line.lstrip().startswith("//")
    )


def _run_skill(src: Path, wtype: int, min_r: int, max_r: int) -> int:
    from Tools.thumb_harness import CODE_BASE, Harness, assemble, symbol_offsets

    raw = bytearray(assemble(src))
    call = raw.find(b"\x00\xf8")
    raw[call - 2 : call] = (0x46C0).to_bytes(2, "little")
    raw[call : call + 2] = (0x4718).to_bytes(2, "little")
    lit = raw.find(GET_WTYPE.to_bytes(4, "little"))
    raw[lit : lit + 4] = (GET_WTYPE | 1).to_bytes(4, "little")
    off = symbol_offsets(src)
    ret = (CODE_BASE + call + 2) | 1
    h = Harness(bytes(raw), skill_present=False)
    h.seed(
        GET_WTYPE,
        struct.pack("<HHHH I", 0x2000 | wtype, 0x4B01, 0x4718, 0x46C0, ret),
    )
    stop = off["End"] + 6
    return h.run(
        stop, regs={"r0": 0x02000000, "r1": 0x0033, "r2": PACKED(min_r, max_r)}
    )["r0"]


class RangeSourceTests(unittest.TestCase):
    def test_ids_are_enabled(self):
        text = DEFS.read_text(encoding="utf-8")
        for name, sid in (
            ("BowRangeUpID", BOWRANGE_ID),
            ("TomeRangeUpID", TOMERANGE_ID),
            ("StaffSavantID", STAFFSAVANT_ID),
            ("PointBlankID", POINTBLANK_ID),
        ):
            m = re.search(rf"^#define\s+{name}\s+(\S+)", text, re.M)
            self.assertIsNotNone(m, name)
            self.assertEqual(int(m.group(1)), sid, name)

    def test_range_skills_are_installed(self):
        self.assertIn("RangeSkills/RangeSkills.event", _active(MASTER))
        self.assertIn("RangeCalcLoop/RangeCalcLoop.event", _active(CALCS))
        hooks = _active(RANGE_EVENT)
        self.assertIn("GetItemMinRangeHook", hooks)
        self.assertIn("GetItemMaxRangeHook", hooks)
        self.assertIn("GetUnitItemReachBits", hooks)
        self.assertIn("$1736C", hooks)
        self.assertIn("$17384", hooks)
        self.assertIn("$16EBC", hooks)
        self.assertIn("$167C8", hooks)
        self.assertIn("$16F10", hooks)
        self.assertIn("$16FCC", hooks)
        self.assertIn("GetUnitStaffReachBitsAll", hooks)
        self.assertIn("$184B4", hooks)
        self.assertIn("IsItemCoveringRangeHook", hooks)
        self.assertIn("GetUnitStaffReachBits", hooks)
        self.assertIn("MagOn2Hook", hooks)
        self.assertIn("$23A74", hooks)
        self.assertIn("StaffRange1FillHook", hooks)
        skills = (SKILLS / "RangeSkills.event").read_text(encoding="utf-8")
        self.assertIn("0x08016381", skills)
        self.assertNotIn("0x080161A5", skills)


class WeaponReachMaskExecutionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        try:
            from Tools.thumb_harness import assemble  # noqa: F401
        except ImportError as exc:
            raise unittest.SkipTest(f"thumb harness unavailable: {exc}")
        cls.src = SKILLS / "GetUnitItemReachBits.s"

    def _mask(self, min_r: int, max_r: int) -> int:
        from Tools.thumb_harness import Harness, assemble, symbol_offsets

        off = symbol_offsets(self.src)
        h = Harness(assemble(self.src), skill_present=False)
        return h.run(
            off["PackedMaskDone"],
            regs={"r0": PACKED(min_r, max_r)},
            entry_offset=off["PackedToMask"],
        )["r0"]

    def test_one_range_is_reach1_not_reach2(self):
        self.assertEqual(self._mask(1, 1), 1)

    def test_bow_two_three(self):
        self.assertEqual(self._mask(2, 3), 6)

    def test_pointblank_bow_one_to_three(self):
        self.assertEqual(self._mask(1, 3), 7)

    def test_bowrange_past_three_stays_legal(self):
        self.assertEqual(self._mask(1, 4), 7)
        self.assertEqual(self._mask(2, 4), 6)


class BowRangeExecutionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        try:
            from Tools.thumb_harness import assemble  # noqa: F401
        except ImportError as exc:
            raise unittest.SkipTest(f"thumb harness unavailable: {exc}")
        cls.src = SKILLS / "BowRange" / "BowRange.s"

    def test_bow_max_increases_by_one(self):
        self.assertEqual(_run_skill(self.src, WTYPE_BOW, 2, 3), PACKED(2, 4))

    def test_non_bow_unchanged(self):
        self.assertEqual(_run_skill(self.src, WTYPE_SWORD, 1, 1), PACKED(1, 1))

    def test_max_caps_at_fifteen(self):
        self.assertEqual(_run_skill(self.src, WTYPE_BOW, 2, 15), PACKED(2, 15))


class PointBlankExecutionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        try:
            from Tools.thumb_harness import assemble  # noqa: F401
        except ImportError as exc:
            raise unittest.SkipTest(f"thumb harness unavailable: {exc}")
        cls.src = SKILLS / "PointBlank" / "PointBlank.s"

    def test_bow_min_becomes_one(self):
        self.assertEqual(_run_skill(self.src, WTYPE_BOW, 2, 3), PACKED(1, 3))

    def test_non_bow_unchanged(self):
        self.assertEqual(_run_skill(self.src, WTYPE_SWORD, 2, 3), PACKED(2, 3))


class StaffSavantExecutionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        try:
            from Tools.thumb_harness import assemble  # noqa: F401
        except ImportError as exc:
            raise unittest.SkipTest(f"thumb harness unavailable: {exc}")
        cls.src = SKILLS / "StaffSavant" / "StaffSavant.s"

    def test_staff_max_increases_by_one(self):
        self.assertEqual(_run_skill(self.src, WTYPE_STAFF, 1, 1), PACKED(1, 2))

    def test_non_staff_unchanged(self):
        self.assertEqual(_run_skill(self.src, WTYPE_BOW, 2, 3), PACKED(2, 3))


class TomeRangeExecutionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        try:
            from Tools.thumb_harness import assemble  # noqa: F401
        except ImportError as exc:
            raise unittest.SkipTest(f"thumb harness unavailable: {exc}")
        cls.src = SKILLS / "TomeRange" / "TomeRange.s"

    def test_anima_light_dark_gain_one(self):
        for wtype in (WTYPE_ANIMA, WTYPE_LIGHT, WTYPE_DARK):
            with self.subTest(wtype=wtype):
                self.assertEqual(_run_skill(self.src, wtype, 1, 2), PACKED(1, 3))

    def test_non_tome_unchanged(self):
        self.assertEqual(_run_skill(self.src, WTYPE_BOW, 2, 3), PACKED(2, 3))


def _ret_packed(mn: int, mx: int) -> bytes:
    return struct.pack("<HHHHH", 0x2000 | mx, 0x2100 | mn, 0x0409, 0x4308, 0x4770)


class CoveringRangeExecutionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        try:
            from Tools.thumb_harness import assemble  # noqa: F401
        except ImportError as exc:
            raise unittest.SkipTest(f"thumb harness unavailable: {exc}")
        cls.src = SKILLS / "GetItemRangeHooks.s"

    def _cover(self, min_r: int, max_r: int, dist: int) -> int:
        from Tools.thumb_harness import Harness, assemble, symbol_offsets

        off = symbol_offsets(self.src)
        code = assemble(self.src)
        start = off["IsItemCoveringRangeHook"]
        unpack = start + code[start:].find(b"\x00\xf8") + 2
        h = Harness(code, skill_present=False)
        return h.run(
            off["CoverFail"],
            regs={"r0": PACKED(min_r, max_r), "r6": dist},
            entry_offset=unpack,
        )["r0"]

    def test_pointblank_bow_covers_range_one(self):
        self.assertEqual(self._cover(1, 3, 1), 1)

    def test_vanilla_bow_rejects_range_one(self):
        self.assertEqual(self._cover(2, 3, 1), 0)

    def test_in_range_accepted(self):
        self.assertEqual(self._cover(2, 3, 2), 1)

    def test_past_max_rejected(self):
        self.assertEqual(self._cover(2, 3, 4), 0)


class MagOn2ExecutionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        try:
            from Tools.thumb_harness import assemble  # noqa: F401
        except ImportError as exc:
            raise unittest.SkipTest(f"thumb harness unavailable: {exc}")
        cls.src = SKILLS / "MagOn2Hook.s"

    def _run(self, mag: int, skill_present: bool) -> int:
        from Tools.thumb_harness import Harness, assemble, symbol_offsets

        raw = bytearray(assemble(self.src))
        idx = raw.rfind(b"\x00\xf8")
        raw[idx : idx + 2] = (0x2000 | int(skill_present)).to_bytes(2, "little")
        off = symbol_offsets(self.src)
        unit = 0x02000000
        entry = raw.find(b"\x14\x21")
        h = Harness(bytes(raw), skill_present=False)
        h.seed(unit + 0x14, struct.pack("b", mag))
        return h.run(
            off["NoSkill"] + 4,
            regs={"r0": 0, "r4": unit},
            entry_offset=entry,
        )["r0"]

    def test_floors_at_five(self):
        self.assertEqual(self._run(8, False), 5)

    def test_half_mag_without_skill(self):
        self.assertEqual(self._run(20, False), 10)

    def test_staffsavant_adds_one(self):
        self.assertEqual(self._run(20, True), 11)


class StaffReachMaskExecutionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        try:
            from Tools.thumb_harness import assemble  # noqa: F401
        except ImportError as exc:
            raise unittest.SkipTest(f"thumb harness unavailable: {exc}")
        cls.src = SKILLS / "GetUnitStaffReachBits.s"

    def _mask(self, max_r: int) -> int:
        from Tools.thumb_harness import Harness, assemble, symbol_offsets

        off = symbol_offsets(self.src)
        h = Harness(assemble(self.src), skill_present=False)
        return h.run(
            off["MaskDone"],
            regs={"r0": PACKED(1, max_r)},
            entry_offset=off["StaffMask"],
        )["r0"]

    def test_heal_range_is_bit_one(self):
        self.assertEqual(self._mask(1), 1)

    def test_staffsavant_heal_is_one_to_two(self):
        self.assertEqual(self._mask(2), 3)

    def test_mag_over_two_uses_0x20(self):
        self.assertEqual(self._mask(5), 0x20)

    def _fill(self, mask: int) -> int:
        from Tools.thumb_harness import Harness, assemble, symbol_offsets

        off = symbol_offsets(self.src)
        h = Harness(assemble(self.src), skill_present=False)
        return h.run(
            off["StaffFillRadiusDone"],
            regs={"r0": mask},
            entry_offset=off["StaffFillRadius"],
        )["r0"]

    def test_heal_fill_stays_one(self):
        self.assertEqual(self._fill(1), 1)

    def test_staffsavant_fill_is_two(self):
        self.assertEqual(self._fill(3), 2)

    def test_physic_mask_does_not_use_this_fill(self):
        self.assertEqual(self._fill(0x20), 1)

    def test_no_staff_fill_stays_one(self):
        self.assertEqual(self._fill(0), 1)


@unittest.skipUnless(HACK.exists(), "FE7_Hack.gba missing")
class RangeRomTests(unittest.TestCase):
    def test_min_max_and_reach_are_hooked(self):
        rom = HACK.read_bytes()  # FE7_Hack.gba
        self.assertEqual(rom[GET_MIN : GET_MIN + 4], JUMP)
        self.assertEqual(rom[GET_MAX : GET_MAX + 4], JUMP)
        self.assertEqual(rom[GET_REACH : GET_REACH + 4], JUMP)
        self.assertEqual(rom[GET_COVER : GET_COVER + 4], JUMP)
        self.assertEqual(rom[GET_STAFF : GET_STAFF + 4], JUMP)
        self.assertEqual(rom[GET_STAFF_ALL : GET_STAFF_ALL + 4], JUMP)
        self.assertEqual(rom[GET_MAG2 : GET_MAG2 + 4], JUMP)
        self.assertEqual(rom[GET_HEAL_FILL : GET_HEAL_FILL + 4], JUMP)


if __name__ == "__main__":
    unittest.main()
