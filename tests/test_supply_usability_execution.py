"""Supply menu: skill or adjacent skill-holder only; no Merlinus class convoy.

NewSupplyUsability already implements those two paths. ALSO_USE_VANILLA_SUPPLY_CHECK
must be False while SupplyID is enabled, or vanilla transporter/lord usability
still opens Supply for Merlinus's class.
"""
from __future__ import annotations

import re
import struct
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from Tools import thumb_harness as th

try:
    from unicorn import Uc, UC_ARCH_ARM, UC_HOOK_CODE, UC_MODE_THUMB, UcError
    from unicorn.arm_const import (
        UC_ARM_REG_LR,
        UC_ARM_REG_PC,
        UC_ARM_REG_R0,
        UC_ARM_REG_SP,
    )
except ImportError:
    Uc = None

DEFS = ROOT / "EngineHacks" / "SkillSystem" / "skill_definitions.event"
CONFIG = ROOT / "EngineHacks" / "Config.event"
INSTALLER = (
    ROOT
    / "EngineHacks"
    / "SkillSystem"
    / "Skills"
    / "UnitMenuSkills"
    / "UnitMenuSkills.event"
)
SUPPLY_S = (
    ROOT
    / "EngineHacks"
    / "SkillSystem"
    / "Skills"
    / "UnitMenuSkills"
    / "Supply"
    / "NewSupplyUsability.s"
)
HACK = ROOT / "FE7_Hack.gba"

G_ACTIVE = 0x03004690
UNIT = 0x02000000
CLASS = 0x02000100
PHANTOM_CMP = 0x08023F78
USABLE = 1
HIDDEN = 3
SUPPLY_ID = 239


class SupplyVanillaCheckSourceTests(unittest.TestCase):
    def test_vanilla_transporter_check_off_while_skill_enabled(self):
        defs = DEFS.read_text(encoding="utf-8")
        match = re.search(r"^#define SupplyID (\S+)", defs, re.M)
        self.assertIsNotNone(match)
        self.assertNotEqual(match.group(1), "SKILL_OFF")
        self.assertEqual(int(match.group(1)), SUPPLY_ID)
        cfg = CONFIG.read_text(encoding="utf-8")
        self.assertIn("#define ALSO_USE_VANILLA_SUPPLY_CHECK False", cfg)
        self.assertNotIn("#define ALSO_USE_VANILLA_SUPPLY_CHECK True", cfg)
        installer = INSTALLER.read_text(encoding="utf-8")
        self.assertIn("WORD ALSO_USE_VANILLA_SUPPLY_CHECK", installer)
        src = SUPPLY_S.read_text(encoding="utf-8")
        self.assertNotIn("0x080D7C04", src)
        self.assertIn("AdjacentOffsets", src)


class SupplyUsabilityExecutionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        try:
            th.assemble(SUPPLY_S)
        except Exception as exc:
            raise unittest.SkipTest(f"thumb harness unavailable: {exc}") from exc

    def _run(self, skill_present: bool, state: int = 0, summon: bool = False) -> int:
        code = th.assemble(SUPPLY_S)
        offs = th.symbol_offsets(SUPPLY_S)
        h = th.Harness(code, skill_present=skill_present)
        unit = bytearray(0x48)
        struct.pack_into("<I", unit, 0x4, CLASS)
        struct.pack_into("<I", unit, 0xC, state)
        if summon:
            unit[0xF] = 0x80
        class_data = bytearray(8)
        class_data[4] = 0x01
        h.seed(G_ACTIVE, struct.pack("<I", UNIT))
        h.seed(UNIT, bytes(unit))
        h.seed(CLASS, bytes(class_data))
        h.seed(PHANTOM_CMP, b"\x51")
        regs = h.run(offs["GoBack"], {})
        return regs["r0"]

    def test_skill_holder_gets_supply(self):
        self.assertEqual(self._run(True), USABLE)

    def test_rescued_unit_denied(self):
        self.assertEqual(self._run(True, state=0x40), HIDDEN)

    def test_no_skill_without_vanilla_denied(self):
        self.assertEqual(self._run(False, summon=True), HIDDEN)

    def test_adjacent_skill_holder_opens_supply(self):
        self.assertEqual(self._run_adjacent(neighbor_has_skill=True), USABLE)

    def test_adjacent_without_skill_denied(self):
        self.assertEqual(self._run_adjacent(neighbor_has_skill=False), HIDDEN)

    def _run_adjacent(self, neighbor_has_skill: bool) -> int:
        if Uc is None:
            raise unittest.SkipTest("unicorn not installed")
        code = bytearray(th.assemble(SUPPLY_S))
        offs = th.symbol_offsets(SUPPLY_S)
        getunit = 0x08018D0C
        neighbor = UNIT + 0x80
        tester = 0x0800F000
        map_rows = 0x02001000
        row_base = 0x02001100
        ao = offs["AdjacentOffsets"]
        needle = struct.pack("<I", ao)
        idx = bytes(code).rfind(needle)
        self.assertNotEqual(idx, -1, "AdjacentOffsets literal missing")
        code[idx : idx + 4] = struct.pack("<I", th.CODE_BASE + ao)

        uc = Uc(UC_ARCH_ARM, UC_MODE_THUMB)
        page = th.PAGE
        uc.mem_map(th.CODE_BASE, page)
        uc.mem_write(th.CODE_BASE, bytes(code))
        uc.mem_map(th.STACK_BASE, th.STACK_SIZE)
        uc.reg_write(UC_ARM_REG_SP, th.STACK_BASE + th.STACK_SIZE - 0x100)

        def map_at(addr: int, size: int = 0x100):
            base = addr & ~(page - 1)
            top = (addr + size + page - 1) & ~(page - 1)
            try:
                uc.mem_map(base, max(top - base, page))
            except UcError:
                pass

        def seed(addr: int, data: bytes):
            map_at(addr, len(data))
            uc.mem_write(addr, data)

        def on_code(uc_, addr, _size, _user):
            if bytes(uc_.mem_read(addr, 2)) != b"\x00\xf8":
                return
            dest = uc_.reg_read(UC_ARM_REG_LR) & ~1
            r0 = uc_.reg_read(UC_ARM_REG_R0)
            if dest == getunit:
                uc_.reg_write(UC_ARM_REG_R0, neighbor if r0 == 2 else 0)
            elif dest == tester:
                has = neighbor_has_skill and r0 == neighbor
                uc_.reg_write(UC_ARM_REG_R0, 1 if has else 0)
            else:
                uc_.reg_write(UC_ARM_REG_R0, 0)
            hit[0] = addr + 2
            uc_.emu_stop()

        hit = {}
        uc.hook_add(UC_HOOK_CODE, on_code)

        active = bytearray(0x48)
        struct.pack_into("<I", active, 0x4, CLASS)
        active[0x0B] = 1
        active[0x10] = 5
        active[0x11] = 5
        other = bytearray(0x48)
        struct.pack_into("<I", other, 0x4, CLASS)
        other[0x0B] = 2
        other[0x10] = 6
        other[0x11] = 5
        class_data = bytearray(8)
        class_data[4] = 0x01
        seed(G_ACTIVE, struct.pack("<I", UNIT))
        seed(UNIT, bytes(active))
        seed(neighbor, bytes(other))
        seed(CLASS, bytes(class_data))
        seed(PHANTOM_CMP, b"\x51")

        rows = bytearray(16 * 4)
        for y in range(16):
            struct.pack_into("<I", rows, y * 4, row_base + y * 32)
        seed(map_rows, bytes(rows))
        seed(0x0202E3DC, struct.pack("<I", map_rows))
        grid = bytearray(16 * 32)
        grid[5 * 32 + 5] = 1
        grid[5 * 32 + 6] = 2
        seed(row_base, bytes(grid))

        pool = th.CODE_BASE + offs["SkillTester"]
        seed(pool, struct.pack("<I", tester | 1))
        seed(pool + 4, struct.pack("<I", SUPPLY_ID))
        seed(pool + 8, struct.pack("<I", 0))

        stop = th.CODE_BASE + offs["GoBack"]
        pc = th.CODE_BASE
        while True:
            hit.clear()
            uc.emu_start(pc | 1, stop, timeout=200_000)
            if not hit:
                break
            pc = hit[0]
        return uc.reg_read(UC_ARM_REG_R0)


@unittest.skipUnless(HACK.exists(), "FE7_Hack.gba missing")
class SupplyUsabilityRomTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        # FE7_Hack.gba: ROM-phase only. MAKE_HACK copies the clean ROM first.
        cls.hack = HACK.read_bytes()

    def test_installed_vanilla_check_word_is_zero(self):
        hack = self.hack
        ptr = struct.unpack_from("<I", hack, 0xB95AB4)[0]
        if not (0x09000000 <= (ptr & ~1) < 0x0A000000):
            self.skipTest("UnitMenuTable not installed (clean ROM copy)")
        base = (ptr & ~1) - 0x08000000
        found = None
        for n in range(40):
            e = base + n * 0x24
            if e + 0x24 > len(hack):
                break
            nameptr, namemsg = struct.unpack_from("<IH", hack, e)
            if nameptr == 0 and namemsg == 0:
                break
            if namemsg == 0x10DF:
                found = struct.unpack_from("<I", hack, e + 0x0C)[0]
                break
        self.assertIsNotNone(found, "Supply menu command not found")
        self.assertTrue(0x09000000 <= (found & ~1) < 0x0A000000, hex(found))
        off = (found & ~1) - 0x08000000
        blob = hack[off : off + 0x400]
        idx = blob.find(struct.pack("<I", SUPPLY_ID))
        self.assertNotEqual(idx, -1, "SupplyID word not after NewSupplyUsability")
        vanilla = struct.unpack_from("<I", blob, idx + 4)[0]
        self.assertEqual(vanilla, 0, vanilla)


if __name__ == "__main__":
    unittest.main()
