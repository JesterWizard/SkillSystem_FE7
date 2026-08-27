"""Regression coverage for the FE7 StealPlus crash-site patch."""
from __future__ import annotations

import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
HACK = ROOT / "FE7_Hack.gba"
CLEAN = ROOT / "FE7_clean.gba"
CRASH_OFFSET = 0x2435C
TERRAIN_LOOKUP_OFFSET = 0x2432A
FE8_STEAL_ORGS = (
    0x17054,
    0x24190,
    0x2432A,
    0x2435C,
    0x25BCC,
    0x34D9A,
    0x3DB70,
    0x3DC0C,
    0x3DC66,
    0x3D4C4,
    0x3EE56,
)


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

    def test_fe8_steal_orgs_do_not_clobber_fe7(self):
        if not HACK.exists() or not CLEAN.exists():
            self.skipTest("requires FE7_Hack.gba and FE7_clean.gba")

        hack = HACK.read_bytes()
        clean = CLEAN.read_bytes()
        for off in FE8_STEAL_ORGS:
            self.assertEqual(
                hack[off : off + 4],
                clean[off : off + 4],
                f"FE8 Steal ORG ${off:X} overwrote FE7 ROM",
            )


if __name__ == "__main__":
    unittest.main()
