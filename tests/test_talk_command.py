"""FE7 unit Talk is vanilla MakeTalkTargetList (UM_Summon blob), not $21F1C."""
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GET_TALKEE = ROOT / "EngineHacks/Necessary/ModularStatScreen/pages/GetTalkee.s"
UNIT_MENU = ROOT / "EngineHacks/Necessary/UnitMenu/UnitMenu.event"
MSS_DEFS = ROOT / "EngineHacks/Necessary/ModularStatScreen/pages/mss_defs.s"


class TalkCommandWiringTests(unittest.TestCase):
    def test_get_talkee_uses_talk_check(self):
        text = GET_TALKEE.read_text(encoding="utf-8")
        self.assertIn("0x080789FC", text)
        self.assertIn("0xBF", text)
        self.assertNotIn("0x08079910", text)
        self.assertNotIn("TalkEventsLoop", text)

    def test_unit_menu_includes_vanilla_talk_command(self):
        text = UNIT_MENU.read_text(encoding="utf-8")
        self.assertIn("UM_Summon", text)
        self.assertNotIn("ORG $21F1C", text)
        self.assertNotIn("jumpToHack(TalkCommandUsability)", text)

    def test_stat_screen_passes_character_id(self):
        text = MSS_DEFS.read_text(encoding="utf-8")
        self.assertIn("ldrb    r0, [r0, #0x4]", text)
        self.assertIn("bl      GetTalkee", text)
        self.assertIn("GetCharacterData", text)


if __name__ == "__main__":
    unittest.main()
