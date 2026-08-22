"""DEC-89: Poise, Triangle Adept, and Triangle Adept+ WTA skills."""
import re
import struct
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

DEFS = ROOT / "EngineHacks" / "SkillSystem" / "skill_definitions.event"
MASTER = ROOT / "EngineHacks" / "SkillSystem" / "Skills" / "MasterSkillInstaller.event"
CALC = ROOT / "EngineHacks" / "Necessary" / "CalcLoops" / "CalcLoops.event"
WTA_EVENT = ROOT / "EngineHacks" / "Necessary" / "CalcLoops" / "WTACalcLoop" / "WTACalcLoop.event"
WTA_S = ROOT / "EngineHacks" / "Necessary" / "CalcLoops" / "WTACalcLoop" / "WTACalcLoop.s"
MOVEMENT = ROOT / "EngineHacks" / "Necessary" / "StatGetters" / "Movement.event"
POISE_S = ROOT / "EngineHacks/SkillSystem/Skills/WTASkills/Poise/Poise.s"
ADEPT_S = ROOT / "EngineHacks/SkillSystem/Skills/WTASkills/TriangleAdept/TriangleAdept.s"
HACK = ROOT / "FE7_Hack.gba"

POISE_ID = 144
TRI_ADEPT_ID = 109
TRI_ADEPT_PLUS_ID = 110
WTA_HIT, WTA_DMG = 0x53, 0x54
HOOK = 0x2A1E0
REAVER = 0x0802A121
MOV_GETTER = 0x18B44
CLASS_MOV, CLASS_MOV_OFF = 6, 0x12
ROM_BASE = 0x08000000
ATTACKER, DEFENDER = 0x0203A3F0, 0x0203A470
UNIT, CHARACTER, CLASS = 0x02010000, 0x02011000, 0x02012000
STOP, SP = 0x08FFFFF0, 0x03007F00
POISE_CONST = bytes.fromhex("004a01e0") + struct.pack("<I", POISE_ID)

MEM_MAP = [
    (0x02000000, 0x40000),
    (0x03000000, 0x10000),
    (0x04000000, 0x1000),
    (0x05000000, 0x1000),
    (0x06000000, 0x20000),
    (0x07000000, 0x1000),
]


def _active(path: Path) -> str:
    return "\n".join(
        line for line in path.read_text(encoding="utf-8").splitlines()
        if not line.lstrip().startswith("//")
    )


def _patch_calls(code: bytes, present: list[bool]) -> bytes:
    patched = bytearray(code)
    start = 0
    for want in present:
        idx = patched.find(b"\x00\xf8", start)
        if idx < 0:
            raise AssertionError("fewer SkillTester trampolines than expected")
        patched[idx : idx + 2] = (0x2000 | int(want)).to_bytes(2, "little")
        start = idx + 2
    return bytes(patched)


def _run_wta(src: Path, stop: str, present: list[bool], atk: tuple[int, int], dfn: tuple[int, int]):
    from Tools.thumb_harness import Harness, assemble, symbol_offsets

    raw = assemble(src)
    offsets = symbol_offsets(src)
    h = Harness(_patch_calls(raw, present), skill_present=False)
    buf_a, buf_d = bytearray(0x80), bytearray(0x80)
    buf_a[WTA_HIT], buf_a[WTA_DMG] = atk[0] & 0xFF, atk[1] & 0xFF
    buf_d[WTA_HIT], buf_d[WTA_DMG] = dfn[0] & 0xFF, dfn[1] & 0xFF
    h.seed(ATTACKER, bytes(buf_a))
    h.seed(DEFENDER, bytes(buf_d))
    h.run(offsets[stop], regs={"r0": ATTACKER, "r1": DEFENDER})

    def signed(addr, off):
        return struct.unpack_from("<b", h.read(addr + off, 1))[0]

    return (
        (signed(ATTACKER, WTA_HIT), signed(ATTACKER, WTA_DMG)),
        (signed(DEFENDER, WTA_HIT), signed(DEFENDER, WTA_DMG)),
    )


class WTASourceTests(unittest.TestCase):
    def test_ids_are_enabled(self):
        text = DEFS.read_text(encoding="utf-8")
        for name, sid in (
            ("PoiseID", POISE_ID),
            ("TriAdeptID", TRI_ADEPT_ID),
            ("TriAdeptPlusID", TRI_ADEPT_PLUS_ID),
        ):
            m = re.search(rf"^#define\s+{name}\s+(\S+)", text, re.M)
            self.assertIsNotNone(m, name)
            self.assertEqual(int(m.group(1)), sid, name)

    def test_wta_skills_and_loop_are_installed(self):
        self.assertIn("WTASkills/WTASkills.event", _active(MASTER))
        self.assertIn("WTACalcLoop/WTACalcLoop.event", _active(CALC))

    def test_hook_and_reaver_are_fe7(self):
        event = WTA_EVENT.read_text(encoding="utf-8")
        self.assertIn("$2A1E0", event.replace("0x", "$").replace("0X", "$"))
        self.assertNotRegex(event, r"ORG\s+\$2[Cc]830")
        src = WTA_S.read_text(encoding="utf-8")
        self.assertIn("0x0802A121", src)
        self.assertNotIn("0x0802A11E", src)
        self.assertNotIn("0x0802C76", src)

    def test_poise_is_plus_one_move(self):
        src = MOVEMENT.read_text(encoding="utf-8")
        chain, _, rest = src.partition("WORD 0")
        self.assertIn("prSkillPoise", chain)
        self.assertRegex(
            rest,
            r"prSkillPoise:\s*rIfUnitHasSkill\(PoiseID\)\s*rAddConst\(1\)",
        )


class PoiseWTAExecutionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        try:
            from Tools.thumb_harness import assemble  # noqa: F401
        except ImportError as exc:
            raise unittest.SkipTest(f"thumb harness unavailable: {exc}")

    def test_defender_poise_clears_attacker_hit_advantage(self):
        atk, dfn = _run_wta(POISE_S, "End", [True, False], (15, 1), (-15, -1))
        self.assertEqual(atk, (0, 1))
        self.assertEqual(dfn, (-15, -1))

    def test_defender_poise_leaves_neutral_and_disadvantage(self):
        atk, _ = _run_wta(POISE_S, "End", [True, False], (0, 0), (0, 0))
        self.assertEqual(atk, (0, 0))
        atk, _ = _run_wta(POISE_S, "End", [True, False], (-15, -1), (15, 1))
        self.assertEqual(atk, (-15, -1))

    def test_attacker_poise_clears_defender_hit_advantage(self):
        atk, dfn = _run_wta(POISE_S, "End", [False, True], (-15, -1), (15, 1))
        self.assertEqual(atk, (-15, -1))
        self.assertEqual(dfn, (0, 1))

    def test_no_change_without_the_skill(self):
        atk, dfn = _run_wta(POISE_S, "End", [False, False], (15, 1), (-15, -1))
        self.assertEqual(atk, (15, 1))
        self.assertEqual(dfn, (-15, -1))


class TriangleAdeptExecutionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        try:
            from Tools.thumb_harness import assemble  # noqa: F401
        except ImportError as exc:
            raise unittest.SkipTest(f"thumb harness unavailable: {exc}")

    def test_attacker_adept_doubles_only_attacker(self):
        atk, dfn = _run_wta(ADEPT_S, "GoBack", [False, False, True, False], (15, 1), (-15, -1))
        self.assertEqual(atk, (30, 2))
        self.assertEqual(dfn, (-15, -1))

    def test_defender_adept_doubles_only_defender(self):
        atk, dfn = _run_wta(ADEPT_S, "GoBack", [False, False, False, True], (15, 1), (-15, -1))
        self.assertEqual(atk, (15, 1))
        self.assertEqual(dfn, (-30, -2))

    def test_plus_doubles_both_units(self):
        atk, dfn = _run_wta(ADEPT_S, "GoBack", [True, False, False, False], (15, 1), (-15, -1))
        self.assertEqual(atk, (30, 2))
        self.assertEqual(dfn, (-30, -2))

    def test_no_change_without_the_skill(self):
        atk, dfn = _run_wta(ADEPT_S, "GoBack", [False, False, False, False], (15, 1), (-15, -1))
        self.assertEqual(atk, (15, 1))
        self.assertEqual(dfn, (-15, -1))


def _rom_off(addr: int) -> int:
    return (addr & ~1) - ROM_BASE


def _wta_list_off(rom: bytes) -> int:
    if rom[HOOK : HOOK + 2] != bytes.fromhex("7847"):
        raise AssertionError("WTA hook at 0x2A1E0 is not installed")
    loop = _rom_off(struct.unpack_from("<I", rom, HOOK + 12)[0])
    body = rom[loop : loop + 0x40]
    for i in range(0, len(body) - 4, 4):
        p = struct.unpack_from("<I", body, i)[0]
        if 0x09000000 <= p <= 0x0A000000:
            return _rom_off(p)
    raise AssertionError("WTACalcFunctions pointer missing from WTACalcLoop")


def _find_poise_skilltester(rom: bytes) -> int:
    if rom[MOV_GETTER : MOV_GETTER + 4] != bytes.fromhex("004b1847"):
        raise AssertionError("GetUnitMov is not hooked")
    getter = _rom_off(struct.unpack_from("<I", rom, MOV_GETTER + 4)[0])
    cursor = _rom_off(struct.unpack_from("<I", rom, getter + 24)[0])
    while True:
        ptr = struct.unpack_from("<I", rom, cursor)[0]
        if ptr == 0:
            break
        off = _rom_off(ptr)
        if POISE_CONST in rom[off : off + 16]:
            check = _rom_off(struct.unpack_from("<I", rom, off + 8 + 44)[0])
            return _rom_off(struct.unpack_from("<I", rom, check + 12)[0])
        cursor += 4
    raise AssertionError("prSkillPoise is not in the Movement modifier chain")


class WTARomTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        if not HACK.exists():
            raise unittest.SkipTest("FE7_Hack.gba missing")
        cls.rom = HACK.read_bytes()

    def test_poise_and_triangle_adept_are_in_the_wta_loop(self):
        from Tools.thumb_harness import assemble

        poise = assemble(POISE_S)[:12]
        adept = assemble(ADEPT_S)[:12]
        cursor = _wta_list_off(self.rom)
        found = set()
        while True:
            ptr = struct.unpack_from("<I", self.rom, cursor)[0]
            if ptr == 0:
                break
            body = self.rom[_rom_off(ptr) : _rom_off(ptr) + 12]
            if body == poise:
                found.add("Poise")
            if body == adept:
                found.add("TriangleAdept")
            cursor += 4
        self.assertEqual(found, {"Poise", "TriangleAdept"})


class PoiseMoveExecutionTests(unittest.TestCase):
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
        cls.skilltester = ROM_BASE + _find_poise_skilltester(cls.rom)

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
                want = uc_.reg_read(UC_ARM_REG_R1) == POISE_ID
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
            uc.emu_start(ROM_BASE + MOV_GETTER | 1, STOP, timeout=10_000_000, count=1_000_000)
        except UcError as exc:
            self.fail(f"chain faulted at pc={uc.reg_read(UC_ARM_REG_PC):08X}: {exc}")
        self.assertEqual(uc.reg_read(UC_ARM_REG_PC), STOP)
        return uc.reg_read(UC_ARM_REG_R0)

    def test_no_boost_without_the_skill(self):
        self.assertEqual(self._run(skill_present=False), CLASS_MOV)

    def test_boosts_movement_by_one(self):
        self.assertEqual(self._run(skill_present=True), CLASS_MOV + 1)


if __name__ == "__main__":
    unittest.main()
