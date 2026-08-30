"""DrawBar prints each core stat's base digit and the small +/- bonus.

The page must not also call draw_*_number_at: that duplicated digits (9 -> 99)
and recoloured the big number. Buff/debuff colour lives only on the small +/-
from DrawSignedBonusNumber (hooked at 0x08006240).

Negative modifiers get a red '-' instead of vanilla's hardcoded green '+'.
What that routine puts in the colour register is asserted by
test_stat_screen_signed_bonus_execution.py. The checks here are structural:
macros still exist, helpers stay page-local, and the build regenerates pages.

Regression: draw_number_at used to unconditionally clobber r1 with its default
colour, silently discarding any Green/Blue the caller had just set in r1 -- this
is why draw_move_number_at/draw_con_number_at were dead code. colour=-1 now
skips that clobber.

Regression: nothing rebuilt pages/*.lyn.event, so edits to these .s files never
reached the ROM at all. Tools/build_skill_asm.py now covers them.
"""
import re
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MSS_DEFS = (
    ROOT / "EngineHacks" / "Necessary" / "ModularStatScreen" / "pages" / "mss_defs.s"
)
PAGES = ROOT / "EngineHacks" / "Necessary" / "ModularStatScreen" / "pages"
PAGE1_SKILLS = PAGES / "mss_page1_skills.s"
MSS_EVENT = (
    ROOT / "EngineHacks" / "Necessary" / "ModularStatScreen" / "ModularStatScreen.event"
)

SIGNED_HELPERS = ("SetFontRedPalette", "RestoreFontPalette")

CORE_STATS = {
    "str": ("StrGetter", "0x14"),
    "mag": ("MagGetter", "0x47"),
    "skl": ("SklGetter", "0x15"),
    "spd": ("SpdGetter", "0x16"),
    "luck": ("LuckGetter", "0x19"),
    "def": ("DefGetter", "0x17"),
    "res": ("ResGetter", "0x18"),
}


def _macro(src: str, name: str) -> str:
    body = src.split(f".macro {name}", 1)[1]
    return body.split(".endm", 1)[0]


class StatScreenBoostColorTests(unittest.TestCase):
    def test_draw_number_at_can_preserve_caller_colour(self):
        src = MSS_DEFS.read_text(encoding="utf-8")
        macro = _macro(src, "draw_number_at,")
        self.assertRegex(macro, r"\.if\s+\\colour\s*>=\s*0")
        self.assertRegex(macro, r"mov\s+r1,\s*#\\colour")

    def test_move_and_con_number_macros_preserve_boost_colour(self):
        src = MSS_DEFS.read_text(encoding="utf-8")
        for name in ("draw_move_number_at", "draw_con_number_at"):
            with self.subTest(macro=name):
                macro = _macro(src, f"{name},")
                self.assertIn("#Green", macro)
                self.assertIn("#Blue", macro)
                self.assertRegex(macro, r"draw_number_at\s+\\tile_x\s*\+\s*1,\s*\\tile_y,\s*colour=-1")

    def test_core_stat_number_macros_compare_total_to_base(self):
        src = MSS_DEFS.read_text(encoding="utf-8")
        generic = _macro(src, "draw_stat_number_at,")
        self.assertIn("#Green", generic)
        self.assertIn("#Blue", generic)
        self.assertRegex(generic, r"cmp\s+r6,\s*r3")
        self.assertRegex(generic, r"draw_number_at\s+\\tile_x\s*\+\s*1,\s*\\tile_y,\s*colour=-1")

        for stat, (getter, offset) in CORE_STATS.items():
            with self.subTest(stat=stat):
                macro = _macro(src, f"draw_{stat}_number_at,")
                self.assertIn(getter, macro)
                self.assertIn(offset, macro)

    def test_page_lets_drawbar_print_the_big_number_alone(self):
        # DrawBar already prints the base digit and the small +/- bonus.
        # A second draw_*_number_at call wrote another copy one column over
        # (9 -> 99) and recoloured the big number. The page must not do that.
        src = PAGE1_SKILLS.read_text(encoding="utf-8")
        pairs = [
            ("str", 16, 3),
            ("mag", 16, 5),
            ("skl", 16, 7),
            ("spd", 16, 9),
            ("luck", 16, 11),
            ("def", 16, 13),
            ("res", 16, 15),
        ]
        for stat, x, y in pairs:
            with self.subTest(stat=stat):
                self.assertRegex(src, rf"draw_{stat}_bar_at\s+{x},\s*{y}")
                self.assertNotRegex(src, rf"draw_{stat}_number_at")

        self.assertRegex(src, r"draw_move_bar_with_getter_at\s+16,\s*17")
        self.assertNotRegex(src, r"draw_move_number_at")
        self.assertRegex(src, r"draw_con_bar_at\s+24,\s*3")
        self.assertNotRegex(src, r"draw_con_number_at")

    def test_status_duration_uses_fe7_tilemap(self):
        src = MSS_DEFS.read_text(encoding="utf-8")
        macro = _macro(src, "draw_status_text_at,")
        self.assertIn("tile_origin", macro)
        self.assertIn(r"\tile_x+7", macro)
        self.assertNotIn("0x2003CA2", macro)


class NegativeModifierColourTests(unittest.TestCase):
    """A signed three-way compare, not equal/not-equal, in every number macro."""

    def test_number_macros_branch_three_ways(self):
        src = MSS_DEFS.read_text(encoding="utf-8")
        for name in ("draw_stat_number_at", "draw_move_number_at", "draw_con_number_at"):
            with self.subTest(macro=name):
                macro = _macro(src, f"{name},")
                self.assertRegex(macro, r"blt\s+\w*Debuffed",
                                 "below base must take its own branch")
                self.assertRegex(macro, r"bgt\s+\w*Boosted",
                                 "above base must take its own branch")
                self.assertNotRegex(
                    macro,
                    r"beq\s+\w*NotBoosted",
                    "the old equal/not-equal split coloured debuffs green",
                )
                self.assertIn("#RedColour", macro)
                self.assertIn("SetFontRedPalette", macro)
                self.assertIn("RestoreFontPalette", macro)

    def test_growth_bonus_uses_the_signed_replacement(self):
        src = MSS_DEFS.read_text(encoding="utf-8")
        macro = _macro(src, "draw_growth_at,")
        self.assertIn("DrawStatScreenBonusNumber", macro)
        # After ORG $6240 jumpToHack, this is DrawSignedBonusNumber.

    def test_red_reaches_a_palette_bank_the_base_font_does_not_have(self):
        # The five base text colours all live in palette bank 0; red only
        # exists in the growth palettes HP_Name_Color loads into banks 8 and 9.
        src = MSS_DEFS.read_text(encoding="utf-8")
        self.assertRegex(src, r"\.equ RedPalBank, 9")
        self.assertRegex(src, r"\.equ Glyph_Minus, 20")
        self.assertRegex(src, r"\.equ Glyph_Plus, 21")

    def test_signed_helpers_are_not_exported(self):
        # mss_defs.s is included by every page, so each installed page carries
        # its own copy. Exporting them would define the same label four times
        # over inside ModularStatScreen.event.
        src = MSS_DEFS.read_text(encoding="utf-8")
        for name in SIGNED_HELPERS:
            with self.subTest(helper=name):
                self.assertRegex(src, rf"(?m)^{name}:")
                self.assertNotIn(f".global {name}", src)


class StatScreenPagesAreBuiltTests(unittest.TestCase):
    """Every page the installer includes must be regenerated by the build."""

    def test_installed_pages_are_covered_by_build_skill_asm(self):
        if str(ROOT) not in sys.path:
            sys.path.insert(0, str(ROOT))
        from Tools.build_skill_asm import MSS_PAGES, MSS_PAGE_DEPS

        installed = set(re.findall(r'#include\s+"pages/(\w+)\.lyn\.event"',
                                   MSS_EVENT.read_text(encoding="utf-8")))
        self.assertTrue(installed, "no pages included by ModularStatScreen.event")
        built = {p.stem for p in MSS_PAGES}
        self.assertEqual(
            installed - built,
            set(),
            "these pages are installed but nothing rebuilds their .lyn.event",
        )
        self.assertIn(
            MSS_DEFS, MSS_PAGE_DEPS,
            "mss_defs.s is .included by every page; edits to it must restale them",
        )


if __name__ == "__main__":
    unittest.main()
