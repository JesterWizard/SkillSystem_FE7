"""Loyalty: nearby lord check uses character IDs (Eliwood/Hector/Lyn),
not class IDs. Lyn is character 0x2D; Blade Lord is class 0x08."""
import struct
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from Tools.thumb_harness import CODE_BASE, Harness, assemble, symbol_offsets

SRC = ROOT / "EngineHacks/SkillSystem/Skills/PreBattleSkills/Loyalty/Loyalty.s"

ATTACKER = 0x0203A3F0
DEFENDER = 0x0203A470
UNIT = 0x0203B200
CHAR = 0x0203B300
CLASS = 0x0203B400
RANGE_LIST = 0x0203B100
GET_UNIT = 0x08018D0C
NOP = 0x46C0
BX_R3 = 0x4718

DEF_OFF = 0x5C
HIT_OFF = 0x60
DEF_BASE = 10
HIT_BASE = 50


def _f800_offsets(code: bytes) -> list[int]:
    found = []
    start = 0
    while True:
        i = code.find(b"\x00\xf8", start)
        if i < 0:
            return found
        found.append(i)
        start = i + 2


def _run(char_id: int, class_id: int, skill_present: bool = True) -> tuple[int, int]:
    raw = assemble(SRC)
    offsets = symbol_offsets(SRC)
    f800s = _f800_offsets(raw)
    # 0: SkillTester (Harness), 1: GetUnitsInRange, 2: GetUnit
    patched = bytearray(raw)
    # Leave `ldr r0, UnitRangeCheck`; NOP mov lr / args / f800 so r0 stays the list pointer.
    for off in range(f800s[1] - 8, f800s[1] + 2, 2):
        patched[off : off + 2] = NOP.to_bytes(2, "little")
    # bx r3 — r3 already holds GetUnit from `ldr r3,=GetUnit`.
    patched[f800s[2] : f800s[2] + 2] = BX_R3.to_bytes(2, "little")

    h = Harness(bytes(patched), skill_present=skill_present)
    ret = (CODE_BASE + f800s[2] + 2) | 1
    # ldr r0, [pc,#4]; nop; ldr r3, [pc,#4]; bx r3; .word UNIT; .word ret
    h.seed(GET_UNIT, struct.pack("<HHHHII", 0x4801, NOP, 0x4B01, BX_R3, UNIT, ret))
    h.seed(CODE_BASE + offsets["SkillTester"] + 4, struct.pack("<I", RANGE_LIST))

    h.seed(RANGE_LIST, bytes([1, 0]))
    h.seed(UNIT + 0x00, struct.pack("<I", CHAR))
    h.seed(UNIT + 0x04, struct.pack("<I", CLASS))
    h.seed(CHAR + 0x04, bytes([char_id]))
    h.seed(CLASS + 0x04, bytes([class_id]))

    atk = bytearray(0x80)
    struct.pack_into("<H", atk, DEF_OFF, DEF_BASE)
    struct.pack_into("<H", atk, HIT_OFF, HIT_BASE)
    h.seed(ATTACKER, bytes(atk))
    h.seed(DEFENDER, bytes(0x80))

    h.run(offsets["End"], regs={"r0": ATTACKER, "r1": DEFENDER})
    defn = struct.unpack_from("<H", h.read(ATTACKER + DEF_OFF, 2))[0]
    hit = struct.unpack_from("<H", h.read(ATTACKER + HIT_OFF, 2))[0]
    return defn, hit


class LoyaltyExecutionTests(unittest.TestCase):
    def test_boost_when_main_lyn_is_blade_lord(self):
        # Reported case: Lyn (char 0x2D) in Blade Lord (class 0x08).
        defn, hit = _run(char_id=0x2D, class_id=0x08)
        self.assertEqual(defn, DEF_BASE + 3)
        self.assertEqual(hit, HIT_BASE + 15)

    def test_no_boost_when_nearby_ally_is_not_a_lord_character(self):
        defn, hit = _run(char_id=0x04, class_id=0x02)  # Raven in Lyn Lord clothes
        self.assertEqual(defn, DEF_BASE)
        self.assertEqual(hit, HIT_BASE)

    def test_no_boost_when_skill_absent(self):
        defn, hit = _run(char_id=0x2D, class_id=0x08, skill_present=False)
        self.assertEqual(defn, DEF_BASE)
        self.assertEqual(hit, HIT_BASE)

    def test_boost_for_eliwood_and_tutorial_lyn(self):
        for cid in (0x01, 0x03):
            defn, hit = _run(char_id=cid, class_id=0x0A)
            self.assertEqual((defn, hit), (DEF_BASE + 3, HIT_BASE + 15), cid)


if __name__ == "__main__":
    unittest.main()
