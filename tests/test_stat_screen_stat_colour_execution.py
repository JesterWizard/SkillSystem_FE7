"""Executes the draw_str_number_at expansion from mss_defs.s on a real Thumb CPU.

draw_stat_number_at compares the getter total (all modifiers: equip, rally,
Defiant, debuffs) against the raw base stat byte on the unit and picks the
colour the number is redrawn in. Three outcomes, and source review cannot tell
them apart because they differ only by which branch is taken:

    total > base -> green (colour 4, base palette bank)
    total < base -> red   (colour 4, palette bank 9 -- see the module docstring
                           in test_stat_screen_signed_bonus_execution.py)
    total == base -> blue (colour 2, base palette bank)

The old macro compared with beq/bne, so *any* difference came out green -- a
debuffed stat was indistinguishable from a boosted one. Both sides of the new
comparison are asserted here, plus the equal case.

The test assembles a small wrapper that expands the real macro, then patches
the two `blh` trampolines the way Tools/thumb_harness already does: the stat
getter's call becomes `movs r0, #total` (its only visible effect) and
DrawDecNumber's becomes a NOP that is hooked, so the colour in r1 and the
number in r2 can be read at the moment of the call.
"""
import struct
import sys
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

PAGES = ROOT / "EngineHacks/Necessary/ModularStatScreen/pages"

try:
    from unicorn import UC_HOOK_CODE
    from unicorn.arm_const import UC_ARM_REG_R1, UC_ARM_REG_R2
    from Tools.thumb_harness import AS, CODE_BASE, Harness, assemble, symbol_offsets
except ImportError as exc:  # unicorn not installed locally
    raise unittest.SkipTest(f"unicorn unavailable: {exc}")

if not AS.is_file():
    raise unittest.SkipTest(f"devkitARM assembler not found at {AS}")

G_ACTIVE_FONT_PTR = 0x02028D70
FONT_ADDR = 0x02020000
BASE_TILEREF = 0x0140
RED_BANK = 9

UNIT_ADDR = 0x0202BE4C
CLASS_ADDR = 0x0202C000
CHARACTER_ADDR = 0x0202C100
STR_OFFSET = 0x14
CLASS_MOV_OFFSET = 0x12
CLASS_CON_OFFSET = 0x11
UNIT_MOV_BONUS = 0x1D
UNIT_CON_BONUS = 0x1A
CHARACTER_CON_OFFSET = 0x13

GREEN = 4
BLUE = 2
RED_COLOUR = 4

TRAMPOLINE_CALL = b"\x00\xf8"
NOP = (0x46C0).to_bytes(2, "little")

# Wrapper mirrors page_start/page_end's frame: the macro parks the saved font
# tileref at [sp,#0x20], which only exists inside that 0x50-byte frame.
WRAPPER = """
.thumb
.include "mss_defs.s"

.global TestStrNumber
.type TestStrNumber, %function
TestStrNumber:
  push    {r4-r7, lr}
  mov     r7, r8
  push    {r7}
  add     sp, #-0x50
  mov     r8, r0
  draw_STAT_number_at 16, 3
TestStrNumberEnd:
  add     sp, #0x50
  pop     {r7}
  mov     r8, r7
  pop     {r4-r7}
  pop     {r0}
  bx      r0
.ltorg
"""


def _run_wrapper(stat: str, getter_total, seeds):
    """Assembles a wrapper around draw_<stat>_number_at, patches its trampolines
    and runs it. getter_total is None for the macros that read the bonus byte
    straight off the unit instead of calling a getter.

    Returns (colour, number_drawn, tileref_at_draw, tileref_after).
    """
    with tempfile.TemporaryDirectory() as tmp:
        src = Path(tmp) / "stat_colour_wrapper.s"
        src.write_text(WRAPPER.replace("STAT", stat), encoding="utf-8")
        code = assemble(src, include_dirs=[PAGES])
        offsets = symbol_offsets(src, include_dirs=[PAGES])

    start = offsets["TestStrNumber"]
    end = offsets["TestStrNumberEnd"]
    sites = [
        i for i in range(start, end - 1, 2)
        if code[i:i + 2] == TRAMPOLINE_CALL
    ]
    expected = 2 if getter_total is not None else 1
    assert len(sites) == expected, f"unexpected trampoline layout: {sites}"
    draw_site = sites[-1]

    patched = bytearray(code)
    if getter_total is not None:
        patched[sites[0]:sites[0] + 2] = (0x2000 | (getter_total & 0xFF)).to_bytes(2, "little")
    patched[draw_site:draw_site + 2] = NOP

    h = Harness(bytes(patched))
    h.uc.mem_write(CODE_BASE, bytes(patched))  # keep our patch, not the harness's

    h.seed(G_ACTIVE_FONT_PTR, struct.pack("<I", FONT_ADDR))
    h.seed(FONT_ADDR + 0x10, struct.pack("<H", BASE_TILEREF))
    for addr, data in seeds:
        h.seed(addr, data)

    seen = {}

    def on_draw(uc, address, size, _user):
        seen["colour"] = uc.reg_read(UC_ARM_REG_R1)
        seen["number"] = uc.reg_read(UC_ARM_REG_R2)
        seen["tileref"] = struct.unpack("<H", h.read(FONT_ADDR + 0x10, 2))[0]

    addr = CODE_BASE + draw_site
    h.uc.hook_add(UC_HOOK_CODE, on_draw, begin=addr, end=addr)

    h.run(end, regs={"r0": UNIT_ADDR}, entry_offset=start)
    after = struct.unpack("<H", h.read(FONT_ADDR + 0x10, 2))[0]
    assert seen, "DrawDecNumber was never reached"
    return seen["colour"], seen["number"], seen["tileref"], after


def run_str_number(total: int, base: int):
    return _run_wrapper("str", total, [(UNIT_ADDR + STR_OFFSET, struct.pack("<b", base))])


def run_move_number(class_move: int, bonus: int):
    return _run_wrapper("move", None, [
        (UNIT_ADDR + 0x4, struct.pack("<I", CLASS_ADDR)),
        (CLASS_ADDR + CLASS_MOV_OFFSET, struct.pack("<b", class_move)),
        (UNIT_ADDR + UNIT_MOV_BONUS, struct.pack("<b", bonus)),
    ])


def run_con_number(class_con: int, bonus: int):
    return _run_wrapper("con", None, [
        (UNIT_ADDR, struct.pack("<I", CHARACTER_ADDR)),
        (UNIT_ADDR + 0x4, struct.pack("<I", CLASS_ADDR)),
        (CHARACTER_ADDR + CHARACTER_CON_OFFSET, struct.pack("<b", 0)),
        (CLASS_ADDR + CLASS_CON_OFFSET, struct.pack("<b", class_con)),
        (UNIT_ADDR + UNIT_CON_BONUS, struct.pack("<b", bonus)),
    ])


class StatColourExecutionTests(unittest.TestCase):
    def test_boosted_stat_draws_green_on_the_base_palette(self):
        colour, number, at_draw, after = run_str_number(total=12, base=10)
        self.assertEqual(colour, GREEN)
        self.assertEqual(number, 12, "the total is drawn, not the base or the delta")
        self.assertEqual(at_draw, BASE_TILEREF)
        self.assertEqual(after, BASE_TILEREF)

    def test_debuffed_stat_draws_from_the_red_palette_bank(self):
        colour, number, at_draw, after = run_str_number(total=8, base=10)
        self.assertEqual(colour, RED_COLOUR)
        self.assertEqual(number, 8)
        self.assertEqual(at_draw >> 12, RED_BANK,
                         "a stat below base must be drawn from the red bank, not green")
        self.assertEqual(after, BASE_TILEREF,
                         "the font tileref must be restored, or every later draw goes red")

    def test_unmodified_stat_draws_blue(self):
        colour, number, at_draw, after = run_str_number(total=10, base=10)
        self.assertEqual(colour, BLUE)
        self.assertEqual(number, 10)
        self.assertEqual(at_draw, BASE_TILEREF)
        self.assertEqual(after, BASE_TILEREF)

    def test_one_point_either_side_of_the_base(self):
        # The boundary itself and one step each way -- the whole macro is a
        # three-way compare, so off-by-one on either branch is the failure mode.
        self.assertEqual(run_str_number(total=11, base=10)[0], GREEN)
        self.assertEqual(run_str_number(total=10, base=10)[0], BLUE)
        self.assertEqual(run_str_number(total=9, base=10)[2] >> 12, RED_BANK)

    def test_zero_base_stat_still_distinguishes_boost_from_flat(self):
        self.assertEqual(run_str_number(total=0, base=0)[0], BLUE)
        self.assertEqual(run_str_number(total=1, base=0)[0], GREEN)


class MoveAndConColourExecutionTests(unittest.TestCase):
    """MOV and CON compare their bonus byte against zero rather than calling a
    getter, so they need their own three-way check. Both were dead code until
    draw_number_at learned colour=-1, and both coloured a debuff green after
    that."""

    def test_move_bonus_sign_picks_the_colour(self):
        colour, number, at_draw, after = run_move_number(class_move=6, bonus=2)
        self.assertEqual((colour, number, at_draw), (GREEN, 8, BASE_TILEREF))

        colour, number, at_draw, after = run_move_number(class_move=6, bonus=0)
        self.assertEqual((colour, number, at_draw), (BLUE, 6, BASE_TILEREF))

        colour, number, at_draw, after = run_move_number(class_move=6, bonus=-2)
        self.assertEqual(colour, RED_COLOUR)
        self.assertEqual(number, 4, "the debuffed total is drawn, not the bonus")
        self.assertEqual(at_draw >> 12, RED_BANK)
        self.assertEqual(after, BASE_TILEREF)

    def test_con_bonus_sign_picks_the_colour(self):
        colour, number, at_draw, after = run_con_number(class_con=9, bonus=3)
        self.assertEqual((colour, number, at_draw), (GREEN, 12, BASE_TILEREF))

        colour, number, at_draw, after = run_con_number(class_con=9, bonus=0)
        self.assertEqual((colour, number, at_draw), (BLUE, 9, BASE_TILEREF))

        colour, number, at_draw, after = run_con_number(class_con=9, bonus=-3)
        self.assertEqual(colour, RED_COLOUR)
        self.assertEqual(number, 6)
        self.assertEqual(at_draw >> 12, RED_BANK)
        self.assertEqual(after, BASE_TILEREF)


if __name__ == "__main__":
    unittest.main()
