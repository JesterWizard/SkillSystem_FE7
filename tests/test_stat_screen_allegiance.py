"""DEC-69: Stat Screen Allegiance uses FE7 hook/RAM, not FE8 copy-paste."""
import struct
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CONFIG = ROOT / "EngineHacks" / "Config.event"
MASTER = ROOT / "EngineHacks" / "_MasterHackInstaller.event"
INSTALLER = (
    ROOT
    / "EngineHacks"
    / "ExternalHacks"
    / "StatScreenAllegiance"
    / "StatScreenAllegiance.event"
)
ASM = (
    ROOT
    / "EngineHacks"
    / "ExternalHacks"
    / "StatScreenAllegiance"
    / "asm"
    / "statscreenAlleg.s"
)
DMP = ASM.with_suffix(".dmp")

FE7_HOOK = 0x81132
FE7_RETURN = 0x0808113F
FE7_CURSOR = 0x0202BBCC
FE7_MAP_UNIT = 0x0202E3DC
FE7_ACTIVE_ID = 0x0202BD48
FE7_STATSCREEN = 0x0200310C
FE7_PAL_TABLE = 0x08B9A830

FE8_HOOK_HINTS = ("ORG $8859C", "ORG 0x8859C", "0x80885A5", "0x202BCC4", "0x202E4D8")


class StatScreenAllegianceTests(unittest.TestCase):
    def test_config_toggle_exists(self):
        text = CONFIG.read_text(encoding="utf-8")
        self.assertIn("STATSCREEN_ALLEGIANCE", text)
        self.assertIn("allegiance-based statscreen palettes", text.lower())

    def test_master_includes_after_mss(self):
        text = MASTER.read_text(encoding="utf-8")
        mss = text.find("ModularStatScreen/ModularStatScreen.event")
        alleg = text.find("StatScreenAllegiance/StatScreenAllegiance.event")
        self.assertNotEqual(mss, -1)
        self.assertNotEqual(alleg, -1)
        self.assertGreater(alleg, mss)

    def test_installer_is_fe7_gated(self):
        text = INSTALLER.read_text(encoding="utf-8")
        self.assertIn("STATSCREEN_ALLEGIANCE", text)
        self.assertIn("_FE7_", text)
        self.assertIn("ORG $81132", text)
        self.assertIn("POIN StatscreenAlleg|1", text)
        self.assertNotIn("jumpToHack(StatscreenAlleg)", text)
        self.assertNotIn("ERROR Statscreen palette based on allegiance hack is for FE8", text)
        for hint in FE8_HOOK_HINTS:
            self.assertNotIn(hint, text)

    def test_asm_uses_fe7_addresses(self):
        text = ASM.read_text(encoding="utf-8")
        self.assertIn("0x202BBCC", text.replace("0x0202BBCC", "0x202BBCC"))
        self.assertIn("0x202E3DC", text.replace("0x0202E3DC", "0x202E3DC"))
        self.assertIn("0x202BD48", text.replace("0x0202BD48", "0x202BD48"))
        self.assertIn("0x0808113F", text.replace("0x808113F", "0x0808113F"))
        self.assertNotIn("0x202BCC4", text)
        self.assertNotIn("0x202E4D8", text)
        self.assertNotIn("0x80885A5", text)
        self.assertNotIn("0x8088640", text)

    def test_dmp_literals_are_fe7(self):
        data = DMP.read_bytes()
        for addr in (
            FE7_CURSOR,
            FE7_MAP_UNIT,
            FE7_ACTIVE_ID,
            FE7_STATSCREEN,
            FE7_PAL_TABLE,
            FE7_RETURN,
        ):
            self.assertIn(
                struct.pack("<I", addr),
                data,
                f"dmp missing {addr:#010x}",
            )
        self.assertNotIn(struct.pack("<I", 0x0202BCC4), data)
        self.assertNotIn(struct.pack("<I", 0x080885A5), data)

    def test_built_rom_hook_when_enabled(self):
        config = CONFIG.read_text(encoding="utf-8")
        enabled = any(
            line.strip() == "#define STATSCREEN_ALLEGIANCE"
            for line in config.splitlines()
        )
        hack = ROOT / "FE7_Hack.gba"
        if not enabled or not hack.is_file():
            self.skipTest("STATSCREEN_ALLEGIANCE off or FE7_Hack.gba missing")
        rom = hack.read_bytes()
        self.assertEqual(
            rom[FE7_HOOK : FE7_HOOK + 6],
            bytes([0x01, 0x4B, 0x18, 0x47, 0xC0, 0x46]),
        )


if __name__ == "__main__":
    unittest.main()
