"""Hero and Ignis executed from FE7_Hack.gba, proving both are reachable.

Hero is walked from the 0x802857C d100 hook through SkillActivationChanceCalcLoop.
Ignis is walked from the battle proc loop. SkillTester, Roll1RN, and the Def/Res
getters are stubbed at the `.short 0xf800` trampoline so Unicorn can decode it;
the HP gate, +30, (Def/2+Res/2) bonus, crit x3, and miss skip run as shipped.
"""
import struct
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))
sys.path.insert(0, str(Path(__file__).resolve().parent))

import built_rom  # noqa: E402  (FE7_Hack.gba loader with an assembled-ROM check)

BUILT = built_rom.BUILT

ROM_BASE = 0x08000000
STOP = 0x08FFFFF0
SP = 0x03007F00
UNIT = 0x02000000
ATTACKER = 0x0203A3F0
DEFENDER = 0x0203A470
ROUND_BUFFER = 0x0203A5EC
BATTLE_DATA = 0x0203A700
G_BATTLE_STATS = 0x0203A3D8

D100_HOOK = 0x2857C
ROLL1RN = 0x08000E60
DEF_GETTER = 0x08018B70
RES_GETTER = 0x08018B90

HERO_ID = 15
IGNIS_ID = 16
CHANCE = 40
HERO_BONUS = 30
SKILL_FLAG = 0x4000
MISS = 0x2
FORECAST = 0x0002

HERO_HP_SIG = bytes.fromhex("e87ca97c4908")  # ldrb curHP; ldrb maxHP; lsr #1
IGNIS_DEF_LIT = struct.pack("<I", DEF_GETTER)
IGNIS_RES_LIT = struct.pack("<I", RES_GETTER)

_rom = built_rom.load
_symbols = built_rom.symbols


def _map_uc(rom):
    from unicorn import Uc, UC_ARCH_ARM, UC_MODE_THUMB

    uc = Uc(UC_ARCH_ARM, UC_MODE_THUMB)
    size = (len(rom) + 0xFFF) & ~0xFFF
    uc.mem_map(0x02000000, 0x40000)
    uc.mem_map(0x03000000, 0x10000)
    uc.mem_map(ROM_BASE, size)
    uc.mem_write(ROM_BASE, rom)
    return uc


def _follow_f800(uc, *, skill_ids=(), roll_result=1, defense=None, resist=None,
                 recorded_chance=None):
    from unicorn import UC_HOOK_CODE
    from unicorn.arm_const import (
        UC_ARM_REG_LR, UC_ARM_REG_PC, UC_ARM_REG_R0, UC_ARM_REG_R1)

    tester = _symbols()["SkillTester"] & ~1

    def on_insn(uc_, addr, size, _ud):
        hw = struct.unpack("<H", uc_.mem_read(addr, 2))[0]
        if hw != 0xF800:
            return
        target = uc_.reg_read(UC_ARM_REG_LR) & ~1
        ret = (addr + 2) | 1
        if target == ROLL1RN:
            if recorded_chance is not None:
                recorded_chance.append(uc_.reg_read(UC_ARM_REG_R0))
            uc_.reg_write(UC_ARM_REG_R0, roll_result)
            uc_.reg_write(UC_ARM_REG_LR, ret)
            uc_.reg_write(UC_ARM_REG_PC, ret)
            return
        if target == tester:
            sid = uc_.reg_read(UC_ARM_REG_R1) & 0xFF
            uc_.reg_write(UC_ARM_REG_R0, 1 if sid in skill_ids else 0)
            uc_.reg_write(UC_ARM_REG_LR, ret)
            uc_.reg_write(UC_ARM_REG_PC, ret)
            return
        if defense is not None and target == DEF_GETTER:
            uc_.reg_write(UC_ARM_REG_R0, defense)
            uc_.reg_write(UC_ARM_REG_LR, ret)
            uc_.reg_write(UC_ARM_REG_PC, ret)
            return
        if resist is not None and target == RES_GETTER:
            uc_.reg_write(UC_ARM_REG_R0, resist)
            uc_.reg_write(UC_ARM_REG_LR, ret)
            uc_.reg_write(UC_ARM_REG_PC, ret)
            return
        uc_.reg_write(UC_ARM_REG_LR, ret)
        uc_.reg_write(UC_ARM_REG_PC, target | 1)

    uc.hook_add(UC_HOOK_CODE, on_insn)


class HeroRomTests(unittest.TestCase):
    def test_d100_hook_lists_hero_after_rightful_god(self):
        rom, sym = _rom(), _symbols()
        hook = rom[D100_HOOK:D100_HOOK + 8]
        self.assertEqual(hook[:4], bytes.fromhex("004b1847"))
        dest = struct.unpack_from("<I", hook, 4)[0]
        self.assertEqual(dest & ~1, sym["SkillActivationChanceCalcLoopFunc"] & ~1)

        table = built_rom.offset(rom, sym["SkillActivationChanceCalcLoop"], 20)
        entries = [struct.unpack_from("<I", rom, table + 4 * i)[0] for i in range(5)]
        self.assertEqual(entries[2], sym["HeroSkill"])
        self.assertEqual(entries[4], 0)
        body_off = built_rom.offset(rom, entries[2] & ~1, 32)
        self.assertIn(HERO_HP_SIG, rom[body_off:body_off + 32])
        self.assertEqual(rom[built_rom.offset(rom, sym["HeroIDLink"], 1)], HERO_ID)

    def _hero_chance(self, cur_hp, max_hp, *, has_hero=True, config=0):
        from unicorn.arm_const import UC_ARM_REG_LR, UC_ARM_REG_R0, UC_ARM_REG_R1, UC_ARM_REG_SP

        rom, sym = _rom(), _symbols()
        recorded = []
        uc = _map_uc(rom)
        _follow_f800(uc, skill_ids={HERO_ID} if has_hero else (), recorded_chance=recorded)
        uc.mem_write(UNIT + 0x12, bytes([max_hp, cur_hp]))
        uc.mem_write(G_BATTLE_STATS, struct.pack("<H", config))
        uc.reg_write(UC_ARM_REG_SP, SP)
        uc.reg_write(UC_ARM_REG_R0, CHANCE)
        uc.reg_write(UC_ARM_REG_R1, UNIT)
        uc.reg_write(UC_ARM_REG_LR, STOP | 1)
        entry = sym["SkillActivationChanceCalcLoopFunc"] & ~1
        uc.emu_start(entry | 1, STOP, timeout=2_000_000, count=200_000)
        return recorded[0] if recorded else None

    def test_half_hp_adds_30_before_the_roll(self):
        self.assertEqual(self._hero_chance(8, 16), CHANCE + HERO_BONUS)

    def test_below_half_adds_30(self):
        self.assertEqual(self._hero_chance(7, 16), CHANCE + HERO_BONUS)

    def test_above_half_does_not_add_30(self):
        self.assertEqual(self._hero_chance(9, 16), CHANCE)

    def test_no_bonus_without_hero(self):
        self.assertEqual(self._hero_chance(8, 16, has_hero=False), CHANCE)

    def test_forecast_does_not_roll(self):
        self.assertIsNone(self._hero_chance(8, 16, config=FORECAST))


class IgnisRomTests(unittest.TestCase):
    def test_ignis_is_in_the_battle_proc_loop(self):
        rom, sym = _rom(), _symbols()
        self.assertIn("Proc_Ignis", sym)
        self.assertIn("ProcLoopParent", sym)
        self.assertNotEqual(sym.get("IgnisID", IGNIS_ID), 255)
        parent = built_rom.offset(rom, sym["ProcLoopParent"])
        table = rom.find(struct.pack("<I", sym["ProcLoop_Start"]), parent)
        self.assertNotEqual(table, -1)
        found = False
        for i in range(40):
            ptr = struct.unpack_from("<I", rom, table + 4 * i)[0]
            if ptr == 0:
                break
            if ptr == sym["Proc_Ignis"]:
                found = True
                body = rom[built_rom.offset(rom, ptr, 160):][:160]
                self.assertIn(IGNIS_DEF_LIT, body)
                self.assertIn(IGNIS_RES_LIT, body)
                break
        self.assertTrue(found, "Proc_Ignis missing from the battle proc loop")
        tail = built_rom.offset(rom, sym["Proc_Ignis"], 156) + 152
        self.assertEqual(struct.unpack_from("<I", rom, tail)[0], IGNIS_ID)

    def _ignis(self, *, has_skill=True, defense=10, resist=8, dmg=10, bufword=0):
        from unicorn.arm_const import (
            UC_ARM_REG_LR, UC_ARM_REG_R0, UC_ARM_REG_R1, UC_ARM_REG_R2,
            UC_ARM_REG_R3, UC_ARM_REG_SP)

        rom, sym = _rom(), _symbols()
        uc = _map_uc(rom)
        _follow_f800(
            uc,
            skill_ids={IGNIS_ID} if has_skill else (),
            defense=defense,
            resist=resist,
        )
        atk = bytearray(0x80)
        atk[0x15] = 40
        uc.mem_write(ATTACKER, bytes(atk))
        uc.mem_write(DEFENDER, bytes(0x80))
        uc.mem_write(ROUND_BUFFER, struct.pack("<I", bufword))
        bd = bytearray(0x10)
        struct.pack_into("<h", bd, 4, dmg)
        uc.mem_write(BATTLE_DATA, bytes(bd))
        uc.mem_write(G_BATTLE_STATS, bytes(4))
        uc.reg_write(UC_ARM_REG_SP, SP)
        uc.reg_write(UC_ARM_REG_R0, ATTACKER)
        uc.reg_write(UC_ARM_REG_R1, DEFENDER)
        uc.reg_write(UC_ARM_REG_R2, ROUND_BUFFER)
        uc.reg_write(UC_ARM_REG_R3, BATTLE_DATA)
        uc.reg_write(UC_ARM_REG_LR, STOP | 1)
        entry = sym["Proc_Ignis"] & ~1
        uc.emu_start(entry | 1, STOP, timeout=2_000_000, count=500_000)
        return {
            "word": struct.unpack("<I", uc.mem_read(ROUND_BUFFER, 4))[0],
            "dmg": struct.unpack("<h", uc.mem_read(BATTLE_DATA + 4, 2))[0],
            "sid": uc.mem_read(ROUND_BUFFER + 4, 1)[0],
        }

    def test_proc_adds_half_def_half_res_and_writes_ignis_id(self):
        out = self._ignis()
        self.assertTrue(out["word"] & SKILL_FLAG)
        self.assertEqual(out["dmg"], 10 + 5 + 4)
        self.assertEqual(out["sid"], IGNIS_ID)

    def test_crit_triples_the_bonus(self):
        out = self._ignis(bufword=1)
        self.assertEqual(out["dmg"], 10 + (5 + 4) * 3)

    def test_no_skill_leaves_damage_alone(self):
        out = self._ignis(has_skill=False)
        self.assertFalse(out["word"] & SKILL_FLAG)
        self.assertEqual(out["dmg"], 10)
        self.assertEqual(out["sid"], 0)

    def test_miss_does_not_proc(self):
        out = self._ignis(bufword=MISS)
        self.assertFalse(out["word"] & SKILL_FLAG)
        self.assertEqual(out["dmg"], 10)


if __name__ == "__main__":
    unittest.main()
