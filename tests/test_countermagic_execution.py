"""CounterMagic: Devil-style magic reversal at 1-2 range.

Same contract as Counter: the incoming hit is not taken, damage is applied
to the inflicter (flag 0x80), and the skill holder's HP is unchanged. The
gate is the opposite weapon check: magic ability 0x42 or tome types 5-7.

SkillTester is stubbed; this does not prove a unit owns CounterMagicID.
"""
import struct
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from Tools.thumb_harness import Harness, assemble, symbol_offsets

SRC = ROOT / "EngineHacks/SkillSystem/Skills/ProcSkills/Countermagic/proc_countermagic.s"

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

CONFIG_REAL = 0x0001

ATTR_WEAPON = 0x01
ATTR_MAGIC = 0x42
WTYPE_SWORD = 0
WTYPE_ANIMA = 5
WTYPE_LIGHT = 6
WTYPE_DARK = 7


def _unit(hp=40, wtype=WTYPE_ANIMA, wattr=ATTR_MAGIC):
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
    wtype=WTYPE_ANIMA,
    wattr=ATTR_MAGIC,
):
    code = assemble(SRC)
    offsets = symbol_offsets(SRC)
    h = Harness(code, skill_present=skill)

    if round_attacker == ACTOR:
        actor = _unit(hp=atk_hp, wtype=wtype, wattr=wattr)
        target = _unit(hp=def_hp)
    else:
        actor = _unit(hp=def_hp)
        target = _unit(hp=atk_hp, wtype=wtype, wattr=wattr)

    h.seed(ACTOR, bytes(actor))
    h.seed(TARGET, bytes(target))
    h.seed(BUFFER, struct.pack("<I", hit_word))
    stats = bytearray(0x10)
    struct.pack_into("<H", stats, 0, CONFIG_REAL)
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
    inflicter_hp = h.read(round_attacker + HP, 1)[0]
    taker = TARGET if round_attacker == ACTOR else ACTOR
    taker_hp = h.read(taker + HP, 1)[0]
    dmg = struct.unpack("<h", h.read(BATTLE_DATA + 4, 2))[0]
    return word, inflicter_hp, taker_hp, dmg


class CounterMagicExecutionTests(unittest.TestCase):
    def test_anima_hit_is_reversed_onto_the_inflicter(self):
        word, inflicter_hp, taker_hp, dmg = _run()
        self.assertTrue(word & DEVIL, f"devil flag missing, buffer={word:#x}")
        self.assertFalse(word & HPSTEAL)
        self.assertEqual(inflicter_hp, 30)
        self.assertEqual(taker_hp, 30, "the CounterMagic unit must not take the hit")
        self.assertEqual(dmg, 10)

    def test_magic_counterattack_is_reversed_onto_the_inflicter(self):
        word, inflicter_hp, taker_hp, dmg = _run(
            round_attacker=TARGET, loop_defender=TARGET, atk_hp=40, def_hp=30
        )
        self.assertTrue(word & DEVIL)
        self.assertEqual(inflicter_hp, 30)
        self.assertEqual(taker_hp, 30)
        self.assertEqual(dmg, 10)

    def test_light_and_dark_tomes_reverse(self):
        for wtype in (WTYPE_LIGHT, WTYPE_DARK):
            with self.subTest(wtype=wtype):
                word, inflicter_hp, taker_hp, _ = _run(wtype=wtype, wattr=0)
                self.assertTrue(word & DEVIL)
                self.assertEqual(inflicter_hp, 30)
                self.assertEqual(taker_hp, 30)

    def test_magic_damage_bit_on_a_sword_still_reverses(self):
        word, inflicter_hp, taker_hp, _ = _run(wtype=WTYPE_SWORD, wattr=ATTR_MAGIC)
        self.assertTrue(word & DEVIL)
        self.assertEqual(inflicter_hp, 30)
        self.assertEqual(taker_hp, 30)

    def test_physical_weapon_does_not_reverse(self):
        word, inflicter_hp, taker_hp, dmg = _run(
            wtype=WTYPE_SWORD, wattr=ATTR_WEAPON
        )
        self.assertFalse(word & DEVIL)
        self.assertEqual(inflicter_hp, 40)
        self.assertEqual(taker_hp, 30)
        self.assertEqual(dmg, 10)

    def test_no_skill_does_not_reverse(self):
        word, inflicter_hp, taker_hp, dmg = _run(skill=False)
        self.assertFalse(word & DEVIL)
        self.assertEqual(inflicter_hp, 40)
        self.assertEqual(taker_hp, 30)
        self.assertEqual(dmg, 10)

    def test_range_3_does_not_reverse(self):
        word, inflicter_hp, taker_hp, _ = _run(range_=3)
        self.assertFalse(word & DEVIL)
        self.assertEqual(inflicter_hp, 40)
        self.assertEqual(taker_hp, 30)

    def test_range_2_still_reverses(self):
        word, inflicter_hp, taker_hp, _ = _run(range_=2)
        self.assertTrue(word & DEVIL)
        self.assertEqual(inflicter_hp, 30)
        self.assertEqual(taker_hp, 30)

    def test_lethal_hit_is_still_reversed(self):
        word, inflicter_hp, taker_hp, dmg = _run(damage=30, def_hp=30)
        self.assertTrue(word & DEVIL)
        self.assertEqual(taker_hp, 30)
        self.assertEqual(inflicter_hp, 10)
        self.assertEqual(dmg, 30)

    def test_miss_does_not_reverse(self):
        word, inflicter_hp, taker_hp, _ = _run(hit_word=MISS)
        self.assertFalse(word & DEVIL)
        self.assertEqual(inflicter_hp, 40)
        self.assertEqual(taker_hp, 30)

    def test_zero_damage_does_not_reverse(self):
        word, inflicter_hp, taker_hp, dmg = _run(damage=0)
        self.assertFalse(word & DEVIL)
        self.assertEqual(inflicter_hp, 40)
        self.assertEqual(taker_hp, 30)
        self.assertEqual(dmg, 0)


if __name__ == "__main__":
    unittest.main()
