"""Verify DEC-61 expanded convoy patches against a built SkillsTest.gba (or FE7_clean baseline)."""
from __future__ import annotations

import struct
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CLEAN = ROOT / "FE7_clean.gba"
BUILT = ROOT / "FE7_Hack.gba"
if not BUILT.exists():
    BUILT = ROOT / "SkillsTest.gba"

CONVOY_RAM = 0x0203B200
SIZE_SITES_C7 = [
    0x2E74C,
    0x2E7B8,
    0x2E808,
    0x17000,
    0x17030,
    0x1708C,
    0x1D7CA,
    0x1D812,
    0x1D872,
    0x1D904,
    0x911E2,
    0x91266,
    0x92F20,
    0x92F3A,
    0xB0C08,
]
SIZE_SITES_C8 = [0x972AA, 0xAD58C, 0x95FFE, 0x960C2, 0x960EC]
POINTER_SITES = [0x2E704, 0x2E724, 0x2E78C, 0x2E7B0, 0x2E7DC, 0x2E800]
SUSPEND_SHIFTS = {
    0xA1234: 0x1FE4,
    0xA1238: 0x1FEC,
    0xA1240: 0x1AB4,
    0xA1244: 0x1F14,
    0xA124C: 0x1FD4,
    0xA1368: 0x1AB4,
    0xA136C: 0x1F14,
    0xA1374: 0x1FE4,
    0xA1378: 0x1FEC,
    0xA1380: 0x1FD4,
}


class TestExpandedConvoy(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.rom_path = BUILT if BUILT.exists() else CLEAN
        cls.rom = cls.rom_path.read_bytes()
        cls.is_built = cls.rom_path == BUILT

    def test_vanilla_baseline_or_patched(self):
        if not self.is_built:
            # Clean ROM still has 100-item convoy at 0x203A720.
            self.assertEqual(struct.unpack_from("<I", self.rom, 0x2E704)[0], 0x0203A720)
            self.assertEqual(self.rom[0x2E7B8], 0x63)
            self.skipTest("SkillsTest.gba not built yet; baseline only")
        for off in POINTER_SITES:
            self.assertEqual(
                struct.unpack_from("<I", self.rom, off)[0],
                CONVOY_RAM,
                f"pointer @ {off:#x}",
            )
        for off in SIZE_SITES_C7:
            self.assertEqual(self.rom[off], 0xC7, f"size-1 @ {off:#x}")
        for off in SIZE_SITES_C8:
            self.assertEqual(self.rom[off], 0xC8, f"size @ {off:#x}")
        self.assertEqual(struct.unpack_from("<I", self.rom, 0x2E728)[0], 0x010000C8)
        # GetConvoyItemCount replaced with sanitize+count hook
        self.assertNotEqual(self.rom[0x2E770:0x2E770 + 2], b"\x23\x00")
        for off, val in SUSPEND_SHIFTS.items():
            self.assertEqual(
                struct.unpack_from("<I", self.rom, off)[0],
                val,
                f"suspend offset @ {off:#x}",
            )


if __name__ == "__main__":
    unittest.main()
