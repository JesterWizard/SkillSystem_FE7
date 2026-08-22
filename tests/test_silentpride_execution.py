"""Silent Pride: +2 atk and +2 def per 25% HP missing, capped at 3 stacks."""
import struct
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from Tools.thumb_harness import Harness, assemble, symbol_offsets

SRC = ROOT / "EngineHacks/SkillSystem/Skills/PreBattleSkills/SilentPride/SilentPride.s"

ATTACKER = 0x0203A3F0
DEFENDER = 0x0203A470
ATK_OFF = 0x5A
DEF_OFF = 0x5C
ATK_BASE = 10
DEF_BASE = 8


def _run(max_hp: int, cur_hp: int, skill_present: bool = True) -> tuple[int, int]:
    raw = assemble(SRC)
    offsets = symbol_offsets(SRC)
    h = Harness(raw, skill_present=skill_present)
    atk = bytearray(0x80)
    atk[0x12] = max_hp
    atk[0x13] = cur_hp
    struct.pack_into("<H", atk, ATK_OFF, ATK_BASE)
    struct.pack_into("<H", atk, DEF_OFF, DEF_BASE)
    h.seed(ATTACKER, bytes(atk))
    h.seed(DEFENDER, bytes(0x80))
    h.run(offsets["End"], regs={"r0": ATTACKER, "r1": DEFENDER})
    attack = struct.unpack_from("<H", h.read(ATTACKER + ATK_OFF, 2))[0]
    defense = struct.unpack_from("<H", h.read(ATTACKER + DEF_OFF, 2))[0]
    return attack, defense


class SilentPrideExecutionTests(unittest.TestCase):
    def test_one_stack_when_hp_reduced_by_exactly_25_percent(self):
        # Reported case: 12/16 is 25% below max.
        atk, defn = _run(16, 12)
        self.assertEqual(atk, ATK_BASE + 2)
        self.assertEqual(defn, DEF_BASE + 2)

    def test_one_stack_when_missing_hp_times_4_meets_max(self):
        # 14/19 is ~26% missing; floor(max/4) buckets skip this band.
        atk, defn = _run(19, 14)
        self.assertEqual(atk, ATK_BASE + 2)
        self.assertEqual(defn, DEF_BASE + 2)

    def test_no_stack_just_above_25_percent_missing(self):
        atk, defn = _run(16, 13)
        self.assertEqual((atk, defn), (ATK_BASE, DEF_BASE))

    def test_two_and_three_stacks_at_half_and_quarter_remaining(self):
        self.assertEqual(_run(16, 8), (ATK_BASE + 4, DEF_BASE + 4))
        self.assertEqual(_run(16, 4), (ATK_BASE + 6, DEF_BASE + 6))

    def test_no_boost_at_full_hp_or_without_skill(self):
        self.assertEqual(_run(16, 16), (ATK_BASE, DEF_BASE))
        self.assertEqual(_run(16, 12, skill_present=False), (ATK_BASE, DEF_BASE))


if __name__ == "__main__":
    unittest.main()
