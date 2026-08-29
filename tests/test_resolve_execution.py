"""Resolve: when HP < 50%, 1.5x Str/Skl/Spd. Assembled Thumb under Unicorn."""
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from Tools.thumb_harness import Harness, assemble, symbol_offsets

SRC = ROOT / "EngineHacks/SkillSystem/Skills/StatModifierSkills/Resolve/Resolve.s"

UNIT = 0x02000000
UNIT_MAXHP, UNIT_CURHP = 0x12, 0x13
BASE = 10


def _run(cur_hp: int, max_hp: int, skill_present: bool = True, base: int = BASE) -> int:
    raw = assemble(SRC)
    offsets = symbol_offsets(SRC)
    h = Harness(raw, skill_present=skill_present)
    h.seed(UNIT + UNIT_MAXHP, bytes([max_hp]))
    h.seed(UNIT + UNIT_CURHP, bytes([cur_hp]))
    regs = h.run(offsets["GotResult"], regs={"r0": base, "r1": UNIT})
    return regs["r0"]


class ResolveExecutionTests(unittest.TestCase):
    def test_boost_when_hp_strictly_below_half(self):
        self.assertEqual(_run(7, 16), 15)
        self.assertEqual(_run(1, 16), 15)

    def test_no_boost_at_half_or_above(self):
        self.assertEqual(_run(8, 16), BASE)
        self.assertEqual(_run(9, 16), BASE)
        self.assertEqual(_run(16, 16), BASE)

    def test_odd_stat_floors_after_three_halves(self):
        self.assertEqual(_run(7, 16, base=11), 16)

    def test_no_boost_without_the_skill(self):
        self.assertEqual(_run(7, 16, skill_present=False), BASE)


if __name__ == "__main__":
    unittest.main()
