"""Rescue crashes because FE8 ApplyUnitAction is patched into FE7's
rescue info-window routine (StartUnitRescueInfoWindowsCore at 0x08031FFC).

Selecting Rescue starts target select, which runs that routine.  FE8's
ApplyUnitAction lives at 0x0803200C — 16 bytes into the FE7 function.
"""
from __future__ import annotations

import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
HACK = ROOT / "FE7_Hack.gba"
CLEAN = ROOT / "FE7_clean.gba"
# FE7U StartUnitRescueInfoWindowsCore .. RefreshUnitRescueInfoWindows
RESCUE_INFO_WINDOWS = 0x31FFC
RESCUE_INFO_WINDOWS_END = 0x32064
FE8_APPLY_UNIT_ACTION = 0x3200C
ACTION_REWORK = (
    ROOT
    / "EngineHacks"
    / "Necessary"
    / "UnitActionRework"
    / "UnitActionRework.event"
)


class RescueFe7CrashTests(unittest.TestCase):
    def test_action_rework_does_not_org_fe8_applyunitaction(self):
        text = ACTION_REWORK.read_text(encoding="utf-8")
        self.assertNotIn("ORG 0x3200C", text)
        self.assertNotIn("ORG $3200C", text)

    def test_rescue_info_windows_are_not_clobbered(self):
        if not HACK.exists() or not CLEAN.exists():
            self.skipTest("requires FE7_Hack.gba and FE7_clean.gba")

        hack = HACK.read_bytes()
        clean = CLEAN.read_bytes()
        self.assertEqual(
            hack[RESCUE_INFO_WINDOWS:RESCUE_INFO_WINDOWS_END],
            clean[RESCUE_INFO_WINDOWS:RESCUE_INFO_WINDOWS_END],
            f"FE8 ApplyUnitAction ORG ${FE8_APPLY_UNIT_ACTION:X} overwrote "
            "FE7 StartUnitRescueInfoWindowsCore",
        )


if __name__ == "__main__":
    unittest.main()
