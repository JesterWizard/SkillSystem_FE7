"""Luna pierce damage must land on FE7 hit.hpChange so the anim HP bar ticks.

BattleGenerateHitEffects copies gBattleStats.damage to hit+3, but the LUT and
AnimNumbers read that byte. A proc that only updates battle_data+4 leaves the
bar on the pre-pierce value; the real HP then snaps after the anim.
"""
import struct
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from Tools.thumb_harness import Harness, assemble, symbol_offsets

LUNA_SRC = ROOT / "EngineHacks/SkillSystem/Skills/ProcSkills/Luna/proc_luna.s"
FINISH_SRC = (
    ROOT
    / "EngineHacks/Necessary/CalcLoops/BattleProcCalcLoop/ProcFinish/proc_finish.s"
)
KEEP_SRC = (
    ROOT
    / "EngineHacks/Necessary/CalcLoops/BattleProcCalcLoop/LifeSteal/keep_hpchange.s"
)

ACTOR = 0x0203A3F0
TARGET = 0x0203A470
BUFFER = 0x0203A600
BATTLE_DATA = 0x0203A3D8
D100 = 0x0802857C
SKILL_ATTR = 0x4000
HPSTEAL = 0x100
MISS = 0x2
CRIT = 0x1


def _run_luna(*, skill=True, roll=1, mt=20, damage=7, hit_word=0):
    def intercept(lr, r0, r1):
        if (lr & ~1) == D100:
            return roll
        return 1 if skill else 0

    code = assemble(LUNA_SRC)
    offsets = symbol_offsets(LUNA_SRC)
    h = Harness(code, intercept_calls=intercept)
    atk = bytearray(0x80)
    atk[0x15] = 100
    h.seed(ACTOR, bytes(atk))
    h.seed(TARGET, bytes(bytearray(0x80)))
    h.seed(BUFFER, struct.pack("<I", hit_word) + b"\x00\x00\x00\x00")
    stats = bytearray(0x10)
    struct.pack_into("<h", stats, 4, damage)
    struct.pack_into("<h", stats, 6, mt)
    h.seed(BATTLE_DATA, bytes(stats))
    h.run(
        offsets["End"],
        regs={"r0": ACTOR, "r1": TARGET, "r2": BUFFER, "r3": BATTLE_DATA},
    )
    out_word = struct.unpack("<I", h.read(BUFFER, 4))[0]
    out_change = struct.unpack("<b", h.read(BUFFER + 3, 1))[0]
    out_dmg = struct.unpack("<h", h.read(BATTLE_DATA + 4, 2))[0]
    next_attr = h.read(BUFFER + 4, 1)[0]
    return out_word, out_change, out_dmg, next_attr


class LunaExecutionTests(unittest.TestCase):
    def test_pierce_writes_hpchange_for_anim_bar(self):
        word, change, dmg, next_attr = _run_luna(mt=20, damage=7)
        self.assertTrue(word & SKILL_ATTR, f"skill flag missing, buffer={word:#x}")
        self.assertEqual(dmg, 20)
        self.assertEqual(change, 20)
        self.assertEqual(next_attr, 0)

    def test_no_skill_leaves_round_untouched(self):
        word, change, dmg, _ = _run_luna(skill=False, mt=20, damage=7)
        self.assertFalse(word & SKILL_ATTR)
        self.assertEqual(dmg, 7)
        self.assertEqual(change, 0)

    def test_failed_roll_leaves_round_untouched(self):
        word, change, dmg, _ = _run_luna(roll=0, mt=20, damage=7)
        self.assertFalse(word & SKILL_ATTR)
        self.assertEqual(dmg, 7)
        self.assertEqual(change, 0)

    def test_miss_does_not_pierce(self):
        word, change, dmg, _ = _run_luna(hit_word=MISS, mt=20, damage=7)
        self.assertFalse(word & SKILL_ATTR)
        self.assertEqual(dmg, 7)
        self.assertEqual(change, 0)

    def test_crit_triples_mt_into_hpchange(self):
        _, change, dmg, _ = _run_luna(mt=10, damage=3, hit_word=CRIT)
        self.assertEqual(dmg, 30)
        self.assertEqual(change, 30)

    def test_damage_cap_127(self):
        _, change, dmg, _ = _run_luna(mt=200, damage=50)
        self.assertEqual(dmg, 127)
        self.assertEqual(change, 127)


class LunaAnimPipelineTests(unittest.TestCase):
    """Finish must not treat Luna hpChange as an attacker heal. KeepHpChange
    must still copy gBattleStats.damage when a leftover Ooze RAM flag is set.
    """

    def test_finish_does_not_heal_attacker_on_luna_hit(self):
        code = assemble(FINISH_SRC)
        offsets = symbol_offsets(FINISH_SRC)
        h = Harness(code)
        atk = bytearray(0x80)
        atk[0x12] = 40
        atk[0x13] = 30
        h.seed(ACTOR, bytes(atk))
        word = SKILL_ATTR | (20 << 24)
        h.seed(BUFFER, struct.pack("<I", word))
        stats = bytearray(0x10)
        struct.pack_into("<h", stats, 4, 20)
        h.seed(BATTLE_DATA, bytes(stats))
        h.run(
            offsets["End"],
            regs={"r0": ACTOR, "r1": TARGET, "r2": BUFFER, "r3": BATTLE_DATA},
        )
        self.assertEqual(h.read(ACTOR + 0x13, 1)[0], 30)
        self.assertEqual(struct.unpack("<b", h.read(BUFFER + 3, 1))[0], 20)

    def test_finish_still_heals_on_sol_steal(self):
        code = assemble(FINISH_SRC)
        offsets = symbol_offsets(FINISH_SRC)
        h = Harness(code)
        atk = bytearray(0x80)
        atk[0x12] = 40
        atk[0x13] = 30
        h.seed(ACTOR, bytes(atk))
        word = (SKILL_ATTR | HPSTEAL) | (10 << 24)
        h.seed(BUFFER, struct.pack("<I", word))
        stats = bytearray(0x10)
        struct.pack_into("<h", stats, 4, 10)
        h.seed(BATTLE_DATA, bytes(stats))
        h.run(
            offsets["End"],
            regs={"r0": ACTOR, "r1": TARGET, "r2": BUFFER, "r3": BATTLE_DATA},
        )
        self.assertEqual(h.read(ACTOR + 0x13, 1)[0], 40)
        self.assertEqual(struct.unpack("<b", h.read(BUFFER + 3, 1))[0], 10)

    def test_keep_hpchange_stores_luna_damage_with_stale_ooze_flag(self):
        code = assemble(KEEP_SRC)
        offsets = symbol_offsets(KEEP_SRC)
        h = Harness(code)
        gp = 0x0203A50C
        h.seed(BUFFER, struct.pack("<I", SKILL_ATTR))
        h.seed(gp, struct.pack("<I", BUFFER))
        stats = bytearray(8)
        struct.pack_into("<H", stats, 4, 20)
        h.seed(BATTLE_DATA, bytes(stats))
        h.seed(0x0203AA01, bytes([1]))
        h.run(offsets["KeepSkip"], regs={"r2": gp})
        self.assertEqual(struct.unpack("<b", h.read(BUFFER + 3, 1))[0], 20)


if __name__ == "__main__":
    unittest.main()
