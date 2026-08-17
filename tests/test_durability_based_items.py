"""DEC-64: DurabilityBasedItems hooks FE7 item getters for skill scrolls."""
import re
import struct
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
INSTALLER = ROOT / "EngineHacks" / "_MasterHackInstaller.event"
EVENT = (
    ROOT
    / "EngineHacks"
    / "Necessary"
    / "DurabilityBasedItems"
    / "DurabilityBasedItems.event"
)
NAMES = (
    ROOT
    / "EngineHacks"
    / "Necessary"
    / "DurabilityBasedItems"
    / "ScrollNames.s"
)
USES = (
    ROOT
    / "EngineHacks"
    / "Necessary"
    / "DurabilityBasedItems"
    / "ScrollDurability.s"
)
ICONS = (
    ROOT
    / "EngineHacks"
    / "Necessary"
    / "DurabilityBasedItems"
    / "SkillBookIconDraw.s"
)
HACK_ROM = ROOT / "FE7_Hack.gba"

FE7_GET_ITEM_NAME_HOOK = 0x171C0
FE7_GET_ITEM_NAME_ID_HOOK = 0x1722C
FE7_GET_ITEM_DESC_HOOK = 0x17244
FE7_GET_ITEM_USES_HOOK = 0x17294
FE7_STATSCREEN_USES_HOOK = 0x166B0
FE7_MENU_USES_HOOKS = (0x164C8, 0x16570)
FE7_GET_ITEM_ICON_HOOK = 0x17400
FE7_INLINE_NAME_HOOKS = (0x16690, 0x1649C, 0x16538, 0x165F4)
FE7_MENU_ICON_HOOKS = (0x164E8, 0x165B4, 0x16640, 0x16708)
JUMP_TO_HACK = bytes((0x00, 0x4B, 0x18, 0x47))

FE8_GET_ITEM_NAME_HOOK = 0x174F8
FE8_GET_ITEM_USES_HOOK = 0x17594


def _text(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def _orgs(text: str) -> set[int]:
    found = set()
    for m in re.finditer(r"ORG\s+\$([0-9A-Fa-f]+)", text):
        found.add(int(m.group(1), 16))
    return found


class DurabilityBasedItemsTests(unittest.TestCase):
    def test_master_installer_includes_module(self):
        self.assertRegex(
            _text(INSTALLER),
            r'DurabilityBasedItems/DurabilityBasedItems\.event',
        )

    def test_hooks_fe7_getters_and_inline_icons(self):
        event = _text(EVENT)
        orgs = _orgs(event)
        self.assertIn(FE7_GET_ITEM_NAME_HOOK, orgs)
        self.assertIn(FE7_GET_ITEM_NAME_ID_HOOK, orgs)
        self.assertIn(FE7_GET_ITEM_DESC_HOOK, orgs)
        self.assertIn(FE7_GET_ITEM_USES_HOOK, orgs)
        self.assertIn(FE7_STATSCREEN_USES_HOOK, orgs)
        for off in FE7_MENU_USES_HOOKS:
            self.assertIn(off, orgs, f"missing menu uses skip ORG ${off:X}")
        self.assertIn(FE7_GET_ITEM_ICON_HOOK, orgs)
        for off in FE7_INLINE_NAME_HOOKS:
            self.assertIn(off, orgs, f"missing inline name hook ORG ${off:X}")
        for off in FE7_MENU_ICON_HOOKS:
            self.assertIn(off, orgs, f"missing inline icon hook ORG ${off:X}")
        self.assertNotIn(FE8_GET_ITEM_NAME_HOOK, orgs)
        self.assertNotIn(FE8_GET_ITEM_USES_HOOK, orgs)
        self.assertNotRegex(event, r"DurabilityChest/")
        self.assertNotRegex(event, r"DurabilityShop/")
        self.assertIn("DurabilityItem(SkillScroll)", event)
        self.assertIn("DurabilityIcon(SkillScroll,5)", event)

    def test_name_getter_uses_fe7_msg_buffer(self):
        src = _text(NAMES)
        self.assertRegex(src, r"0x08012C6[01]")
        self.assertIn("0x202A5B4", src)
        self.assertNotIn("0x800A241", src)
        self.assertIn("GetItemNameString", src)
        self.assertIn("GetItemDescStringIndex", src)
        self.assertIn("NewItemNameGetter1", src)
        self.assertIn("NewItemNameGetter4", src)

    def test_uses_getter_returns_with_bx_lr(self):
        src = _text(USES)
        self.assertIn("ScrollDurabilityGetter", src)
        self.assertIn("bx lr", src)

    def test_icon_getter_uses_durability_list(self):
        src = _text(ICONS)
        self.assertIn("CheckIfSkillBookIcon_Generic", src)
        self.assertIn("CheckIfSkillBookIcon_MenuA", src)
        self.assertIn("ResolveDurabilityIcon", src)
        self.assertIn("DurabilityBasedItemIconList", src)

    def test_hack_rom_jump_hooks(self):
        if not HACK_ROM.is_file():
            self.skipTest("FE7_Hack.gba missing")
        rom = HACK_ROM.read_bytes()
        for off in (
            FE7_GET_ITEM_NAME_HOOK,
            FE7_GET_ITEM_NAME_ID_HOOK,
            FE7_GET_ITEM_DESC_HOOK,
            FE7_GET_ITEM_USES_HOOK,
            FE7_STATSCREEN_USES_HOOK,
            *FE7_MENU_USES_HOOKS,
            FE7_GET_ITEM_ICON_HOOK,
            *FE7_INLINE_NAME_HOOKS,
            *FE7_MENU_ICON_HOOKS,
        ):
            self.assertEqual(
                rom[off : off + 4],
                JUMP_TO_HACK,
                f"missing jumpToHack at 0x{off:05X}",
            )
            dest = struct.unpack_from("<I", rom, off + 4)[0]
            self.assertTrue(dest & 1, f"thumb bit missing at 0x{off:05X}")
            body = dest & 0x01FFFFFF
            self.assertGreater(body, 0x1000000, f"hook dest not in free space: 0x{dest:08X}")


if __name__ == "__main__":
    unittest.main()
