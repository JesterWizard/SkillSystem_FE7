"""Skill scroll is FE7 item 0x9F; use tables are expanded and repointed."""
import struct
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DEFS = ROOT / "CustomDefinitions.event"
SCROLLS = ROOT / "EngineHacks" / "SkillSystem" / "SkillScrolls" / "SkillScrolls.event"
HACK_ROM = ROOT / "FE7_Hack.gba"

SKILL_SCROLL = 0x9F
ITEM_TABLE = 0xBE222C
ITEM_SIZE = 0x24
USE_CMP = 0x16B76
TARGET_CMP = 0x26CFC
EFFECT_CMP = 0x2D030
USE_TABLE_PTR = 0x16B88
TARGET_TABLE_PTR = 0x26D0C
EFFECT_TABLE_PTR = 0x2D048
CMP_INDEX = SKILL_SCROLL - 0x4A  # 0x55
VANILLA_TABLE_ENTRIES = 0x51


def _text(path: Path) -> str:
    return path.read_text(encoding="utf-8")


class SkillScrollIdTests(unittest.TestCase):
    def test_define_is_0x9f(self):
        self.assertRegex(
            _text(DEFS),
            r"#define\s+SkillScroll\s+0x9F\b",
        )

    def test_use_tables_extend_to_scroll_index(self):
        src = _text(SCROLLS)
        self.assertRegex(src, r"SHORT 0x2855")
        self.assertNotRegex(src, r"SHORT 0x2872")
        self.assertEqual(src.count("POIN (MultiScroll"), 4)

    def test_hack_rom_item_and_cmp(self):
        if not HACK_ROM.is_file():
            self.skipTest("FE7_Hack.gba missing")
        rom = HACK_ROM.read_bytes()
        cmp_bytes = struct.pack("<H", 0x2800 | CMP_INDEX)
        for off in (USE_CMP, TARGET_CMP, EFFECT_CMP):
            self.assertEqual(rom[off : off + 2], cmp_bytes, f"cmp at 0x{off:05X}")
        entry = rom[ITEM_TABLE + ITEM_SIZE * SKILL_SCROLL :]
        self.assertEqual(entry[0:2], b"\xff\xff")
        self.assertEqual(entry[2:4], b"\xff\xff")
        self.assertEqual(entry[6], SKILL_SCROLL)
        for ptr_off in (USE_TABLE_PTR, TARGET_TABLE_PTR, EFFECT_TABLE_PTR):
            table = struct.unpack_from("<I", rom, ptr_off)[0]
            self.assertGreater(table, 0x09000000, f"table not repointed at 0x{ptr_off:05X}")
            slot = (table & 0x01FFFFFF) + 4 * CMP_INDEX
            dest = struct.unpack_from("<I", rom, slot)[0]
            self.assertTrue(dest & 1, f"scroll handler at 0x{slot:08X}")
            self.assertGreater(dest & 0x01FFFFFF, 0x01000000)


if __name__ == "__main__":
    unittest.main()
