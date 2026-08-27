"""Steal / Steal+ FE7 hooks: vanilla Steal command, skill gate, weapon steal."""
from __future__ import annotations

import re
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
except ImportError as exc:  # pragma: no cover
    raise unittest.SkipTest(f"unicorn unavailable: {exc}") from exc


ROOT = Path(__file__).resolve().parents[1]
HACK = ROOT / "FE7_Hack.gba"
CLEAN = ROOT / "FE7_clean.gba"
DEFS = ROOT / "EngineHacks/SkillSystem/skill_definitions.event"
CONFIG = ROOT / "EngineHacks/Config.event"
INSTALLER = (
    ROOT
    / "EngineHacks/SkillSystem/Skills/UnitMenuSkills/StealPlus/StealPlus/StealPlus.event"
)
CAN_STEAL_S = (
    ROOT
    / "EngineHacks/SkillSystem/Skills/UnitMenuSkills/StealPlus/StealPlus/Can_Unit_Steal.s"
)
ROGUE_S = (
    ROOT
    / "EngineHacks/SkillSystem/Skills/UnitMenuSkills/StealPlus/StealPlus/FE8-Rogue_Robbery.s"
)

ROM_BASE = 0x08000000
STOP = 0x08FFFFF0
SP = 0x03007F00

USABILITY_ENTRY = 0x08022F78
IS_ITEM_STEALABLE = 0x08016D38
STEAL_LIST_CHECK = 0x080244D0
STEAL_MENU_CHECK = 0x08023110

MAKE_TARGET_LIST = 0x08024504
GET_TARGET_LIST_SIZE = 0x0804B174
GET_ITEM_TYPE = 0x0801725C
GET_EQUIPPED_SLOT = 0x08016794
GET_ITEM_WEIGHT = 0x08017310

G_ACTIVE_UNIT = 0x03004690
ACTOR = 0x02010000
TARGET = 0x02010100
ACTOR_CLASS = 0x02010200
ACTOR_CHARACTER = 0x02010400
TARGET_CLASS = 0x02010500
MENU_PROC = 0x02018000

STEAL_ID = 246
STEAL_PLUS_ID = 247
STEAL_ABILITY = 0x4
USABLE, GRAYED, HIDDEN = 1, 2, 3

FE8_ORGS = (
    0x17054,
    0x24190,
    0x2432A,
    0x2435C,
    0x25BCC,
    0x34D9A,
    0x3DB70,
    0x3DC0C,
    0x3DC66,
    0x3D4C4,
    0x3EE56,
)


def _base(addr):
    return addr & ~1


def _active(path: Path) -> str:
    return "\n".join(
        line
        for line in path.read_text(encoding="utf-8").splitlines()
        if not line.lstrip().startswith("//")
    )


def _macro(name: str) -> str:
    match = re.search(rf"^#define {name} (\S+)", DEFS.read_text(encoding="utf-8"), re.M)
    if match is None:
        raise AssertionError(f"{name} missing")
    return match.group(1)


def _map_gba_memory(uc, rom):
    uc.mem_map(0x02000000, 0x40000)
    uc.mem_map(0x03000000, 0x10000)
    uc.mem_map(0x04000000, 0x1000)
    rom_size = (len(rom) + 0xFFF) & ~0xFFF
    uc.mem_map(ROM_BASE, rom_size)
    uc.mem_write(ROM_BASE, rom)
    uc.reg_write(UC_ARM_REG_SP, SP)
    uc.reg_write(UC_ARM_REG_LR, STOP | 1)


def _seed_thief(uc, ability=0, state=0, items=None):
    uc.mem_write(ACTOR, b"\x00" * 0x48)
    uc.mem_write(TARGET, b"\x00" * 0x48)
    uc.mem_write(ACTOR_CLASS, b"\x00" * 0x40)
    uc.mem_write(ACTOR_CHARACTER, b"\x00" * 0x40)
    uc.mem_write(TARGET_CLASS, b"\x00" * 0x40)
    uc.mem_write(ACTOR, struct.pack("<I", ACTOR_CHARACTER))
    uc.mem_write(ACTOR + 4, struct.pack("<I", ACTOR_CLASS))
    uc.mem_write(TARGET + 4, struct.pack("<I", TARGET_CLASS))
    uc.mem_write(ACTOR_CLASS + 0x28, struct.pack("<I", ability))
    uc.mem_write(ACTOR + 0xC, struct.pack("<I", state))
    packed = b"\x00\x00" * 5
    if items:
        blob = b"".join(struct.pack("<H", item) for item in items)
        packed = blob + packed[len(blob) :]
    uc.mem_write(ACTOR + 0x1E, packed)
    uc.mem_write(G_ACTIVE_UNIT, struct.pack("<I", ACTOR))


def _run_until_stop(uc, entry):
    try:
        uc.emu_start(entry | 1, STOP, timeout=10_000_000, count=1_000_000)
    except UcError as exc:
        pc = uc.reg_read(UC_ARM_REG_PC)
        raise AssertionError(f"Unicorn fault at {pc:08X}: {exc}") from exc
    pc = uc.reg_read(UC_ARM_REG_PC)
    if _base(pc) != STOP:
        raise AssertionError(f"routine did not return; stopped at {pc:08X}")


class StealSourceTests(unittest.TestCase):
    def test_ids_are_enabled(self):
        self.assertEqual(_macro("StealID"), str(STEAL_ID))
        self.assertEqual(_macro("StealPlusID"), str(STEAL_PLUS_ID))

    def test_installer_uses_fe7_hooks(self):
        text = _active(INSTALLER)
        self.assertIn("ORG $16D38", text)
        self.assertIn("ORG $22F78", text)
        self.assertIn("ORG $244D0", text)
        self.assertIn("ORG $23110", text)
        self.assertIn("jumpToHack(Rogue_Robbery)", text)
        self.assertIn("jumpToHack(Can_Unit_Steal)", text)
        self.assertIn("jumpToHack(StealSlotCheck)", text)
        self.assertIn("jumpToHack(StealMenuSlotCheck)", text)
        self.assertIn("WORD ALSO_USE_VANILLA_STEAL_CHECK", text)
        for org in (
            "ORG $17054",
            "ORG $24190",
            "ORG $25BCC",
            "ORG $34D9A",
            "ORG $3DC0C",
            "ORG $3D4C4",
            "ORG $3EE56",
        ):
            self.assertNotIn(org, text, org)

    def test_usability_uses_fe7_steal_helpers(self):
        src = CAN_STEAL_S.read_text(encoding="utf-8")
        self.assertIn("0x08024505", src)
        self.assertIn("0x0804B175", src)
        self.assertIn("0x03004690", src)
        self.assertNotIn("0x08025c00", src)
        self.assertNotIn("0x080176da", src)

    def test_rogue_robbery_accepts_unit_or_item(self):
        src = ROGUE_S.read_text(encoding="utf-8")
        self.assertIn("VanillaStealable", src)
        self.assertIn("0x0801725D", src)
        self.assertIn("0x08016795", src)
        self.assertIn("0x08017311", src)
        self.assertNotIn("0x8017054", src)

    def test_vanilla_steal_ability_still_counts(self):
        cfg = CONFIG.read_text(encoding="utf-8")
        self.assertIn("#define ALSO_USE_VANILLA_STEAL_CHECK True", cfg)
        self.assertIn("#define ENABLE_STEAL_SKILL", cfg)


@unittest.skipUnless(HACK.exists() and CLEAN.exists(), "FE7_Hack.gba or FE7_clean.gba missing")
class StealRomHookTests(unittest.TestCase):
    def test_fe8_orgs_do_not_clobber_fe7(self):
        hack = HACK.read_bytes()
        clean = CLEAN.read_bytes()
        for off in FE8_ORGS:
            n = 8 if off in (0x17054, 0x3DC0C, 0x24190) else 4
            self.assertEqual(
                hack[off : off + n],
                clean[off : off + n],
                f"FE8 Steal ORG ${off:X} overwrote FE7 ROM",
            )

    def test_fe7_steal_sites_are_hooked(self):
        hack = HACK.read_bytes()
        # jumpToHack: ldr r3,[pc]; bx r3. Pre-assemble still has vanilla here.
        if hack[0x16D38:0x16D3C] != bytes.fromhex("004b1847"):
            self.skipTest("FE7_Hack.gba does not yet contain steal jumpToHack")
        for off in (0x16D38, 0x22F78, 0x244D0, 0x23110):
            ptr = struct.unpack_from("<I", hack, off + 4)[0]
            self.assertTrue(
                0x09000000 <= (ptr & ~1) < 0x0A000000,
                f"${off:X} dest {ptr:08X}",
            )


@unittest.skipUnless(HACK.exists(), "FE7_Hack.gba missing")
class StealUsabilityUnicornTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.rom = HACK.read_bytes()
        if cls.rom[0x22F78:0x22F7C] != bytes.fromhex("004b1847"):
            raise unittest.SkipTest("steal usability hook not in FE7_Hack.gba yet")

    def _run(self, skill_present, ability=0, state=0, items=(0x6C,), targets=1):
        uc = Uc(UC_ARCH_ARM, UC_MODE_THUMB)
        _map_gba_memory(uc, self.rom)
        _seed_thief(uc, ability=ability, state=state, items=list(items))

        def on_code(uc_, addr, _size, _user_data):
            if struct.unpack("<H", bytes(uc_.mem_read(addr, 2)))[0] != 0xF800:
                return
            target = _base(uc_.reg_read(UC_ARM_REG_LR))
            if target == MAKE_TARGET_LIST:
                uc_.reg_write(UC_ARM_REG_R0, 0)
            elif target == GET_TARGET_LIST_SIZE:
                uc_.reg_write(UC_ARM_REG_R0, targets)
            else:
                uc_.reg_write(UC_ARM_REG_R0, int(skill_present))
            ret = (addr + 2) | 1
            uc_.reg_write(UC_ARM_REG_LR, ret)
            uc_.reg_write(UC_ARM_REG_PC, ret)

        uc.hook_add(UC_HOOK_CODE, on_code)
        uc.reg_write(UC_ARM_REG_R0, MENU_PROC)
        _run_until_stop(uc, USABILITY_ENTRY)
        return uc.reg_read(UC_ARM_REG_R0)

    def test_skill_with_target_is_usable(self):
        self.assertEqual(self._run(True), USABLE)

    def test_no_skill_hides_command(self):
        self.assertEqual(self._run(False), HIDDEN)

    def test_vanilla_steal_ability_without_skill(self):
        self.assertEqual(self._run(False, ability=STEAL_ABILITY), USABLE)

    def test_cantoing_hides_command(self):
        self.assertEqual(self._run(True, state=0x40), HIDDEN)

    def test_no_targets_hides_command(self):
        self.assertEqual(self._run(True, targets=0), HIDDEN)

    def test_full_inventory_grays_command(self):
        self.assertEqual(self._run(True, items=(1, 2, 3, 4, 5)), GRAYED)


@unittest.skipUnless(HACK.exists(), "FE7_Hack.gba missing")
class StealPlusUnicornTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.rom = HACK.read_bytes()
        if cls.rom[0x16D38:0x16D3C] != bytes.fromhex("004b1847"):
            raise unittest.SkipTest("IsItemStealable hook not in FE7_Hack.gba yet")

    def _run(self, r0, r1, item_type, steal_plus=False, equipped_slot=0, weight=5, con=8):
        uc = Uc(UC_ARCH_ARM, UC_MODE_THUMB)
        _map_gba_memory(uc, self.rom)
        uc.mem_write(TARGET, b"\x00" * 0x48)
        uc.mem_write(ACTOR, b"\x00" * 0x48)
        uc.mem_write(G_ACTIVE_UNIT, struct.pack("<I", ACTOR))
        if r0 == TARGET:
            uc.mem_write(TARGET + 0x1E + r1 * 2, struct.pack("<H", 0x0001))
        freespace_calls = 0

        def on_code(uc_, addr, _size, _user_data):
            nonlocal freespace_calls
            if struct.unpack("<H", bytes(uc_.mem_read(addr, 2)))[0] != 0xF800:
                return
            target = _base(uc_.reg_read(UC_ARM_REG_LR))
            if target == GET_ITEM_TYPE:
                uc_.reg_write(UC_ARM_REG_R0, item_type)
            elif target == GET_EQUIPPED_SLOT:
                uc_.reg_write(UC_ARM_REG_R0, equipped_slot)
            elif target == GET_ITEM_WEIGHT:
                uc_.reg_write(UC_ARM_REG_R0, weight)
            else:
                # Watchful is SKILL_OFF, so the first freespace trampoline is
                # Steal+ SkillTester and the second is Con_Getter.
                freespace_calls += 1
                if freespace_calls == 1:
                    uc_.reg_write(UC_ARM_REG_R0, int(steal_plus))
                else:
                    uc_.reg_write(UC_ARM_REG_R0, con)
            ret = (addr + 2) | 1
            uc_.reg_write(UC_ARM_REG_LR, ret)
            uc_.reg_write(UC_ARM_REG_PC, ret)

        uc.hook_add(UC_HOOK_CODE, on_code)
        uc.reg_write(UC_ARM_REG_R0, r0)
        uc.reg_write(UC_ARM_REG_R1, r1)
        _run_until_stop(uc, IS_ITEM_STEALABLE)
        return uc.reg_read(UC_ARM_REG_R0)

    def test_item_short_type9_is_stealable(self):
        self.assertEqual(self._run(0x006C, 0, item_type=9), 1)

    def test_item_short_weapon_is_not_stealable(self):
        self.assertEqual(self._run(0x0001, 0, item_type=0), 0)

    def test_unit_item_stealable_without_steal_plus(self):
        self.assertEqual(self._run(TARGET, 0, item_type=9, steal_plus=False), 1)

    def test_unit_weapon_needs_steal_plus(self):
        self.assertEqual(self._run(TARGET, 0, item_type=0, steal_plus=False), 0)

    def test_steal_plus_weapon_when_con_beats_weight(self):
        self.assertEqual(
            self._run(TARGET, 1, item_type=0, steal_plus=True, equipped_slot=0, weight=5, con=8),
            1,
        )

    def test_steal_plus_rejects_equipped_weapon(self):
        self.assertEqual(
            self._run(TARGET, 0, item_type=0, steal_plus=True, equipped_slot=0, weight=1, con=8),
            0,
        )

    def test_steal_plus_rejects_heavier_than_con(self):
        self.assertEqual(
            self._run(TARGET, 1, item_type=0, steal_plus=True, equipped_slot=0, weight=10, con=8),
            0,
        )

    def test_steal_plus_staff_skips_weight(self):
        self.assertEqual(
            self._run(TARGET, 1, item_type=4, steal_plus=True, equipped_slot=0, weight=99, con=1),
            1,
        )


if __name__ == "__main__":
    unittest.main()
