"""Execute Aptitude.s under a real Thumb CPU emulator.

Asserts r5 (growth so far) becomes +20 exactly when SkillTester returns
present, and is unchanged when the skill is absent. Skill lookup is stubbed
by the harness; this isolates the add, not whether a unit owns Aptitude.
"""
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from Tools.thumb_harness import Harness, assemble, symbol_offsets

SRC = ROOT / "EngineHacks/SkillSystem/Skills/GrowthSkills/Aptitude/Aptitude.s"
UNIT = 0x02000000
BASE_GROWTH = 40
APTITUDE_BONUS = 20


def _run(growth: int, skill_present: bool) -> int:
    code = assemble(SRC)
    offsets = symbol_offsets(SRC)
    h = Harness(code, skill_present=skill_present)
    h.seed(UNIT, b"\x00")
    regs = h.run(offsets["End"], regs={"r4": UNIT, "r5": growth})
    return regs["r5"]


class AptitudeExecutionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        try:
            assemble(SRC)
        except Exception as exc:
            raise unittest.SkipTest(f"thumb harness unavailable: {exc}")

    def test_skill_present_adds_twenty(self):
        self.assertEqual(_run(BASE_GROWTH, skill_present=True), BASE_GROWTH + APTITUDE_BONUS)

    def test_skill_absent_leaves_growth_unchanged(self):
        self.assertEqual(_run(BASE_GROWTH, skill_present=False), BASE_GROWTH)

    def test_zero_growth_still_adds_twenty(self):
        self.assertEqual(_run(0, skill_present=True), APTITUDE_BONUS)
        self.assertEqual(_run(0, skill_present=False), 0)


if __name__ == "__main__":
    unittest.main()
