"""Leaving the unit stat screen must keep the map cursor on that unit.

FE7 StatScreen_BackUpStatus (0x08081408) saves unit->index to gStatScreenInfo.
Player phase then SetCursorMapPosition's that unit. The Store_Page callHack
replaces the ldr that put StatScreenStruct in r2; leftover vanilla still does
ldr r0, [r2, #0xC] / strb index. If Store_Page leaves r2 unset, the saved id
is 0 and the cursor goes to 0,0.
"""
import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
STORE_S = (
    ROOT
    / "EngineHacks"
    / "Necessary"
    / "ModularStatScreen"
    / "asm"
    / "StorePage.s"
)
STORE_DMP = STORE_S.with_suffix(".dmp")
MSS_EVENT = (
    ROOT / "EngineHacks" / "Necessary" / "ModularStatScreen" / "ModularStatScreen.event"
)

STAT_SCREEN_STRUCT = 0x0200310C


class StatScreenCursorTests(unittest.TestCase):
    def test_store_page_sets_r2_to_stat_screen_struct(self):
        src = STORE_S.read_text(encoding="utf-8")
        self.assertRegex(
            src,
            r"ldr\s+r2\s*,\s*StatScreenStruct",
            "Store_Page must put StatScreenStruct in r2 for leftover ldr r0, [r2, #0xC]",
        )
        self.assertIsNone(
            re.search(r"ldr\s+r3\s*,\s*StatScreenStruct", src),
            "r3 must stay ChapterData for leftover strb r1, [r3, #0x14]",
        )

    def test_dmp_literal_is_fe7_stat_screen_struct(self):
        data = STORE_DMP.read_bytes()
        self.assertIn(
            STAT_SCREEN_STRUCT.to_bytes(4, "little"),
            data,
        )
        # ldr r2, [pc, #imm] is 0x4Axx; ldr r3, [pc, #imm] is 0x4Bxx.
        self.assertTrue(
            any(b == 0x4A for b in data[:20]),
            "dmp must ldr StatScreenStruct into r2",
        )
        self.assertFalse(
            any(b == 0x4B for b in data[:20]),
            "dmp must not ldr StatScreenStruct into r3",
        )

    def test_store_page_hook_is_backup_status(self):
        text = MSS_EVENT.read_text(encoding="utf-8")
        self.assertIn("ORG $81414", text)
        self.assertIn("callHack_r3(Store_Page)", text)


if __name__ == "__main__":
    unittest.main()
