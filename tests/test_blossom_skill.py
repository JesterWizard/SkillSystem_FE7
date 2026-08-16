"""Blossom: 2x growths via the growth-bonus loop, and 1/2 EXP via EXPCalcLoop."""
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
BLOSSOM_GROWTH = (
    ROOT
    / "EngineHacks"
    / "SkillSystem"
    / "Skills"
    / "GrowthSkills"
    / "Blossom"
    / "Blossom.s"
)
BLOSSOM_EXP = (
    ROOT
    / "EngineHacks"
    / "SkillSystem"
    / "Skills"
    / "EXPSkills"
    / "Blossom"
    / "BlossomExp.s"
)
GROWTH_SKILLS = (
    ROOT / "EngineHacks" / "SkillSystem" / "Skills" / "GrowthSkills" / "GrowthSkills.event"
)
EXP_SKILLS = (
    ROOT / "EngineHacks" / "SkillSystem" / "Skills" / "EXPSkills" / "EXPSkills.event"
)
EXP_LOOP = (
    ROOT / "EngineHacks" / "Necessary" / "CalcLoops" / "EXPCalcLoop" / "EXPCalcLoop.event"
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


class BlossomSkillTests(unittest.TestCase):
    def test_growth_bonus_loop_runs_blossom(self):
        getters = _active_event(GROWTH_GETTERS)
        loop = getters.split("Growth_Bonus_CalcLoop:", 1)[1]
        loop = loop.split("WORD 0", 1)[0]
        self.assertIn("BlossomGrowthModifier", loop)
        self.assertRegex(getters, r"POIN\s+Growth_Bonus_CalcLoop")

    def test_extra_growth_boosts_calls_modifier_loop(self):
        src = EXTRA_SRC.read_text(encoding="utf-8")
        self.assertIn("GrowthModifiers", src)
        self.assertIn("GrowthLoop", src)
        self.assertIn("lsl r5,#1", BLOSSOM_GROWTH.read_text(encoding="utf-8"))

    def test_growth_modifier_is_installed(self):
        skills = _active_event(GROWTH_SKILLS)
        self.assertIn("BlossomGrowthModifier:", skills)
        self.assertIn("Blossom/Blossom.lyn.event", skills)
        self.assertRegex(skills, r"WORD\s+BlossomID")
        master = _active_event(MASTER)
        self.assertIn("GrowthSkills/GrowthSkills.event", master)

    def test_exp_loop_halves_exp(self):
        src = BLOSSOM_EXP.read_text(encoding="utf-8")
        self.assertIn("lsr r4, r4, #0x01", src)
        loop = _active_event(EXP_LOOP)
        self.assertRegex(loop, r"POIN\s+Paragon\s+Blossom\s+VoidCurse")
        skills = _active_event(EXP_SKILLS)
        self.assertIn("BlossomExp.lyn.event", skills)
        master = _active_event(MASTER)
        self.assertIn("EXPSkills/EXPSkills.event", master)

    def test_description_and_id(self):
        defs = SKILL_DEFS.read_text(encoding="utf-8")
        self.assertRegex(defs, r"#define\s+BlossomID\s+52")
        desc = _active_event(DESC_EVENT)
        self.assertRegex(desc, r"SkillDescription\(\s*BlossomID\s*,\s*SD_Blossom\s*\)")
        text = DESC_TEXT.read_text(encoding="utf-8")
        self.assertIn("## SD_Blossom", text)
        self.assertIn("2x growth rates", text)
        self.assertIn("1/2 exp gain", text.lower())


if __name__ == "__main__":
    unittest.main()
