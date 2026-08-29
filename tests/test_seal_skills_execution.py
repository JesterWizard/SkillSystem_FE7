"""Seal skills: after combat, -6 to the matching stat (recover 1/turn).

ApplyDebuff is executed from FE7_Hack.gba. The BattleApplyUnitUpdates hook at
0x29AD0 must point at SealSkills.
"""
import struct
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
sys.path.insert(0, str(Path(__file__).resolve().parent))

import built_rom  # noqa: E402

ROM_BASE = 0x08000000
PAGE = 0x1000
EWRAM, EWRAM_SIZE = 0x02000000, 0x40000
IWRAM, IWRAM_SIZE = 0x03000000, 0x8000
UNIT = 0x0202BD50
CHAR_TABLE, CHAR_ENTRY = 0x08BDCE18, 0x34
CLASS_TABLE, CLASS_ENTRY = 0x08BE015C, 0x54
ACTOR = 0x0203A3F0
TARGET = 0x0203A470
PU_DEBUFF = 0x0203F100
DEBUFF_ENTRY = 8
SUPPORTS = 0x32
STOP = 0x08000100
BL_SUFFIX = b"\x00\xf8"
HOOK = 0x29AD0
UPDATE_UNIT = 0x08029C24
BALLISTA = 0x0802A314
BITS = 6
SEAL_STR_ID = 10
# SealSkillList order: Str Skl Spd Def Res Luk Mag
SEAL_NTH = {"str": 0, "skl": 1, "spd": 2, "def": 3, "res": 4, "luk": 5, "mag": 6}
SEAL_IDS = {
    "str": 10,
    "skl": 8,
    "spd": 9,
    "def": 4,
    "luk": 5,
    "res": 7,
    "mag": 6,
}
BIT_OFF = {
    "mag": 0,
    "str": 6,
    "skl": 12,
    "spd": 18,
    "def": 24,
    "res": 30,
    "luk": 36,
}


def _i32(value):
    value &= 0xFFFFFFFF
    return value - 0x100000000 if value >= 0x80000000 else value


def _blh_suffixes(rom, lo, hi):
    out, i = [], lo
    while True:
        i = rom.find(BL_SUFFIX, i, hi)
        if i == -1:
            return out
        if i >= 2:
            prev = rom[i - 2 : i]
            if prev[1] == 0x46 and (prev[0] & 0xC7) == 0x86:
                out.append(ROM_BASE + i)
        i += 2


class SealSkillsExecutionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        try:
            from unicorn import Uc, UC_ARCH_ARM, UC_MODE_THUMB  # noqa: F401
        except ImportError:
            raise unittest.SkipTest("unicorn not installed")
        cls.rom = built_rom.load()
        cls.sym = built_rom.symbols()
        for name in (
            "ApplyDebuff",
            "SealSkills",
            "SkillTester",
            "UnpackData_Signed",
            "GetUnitDebuffEntry",
            "PackData_Signed",
            "ApplyWeaponDebuffs",
        ):
            if name not in cls.sym:
                raise unittest.SkipTest(f"{name} missing from FE7_Hack.sym")

    def test_hook_at_battle_apply_unit_updates(self):
        off = HOOK
        self.assertEqual(self.rom[off : off + 4], bytes.fromhex("004b1847"))
        dest = struct.unpack_from("<I", self.rom, off + 4)[0] & ~1
        self.assertEqual(dest, self.sym["SealSkills"] & ~1)

    def _map(self):
        from unicorn import Uc, UC_ARCH_ARM, UC_MODE_THUMB

        rom = self.rom
        uc = Uc(UC_ARCH_ARM, UC_MODE_THUMB)
        size = (len(rom) + PAGE - 1) // PAGE * PAGE
        uc.mem_map(ROM_BASE, size)
        uc.mem_write(ROM_BASE, rom + bytes(size - len(rom)))
        uc.mem_map(EWRAM, EWRAM_SIZE)
        uc.mem_map(IWRAM, IWRAM_SIZE)
        return uc

    def _unpack(self, uc, nth_name):
        from unicorn import UcError
        from unicorn.arm_const import UC_ARM_REG_R0, UC_ARM_REG_R1, UC_ARM_REG_R2, UC_ARM_REG_LR, UC_ARM_REG_PC, UC_ARM_REG_SP

        unpack = self.sym["UnpackData_Signed"] & ~1
        entry = PU_DEBUFF + 1 * DEBUFF_ENTRY
        uc.reg_write(UC_ARM_REG_SP, IWRAM + IWRAM_SIZE - PAGE)
        uc.reg_write(UC_ARM_REG_R0, entry)
        uc.reg_write(UC_ARM_REG_R1, BIT_OFF[nth_name])
        uc.reg_write(UC_ARM_REG_R2, BITS)
        uc.reg_write(UC_ARM_REG_LR, STOP | 1)
        try:
            uc.emu_start(unpack | 1, STOP, timeout=5_000_000, count=50_000)
        except UcError as exc:
            self.fail(f"UnpackData_Signed faulted: {exc}")
        return _i32(uc.reg_read(UC_ARM_REG_R0))

    def test_apply_debuff_writes_minus_six_each_stat(self):
        from unicorn import UcError
        from unicorn.arm_const import UC_ARM_REG_R0, UC_ARM_REG_R1, UC_ARM_REG_R2, UC_ARM_REG_LR, UC_ARM_REG_PC, UC_ARM_REG_SP

        uc = self._map()
        uc.mem_write(UNIT, bytes(0x48))
        uc.mem_write(UNIT + 0x0B, bytes([1]))
        uc.mem_write(PU_DEBUFF, bytes(DEBUFF_ENTRY * 4))
        fn = self.sym["ApplyDebuff"] & ~1
        tramps = set(
            _blh_suffixes(
                self.rom,
                built_rom.offset(self.rom, fn),
                built_rom.offset(self.rom, fn) + 0x100,
            )
        )
        for name in ("GetUnitDebuffEntry", "UnpackData_Signed", "PackData_Signed"):
            a = self.sym[name] & ~1
            tramps |= set(
                _blh_suffixes(
                    self.rom,
                    built_rom.offset(self.rom, a),
                    built_rom.offset(self.rom, a) + 0x100,
                )
            )

        def on_code(u, addr, _size, _d):
            if addr in tramps:
                from unicorn.arm_const import UC_ARM_REG_LR, UC_ARM_REG_PC

                lr = u.reg_read(UC_ARM_REG_LR)
                u.reg_write(UC_ARM_REG_LR, (addr + 2) | 1)
                u.reg_write(UC_ARM_REG_PC, lr | 1)

        from unicorn import UC_HOOK_CODE

        uc.hook_add(UC_HOOK_CODE, on_code)
        for name, nth in SEAL_NTH.items():
            with self.subTest(stat=name):
                uc.mem_write(PU_DEBUFF, bytes(DEBUFF_ENTRY * 4))
                uc.reg_write(UC_ARM_REG_SP, IWRAM + IWRAM_SIZE - PAGE)
                uc.reg_write(UC_ARM_REG_R0, UNIT)
                uc.reg_write(UC_ARM_REG_R1, 6)
                uc.reg_write(UC_ARM_REG_R2, nth)
                uc.reg_write(UC_ARM_REG_LR, STOP | 1)
                try:
                    uc.emu_start(fn | 1, STOP, timeout=10_000_000, count=200_000)
                except UcError as exc:
                    self.fail(f"ApplyDebuff {name} faulted: {exc}")
                self.assertEqual(uc.reg_read(UC_ARM_REG_PC), STOP)
                self.assertEqual(self._unpack(uc, name), -6)

    def test_apply_debuff_does_not_replace_worse_debuff(self):
        from unicorn import UcError, UC_HOOK_CODE
        from unicorn.arm_const import UC_ARM_REG_R0, UC_ARM_REG_R1, UC_ARM_REG_R2, UC_ARM_REG_R3, UC_ARM_REG_LR, UC_ARM_REG_PC, UC_ARM_REG_SP

        uc = self._map()
        uc.mem_write(UNIT, bytes(0x48))
        uc.mem_write(UNIT + 0x0B, bytes([1]))
        uc.mem_write(PU_DEBUFF, bytes(DEBUFF_ENTRY * 4))
        pack = self.sym["PackData_Signed"] & ~1
        uc.reg_write(UC_ARM_REG_SP, IWRAM + IWRAM_SIZE - PAGE)
        uc.reg_write(UC_ARM_REG_R0, PU_DEBUFF + DEBUFF_ENTRY)
        uc.reg_write(UC_ARM_REG_R1, BIT_OFF["str"])
        uc.reg_write(UC_ARM_REG_R2, BITS)
        uc.reg_write(UC_ARM_REG_R3, (-8) & 0xFFFFFFFF)
        uc.reg_write(UC_ARM_REG_LR, STOP | 1)
        uc.emu_start(pack | 1, STOP, timeout=5_000_000, count=50_000)

        fn = self.sym["ApplyDebuff"] & ~1
        tramps = set(
            _blh_suffixes(
                self.rom,
                built_rom.offset(self.rom, fn),
                built_rom.offset(self.rom, fn) + 0x100,
            )
        )

        def on_code(u, addr, _size, _d):
            if addr in tramps:
                lr = u.reg_read(UC_ARM_REG_LR)
                u.reg_write(UC_ARM_REG_LR, (addr + 2) | 1)
                u.reg_write(UC_ARM_REG_PC, lr | 1)

        uc.hook_add(UC_HOOK_CODE, on_code)
        uc.reg_write(UC_ARM_REG_R0, UNIT)
        uc.reg_write(UC_ARM_REG_R1, 6)
        uc.reg_write(UC_ARM_REG_R2, SEAL_NTH["str"])
        uc.reg_write(UC_ARM_REG_LR, STOP | 1)
        try:
            uc.emu_start(fn | 1, STOP, timeout=10_000_000, count=200_000)
        except UcError as exc:
            self.fail(f"ApplyDebuff faulted: {exc}")
        self.assertEqual(self._unpack(uc, "str"), -8)

    def test_seal_str_applies_to_defender_after_combat(self):
        from unicorn import UcError, UC_HOOK_CODE
        from unicorn.arm_const import (
            UC_ARM_REG_R0,
            UC_ARM_REG_R1,
            UC_ARM_REG_R2,
            UC_ARM_REG_R4,
            UC_ARM_REG_R5,
            UC_ARM_REG_R6,
            UC_ARM_REG_R7,
            UC_ARM_REG_LR,
            UC_ARM_REG_PC,
            UC_ARM_REG_SP,
        )

        uc = self._map()
        actor_u = UNIT
        target_u = UNIT + 0x48
        for addr, idx, skills in (
            (actor_u, 1, [SEAL_STR_ID]),
            (target_u, 2, []),
        ):
            uc.mem_write(addr, bytes(0x48))
            uc.mem_write(addr + 0x00, struct.pack("<I", CHAR_TABLE + CHAR_ENTRY * 1))
            uc.mem_write(addr + 0x04, struct.pack("<I", CLASS_TABLE + CLASS_ENTRY * 1))
            uc.mem_write(addr + 0x0B, bytes([idx]))
            uc.mem_write(addr + 0x13, bytes([20]))
            for i, skill in enumerate(skills):
                uc.mem_write(addr + SUPPORTS + i, bytes([skill]))
        uc.mem_write(ACTOR, bytes(0x80))
        uc.mem_write(TARGET, bytes(0x80))
        uc.mem_write(ACTOR + 0x0B, bytes([1]))
        uc.mem_write(TARGET + 0x0B, bytes([2]))
        uc.mem_write(ACTOR + 0x13, bytes([20]))
        uc.mem_write(TARGET + 0x13, bytes([20]))
        uc.mem_write(PU_DEBUFF, bytes(DEBUFF_ENTRY * 8))

        fn = self.sym["SealSkills"] & ~1
        skilltester = self.sym["SkillTester"] & ~1
        weapon = self.sym["ApplyWeaponDebuffs"] & ~1
        tramps = set(
            _blh_suffixes(
                self.rom,
                built_rom.offset(self.rom, fn),
                built_rom.offset(self.rom, fn) + 0x400,
            )
        )
        apply_debuff = self.sym["ApplyDebuff"] & ~1
        tramps |= set(
            _blh_suffixes(
                self.rom,
                built_rom.offset(self.rom, apply_debuff),
                built_rom.offset(self.rom, apply_debuff) + 0x100,
            )
        )
        seen = []

        def on_code(u, addr, _size, _d):
            if (addr & ~1) in (UPDATE_UNIT, BALLISTA, weapon):
                u.reg_write(UC_ARM_REG_PC, u.reg_read(UC_ARM_REG_LR) | 1)
                return
            if (addr & ~1) == skilltester:
                sid = u.reg_read(UC_ARM_REG_R1) & 0xFF
                seen.append(sid)
                unit = u.reg_read(UC_ARM_REG_R0)
                owns = sid in list(u.mem_read(unit + SUPPORTS, 6))
                result = 1 if sid and sid != 255 and owns else 0
                u.reg_write(UC_ARM_REG_R0, result)
                u.reg_write(UC_ARM_REG_PC, u.reg_read(UC_ARM_REG_LR) | 1)
                return
            if addr in tramps:
                lr = u.reg_read(UC_ARM_REG_LR)
                u.reg_write(UC_ARM_REG_LR, (addr + 2) | 1)
                u.reg_write(UC_ARM_REG_PC, lr | 1)

        uc.hook_add(UC_HOOK_CODE, on_code)
        sp = IWRAM + IWRAM_SIZE - PAGE - 20
        # BattleApplyUnitUpdates already pushed {r4-r7, lr} before the hook.
        uc.mem_write(sp, struct.pack("<IIIII", 0, 0, 0, 0, STOP | 1))
        uc.reg_write(UC_ARM_REG_SP, sp)
        uc.reg_write(UC_ARM_REG_R4, TARGET)
        uc.reg_write(UC_ARM_REG_R5, ACTOR)
        uc.reg_write(UC_ARM_REG_R6, target_u)
        uc.reg_write(UC_ARM_REG_R7, actor_u)
        uc.reg_write(UC_ARM_REG_LR, STOP | 1)
        try:
            uc.emu_start(fn | 1, STOP, timeout=20_000_000, count=500_000)
        except UcError as exc:
            pc = uc.reg_read(UC_ARM_REG_PC)
            lr = uc.reg_read(UC_ARM_REG_LR)
            self.fail(f"SealSkills faulted: {exc} pc={pc:#x} lr={lr:#x}")
        self.assertEqual(uc.reg_read(UC_ARM_REG_PC), STOP)
        self.assertIn(SEAL_STR_ID, seen)
        unpack = self.sym["UnpackData_Signed"] & ~1
        uc.reg_write(UC_ARM_REG_SP, IWRAM + IWRAM_SIZE - PAGE)
        uc.reg_write(UC_ARM_REG_R0, PU_DEBUFF + 2 * DEBUFF_ENTRY)
        uc.reg_write(UC_ARM_REG_R1, BIT_OFF["str"])
        uc.reg_write(UC_ARM_REG_R2, BITS)
        uc.reg_write(UC_ARM_REG_LR, STOP | 1)
        uc.emu_start(unpack | 1, STOP, timeout=5_000_000, count=50_000)
        self.assertEqual(_i32(uc.reg_read(UC_ARM_REG_R0)), -6)


if __name__ == "__main__":
    unittest.main()
