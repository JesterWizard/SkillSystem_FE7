"""Execute every modular stat getter out of the built FE7_Hack.gba on a real core.

The stat screen calls GetUnitPower/Skill/Speed/Defence/Res/Luck/Mov/Con for the
unit it is drawing. If any one of those chains runs off into data the screen
never finishes drawing and the game sits on a black screen -- which is exactly
what a `WORD 0` stub for Is_Capture_Set caused: HalveIfCapturing *calls* that
pointer, so prHalveIfCapturing branched into the freespace data that followed
and executed it, ending in a load off a null pointer.

No source-level check catches that. This test maps the whole ROM plus GBA RAM
into Unicorn, points each vanilla getter entry at a synthetic unit, and runs
the real chain to completion, asserting the value that comes back.

The `.short 0xf800` trampoline the modular getters use (`ldr r3,<target>;
mov lr,r3; .short 0xf800`) is a valid ARM7TDMI BL-second-half but Unicorn
decodes it as a Thumb-2 prefix, so it is emulated in a code hook.

Skill lookup is not stubbed here: the synthetic unit simply owns no skills, so
this covers the no-skill path of every chain. Skill assignment itself is editor
data and out of scope per the project's TDD rules.
"""
import struct
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
HACK = ROOT / "FE7_Hack.gba"

ROM_BASE = 0x08000000

# FE7 vanilla getter entry points (file offsets), hooked by MSG/InstallCore.event.
GETTERS = {
    "MaxHP": 0x18AB0,
    "CurHP": 0x18A70,
    "Pow": 0x18AD0,
    "Mag": 0x18AD8,
    "Skl": 0x18AF0,
    "Spd": 0x18B30,
    "Def": 0x18B70,
    "Res": 0x18B90,
    "Lck": 0x18BB8,
    "Aid": 0x18450,
    "Mov": 0x18B44,
    "Con": 0x18BA4,
}

UNIT = 0x02010000
CHARACTER = 0x02011000
CLASS = 0x02012000
STOP = 0x08FFFFF0
SP = 0x03007F00

BASE_STAT = 10
BASE_MAG = 5
CLASS_CON = 8
CLASS_MOV = 6

# unit struct offsets
UNIT_MAXHP, UNIT_CURHP = 0x12, 0x13
UNIT_POW, UNIT_SKL, UNIT_SPD, UNIT_DEF, UNIT_RES, UNIT_LCK = (
    0x14, 0x15, 0x16, 0x17, 0x18, 0x19)
UNIT_MAG = 0x47
CLASS_CON_OFF, CLASS_MOV_OFF = 0x11, 0x12

EXPECTED = {
    "MaxHP": BASE_STAT, "CurHP": BASE_STAT, "Pow": BASE_STAT, "Mag": BASE_MAG,
    "Skl": BASE_STAT, "Spd": BASE_STAT, "Def": BASE_STAT, "Res": BASE_STAT,
    "Lck": BASE_STAT, "Mov": CLASS_MOV, "Con": CLASS_CON,
    # Aid = Con - 1 for an unmounted unit.
    "Aid": CLASS_CON - 1,
}

MEM_MAP = [
    (0x02000000, 0x40000),   # EWRAM
    (0x03000000, 0x10000),   # IWRAM (+ its mirror; FE7 addresses past 0x8000)
    (0x04000000, 0x1000),    # IO
    (0x05000000, 0x1000),    # palette
    (0x06000000, 0x20000),   # VRAM
    (0x07000000, 0x1000),    # OAM
]


def _load():
    try:
        from unicorn import Uc, UC_ARCH_ARM, UC_MODE_THUMB
    except ImportError:
        raise unittest.SkipTest("unicorn not installed")
    if not HACK.exists():
        raise unittest.SkipTest(f"{HACK.name} not built")
    return Uc, UC_ARCH_ARM, UC_MODE_THUMB, HACK.read_bytes()


class StatGetterExecution(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.Uc, cls.arch, cls.mode, cls.rom = _load()

    def _run(self, entry_addr):
        from unicorn import UcError, UC_HOOK_CODE
        from unicorn.arm_const import (
            UC_ARM_REG_R0, UC_ARM_REG_SP, UC_ARM_REG_LR, UC_ARM_REG_PC)

        uc = self.Uc(self.arch, self.mode)
        for base, size in MEM_MAP:
            uc.mem_map(base, size)
        uc.mem_map(0x08000000, (len(self.rom) + 0xFFF) & ~0xFFF)
        uc.mem_write(0x08000000, self.rom)

        uc.mem_write(UNIT, struct.pack("<II", CHARACTER, CLASS) + b"\x00" * 0x44)
        uc.mem_write(CHARACTER, b"\x00" * 0x34)
        uc.mem_write(CLASS, b"\x00" * 0x54)
        for off in (UNIT_MAXHP, UNIT_CURHP, UNIT_POW, UNIT_SKL, UNIT_SPD,
                    UNIT_DEF, UNIT_RES, UNIT_LCK):
            uc.mem_write(UNIT + off, bytes([BASE_STAT]))
        uc.mem_write(UNIT + UNIT_MAG, bytes([BASE_MAG]))
        uc.mem_write(CLASS + CLASS_CON_OFF, bytes([CLASS_CON]))
        uc.mem_write(CLASS + CLASS_MOV_OFF, bytes([CLASS_MOV]))

        def on_insn(uc_, addr, size, _ud):
            if struct.unpack("<H", uc_.mem_read(addr, 2))[0] == 0xF800:
                target = uc_.reg_read(UC_ARM_REG_LR)
                uc_.reg_write(UC_ARM_REG_LR, (addr + 2) | 1)
                uc_.reg_write(UC_ARM_REG_PC, target | 1)

        uc.hook_add(UC_HOOK_CODE, on_insn)
        uc.reg_write(UC_ARM_REG_SP, SP)
        uc.reg_write(UC_ARM_REG_R0, UNIT)
        uc.reg_write(UC_ARM_REG_LR, STOP | 1)
        try:
            uc.emu_start(ROM_BASE + entry_addr | 1, STOP, timeout=10_000_000, count=1_000_000)
        except UcError as exc:
            self.fail(f"chain faulted at pc={uc.reg_read(UC_ARM_REG_PC):08X}: {exc}")
        self.assertEqual(uc.reg_read(UC_ARM_REG_PC), STOP,
                         "chain did not return (ran away or looped)")
        return uc.reg_read(UC_ARM_REG_R0)

    def test_every_getter_returns_the_base_stat(self):
        for name, entry in GETTERS.items():
            with self.subTest(getter=name):
                self.assertEqual(self._run(entry), EXPECTED[name])

    def test_halve_if_capturing_stub_is_a_routine_not_a_word(self):
        """Power's chain is the one that calls Is_Capture_Set; regression guard."""
        self.assertEqual(self._run(GETTERS["Pow"]), BASE_STAT)


if __name__ == "__main__":
    unittest.main()
