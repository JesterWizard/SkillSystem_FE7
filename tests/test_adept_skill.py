"""Adept adds a consecutive attack (Speed %); FE7 stores round count in r5."""
import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from lyn_bytes import lyn_to_bytes

ROOT = Path(__file__).resolve().parents[1]
HIT_SRC = (
    ROOT
    / "EngineHacks"
    / "SkillSystem"
    / "Skills"
    / "ProcSkills"
    / "Adept"
    / "get_battle_unit_hit_count.s"
)
HIT_LYN = HIT_SRC.with_name(HIT_SRC.stem + ".lyn.event")
ADEPT_SRC = (
    ROOT / "EngineHacks" / "SkillSystem" / "Skills" / "ProcSkills" / "Adept" / "proc_adept.s"
)
CLEAN_ROM = ROOT / "FE7_clean.gba"

GET_HIT_COUNT = 0x08029114
BRAVE_EFFECT = 0x08029128
ROUND_HITS = 0x080290B8
GENERATE_HIT = 0x080294D8


def adept_hit_count(brave: bool, has_adept: bool, speed: int, roll: int) -> int:
    """Mirror GetBattleUnitHitCount + Adept. roll is the 1–100 RN; proc if roll <= speed."""
    result = 1
    if brave:
        result <<= 1
    if has_adept and 1 <= roll <= speed:
        result += 1
    return result


class AdeptSkillTests(unittest.TestCase):
    def test_fe7_round_count_lives_in_r5_not_stack_local(self):
        rom = CLEAN_ROM.read_bytes()
        round_hits = rom[ROUND_HITS - 0x08000000 : ROUND_HITS - 0x08000000 + 0x50]
        self.assertEqual(round_hits[0:2], b"\xf0\xb5")
        bl_off = 0x080290D8 - ROUND_HITS
        self.assertEqual(round_hits[bl_off : bl_off + 4], b"\x00\xf0\x1c\xf8")
        self.assertEqual(round_hits[bl_off + 4 : bl_off + 6], b"\x05\x1c")
        hit = rom[GENERATE_HIT - 0x08000000 : GENERATE_HIT - 0x08000000 + 2]
        self.assertEqual(hit, b"\x70\xb5")
        get_count = rom[GET_HIT_COUNT - 0x08000000 : BRAVE_EFFECT - 0x08000000]
        self.assertEqual(get_count[0:2], b"\x10\xb5")
        self.assertEqual(get_count[2:4], b"\x01\x24")

    def test_source_adds_speed_percent_hit_via_skilltester(self):
        src = HIT_SRC.read_text(encoding="utf-8")
        self.assertIn("BattleCheckBraveEffect", src)
        self.assertIn("0x16", src)
        self.assertIn("SkillTester", src)
        self.assertIn("AdeptID", src)
        self.assertIn("add", src.lower())
        self.assertNotIn("0x38", src)

    def test_legacy_proc_adept_must_not_poke_fe8_stack_slot(self):
        src = ADEPT_SRC.read_text(encoding="utf-8")
        self.assertNotRegex(src, r"mov r1, #0x38")

    def test_dmp_calls_brave_then_adds_a_hit(self):
        data = lyn_to_bytes(HIT_LYN)
        self.assertIn(b"\x01\x25", data)
        self.assertIn(b"\x85\x40", data)
        self.assertIn(b"\x01\x35", data)

    def test_hit_count_logic(self):
        self.assertEqual(adept_hit_count(False, False, 99, 1), 1)
        self.assertEqual(adept_hit_count(True, False, 99, 1), 2)
        self.assertEqual(adept_hit_count(False, True, 50, 50), 2)
        self.assertEqual(adept_hit_count(False, True, 50, 51), 1)
        self.assertEqual(adept_hit_count(True, True, 30, 1), 3)
        self.assertEqual(adept_hit_count(True, True, 30, 31), 2)


if __name__ == "__main__":
    unittest.main()
