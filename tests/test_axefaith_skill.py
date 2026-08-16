"""AxeFaith: Luck*1.5 Hit with axes, and axes skip durability loss."""
import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
AXE_SRC = (
    ROOT
    / "EngineHacks"
    / "SkillSystem"
    / "Skills"
    / "PreBattleSkills"
    / "AxeFaith"
    / "AxeFaith.s"
)
AXE_LYN = AXE_SRC.with_name("AxeFaith.lyn.event")
ROUNDS = (
    ROOT
    / "EngineHacks"
    / "SkillSystem"
    / "Skills"
    / "RoundsSkills"
    / "RoundsSkills.event"
)
ARMSTHRIFT_AXE = (
    ROOT
    / "EngineHacks"
    / "SkillSystem"
    / "Skills"
    / "RoundsSkills"
    / "Armsthrift"
    / "armsthriftaxefaith.s"
)
DESC_EVENT = ROOT / "EngineHacks" / "SkillSystem" / "skill_descriptions.event"
SKILL_DEFS = ROOT / "EngineHacks" / "SkillSystem" / "skill_definitions.event"
DESC_TEXT = ROOT / "Text" / "skilldesc_text.txt"
MASTER = (
    ROOT
    / "EngineHacks"
    / "SkillSystem"
    / "Skills"
    / "MasterSkillInstaller.event"
)
CLEAN_ROM = ROOT / "FE7_clean.gba"

COMMENT_RE = re.compile(r"/\*.*?\*/", re.S)
FE7_DURABILITY_HOOK = 0x08029498
FE7_GET_ITEM_AFTER_USE = 0x08016730


def _active_event(path: Path) -> str:
    return COMMENT_RE.sub("", path.read_text(encoding="utf-8"))


class AxeFaithSkillTests(unittest.TestCase):
    def test_luck_is_loaded_as_a_byte(self):
        src = AXE_SRC.read_text(encoding="utf-8")
        luck = src.split("@Add to Hit", 1)[1]
        luck = luck.split("NoSkill:", 1)[0]
        self.assertIn("ldrb", luck)
        self.assertNotIn("ldrh    r0, [r4,r0]", luck)
        self.assertNotIn("ldrh r0, [r4,r0]", luck)
        lyn = AXE_LYN.read_text(encoding="utf-8")
        self.assertIn("$5C20", lyn)
        self.assertNotIn("$5A20", lyn)

    def test_durability_hook_is_fe7_hit_effects(self):
        rounds = _active_event(ROUNDS)
        self.assertRegex(rounds, r"ORG\s+\$29498")
        self.assertNotRegex(rounds, r"ORG\s+\$2B7F8")
        self.assertRegex(rounds, r"armsthriftaxefaith\.lyn\.event")
        self.assertRegex(rounds, r"\bAxeFaithID\b")

    def test_armsthrift_axefaith_uses_fe7_item_after_use(self):
        src = ARMSTHRIFT_AXE.read_text(encoding="utf-8")
        self.assertIn("0x08016730", src)
        self.assertIn("0x080294C8", src)
        self.assertIn("0x08029498", src)
        self.assertNotIn("0x0801672E", src)
        self.assertNotIn("0x0802B828", src)

    def test_durability_uses_round_weapon_so_counters_apply(self):
        src = ARMSTHRIFT_AXE.read_text(encoding="utf-8")
        self.assertIn("WTYPE_AXE", src)
        self.assertIn("#0x50", src)
        self.assertIn("ldrb", src)
        self.assertNotIn("GetWeaponType", src)

    def test_durability_writes_weapon_through_vanilla_pointer(self):
        """FE7 HitEffects keeps r4 as &weapon; [r5, r4] with a pointer in r4 writes into stats."""
        src = ARMSTHRIFT_AXE.read_text(encoding="utf-8")
        self.assertIn("add r4, #0x48", src)
        self.assertIn("strh r0, [r4]", src)
        self.assertNotIn("strh r0, [r5, r4]", src)
        self.assertNotIn("strh r0, [r5,r4]", src)

    def test_description_feeds_debugger_skill_name(self):
        active = "\n".join(
            line
            for line in DESC_EVENT.read_text(encoding="utf-8").splitlines()
            if not line.lstrip().startswith("//")
        )
        self.assertRegex(active, r"SkillDescription\(\s*AxeFaithID\s*,\s*SD_AxeFaith\s*\)")
        text = DESC_TEXT.read_text(encoding="utf-8")
        self.assertIn("## SD_AxeFaith", text)
        self.assertIn("AxeFaith:", text)
        defs = SKILL_DEFS.read_text(encoding="utf-8")
        self.assertRegex(defs, r"#define\s+AxefaithID\s+AxeFaithID")

    def test_rounds_skills_are_installed(self):
        master = MASTER.read_text(encoding="utf-8")
        active_master = "\n".join(
            line for line in master.splitlines() if not line.lstrip().startswith("//")
        )
        self.assertIn("RoundsSkills/RoundsSkills.event", active_master)
        rounds = "\n".join(
            line for line in ROUNDS.read_text(encoding="utf-8").splitlines()
            if not line.lstrip().startswith("//")
        )
        rounds = COMMENT_RE.sub("", rounds)
        self.assertRegex(rounds, r"ORG\s+\$29498")
        self.assertNotRegex(rounds, r"ORG\s+0x2C864")

    def test_clean_rom_decrements_weapon_at_hook(self):
        if not CLEAN_ROM.exists():
            self.skipTest("FE7_clean.gba missing")
        rom = CLEAN_ROM.read_bytes()
        off = FE7_DURABILITY_HOOK - 0x08000000
        self.assertEqual(rom[off : off + 8], bytes.fromhex("11 68 02 20 09 88 08 40"))
        bl = 0x080294B4 - 0x08000000
        self.assertEqual(rom[bl : bl + 4], bytes.fromhex("ED F7 3C F9"))
        after_use = FE7_GET_ITEM_AFTER_USE - 0x08000000
        self.assertEqual(rom[after_use : after_use + 2], bytes.fromhex("02 1C"))


if __name__ == "__main__":
    unittest.main()
