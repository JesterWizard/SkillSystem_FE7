"""DEC-67: IconRework installed so durability sheet-5 skill icons resolve."""
import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
INSTALLER = ROOT / "EngineHacks" / "_MasterHackInstaller.event"
EVENT = ROOT / "EngineHacks" / "Necessary" / "IconRework" / "IconRework.event"
INTERNAL = (
    ROOT / "EngineHacks" / "Necessary" / "IconRework" / "IconRework_Internal.event"
)
GET_ICON = (
    ROOT / "EngineHacks" / "Necessary" / "IconRework" / "asm" / "GetIconTileIndex.s"
)
LOAD_OBJ = (
    ROOT / "EngineHacks" / "Necessary" / "IconRework" / "asm" / "LoadIconObjGfx.s"
)
MSS_PAGE = (
    ROOT
    / "EngineHacks"
    / "Necessary"
    / "ModularStatScreen"
    / "pages"
    / "mss_page1_skills.s"
)
HACK_ROM = ROOT / "FE7_Hack.gba"

FE7_GET_ICON_TILE_INDEX = 0x4DBC
FE7_CLEAR_ICONS = 0x4CF4
FE7_REGISTER_DATA_MOVE = 0x08003078
# replaceWithHack stub (not jumpToHack)
REPLACE_WITH_HACK = bytes(
    (0x10, 0xB5, 0x03, 0x4C, 0x00, 0xF0, 0x03, 0xF8, 0x10, 0xBC, 0x02, 0xBC, 0x08, 0x47, 0x20, 0x47)
)


def _text(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def _orgs(text: str) -> set[int]:
    found = set()
    for m in re.finditer(r"ORG\s+\$?0?x?([0-9A-Fa-f]+)", text, re.I):
        found.add(int(m.group(1), 16))
    return found


class IconReworkTests(unittest.TestCase):
    def test_master_installer_includes_module(self):
        self.assertRegex(
            _text(INSTALLER),
            r"IconRework/IconRework\.event",
        )

    def test_get_icon_tile_index_hook_enabled(self):
        internal = _text(INTERNAL)
        self.assertIn("ORG 0x004DBC", internal)
        self.assertIn("replaceWithHack(prGetIconTileIndex)", internal)
        # ensure the old crash-comment disable is gone
        self.assertNotRegex(
            internal,
            r"//\s*ORG 0x004DBC",
        )
        orgs = _orgs(internal)
        self.assertIn(FE7_GET_ICON_TILE_INDEX, orgs)
        self.assertIn(FE7_CLEAR_ICONS, orgs)

    def test_register_data_move_uses_fe7_address(self):
        for path in (GET_ICON, LOAD_OBJ):
            text = _text(path)
            self.assertIn("0x08003078", text)
            self.assertNotIn("0x0801320C", text)

    def test_sheet_five_skill_book_getter(self):
        event = _text(EVENT)
        self.assertIn("InjectIconGfxGetter(5, (prGetSkillBookIconGfx+1))", event)
        self.assertIn("POIN SkillIcons", event)
        self.assertRegex(event, r"ICON_SHEET_COUNT\s+6")

    def test_mss_uses_icon_rework_sheet(self):
        self.assertRegex(
            _text(MSS_PAGE),
            r"NoAltIconDraw,\s*1",
        )

    def test_hack_rom_hooks_get_icon_tile_index(self):
        if not HACK_ROM.exists():
            self.skipTest("FE7_Hack.gba not built")
        rom = HACK_ROM.read_bytes()
        off = FE7_GET_ICON_TILE_INDEX
        self.assertEqual(rom[off : off + len(REPLACE_WITH_HACK)], REPLACE_WITH_HACK)
        dest = int.from_bytes(rom[off + 16 : off + 20], "little")
        self.assertEqual(dest & 1, 1, "hook target must be thumb")
        self.assertGreaterEqual(dest, 0x09000000)


if __name__ == "__main__":
    unittest.main()
