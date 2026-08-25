"""Regression coverage for the FE7 StealPlus crash-site patch."""
from __future__ import annotations

import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
HACK = ROOT / "FE7_Hack.gba"
CLEAN = ROOT / "FE7_clean.gba"
CRASH_OFFSET = 0x2435C
TERRAIN_LOOKUP_OFFSET = 0x2432A


class StealPlusFe7CrashTests(unittest.TestCase):
    def test_steal_plus_does_not_replace_fe7_terrain_lookup(self):
        if not HACK.exists() or not CLEAN.exists():
            self.skipTest("requires FE7_Hack.gba and FE7_clean.gba")

        hack = HACK.read_bytes()
        clean = CLEAN.read_bytes()
        self.assertEqual(
            hack[TERRAIN_LOOKUP_OFFSET : TERRAIN_LOOKUP_OFFSET + 6],
            clean[TERRAIN_LOOKUP_OFFSET : TERRAIN_LOOKUP_OFFSET + 6],
        )

    def test_steal_plus_does_not_split_vanilla_call_at_crash_site(self):
        if not HACK.exists() or not CLEAN.exists():
            self.skipTest("requires FE7_Hack.gba and FE7_clean.gba")

        hack = HACK.read_bytes()
        clean = CLEAN.read_bytes()
        self.assertEqual(
            hack[CRASH_OFFSET : CRASH_OFFSET + 4],
            clean[CRASH_OFFSET : CRASH_OFFSET + 4],
        )


if __name__ == "__main__":
    unittest.main()
