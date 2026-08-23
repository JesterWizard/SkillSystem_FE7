"""DEC-109: weapon rank letter must appear after 'increased to' in the popup.

Vanilla gPopup_WRankIncrease at 0xB91BC4 is sound + wtype icon + text 0x750 +
end. text_buildfile rewrote 0x750 to 'Weapon rank increased to', which clips
the letter unless the definition grows a rank-letter component. The vanilla
slot has no room (next popup is at 0xB91BE4), so the NewPopup_WRankIncrease
literal must point at a FreeSpace copy.
"""
from __future__ import annotations

import struct
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))
sys.path.insert(0, str(Path(__file__).resolve().parent))

import built_rom  # noqa: E402
from Tools.thumb_harness import assemble, symbol_offsets  # noqa: E402

SRC = (
    ROOT
    / "EngineHacks"
    / "SkillSystem"
    / "SkillScrolls"
    / "SkillLearnPopup.s"
)

VANILLA_DEF = 0xB91BC4
WRANK_LITERAL = 0xEE48  # ldr pool in NewPopup_WRankIncrease
TID_WRANK = 0x750
POPUP_MSG = 0x06
POPUP_END = 0x00
WRANK_LETTER = 0x10
# FE7 DrawBattlePopup type 0 (anims-on). Width add at 0x6B1FC.
# Hook at 0x6B298 (4-aligned type check) — 0x6B29E makes jumpToHack's POIN unaligned.
ANIMS_WIDTH_ADD = 0x6B1FC
ANIMS_DRAW = 0x6B298
ADD_R4_18 = bytes.fromhex("18 34")
MOV_R2_R8 = bytes.fromhex("42 46")


def u32(data: bytes, off: int) -> int:
    return struct.unpack_from("<I", data, off)[0]


def walk_popup(rom: bytes, off: int, limit: int = 16) -> list[tuple[int, int]]:
    out = []
    for _ in range(limit):
        op = u32(rom, off)
        arg = u32(rom, off + 4)
        out.append((op, arg))
        if op == POPUP_END:
            return out
        off += 8
    return out


class WRankPopupSourceTests(unittest.TestCase):
    def test_event_extends_body_with_letter_component(self):
        text = (
            ROOT
            / "EngineHacks"
            / "SkillSystem"
            / "SkillScrolls"
            / "SkillScrolls.event"
        ).read_text(encoding="utf-8")
        self.assertIn("WeaponRankUpPopup:", text)
        body = text.split("WeaponRankUpPopup:", 1)[1].split("Popup_End", 1)[0]
        self.assertIn("0x750", body)
        self.assertIn("0x10", body)

    def test_letter_table_is_ascii_not_putspecialchar_codes(self):
        # GetDisplayRankStringFromExp returns 0x1D..0x18 (PutSpecialChar).
        # Text_DrawString needs 'E'..'S' or the glyph is blank width.
        try:
            code = assemble(SRC)
        except (FileNotFoundError, OSError) as exc:
            raise unittest.SkipTest(str(exc)) from exc
        off = symbol_offsets(SRC)["WRankLetters"]
        self.assertEqual(code[off : off + 7], b"\x00EDCBAS")

    def test_letter_comes_from_equipped_weapon_rank(self):
        text = SRC.read_text(encoding="utf-8")
        self.assertNotIn("0x0203FE06", text)
        self.assertNotIn("LetterBuf", text)
        self.assertIn("ResolveWRankLetter", text)
        self.assertIn("0x48", text)
        self.assertIn("add r0, #1", text)
        type0 = text.split("DrawBattlePopup_WRank_Type0:", 1)[1]
        self.assertNotIn("0x7E00", type0)
        letter = type0.split("ResolveWRankLetter", 1)[1]
        self.assertIn("mov r1, #0", letter)
        self.assertNotIn("mov r2, #0x20", letter)
        try:
            code = assemble(SRC)
        except (FileNotFoundError, OSError) as exc:
            raise unittest.SkipTest(str(exc)) from exc
        self.assertNotIn((0x0203FE06).to_bytes(4, "little"), code)


class WRankPopupRomTests(unittest.TestCase):
    def test_wrank_popup_includes_letter_after_increased_to(self):
        rom = built_rom.load()
        ptr = u32(rom, WRANK_LITERAL) & 0x01FFFFFF
        self.assertNotEqual(ptr, VANILLA_DEF, "must copy off the vanilla slot")
        ops = walk_popup(rom, ptr)
        self.assertIn((POPUP_MSG, TID_WRANK), ops)
        msg_i = ops.index((POPUP_MSG, TID_WRANK))
        self.assertNotEqual(ops[msg_i + 1][0], POPUP_END)
        self.assertIn((WRANK_LETTER, 0), ops)
        self.assertEqual(ops[-1][0], POPUP_END)

    def test_anims_on_box_reserves_letter_width(self):
        rom = built_rom.load()
        self.assertEqual(rom[ANIMS_WIDTH_ADD : ANIMS_WIDTH_ADD + 2], ADD_R4_18)

    def test_anims_on_draw_is_hooked(self):
        rom = built_rom.load()
        self.assertNotEqual(rom[ANIMS_DRAW : ANIMS_DRAW + 2], MOV_R2_R8)


if __name__ == "__main__":
    unittest.main()
