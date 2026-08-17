"""DEC-65: prep-screen skill scroll usability and effect are hooked."""
import struct
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SCROLLS = ROOT / "EngineHacks" / "SkillSystem" / "SkillScrolls" / "SkillScrolls.event"
HACK_ROM = ROOT / "FE7_Hack.gba"

SKILL_SCROLL = 0x9F
PREP_USE_BASE = 0x5A
PREP_USE_CMP = 0x2805A
PREP_USE_TABLE_PTR = 0x2806C
PREP_USE_INDEX = SKILL_SCROLL - PREP_USE_BASE  # 0x45
PREP_EFFECT_HOOK = 0x2CD28
JUMP_TO_HACK = bytes((0x00, 0x4B, 0x18, 0x47))


def _text(path: Path) -> str:
    return path.read_text(encoding="utf-8")


class PrepSkillScrollTests(unittest.TestCase):
    def test_prep_usability_expands_to_scroll_index(self):
        src = _text(SCROLLS)
        self.assertRegex(src, r"ORG\s+\$2805A")
        self.assertRegex(src, r"SHORT\s+0x2845")
        self.assertIn("MultiScrollPrepUsability", src)
        self.assertIn("SkillScrollPrepUsabilityTable", src)

    def test_prep_effect_hooks_apply_item_stat_boost(self):
        src = _text(SCROLLS)
        self.assertRegex(src, r"ORG\s+\$2CD28")
        self.assertIn("PrepScrollEffectDispatch", src)
        self.assertIn("MultiScrollPrepEffect", src)

    def test_hack_rom_prep_usability_table(self):
        if not HACK_ROM.is_file():
            self.skipTest("FE7_Hack.gba missing")
        rom = HACK_ROM.read_bytes()
        self.assertEqual(rom[PREP_USE_CMP : PREP_USE_CMP + 2], struct.pack("<H", 0x2845))
        table = struct.unpack_from("<I", rom, PREP_USE_TABLE_PTR)[0]
        self.assertGreater(table, 0x09000000, "prep usability table not repointed")
        slot = (table & 0x01FFFFFF) + 4 * PREP_USE_INDEX
        dest = struct.unpack_from("<I", rom, slot)[0]
        self.assertTrue(dest & 1, "prep usability handler must be thumb")
        self.assertGreater(dest & 0x01FFFFFF, 0x01000000)

    def test_hack_rom_prep_effect_jump(self):
        if not HACK_ROM.is_file():
            self.skipTest("FE7_Hack.gba missing")
        rom = HACK_ROM.read_bytes()
        self.assertEqual(rom[PREP_EFFECT_HOOK : PREP_EFFECT_HOOK + 4], JUMP_TO_HACK)
        dest = struct.unpack_from("<I", rom, PREP_EFFECT_HOOK + 4)[0]
        self.assertTrue(dest & 1)
        self.assertGreater(dest & 0x01FFFFFF, 0x01000000)


if __name__ == "__main__":
    unittest.main()
