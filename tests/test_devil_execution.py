"""DevilsLuck / DevilsPact / DevilsWhim (Proc_Devil).

Proc loop hardcodes r1 = gBattleTarget, so the hit-taker is the other of
{gBattleActor, gBattleTarget}. Vanilla helpers (item effect, luck, d100)
and SkillTester are intercepted; this does not prove a unit owns the skill.
"""
import struct
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from Tools.thumb_harness import CODE_BASE, Harness, assemble, symbol_offsets

SRC = ROOT / "EngineHacks/SkillSystem/Skills/ProcSkills/Devil/proc_devil.s"

ACTOR = 0x0203A3F0
TARGET = 0x0203A470
BUFFER = 0x0203A600
BATTLE_DATA = 0x0203A3D8

HP = 0x13
WPN = 0x4A
MISS = 0x2
DEVIL = 0x80
SKILL_FLAG = 0x4000
CONFIG_REAL = 0x0001
CONFIG_FORECAST = 0x0002

LUCK_ID = 9
PACT_ID = 10
WHIM_ID = 11
SKILLTESTER_SENTINEL = 0x11111111
GET_ITEM_EFFECT = 0x8017424
LUCK_GETTER = 0x8018BB8
D100 = 0x802857C

IRON = 0x0001
DEVIL_AXE = 0x002A
NOSFERATU = 0x003F
EFFECT = {IRON: 0, DEVIL_AXE: 4, NOSFERATU: 2}


def _unit(hp=40, item=IRON):
    buf = bytearray(0x80)
    buf[HP] = hp
    struct.pack_into("<H", buf, WPN, item)
    return buf


def _run(
    *,
    round_attacker=ACTOR,
    actor_skills=(),
    target_skills=(),
    actor_item=IRON,
    target_item=IRON,
    luck=10,
    d100=1,
    damage=10,
    atk_hp=40,
    def_hp=30,
    hit_word=0,
    config=CONFIG_REAL,
):
    code = assemble(SRC)
    offsets = symbol_offsets(SRC)
    skills = {ACTOR: set(actor_skills), TARGET: set(target_skills)}

    def intercept(lr, r0, r1):
        if lr == GET_ITEM_EFFECT:
            return EFFECT.get(r0 & 0xFFFF, 0)
        if lr == LUCK_GETTER:
            return luck
        if lr == D100:
            return 1 if d100 else 0
        if lr == SKILLTESTER_SENTINEL:
            return 1 if r1 in skills.get(r0, ()) else 0
        raise AssertionError(f"unexpected call lr={lr:#x} r0={r0:#x} r1={r1:#x}")

    h = Harness(code, intercept_calls=intercept)
    h.seed(
        CODE_BASE + offsets["SkillTester"],
        struct.pack("<IIII", SKILLTESTER_SENTINEL, LUCK_ID, PACT_ID, WHIM_ID),
    )
    if round_attacker == ACTOR:
        actor = _unit(hp=atk_hp, item=actor_item)
        target = _unit(hp=def_hp, item=target_item)
    else:
        actor = _unit(hp=def_hp, item=actor_item)
        target = _unit(hp=atk_hp, item=target_item)
    h.seed(ACTOR, bytes(actor))
    h.seed(TARGET, bytes(target))
    h.seed(BUFFER, struct.pack("<I", hit_word))
    stats = bytearray(0x10)
    struct.pack_into("<H", stats, 0, config)
    struct.pack_into("<h", stats, 4, damage)
    h.seed(BATTLE_DATA, bytes(stats))
    h.run(
        offsets["End"],
        regs={
            "r0": round_attacker,
            "r1": TARGET,
            "r2": BUFFER,
            "r3": BATTLE_DATA,
        },
    )
    word = struct.unpack("<I", h.read(BUFFER, 4))[0]
    inflicter_hp = h.read(round_attacker + HP, 1)[0]
    taker = TARGET if round_attacker == ACTOR else ACTOR
    taker_hp = h.read(taker + HP, 1)[0]
    dmg = struct.unpack("<h", h.read(BATTLE_DATA + 4, 2))[0]
    return word, inflicter_hp, taker_hp, dmg


class DevilExecutionTests(unittest.TestCase):
    def test_miss_does_not_proc(self):
        word, inflicter_hp, taker_hp, dmg = _run(hit_word=MISS, actor_item=DEVIL_AXE)
        self.assertFalse(word & DEVIL)
        self.assertEqual(inflicter_hp, 40)
        self.assertEqual(taker_hp, 30)
        self.assertEqual(dmg, 10)

    def test_zero_damage_does_not_proc(self):
        word, inflicter_hp, taker_hp, dmg = _run(damage=0, actor_item=DEVIL_AXE)
        self.assertFalse(word & DEVIL)
        self.assertEqual(inflicter_hp, 40)
        self.assertEqual(taker_hp, 30)
        self.assertEqual(dmg, 0)

    def test_no_skill_no_devil_weapon_does_not_proc(self):
        word, inflicter_hp, taker_hp, _ = _run()
        self.assertFalse(word & DEVIL)
        self.assertEqual(inflicter_hp, 40)
        self.assertEqual(taker_hp, 30)

    def test_attacker_devil_weapon_reverses_on_successful_roll(self):
        word, inflicter_hp, taker_hp, dmg = _run(actor_item=DEVIL_AXE)
        self.assertTrue(word & DEVIL, f"devil flag missing, buffer={word:#x}")
        self.assertTrue(word & SKILL_FLAG)
        self.assertEqual(inflicter_hp, 30)
        self.assertEqual(taker_hp, 30)
        self.assertEqual(dmg, 10)

    def test_attacker_devil_weapon_does_not_reverse_on_failed_roll(self):
        word, inflicter_hp, taker_hp, _ = _run(actor_item=DEVIL_AXE, d100=0)
        self.assertFalse(word & DEVIL)
        self.assertEqual(inflicter_hp, 40)
        self.assertEqual(taker_hp, 30)

    def test_devils_luck_on_attacker_blocks_own_devil_axe(self):
        word, inflicter_hp, taker_hp, _ = _run(
            actor_item=DEVIL_AXE, actor_skills=(LUCK_ID,)
        )
        self.assertFalse(word & DEVIL)
        self.assertEqual(inflicter_hp, 40)
        self.assertEqual(taker_hp, 30)

    def test_devils_pact_on_attacker_blocks_own_devil_axe(self):
        word, inflicter_hp, taker_hp, _ = _run(
            actor_item=DEVIL_AXE, actor_skills=(PACT_ID,)
        )
        self.assertFalse(word & DEVIL)
        self.assertEqual(inflicter_hp, 40)
        self.assertEqual(taker_hp, 30)

    def test_devils_pact_on_defender_inflicts_without_devil_weapon(self):
        word, inflicter_hp, taker_hp, _ = _run(target_skills=(PACT_ID,))
        self.assertTrue(word & DEVIL)
        self.assertEqual(inflicter_hp, 30)
        self.assertEqual(taker_hp, 30)

    def test_devils_luck_on_defender_with_devil_weapon_inflicts(self):
        word, inflicter_hp, taker_hp, _ = _run(
            target_item=DEVIL_AXE, target_skills=(LUCK_ID,)
        )
        self.assertTrue(word & DEVIL)
        self.assertEqual(inflicter_hp, 30)
        self.assertEqual(taker_hp, 30)

    def test_devils_luck_on_defender_without_devil_weapon_does_not_inflict(self):
        word, inflicter_hp, taker_hp, _ = _run(target_skills=(LUCK_ID,))
        self.assertFalse(word & DEVIL)
        self.assertEqual(inflicter_hp, 40)
        self.assertEqual(taker_hp, 30)

    def test_devils_whim_on_attacker_inflicts_without_devil_weapon(self):
        word, inflicter_hp, taker_hp, _ = _run(actor_skills=(WHIM_ID,))
        self.assertTrue(word & DEVIL)
        self.assertEqual(inflicter_hp, 30)
        self.assertEqual(taker_hp, 30)

    def test_devils_whim_on_defender_inflicts_without_devil_weapon(self):
        word, inflicter_hp, taker_hp, _ = _run(target_skills=(WHIM_ID,))
        self.assertTrue(word & DEVIL)
        self.assertEqual(inflicter_hp, 30)
        self.assertEqual(taker_hp, 30)

    def test_luck_32_is_over_cap_and_does_not_proc(self):
        word, inflicter_hp, taker_hp, _ = _run(actor_item=DEVIL_AXE, luck=32)
        self.assertFalse(word & DEVIL)
        self.assertEqual(inflicter_hp, 40)
        self.assertEqual(taker_hp, 30)

    def test_luck_31_is_at_cap_and_still_rolls(self):
        word, inflicter_hp, _, _ = _run(actor_item=DEVIL_AXE, luck=31, d100=1)
        self.assertTrue(word & DEVIL)
        self.assertEqual(inflicter_hp, 30)

    def test_forecast_sets_flag_but_does_not_write_hp(self):
        word, inflicter_hp, taker_hp, _ = _run(
            actor_item=DEVIL_AXE, config=CONFIG_FORECAST
        )
        self.assertTrue(word & DEVIL)
        self.assertEqual(inflicter_hp, 40)
        self.assertEqual(taker_hp, 30)

    def test_hp_steal_weapon_unsets_reversal_and_zeroes_damage(self):
        word, inflicter_hp, taker_hp, dmg = _run(
            target_skills=(PACT_ID,), actor_item=NOSFERATU
        )
        self.assertFalse(word & DEVIL)
        self.assertTrue(word & SKILL_FLAG)
        self.assertEqual(inflicter_hp, 40)
        self.assertEqual(taker_hp, 30)
        self.assertEqual(dmg, 0)

    def test_counterattack_pact_on_actor_inflicts_when_r1_is_still_target(self):
        """gBattleActor has Pact; gBattleTarget is swinging. r1 stays Target."""
        word, inflicter_hp, taker_hp, _ = _run(
            round_attacker=TARGET, actor_skills=(PACT_ID,)
        )
        self.assertTrue(word & DEVIL, f"Pact on actor must fire, buffer={word:#x}")
        self.assertEqual(inflicter_hp, 30)
        self.assertEqual(taker_hp, 30)

    def test_counterattack_whim_on_actor_inflicts_when_r1_is_still_target(self):
        word, inflicter_hp, taker_hp, _ = _run(
            round_attacker=TARGET, actor_skills=(WHIM_ID,)
        )
        self.assertTrue(word & DEVIL, f"Whim on actor must fire, buffer={word:#x}")
        self.assertEqual(inflicter_hp, 30)
        self.assertEqual(taker_hp, 30)


if __name__ == "__main__":
    unittest.main()
