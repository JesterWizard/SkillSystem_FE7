"""Celerity: GetUnitMov returns class movement +2 when the unit has the skill.

Celerity is an MSG modifier (`prSkillCelerity` in pMovModifiers), not a
fill-map routine. Walking GetUnitMov in FE7_Hack.gba and executing that chain
is the check that would catch a missing POIN or a dead rAddConst(2).

SkillTester is stubbed at the address the Mov chain actually calls, so both
the skill-present and skill-absent branches run. Assignment tables are editor
data and out of scope.
"""
import re
import struct
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DEFS = ROOT / "EngineHacks" / "SkillSystem" / "skill_definitions.event"
MOVEMENT = ROOT / "EngineHacks" / "Necessary" / "StatGetters" / "Movement.event"
MSS_PAGE1 = (
    ROOT / "EngineHacks" / "Necessary" / "ModularStatScreen" / "pages" / "mss_page1_skills.s"
)
INSTALL_CORE = ROOT / "EngineHacks" / "Necessary" / "MSG" / "InstallCore.event"
HACK = ROOT / "FE7_Hack.gba"

CELERITY_ID = 255
CELERITY_BONUS = 2
MOV_GETTER = 0x18B44
CLASS_MOV = 6
CLASS_MOV_OFF = 0x12

ROM_BASE = 0x08000000
UNIT = 0x02010000
CHARACTER = 0x02011000
CLASS = 0x02012000
STOP = 0x08FFFFF0
SP = 0x03007F00

# rWithConstant(CelerityID): ldr r2, [pc]; b +4; .word SKILL_OFF (255)
CELERITY_CONST = bytes.fromhex("004a01e0") + struct.pack("<I", CELERITY_ID)

MEM_MAP = [
    (0x02000000, 0x40000),
    (0x03000000, 0x10000),
    (0x04000000, 0x1000),
    (0x05000000, 0x1000),
    (0x06000000, 0x20000),
    (0x07000000, 0x1000),
]


def _rom_off(addr: int) -> int:
    return (addr & ~1) - ROM_BASE


def _find_skilltester(rom: bytes) -> int:
    """GetUnitMov -> pMovModifiers -> prSkillCelerity -> SkillTester."""
    if rom[MOV_GETTER : MOV_GETTER + 4] != bytes.fromhex("004b1847"):
        raise AssertionError("GetUnitMov is not hooked")
    getter = _rom_off(struct.unpack_from("<I", rom, MOV_GETTER + 4)[0])
    cursor = _rom_off(struct.unpack_from("<I", rom, getter + 24)[0])
    while True:
        ptr = struct.unpack_from("<I", rom, cursor)[0]
        if ptr == 0:
            break
        off = _rom_off(ptr)
        body = rom[off : off + 16]
        if CELERITY_CONST in body:
            # rIf's POIN is the last word of the 48-byte rIf blob, which
            # starts immediately after the 8-byte rWithConstant.
            check = _rom_off(struct.unpack_from("<I", rom, off + 8 + 44)[0])
            return _rom_off(struct.unpack_from("<I", rom, check + 12)[0])
        cursor += 4
    raise AssertionError("prSkillCelerity is not in the Movement modifier chain")


class CeleritySourceTests(unittest.TestCase):
    def test_id_is_enabled(self):
        text = DEFS.read_text(encoding="utf-8")
        m = re.search(r"^#define\s+CelerityID\s+(\S+)", text, re.M)
        self.assertIsNotNone(m)
        rhs = m.group(1)
        self.assertEqual(255 if rhs == "SKILL_OFF" else int(rhs), CELERITY_ID)

    def test_wired_into_mov_chain_as_plus_two(self):
        src = MOVEMENT.read_text(encoding="utf-8")
        chain, _, rest = src.partition("WORD 0")
        self.assertIn("prSkillCelerity", chain)
        self.assertRegex(
            rest,
            r"prSkillCelerity:\s*rIfUnitHasSkill\(CelerityID\)\s*rAddConst\(2\)",
        )

    def test_stat_page_draws_move_through_the_getter(self):
        src = MSS_PAGE1.read_text(encoding="utf-8")
        self.assertIn("draw_move_bar_with_getter_at", src)
        self.assertNotRegex(src, r"^draw_move_bar_at\b", re.M)

    def test_fe7_fill_injectors_are_installed(self):
        src = INSTALL_CORE.read_text(encoding="utf-8")
        self.assertIn("InjectMovGetters_FE7.event", src)


class CelerityExecutionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        try:
            from unicorn import Uc, UC_ARCH_ARM, UC_MODE_THUMB  # noqa: F401
        except ImportError:
            raise unittest.SkipTest("unicorn not installed")
        if not HACK.exists():
            raise unittest.SkipTest("FE7_Hack.gba missing")
        cls.Uc, cls.arch, cls.mode = Uc, UC_ARCH_ARM, UC_MODE_THUMB
        cls.rom = HACK.read_bytes()
        cls.skilltester = ROM_BASE + _find_skilltester(cls.rom)

    def _run(self, skill_present: bool) -> int:
        from unicorn import UcError, UC_HOOK_CODE
        from unicorn.arm_const import (
            UC_ARM_REG_R0,
            UC_ARM_REG_R1,
            UC_ARM_REG_LR,
            UC_ARM_REG_PC,
            UC_ARM_REG_SP,
        )

        uc = self.Uc(self.arch, self.mode)
        for base, size in MEM_MAP:
            uc.mem_map(base, size)
        uc.mem_map(0x08000000, (len(self.rom) + 0xFFF) & ~0xFFF)
        uc.mem_write(0x08000000, self.rom)

        uc.mem_write(UNIT, struct.pack("<II", CHARACTER, CLASS) + b"\x00" * 0x44)
        uc.mem_write(CHARACTER, b"\x00" * 0x34)
        uc.mem_write(CLASS, b"\x00" * 0x54)
        uc.mem_write(CLASS + CLASS_MOV_OFF, bytes([CLASS_MOV]))

        def on_insn(uc_, addr, size, _ud):
            if addr == self.skilltester:
                want = uc_.reg_read(UC_ARM_REG_R1) == CELERITY_ID
                uc_.reg_write(UC_ARM_REG_R0, int(skill_present and want))
                uc_.reg_write(UC_ARM_REG_PC, uc_.reg_read(UC_ARM_REG_LR))
                return
            if struct.unpack("<H", uc_.mem_read(addr, 2))[0] == 0xF800:
                target = uc_.reg_read(UC_ARM_REG_LR)
                uc_.reg_write(UC_ARM_REG_LR, (addr + 2) | 1)
                uc_.reg_write(UC_ARM_REG_PC, target | 1)

        uc.hook_add(UC_HOOK_CODE, on_insn)
        uc.reg_write(UC_ARM_REG_SP, SP)
        uc.reg_write(UC_ARM_REG_R0, UNIT)
        uc.reg_write(UC_ARM_REG_LR, STOP | 1)
        try:
            uc.emu_start(
                ROM_BASE + MOV_GETTER | 1,
                STOP,
                timeout=10_000_000,
                count=1_000_000,
            )
        except UcError as exc:
            self.fail(f"chain faulted at pc={uc.reg_read(UC_ARM_REG_PC):08X}: {exc}")
        self.assertEqual(uc.reg_read(UC_ARM_REG_PC), STOP)
        return uc.reg_read(UC_ARM_REG_R0)

    def test_no_boost_without_the_skill(self):
        self.assertEqual(self._run(skill_present=False), CLASS_MOV)

    def test_boosts_movement_by_two(self):
        self.assertEqual(self._run(skill_present=True), CLASS_MOV + CELERITY_BONUS)

# Every place FE7 inlines "class Mov + unit Mov bonus" instead of calling
# GetUnitMov. `shape` says what the fill routine being called expects:
#   "xy"        MakeMoveMap body -> fill(x, y, mov, terrain)
#   "unit"      MakeMoveMapWithMov(unit, mov)
#   "unit_used" MakeMoveMapWithMov(unit, mov - movement already spent)
FILL_SITES = (
    # (name, patch start, the vanilla call the patch feeds, shape)
    ("MakeMoveMap", 0x19BB4, 0x19BCE, "xy"),
    ("MakeMoveMap_AI", 0x3C0A0, 0x3C0BA, "xy"),
    ("PlayerPhaseSelectRange", 0x1B090, 0x1B09E, "unit"),
    # The blue range for the unit you are actually moving. gActiveUnit is read
    # through 0x03004690 and the Mov already spent from 0x0203A85C+0x10.
    ("ActiveUnitRange", 0x1C4D0, 0x1C4EC, "unit_used"),
    ("ActiveUnitRangeRefresh", 0x31444, 0x3145C, "unit_used"),
)

UNIT_X = 5
UNIT_Y = 7
UNIT_MOV_BONUS = 0

# [0x03004690] is the active unit; [0x0203A85C + 0x10] is Mov already spent.
ACTIVE_UNIT_PTR = 0x03004690
MOV_SPENT_STRUCT = 0x0203A85C
MOV_SPENT_OFF = 0x10
MOV_SPENT = 3


class CelerityMapFillTests(unittest.TestCase):
    """The map-fill call sites must receive Celerity's Mov without losing args.

    Replacing the inlined class-Mov arithmetic with a BL to GetUnitMov costs
    r0-r3. If the injector overwrites the instructions that set up the fill
    call's other arguments, the stat screen still shows +2 (it reads the
    getter directly) while the movement map is built from garbage.
    """

    @classmethod
    def setUpClass(cls):
        try:
            from unicorn import Uc, UC_ARCH_ARM, UC_MODE_THUMB  # noqa: F401
        except ImportError:
            raise unittest.SkipTest("unicorn not installed")
        if not HACK.exists():
            raise unittest.SkipTest("FE7_Hack.gba missing")
        cls.Uc, cls.arch, cls.mode = Uc, UC_ARCH_ARM, UC_MODE_THUMB
        cls.rom = HACK.read_bytes()
        cls.skilltester = ROM_BASE + _find_skilltester(cls.rom)

    def _run_site(self, start: int, fill: int, skill_present: bool) -> dict:
        from unicorn import UcError, UC_HOOK_CODE
        from unicorn.arm_const import (
            UC_ARM_REG_R0,
            UC_ARM_REG_R1,
            UC_ARM_REG_R2,
            UC_ARM_REG_R4,
            UC_ARM_REG_LR,
            UC_ARM_REG_PC,
            UC_ARM_REG_SP,
        )

        uc = self.Uc(self.arch, self.mode)
        for base, size in MEM_MAP:
            uc.mem_map(base, size)
        uc.mem_map(0x08000000, (len(self.rom) + 0xFFF) & ~0xFFF)
        uc.mem_write(0x08000000, self.rom)

        uc.mem_write(UNIT, struct.pack("<II", CHARACTER, CLASS) + bytes(0x44))
        uc.mem_write(UNIT + 0x10, bytes([UNIT_X, UNIT_Y]))
        uc.mem_write(UNIT + 0x1D, bytes([UNIT_MOV_BONUS]))
        uc.mem_write(CHARACTER, bytes(0x34))
        uc.mem_write(CLASS, bytes(0x54))
        uc.mem_write(CLASS + CLASS_MOV_OFF, bytes([CLASS_MOV]))

        uc.mem_write(ACTIVE_UNIT_PTR, struct.pack("<I", UNIT))
        uc.mem_write(MOV_SPENT_STRUCT + MOV_SPENT_OFF, bytes([MOV_SPENT]))

        captured = {}

        def on_insn(uc_, addr, size, _ud):
            if addr == ROM_BASE + fill:
                captured["r0"] = uc_.reg_read(UC_ARM_REG_R0)
                captured["r1"] = uc_.reg_read(UC_ARM_REG_R1)
                captured["r2"] = uc_.reg_read(UC_ARM_REG_R2)
                captured["r4"] = uc_.reg_read(UC_ARM_REG_R4)
                uc_.emu_stop()
                return
            if addr == self.skilltester:
                want = uc_.reg_read(UC_ARM_REG_R1) == CELERITY_ID
                uc_.reg_write(UC_ARM_REG_R0, int(skill_present and want))
                uc_.reg_write(UC_ARM_REG_PC, uc_.reg_read(UC_ARM_REG_LR))
                return
            if struct.unpack("<H", uc_.mem_read(addr, 2))[0] == 0xF800:
                target = uc_.reg_read(UC_ARM_REG_LR)
                uc_.reg_write(UC_ARM_REG_LR, (addr + 2) | 1)
                uc_.reg_write(UC_ARM_REG_PC, target | 1)

        uc.hook_add(UC_HOOK_CODE, on_insn)
        uc.reg_write(UC_ARM_REG_SP, SP)
        uc.reg_write(UC_ARM_REG_R4, UNIT)
        uc.reg_write(UC_ARM_REG_LR, STOP | 1)
        try:
            uc.emu_start(
                ROM_BASE + start | 1, STOP, timeout=10_000_000, count=1_000_000
            )
        except UcError as exc:
            self.fail(f"site {start:X} faulted at pc={uc.reg_read(UC_ARM_REG_PC):08X}: {exc}")
        if not captured:
            self.fail(f"site {start:X} never reached the fill call at {fill:X}")
        return captured

    @staticmethod
    def _mov_arg(shape: str, regs: dict) -> int:
        return regs["r2"] if shape == "xy" else regs["r1"]

    @staticmethod
    def _expected_mov(shape: str, boosted: bool) -> int:
        mov = CLASS_MOV + UNIT_MOV_BONUS + (CELERITY_BONUS if boosted else 0)
        return mov - MOV_SPENT if shape == "unit_used" else mov

    def test_unit_pointer_survives_the_getter_call(self):
        for name, start, fill, shape in FILL_SITES:
            if shape != "xy":
                continue
            with self.subTest(site=name):
                regs = self._run_site(start, fill, skill_present=True)
                self.assertEqual(regs["r4"], UNIT)

    def test_movement_map_sites_get_the_boosted_mov(self):
        for name, start, fill, shape in FILL_SITES:
            with self.subTest(site=name):
                regs = self._run_site(start, fill, skill_present=True)
                self.assertEqual(
                    self._mov_arg(shape, regs), self._expected_mov(shape, True)
                )

    def test_movement_map_sites_get_base_mov_without_the_skill(self):
        for name, start, fill, shape in FILL_SITES:
            with self.subTest(site=name):
                regs = self._run_site(start, fill, skill_present=False)
                self.assertEqual(
                    self._mov_arg(shape, regs), self._expected_mov(shape, False)
                )

    def test_other_fill_arguments_are_not_clobbered(self):
        for name, start, fill, shape in FILL_SITES:
            with self.subTest(site=name):
                regs = self._run_site(start, fill, skill_present=True)
                if shape == "xy":
                    # fill(x, y, mov, terrain)
                    self.assertEqual(regs["r0"], UNIT_X)
                    self.assertEqual(regs["r1"], UNIT_Y)
                else:
                    # MakeMoveMapWithMov(unit, mov)
                    self.assertEqual(regs["r0"], UNIT)


if __name__ == "__main__":
    unittest.main()
