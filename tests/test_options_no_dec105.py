"""DEC-105: Options/shop No is vanilla FE7 text ID 0x2 (not 0x844 / 0x10EF).

FE7U 0x0001/0x0002 are Yes/No. text_buildfile used to overwrite 0x2 with the
FE8 weapon-rank popup, so Options/shop drew the wrong string.
"""
from __future__ import annotations

import struct
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CLEAN = ROOT / "FE7_clean.gba"
HACK = ROOT / "FE7_Hack.gba"
BUILDFILE = ROOT / "Text" / "text_buildfile.txt"

VANILLA_TABLE = 0xB808AC
GET_STRING_TABLE_LITERAL = 0x12C88
TREE_PTR = 0x6BC
TREE_ROOT = 0xB808A4
OPTIONS_TABLE = 0xCE58D8
OPTIONS_BLOCK = 44
TID_NO = 0x2
TID_YES = 0x1
TID_DIALOGUE_NO = 0x10EF


def u16(data: bytes, off: int) -> int:
    return struct.unpack_from("<H", data, off)[0]


def u32(data: bytes, off: int) -> int:
    return struct.unpack_from("<I", data, off)[0]


def live_table_off(rom: bytes) -> int:
    return u32(rom, GET_STRING_TABLE_LITERAL) & 0x01FFFFFF


def huffman_decode(rom: bytes, addr: int) -> bytes:
    tree_base = u32(rom, TREE_PTR) & 0x01FFFFFF
    tree_data = TREE_ROOT
    out = bytearray()
    for _ in range(20_000):
        bit = rom[addr]
        addr += 1
        for _bit in range(8):
            node = u16(rom, tree_data + (bit & 1) * 2)
            tree_data = tree_base + node * 4
            bit >>= 1
            leaf = u32(rom, tree_data)
            if leaf & 0x80000000 == 0:
                continue
            tree_data = TREE_ROOT
            code = leaf & 0xFFFF
            if code == 0 or (code & 0xFF) == 0:
                return bytes(out)
            out.append(code & 0xFF)
            hi = (code >> 8) & 0xFF
            if hi:
                out.append(hi)
    return bytes(out)


def text_payload(rom: bytes, table_off: int, tid: int) -> bytes:
    ptr = u32(rom, table_off + 4 * tid)
    off = ptr & 0x01FFFFFF
    if ptr & 0x80000000:
        end = rom.find(b"\x00", off)
        return rom[off:end]
    return huffman_decode(rom, off)


class OptionsNoSourceTests(unittest.TestCase):
    def test_buildfile_pins_id_2_as_no_not_weapon_rank(self):
        text = BUILDFILE.read_text(encoding="utf-8")
        block = text.split("#0x2", 1)[1].split("#", 1)[0]
        self.assertIn("No[X]", block)
        self.assertNotIn("Weapon rank", block)


@unittest.skipUnless(CLEAN.is_file() and HACK.is_file(), "FE7_clean.gba or FE7_Hack.gba missing")
class OptionsNoRomTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.clean = CLEAN.read_bytes()
        cls.hack = HACK.read_bytes()

    def test_vanilla_id_2_is_no(self):
        self.assertEqual(text_payload(self.clean, VANILLA_TABLE, TID_NO), b"No")

    def test_hack_id_2_is_no_like_clean(self):
        live = live_table_off(self.hack)
        self.assertEqual(text_payload(self.hack, live, TID_NO).rstrip(b"\x1f"), b"No")

    def test_dialogue_and_shop_no_ids_untouched_as_no(self):
        live = live_table_off(self.hack)
        self.assertEqual(
            text_payload(self.hack, live, TID_DIALOGUE_NO).rstrip(b"\x1f"), b"No"
        )
        self.assertEqual(text_payload(self.hack, live, TID_YES).rstrip(b"\x1f"), b"Yes")

    def test_options_table_not_rewritten(self):
        n = 16 * OPTIONS_BLOCK
        self.assertEqual(
            self.hack[OPTIONS_TABLE : OPTIONS_TABLE + n],
            self.clean[OPTIONS_TABLE : OPTIONS_TABLE + n],
        )


if __name__ == "__main__":
    unittest.main()
