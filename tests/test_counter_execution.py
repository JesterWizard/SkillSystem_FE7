"""Counter: Devil-style physical reversal at 1-2 range.

The incoming hit is not taken. Damage is applied to the inflicter (flag 0x80)
and the Counter unit's HP is unchanged. The proc loop hardcodes r1 =
gBattleTarget, so the hit-taker is derived from r0.

SkillTester is stubbed; this does not prove a unit owns CounterID.
"""
import struct
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from Tools.thumb_harness import Harness, assemble, symbol_offsets

SRC = ROOT / "EngineHacks/SkillSystem/Skills/ProcSkills/Counter/proc_counter.s"

ACTOR = 0x0203A3F0
TARGET = 0x0203A470
BUFFER = 0x0203A600
BATTLE_DATA = 0x0203A3D8

HP = 0x13
WPN_ATTR = 0x4C
WPN_TYPE = 0x50

MISS = 0x2
DEVIL = 0x80
HPSTEAL = 0x100
OTHER_DELTA = 0x0203AA02

CONFIG_REAL = 0x0001
CONFIG_FORECAST = 0x0002

ATTR_WEAPON = 0x01
ATTR_MAGIC = 0x42
WTYPE_SWORD = 0
WTYPE_ANIMA = 5


def _unit(hp=40, wtype=WTYPE_SWORD, wattr=ATTR_WEAPON):
    buf = bytearray(0x80)
    buf[HP] = hp
    buf[WPN_TYPE] = wtype
    struct.pack_into("<I", buf, WPN_ATTR, wattr)
    return buf


def _run(
    *,
    skill=True,
    round_attacker=ACTOR,
    loop_defender=TARGET,
    atk_hp=40,
    def_hp=30,
    damage=10,
    range_=1,
    hit_word=0,
    config=CONFIG_REAL,
    wtype=WTYPE_SWORD,
    wattr=ATTR_WEAPON,
    hit_taker_hp=None,
):
    """One round. `loop_defender` is r1 as ProcLoopParent actually passes it
    (always gBattleTarget). `round_attacker` is r0, the unit inflicting this hit.
    """
    code = assemble(SRC)
    offsets = symbol_offsets(SRC)
    h = Harness(code, skill_present=skill)

    taker_hp = def_hp if hit_taker_hp is None else hit_taker_hp
    if round_attacker == ACTOR:
        actor = _unit(hp=atk_hp, wtype=wtype, wattr=wattr)
        target = _unit(hp=taker_hp)
    else:
        actor = _unit(hp=taker_hp)
        target = _unit(hp=atk_hp, wtype=wtype, wattr=wattr)

    h.seed(ACTOR, bytes(actor))
    h.seed(TARGET, bytes(target))
    h.seed(BUFFER, struct.pack("<I", hit_word))
    h.seed(OTHER_DELTA, b"\x00")
    stats = bytearray(0x10)
    struct.pack_into("<H", stats, 0, config)
    stats[2] = range_
    struct.pack_into("<h", stats, 4, damage)
    h.seed(BATTLE_DATA, bytes(stats))
    h.run(
        offsets["End"],
        regs={
            "r0": round_attacker,
            "r1": loop_defender,
            "r2": BUFFER,
            "r3": BATTLE_DATA,
        },
    )
    word = struct.unpack("<I", h.read(BUFFER, 4))[0]
    hp_change = struct.unpack("<b", h.read(BUFFER + 3, 1))[0]
    inflicter_hp = h.read(round_attacker + HP, 1)[0]
    taker = TARGET if round_attacker == ACTOR else ACTOR
    taker_hp = h.read(taker + HP, 1)[0]
    other_delta = struct.unpack("<b", h.read(OTHER_DELTA, 1))[0]
    dmg = struct.unpack("<h", h.read(BATTLE_DATA + 4, 2))[0]
    return word, hp_change, inflicter_hp, other_delta, taker_hp, dmg


class CounterExecutionTests(unittest.TestCase):
    def test_physical_hit_is_reversed_onto_the_inflicter(self):
        word, hp_change, inflicter_hp, other_delta, taker_hp, dmg = _run()
        self.assertTrue(word & DEVIL, f"devil flag missing, buffer={word:#x}")
        self.assertFalse(word & HPSTEAL)
        self.assertEqual(hp_change, 0)
        self.assertEqual(other_delta, 0)
        self.assertEqual(inflicter_hp, 30)
        self.assertEqual(taker_hp, 30, "the Counter unit must not take the hit")
        self.assertEqual(dmg, 10)

    def test_physical_counterattack_is_reversed_onto_the_inflicter(self):
        word, hp_change, inflicter_hp, other_delta, taker_hp, dmg = _run(
            round_attacker=TARGET, loop_defender=TARGET, atk_hp=40, def_hp=30
        )
        self.assertTrue(word & DEVIL, f"devil flag missing, buffer={word:#x}")
        self.assertEqual(inflicter_hp, 30)
        self.assertEqual(taker_hp, 30)
        self.assertEqual(dmg, 10)

    def test_no_skill_does_not_reflect(self):
        word, _, inflicter_hp, other_delta, taker_hp, dmg = _run(skill=False)
        self.assertFalse(word & DEVIL)
        self.assertEqual(other_delta, 0)
        self.assertEqual(inflicter_hp, 40)
        self.assertEqual(taker_hp, 30)
        self.assertEqual(dmg, 10)

    def test_magic_weapon_does_not_reflect(self):
        word, _, inflicter_hp, other_delta, taker_hp, dmg = _run(
            wtype=WTYPE_ANIMA, wattr=ATTR_MAGIC
        )
        self.assertFalse(word & DEVIL)
        self.assertEqual(inflicter_hp, 40)
        self.assertEqual(taker_hp, 30)
        self.assertEqual(dmg, 10)

    def test_range_3_does_not_reflect(self):
        word, _, inflicter_hp, other_delta, taker_hp, dmg = _run(range_=3)
        self.assertFalse(word & DEVIL)
        self.assertEqual(inflicter_hp, 40)
        self.assertEqual(taker_hp, 30)

    def test_range_2_still_reflects(self):
        word, _, inflicter_hp, _, taker_hp, _ = _run(range_=2)
        self.assertTrue(word & DEVIL)
        self.assertEqual(inflicter_hp, 30)
        self.assertEqual(taker_hp, 30)

    def test_lethal_hit_is_still_reversed(self):
        """The Counter unit never takes the hit, so a lethal swing still reverses."""
        word, _, inflicter_hp, _, taker_hp, dmg = _run(damage=30, def_hp=30)
        self.assertTrue(word & DEVIL)
        self.assertEqual(taker_hp, 30)
        self.assertEqual(inflicter_hp, 10)
        self.assertEqual(dmg, 30)

    def test_miss_does_not_reflect(self):
        word, _, inflicter_hp, _, taker_hp, _ = _run(hit_word=MISS)
        self.assertFalse(word & DEVIL)
        self.assertEqual(inflicter_hp, 40)
        self.assertEqual(taker_hp, 30)

    def test_zero_damage_does_not_reflect(self):
        word, _, inflicter_hp, _, taker_hp, dmg = _run(damage=0)
        self.assertFalse(word & DEVIL)
        self.assertEqual(inflicter_hp, 40)
        self.assertEqual(taker_hp, 30)
        self.assertEqual(dmg, 0)


if __name__ == "__main__":
    unittest.main()
