"""DEC-88: Armsthrift, Dazzle, and Desperation round skills."""
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
ROUNDS = ROOT / "EngineHacks" / "SkillSystem" / "Skills" / "RoundsSkills" / "RoundsSkills.event"
ARM_S = (
    ROOT
    / "EngineHacks"
    / "SkillSystem"
    / "Skills"
    / "RoundsSkills"
    / "Armsthrift"
    / "armsthriftaxefaith.s"
)
DAZZLE_S = ROOT / "EngineHacks" / "SkillSystem" / "Skills" / "RoundsSkills" / "Dazzle" / "dazzle.s"
HACK = ROOT / "FE7_Hack.gba"

ARMSTHRIFT_ID = 138
DAZZLE_ID = 140
DESPERATION_ID = 141
AXEFAITH_ID = 165
ATTACKER, DEFENDER = 0x0203A3F0, 0x0203A470
WEAPON, CAN_COUNTER, WTYPE, ATTRS, LUCK = 0x48, 0x52, 0x50, 0x4C, 0x19
MAXHP, HP_INIT = 0x12, 0x72
HITPTR, HIT = 0x0203A500, 0x0203A510
STUB = 0x02000100
ROLL_RN, AFTER_USE = 0x0802857C, 0x08016730
USED_WEAPON = 0x00AA
UNWIND_HOOK = 0x28FB0
DESP_SIG = bytes.fromhex("F8B5164B9E78164B164F1968")


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


class RoundsSourceTests(unittest.TestCase):
    def test_ids_are_enabled(self):
        text = DEFS.read_text(encoding="utf-8")
        for name, sid in (
            ("ArmsthriftID", ARMSTHRIFT_ID),
            ("DazzleID", DAZZLE_ID),
            ("DesperationID", DESPERATION_ID),
        ):
            m = re.search(rf"^#define\s+{name}\s+(\S+)", text, re.M)
            self.assertIsNotNone(m, name)
            self.assertEqual(int(m.group(1)), sid, name)

    def test_rounds_skills_are_installed(self):
        self.assertIn("RoundsSkills/RoundsSkills.event", _active(MASTER))
        rounds = _active(ROUNDS)
        self.assertRegex(rounds, r"ORG\s+\$29498")
        self.assertRegex(rounds, r"ORG\s+\$2A1F4")
        self.assertNotRegex(rounds, r"ORG\s+\$2[Cc]864")
        self.assertIn("jumpToHack(DazzleCheck)", rounds)

    def test_dazzle_returns_are_fe7(self):
        src = DAZZLE_S.read_text(encoding="utf-8")
        self.assertIn("0x0203A3F0", src)
        self.assertIn("0x0203A470", src)
        self.assertNotIn("0x802c877", src.lower())
        self.assertNotIn("0x203a4ec", src.lower())


class ArmsthriftExecutionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        try:
            from Tools.thumb_harness import assemble  # noqa: F401
        except ImportError as exc:
            raise unittest.SkipTest(f"thumb harness unavailable: {exc}")

    def _weapon_after(self, skill, roll, miss=False, attrs=0):
        from Tools.thumb_harness import Harness, assemble, symbol_offsets

        raw = assemble(ARM_S)
        off = symbol_offsets(ARM_S)
        code = bytearray(raw + bytes(12))
        struct.pack_into(
            "<III", code, off["EALiterals"], STUB | 1, ARMSTHRIFT_ID, AXEFAITH_ID
        )
        h = Harness(bytes(code), skill_present=False)
        h.seed(STUB, bytes.fromhex("01207047" if skill else "00207047"))
        h.seed(ROLL_RN, bytes.fromhex("01207047" if roll else "00207047"))
        h.seed(AFTER_USE, bytes.fromhex("AA207047"))
        bu = bytearray(0x80)
        struct.pack_into("<H", bu, WEAPON, 0x1122)
        bu[WTYPE] = 0
        bu[LUCK] = 30
        struct.pack_into("<I", bu, ATTRS, attrs)
        h.seed(ATTACKER, bytes(bu))
        h.seed(HIT, struct.pack("<H", 2 if miss else 0))
        h.seed(HITPTR, struct.pack("<I", HIT))
        h.run(off["End"], regs={"r2": HITPTR, "r5": ATTACKER})
        return struct.unpack_from("<H", h.read(ATTACKER + WEAPON, 2))[0]

    def test_proc_skips_durability(self):
        self.assertEqual(self._weapon_after(True, True), 0x1122)

    def test_failed_roll_consumes(self):
        self.assertEqual(self._weapon_after(True, False), USED_WEAPON)

    def test_no_skill_consumes(self):
        self.assertEqual(self._weapon_after(False, True), USED_WEAPON)

    def test_physical_miss_skips_without_skill(self):
        self.assertEqual(self._weapon_after(False, True, miss=True, attrs=0), 0x1122)


class DazzleExecutionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        try:
            from Tools.thumb_harness import assemble  # noqa: F401
        except ImportError as exc:
            raise unittest.SkipTest(f"thumb harness unavailable: {exc}")

    def _can_counter(self, present, attrs=0):
        from Tools.thumb_harness import Harness, assemble, symbol_offsets

        raw = assemble(DAZZLE_S)
        off = symbol_offsets(DAZZLE_S)
        h = Harness(_patch_calls(raw, present), skill_present=False)
        atk, dfn = bytearray(0x80), bytearray(0x80)
        struct.pack_into("<H", dfn, WEAPON, 0x1122)
        dfn[CAN_COUNTER] = 1
        struct.pack_into("<I", atk, ATTRS, attrs)
        h.seed(ATTACKER, bytes(atk))
        h.seed(DEFENDER, bytes(dfn))
        h.run(off["End"], regs={})
        return (
            struct.unpack_from("<H", h.read(DEFENDER + WEAPON, 2))[0],
            h.read(DEFENDER + CAN_COUNTER, 1)[0],
        )

    def test_dazzle_clears_counter(self):
        self.assertEqual(self._can_counter([True, False]), (0, 0))

    def test_moonlight_clears_counter(self):
        self.assertEqual(self._can_counter([False, True]), (0, 0))

    def test_no_skill_leaves_counter(self):
        self.assertEqual(self._can_counter([False, False]), (0x1122, 1))

    def test_uncounterable_weapon_clears_counter(self):
        self.assertEqual(self._can_counter([False, False], attrs=0x80), (0, 0))


class DazzleRomTests(unittest.TestCase):
    def test_hook_is_installed(self):
        if not HACK.exists():
            raise unittest.SkipTest("FE7_Hack.gba missing")
        rom = HACK.read_bytes()
        self.assertEqual(rom[0x2A1F4 : 0x2A1F4 + 2], bytes.fromhex("004B"))
        self.assertNotEqual(rom[0x2C864 : 0x2C864 + 2], bytes.fromhex("004B"))


class DesperationExecutionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        try:
            from unicorn import Uc  # noqa: F401
            from Tools.thumb_harness import Harness  # noqa: F401
        except ImportError as exc:
            raise unittest.SkipTest(f"thumb harness unavailable: {exc}")
        if not HACK.exists():
            raise unittest.SkipTest("FE7_Hack.gba missing")
        rom = HACK.read_bytes()
        if rom[UNWIND_HOOK : UNWIND_HOOK + 2] != bytes.fromhex("7847"):
            raise AssertionError("NewBattleUnwind is not hooked")
        off = rom.find(DESP_SIG)
        if off < 0:
            raise AssertionError("DoesUnitImmediatelyFollowUp missing from FE7_Hack.gba")
        cls.rom = rom
        cls.off = off

    def _run_rom(self, cur, mx, skill_present):
        from unicorn import Uc, UC_ARCH_ARM, UC_MODE_THUMB, UC_HOOK_CODE, UcError
        from unicorn.arm_const import (
            UC_ARM_REG_R0,
            UC_ARM_REG_R1,
            UC_ARM_REG_LR,
            UC_ARM_REG_PC,
            UC_ARM_REG_SP,
        )

        rom = self.rom
        off = self.off
        pool = rom.find(bytes.fromhex("D8A30302"), off, off + 0x80)
        if pool < 0:
            raise AssertionError("gBattleStats literal missing")
        tester = struct.unpack_from("<I", rom, pool + 8)[0]
        STOP = 0x03007E00
        uc = Uc(UC_ARCH_ARM, UC_MODE_THUMB)
        uc.mem_map(0x02000000, 0x40000)
        uc.mem_map(0x03000000, 0x10000)
        uc.mem_map(0x08000000, (len(rom) + 0xFFF) & ~0xFFF)
        uc.mem_write(0x08000000, rom)
        bu = bytearray(0x80)
        bu[MAXHP] = mx
        bu[HP_INIT] = cur
        uc.mem_write(ATTACKER, bytes(bu))
        uc.mem_write(0x0203A3D8, bytes(4))

        def on_insn(uc_, addr, size, _ud):
            if (addr & ~1) == (tester & ~1):
                sid = uc_.reg_read(UC_ARM_REG_R1)
                uc_.reg_write(
                    UC_ARM_REG_R0,
                    int(skill_present and sid == DESPERATION_ID),
                )
                uc_.reg_write(UC_ARM_REG_PC, uc_.reg_read(UC_ARM_REG_LR))

        uc.hook_add(UC_HOOK_CODE, on_insn)
        uc.reg_write(UC_ARM_REG_SP, 0x03007F00)
        uc.reg_write(UC_ARM_REG_R0, ATTACKER)
        uc.reg_write(UC_ARM_REG_R1, DEFENDER)
        uc.reg_write(UC_ARM_REG_LR, STOP | 1)
        try:
            uc.emu_start(0x08000000 + off | 1, STOP, timeout=2_000_000, count=200_000)
        except UcError as exc:
            self.fail(f"Desperation faulted at pc={uc.reg_read(UC_ARM_REG_PC):08X}: {exc}")
        self.assertEqual(uc.reg_read(UC_ARM_REG_PC), STOP)
        return uc.reg_read(UC_ARM_REG_R0)

    def test_below_half_hp_followup_is_immediate(self):
        self.assertEqual(self._run_rom(7, 16, True), 1)

    def test_at_half_hp_is_not_desperation(self):
        self.assertEqual(self._run_rom(8, 16, True), 0)

    def test_above_half_hp_is_not_desperation(self):
        self.assertEqual(self._run_rom(9, 16, True), 0)

    def test_no_skill_even_at_low_hp(self):
        self.assertEqual(self._run_rom(1, 16, False), 0)


if __name__ == "__main__":
    unittest.main()
