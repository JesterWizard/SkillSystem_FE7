"""Regression: FE7 chapter table entries are 152 bytes (0x98), not 148."""
import struct
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
HACK = ROOT / "FE7_Hack.gba"
CHAPTER_TABLE = 0xC9A200
ENTRY_SIZE = 0x98


class ChapterDataStrideTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        if not HACK.is_file():
            raise unittest.SkipTest("FE7_Hack.gba missing; run MAKE_HACK_quick.cmd")
        cls.rom = HACK.read_bytes()

    def test_chapter_four_event_pointer(self):
        off = CHAPTER_TABLE + 4 * ENTRY_SIZE
        event_ptr = struct.unpack_from("<I", self.rom, off)[0]
        self.assertEqual(event_ptr, 0x083B8C84)

    def test_lyn_chapters_use_vanilla_event_roots(self):
        expected = [
            0x083B8CA4,  # Prologue
            0x083B8C9C,  # Ch. 1
            0x083B8C94,  # Ch. 2
            0x083B8C8C,  # Ch. 3
            0x083B8C84,  # Ch. 4
        ]
        for idx, ptr in enumerate(expected):
            off = CHAPTER_TABLE + idx * ENTRY_SIZE
            got = struct.unpack_from("<I", self.rom, off)[0]
            self.assertEqual(got, ptr, f"chapter index {idx}")


if __name__ == "__main__":
    unittest.main()
