"""DEC-117: opt-in alternate weapon/skill page and dedicated support page."""
import re
import struct
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CONFIG = ROOT / "EngineHacks" / "Config.event"
MSS = ROOT / "EngineHacks" / "Necessary" / "ModularStatScreen" / "ModularStatScreen.event"
RTEXT = ROOT / "EngineHacks" / "Necessary" / "ModularStatScreen" / "RText.event"
PAGES = ROOT / "EngineHacks" / "Necessary" / "ModularStatScreen" / "pages"
BUILD_ASM = ROOT / "Tools" / "build_skill_asm.py"
SCREEN_TEXT = ROOT / "Text" / "statscreen_text.txt"
HACK_ROM = ROOT / "FE7_Hack.gba"

PAGE_COUNT_OFF = 0x811BC
PAGE_TABLE_OFF = 0x404B60
HELP_SWITCH_OFF = 0x81520
JUMP_TO_HACK = bytes([0x00, 0x4B, 0x18, 0x47])

PAGE1 = PAGES / "mss_page1_skills.s"
PAGE3 = PAGES / "mss_page3_weapons_skills.s"
PAGE4 = PAGES / "mss_page4_supports.s"
HELP_PAGE1_BEQ_OFF = 0x81516
HELP_PAGE1_TO_HACK = bytes([0x03, 0xD0])  # beq $81520 (HelpPageSelect)


def _config_enabled() -> bool:
    text = CONFIG.read_text(encoding="utf-8")
    return bool(re.search(r"(?m)^#define ALTERNATE_SKILL_SUPPORT_PAGES\b", text))


class AlternateSkillSupportPagesTests(unittest.TestCase):
    def test_config_option_exists(self):
        text = CONFIG.read_text(encoding="utf-8")
        self.assertRegex(text, r"ALTERNATE_SKILL_SUPPORT_PAGES")

    def test_installer_keeps_three_pages_when_disabled(self):
        text = MSS.read_text(encoding="utf-8")
        self.assertIn("#ifdef ALTERNATE_SKILL_SUPPORT_PAGES", text)
        self.assertIn('#include "pages/mss_page3_original.lyn.event"', text)
        self.assertIsNotNone(re.search(r"#else.*?BYTE 3", text, flags=re.S))

    def test_installer_uses_four_pages_when_enabled(self):
        text = MSS.read_text(encoding="utf-8")
        self.assertIn("mss_page3_weapons_skills.lyn.event", text)
        self.assertIn("mss_page4_supports.lyn.event", text)
        self.assertIsNotNone(
            re.search(r"#ifdef ALTERNATE_SKILL_SUPPORT_PAGES.*?BYTE 4", text, flags=re.S)
        )
        self.assertIn("MSS_page4|1", text)

    def test_page3_lists_all_weapon_ranks_and_skill_names(self):
        src = PAGE3.read_text(encoding="utf-8")
        for weapon in ("Sword", "Lance", "Axe", "Bow", "Staff", "Anima", "Light", "Dark"):
            self.assertIn(weapon, src)
        self.assertIn("draw_weapon_rank_at 1, 1, Sword", src)
        self.assertIn("draw_skill_icon_at 21,", src)
        self.assertNotIn("draw_skill_icon_at 16,", src)
        self.assertIn("draw_skillname_at 23,", src)
        self.assertIn("GetSkillNameFromSkillDesc", src)
        self.assertIn("NarrowMenuLut", src)
        self.assertIn("width=7", src)
        self.assertNotIn("DrawSupports", src)
        self.assertNotIn("WeaponSkillsTextIDLink", src)
        self.assertNotRegex(src, r"(?i)skill.?capacity")

    def test_page3_uses_tall_frame_not_wep_support_divider(self):
        gfx = (
            ROOT
            / "EngineHacks"
            / "Necessary"
            / "ModularStatScreen"
            / "Background"
            / "Graphics"
            / "Graphics.event"
        ).read_text(encoding="utf-8")
        self.assertIn("ALTERNATE_SKILL_SUPPORT_PAGES", gfx)
        self.assertIn("SSS_PageWepSupportTSA", gfx)

    def test_page1_skips_skills_when_alternate_pages_enabled(self):
        src = PAGE1.read_text(encoding="utf-8")
        self.assertIn("AlternatePagesLink", src)
        self.assertIn("b SkillEnd", src)
        self.assertIn("draw_trv_text_at 21, 13", src)
        text = RTEXT.read_text(encoding="utf-8")
        self.assertIn("#define ST_Skills ST_Trv", text)
        self.assertIn("HTID_Trv", text)

    def test_help_page_select_does_not_overwrite_page1_loader(self):
        text = MSS.read_text(encoding="utf-8")
        self.assertIn("ORG $81516", text)
        self.assertIn("SHORT $D003", text)

    def test_page4_draws_support_list_and_cumulative_bonuses(self):
        src = PAGE4.read_text(encoding="utf-8")
        self.assertIn("GetUnitSupportLevel", src)
        self.assertIn("ApplyAffinitySupportBonuses", src)
        self.assertIn("Page4GetSupportData", src)
        self.assertIn("ldr r2, [sp, #0x48]", src)
        self.assertIn("@ Atk", src)
        self.assertIn("@ Def", src)
        self.assertIn("@ Hit", src)
        self.assertIn("@ Avoid", src)
        self.assertIn("@ Crit", src)
        self.assertIn("@ Ddg", src)
        self.assertIn("GetSupportLevelUiChar", src)
        self.assertIn("draw_textID_at 13, 3", src)
        self.assertNotIn("draw_affinity_icon_at", src)
        self.assertIn("add r1, #46 @ x=23", src)
        self.assertIn("beq Page4ListAdvance", src)
        self.assertNotIn("SupportLevelTextIDLink", src)
        self.assertNotIn("SkillCapacity", src)

    def test_rtext_gains_page4_when_enabled(self):
        text = RTEXT.read_text(encoding="utf-8")
        self.assertIn("RText_Page4", text)
        self.assertIn("HTID_Supports", text)

    def test_new_pages_are_rebuilt_with_mss_asm(self):
        text = BUILD_ASM.read_text(encoding="utf-8")
        self.assertIn("mss_page3_weapons_skills.s", text)
        self.assertIn("mss_page4_supports.s", text)

    def test_screen_text_has_support_and_bonus_labels(self):
        text = SCREEN_TEXT.read_text(encoding="utf-8")
        self.assertIn("SS_SupportLevelText", text)
        self.assertIn("SS_BonusText", text)
        self.assertIn("SS_DdgText", text)

    def test_rom_page_count_matches_config(self):
        if not HACK_ROM.is_file():
            self.skipTest("FE7_Hack.gba not built")
        rom = HACK_ROM.read_bytes()
        count = rom[PAGE_COUNT_OFF]
        table = struct.unpack_from("<III", rom, PAGE_TABLE_OFF)
        if _config_enabled():
            self.assertEqual(count, 4)
            fourth = struct.unpack_from("<I", rom, PAGE_TABLE_OFF + 12)[0]
            self.assertTrue(fourth & 1, "page 4 pointer must be Thumb")
            self.assertEqual(rom[HELP_SWITCH_OFF:HELP_SWITCH_OFF + 4], JUMP_TO_HACK)
            self.assertEqual(rom[HELP_PAGE1_BEQ_OFF:HELP_PAGE1_BEQ_OFF + 2], HELP_PAGE1_TO_HACK)
        else:
            self.assertEqual(count, 3)
            self.assertNotEqual(rom[HELP_SWITCH_OFF:HELP_SWITCH_OFF + 4], JUMP_TO_HACK)
        self.assertTrue(all(p & 1 for p in table[:3]))

    def test_page3_skill_names_remap_to_narrow_menu_glyphs(self):
        if str(ROOT) not in sys.path:
            sys.path.insert(0, str(ROOT))
        from Tools.thumb_harness import CODE_BASE, Harness, assemble, symbol_offsets

        code = assemble(PAGE3)
        offsets = symbol_offsets(PAGE3)
        entry = offsets["GetSkillNameFromSkillDesc"]
        halt = len(code)
        buf = 0x02004000
        src = b"Triangle Adept: If this unit has WTA, +15 hit.\x00"
        # NARROW_MENU_DICT: T,i,l,t stay vanilla; rest + space remap.
        expected = bytes.fromhex("548f69818b876c85bc9b84858d74") + b"\x00"

        h = Harness(code)
        h.seed(buf, src)
        regs = h.run(
            halt,
            regs={"r0": buf, "lr": (CODE_BASE + halt) | 1},
            entry_offset=entry,
        )
        self.assertEqual(h.read(buf, len(expected)), expected)
        self.assertEqual(regs["r0"], buf)


if __name__ == "__main__":
    unittest.main()
