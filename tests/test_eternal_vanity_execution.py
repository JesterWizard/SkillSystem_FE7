"""Eternal Vanity: buffed stats do not deplete. GetNewTemporaryStatValue + ProcessDebuffs."""
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
CHAPTER = 0x0202BBF8
UNIT1 = 0x0202BD50
CHAR_TABLE, CHAR_ENTRY = 0x08BDCE18, 0x34
CLASS_TABLE, CLASS_ENTRY = 0x08BE015C, 0x54
SUPPORTS = 0x32
PU_DEBUFF = 0x0203F100
DEBUFF_ENTRY = 8
STOP = 0x08000100
BL_SUFFIX = b"\x00\xf8"
MOV_LR_R3 = b"\x9e\x46"
GET_UNIT = 0x08018D0C
ETERNAL_VANITY_ID = 1
STR_BIT = 6  # DebuffStatBitOffset_Str = 1 * 6
BITS = 6


def _i32(value):
    value &= 0xFFFFFFFF
    return value - 0x100000000 if value >= 0x80000000 else value


def _blh_suffixes(rom, lo, hi):
    out, i = [], lo
    while True:
        i = rom.find(BL_SUFFIX, i, hi)
        if i == -1:
            return out
        if i >= 2 and rom[i - 2 : i] == MOV_LR_R3:
            out.append(ROM_BASE + i)
        i += 2


class EternalVanityExecutionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        try:
            from unicorn import Uc, UC_ARCH_ARM, UC_MODE_THUMB  # noqa: F401
        except ImportError:
            raise unittest.SkipTest("unicorn not installed")
        cls.rom = built_rom.load()
        cls.sym = built_rom.symbols()
        for name in (
            "GetNewTemporaryStatValue",
            "ProcessDebuffs",
            "SkillTester",
            "UnpackData_Signed",
            "PackData_Signed",
            "GetUnitDebuffEntry",
            "IsUnitOnField",
        ):
            if name not in cls.sym:
                raise unittest.SkipTest(f"{name} missing from FE7_Hack.sym")

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

    def _run_new_value(self, value, skip_deplete):
        from unicorn import UcError
        from unicorn.arm_const import UC_ARM_REG_R0, UC_ARM_REG_R1, UC_ARM_REG_LR, UC_ARM_REG_PC, UC_ARM_REG_SP

        uc = self._map()
        fn = self.sym["GetNewTemporaryStatValue"] & ~1
        uc.reg_write(UC_ARM_REG_SP, IWRAM + IWRAM_SIZE - PAGE)
        uc.reg_write(UC_ARM_REG_R0, value & 0xFFFFFFFF)
        uc.reg_write(UC_ARM_REG_R1, 1 if skip_deplete else 0)
        uc.reg_write(UC_ARM_REG_LR, STOP | 1)
        try:
            uc.emu_start(fn | 1, STOP, timeout=5_000_000, count=50_000)
        except UcError as exc:
            self.fail(f"GetNewTemporaryStatValue faulted: {exc}")
        self.assertEqual(uc.reg_read(UC_ARM_REG_PC), STOP)
        return _i32(uc.reg_read(UC_ARM_REG_R0))

    def test_buff_held_when_skip_flag_set(self):
        self.assertEqual(self._run_new_value(5, True), 5)

    def test_buff_depletes_one_without_skip(self):
        self.assertEqual(self._run_new_value(5, False), 4)

    def test_debuff_recovers_one_regardless_of_skip(self):
        self.assertEqual(self._run_new_value(-6, False), -5)
        self.assertEqual(self._run_new_value(-6, True), -5)

    def _pack_str(self, uc, amount):
        from unicorn import UcError
        from unicorn.arm_const import UC_ARM_REG_R0, UC_ARM_REG_R1, UC_ARM_REG_R2, UC_ARM_REG_R3, UC_ARM_REG_LR, UC_ARM_REG_PC, UC_ARM_REG_SP

        pack = self.sym["PackData_Signed"] & ~1
        entry = PU_DEBUFF + 1 * DEBUFF_ENTRY
        uc.mem_write(entry, bytes(DEBUFF_ENTRY))
        uc.reg_write(UC_ARM_REG_SP, IWRAM + IWRAM_SIZE - PAGE)
        uc.reg_write(UC_ARM_REG_R0, entry)
        uc.reg_write(UC_ARM_REG_R1, STR_BIT)
        uc.reg_write(UC_ARM_REG_R2, BITS)
        uc.reg_write(UC_ARM_REG_R3, amount & 0xFFFFFFFF)
        uc.reg_write(UC_ARM_REG_LR, STOP | 1)
        try:
            uc.emu_start(pack | 1, STOP, timeout=5_000_000, count=50_000)
        except UcError as exc:
            self.fail(f"PackData_Signed faulted: {exc}")

    def _unpack_str(self, uc):
        from unicorn import UcError
        from unicorn.arm_const import UC_ARM_REG_R0, UC_ARM_REG_R1, UC_ARM_REG_R2, UC_ARM_REG_LR, UC_ARM_REG_PC, UC_ARM_REG_SP

        unpack = self.sym["UnpackData_Signed"] & ~1
        entry = PU_DEBUFF + 1 * DEBUFF_ENTRY
        uc.reg_write(UC_ARM_REG_SP, IWRAM + IWRAM_SIZE - PAGE)
        uc.reg_write(UC_ARM_REG_R0, entry)
        uc.reg_write(UC_ARM_REG_R1, STR_BIT)
        uc.reg_write(UC_ARM_REG_R2, BITS)
        uc.reg_write(UC_ARM_REG_LR, STOP | 1)
        try:
            uc.emu_start(unpack | 1, STOP, timeout=5_000_000, count=50_000)
        except UcError as exc:
            self.fail(f"UnpackData_Signed faulted: {exc}")
        return _i32(uc.reg_read(UC_ARM_REG_R0))

    def _run_process(self, has_skill):
        from unicorn import UcError, UC_HOOK_CODE
        from unicorn.arm_const import (
            UC_ARM_REG_R0,
            UC_ARM_REG_R1,
            UC_ARM_REG_LR,
            UC_ARM_REG_PC,
            UC_ARM_REG_SP,
        )

        uc = self._map()
        uc.mem_write(UNIT1, bytes(0x48))
        uc.mem_write(UNIT1 + 0x00, struct.pack("<I", CHAR_TABLE + CHAR_ENTRY * 1))
        uc.mem_write(UNIT1 + 0x04, struct.pack("<I", CLASS_TABLE + CLASS_ENTRY * 1))
        uc.mem_write(CHAR_TABLE + CHAR_ENTRY * 1 + 4, bytes([1]))
        uc.mem_write(UNIT1 + 0x0B, bytes([1]))
        uc.mem_write(UNIT1 + 0x0C, struct.pack("<I", 0))
        skills = [ETERNAL_VANITY_ID] if has_skill else []
        for i, skill in enumerate(skills):
            uc.mem_write(UNIT1 + SUPPORTS + i, bytes([skill]))
        uc.mem_write(CHAPTER + 0x0F, bytes([0]))
        self._pack_str(uc, 5)

        fn = self.sym["ProcessDebuffs"] & ~1
        skilltester = self.sym["SkillTester"] & ~1
        on_field = self.sym["IsUnitOnField"] & ~1
        tramps = set(
            _blh_suffixes(
                self.rom,
                built_rom.offset(self.rom, fn),
                built_rom.offset(self.rom, fn) + 0x400,
            )
        )
        seen = []

        def on_code(u, addr, _size, _d):
            if (addr & ~1) == GET_UNIT:
                idx = u.reg_read(UC_ARM_REG_R0)
                u.reg_write(UC_ARM_REG_R0, UNIT1 if idx == 1 else 0)
                u.reg_write(UC_ARM_REG_PC, u.reg_read(UC_ARM_REG_LR) | 1)
                return
            if (addr & ~1) == on_field:
                unit = u.reg_read(UC_ARM_REG_R0)
                u.reg_write(UC_ARM_REG_R0, 1 if unit == UNIT1 else 0)
                u.reg_write(UC_ARM_REG_PC, u.reg_read(UC_ARM_REG_LR) | 1)
                return
            if (addr & ~1) == skilltester:
                sid = u.reg_read(UC_ARM_REG_R1) & 0xFF
                seen.append(sid)
                unit = u.reg_read(UC_ARM_REG_R0)
                owns = sid in list(u.mem_read(UNIT1 + SUPPORTS, 6)) if unit == UNIT1 else False
                result = 1 if sid and sid != 255 and owns else 0
                u.reg_write(UC_ARM_REG_R0, result)
                u.reg_write(UC_ARM_REG_PC, u.reg_read(UC_ARM_REG_LR) | 1)
                return
            if addr in tramps:
                lr = u.reg_read(UC_ARM_REG_LR)
                u.reg_write(UC_ARM_REG_LR, (addr + 2) | 1)
                u.reg_write(UC_ARM_REG_PC, lr | 1)

        uc.hook_add(UC_HOOK_CODE, on_code)
        uc.reg_write(UC_ARM_REG_SP, IWRAM + IWRAM_SIZE - PAGE)
        uc.reg_write(UC_ARM_REG_LR, STOP | 1)
        try:
            uc.emu_start(fn | 1, STOP, timeout=20_000_000, count=800_000)
        except UcError as exc:
            self.fail(f"ProcessDebuffs faulted: {exc}")
        self.assertEqual(uc.reg_read(UC_ARM_REG_PC), STOP)
        return self._unpack_str(uc), seen

    def test_process_holds_buff_with_eternal_vanity(self):
        value, seen = self._run_process(True)
        self.assertEqual(value, 5)
        self.assertIn(ETERNAL_VANITY_ID, seen)

    def test_process_depletes_buff_without_eternal_vanity(self):
        value, seen = self._run_process(False)
        self.assertEqual(value, 4)
        self.assertIn(ETERNAL_VANITY_ID, seen)


if __name__ == "__main__":
    unittest.main()
