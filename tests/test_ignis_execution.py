"""Ignis: on proc, add (Def/2 + Res/2) to round damage, x3 on crit, cap 127."""
import struct
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from Tools.thumb_harness import Harness, assemble, symbol_offsets

SRC = ROOT / "EngineHacks/SkillSystem/Skills/ProcSkills/Ignis/proc_ignis.s"

ATTACKER = 0x0203A3F0
DEFENDER = 0x0203A470
BUFFER = 0x0203A600
BATTLE_DATA = 0x0203A700

D100 = 0x0802857C
DEF_GETTER = 0x08018B70
RES_GETTER = 0x08018B90

SKILL_FLAG = 0x4000
MISS = 0x2
DEFENDER_SKILL = 0x8000


def _intercept(skill, proc, defense, resist):
    def intercept(lr, r0, r1):
        target = lr & ~1
        if target == D100:
            return 1 if proc else 0
        if target == DEF_GETTER:
            return defense
        if target == RES_GETTER:
            return resist
        return 1 if skill else 0
    return intercept


def _run(*, skill=True, proc=True, defense=10, resist=8, dmg=10, bufword=0):
    raw = assemble(SRC)
    offsets = symbol_offsets(SRC)
    h = Harness(raw, intercept_calls=_intercept(skill, proc, defense, resist))
    atk = bytearray(0x80)
    atk[0x15] = 40
    h.seed(ATTACKER, bytes(atk))
    h.seed(DEFENDER, bytes(0x80))
    h.seed(BUFFER, struct.pack("<I", bufword))
    bd = bytearray(0x10)
    struct.pack_into("<h", bd, 4, dmg)
    h.seed(BATTLE_DATA, bytes(bd))
    h.run(
        offsets["End"],
        regs={"r0": ATTACKER, "r1": DEFENDER, "r2": BUFFER, "r3": BATTLE_DATA},
    )
    word = struct.unpack("<I", h.read(BUFFER, 4))[0]
    out = struct.unpack("<h", h.read(BATTLE_DATA + 4, 2))[0]
    return word, out


class IgnisExecutionTests(unittest.TestCase):
    def test_adds_half_def_plus_half_res_on_proc(self):
        word, dmg = _run()
        self.assertTrue(word & SKILL_FLAG)
        self.assertEqual(dmg, 10 + 5 + 4)

    def test_odd_stats_floor_each_half_separately(self):
        _, dmg = _run(defense=5, resist=5, dmg=10)
        self.assertEqual(dmg, 10 + 2 + 2)

    def test_crit_triples_the_bonus(self):
        word, dmg = _run(bufword=1)
        self.assertTrue(word & SKILL_FLAG)
        self.assertEqual(dmg, 10 + (5 + 4) * 3)

    def test_no_bonus_without_the_skill(self):
        word, dmg = _run(skill=False)
        self.assertFalse(word & SKILL_FLAG)
        self.assertEqual(dmg, 10)

    def test_no_bonus_when_the_roll_fails(self):
        word, dmg = _run(proc=False)
        self.assertFalse(word & SKILL_FLAG)
        self.assertEqual(dmg, 10)

    def test_miss_does_not_proc(self):
        word, dmg = _run(bufword=MISS)
        self.assertFalse(word & SKILL_FLAG)
        self.assertEqual(dmg, 10)

    def test_already_activated_skill_does_not_proc(self):
        word, dmg = _run(bufword=SKILL_FLAG)
        self.assertEqual(word, SKILL_FLAG)
        self.assertEqual(dmg, 10)
        word, dmg = _run(bufword=DEFENDER_SKILL)
        self.assertEqual(word, DEFENDER_SKILL)
        self.assertEqual(dmg, 10)

    def test_damage_caps_at_127(self):
        _, dmg = _run(defense=40, resist=40, dmg=120)
        self.assertEqual(dmg, 127)


if __name__ == "__main__":
    unittest.main()
