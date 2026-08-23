"""Aptitude: +20 to all growths via the growth-bonus loop."""
import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GROWTH_GETTERS = ROOT / "EngineHacks" / "Necessary" / "GrowthGetters" / "GrowthGetters.event"
EXTRA_SRC = (
    ROOT
    / "EngineHacks"
    / "Necessary"
    / "GrowthGetters"
    / "asm"
    / "Extra_Growth_Boosts.s"
)
APTITUDE_GROWTH = (
    ROOT
    / "EngineHacks"
    / "SkillSystem"
    / "Skills"
    / "GrowthSkills"
    / "Aptitude"
    / "Aptitude.s"
)
GROWTH_SKILLS = (
    ROOT / "EngineHacks" / "SkillSystem" / "Skills" / "GrowthSkills" / "GrowthSkills.event"
)
MASTER = (
    ROOT / "EngineHacks" / "SkillSystem" / "Skills" / "MasterSkillInstaller.event"
)
DESC_EVENT = ROOT / "EngineHacks" / "SkillSystem" / "skill_descriptions.event"
SKILL_DEFS = ROOT / "EngineHacks" / "SkillSystem" / "skill_definitions.event"
DESC_TEXT = ROOT / "Text" / "skilldesc_text.txt"

COMMENT_RE = re.compile(r"/\*.*?\*/", re.S)


def _active_event(path: Path) -> str:
    text = COMMENT_RE.sub("", path.read_text(encoding="utf-8"))
    return "\n".join(
        line for line in text.splitlines() if not line.lstrip().startswith("//")
    )


class AptitudeSkillTests(unittest.TestCase):
    def test_growth_bonus_loop_runs_aptitude(self):
        getters = _active_event(GROWTH_GETTERS)
        loop = getters.split("Growth_Bonus_CalcLoop:", 1)[1]
        loop = loop.split("WORD 0", 1)[0]
        self.assertIn("AptitudeGrowthModifier", loop)
        self.assertRegex(getters, r"POIN\s+Growth_Bonus_CalcLoop")

    def test_extra_growth_boosts_calls_modifier_loop(self):
        src = EXTRA_SRC.read_text(encoding="utf-8")
        self.assertIn("GrowthModifiers", src)
        self.assertIn("GrowthLoop", src)
        self.assertRegex(APTITUDE_GROWTH.read_text(encoding="utf-8"), r"add\s+r5,\s*#20")

    def test_growth_modifier_is_installed(self):
        skills = _active_event(GROWTH_SKILLS)
        self.assertIn("AptitudeGrowthModifier:", skills)
        self.assertIn("Aptitude/Aptitude.lyn.event", skills)
        self.assertRegex(skills, r"WORD\s+AptitudeID")
        master = _active_event(MASTER)
        self.assertIn("GrowthSkills/GrowthSkills.event", master)

    def test_description_and_id(self):
        defs = SKILL_DEFS.read_text(encoding="utf-8")
        self.assertRegex(defs, r"#define\s+AptitudeID\s+196")
        desc = _active_event(DESC_EVENT)
        self.assertRegex(desc, r"SkillDescription\(\s*AptitudeID\s*,\s*SD_Aptitude\s*\)")
        text = DESC_TEXT.read_text(encoding="utf-8")
        self.assertIn("## SD_Aptitude", text)
        self.assertIn("+20 to", text)
        self.assertIn("all growth rates", text.lower())


if __name__ == "__main__":
    unittest.main()
