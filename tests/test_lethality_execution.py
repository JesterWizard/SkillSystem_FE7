"""Lethality pre-battle rate and NonGBA skill/2 encoding.

Normal store is 0x32 (50); NonGBA turns that into 0xFE so proc uses Skill/2
without requiring a crit. A stored 100 is still passed through as a percent.
"""
import struct
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from Tools.thumb_harness import Harness, assemble, symbol_offsets

PRE = ROOT / "EngineHacks/SkillSystem/Skills/PreBattleSkills/Lethality/LethalitySkill.s"
NON_GBA = ROOT / "EngineHacks/SkillSystem/Skills/PreBattleSkills/Lethality/NonGBALethalitySkill.s"
PROC = ROOT / "EngineHacks/SkillSystem/Skills/ProcSkills/Lethality/proc_lethality.s"

ATTACKER = 0x0203A3F0
DEFENDER = 0x0203A470
BUFFER = 0x0203A600
BATTLE_DATA = 0x0203A700
RATE_OFF = 0x6C
SILENCER = 0x800
SKILL_FLAG = 0x4000


def _run_pre(skill_present: bool) -> int:
    code = assemble(PRE)
    offsets = symbol_offsets(PRE)
    h = Harness(code, skill_present=skill_present)
    h.seed(ATTACKER, bytes(0x80))
    h.seed(DEFENDER, bytes(0x80))
    h.run(offsets["GoBack"], regs={"r4": ATTACKER, "r5": DEFENDER})
    return h.read(ATTACKER + RATE_OFF, 1)[0]


def _run_nongba(stored: int) -> int:
    code = assemble(NON_GBA)
    offsets = symbol_offsets(NON_GBA)
    h = Harness(code)
    buf = bytearray(0x80)
    buf[RATE_OFF] = stored
    h.seed(ATTACKER, bytes(buf))
    h.run(offsets["GoBack"], regs={"r4": ATTACKER, "r5": DEFENDER})
    return h.read(ATTACKER + RATE_OFF, 1)[0]


def _run_proc(rate: int, hit_word: int = 0) -> tuple[int, int]:
    code = assemble(PROC)
    offsets = symbol_offsets(PROC)
    h = Harness(code)
    atk = bytearray(0x80)
    atk[RATE_OFF] = rate
    h.seed(ATTACKER, bytes(atk))
    h.seed(DEFENDER, bytes(0x80))
    h.seed(BUFFER, struct.pack("<I", hit_word))
    h.seed(BATTLE_DATA, bytes(0x10))
    h.run(
        offsets["End"],
        regs={
            "r0": ATTACKER,
            "r1": DEFENDER,
            "r2": BUFFER,
            "r3": BATTLE_DATA,
        },
    )
    word = struct.unpack("<I", h.read(BUFFER, 4))[0]
    dmg = struct.unpack("<H", h.read(BATTLE_DATA + 4, 2))[0]
    return word, dmg


class LethalityExecutionTests(unittest.TestCase):
    def test_prebattle_stores_50_when_skill_present(self):
        self.assertEqual(_run_pre(True), 0x32)

    def test_prebattle_stores_0_when_skill_absent(self):
        self.assertEqual(_run_pre(False), 0)

    def test_nongba_preserves_100_percent(self):
        self.assertEqual(_run_nongba(100), 100)

    def test_nongba_encodes_skill_over_2_when_rate_is_50(self):
        self.assertEqual(_run_nongba(0x32), 0xFE)

    def test_nongba_leaves_zero_alone(self):
        self.assertEqual(_run_nongba(0), 0)

    def test_proc_100_percent_silences_on_a_non_crit_hit(self):
        word, dmg = _run_proc(100, hit_word=0)
        self.assertTrue(word & SILENCER, f"silencer flag missing, buffer={word:#x}")
        self.assertTrue(word & SKILL_FLAG, f"skill flag missing, buffer={word:#x}")
        self.assertEqual(dmg, 0x7F)

    def test_proc_zero_rate_does_not_silence(self):
        word, dmg = _run_proc(0, hit_word=0)
        self.assertFalse(word & SILENCER)
        self.assertEqual(dmg, 0)


if __name__ == "__main__":
    unittest.main()
