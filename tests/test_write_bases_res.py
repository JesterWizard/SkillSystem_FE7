"""DEC-115: Mag-split UnitLoadStatsFromCharacter must write class+char Res.

ColorzCore callHack_r3 at 0x17958 is 12 bytes, so it overwrites the vanilla
Res loads (char+0x11 / class+0x10). WriteBasestoRAM already stores Def; it
must also store Res and resume at 0x08017968 (Luck), or generic enemies
(char bases 0, class Res nonzero) load with Resistance 0.
"""
import struct
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from Tools.thumb_harness import Harness, assemble, symbol_offsets

SRC = (
    ROOT
    / "EngineHacks"
    / "ExternalHacks"
    / "StrMagSplit"
    / "StrMagSplit"
    / "AutolevellingSaves"
    / "WriteBasestoRAM.s"
)
DMP = SRC.with_suffix(".dmp")

UNIT = 0x02010000
CHAR = 0x02011000
CLASS = 0x02012000
MAG_CHAR = 0x02013000
MAG_CLASS = 0x02014000
RESUME = 0x08017968  # vanilla Luck store after the callHack pool

CHAR_NUM = 1
CLASS_NUM = 1
CHAR_DEF, CHAR_RES, CHAR_MAG = 2, 3, 7
CLASS_DEF, CLASS_RES, CLASS_MAG = 4, 5, 9


def _run():
    raw = assemble(SRC)
    off = symbol_offsets(SRC)["MagCharTable"]
    code = bytearray(raw)
    if len(code) < off + 8:
        code.extend(b"\x00" * (off + 8 - len(code)))
    struct.pack_into("<II", code, off, MAG_CHAR, MAG_CLASS)

    h = Harness(bytes(code))
    h.seed(UNIT, b"\x00" * 0x50)
    char = bytearray(0x20)
    char[4] = CHAR_NUM
    char[0x10] = CHAR_DEF
    char[0x11] = CHAR_RES
    h.seed(CHAR, bytes(char))
    cls = bytearray(0x20)
    cls[4] = CLASS_NUM
    cls[0x0F] = CLASS_DEF
    cls[0x10] = CLASS_RES
    h.seed(CLASS, bytes(cls))
    mag_char = bytearray(0x10)
    mag_char[CHAR_NUM * 2] = CHAR_MAG
    h.seed(MAG_CHAR, bytes(mag_char))
    mag_class = bytearray(0x10)
    mag_class[CLASS_NUM * 4] = CLASS_MAG
    h.seed(MAG_CLASS, bytes(mag_class))
    h.map_page(RESUME, 4)
    h.seed(RESUME, b"\xc0\x46")

    h.run(RESUME - 0x08000000, regs={
        "r1": CHAR,
        "r2": CLASS,
        "r4": UNIT,
        "lr": RESUME | 1,
    })
    return h


class WriteBasesResTests(unittest.TestCase):
    def test_stores_class_plus_char_resistance(self):
        h = _run()
        self.assertEqual(h.read(UNIT + 0x18, 1)[0], CHAR_RES + CLASS_RES)
        self.assertEqual(h.read(UNIT + 0x17, 1)[0], CHAR_DEF + CLASS_DEF)
        self.assertEqual(h.read(UNIT + 0x47, 1)[0], CHAR_MAG + CLASS_MAG)

    def test_dmp_stores_resistance(self):
        data = DMP.read_bytes()
        # strb r0, [r4, #0x18] encodes as 0x7620
        self.assertIn(b"\x20\x76", data)


if __name__ == "__main__":
    unittest.main()
