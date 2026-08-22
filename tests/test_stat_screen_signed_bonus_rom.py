"""DrawSignedBonusNumber must actually reach FE7_Hack.gba at the vanilla
DrawStatScreenBonusNumber site (0x08006240). DrawBar calls that address for
the small +/- next to every core stat; leaving the original bytes there is
how Fortress Defense's -3 printed as a green '+7'.
"""
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

CLEAN_ROM = ROOT / "FE7_clean.gba"
HACK_ROM = ROOT / "FE7_Hack.gba"
MSS_DIR = ROOT / "EngineHacks" / "Necessary" / "ModularStatScreen"
SIGNED_SRC = MSS_DIR / "pages" / "signed_bonus_number.s"
MSS_EVENT = MSS_DIR / "ModularStatScreen.event"

DRAW_STAT_SCREEN_BONUS_NUMBER = 0x08006240
VANILLA_PUSH = bytes.fromhex("30 b5")  # push {r4, r5, lr}
JUMP_TO_HACK = bytes.fromhex("00 4b 18 47")


class SignedBonusNumberInRomTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        if not HACK_ROM.is_file():
            raise unittest.SkipTest("FE7_Hack.gba not built")
        try:
            from Tools.thumb_harness import AS, assemble
        except ImportError as exc:
            raise unittest.SkipTest(f"thumb_harness unavailable: {exc}")
        if not AS.is_file():
            raise unittest.SkipTest(f"devkitARM assembler not found at {AS}")
        cls.hack = HACK_ROM.read_bytes()
        cls.helpers = assemble(SIGNED_SRC)

    def test_drawbar_bonus_call_is_hooked(self):
        off = DRAW_STAT_SCREEN_BONUS_NUMBER & 0x01FFFFFF
        self.assertEqual(self.hack[off:off + 4], JUMP_TO_HACK)
        if CLEAN_ROM.is_file():
            clean = CLEAN_ROM.read_bytes()
            self.assertEqual(clean[off:off + 2], VANILLA_PUSH)

    def test_signed_routine_is_installed_once(self):
        self.assertTrue(self.helpers, "signed_bonus_number.s assembled to nothing")
        self.assertEqual(self.hack.count(self.helpers), 1)

    def test_installer_includes_the_lyn_event(self):
        text = MSS_EVENT.read_text(encoding="utf-8")
        self.assertIn("signed_bonus_number.lyn.event", text)
        self.assertIn("jumpToHack(DrawSignedBonusNumber)", text)


if __name__ == "__main__":
    unittest.main()
