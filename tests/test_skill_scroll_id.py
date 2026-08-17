"""Skill scroll is FE7 item 0x9F on an expanded FreeSpace item table.

Writing 0x9F into the vanilla ItemTable at 0xBE222C overlaps Lord
movement-cost data at 0xBE3888 and zeroes map movement.
"""
import struct
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DEFS = ROOT / "CustomDefinitions.event"
SCROLLS = ROOT / "EngineHacks" / "SkillSystem" / "SkillScrolls" / "SkillScrolls.event"
ITEM_BIN = (
    ROOT
    / "EngineHacks"
    / "SkillSystem"
    / "SkillScrolls"
    / "fe7_item_table_through_9A.bin"
)
HACK_ROM = ROOT / "FE7_Hack.gba"
CLEAN_ROM = ROOT / "FE7_clean.gba"

SKILL_SCROLL = 0x9F
VANILLA_ITEM_TABLE = 0xBE222C
ITEM_SIZE = 0x24
LORD_MOV_COST = 0xBE3888
GET_ITEM_DATA_TABLE_LIT = 0x174BC
USE_CMP = 0x16B76
TARGET_CMP = 0x26CFC
EFFECT_CMP = 0x2D030
USE_TABLE_PTR = 0x16B88
TARGET_TABLE_PTR = 0x26D0C
EFFECT_TABLE_PTR = 0x2D048
CMP_INDEX = SKILL_SCROLL - 0x4A  # 0x55


def _text(path: Path) -> str:
    return path.read_text(encoding="utf-8")


class SkillScrollIdTests(unittest.TestCase):
    def test_define_is_0x9f(self):
        self.assertRegex(
            _text(DEFS),
            r"#define\s+SkillScroll\s+0x9F\b",
        )

    def test_expanded_table_not_vanilla_slot(self):
        src = _text(SCROLLS)
        self.assertIn("ExpandedItemTable", src)
        self.assertIn("fe7_item_table_through_9A.bin", src)
        self.assertNotRegex(
            src,
            r"ORG\s+0xBE222C\s*\+|ORG\s+ItemTable\s*\+\s*\(0x24\s*\*\s*SkillScroll\)",
        )
        self.assertTrue(ITEM_BIN.is_file())
        self.assertEqual(ITEM_BIN.stat().st_size, 0x9B * ITEM_SIZE)

    def test_use_tables_extend_to_scroll_index(self):
        src = _text(SCROLLS)
        self.assertRegex(src, r"SHORT 0x2855")
        self.assertNotRegex(src, r"SHORT 0x2872")
        self.assertEqual(src.count("POIN (MultiScroll"), 4)

    def test_hack_rom_preserves_lord_mov_costs(self):
        if not HACK_ROM.is_file() or not CLEAN_ROM.is_file():
            self.skipTest("FE7_Hack.gba or FE7_clean.gba missing")
        clean = CLEAN_ROM.read_bytes()
        hack = HACK_ROM.read_bytes()
        # Plains (index 1) must stay cost 1, not 0xFF from item name SHORT.
        self.assertEqual(hack[LORD_MOV_COST + 1], 1)
        self.assertEqual(
            hack[LORD_MOV_COST : LORD_MOV_COST + 0x20],
            clean[LORD_MOV_COST : LORD_MOV_COST + 0x20],
        )
        # Vanilla slot must not hold the SkillScroll item blob.
        vanilla_slot = VANILLA_ITEM_TABLE + ITEM_SIZE * SKILL_SCROLL
        self.assertNotEqual(hack[vanilla_slot : vanilla_slot + 2], b"\xff\xff")

    def test_hack_rom_item_and_cmp(self):
        if not HACK_ROM.is_file():
            self.skipTest("FE7_Hack.gba missing")
        rom = HACK_ROM.read_bytes()
        cmp_bytes = struct.pack("<H", 0x2800 | CMP_INDEX)
        for off in (USE_CMP, TARGET_CMP, EFFECT_CMP):
            self.assertEqual(rom[off : off + 2], cmp_bytes, f"cmp at 0x{off:05X}")

        table = struct.unpack_from("<I", rom, GET_ITEM_DATA_TABLE_LIT)[0]
        self.assertGreater(table, 0x09000000, "GetItemData still uses vanilla ItemTable")
        entry_off = (table & 0x01FFFFFF) + ITEM_SIZE * SKILL_SCROLL
        entry = rom[entry_off:]
        self.assertEqual(entry[0:2], b"\xff\xff")
        self.assertEqual(entry[2:4], b"\xff\xff")
        self.assertEqual(entry[6], SKILL_SCROLL)

        for ptr_off in (USE_TABLE_PTR, TARGET_TABLE_PTR, EFFECT_TABLE_PTR):
            use_table = struct.unpack_from("<I", rom, ptr_off)[0]
            self.assertGreater(use_table, 0x09000000, f"table not repointed at 0x{ptr_off:05X}")
            slot = (use_table & 0x01FFFFFF) + 4 * CMP_INDEX
            dest = struct.unpack_from("<I", rom, slot)[0]
            self.assertTrue(dest & 1, f"scroll handler at 0x{slot:08X}")
            self.assertGreater(dest & 0x01FFFFFF, 0x01000000)


if __name__ == "__main__":
    unittest.main()
