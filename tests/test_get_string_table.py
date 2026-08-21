"""
Regression checks for FE7 GetStringFromIndex.

Title-start black screens happen when the live text table is FE8's
(or too short, or the function's literal pool is clobbered). These
tests read the built ROM the same way the game does.
"""
import struct
import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from lyn_bytes import lyn_to_bytes

ROOT = Path(__file__).resolve().parents[1]
CLEAN_ROM = ROOT / "FE7_clean.gba"
HACK_ROM = ROOT / "FE7_Hack.gba"

VANILLA_TABLE_FILE_OFF = 0xB808AC
GET_STRING_TABLE_LITERAL = 0x12C88
GET_STRING_LAST_ID_LITERAL = 0x12C84
GET_STRING_BUFFER_LITERAL = 0x12C8C
HELPER_TABLE_LITERAL = 0x12CB8
LEFT_PAGE_HOOK = 0x7FA8C
AFFINITY_GETTER = 0x08026B24
GET_SKILLS_LYN = ROOT / "EngineHacks" / "SkillSystem" / "Internals" / "asm" / "GetSkills.lyn.event"
PAGE1_LYN = (
    ROOT
    / "EngineHacks"
    / "Necessary"
    / "ModularStatScreen"
    / "pages"
    / "mss_page1_skills.lyn.event"
)
LEFT_LYN = (
    ROOT
    / "EngineHacks"
    / "Necessary"
    / "ModularStatScreen"
    / "pages"
    / "mss_leftstatscreen.lyn.event"
)
PAGE2_LYN = (
    ROOT
    / "EngineHacks"
    / "Necessary"
    / "ModularStatScreen"
    / "pages"
    / "mss_page2_original.lyn.event"
)
PAGE3_LYN = (
    ROOT
    / "EngineHacks"
    / "Necessary"
    / "ModularStatScreen"
    / "pages"
    / "mss_page3_original.lyn.event"
)

TID_STR = 0x10F8
TID_SKILLS = 0xF45
TID_AFFIN = 0xF64
STRING_EXPANDER = 0x4364

GBA_ROM_BASE = 0x08000000


def u32(data: bytes, off: int) -> int:
    return struct.unpack_from("<I", data, off)[0]


def gba_to_file(ptr: int) -> int:
    return ptr & 0x01FFFFFF


def is_rom_ptr(ptr: int) -> bool:
    body = ptr & 0x7FFFFFFF
    return 0x08000000 <= body < 0x0A000000


def read_event_text(path: Path) -> str:
    raw = path.read_bytes()
    if raw.startswith(b"\xff\xfe") or raw[:2] == b"A\x00":
        return raw.decode("utf-16-le")
    if raw.startswith(b"\xfe\xff"):
        return raw.decode("utf-16-be")
    return raw.decode("utf-8")


class GetStringTableTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        if not CLEAN_ROM.is_file():
            raise unittest.SkipTest(f"missing {CLEAN_ROM.name}")
        if not HACK_ROM.is_file():
            raise unittest.SkipTest(f"missing {HACK_ROM.name}")
        cls.clean = CLEAN_ROM.read_bytes()
        cls.hack = HACK_ROM.read_bytes()

    def live_table_off(self) -> int:
        ptr = u32(self.hack, GET_STRING_TABLE_LITERAL)
        self.assertTrue(is_rom_ptr(ptr), f"12C88 is not a ROM pointer: {ptr:08X}")
        off = gba_to_file(ptr)
        self.assertLess(off + 4, len(self.hack), "text table pointer is past the ROM")
        return off

    def table_entry(self, rom: bytes, table_off: int, text_id: int) -> int:
        return u32(rom, table_off + 4 * text_id)

    def test_vanilla_text_id_0_matches_clean_fe7(self):
        """Chapter boot reads low text IDs; FE8 table pointers Huffman-decode as garbage and hang."""
        live = self.table_entry(self.hack, self.live_table_off(), 0)
        vanilla = self.table_entry(self.clean, VANILLA_TABLE_FILE_OFF, 0)
        self.assertEqual(
            live & 0x7FFFFFFF,
            vanilla & 0x7FFFFFFF,
            f"text ID 0 is {live:08X}, clean FE7 is {vanilla:08X}",
        )

    def test_str_label_matches_clean_fe7(self):
        """Stat-screen Str (0x10F8) is past FE8's table length; the FE7 table must be that long."""
        live = self.table_entry(self.hack, self.live_table_off(), TID_STR)
        vanilla = self.table_entry(self.clean, VANILLA_TABLE_FILE_OFF, TID_STR)
        self.assertTrue(is_rom_ptr(live), f"Str text pointer {live:08X} is not in ROM")
        self.assertEqual(live & 0x7FFFFFFF, vanilla & 0x7FFFFFFF)

    def anti_huffman_payload(self, text_id: int, maxlen: int = 64) -> bytes:
        live = self.table_entry(self.hack, self.live_table_off(), text_id)
        self.assertEqual(live & 0x80000000, 0x80000000, f"text 0x{text_id:X} must be anti-Huffman")
        off = gba_to_file(live)
        end = self.hack.find(b"\x00", off, off + maxlen)
        self.assertNotEqual(end, -1, f"text 0x{text_id:X} is not null-terminated")
        self.assertGreater(end - off, 0, f"text 0x{text_id:X} is empty")
        return self.hack[off : end + 1]

    def test_skills_string_is_anti_huffman_skills(self):
        """Stat-screen Skills label is setText (anti-Huffman). Wording may use NarrowFont codes."""
        self.anti_huffman_payload(TID_SKILLS)

    def test_affin_label_is_affin(self):
        """FE7 0x1100 is 'Div', not the personal-data Affin label."""
        blob = self.anti_huffman_payload(TID_AFFIN)
        self.assertNotEqual(blob, b"Div\x00")

    def test_string_expander_accepts_anti_huffman(self):
        """Talk/Skills use setText's 0x80000000 bit. Vanilla 08004364 only Huffman-decodes; that hangs before the stat page is copied to the screen."""
        self.assertNotEqual(
            self.hack[STRING_EXPANDER:STRING_EXPANDER + 8],
            self.clean[STRING_EXPANDER:STRING_EXPANDER + 8],
            "08004364 is still the vanilla Huffman trampoline",
        )

    def test_get_string_from_index_literal_pool_intact(self):
        """Overwriting 12C88 must not smash the adjacent last-id / buffer literals."""
        self.assertEqual(u32(self.hack, GET_STRING_LAST_ID_LITERAL), 0x0202B5B4)
        self.assertEqual(u32(self.hack, GET_STRING_BUFFER_LITERAL), 0x0202A5B4)
        self.assertEqual(u32(self.hack, HELPER_TABLE_LITERAL), u32(self.hack, GET_STRING_TABLE_LITERAL))

    def test_left_panel_does_not_draw_affinity_icon(self):
        """Affinity belongs on the personal-data page, not beside the unit name."""
        hook = self.hack[LEFT_PAGE_HOOK:LEFT_PAGE_HOOK + 8]
        self.assertEqual(hook[:4], bytes([0x00, 0x4B, 0x18, 0x47]))
        left = u32(self.hack, LEFT_PAGE_HOOK + 4) & 0x01FFFFFE
        blob = self.hack[left:left + 0x400]
        self.assertNotIn(
            AFFINITY_GETTER.to_bytes(4, "little"),
            blob,
            "left panel still calls AffinityGetter (icon next to the name)",
        )

    def test_page1_affinity_uses_icon_sheet_2(self):
        """IconRework: AffinityGetter is sheet-local; DrawIcon must OR sheet 2."""
        text = read_event_text(PAGE1_LYN)
        self.assertIn("$8026B24", text)
        self.assertIn(
            "$2092102",
            text,
            "page 1 must OR IconRework sheet 2 before DrawIcon for affinity",
        )

    def test_left_panel_does_not_apply_fe6_portrait_box(self):
        """The FE6 12x13 box overwrites vanilla LV/EXP window tiles with the wrong tileset."""
        text = read_event_text(LEFT_LYN)
        self.assertNotIn("SSS_PortraitBoxTSA", text)
        self.assertNotIn("RestoreStatScreenPortraitBox", text)

    def test_left_panel_reapplies_vanilla_window_tsa(self):
        """Vanilla 083FC9FC is the left-window TSA that sits behind LV/E/HP."""
        text = read_event_text(LEFT_LYN)
        self.assertIn("$83FC9FC", text)

    def test_left_panel_uses_vanilla_mms_box_oam(self):
        """FE6 SSS_MMSBoxOAM needs FE6 tiles at 0x6000000. Vanilla 08CC1E58 is the dark LV/HP box."""
        self.assertEqual(
            u32(self.hack, 0x80F3C),
            u32(self.clean, 0x80F3C),
            "0x80F3C still points at SSS_MMSBoxOAM instead of vanilla 08CC1E58",
        )

    def test_items_page_uses_vanilla_item_box_tsa(self):
        """SSS_StatsBoxTSA is the FE6 equipment box. FE7 item names sit on 083FCAC0."""
        text = read_event_text(PAGE2_LYN)
        self.assertIn("$83FCAC0", text)
        self.assertNotIn("SSS_StatsBoxTSA", text)

    def test_items_page_loads_vanilla_equipment_label_gfx(self):
        """Vanilla 083FD62C at 0x6004E00 is the tileset with the baked-in Equipment label."""
        text = read_event_text(PAGE2_LYN)
        self.assertIn("$83FD62C", text)

    def test_weapon_page_uses_vanilla_wep_support_tsa(self):
        """FE6 WepSupport TSA draws a divider with the wrong tileset under the 2x2 ranks."""
        text = read_event_text(PAGE3_LYN)
        self.assertIn("$83FCB30", text)

    def test_items_page_range_text_uses_fe7_handle(self):
        """FE8 0x2003CB4 is page BG2 on FE7. Vanilla writes Rng into StatScreenStruct+0xB8."""
        text = read_event_text(PAGE2_LYN)
        self.assertNotIn("$2003CB4", text)
        self.assertIn("$20031C4", text)

    def test_get_skills_skips_invalid_id_0xff(self):
        """Lyn Lord's class skill is 0xFF (none). Listing it draws a bogus weapon icon."""
        blob = lyn_to_bytes(GET_SKILLS_LYN)
        self.assertIn(
            bytes([0xFF, 0x2A]),
            blob,
            "GetSkills must cmp r2, #0xFF so placeholder class skills are not listed",
        )


if __name__ == "__main__":
    result = unittest.main(verbosity=2, exit=False).result
    sys.exit(0 if result.wasSuccessful() else 1)
