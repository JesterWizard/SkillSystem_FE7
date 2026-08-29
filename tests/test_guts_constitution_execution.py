"""Guts +5 Str and Strong Constitution +5 Def/Res while status != 0.

Executes the built ROM routines (Power / Defense getter-chain symbols) with
SkillTester hooked. Status 0x55 is a dancer Str ring (duration 5, status 5).
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
SUPPORTS = 0x32
STATUS = 0x30
STOP = 0x08000100
BL_SUFFIX = b"\x00\xf8"
MOV_LR_R3 = b"\x9e\x46"
GUTS_ID = 2
STRONGCON_ID = 11
BASE = 10
RING = 0x55  # dancer Str ring: high nibble duration, low nibble status


def _blh_suffixes(rom, lo, hi):
    out, i = [], lo
    while True:
        i = rom.find(BL_SUFFIX, i, hi)
        if i == -1:
            return out
        if i >= 2 and rom[i - 2 : i] == MOV_LR_R3:
            out.append(ROM_BASE + i)
        i += 2


class GutsConstitutionExecutionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        try:
            from unicorn import Uc, UC_ARCH_ARM, UC_MODE_THUMB  # noqa: F401
        except ImportError:
            raise unittest.SkipTest("unicorn not installed")
        cls.rom = built_rom.load()
        cls.sym = built_rom.symbols()
        for name in ("Guts", "StrongCon", "SkillTester", "prResolve"):
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

    def _write_unit(self, uc, skills, status):
        uc.mem_write(UNIT, bytes(0x48))
        uc.mem_write(UNIT + 0x00, struct.pack("<I", CHAR_TABLE + CHAR_ENTRY * 1))
        uc.mem_write(UNIT + 0x04, struct.pack("<I", CLASS_TABLE + CLASS_ENTRY * 1))
        uc.mem_write(UNIT + 0x0B, bytes([1]))
        uc.mem_write(UNIT + STATUS, bytes([status]))
        for i, skill in enumerate(skills):
            uc.mem_write(UNIT + SUPPORTS + i, bytes([skill]))

    def _hooks(self, uc, routine, seen):
        from unicorn import UC_HOOK_CODE
        from unicorn.arm_const import UC_ARM_REG_R0, UC_ARM_REG_R1, UC_ARM_REG_LR, UC_ARM_REG_PC

        start = routine & ~1
        tramps = set(
            _blh_suffixes(
                self.rom,
                built_rom.offset(self.rom, start),
                built_rom.offset(self.rom, start) + 0x80,
            )
        )
        skilltester = self.sym["SkillTester"] & ~1

        def _supports(u):
            return list(u.mem_read(UNIT + SUPPORTS, 6))

        def on_code(u, addr, _size, _d):
            if (addr & ~1) == skilltester:
                sid = u.reg_read(UC_ARM_REG_R1) & 0xFF
                seen.append(sid)
                result = 1 if sid and sid != 255 and sid in _supports(u) else 0
                u.reg_write(UC_ARM_REG_R0, result)
                u.reg_write(UC_ARM_REG_PC, u.reg_read(UC_ARM_REG_LR) | 1)
                return
            if addr in tramps:
                lr = u.reg_read(UC_ARM_REG_LR)
                u.reg_write(UC_ARM_REG_LR, (addr + 2) | 1)
                u.reg_write(UC_ARM_REG_PC, lr | 1)

        uc.hook_add(UC_HOOK_CODE, on_code)

    def _run(self, name, skills, status):
        from unicorn import UcError
        from unicorn.arm_const import UC_ARM_REG_R0, UC_ARM_REG_R1, UC_ARM_REG_LR, UC_ARM_REG_PC, UC_ARM_REG_SP

        uc = self._map()
        self._write_unit(uc, skills, status)
        seen = []
        routine = self.sym[name] & ~1
        self._hooks(uc, routine, seen)
        uc.reg_write(UC_ARM_REG_SP, IWRAM + IWRAM_SIZE - PAGE)
        uc.reg_write(UC_ARM_REG_R0, BASE)
        uc.reg_write(UC_ARM_REG_R1, UNIT)
        uc.reg_write(UC_ARM_REG_LR, STOP | 1)
        try:
            uc.emu_start(routine | 1, STOP, timeout=20_000_000, count=200_000)
        except UcError as exc:
            self.fail(f"{name} faulted: {exc}")
        self.assertEqual(uc.reg_read(UC_ARM_REG_PC), STOP)
        return uc.reg_read(UC_ARM_REG_R0), seen

    def test_guts_plus_five_with_status(self):
        r0, seen = self._run("Guts", [GUTS_ID], RING)
        self.assertEqual(r0, BASE + 5)
        self.assertIn(GUTS_ID, seen)

    def test_guts_plus_five_with_poison(self):
        r0, _ = self._run("Guts", [GUTS_ID], 0x11)
        self.assertEqual(r0, BASE + 5)

    def test_guts_no_bonus_without_status(self):
        r0, seen = self._run("Guts", [GUTS_ID], 0)
        self.assertEqual(r0, BASE)
        self.assertIn(GUTS_ID, seen)

    def test_guts_no_bonus_without_skill(self):
        r0, _ = self._run("Guts", [], RING)
        self.assertEqual(r0, BASE)

    def test_strongcon_plus_five_with_ring(self):
        r0, seen = self._run("StrongCon", [STRONGCON_ID], RING)
        self.assertEqual(r0, BASE + 5)
        self.assertIn(STRONGCON_ID, seen)

    def test_power_chain_contains_guts_and_resolve(self):
        getter_ent = 0x18AD0
        self.assertEqual(self.rom[getter_ent : getter_ent + 4], bytes.fromhex("004b1847"))
        getter = (struct.unpack_from("<I", self.rom, getter_ent + 4)[0] & ~1) - ROM_BASE
        modifier_list = struct.unpack_from("<I", self.rom, getter + 24)[0]
        cursor = (modifier_list & ~1) - ROM_BASE
        listed = []
        while cursor + 4 <= len(self.rom):
            ent = struct.unpack_from("<I", self.rom, cursor)[0]
            if ent == 0:
                break
            listed.append(ent & ~1)
            cursor += 4
        self.assertIn(self.sym["Guts"] & ~1, listed)
        self.assertIn(self.sym["prResolve"] & ~1, listed)

    def test_strongcon_no_bonus_without_status(self):
        r0, _ = self._run("StrongCon", [STRONGCON_ID], 0)
        self.assertEqual(r0, BASE)


if __name__ == "__main__":
    unittest.main()
