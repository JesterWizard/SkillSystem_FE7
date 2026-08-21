"""Core-7 stats (STR/MAG/SKL/SPD/LCK/DEF/RES) show boosted totals in green on the
stat screen, the same way MOV/CON already do.

draw_*_bar_at (via vanilla DrawBar, 0x0807FD28) already prints the stat's total
value as a plain-colour number at (bar_x, bar_y) before drawing the fill graphic
on the row below. draw_*_number_at is called immediately after, at the same
tile, to redraw that number in green when boosted (current total != base stat
byte) or blue otherwise -- overwriting DrawBar's plain digit, not duplicating it.

Regression: draw_number_at used to unconditionally clobber r1 with its default
colour, silently discarding any Green/Blue the caller had just set in r1 -- this
is why draw_move_number_at/draw_con_number_at were dead code. colour=-1 now
skips that clobber.
"""
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MSS_DEFS = (
    ROOT / "EngineHacks" / "Necessary" / "ModularStatScreen" / "pages" / "mss_defs.s"
)
PAGE1_SKILLS = (
    ROOT
    / "EngineHacks"
    / "Necessary"
    / "ModularStatScreen"
    / "pages"
    / "mss_page1_skills.s"
)

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
                self.assertRegex(macro, r"draw_number_at\s+\\tile_x,\s*\\tile_y,\s*colour=-1")

    def test_core_stat_number_macros_compare_total_to_base(self):
        src = MSS_DEFS.read_text(encoding="utf-8")
        generic = _macro(src, "draw_stat_number_at,")
        self.assertIn("#Green", generic)
        self.assertIn("#Blue", generic)
        self.assertRegex(generic, r"cmp\s+r6,\s*r3")
        self.assertRegex(generic, r"draw_number_at\s+\\tile_x,\s*\\tile_y,\s*colour=-1")

        for stat, (getter, offset) in CORE_STATS.items():
            with self.subTest(stat=stat):
                macro = _macro(src, f"draw_{stat}_number_at,")
                self.assertIn(getter, macro)
                self.assertIn(offset, macro)

    def test_page_redraws_boosted_number_at_same_tile_as_bar(self):
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
                self.assertRegex(src, rf"draw_{stat}_number_at\s+{x},\s*{y}")

        self.assertRegex(src, r"draw_move_bar_at\s+16,\s*17")
        self.assertRegex(src, r"draw_move_number_at\s+16,\s*17")
        self.assertRegex(src, r"draw_con_bar_at\s+24,\s*3")
        self.assertRegex(src, r"draw_con_number_at\s+24,\s*3")


if __name__ == "__main__":
    unittest.main()
