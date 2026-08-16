"""Left-panel names must match vanilla FE7U PutStatScreenLeftPanelInfo (0x0807FA8C).

Character name: tile (4, 10), GetStringTextCenteredPos(0x38), no +3.
Class name: tile (1, 13), xOffset 0 (left-aligned).
"""
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MSS_DEFS = (
    ROOT
    / "EngineHacks"
    / "Necessary"
    / "ModularStatScreen"
    / "pages"
    / "mss_defs.s"
)
STRMAG_DEFS = (
    ROOT
    / "EngineHacks"
    / "Necessary"
    / "ModularStatScreen"
    / "pages"
    / "strmag"
    / "mss_defs.s"
)
LEFT_PAGE = (
    ROOT
    / "EngineHacks"
    / "Necessary"
    / "ModularStatScreen"
    / "pages"
    / "mss_leftstatscreen.s"
)
LEFT_LYN = LEFT_PAGE.with_suffix(".lyn.event")


class StatScreenNameCenteringTests(unittest.TestCase):
    def test_left_page_tile_origins(self):
        src = LEFT_PAGE.read_text(encoding="utf-8")
        self.assertRegex(src, r"draw_character_name_at\s+4\s*,\s*10")
        self.assertRegex(src, r"draw_class_name_at\s+1\s*,\s*13")

    def test_character_name_centers_in_0x38_without_plus_3(self):
        for path in (MSS_DEFS, STRMAG_DEFS):
            with self.subTest(path=str(path.relative_to(ROOT))):
                src = path.read_text(encoding="utf-8")
                macro = src.split(".macro draw_character_name_at", 1)[1]
                macro = macro.split(".endm", 1)[0]
                self.assertIn("mov     r0, #0x38", macro)
                self.assertIn("Text_GetStringTextCenteredPos", macro)
                self.assertNotRegex(macro, r"add\s+r3\s*,\s*#3")
                self.assertNotIn("mov     r0, #0x30", macro)

    def test_class_name_stays_left_aligned(self):
        for path in (MSS_DEFS, STRMAG_DEFS):
            with self.subTest(path=str(path.relative_to(ROOT))):
                src = path.read_text(encoding="utf-8")
                macro = src.split(".macro draw_class_name_at", 1)[1]
                macro = macro.split(".endm", 1)[0]
                self.assertIn("mov     r3, #0", macro)
                self.assertNotIn("Text_GetStringTextCenteredPos", macro)

    def test_lyn_matches_vanilla_name_literals(self):
        text = LEFT_LYN.read_text(encoding="utf-8")
        # Thumb: mov r0, #0x38 is 0x2038; add r3, #3 is 0x3303.
        # Tile (4,10) map offset 0x288; class (1,13) is 0x342.
        self.assertIn("2038", text)
        self.assertIn("$288", text)
        self.assertIn("$342", text)
        self.assertNotIn("3303", text)
        self.assertNotIn("2030", text)
        self.assertNotIn("2040", text)


if __name__ == "__main__":
    unittest.main()
