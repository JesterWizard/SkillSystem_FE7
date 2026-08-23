"""DEC-106: item-select menus draw vanilla uses except durability-list items.

DrawItemMenuLine (Menu A @ 0x164C8) keeps the item in r6 and the color flag
in r8. Skipping uses must key off the item, or a color byte that happens to
match SkillScroll hides uses on every normal line.
"""
from __future__ import annotations

import struct
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
HACK = ROOT / "FE7_Hack.gba"

FE7_GET_ITEM_USES = 0x17294
FE7_MENU_A_USES = 0x164C8
FE7_MENU_B_USES = 0x16570
FE7_STATSCREEN_USES = 0x166B0
JUMP_TO_HACK = bytes((0x00, 0x4B, 0x18, 0x47))

MENU_A_DRAW_USES = 0x080164D0
MENU_A_SKIP_USES = 0x080164E8
MENU_B_DRAW_USES = 0x08016578
MENU_B_SKIP_USES = 0x080165B4
STAT_DRAW_SLASH = 0x080166B8
STAT_SKIP_USES = 0x080166FE

IRON_SWORD = 0x2E01  # id 0x01, 46 uses
SKILL_SCROLL = 0x059F  # id 0x9F, durability = skill id 5
PAGE = 0x1000


def _hook_dest(rom: bytes, off: int) -> int:
    if rom[off : off + 4] != JUMP_TO_HACK:
        raise AssertionError(f"no jumpToHack at 0x{off:05X}")
    return struct.unpack_from("<I", rom, off + 4)[0] & ~1


def _map(uc, addr: int, size: int) -> None:
    from unicorn import UcError

    base = addr & ~(PAGE - 1)
    top = (addr + size + PAGE - 1) & ~(PAGE - 1)
    try:
        uc.mem_map(base, max(top - base, PAGE))
    except UcError:
        pass


def _run_uses(rom: bytes, item: int) -> int:
    from unicorn import Uc, UC_ARCH_ARM, UC_MODE_THUMB
    from unicorn.arm_const import UC_ARM_REG_R0, UC_ARM_REG_SP, UC_ARM_REG_LR

    dest = _hook_dest(rom, FE7_GET_ITEM_USES)
    stop = 0x08000000
    uc = Uc(UC_ARCH_ARM, UC_MODE_THUMB)
    rom_size = (len(rom) + PAGE - 1) & ~(PAGE - 1)
    uc.mem_map(0x08000000, rom_size)
    uc.mem_write(0x08000000, rom)
    _map(uc, 0x02000000, 0x40000)
    _map(uc, 0x03000000, 0x8000)
    uc.reg_write(UC_ARM_REG_SP, 0x03007E00)
    uc.reg_write(UC_ARM_REG_LR, stop)
    uc.reg_write(UC_ARM_REG_R0, item)
    uc.emu_start(dest | 1, stop, timeout=200_000)
    return uc.reg_read(UC_ARM_REG_R0)


def _run_until(rom: bytes, entry: int, regs: dict[str, int], stops: set[int]) -> int:
    from unicorn import Uc, UC_ARCH_ARM, UC_MODE_THUMB, UC_HOOK_CODE
    from unicorn.arm_const import (
        UC_ARM_REG_R0,
        UC_ARM_REG_R4,
        UC_ARM_REG_R5,
        UC_ARM_REG_R6,
        UC_ARM_REG_R7,
        UC_ARM_REG_R8,
        UC_ARM_REG_R9,
        UC_ARM_REG_SP,
        UC_ARM_REG_LR,
        UC_ARM_REG_PC,
    )

    names = {
        "r0": UC_ARM_REG_R0,
        "r4": UC_ARM_REG_R4,
        "r5": UC_ARM_REG_R5,
        "r6": UC_ARM_REG_R6,
        "r7": UC_ARM_REG_R7,
        "r8": UC_ARM_REG_R8,
        "r9": UC_ARM_REG_R9,
    }
    stop = 0x08FFFFFE
    uc = Uc(UC_ARCH_ARM, UC_MODE_THUMB)
    rom_size = (len(rom) + PAGE - 1) & ~(PAGE - 1)
    uc.mem_map(0x08000000, rom_size)
    uc.mem_write(0x08000000, rom)
    _map(uc, 0x02000000, 0x40000)
    _map(uc, 0x03000000, 0x8000)
    uc.reg_write(UC_ARM_REG_SP, 0x03007E00)
    uc.reg_write(UC_ARM_REG_LR, stop | 1)
    for name, value in regs.items():
        uc.reg_write(names[name], value)

    def on_code(uc, addr, size, _data):
        if addr in stops:
            uc.emu_stop()

    uc.hook_add(UC_HOOK_CODE, on_code)
    uc.emu_start(entry | 1, stop, timeout=200_000, count=200)
    return uc.reg_read(UC_ARM_REG_PC) & ~1


@unittest.skipUnless(HACK.is_file(), "FE7_Hack.gba missing")
class ItemSelectUsesRomTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        try:
            from unicorn import Uc  # noqa: F401
        except ImportError as exc:
            raise unittest.SkipTest(f"unicorn missing: {exc}")
        cls.rom = HACK.read_bytes()  # FE7_Hack.gba

    def _menu_a(self, item: int, color: int) -> int:
        dest = _hook_dest(self.rom, FE7_MENU_A_USES)
        return _run_until(
            self.rom,
            dest,
            {"r6": item, "r8": color},
            {MENU_A_DRAW_USES, MENU_A_SKIP_USES},
        )

    def _menu_b(self, item: int) -> int:
        dest = _hook_dest(self.rom, FE7_MENU_B_USES)
        return _run_until(
            self.rom,
            dest,
            {"r8": item, "r5": 0x03007000},
            {MENU_B_DRAW_USES, MENU_B_SKIP_USES},
        )

    def test_menu_a_skill_scroll_skips_uses(self):
        self.assertEqual(self._menu_a(SKILL_SCROLL, 0), MENU_A_SKIP_USES)

    def test_menu_a_iron_sword_draws_uses(self):
        self.assertEqual(self._menu_a(IRON_SWORD, 1), MENU_A_DRAW_USES)

    def test_menu_a_color_matching_scroll_id_still_draws_uses(self):
        self.assertEqual(self._menu_a(IRON_SWORD, 0x9F), MENU_A_DRAW_USES)

    def test_menu_b_iron_sword_draws_uses(self):
        self.assertEqual(self._menu_b(IRON_SWORD), MENU_B_DRAW_USES)

    def test_menu_b_skill_scroll_skips_uses(self):
        self.assertEqual(self._menu_b(SKILL_SCROLL), MENU_B_SKIP_USES)

    def test_get_item_uses_returns_halfword_for_iron_sword(self):
        self.assertEqual(_run_uses(self.rom, IRON_SWORD), 0x2E)

    def test_get_item_uses_hides_skill_id_on_scroll(self):
        got = _run_uses(self.rom, SKILL_SCROLL)
        self.assertEqual(got, 1)
        self.assertNotEqual(got, 5)

    def test_stat_screen_scroll_skips_uses(self):
        dest = _hook_dest(self.rom, FE7_STATSCREEN_USES)
        pc = _run_until(
            self.rom,
            dest,
            {"r9": SKILL_SCROLL, "r6": 1, "r7": 0x0203A000},
            {STAT_DRAW_SLASH, STAT_SKIP_USES},
        )
        self.assertEqual(pc, STAT_SKIP_USES)

    def test_stat_screen_iron_sword_draws_slash(self):
        dest = _hook_dest(self.rom, FE7_STATSCREEN_USES)
        pc = _run_until(
            self.rom,
            dest,
            {"r9": IRON_SWORD, "r6": 1, "r7": 0x0203A000},
            {STAT_DRAW_SLASH, STAT_SKIP_USES},
        )
        self.assertEqual(pc, STAT_DRAW_SLASH)


if __name__ == "__main__":
    unittest.main()
