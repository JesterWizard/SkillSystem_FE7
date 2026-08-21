"""DEC-71: Bly NarrowFont glyphs install into FE7 menu/serif tables."""
import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MASTER = ROOT / "EngineHacks" / "_MasterHackInstaller.event"
CONFIG = ROOT / "EngineHacks" / "Config.event"
NF_INSTALLER = (
    ROOT / "EngineHacks" / "ExternalHacks" / "NarrowFont" / "NarrowFontInstaller.event"
)

FE7_MENU_GLYPH_TABLE = 0xB896B0
FE7_SERIF_GLYPH_TABLE = 0xB8B5B0
FE8_MENU_GLYPH_TABLE = 0x58C7EC
FE8_SERIF_GLYPH_TABLE = 0x58F6F4


class NarrowFontIncludeTests(unittest.TestCase):
    def test_master_installer_includes_narrow_font(self):
        text = MASTER.read_text(encoding="utf-8")
        self.assertRegex(text, r"NarrowFont/NarrowFontInstaller\.event")

    def test_installer_targets_fe7_glyph_tables(self):
        text = NF_INSTALLER.read_text(encoding="utf-8")
        self.assertIn("#ifdef NARROW_FONT", text)
        self.assertIn("#ifdef _FE7_", text)
        self.assertNotIn("#ifdef _FE8_", text)
        self.assertIn(f"{FE7_MENU_GLYPH_TABLE:X}", text.upper())
        self.assertIn(f"{FE7_SERIF_GLYPH_TABLE:X}", text.upper())
        self.assertNotIn(f"{FE8_MENU_GLYPH_TABLE:X}", text.upper())
        self.assertNotIn(f"{FE8_SERIF_GLYPH_TABLE:X}", text.upper())

    def test_config_defines_narrow_font(self):
        text = CONFIG.read_text(encoding="utf-8")
        self.assertRegex(text, re.compile(r"^#define NARROW_FONT\b", re.M))


def _text_process():
    import importlib.util

    spec = importlib.util.spec_from_file_location(
        "text_process_classic",
        ROOT / "Tools" / "TextProcess" / "text-process-classic.py",
    )
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


class NarrowFontTextProcessTests(unittest.TestCase):
    def test_star_span_emits_serif_narrow_codes(self):
        lines = [
            ("t.txt", 0, "#0x100 Sample\n"),
            ("t.txt", 1, "*{Dislikes}:[X]\n"),
        ]
        entries = _text_process().generate_text_entries(lines, False)
        self.assertEqual(len(entries), 1)
        self.assertIn("[0x9E]", entries[0].text)
        self.assertNotIn("[0xe1]", entries[0].text.lower())

    def test_caret_span_emits_menu_narrow_codes(self):
        lines = [
            ("t.txt", 0, "#0x101 Sample\n"),
            ("t.txt", 1, "^{Adept}[X]\n"),
        ]
        entries = _text_process().generate_text_entries(lines, False)
        self.assertEqual(len(entries), 1)
        self.assertIn("[0x9B]", entries[0].text)  # A
        self.assertIn("[0x84]", entries[0].text)  # d
        self.assertNotIn("[0xe1]", entries[0].text.lower())

    def test_serif_installer_skips_vanilla_brace_slots(self):
        text = (
            ROOT
            / "EngineHacks"
            / "ExternalHacks"
            / "NarrowFont"
            / "SerifLowercase"
            / "LowercaseSerif.txt"
        ).read_text(encoding="utf-8")
        for slot in (0x7B, 0x7C, 0x7D, 0x7F):
            self.assertIsNone(
                re.search(rf"^\s*tGlyphEntry\(0x{slot:X},", text, re.I | re.M),
                f"slot 0x{slot:X} is already a vanilla FE7 glyph",
            )


class NarrowFontRomTests(unittest.TestCase):
    def setUp(self):
        self.clean = ROOT / "FE7_clean.gba"
        self.hack = ROOT / "FE7_Hack.gba"
        if not self.clean.is_file() or not self.hack.is_file():
            self.skipTest("FE7_clean.gba or FE7_Hack.gba missing")
        self.clean_bytes = self.clean.read_bytes()
        self.hack_bytes = self.hack.read_bytes()

    def _u32(self, data, off):
        return int.from_bytes(data[off : off + 4], "little")

    def _slot(self, data, table, index):
        return self._u32(data, table + index * 4)

    def test_narrow_a_installed_without_clobbering_vanilla(self):
        for table in (FE7_MENU_GLYPH_TABLE, FE7_SERIF_GLYPH_TABLE):
            with self.subTest(table=hex(table)):
                vanilla_a = self._slot(self.clean_bytes, table, 0x41)
                vanilla_brace = self._slot(self.clean_bytes, table, 0x7B)
                self.assertEqual(self._slot(self.hack_bytes, table, 0x41), vanilla_a)
                self.assertEqual(self._slot(self.hack_bytes, table, 0x7B), vanilla_brace)
                ptr = self._slot(self.hack_bytes, table, 0x81)
                self.assertNotEqual(ptr, 0)
                self.assertGreaterEqual(ptr, 0x09000000)
                self.assertLess(ptr, 0x0A000000)
                width = self.hack_bytes[(ptr & 0x01FFFFFF) + 5]
                self.assertGreaterEqual(width, 3)
                self.assertLessEqual(width, 6)

    def test_dislikes_text_uses_narrow_serif_bytes(self):
        table_ptr = int.from_bytes(self.hack_bytes[0x12C88:0x12C8C], "little")
        table_off = table_ptr & 0x01FFFFFF
        live = self._u32(self.hack_bytes, table_off + 4 * 0xD4D)
        self.assertEqual(live & 0x80000000, 0x80000000)
        off = live & 0x01FFFFFF
        blob = self.hack_bytes[off:off + 16]
        self.assertIn(0x9E, blob)
        self.assertTrue(blob.startswith(bytes([0x9E, 0x69, 0x90, 0x6C, 0x69, 0x8A, 0x85, 0x90])))


if __name__ == "__main__":
    unittest.main()
