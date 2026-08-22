"""Select growth toggle must refresh BG0/BG2, never BG1 (page frame).

Vanilla FE7 copies after drawing a page (0808122A):
  0200323C → 02022CF8  BG0
  0200373C → 020234F8  BG1  (personal-data container)
  02003C3C → 02023CF8  BG2

Page1's growth-toggle path only updates BG0 + BG2. If Const_2023D40 is
mistakenly 0x20234F8 (BG1), Select overwrites the frame with BG2 tiles.
"""
import re
import struct
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(Path(__file__).resolve().parent) not in sys.path:
    sys.path.insert(0, str(Path(__file__).resolve().parent))
from lyn_bytes import lyn_to_bytes
MSS_DEFS = (
    ROOT
    / "EngineHacks"
    / "Necessary"
    / "ModularStatScreen"
    / "pages"
    / "mss_defs.s"
)
PAGE1_LYN = (
    ROOT
    / "EngineHacks"
    / "Necessary"
    / "ModularStatScreen"
    / "pages"
    / "mss_page1_skills.lyn.event"
)

BG0_SCREEN = 0x02022CF8
BG1_SCREEN = 0x020234F8
BG2_SCREEN = 0x02023CF8
BG0_PAGE = 0x0200323C
BG2_PAGE = 0x02003C3C


class GrowthToggleBgTests(unittest.TestCase):
    def test_mss_defs_bg2_screen_is_not_bg1(self):
        src = MSS_DEFS.read_text(encoding="utf-8")
        m = re.search(
            r"\.equ\s+Const_2023D40\s*,\s*(0x[0-9A-Fa-f]+)",
            src,
        )
        self.assertIsNotNone(m, "Const_2023D40 missing from mss_defs.s")
        addr = int(m.group(1), 16)
        self.assertEqual(
            addr,
            BG2_SCREEN,
            "Const_2023D40 must be FE7 BG2 screen (vanilla 08081278)",
        )
        self.assertNotEqual(
            addr,
            BG1_SCREEN,
            "Const_2023D40 must not be BG1 — Select would erase the page frame",
        )

    def test_page1_lyn_refresh_targets_bg0_and_bg2(self):
        # Decode the emitted bytes rather than grepping the text: lyn picks
        # WORD or SHORT/BYTE per blob depending on alignment, so the literal
        # is not reliably spelled out as one token.
        blob = lyn_to_bytes(PAGE1_LYN)
        self.assertIn(
            struct.pack("<I", BG2_SCREEN),
            blob,
            "page1 lyn must copy onto BG2 screen 0x2023CF8",
        )
        self.assertNotIn(
            struct.pack("<I", BG1_SCREEN),
            blob,
            "page1 lyn must not target BG1 screen 0x20234F8 on growth refresh",
        )


if __name__ == "__main__":
    unittest.main()
