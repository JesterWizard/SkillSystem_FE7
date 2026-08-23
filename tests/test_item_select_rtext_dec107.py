"""DEC-107: item-select R-text uses GetItemDescId (0x1722C), not the name ID.

FE7 0x0801722C is GetItemDescId (vanilla loads ItemData+2). Item-select and
stat-screen ItemDescGetter call it for the R help box. The DurabilityBasedItems
hook there used to load +0 (name), so help IDs were names / 0xFFFF.
"""
from __future__ import annotations

import struct
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
HACK = ROOT / "FE7_Hack.gba"
NAMES = (
    ROOT
    / "EngineHacks"
    / "Necessary"
    / "DurabilityBasedItems"
    / "ScrollNames.s"
)

FE7_GET_ITEM_DESC_ID = 0x1722C  # vanilla: ldrh r0, [itemData, #2]
FE7_GET_ITEM_USE_DESC_ID = 0x17244  # vanilla: ldrh r0, [itemData, #4]
JUMP_TO_HACK = bytes((0x00, 0x4B, 0x18, 0x47))

# Item-select / staff / attack / heal pickers (Use-item style windows).
ITEM_SELECT_MENU_DEFS = (0xB95A1C, 0xB95A40, 0xB95A64, 0xB95A88)
VANILLA_MENU_R_PRESS = 0x0804A9D5
VANILLA_ITEM_HELP_BOX = 0x080231B9
FE7_MENU_R_PRESS = 0x4A9D4  # Menu_DefaultRPress
# push {lr}; ldr r1, proc; bl Goto6CPointer
VANILLA_MENU_R_PRESS_BYTES = bytes.fromhex("00b50249b9f7befe")
HELP_BOX_PROC = 0x08B9A8E8

IRON_SWORD = 0x01
IRON_SWORD_NAME = 0x03F3
IRON_SWORD_DESC = 0x0279
SKILL_SCROLL = 0x9F

PAGE = 0x1000


def _map(uc, addr: int, size: int) -> None:
    from unicorn import UcError

    base = addr & ~(PAGE - 1)
    top = (addr + size + PAGE - 1) & ~(PAGE - 1)
    try:
        uc.mem_map(base, max(top - base, PAGE))
    except UcError:
        pass


def _run_thumb_rom(rom: bytes, entry: int, r0: int) -> int:
    from unicorn import Uc, UC_ARCH_ARM, UC_MODE_THUMB
    from unicorn.arm_const import (
        UC_ARM_REG_R0,
        UC_ARM_REG_SP,
        UC_ARM_REG_LR,
        UC_ARM_REG_PC,
    )

    stop = 0x08000000
    uc = Uc(UC_ARCH_ARM, UC_MODE_THUMB)
    rom_size = (len(rom) + PAGE - 1) & ~(PAGE - 1)
    uc.mem_map(0x08000000, rom_size)
    uc.mem_write(0x08000000, rom)
    _map(uc, 0x02000000, 0x40000)
    _map(uc, 0x03000000, 0x8000)
    uc.reg_write(UC_ARM_REG_SP, 0x03007E00)
    uc.reg_write(UC_ARM_REG_LR, stop)
    uc.reg_write(UC_ARM_REG_R0, r0)
    uc.emu_start(entry | 1, stop, timeout=200_000)
    return uc.reg_read(UC_ARM_REG_R0)


def _hook_dest(rom: bytes, off: int) -> int:
    if rom[off : off + 4] != JUMP_TO_HACK:
        raise AssertionError(f"no jumpToHack at 0x{off:05X}")
    return struct.unpack_from("<I", rom, off + 4)[0] & ~1


class ItemSelectRTextSourceTests(unittest.TestCase):
    def test_desc_id_hook_loads_desc_field_not_name(self):
        src = NAMES.read_text(encoding="utf-8")
        body = src.split("GetItemNameIdStringIndex:", 1)[1].split(
            "GetItemDescStringIndex:", 1
        )[0]
        self.assertIn("ldrh r0,[r1,#2]", body)
        self.assertNotIn("ldrh r0,[r1] @r0 = name ID", body)
        self.assertIn("DurabilityBasedItemDescList", body)

    def test_use_desc_hook_loads_use_desc_field(self):
        src = NAMES.read_text(encoding="utf-8")
        body = src.split("GetItemDescStringIndex:", 1)[1]
        self.assertIn("ldrh r0,[r1,#4]", body)


@unittest.skipUnless(HACK.is_file(), "FE7_Hack.gba missing")
class ItemSelectRTextRomTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        try:
            from unicorn import Uc  # noqa: F401
        except ImportError as exc:
            raise unittest.SkipTest(f"unicorn missing: {exc}")
        cls.rom = HACK.read_bytes()  # FE7_Hack.gba

    def test_menu_r_press_routine_still_starts_help_proc(self):
        """VeslyDebugger SET_FUNC MenuAutoHelpBoxSelect @ 0x4A9D4 overwrote
        vanilla Menu_DefaultRPress with a trampoline to `return 0`."""
        self.assertEqual(
            self.rom[FE7_MENU_R_PRESS : FE7_MENU_R_PRESS + 8],
            VANILLA_MENU_R_PRESS_BYTES,
        )
        proc = struct.unpack_from("<I", self.rom, FE7_MENU_R_PRESS + 0xC)[0]
        self.assertEqual(proc, HELP_BOX_PROC)

    def test_item_select_menus_keep_vanilla_r_help(self):
        for off in ITEM_SELECT_MENU_DEFS:
            r_press = struct.unpack_from("<I", self.rom, off + 0x1C)[0]
            help_box = struct.unpack_from("<I", self.rom, off + 0x20)[0]
            self.assertEqual(
                r_press,
                VANILLA_MENU_R_PRESS,
                f"MenuDef 0x{off:X} onRPress",
            )
            self.assertNotEqual(r_press, 0, f"MenuDef 0x{off:X} lost R")
            self.assertNotEqual(help_box, 0, f"MenuDef 0x{off:X} lost help box")

    def test_get_item_desc_id_returns_desc_not_name(self):
        dest = _hook_dest(self.rom, FE7_GET_ITEM_DESC_ID)
        got = _run_thumb_rom(self.rom, dest, IRON_SWORD)
        self.assertEqual(got, IRON_SWORD_DESC)
        self.assertNotEqual(got, IRON_SWORD_NAME)

    def test_skill_scroll_rtext_uses_skill_desc_table(self):
        dest = _hook_dest(self.rom, FE7_GET_ITEM_DESC_ID)
        item = (1 << 8) | SKILL_SCROLL
        got = _run_thumb_rom(self.rom, dest, item)
        self.assertNotEqual(got, 0xFFFF)
        self.assertNotEqual(got, 0)

    def test_use_desc_id_still_loads_offset_4(self):
        dest = _hook_dest(self.rom, FE7_GET_ITEM_USE_DESC_ID)
        got = _run_thumb_rom(self.rom, dest, IRON_SWORD)
        self.assertEqual(got, 0)


if __name__ == "__main__":
    unittest.main()
