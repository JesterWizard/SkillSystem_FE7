"""Armor March start-of-turn bit and GetUnitMov +2, from FE7_Hack.gba.

The skill ID must be passed to SkillTester as a 32-bit value 1-254. lyn
emits `POIN ArmorMarchID` for `ldr r1, =ArmorMarchID`, and Event Assembler
turns a small integer POIN into 0x08000002. SkillTester then never matches
skill 2 in the buffer, so the debuff bit is never set and movement is unchanged.
"""
import json
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
CHAR_TABLE, CHAR_ENTRY = 0x08BDCE18, 0x34
CLASS_TABLE, CLASS_ENTRY = 0x08BE015C, 0x54
UNIT1 = 0x0202BD50
UNIT2 = 0x0202BD98
KNIGHT = 0x14
ARMOR_MARCH_ID = 2
ARMOR_MARCH_BIT = 60
ARMOR_MARCH_BONUS = 2
SUPPORTS = 0x32
STOP = 0x08000100
BL_SUFFIX = b"\x00\xf8"
PU_DEBUFF = 0x0203F100
DEBUFF_ENTRY = 8


def _bl_suffixes(rom, lo, hi):
    out, i = [], lo
    while True:
        i = rom.find(BL_SUFFIX, i, hi)
        if i == -1:
            return out
        out.append(ROM_BASE + i)
        i += 2


def _bit_set(entry: bytes) -> bool:
    byte, bit = divmod(ARMOR_MARCH_BIT, 8)
    return bool(entry[byte] & (1 << bit))


class ArmorMarchExecutionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        try:
            from unicorn import Uc, UC_ARCH_ARM, UC_MODE_THUMB  # noqa: F401
        except ImportError:
            raise unittest.SkipTest("unicorn not installed")
        cls.rom = built_rom.load()
        cls.sym = built_rom.symbols()
        snapshot = json.loads((ROOT / "tests" / "skill_id_snapshot.json").read_text(encoding="utf-8"))
        if snapshot.get("ArmorMarchID", 255) == 255:
            raise unittest.SkipTest("ArmorMarchID is SKILL_OFF")
        for name in (
            "ArmorMarch_StartOfTurn",
            "TurnCalcLoop_Silent",
            "SkillTester",
            "GetUnitsInRange",
            "GetUnitDebuffEntry",
            "SetBit",
            "UnsetBit",
            "IsUnitOnField",
            "prArmorMarchCheck",
        ):
            if name not in cls.sym:
                raise unittest.SkipTest(f"{name} missing from FE7_Hack.sym")

    def test_silent_loop_points_at_start_of_turn(self):
        off = built_rom.offset(self.rom, self.sym["TurnCalcLoop_Silent"])
        ptrs = []
        for i in range(8):
            p = struct.unpack_from("<I", self.rom, off + i * 4)[0]
            if p == 0:
                break
            ptrs.append(p)
        self.assertIn(self.sym["ArmorMarch_StartOfTurn"], ptrs)

    def test_skilltester_receives_catalog_id_not_poin(self):
        seen = []
        self._run_start_of_turn(seen)
        self.assertTrue(seen, "SkillTester was never called")
        self.assertIn(
            ARMOR_MARCH_ID,
            seen,
            f"SkillTester r1 values were {[hex(x) for x in seen]}; "
            "lyn POIN of a skill ID adds 0x08000000",
        )

    def test_sets_bit_on_skill_holder_and_adjacent_armor(self):
        self._run_start_of_turn([])
        e1 = self.uc.mem_read(PU_DEBUFF + 1 * DEBUFF_ENTRY, DEBUFF_ENTRY)
        e2 = self.uc.mem_read(PU_DEBUFF + 2 * DEBUFF_ENTRY, DEBUFF_ENTRY)
        self.assertTrue(_bit_set(e1), "skill holder did not get Armor March")
        self.assertTrue(_bit_set(e2), "adjacent armor ally did not get Armor March")

    def test_check_adds_two_when_bit_is_set_and_not_when_clear(self):
        from unicorn import UcError, UC_HOOK_CODE
        from unicorn.arm_const import (
            UC_ARM_REG_R0, UC_ARM_REG_R1, UC_ARM_REG_LR, UC_ARM_REG_PC, UC_ARM_REG_SP,
        )

        check = self.sym["prArmorMarchCheck"] & ~1
        tramps = set(
            _bl_suffixes(
                self.rom,
                built_rom.offset(self.rom, check),
                built_rom.offset(self.rom, check) + 0x40,
            )
        )
        for name, size in (("GetUnitDebuffEntry", 0x80), ("CheckBit", 0x40)):
            a = self.sym[name] & ~1
            tramps |= set(
                _bl_suffixes(
                    self.rom,
                    built_rom.offset(self.rom, a),
                    built_rom.offset(self.rom, a) + size,
                )
            )

        def run(bit_on: bool) -> int:
            uc = self._map()
            self._write_unit(uc, UNIT1, 1, KNIGHT, [ARMOR_MARCH_ID], 5, 5)
            entry = bytearray(DEBUFF_ENTRY)
            if bit_on:
                entry[ARMOR_MARCH_BIT // 8] |= 1 << (ARMOR_MARCH_BIT % 8)
            uc.mem_write(PU_DEBUFF + 1 * DEBUFF_ENTRY, bytes(entry))

            def on_code(u, addr, _size, _d):
                if addr in tramps:
                    lr = u.reg_read(UC_ARM_REG_LR)
                    u.reg_write(UC_ARM_REG_LR, (addr + 2) | 1)
                    u.reg_write(UC_ARM_REG_PC, lr | 1)

            uc.hook_add(UC_HOOK_CODE, on_code)
            uc.reg_write(UC_ARM_REG_SP, IWRAM + IWRAM_SIZE - PAGE)
            uc.reg_write(UC_ARM_REG_R0, 6)
            uc.reg_write(UC_ARM_REG_R1, UNIT1)
            uc.reg_write(UC_ARM_REG_LR, STOP | 1)
            try:
                uc.emu_start(check | 1, STOP, timeout=5_000_000, count=50_000)
            except UcError as exc:
                self.fail(f"prArmorMarchCheck faulted: {exc}")
            self.assertEqual(uc.reg_read(UC_ARM_REG_PC), STOP)
            return uc.reg_read(UC_ARM_REG_R0)

        self.assertEqual(run(False), 6)
        self.assertEqual(run(True), 6 + ARMOR_MARCH_BONUS)

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

    def _write_unit(self, uc, addr, index, class_id, skills, x, y):
        uc.mem_write(addr, bytes(0x48))
        uc.mem_write(addr + 0x00, struct.pack("<I", CHAR_TABLE + CHAR_ENTRY * 1))
        uc.mem_write(addr + 0x04, struct.pack("<I", CLASS_TABLE + CLASS_ENTRY * class_id))
        uc.mem_write(addr + 0x0B, bytes([index]))
        uc.mem_write(addr + 0x10, bytes([x]))
        uc.mem_write(addr + 0x11, bytes([y]))
        for i, skill in enumerate(skills):
            uc.mem_write(addr + SUPPORTS + i, bytes([skill]))

    def _run_start_of_turn(self, seen_ids):
        from unicorn import UcError, UC_HOOK_CODE
        from unicorn.arm_const import (
            UC_ARM_REG_R0, UC_ARM_REG_R1, UC_ARM_REG_LR, UC_ARM_REG_PC, UC_ARM_REG_SP,
        )

        uc = self._map()
        self.uc = uc
        self._write_unit(uc, UNIT1, 1, KNIGHT, [ARMOR_MARCH_ID], 5, 5)
        self._write_unit(uc, UNIT2, 2, KNIGHT, [], 6, 5)
        uc.mem_write(CHAPTER + 0x0F, bytes([0]))

        am = self.sym["ArmorMarch_StartOfTurn"] & ~1
        tramps = set(
            _bl_suffixes(
                self.rom,
                built_rom.offset(self.rom, am),
                built_rom.offset(self.rom, am) + 0x200,
            )
        )
        for name, size in (
            ("SkillTester", 0x300),
            ("GetUnitsInRange", 0x200),
            ("GetUnitDebuffEntry", 0x80),
            ("SetBit", 0x40),
            ("UnsetBit", 0x40),
            ("IsUnitOnField", 0x40),
            ("CheckBit", 0x40),
        ):
            a = self.sym[name] & ~1
            tramps |= set(
                _bl_suffixes(
                    self.rom,
                    built_rom.offset(self.rom, a),
                    built_rom.offset(self.rom, a) + size,
                )
            )
        tramps |= set(_bl_suffixes(self.rom, 0x18D0C, 0x18D20))
        tramps |= set(_bl_suffixes(self.rom, 0x0238B0, 0x0238F0))

        def on_code(u, addr, _size, _d):
            if addr in tramps:
                lr = u.reg_read(UC_ARM_REG_LR)
                u.reg_write(UC_ARM_REG_LR, (addr + 2) | 1)
                u.reg_write(UC_ARM_REG_PC, lr | 1)
                return
            if (addr & ~1) == (self.sym["SkillTester"] & ~1):
                seen_ids.append(u.reg_read(UC_ARM_REG_R1))

        uc.hook_add(UC_HOOK_CODE, on_code)
        uc.reg_write(UC_ARM_REG_SP, IWRAM + IWRAM_SIZE - PAGE)
        uc.reg_write(UC_ARM_REG_LR, STOP | 1)
        try:
            uc.emu_start(am | 1, STOP, timeout=20_000_000, count=500_000)
        except UcError as exc:
            self.fail(f"ArmorMarch_StartOfTurn faulted: {exc}")
        self.assertEqual(uc.reg_read(UC_ARM_REG_PC), STOP)


if __name__ == "__main__":
    unittest.main()
