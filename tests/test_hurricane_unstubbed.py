"""Hurricane with NOTHING stubbed, against the built FE7_Hack.gba.

Every other Hurricane test replaces SkillTester with a stub. This one does not.
It maps the whole cartridge and all 256K of EWRAM, points gBattleActor /
gBattleTarget at real gUnitLookup slots, puts Hurricane in unit->supports[],
and lets the genuine SkillTester, MakeSkillBuffer, GetUnit,
CanSkillActivationFlagProc, SetSkillActivationFlag and
ResetTurnActivationFlags all execute.

The lone `.short 0xf800` BL-suffix halfwords are handled with a Unicorn code
hook that emulates them (PC = LR, LR = pc + 2) rather than by rewriting bytes,
so those calls land on the real routines instead of on a substitute.

Two things this reaches that the stubbed tests cannot:
  * SkillTester actually finding a skill stored in unit->supports[], which is
    where skill scrolls and in-game skill adds put it, and
  * ResetTurnActivationFlags walking the real gUnitLookup, which has 60 NULL
    slots between deployment id 1 and 0xBF.
"""
import struct
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))
sys.path.insert(0, str(Path(__file__).resolve().parent))

import built_rom  # noqa: E402

ROM_BASE = 0x08000000
PAGE = 0x1000
EWRAM, EWRAM_SIZE = 0x02000000, 0x40000
IWRAM, IWRAM_SIZE = 0x03000000, 0x8000

G_BATTLE_ACTOR = 0x0203A3F0
G_BATTLE_TARGET = 0x0203A470
G_BATTLE_STATS = 0x0203A3D8
G_ATTACKER_BUF = 0x0202A9D4
G_DEFENDER_BUF = 0x0202AA24
ROUND_BUFFER = 0x0203A5EC
BATTLE_CONFIG_REAL = 0x0001
BATTLE_CONFIG_SIMULATE = 0x0002

# gBattleStats.config as the engine writes it, wholesale, before generating a
# battle. See "FE7 Decomp.txt": BattleGenerateSimulation stores 0x2 and the
# ballista simulation 0xA, while BattleGenerateReal stores 0x1 and 0x9.
CONFIG_FORECAST = 0x0002
CONFIG_BALLISTA_FORECAST = 0x000A
CONFIG_REAL_COMBAT = 0x0001
CONFIG_REAL_ARENA = 0x0009

CHAR_TABLE, CHAR_ENTRY = 0x08BDCE18, 0x34
CLASS_TABLE, CLASS_ENTRY = 0x08BE015C, 0x54
G_UNIT_LOOKUP = 0x08B92EB0  # ROM table of EWRAM Unit pointers, read by GetUnit

ACT_FLAGS = 0x3A
SUPPORTS = 0x32
HURRICANE_BIT = 0
ATTR_MISS = 0x2
IDX_A, IDX_B = 0x05, 0x0A

HSRC = ROOT / "EngineHacks/SkillSystem/Skills/ProcSkills/Hurricane/Hurricane.c"
BL_SUFFIX = b"\x00\xf8"


class Combat:
    def __init__(self, test, hurricane_on_actor):
        from unicorn import (Uc, UC_ARCH_ARM, UC_MODE_THUMB,
                             UC_HOOK_CODE, UC_HOOK_MEM_UNMAPPED)
        from unicorn.arm_const import UC_ARM_REG_SP, UC_ARM_REG_LR, UC_ARM_REG_PC

        self.test = test
        rom = built_rom.load()
        self.sym = built_rom.symbols()
        for name in ("Proc_Hurricane", "SkillTester", "ResetTurnActivationFlags",
                     "HurricaneID_Link"):
            if name not in self.sym:
                raise unittest.SkipTest(f"{name} missing from FE7_Hack.sym")

        # Hurricane is compiled from C, so its extent is HurricaneID_Link minus
        # its own start rather than a hand-counted label offset.
        code = self.sym["HurricaneID_Link"] - self.sym["Proc_Hurricane"]
        hb = built_rom.offset(rom, self.sym["Proc_Hurricane"], code)
        fb = built_rom.offset(rom, self.sym["ResetTurnActivationFlags"], 0x60)

        self.tramps = set(self._bl_suffixes(rom, hb, hb + code))
        self.tramps |= set(self._bl_suffixes(rom, fb, fb + 0x60))

        uc = Uc(UC_ARCH_ARM, UC_MODE_THUMB)
        size = (len(rom) + PAGE - 1) // PAGE * PAGE
        uc.mem_map(ROM_BASE, size)
        uc.mem_write(ROM_BASE, rom + bytes(size - len(rom)))
        uc.mem_map(EWRAM, EWRAM_SIZE)
        uc.mem_map(IWRAM, IWRAM_SIZE)
        uc.reg_write(UC_ARM_REG_SP, IWRAM + IWRAM_SIZE - PAGE)
        self.uc = uc

        lut = built_rom.offset(rom, G_UNIT_LOOKUP, 0xC0 * 4)
        self.unit_a = struct.unpack_from("<I", rom, lut + IDX_A * 4)[0]
        self.unit_b = struct.unpack_from("<I", rom, lut + IDX_B * 4)[0]
        test.assertTrue(self.unit_a and self.unit_b, "gUnitLookup slots are NULL")

        lit = built_rom.offset(rom, self.sym["HurricaneID_Link"], 4)
        self.skill_id = struct.unpack_from("<I", rom, lit)[0]

        self._unit(self.unit_a, IDX_A, 1, 1, [self.skill_id])
        self._unit(self.unit_b, IDX_B, 2, 2, [])

        actor = self.unit_a if hurricane_on_actor else self.unit_b
        target = self.unit_b if hurricane_on_actor else self.unit_a
        uc.mem_write(G_BATTLE_ACTOR, bytes(uc.mem_read(actor, 0x48)) + bytes(0x50))
        uc.mem_write(G_BATTLE_TARGET, bytes(uc.mem_read(target, 0x48)) + bytes(0x50))
        uc.mem_write(G_BATTLE_STATS, struct.pack("<H", BATTLE_CONFIG_REAL))
        uc.mem_write(G_ATTACKER_BUF, bytes(12))
        uc.mem_write(G_DEFENDER_BUF, bytes(12))

        def on_code(u, addr, _size, _d):
            if addr in self.tramps:  # emulate the BL suffix: PC = LR, LR = pc + 2
                lr = u.reg_read(UC_ARM_REG_LR)
                u.reg_write(UC_ARM_REG_LR, (addr + 2) | 1)
                u.reg_write(UC_ARM_REG_PC, lr | 1)

        uc.hook_add(UC_HOOK_CODE, on_code)
        self.faults = []
        uc.hook_add(UC_HOOK_MEM_UNMAPPED,
                    lambda u, t, a, s, v, d: (self.faults.append(a), False)[1])

    @staticmethod
    def _bl_suffixes(rom, lo, hi):
        out, i = [], lo
        while True:
            i = rom.find(BL_SUFFIX, i, hi)
            if i == -1:
                return out
            out.append(ROM_BASE + i)
            i += 2

    def _unit(self, addr, index, char_id, class_id, skills):
        self.uc.mem_write(addr, bytes(0x48))
        self.uc.mem_write(addr + 0x00, struct.pack("<I", CHAR_TABLE + CHAR_ENTRY * char_id))
        self.uc.mem_write(addr + 0x04, struct.pack("<I", CLASS_TABLE + CLASS_ENTRY * class_id))
        self.uc.mem_write(addr + 0x0B, bytes([index]))
        for i, skill in enumerate(skills):
            self.uc.mem_write(addr + SUPPORTS + i, bytes([skill]))

    def _run(self, entry, **regs):
        from unicorn.arm_const import (UC_ARM_REG_R0, UC_ARM_REG_R1, UC_ARM_REG_R2,
                                       UC_ARM_REG_R3, UC_ARM_REG_LR)
        stop = ROM_BASE + 0x100  # cartridge header; never a real return target
        mapping = {"r0": UC_ARM_REG_R0, "r1": UC_ARM_REG_R1,
                   "r2": UC_ARM_REG_R2, "r3": UC_ARM_REG_R3}
        for name in ("r0", "r1", "r2", "r3"):
            self.uc.reg_write(mapping[name], regs.get(name, 0))
        self.uc.reg_write(UC_ARM_REG_LR, stop | 1)
        self.uc.emu_start((entry & ~1) | 1, stop, timeout=5_000_000)
        self.test.assertEqual(self.faults, [],
                              f"unmapped access: {[hex(x) for x in self.faults]}")

    def round(self, attacker, damage=7, config=CONFIG_REAL_COMBAT):
        self.uc.mem_write(G_BATTLE_STATS, struct.pack("<H", config))
        self.uc.mem_write(ROUND_BUFFER, struct.pack("<I", 0))
        self.uc.mem_write(G_BATTLE_STATS + 4, struct.pack("<h", damage))
        self._run(self.sym["Proc_Hurricane"], r0=attacker, r1=G_BATTLE_TARGET,
                  r2=ROUND_BUFFER, r3=G_BATTLE_STATS)
        attrs = struct.unpack("<I", self.uc.mem_read(ROUND_BUFFER, 4))[0]
        dealt = struct.unpack("<h", self.uc.mem_read(G_BATTLE_STATS + 4, 2))[0]
        if attrs & ATTR_MISS:
            self.test.assertEqual(dealt, 0, "a dodged round must deal nothing")
            return "dodged"
        self.test.assertEqual(dealt, damage, "an undodged round keeps its damage")
        return "hit"

    def start_of_player_phase(self):
        self._run(self.sym["ResetTurnActivationFlags"])

    def skill_tester(self, battle_unit):
        from unicorn.arm_const import UC_ARM_REG_R0
        self._run(self.sym["SkillTester"], r0=battle_unit, r1=self.skill_id)
        return self.uc.reg_read(UC_ARM_REG_R0)

    def flags(self, unit=None):
        unit = self.unit_a if unit is None else unit
        return struct.unpack("<H", self.uc.mem_read(unit + ACT_FLAGS, 2))[0]

    def charged(self):
        return not (self.flags() & (1 << HURRICANE_BIT))


class UnstubbedTests(unittest.TestCase):
    def test_real_skilltester_finds_a_supports_learned_hurricane(self):
        """Skill scrolls and in-game skill adds store into unit->supports[]."""
        for on_actor in (True, False):
            with self.subTest(hurricane_on_actor=on_actor):
                c = Combat(self, hurricane_on_actor=on_actor)
                bu = G_BATTLE_ACTOR if on_actor else G_BATTLE_TARGET
                self.assertEqual(c.skill_tester(bu), 1,
                                 "SkillTester must see Hurricane in supports[]")

    def test_scenario_1_attack_then_counter(self):
        c = Combat(self, hurricane_on_actor=True)
        self.assertEqual(c.round(G_BATTLE_ACTOR), "hit", "our own swing is unaffected")
        self.assertTrue(c.charged(), "attacking must not spend the dodge")
        self.assertEqual(c.round(G_BATTLE_TARGET), "dodged", "the counter is dodged")
        self.assertFalse(c.charged())
        self.assertEqual(c.round(G_BATTLE_TARGET), "hit", "only the first attack")

    def test_scenario_2_attacked_on_enemy_phase(self):
        c = Combat(self, hurricane_on_actor=False)
        self.assertEqual(c.round(G_BATTLE_ACTOR), "dodged")
        self.assertFalse(c.charged())
        self.assertEqual(c.round(G_BATTLE_ACTOR), "hit")

    def test_reset_survives_the_null_slots_in_gunitlookup(self):
        """60 of the 191 deployment slots are NULL; the loop must skip them."""
        c = Combat(self, hurricane_on_actor=False)
        self.assertEqual(c.round(G_BATTLE_ACTOR), "dodged")
        self.assertFalse(c.charged())
        c.start_of_player_phase()
        self.assertTrue(c.charged(), "the reset must recharge the dodge")
        self.assertEqual(c.round(G_BATTLE_ACTOR), "dodged")

    def test_the_enemy_never_gains_a_flag(self):
        c = Combat(self, hurricane_on_actor=False)
        c.round(G_BATTLE_ACTOR)
        self.assertEqual(c.flags(c.unit_b), 0)

    def test_a_natural_miss_still_spends_the_charge(self):
        """"First attack" means the first attack, hit or miss.

        ProcLoop_Start rolls true hit before Hurricane runs, so a round that
        missed on its own already carries the miss bit. Hurricane must still
        treat that as the attack it dodges, otherwise the charge survives and
        gets spent on the *second* swing of the same combat -- which is what
        "the skill fires late / inconsistently" looks like in game.
        """
        c = Combat(self, hurricane_on_actor=False)
        self.assertTrue(c.charged())
        c.uc.mem_write(ROUND_BUFFER, struct.pack("<I", ATTR_MISS))
        c.uc.mem_write(G_BATTLE_STATS + 4, struct.pack("<h", 0))
        c._run(c.sym["Proc_Hurricane"], r0=G_BATTLE_ACTOR, r1=G_BATTLE_TARGET,
               r2=ROUND_BUFFER, r3=G_BATTLE_STATS)
        self.assertFalse(c.charged(), "a natural miss is still the first attack")
        self.assertEqual(c.round(G_BATTLE_ACTOR), "hit",
                         "the doubling round must not be dodged")

    def test_another_skill_owning_the_round_leaves_the_charge_alone(self):
        """0xC000 = a round already claimed by an attacker/defender skill."""
        for claimed in (0x4000, 0x8000):
            with self.subTest(attr=hex(claimed)):
                c = Combat(self, hurricane_on_actor=False)
                c.uc.mem_write(ROUND_BUFFER, struct.pack("<I", claimed))
                c.uc.mem_write(G_BATTLE_STATS + 4, struct.pack("<h", 7))
                c._run(c.sym["Proc_Hurricane"], r0=G_BATTLE_ACTOR,
                       r1=G_BATTLE_TARGET, r2=ROUND_BUFFER, r3=G_BATTLE_STATS)
                self.assertTrue(c.charged(),
                                "another skill's round must not burn the dodge")

    def test_the_forecast_never_spends_the_charge(self):
        """Opening the battle forecast must not fire the skill.

        The forecast runs this same proc loop to predict the fight. Reported
        symptom: "as soon as I open the forecast menu the bit is being set" --
        the charge was gone before a blow landed, and on some paths the forecast
        also displayed the dodge it had just consumed.
        """
        for config, label in ((CONFIG_FORECAST, "battle forecast"),
                              (CONFIG_BALLISTA_FORECAST, "ballista forecast")):
            with self.subTest(config=hex(config), kind=label):
                c = Combat(self, hurricane_on_actor=False)
                self.assertEqual(
                    c.round(G_BATTLE_ACTOR, config=config), "hit",
                    f"{label} must not rewrite the round into a miss")
                self.assertTrue(
                    c.charged(),
                    f"{label} spent the dodge before the fight happened")

    def test_the_charge_survives_a_forecast_and_fires_in_the_real_fight(self):
        """The sequence the player actually performs: look, then attack."""
        c = Combat(self, hurricane_on_actor=False)
        for _ in range(3):  # open the forecast a few times, as players do
            c.round(G_BATTLE_ACTOR, config=CONFIG_FORECAST)
        self.assertTrue(c.charged(), "forecasting must leave the dodge intact")
        self.assertEqual(c.round(G_BATTLE_ACTOR), "dodged",
                         "the real fight still gets its dodge")
        self.assertFalse(c.charged())

    def test_real_combat_configs_still_fire(self):
        """Both REAL configs the engine writes must be treated as real."""
        for config, label in ((CONFIG_REAL_COMBAT, "normal combat"),
                              (CONFIG_REAL_ARENA, "arena/real variant 0x9")):
            with self.subTest(config=hex(config), kind=label):
                c = Combat(self, hurricane_on_actor=False)
                self.assertEqual(c.round(G_BATTLE_ACTOR, config=config), "dodged",
                                 f"{label} must still dodge")
                self.assertFalse(c.charged())

    def test_r8_is_restored_on_every_path(self):
        """Hurricane now uses r8; the proc loop keeps live state in r9-r11 and
        expects r8 preserved. Check the early-out paths too, not just the
        path that fires."""
        from unicorn.arm_const import UC_ARM_REG_R8
        SENTINEL = 0xDEADBEEF
        cases = {
            "fires":        (0, 7),
            "already missed": (ATTR_MISS, 0),
            "skill-claimed":  (0x4000, 7),
        }
        for name, (attrs, dmg) in cases.items():
            with self.subTest(path=name):
                c = Combat(self, hurricane_on_actor=False)
                c.uc.reg_write(UC_ARM_REG_R8, SENTINEL)
                c.uc.mem_write(ROUND_BUFFER, struct.pack("<I", attrs))
                c.uc.mem_write(G_BATTLE_STATS + 4, struct.pack("<h", dmg))
                c._run(c.sym["Proc_Hurricane"], r0=G_BATTLE_ACTOR,
                       r1=G_BATTLE_TARGET, r2=ROUND_BUFFER, r3=G_BATTLE_STATS)
                self.assertEqual(c.uc.reg_read(UC_ARM_REG_R8), SENTINEL,
                                 f"r8 clobbered on the {name} path")


if __name__ == "__main__":
    unittest.main()
