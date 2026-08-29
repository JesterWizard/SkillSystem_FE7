"""Keep Up is a live +2 Mov check: manhattan <= 3 of an allied Canto unit.

It must not use the start-of-turn Armor March bit (that delayed apply/remove).
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

CHAR_TABLE, CHAR_ENTRY = 0x08BDCE18, 0x34
CLASS_TABLE, CLASS_ENTRY = 0x08BE015C, 0x54
UNIT1 = 0x0202BD50
UNIT2 = 0x0202BD98
UNIT3 = 0x0202BDE0
MERC = 0x09
PALADIN = 0x07
KEEPUP_ID = 24
CANTO_PROBE_ID = 90
ARMOR_MARCH_BIT = 60
ARMOR_MARCH_BONUS = 2
SUPPORTS = 0x32
STOP = 0x08000100
BL_SUFFIX = b"\x00\xf8"
MOV_LR_R3 = b"\x9e\x46"
PU_DEBUFF = 0x0203F100
DEBUFF_ENTRY = 8
G_MAP_SIZE = 0x0202E3D8
PP_MOVE_MAP = 0x0202E3E4
MAP_ROWS = 0x02030000
MAP_CELLS = 0x02030100
UNREACHABLE = 0xFF


def _blh_suffixes(rom, lo, hi):
    out, i = [], lo
    while True:
        i = rom.find(BL_SUFFIX, i, hi)
        if i == -1:
            return out
        if i >= 2 and rom[i - 2:i] == MOV_LR_R3:
            out.append(ROM_BASE + i)
        i += 2


class KeepUpExecutionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        try:
            from unicorn import Uc, UC_ARCH_ARM, UC_MODE_THUMB  # noqa: F401
        except ImportError:
            raise unittest.SkipTest("unicorn not installed")
        cls.rom = built_rom.load()
        cls.sym = built_rom.symbols()
        for name in (
            "KeepUp",
            "SkillTester",
            "prArmorMarchCheck",
            "GetUnitDebuffEntry",
            "CheckBit",
            "CantoID_Link",
            "CantoPlusID_Link",
            "KeepUpID_Link",
            "PruneKeepUpMoveMap",
        ):
            if name not in cls.sym:
                raise unittest.SkipTest(f"{name} missing from FE7_Hack.sym")

    def test_zero_canto_id_does_not_match_every_ally(self):
        r0 = self._run_keepup(canto_id=0, canto_plus_id=0, ally_skills=[], seen=[], xy=(6, 5))
        self.assertEqual(r0, 0, "CantoID 0 must not count as every nearby ally having Canto")

    def test_false_when_ally_lacks_canto(self):
        seen = []
        r0 = self._run_keepup(
            canto_id=CANTO_PROBE_ID, canto_plus_id=255, ally_skills=[], seen=seen, xy=(6, 5)
        )
        self.assertEqual(r0, 0)
        self.assertNotIn(0, seen, "SkillTester(0) is always true")

    def test_true_at_manhattan_3(self):
        seen = []
        r0 = self._run_keepup(
            canto_id=CANTO_PROBE_ID,
            canto_plus_id=255,
            ally_skills=[CANTO_PROBE_ID],
            seen=seen,
            xy=(8, 5),
        )
        self.assertEqual(r0, 1, "manhattan 3 must apply")
        self.assertIn(CANTO_PROBE_ID, seen)

    def test_false_at_manhattan_4(self):
        r0 = self._run_keepup(
            canto_id=CANTO_PROBE_ID,
            canto_plus_id=255,
            ally_skills=[CANTO_PROBE_ID],
            seen=[],
            xy=(9, 5),
        )
        self.assertEqual(r0, 0, "manhattan 4 must not apply")

    def test_false_at_manhattan_5(self):
        r0 = self._run_keepup(
            canto_id=CANTO_PROBE_ID,
            canto_plus_id=255,
            ally_skills=[CANTO_PROBE_ID],
            seen=[],
            xy=(8, 7),
        )
        self.assertEqual(r0, 0, "manhattan 5 must not apply")

    def test_false_at_reported_lyn_wallace_coords(self):
        r0 = self._run_keepup(
            canto_id=CANTO_PROBE_ID,
            canto_plus_id=255,
            ally_skills=[CANTO_PROBE_ID],
            seen=[],
            xy=(4, 7),
            holder_xy=(5, 1),
        )
        self.assertEqual(r0, 0, "Lyn (5,1) vs Wallace (4,7) is manhattan 7")

    def test_false_when_nearby_paladin_lacks_canto_skill(self):
        r0 = self._run_keepup(
            canto_id=CANTO_PROBE_ID,
            canto_plus_id=255,
            ally_skills=[CANTO_PROBE_ID],
            seen=[],
            xy=(4, 7),
            holder_xy=(5, 1),
            extra=(UNIT3, 3, PALADIN, [], 6, 1),
        )
        self.assertEqual(r0, 0, "class Canto on a nearby Paladin must not apply")

    def test_false_when_ally_has_only_class_canto(self):
        r0 = self._run_keepup(
            canto_id=CANTO_PROBE_ID,
            canto_plus_id=255,
            ally_skills=[],
            seen=[],
            xy=(6, 5),
            ally_class=PALADIN,
        )
        self.assertEqual(r0, 0, "CA_CANTO must not count; Canto/Canto+ skills only")

    def test_getter_adds_two_only_while_in_range(self):
        self.assertEqual(self._run_getter(xy=(8, 5), bit=False), 6 + ARMOR_MARCH_BONUS)
        self.assertEqual(self._run_getter(xy=(9, 5), bit=False), 6)
        self.assertEqual(self._run_getter(xy=(8, 7), bit=False), 6)

    def test_getter_does_not_stack_bit_and_keepup(self):
        self.assertEqual(self._run_getter(xy=(8, 5), bit=True), 6 + ARMOR_MARCH_BONUS)

    def test_getter_false_at_reported_coords(self):
        self.assertEqual(self._run_getter(xy=(4, 7), bit=False, holder_xy=(5, 1)), 6)

    def test_prune_drops_boost_tile_outside_aura(self):
        rem = self._run_prune(
            holder_xy=(2, 2),
            ally_xy=(3, 2),
            fill_mov=6,
            tiles={
                (2, 2): 6,
                (7, 2): 2,
                (8, 2): 1,
            },
        )
        self.assertEqual(rem[(2, 2)], 6, "origin stays reachable")
        self.assertEqual(rem[(7, 2)], 2, "base-mov tile stays even outside the aura")
        self.assertEqual(rem[(8, 2)], UNREACHABLE, "tile that needed +2 outside aura must drop")

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

    def _patch_word(self, uc, name, value):
        addr = self.sym[name] & ~1
        uc.mem_write(addr, struct.pack("<I", value & 0xFFFFFFFF))

    def _hooks(self, uc, seen, extra_tramps=()):
        from unicorn import UC_HOOK_CODE
        from unicorn.arm_const import UC_ARM_REG_R0, UC_ARM_REG_R1, UC_ARM_REG_LR, UC_ARM_REG_PC

        keepup = self.sym["KeepUp"] & ~1
        tramps = set(
            _blh_suffixes(
                self.rom,
                built_rom.offset(self.rom, keepup),
                built_rom.offset(self.rom, keepup) + 0x400,
            )
        )
        tramps |= set(extra_tramps)
        for name, size in (
            ("SkillTester", 0x300),
            ("GetUnitDebuffEntry", 0x80),
            ("CheckBit", 0x40),
            ("InitSkillBuffers", 0x40),
            ("IsUnitOnField", 0x40),
        ):
            if name not in self.sym:
                continue
            a = self.sym[name] & ~1
            tramps |= set(
                _blh_suffixes(
                    self.rom,
                    built_rom.offset(self.rom, a),
                    built_rom.offset(self.rom, a) + size,
                )
            )
        tramps |= set(_blh_suffixes(self.rom, 0x18D0C, 0x18D20))
        skilltester = self.sym["SkillTester"] & ~1
        get_unit = 0x08018D0C

        def _supports(u, unit_addr):
            return list(u.mem_read(unit_addr + SUPPORTS, 6))

        def on_code(u, addr, _size, _d):
            if (addr & ~1) == get_unit:
                idx = u.reg_read(UC_ARM_REG_R0)
                if idx == 1:
                    u.reg_write(UC_ARM_REG_R0, UNIT1)
                elif idx == 2:
                    u.reg_write(UC_ARM_REG_R0, UNIT2)
                elif idx == 3:
                    u.reg_write(UC_ARM_REG_R0, UNIT3)
                else:
                    u.reg_write(UC_ARM_REG_R0, 0)
                u.reg_write(UC_ARM_REG_PC, u.reg_read(UC_ARM_REG_LR) | 1)
                return
            if (addr & ~1) == skilltester:
                sid = u.reg_read(UC_ARM_REG_R1) & 0xFF
                seen.append(sid)
                unit = u.reg_read(UC_ARM_REG_R0)
                if sid == 0:
                    result = 1
                elif sid == 255:
                    result = 0
                else:
                    result = 1 if sid in _supports(u, unit) else 0
                u.reg_write(UC_ARM_REG_R0, result)
                u.reg_write(UC_ARM_REG_PC, u.reg_read(UC_ARM_REG_LR) | 1)
                return
            if addr in tramps:
                lr = u.reg_read(UC_ARM_REG_LR)
                u.reg_write(UC_ARM_REG_LR, (addr + 2) | 1)
                u.reg_write(UC_ARM_REG_PC, lr | 1)

        uc.hook_add(UC_HOOK_CODE, on_code)

    def _run_keepup(
        self,
        canto_id,
        canto_plus_id,
        ally_skills,
        seen,
        xy,
        ally_class=MERC,
        holder_xy=(5, 5),
        extra=None,
    ):
        from unicorn import UcError
        from unicorn.arm_const import UC_ARM_REG_R0, UC_ARM_REG_LR, UC_ARM_REG_PC, UC_ARM_REG_SP

        uc = self._map()
        self.uc = uc
        x, y = xy
        hx, hy = holder_xy
        self._write_unit(uc, UNIT1, 1, MERC, [KEEPUP_ID], hx, hy)
        self._write_unit(uc, UNIT2, 2, ally_class, ally_skills, x, y)
        if extra:
            addr, index, class_id, skills, ex, ey = extra
            self._write_unit(uc, addr, index, class_id, skills, ex, ey)
        self._patch_word(uc, "CantoID_Link", canto_id)
        self._patch_word(uc, "CantoPlusID_Link", canto_plus_id)
        self._hooks(uc, seen)
        keepup = self.sym["KeepUp"] & ~1
        uc.reg_write(UC_ARM_REG_SP, IWRAM + IWRAM_SIZE - PAGE)
        uc.reg_write(UC_ARM_REG_R0, UNIT1)
        uc.reg_write(UC_ARM_REG_LR, STOP | 1)
        try:
            uc.emu_start(keepup | 1, STOP, timeout=20_000_000, count=500_000)
        except UcError as exc:
            self.fail(f"KeepUp faulted: {exc}")
        self.assertEqual(uc.reg_read(UC_ARM_REG_PC), STOP)
        return uc.reg_read(UC_ARM_REG_R0)

    def _run_getter(self, xy, bit, holder_xy=(5, 5)):
        from unicorn import UcError
        from unicorn.arm_const import UC_ARM_REG_R0, UC_ARM_REG_R1, UC_ARM_REG_LR, UC_ARM_REG_PC, UC_ARM_REG_SP

        uc = self._map()
        self.uc = uc
        x, y = xy
        hx, hy = holder_xy
        self._write_unit(uc, UNIT1, 1, MERC, [KEEPUP_ID], hx, hy)
        self._write_unit(uc, UNIT2, 2, MERC, [CANTO_PROBE_ID], x, y)
        self._patch_word(uc, "CantoID_Link", CANTO_PROBE_ID)
        self._patch_word(uc, "CantoPlusID_Link", 255)
        entry = bytearray(DEBUFF_ENTRY)
        if bit:
            entry[ARMOR_MARCH_BIT // 8] |= 1 << (ARMOR_MARCH_BIT % 8)
        uc.mem_write(PU_DEBUFF + 1 * DEBUFF_ENTRY, bytes(entry))
        check = self.sym["prArmorMarchCheck"] & ~1
        extra = _blh_suffixes(
            self.rom,
            built_rom.offset(self.rom, check),
            built_rom.offset(self.rom, check) + 0x80,
        )
        self._hooks(uc, [], extra_tramps=extra)
        uc.reg_write(UC_ARM_REG_SP, IWRAM + IWRAM_SIZE - PAGE)
        uc.reg_write(UC_ARM_REG_R0, 6)
        uc.reg_write(UC_ARM_REG_R1, UNIT1)
        uc.reg_write(UC_ARM_REG_LR, STOP | 1)
        try:
            uc.emu_start(check | 1, STOP, timeout=20_000_000, count=500_000)
        except UcError as exc:
            self.fail(f"prArmorMarchCheck faulted: {exc}")
        self.assertEqual(uc.reg_read(UC_ARM_REG_PC), STOP)
        return uc.reg_read(UC_ARM_REG_R0)

    def _run_prune(self, holder_xy, ally_xy, fill_mov, tiles):
        from unicorn import UcError
        from unicorn.arm_const import UC_ARM_REG_R0, UC_ARM_REG_R1, UC_ARM_REG_LR, UC_ARM_REG_PC, UC_ARM_REG_SP

        uc = self._map()
        self.uc = uc
        hx, hy = holder_xy
        ax, ay = ally_xy
        self._write_unit(uc, UNIT1, 1, MERC, [KEEPUP_ID], hx, hy)
        self._write_unit(uc, UNIT2, 2, MERC, [CANTO_PROBE_ID], ax, ay)
        self._patch_word(uc, "CantoID_Link", CANTO_PROBE_ID)
        self._patch_word(uc, "CantoPlusID_Link", 255)
        width, height = 10, 6
        uc.mem_write(G_MAP_SIZE, struct.pack("<hh", width, height))
        row_ptrs = b"".join(struct.pack("<I", MAP_CELLS + y * width) for y in range(height))
        uc.mem_write(MAP_ROWS, row_ptrs)
        uc.mem_write(PP_MOVE_MAP, struct.pack("<I", MAP_ROWS))
        grid = bytearray([UNREACHABLE] * (width * height))
        for (x, y), rem in tiles.items():
            grid[y * width + x] = rem
        uc.mem_write(MAP_CELLS, bytes(grid))
        prune = self.sym["PruneKeepUpMoveMap"] & ~1
        extra = _blh_suffixes(
            self.rom,
            built_rom.offset(self.rom, prune),
            built_rom.offset(self.rom, prune) + 0x200,
        )
        keepup = self.sym["KeepUp"] & ~1
        extra += _blh_suffixes(
            self.rom,
            built_rom.offset(self.rom, keepup),
            built_rom.offset(self.rom, keepup) + 0x400,
        )
        self._hooks(uc, [], extra_tramps=extra)
        uc.reg_write(UC_ARM_REG_SP, IWRAM + IWRAM_SIZE - PAGE)
        uc.reg_write(UC_ARM_REG_R0, UNIT1)
        uc.reg_write(UC_ARM_REG_R1, fill_mov)
        uc.reg_write(UC_ARM_REG_LR, STOP | 1)
        try:
            uc.emu_start(prune | 1, STOP, timeout=20_000_000, count=2_000_000)
        except UcError as exc:
            self.fail(f"PruneKeepUpMoveMap faulted: {exc}")
        self.assertEqual(uc.reg_read(UC_ARM_REG_PC), STOP)
        out = {}
        for x, y in tiles:
            out[(x, y)] = uc.mem_read(MAP_CELLS + y * width + x, 1)[0]
        return out


if __name__ == "__main__":
    unittest.main()
