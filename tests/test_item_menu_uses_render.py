"""Item-menu draw routines must reach DrawNumber with vanilla-identical args.

The DEC-106 tests only check *which* branch the durability hooks take. They stop
at the resume point, so they cannot see that the hook corrupted a register the
vanilla draw code still needs. Three such bugs shipped past them:

  * jumpToHack is "ldr r3,[pc,#0]; bx r3", so it destroys r3. At the Menu A
    hook (0x164C8) r3 is live - it holds the uses-number destination r7+22 that
    vanilla reads at 0x164DE. The uses count was written to a ROM address, so
    no number appeared in the on-map item menu.
  * The Menu B hook used r1 as a scratch mask, but r1 already held the number
    colour (set 0x16564..0x1656A, read at 0x1657E).
  * NewItemNameGetter4's vanilla resume (0x80165F9) pointed at the jumpToHack
    literal word rather than at code.

DrawNumber (0x80061E4) blanks the tile when r2 < 0 or r2 == 0xFF, so a wrong
register here is invisible on screen rather than a crash. Compare the whole
(dest, colour, value) triple against FE7_clean.gba for a normal breakable item.
"""
from __future__ import annotations

import struct
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
HACK = ROOT / "FE7_Hack.gba"
CLEAN = ROOT / "FE7_clean.gba"

DRAW_NUMBER = 0x080061E4
STOP = 0x08FFFFFE
PAGE = 0x1000

# Leaf routines the draw functions call; stubbed with `bx lr` so emulation stays
# inside the code under test instead of wandering into text/VRAM engines.
STUBS = (
    0x8005588, 0x8012C60, 0x8012F14, 0x8005718, 0x8005590, 0x8004E28,
    0x800615C, 0x80054E0, 0x8005580, 0x8005574, 0x8005584, 0x80063AC, 0x80061D8,
)

IRON_SWORD = 0x2E01  # id 0x01, 46 uses -- breakable, not on DurabilityItemList
DEST = 0x02010000

# entry, seed registers. Params follow the vanilla prologues at each address.
ROUTINES = {
    "MenuA_DrawItemMenuLine": (0x8016470, {"r0": 0x02020000, "r1": IRON_SWORD, "r2": 0, "r3": DEST}),
    "MenuB_DrawItemMenuLineLong": (0x801650C, {"r0": 0x02020000, "r1": IRON_SWORD, "r2": 0, "r3": DEST}),
    "MenuC_DrawItemMenuLineNoColor": (0x80165DC, {"r0": 0x02020000, "r1": IRON_SWORD, "r2": DEST}),
    "StatScreen_DrawItemOnStatscreen": (0x8016668, {"r0": 0x02020000, "r1": IRON_SWORD, "r2": 1, "r3": DEST}),
}


def _draw_number_calls(rom: bytes, entry: int, regs: dict[str, int]):
    """Run one draw routine, returning every (dest, colour, value) it passes to DrawNumber."""
    from unicorn import Uc, UcError, UC_ARCH_ARM, UC_MODE_THUMB, UC_HOOK_CODE
    from unicorn.arm_const import (
        UC_ARM_REG_R0, UC_ARM_REG_R1, UC_ARM_REG_R2, UC_ARM_REG_R3,
        UC_ARM_REG_SP, UC_ARM_REG_LR, UC_ARM_REG_PC,
    )

    uc = Uc(UC_ARCH_ARM, UC_MODE_THUMB)
    uc.mem_map(0x08000000, (len(rom) + PAGE - 1) & ~(PAGE - 1))
    uc.mem_write(0x08000000, rom)
    for base, size in ((0x02000000, 0x40000), (0x03000000, 0x8000), (0x04000000, 0x10000),
                       (0x05000000, 0x1000), (0x06000000, 0x20000), (0x07000000, 0x1000)):
        uc.mem_map(base, size)
    for addr in STUBS:
        uc.mem_write(addr, b"\x70\x47")
    uc.mem_write(DRAW_NUMBER, b"\x70\x47")

    uc.reg_write(UC_ARM_REG_SP, 0x03007E00)
    uc.reg_write(UC_ARM_REG_LR, STOP | 1)
    ids = {"r0": UC_ARM_REG_R0, "r1": UC_ARM_REG_R1, "r2": UC_ARM_REG_R2, "r3": UC_ARM_REG_R3}
    for name, value in regs.items():
        uc.reg_write(ids[name], value)

    calls = []

    def on_code(uc, addr, size, _data):
        if addr == DRAW_NUMBER:
            raw = uc.reg_read(UC_ARM_REG_R2)
            calls.append((
                uc.reg_read(UC_ARM_REG_R0),
                uc.reg_read(UC_ARM_REG_R1),
                struct.unpack("<i", struct.pack("<I", raw))[0],
            ))

    uc.hook_add(UC_HOOK_CODE, on_code)
    try:
        uc.emu_start(entry | 1, STOP, timeout=500_000, count=100_000)
    except UcError as exc:
        raise AssertionError(
            f"emulation faulted at pc=0x{uc.reg_read(UC_ARM_REG_PC):08X}: {exc}"
        ) from exc
    return calls


@unittest.skipUnless(HACK.is_file(), "FE7_Hack.gba missing")
@unittest.skipUnless(CLEAN.is_file(), "FE7_clean.gba missing")
class ItemMenuUsesRenderTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        try:
            from unicorn import Uc  # noqa: F401
        except ImportError as exc:
            raise unittest.SkipTest(f"unicorn missing: {exc}")
        cls.hack = HACK.read_bytes()  # FE7_Hack.gba
        cls.clean = CLEAN.read_bytes()

    def _compare(self, name: str) -> list:
        entry, regs = ROUTINES[name]
        want = _draw_number_calls(self.clean, entry, regs)
        got = _draw_number_calls(self.hack, entry, regs)
        self.assertTrue(want, f"{name}: vanilla drew no number; bad test setup")
        self.assertEqual(got, want, f"{name}: durability hooks changed a normal item's uses draw")
        return got

    def test_menu_a_matches_vanilla(self):
        self._compare("MenuA_DrawItemMenuLine")

    def test_menu_b_matches_vanilla(self):
        self._compare("MenuB_DrawItemMenuLineLong")

    def test_menu_c_matches_vanilla(self):
        self._compare("MenuC_DrawItemMenuLineNoColor")

    def test_stat_screen_matches_vanilla(self):
        self._compare("StatScreen_DrawItemOnStatscreen")

    def test_menu_a_uses_go_to_the_tilemap_not_rom(self):
        """The reported bug: r3 clobbered by jumpToHack sent uses to a ROM address."""
        (dest, _colour, value), = self._compare("MenuA_DrawItemMenuLine")
        self.assertEqual(value, 46, "Iron Sword should draw 46 uses")
        self.assertEqual(dest, DEST + 22, f"uses drawn to 0x{dest:08X}, not the tilemap")
        self.assertLess(dest, 0x08000000, "uses destination must not be in ROM")

    def test_menu_b_uses_keep_the_vanilla_colour(self):
        """r1 held the number colour; the hook had been using it as a scratch mask."""
        first, _second = self._compare("MenuB_DrawItemMenuLineLong")
        self.assertEqual(first[1], 1, "uses number drawn with the wrong palette")

    def test_no_draw_routine_executes_a_jumptohack_literal(self):
        """NewItemNameGetter4 resumed at 0x165F8, which holds the hook's pointer word."""
        for name in ROUTINES:
            with self.subTest(routine=name):
                entry, regs = ROUTINES[name]
                _draw_number_calls(self.hack, entry, regs)  # raises on a fault


if __name__ == "__main__":
    unittest.main()
