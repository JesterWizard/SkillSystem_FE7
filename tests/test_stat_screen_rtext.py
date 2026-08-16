"""Stat-screen R-text must use vanilla FE7U help IDs, not FE8 0x54x/0x55x.

Vanilla table is at 0x08CC2140 (page 1 start). FE8 0x542 etc. are names here.
"""
import re
import struct
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
RTEXT = ROOT / "EngineHacks" / "Necessary" / "ModularStatScreen" / "RText.event"
GETTERS = (
    ROOT
    / "EngineHacks"
    / "Necessary"
    / "ModularStatScreen"
    / "RTextGetters"
    / "RTextGetters.event"
)
WRANK = (
    ROOT
    / "EngineHacks"
    / "Necessary"
    / "ModularStatScreen"
    / "WeaponRankStatScreen"
    / "asm"
    / "asm.event"
)
CLEAN_ROM = ROOT / "FE7_clean.gba"

DEFINE_RE = re.compile(r"#define\s+(HTID_\w+)\s+(0x[0-9A-Fa-f]+)")


def _defines(text: str) -> dict[str, int]:
    return {n: int(v, 16) for n, v in DEFINE_RE.findall(text)}


class StatScreenRTextTests(unittest.TestCase):
    def test_htid_defines_match_vanilla_rom_boxes(self):
        ids = _defines(RTEXT.read_text(encoding="utf-8"))
        self.assertEqual(ids["HTID_Level"], 0x25B)
        self.assertEqual(ids["HTID_Exp"], 0x25C)
        self.assertEqual(ids["HTID_HP"], 0x25D)
        self.assertEqual(ids["HTID_Str"], 0x264)
        self.assertEqual(ids["HTID_Luck"], 0x26E)
        self.assertEqual(ids["HTID_Def"], 0x268)
        self.assertEqual(ids["HTID_Res"], 0x269)
        self.assertEqual(ids["HTID_Con"], 0x26A)
        self.assertEqual(ids["HTID_Aid"], 0x26B)
        self.assertEqual(ids["HTID_Mov"], 0x26C)
        self.assertEqual(ids["HTID_Trv"], 0x26D)
        self.assertEqual(ids["HTID_Affin"], 0x26F)
        self.assertEqual(ids["HTID_Atk"], 0x25F)
        self.assertEqual(ids["HTID_Hit"], 0x260)
        self.assertEqual(ids["HTID_Rng"], 0x261)
        self.assertEqual(ids["HTID_Crit"], 0x262)
        self.assertEqual(ids["HTID_Avo"], 0x263)
        self.assertEqual(ids["HTID_Supports"], 0x350)
        self.assertEqual(ids["HTID_Class"], 0x22B)
        self.assertEqual(ids["HTID_Mag"], 0x265)

    def test_rmenu_uses_htid_not_fe8_literals(self):
        src = RTEXT.read_text(encoding="utf-8")
        self.assertNotRegex(src, r"RMenu\([^)]*0x54[0-9a-fA-F]")
        self.assertNotRegex(src, r"RMenu\([^)]*0x55[0-9a-fA-F]")
        self.assertNotRegex(src, r"RMenu\([^)]*0x6E8")
        self.assertNotRegex(src, r"RMenu_Cond\([^)]*0x569")
        self.assertIn("HTID_Level", src)
        self.assertIn("HTID_Atk", src)
        self.assertIn("HTID_Mov", src)
        self.assertGreaterEqual(src.count("HTID_Level"), 3)
        self.assertGreaterEqual(src.count("HTID_HP"), 3)

    def test_mov_hp_getter_ids(self):
        src = GETTERS.read_text(encoding="utf-8")
        self.assertIn("#define MovDesc HTID_Mov", src)
        self.assertIn("#define HPDesc  0x025D", src)

    def test_weapon_rank_help_ids(self):
        src = WRANK.read_text(encoding="utf-8")
        self.assertIn("SHORT 0x348 0x349 0x34A 0x34B 0x34C 0x34D 0x34E 0x34F", src)
        self.assertNotIn("0x561", src)

    def test_clean_rom_page1_level_box(self):
        if not CLEAN_ROM.exists():
            self.skipTest("FE7_clean.gba missing")
        rom = CLEAN_ROM.read_bytes()
        page1 = struct.unpack_from("<I", rom, 0x8152C)[0] & 0x01FFFFFF
        # First vanilla page-1 box is Str at 0xCC2140; Level is at 0xCC20EC.
        level_off = 0xCC20EC
        self.assertEqual(rom[level_off + 16], 0x06)
        self.assertEqual(rom[level_off + 17], 0x78)
        self.assertEqual(struct.unpack_from("<H", rom, level_off + 18)[0], 0x25B)
        self.assertEqual(page1, 0xCC2140)


if __name__ == "__main__":
    unittest.main()
