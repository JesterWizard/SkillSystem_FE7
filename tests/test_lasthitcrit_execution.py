"""Last remaining weapon use sets battle crit to 100."""
import struct
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from Tools.thumb_harness import Harness, assemble, symbol_offsets

SRC = ROOT / "EngineHacks/SkillSystem/Skills/PreBattleSkills/LastHitCrit/LastHitCrit.s"
LOOP = ROOT / "EngineHacks/Necessary/CalcLoops/PreBattleCalcLoop/PreBattleCalcLoop.event"
CONFIG = ROOT / "EngineHacks/Config.event"

ATTACKER = 0x0203A3F0
DEFENDER = 0x0203A470
WEAPON_OFF = 0x48
CRIT_OFF = 0x66
CRIT_BASE = 10
LAST_HIT_CRIT = 100


def _weapon(item_id: int, uses: int) -> int:
    return (uses << 8) | item_id


def _run(uses: int, crit: int = CRIT_BASE) -> int:
    raw = assemble(SRC)
    offsets = symbol_offsets(SRC)
    h = Harness(raw)
    atk = bytearray(0x80)
    struct.pack_into("<H", atk, WEAPON_OFF, _weapon(0x01, uses))
    struct.pack_into("<H", atk, CRIT_OFF, crit)
    h.seed(ATTACKER, bytes(atk))
    h.seed(DEFENDER, bytes(0x80))
    h.run(offsets["End"], regs={"r0": ATTACKER, "r1": DEFENDER})
    return struct.unpack_from("<H", h.read(ATTACKER + CRIT_OFF, 2))[0]


class LastHitCritExecutionTests(unittest.TestCase):
    def test_one_use_sets_crit_to_100(self):
        self.assertEqual(_run(1), LAST_HIT_CRIT)

    def test_two_uses_leaves_crit_unchanged(self):
        self.assertEqual(_run(2), CRIT_BASE)

    def test_zero_uses_leaves_crit_unchanged(self):
        self.assertEqual(_run(0), CRIT_BASE)

    def test_config_toggle_exists(self):
        text = CONFIG.read_text(encoding="utf-8")
        self.assertRegex(text, r"(?m)^#define LAST_HIT_CRIT\b")

    def test_prebattle_loop_calls_lasthitcrit(self):
        text = LOOP.read_text(encoding="utf-8")
        self.assertRegex(text, r"#ifdef LAST_HIT_CRIT\s+POIN LastHitCrit")


if __name__ == "__main__":
    unittest.main()
