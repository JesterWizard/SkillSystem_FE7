"""Executes DrawSignedBonusNumber (mss_defs.s) on a real Thumb CPU emulator.

Vanilla DrawStatScreenBonusNumber (FE7 0x08006240) hardcodes a green '+':

    cmp r5,#0 / beq out          @ zero draws nothing
    PutSpecialChar(dest, 4, 21)  @ colour 4 = green, glyph 21 = '+'
    PutUiSmallNumber(dest+2 or +4, 4, value)

Feed it a negative and it prints '+' followed by whatever the unsigned digit
routine makes of a negative -- there is no '-' and no red anywhere in it.
DrawSignedBonusNumber replaces it, so the thing worth proving is which glyph
id and which palette each branch actually passes to those two routines.

Red is not a base text colour: the five colour tables only reach palette bank
0 (white/grey/blue/yellow/green). SetFontRedPalette retargets the active
font's tileref (gActiveFont+0x10) at bank 9, which HP_Name_Color fills from
New_Palettes on every stat screen draw and whose colour 4 is the dark red the
growth display already uses for debuffs. So "is it red" is asserted as "was
the tileref sitting on bank 9 at the moment the glyph was drawn, and was it
put back afterwards".

The two vanilla draw routines are reached through the `blh` trampoline's lone
`.short 0xf800`, which Unicorn cannot decode. Each one is replaced with a NOP
and hooked instead: at that point lr holds the routine the call was about to
enter and r0-r2 hold its arguments, so the hook records the whole call.
"""
import struct
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

MSS_DEFS = ROOT / "EngineHacks/Necessary/ModularStatScreen/pages/signed_bonus_number.s"

try:
    from unicorn import UC_HOOK_CODE
    from unicorn.arm_const import (
        UC_ARM_REG_R0,
        UC_ARM_REG_R1,
        UC_ARM_REG_R2,
        UC_ARM_REG_LR,
    )
    from Tools.thumb_harness import AS, CODE_BASE, Harness, assemble, symbol_offsets
except ImportError as exc:  # unicorn not installed locally
    raise unittest.SkipTest(f"unicorn unavailable: {exc}")

if not AS.is_file():
    raise unittest.SkipTest(f"devkitARM assembler not found at {AS}")

DRAW_SPECIAL_UI_CHAR = 0x0800615C
DRAW_UI_SMALL_NUMBER = 0x08006234
G_ACTIVE_FONT_PTR = 0x02028D70

FONT_ADDR = 0x02020000
BASE_TILEREF = 0x0140
RED_BANK = 9
DEST = 0x02003288  # a stat screen BG0 tilemap slot; never dereferenced here

GREEN = 4
RED_COLOUR = 4
GLYPH_PLUS = 21
GLYPH_MINUS = 20

TRAMPOLINE_CALL = b"\x00\xf8"
NOP = (0x46C0).to_bytes(2, "little")


def _tileref(h) -> int:
    return struct.unpack("<H", h.read(FONT_ADDR + 0x10, 2))[0]


def run_bonus(value: int):
    """Runs DrawSignedBonusNumber(value, DEST).

    Returns (calls, final_tileref) where calls is a list of
    (target, r0, r1, r2, tileref_at_call).
    """
    code = assemble(MSS_DEFS)
    offsets = symbol_offsets(MSS_DEFS)

    call_sites = [
        i for i in range(0, len(code) - 1, 2)
        if code[i:i + 2] == TRAMPOLINE_CALL
    ]
    assert call_sites, "no `.short 0xf800` trampoline found in mss_defs.s helpers"
    patched = bytearray(code)
    for site in call_sites:
        patched[site:site + 2] = NOP

    h = Harness(bytes(patched))
    # Harness patches the first trampoline itself; re-write the bytes we want.
    h.uc.mem_write(CODE_BASE, bytes(patched))

    h.seed(G_ACTIVE_FONT_PTR, struct.pack("<I", FONT_ADDR))
    h.seed(FONT_ADDR + 0x10, struct.pack("<H", BASE_TILEREF))
    h.seed(DEST, bytes(4))  # shift reads the tileref DrawSpecialUiChar would write

    calls = []

    def on_call(uc, address, size, _user):
        calls.append((
            uc.reg_read(UC_ARM_REG_LR) & ~1,
            uc.reg_read(UC_ARM_REG_R0),
            uc.reg_read(UC_ARM_REG_R1),
            uc.reg_read(UC_ARM_REG_R2),
            _tileref(h),
        ))

    for site in call_sites:
        addr = CODE_BASE + site
        h.uc.hook_add(UC_HOOK_CODE, on_call, begin=addr, end=addr)

    h.run(
        offsets["SBN_End"],
        regs={"r0": value & 0xFFFFFFFF, "r1": DEST},
        entry_offset=offsets["DrawSignedBonusNumber"],
    )
    return calls, _tileref(h)


class SignedBonusNumberExecutionTests(unittest.TestCase):
    def test_positive_bonus_draws_green_plus_and_value(self):
        calls, tileref = run_bonus(5)
        self.assertEqual(len(calls), 2, calls)

        target, r0, r1, r2, at_call = calls[0]
        self.assertEqual(target, DRAW_SPECIAL_UI_CHAR)
        self.assertEqual(r0, DEST)
        self.assertEqual(r1, GREEN)
        self.assertEqual(r2, GLYPH_PLUS)
        self.assertEqual(at_call, BASE_TILEREF, "positives must stay on the base palette bank")

        target, r0, r1, r2, at_call = calls[1]
        self.assertEqual(target, DRAW_UI_SMALL_NUMBER)
        self.assertEqual(r0, DEST + 2)
        self.assertEqual(r1, GREEN)
        self.assertEqual(r2, 5)
        self.assertEqual(tileref, BASE_TILEREF)

    def test_negative_bonus_draws_red_minus_and_magnitude(self):
        calls, tileref = run_bonus(-5)
        self.assertEqual(len(calls), 2, calls)

        target, r0, r1, r2, at_call = calls[0]
        self.assertEqual(target, DRAW_SPECIAL_UI_CHAR)
        self.assertEqual(r0, DEST)
        self.assertEqual(r2, GLYPH_MINUS, "a negative bonus must draw '-' , not '+'")
        self.assertEqual(r1, RED_COLOUR)
        self.assertEqual(at_call >> 12, RED_BANK, "glyph must be drawn from the red palette bank")

        target, r0, r1, r2, at_call = calls[1]
        self.assertEqual(target, DRAW_UI_SMALL_NUMBER)
        self.assertEqual(r0, DEST + 2)
        self.assertEqual(r1, RED_COLOUR)
        self.assertEqual(r2, 5, "the magnitude is drawn, not the two's-complement value")
        self.assertEqual(at_call >> 12, RED_BANK)

        self.assertEqual(tileref, BASE_TILEREF, "the font tileref must be restored afterwards")

    def test_fortress_defense_str_penalty_draws_red_minus_three(self):
        # Reported case: Fortress Defense -3 Str showed as a green '+7'
        # because vanilla DrawUiSmallNumber uses signed remainder of -3 / 10.
        calls, tileref = run_bonus(-3)
        self.assertEqual(calls[0][3], GLYPH_MINUS)
        self.assertEqual(calls[0][4] >> 12, RED_BANK)
        self.assertEqual(calls[1][3], 3)
        self.assertEqual(calls[1][4] >> 12, RED_BANK)
        self.assertEqual(tileref, BASE_TILEREF)

    def test_zero_bonus_draws_nothing(self):
        calls, tileref = run_bonus(0)
        self.assertEqual(calls, [])
        self.assertEqual(tileref, BASE_TILEREF)

    def test_two_digit_bonuses_shift_the_digits_right(self):
        # Vanilla draws from dest+2 for a single digit and dest+4 for two, so
        # the digits end flush against the '+'/'-' either way.
        for value, expected_sign, expected_digits in (
            (12, GLYPH_PLUS, 12),
            (-12, GLYPH_MINUS, 12),
        ):
            with self.subTest(value=value):
                calls, _ = run_bonus(value)
                self.assertEqual(len(calls), 2, calls)
                self.assertEqual(calls[0][3], expected_sign)
                self.assertEqual(calls[1][1], DEST + 4)
                self.assertEqual(calls[1][3], expected_digits)

    def test_boundary_between_one_and_two_digit_placement(self):
        for value, expected_dest in ((9, DEST + 2), (10, DEST + 4),
                                     (-9, DEST + 2), (-10, DEST + 4)):
            with self.subTest(value=value):
                calls, _ = run_bonus(value)
                self.assertEqual(calls[1][1], expected_dest)

    def test_minus_glyph_vram_is_shifted_down_four_pixels(self):
        # DrawSpecialUiChar writes 8x16 (dest and dest+0x40). Glyph 20's bar
        # sits in the top 8px; small digits sit lower. Shift the two VRAM tiles
        # down 4px, and do it only once if the cached glyph is reused.
        code = assemble(MSS_DEFS)
        offsets = symbol_offsets(MSS_DEFS)
        h = Harness(code)
        tile = BASE_TILEREF
        vram = 0x06000000 + (tile & 0x3FF) * 32
        marker = bytes([0x11, 0x22, 0x33, 0x44])
        h.seed(DEST, struct.pack("<H", tile))
        h.seed(vram, marker + bytes(28) + bytes(32))  # row 0 of top tile

        def run_shift():
            h.run(
                offsets["SBN_ShiftDone"],
                regs={"r4": DEST},
                entry_offset=offsets["SBN_ShiftMinusDown4"],
            )

        run_shift()
        self.assertEqual(h.read(vram, 4), b"\x00\x00\x00\x00")
        self.assertEqual(h.read(vram + 16, 4), marker, "row 0 must land on row 4")

        run_shift()
        self.assertEqual(h.read(vram + 16, 4), marker, "a second call must not shift again")


if __name__ == "__main__":
    unittest.main()
