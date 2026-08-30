"""Execute the shipped FE7 Dance hooks on an ARM7TDMI emulator.

The test deliberately starts at the vanilla FE7 hook entries instead of at
the injected labels.  External FE7 calls are intercepted at their real
``.short 0xf800`` call sites, while their observable inputs and outputs are
checked.  Any bad hook, stack return, invalid branch, or runaway execution
becomes a Unicorn fault instead of being mistaken for a successful assemble.
"""
import struct
import unittest
from pathlib import Path

try:
    from unicorn import Uc, UcError, UC_ARCH_ARM, UC_HOOK_CODE, UC_MODE_THUMB
    from unicorn.arm_const import (
        UC_ARM_REG_LR,
        UC_ARM_REG_PC,
        UC_ARM_REG_R0,
        UC_ARM_REG_R1,
        UC_ARM_REG_SP,
    )
except ImportError as exc:  # pragma: no cover - local tool availability
    raise unittest.SkipTest(f"unicorn unavailable: {exc}")


ROOT = Path(__file__).resolve().parents[1]
HACK = ROOT / "FE7_Hack.gba"

ROM_BASE = 0x08000000
STOP = 0x08FFFFF0
SP = 0x03007F00

ACTION_ENTRY = 0x0802F4C4
USABILITY_ENTRY = 0x08022058

G_ACTION_DATA = 0x0203A85C
G_BATTLE_STATS = 0x0203A3D8
G_BM_STATUS = 0x0202BBB8
G_PLAY_STATUS = 0x0202BBF8
G_ACTIVE_UNIT = 0x03004690

ACTOR = 0x02010000
TARGET = 0x02010100
ACTOR_CLASS = 0x02010200
TARGET_CLASS = 0x02010300
ACTOR_CHARACTER = 0x02010400
MENU_PROC = 0x02018000
ACTION_PROC = 0x02018100
BATTLE_ACTOR = 0x0203A3F0
BATTLE_TARGET = 0x0203A470
CHILD_PROC = 0x02018200
PROC_ALLOC_SLOT = 0x02018300

ACTOR_ID = 1
TARGET_ID = 2
DANCE_CLASS_ATTR = 0x10

GET_UNIT = 0x08018D0D
BATTLE_INIT_ITEM_EFFECT = 0x0802A4B5
BATTLE_INIT_ITEM_EFFECT_TARGET = 0x0802A561
APPLY_DANCE_BATTLE_ACTION = 0x0802A5D1
BEGIN_BATTLE_ANIMATIONS = 0x0802A3B1
DANCE_PROC_SCRIPT = 0x08B942A0
DANCE_PROC_CALL = 0x0802A5B5
DANCE_EFFECT = 0x0802A5B5
APPLY_DANCE_PREP = 0x0802A05C
SPAWN_PROC_LOCKING = 0x080044F8
PROC_END = 0x08004584
UPDATE_UNIT_FROM_BATTLE = 0x08029C25


def _base(addr):
    return addr & ~1


def _map_gba_memory(uc, rom):
    uc.mem_map(0x02000000, 0x40000)  # EWRAM
    uc.mem_map(0x03000000, 0x10000)  # IWRAM
    uc.mem_map(0x04000000, 0x1000)   # IO
    rom_size = (len(rom) + 0xFFF) & ~0xFFF
    uc.mem_map(ROM_BASE, rom_size)
    uc.mem_write(ROM_BASE, rom)
    uc.reg_write(UC_ARM_REG_SP, SP)
    uc.reg_write(UC_ARM_REG_LR, STOP | 1)


def _seed_units(uc, class_attributes):
    uc.mem_write(ACTOR, b"\x00" * 0x80)
    uc.mem_write(TARGET, b"\x00" * 0x80)
    uc.mem_write(ACTOR_CLASS, b"\x00" * 0x40)
    uc.mem_write(TARGET_CLASS, b"\x00" * 0x40)
    uc.mem_write(ACTOR_CHARACTER, b"\x00" * 0x40)
    uc.mem_write(ACTOR, struct.pack("<I", ACTOR_CHARACTER))
    uc.mem_write(ACTOR + 4, struct.pack("<I", ACTOR_CLASS))
    uc.mem_write(TARGET + 4, struct.pack("<I", TARGET_CLASS))
    uc.mem_write(ACTOR_CLASS + 0x28, struct.pack("<I", class_attributes))
    uc.mem_write(G_ACTIVE_UNIT, struct.pack("<I", ACTOR))

    uc.mem_write(G_ACTION_DATA, b"\x00" * 0x20)
    uc.mem_write(G_ACTION_DATA + 0xC, bytes([ACTOR_ID]))
    uc.mem_write(G_ACTION_DATA + 0xD, bytes([TARGET_ID]))
    uc.mem_write(G_BATTLE_STATS, b"\x00" * 0x20)
    uc.mem_write(ACTION_PROC, b"\x00" * 0x40)
    uc.mem_write(BATTLE_ACTOR + 0xB, bytes([ACTOR_ID]))


def _run_until_stop(uc, entry):
    try:
        uc.emu_start(entry | 1, STOP, timeout=10_000_000, count=1_000_000)
    except UcError as exc:
        pc = uc.reg_read(UC_ARM_REG_PC)
        regs = {
            name: uc.reg_read(reg)
            for name, reg in (
                ("r0", UC_ARM_REG_R0),
                ("r1", UC_ARM_REG_R1),
                ("sp", UC_ARM_REG_SP),
                ("lr", UC_ARM_REG_LR),
            )
        }
        state = ", ".join(f"{name}={value:08X}" for name, value in regs.items())
        raise AssertionError(
            f"Unicorn fault at {pc:08X}: {exc} ({state})"
        ) from exc
    pc = uc.reg_read(UC_ARM_REG_PC)
    if _base(pc) != STOP:
        raise AssertionError(f"routine did not return; stopped at {pc:08X}")


class DanceUnicornTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        if not HACK.is_file():
            raise unittest.SkipTest("FE7_Hack.gba missing")
        cls.rom = HACK.read_bytes()

    def _run_action(self, class_attributes, animation_config):
        uc = Uc(UC_ARCH_ARM, UC_MODE_THUMB)
        _map_gba_memory(uc, self.rom)
        _seed_units(uc, class_attributes)
        uc.mem_write(G_PLAY_STATUS + 0x42, bytes([animation_config]))

        apply_proc = []
        begin_configs = []
        calls = []
        spawned_parents = []
        update_calls = 0
        units = {ACTOR_ID: ACTOR, TARGET_ID: TARGET}

        # Proc_End returns a locked child to the allocator.  Seed only the
        # allocator head needed by that real FE7 proc code.
        alloc_head_literal = struct.unpack(
            "<I", bytes(uc.mem_read(0x080045A8, 4))
        )[0]
        uc.mem_write(
            alloc_head_literal, struct.pack("<I", PROC_ALLOC_SLOT + 4)
        )

        def return_from_direct_call(uc_):
            uc_.reg_write(UC_ARM_REG_PC, uc_.reg_read(UC_ARM_REG_LR))

        def spawn_dance_proc(uc_):
            parent = uc_.reg_read(UC_ARM_REG_R1)
            if parent != ACTION_PROC:
                raise AssertionError(
                    f"Dance proc parent was {parent:08X}, "
                    f"expected {ACTION_PROC:08X}"
                )

            script = uc_.reg_read(UC_ARM_REG_R0)
            spawned_parents.append(parent)
            uc_.mem_write(CHILD_PROC, b"\x00" * 0x40)
            uc_.mem_write(CHILD_PROC, struct.pack("<I", script))
            uc_.mem_write(CHILD_PROC + 4, struct.pack("<I", script))
            uc_.mem_write(
                CHILD_PROC + 0x14, struct.pack("<I", parent)
            )
            uc_.mem_write(CHILD_PROC + 0x27, b"\x02")
            uc_.mem_write(
                parent + 0x18, struct.pack("<I", CHILD_PROC)
            )
            uc_.mem_write(parent + 0x28, b"\x01")
            uc_.reg_write(UC_ARM_REG_R0, CHILD_PROC)
            return_from_direct_call(uc_)

        def on_code(uc_, addr, _size, _user_data):
            nonlocal update_calls
            target = _base(addr)

            if target == _base(GET_UNIT):
                unit = units.get(uc_.reg_read(UC_ARM_REG_R0) & 0xFF)
                if unit is None:
                    raise AssertionError("DanceAction requested an unknown unit")
                uc_.reg_write(UC_ARM_REG_R0, unit)
                return_from_direct_call(uc_)
                return

            if target == _base(APPLY_DANCE_PREP):
                return_from_direct_call(uc_)
                return

            if target == _base(SPAWN_PROC_LOCKING):
                spawn_dance_proc(uc_)
                return

            if target == _base(UPDATE_UNIT_FROM_BATTLE):
                update_calls += 1
                return_from_direct_call(uc_)
                return

            if struct.unpack("<H", bytes(uc_.mem_read(addr, 2)))[0] != 0xF800:
                return

            target = _base(uc_.reg_read(UC_ARM_REG_LR))
            calls.append(target)
            if target == _base(GET_UNIT):
                unit = units.get(uc_.reg_read(UC_ARM_REG_R0) & 0xFF)
                if unit is None:
                    raise AssertionError("DanceAction requested an unknown unit")
                uc_.reg_write(UC_ARM_REG_R0, unit)
            elif target in (
                _base(BATTLE_INIT_ITEM_EFFECT),
                _base(BATTLE_INIT_ITEM_EFFECT_TARGET),
            ):
                pass
            elif target == _base(APPLY_DANCE_BATTLE_ACTION):
                apply_proc.append(uc_.reg_read(UC_ARM_REG_R0))
                uc_.reg_write(
                    UC_ARM_REG_PC, _base(APPLY_DANCE_BATTLE_ACTION) | 1
                )
                uc_.reg_write(UC_ARM_REG_LR, (addr + 2) | 1)
                return
            elif target == _base(BEGIN_BATTLE_ANIMATIONS):
                if not class_attributes & DANCE_CLASS_ATTR:
                    raise AssertionError(
                        "non-dancer entered BeginBattleAnimations"
                    )
                begin_configs.append(
                    bytes(uc_.mem_read(G_PLAY_STATUS + 0x42, 1))[0]
                )
            else:
                raise AssertionError(f"unexpected DanceAction call {target:08X}")

            # Emulate the external routine's return at this exact call site.
            return_addr = (addr + 2) | 1
            uc_.reg_write(UC_ARM_REG_LR, return_addr)
            uc_.reg_write(UC_ARM_REG_PC, return_addr)

        uc.hook_add(UC_HOOK_CODE, on_code)
        uc.reg_write(UC_ARM_REG_R0, ACTION_PROC)
        _run_until_stop(uc, ACTION_ENTRY)

        if not spawned_parents:
            raise AssertionError("DanceAction did not create its completion proc")

        script = bytes(uc.mem_read(DANCE_PROC_SCRIPT, 16))
        self.assertEqual(struct.unpack("<H", script[0:2])[0], 0x000E)
        self.assertEqual(struct.unpack("<H", script[2:4])[0], 1)
        self.assertEqual(struct.unpack("<H", script[8:10])[0], 0x0002)
        self.assertEqual(struct.unpack("<I", script[12:16])[0], DANCE_PROC_CALL)

        # Execute the proc's CALL step and its real cleanup path.  This is
        # the part the old harness skipped: a bad parent here leaves the
        # action tree locked forever even though the action routine returned.
        uc.reg_write(UC_ARM_REG_LR, STOP | 1)
        _run_until_stop(uc, DANCE_EFFECT)
        uc.reg_write(UC_ARM_REG_R0, CHILD_PROC)
        uc.reg_write(UC_ARM_REG_LR, STOP | 1)
        _run_until_stop(uc, PROC_END)

        return {
            "config": bytes(uc.mem_read(G_PLAY_STATUS + 0x42, 1))[0],
            "apply_proc": apply_proc,
            "begin_configs": begin_configs,
            "calls": calls,
            "spawned_parents": spawned_parents,
            "update_calls": update_calls,
            "parent_lock": bytes(uc.mem_read(ACTION_PROC + 0x28, 1))[0],
            "child_attached": struct.unpack(
                "<I", bytes(uc.mem_read(ACTION_PROC + 0x18, 4))
            )[0],
        }

    def _run_usability(self, skill_present, class_attributes):
        uc = Uc(UC_ARCH_ARM, UC_MODE_THUMB)
        _map_gba_memory(uc, self.rom)
        _seed_units(uc, class_attributes)
        uc.mem_write(G_BM_STATUS + 0x2C, b"\x00\x00")

        call_count = 0

        def on_code(uc_, addr, _size, _user_data):
            nonlocal call_count
            if struct.unpack("<H", bytes(uc_.mem_read(addr, 2)))[0] != 0xF800:
                return

            # The first trampoline is SkillTester.  Any later one is the
            # FE7 vanilla common Dance usability routine.
            uc_.reg_write(UC_ARM_REG_R0, int(skill_present or call_count > 0))
            call_count += 1
            return_addr = (addr + 2) | 1
            uc_.reg_write(UC_ARM_REG_LR, return_addr)
            uc_.reg_write(UC_ARM_REG_PC, return_addr)

        uc.hook_add(UC_HOOK_CODE, on_code)
        uc.reg_write(UC_ARM_REG_R0, MENU_PROC)
        uc.reg_write(UC_ARM_REG_R1, 0)
        _run_until_stop(uc, USABILITY_ENTRY)
        return {
            "result": uc.reg_read(UC_ARM_REG_R0),
            "status": struct.unpack(
                "<H", bytes(uc.mem_read(G_BM_STATUS + 0x2C, 2))
            )[0],
            "calls": call_count,
        }

    def test_action_non_dancer_with_animations_off_returns_and_restores(self):
        result = self._run_action(class_attributes=0, animation_config=0x20)
        self.assertEqual(result["begin_configs"], [])
        self.assertEqual(result["config"], 0x20)
        self.assertEqual(result["apply_proc"], [ACTION_PROC])
        self.assertEqual(result["spawned_parents"], [ACTION_PROC])
        self.assertEqual(result["update_calls"], 1)
        self.assertEqual(result["parent_lock"], 0)
        self.assertEqual(result["child_attached"], 0)

    def test_action_non_dancer_skips_custom_animation_and_restores_setting(self):
        result = self._run_action(class_attributes=0, animation_config=0)
        self.assertEqual(result["begin_configs"], [])
        self.assertEqual(result["config"], 0)
        self.assertEqual(result["apply_proc"], [ACTION_PROC])
        self.assertEqual(result["spawned_parents"], [ACTION_PROC])
        self.assertEqual(result["update_calls"], 1)
        self.assertEqual(result["parent_lock"], 0)
        self.assertEqual(result["child_attached"], 0)

    def test_action_dancer_keeps_animation_setting(self):
        result = self._run_action(
            class_attributes=DANCE_CLASS_ATTR, animation_config=0x20
        )
        self.assertEqual(result["begin_configs"], [0x20])
        self.assertEqual(result["config"], 0x20)
        self.assertEqual(result["apply_proc"], [ACTION_PROC])
        self.assertEqual(result["spawned_parents"], [ACTION_PROC])
        self.assertEqual(result["update_calls"], 1)
        self.assertEqual(result["parent_lock"], 0)
        self.assertEqual(result["child_attached"], 0)

    def test_vanilla_fe7_dance_usability_writes_item_9d(self):
        clean = ROOT / "FE7_clean.gba"
        if not clean.is_file():
            raise unittest.SkipTest("FE7_clean.gba missing")
        # 0x08022074: mov r0, #0x9D
        self.assertEqual(clean.read_bytes()[0x22074:0x22076], b"\x9d\x20")

    def test_fe7_usability_hook_executes_for_skill_at_fe7_entry(self):
        result = self._run_usability(
            skill_present=True, class_attributes=0
        )
        self.assertEqual(result["result"], 1)
        self.assertEqual(result["status"], 0x9D)
        self.assertEqual(result["calls"], 2)

    def test_fe7_usability_rejects_non_dancer_without_skill(self):
        result = self._run_usability(
            skill_present=False, class_attributes=0
        )
        self.assertEqual(result["result"], 3)
        self.assertEqual(result["calls"], 1)

    def test_fe7_usability_rejects_missing_skill_when_vanilla_check_is_off(self):
        result = self._run_usability(
            skill_present=False, class_attributes=DANCE_CLASS_ATTR
        )
        self.assertEqual(result["result"], 3)
        self.assertEqual(result["status"], 0)
        self.assertEqual(result["calls"], 1)


if __name__ == "__main__":
    unittest.main()
