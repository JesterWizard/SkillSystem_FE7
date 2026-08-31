"""Hero: at HP <= 50%, +30 to the skill activation chance passed in r0."""
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from Tools.thumb_harness import Harness, assemble, symbol_offsets

SRC = ROOT / "EngineHacks/SkillSystem/Skills/ActivationRateSkills/Hero/Hero.s"

UNIT = 0x02000000
UNIT_MAXHP, UNIT_CURHP = 0x12, 0x13
CHANCE = 40
BONUS = 30


def _run(cur_hp: int, max_hp: int, skill_present: bool = True, chance: int = CHANCE) -> int:
    raw = assemble(SRC)
    offsets = symbol_offsets(SRC)
    h = Harness(raw, skill_present=skill_present)
    buf = bytearray(0x20)
    buf[UNIT_MAXHP] = max_hp
    buf[UNIT_CURHP] = cur_hp
    h.seed(UNIT, bytes(buf))
    return h.run(offsets["GotResult"], regs={"r0": chance, "r1": UNIT})["r0"]


class HeroExecutionTests(unittest.TestCase):
    def test_bonus_at_exactly_half_hp(self):
        self.assertEqual(_run(8, 16), CHANCE + BONUS)

    def test_bonus_one_below_half(self):
        self.assertEqual(_run(7, 16), CHANCE + BONUS)

    def test_no_bonus_one_above_half(self):
        self.assertEqual(_run(9, 16), CHANCE)

    def test_no_bonus_at_full_hp(self):
        self.assertEqual(_run(16, 16), CHANCE)

    def test_no_bonus_without_the_skill(self):
        self.assertEqual(_run(8, 16, skill_present=False), CHANCE)
        self.assertEqual(_run(0, 16, skill_present=False), CHANCE)


if __name__ == "__main__":
    unittest.main()
