import struct
import sys
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

try:
    from Tools.thumb_harness import CODE_BASE, Harness, assemble, symbol_offsets
except ImportError:
    CODE_BASE = Harness = assemble = symbol_offsets = None


CAPTURE = (
    ROOT
    / "EngineHacks"
    / "SkillSystem"
    / "Skills"
    / "UnitMenuSkills"
    / "Capture"
    / "Capture"
)
SOURCE = CAPTURE / "Preserve_Captured_Enemy.s"
DROP_SOURCE = CAPTURE / "Drop_Dead_Enemy.s"
UNIT = 0x0202BE4C
CHAR = 0x0817FF00
CARRIER = 0x0202BE4C
RESCUEE = 0x0202BF00
UNIT_LOOKUP = 0x08B92EB0
CHAPTER_DATA = 0x0202BBF8


@unittest.skipIf(Harness is None, "Unicorn/devkitARM is unavailable")
class PreserveCapturedEnemyExecutionTests(unittest.TestCase):
    def _run(self, allegiance, state):
        code = bytearray(assemble(SOURCE))
        offsets = symbol_offsets(SOURCE)
        # ClearUnitSupports has no observable effect in this harness. Replace
        # the three-halfword long-call sequence without touching the preceding
        # state write (the generic SkillTester patch expects five halfwords).
        call = code.find(b"\x00\xf8")
        self.assertGreaterEqual(call, 4)
        code[call - 4 : call + 2] = struct.pack("<HHH", 0x46C0, 0x46C0, 0x46C0)
        harness = Harness(bytes(code))

        unit = bytearray(0x48)
        unit[0:4] = struct.pack("<I", CHAR)
        unit[0x0B] = allegiance
        unit[0x0C:0x10] = struct.pack("<I", state)
        harness.seed(UNIT, bytes(unit))

        harness.run(
            offsets["End"],
            regs={
                "r0": UNIT,
                "lr": (CODE_BASE + offsets["End"]) | 1,
            },
        )
        return harness

    def test_rescued_enemy_keeps_character_pointer(self):
        harness = self._run(0x80, 0x20)

        self.assertEqual(harness.read(UNIT, 4), struct.pack("<I", CHAR))

    def test_unrescued_enemy_still_clears_character_pointer(self):
        harness = self._run(0x80, 0)

        self.assertEqual(harness.read(UNIT, 4), b"\0\0\0\0")

    def test_allied_unit_keeps_vanilla_dead_state(self):
        harness = self._run(0, 0)

        self.assertEqual(harness.read(UNIT, 4), struct.pack("<I", CHAR))
        self.assertEqual(
            struct.unpack("<I", harness.read(UNIT + 0x0C, 4))[0],
            5,
        )


@unittest.skipIf(Harness is None, "Unicorn/devkitARM is unavailable")
class DropCapturedEnemyExecutionTests(unittest.TestCase):
    def _run(self, allegiance, hp):
        code = assemble(DROP_SOURCE)
        offsets = symbol_offsets(DROP_SOURCE)
        harness = Harness(code)

        carrier = bytearray(0x48)
        carrier[0x0C:0x10] = struct.pack("<I", 0x10)
        carrier[0x1B] = 1

        rescuee = bytearray(0x48)
        rescuee[0:4] = struct.pack("<I", CHAR)
        rescuee[0x0B] = allegiance
        rescuee[0x0C:0x10] = struct.pack("<I", 0x21)
        rescuee[0x13] = hp

        harness.seed(CARRIER, bytes(carrier))
        harness.seed(RESCUEE, bytes(rescuee))
        harness.seed(UNIT_LOOKUP + 4, struct.pack("<I", RESCUEE))
        harness.seed(CHAPTER_DATA, bytes(0x10))
        harness.run(
            offsets["End"],
            regs={
                "r0": CARRIER,
                "r1": 7,
                "r2": 8,
                "lr": (CODE_BASE + offsets["End"]) | 1,
            },
        )
        return harness

    def test_one_hp_enemy_is_cleared_when_dropped(self):
        harness = self._run(0x80, 1)

        self.assertEqual(harness.read(RESCUEE, 4), b"\0\0\0\0")
        self.assertEqual(harness.read(RESCUEE + 0x13, 1), b"\0")
        self.assertEqual(
            struct.unpack("<I", harness.read(RESCUEE + 0x0C, 4))[0] & 0x0D,
            0x0D,
        )
        self.assertEqual(harness.read(CARRIER + 0x1B, 1), b"\0")

    def test_allied_one_hp_unit_is_not_cleared(self):
        harness = self._run(0, 1)

        self.assertEqual(
            harness.read(RESCUEE, 4), struct.pack("<I", CHAR)
        )
        self.assertEqual(harness.read(RESCUEE + 0x13, 1), b"\x01")
        self.assertEqual(harness.read(CARRIER + 0x1B, 1), b"\0")


RESCUE_SOURCE = CAPTURE / "After_Battle_Rescue.s"
GET_UNIT = 0x08018D0C
UNIT_DROP = 0x0802F754
UNIT_RESCUE = 0x08017DE4
UNIT_KILL = 0x0802F808
IS_CAPTURE_SET = 0x08FFFF00
SKILLTESTER = 0x08FFFF10
CAPTURE_BIT = 0x04000000
ACTOR_ID = 1
TARGET_ID = 0x80
PROC = 0x0203A4EC
ACTOR = 0x0202BE4C
TARGET = 0x0202BF00
STOP = 0x08FFFFF0
SP = 0x03007F00


@unittest.skipIf(Harness is None, "Unicorn/devkitARM is unavailable")
class AfterBattleRescueSkillGateTests(unittest.TestCase):
    """Capture after a kill must not fire when the winner lacks Capture."""

    def _run(self, skill_present, capture_bit=CAPTURE_BIT, actor_hp=10, target_hp=0):
        from unicorn import Uc, UC_ARCH_ARM, UC_MODE_THUMB, UC_HOOK_CODE
        from unicorn.arm_const import (
            UC_ARM_REG_R0,
            UC_ARM_REG_R1,
            UC_ARM_REG_LR,
            UC_ARM_REG_PC,
            UC_ARM_REG_SP,
        )

        code = bytearray(assemble(RESCUE_SOURCE))
        offsets = symbol_offsets(RESCUE_SOURCE)
        pool = offsets["Is_Capture_Set"]
        need = pool + 12
        if len(code) < need:
            code.extend(b"\x00" * (need - len(code)))
        struct.pack_into("<III", code, pool, IS_CAPTURE_SET, SKILLTESTER, 234)

        bx_lr = b"\x70\x47"
        uc = Uc(UC_ARCH_ARM, UC_MODE_THUMB)
        uc.mem_map(0x02000000, 0x40000)
        uc.mem_map(0x03000000, 0x10000)
        uc.mem_map(0x08000000, 0x1000)
        uc.mem_map(0x08017000, 0x1000)
        uc.mem_map(0x08018000, 0x1000)
        uc.mem_map(0x0802F000, 0x1000)
        uc.mem_map(0x08FFF000, 0x1000)
        uc.mem_write(0x08000000, bytes(code))
        for stub in (GET_UNIT, UNIT_DROP, UNIT_RESCUE, UNIT_KILL, IS_CAPTURE_SET, SKILLTESTER):
            uc.mem_write(stub, bx_lr)

        proc = bytearray(0x70)
        struct.pack_into("<h", proc, 0x64, ACTOR_ID)
        struct.pack_into("<h", proc, 0x66, TARGET_ID)
        uc.mem_write(PROC, bytes(proc))

        actor = bytearray(0x48)
        actor[0x0B] = ACTOR_ID
        actor[0x0C:0x10] = struct.pack("<I", capture_bit)
        actor[0x13] = actor_hp
        uc.mem_write(ACTOR, bytes(actor))

        target = bytearray(0x48)
        target[0x0B] = TARGET_ID
        target[0x13] = target_hp
        uc.mem_write(TARGET, bytes(target))

        units = {ACTOR_ID: ACTOR, TARGET_ID: TARGET}
        rescued = []

        def on_insn(uc_, addr, size, _ud):
            if struct.unpack("<H", bytes(uc_.mem_read(addr, 2)))[0] == 0xF800:
                dest = uc_.reg_read(UC_ARM_REG_LR) & ~1
                uc_.reg_write(UC_ARM_REG_LR, (addr + 2) | 1)
                uc_.reg_write(UC_ARM_REG_PC, dest | 1)
                return
            where = addr & ~1
            ret = uc_.reg_read(UC_ARM_REG_LR)
            if where == GET_UNIT:
                uc_.reg_write(UC_ARM_REG_R0, units.get(uc_.reg_read(UC_ARM_REG_R0), 0))
                uc_.reg_write(UC_ARM_REG_PC, ret)
                return
            if where == UNIT_RESCUE:
                rescued.append(
                    (uc_.reg_read(UC_ARM_REG_R0), uc_.reg_read(UC_ARM_REG_R1))
                )
                uc_.reg_write(UC_ARM_REG_PC, ret)
                return
            if where == IS_CAPTURE_SET:
                unit = uc_.reg_read(UC_ARM_REG_R0)
                state = struct.unpack("<I", bytes(uc_.mem_read(unit + 0x0C, 4)))[0]
                uc_.reg_write(UC_ARM_REG_R0, 1 if state & CAPTURE_BIT else 0)
                uc_.reg_write(UC_ARM_REG_PC, ret)
                return
            if where == SKILLTESTER:
                uc_.reg_write(UC_ARM_REG_R0, 1 if skill_present else 0)
                uc_.reg_write(UC_ARM_REG_PC, ret)
                return

        uc.hook_add(UC_HOOK_CODE, on_insn)
        uc.reg_write(UC_ARM_REG_SP, SP)
        uc.reg_write(UC_ARM_REG_R0, PROC)
        uc.reg_write(UC_ARM_REG_LR, STOP | 1)
        uc.emu_start(0x08000000 | 1, STOP, timeout=2_000_000, count=200_000)
        return uc, rescued

    def test_dead_enemy_is_not_rescued_without_capture_skill(self):
        uc, rescued = self._run(skill_present=False)

        self.assertEqual(rescued, [])
        self.assertEqual(bytes(uc.mem_read(TARGET + 0x13, 1)), b"\0")

    def test_dead_enemy_is_rescued_when_winner_has_capture(self):
        uc, rescued = self._run(skill_present=True)

        self.assertEqual(rescued, [(ACTOR, TARGET)])
        self.assertEqual(bytes(uc.mem_read(TARGET + 0x13, 1)), b"\x01")

    def test_dead_enemy_is_not_rescued_without_capture_flag(self):
        uc, rescued = self._run(skill_present=True, capture_bit=0)

        self.assertEqual(rescued, [])
        self.assertEqual(bytes(uc.mem_read(TARGET + 0x13, 1)), b"\0")


if __name__ == "__main__":
    unittest.main()
