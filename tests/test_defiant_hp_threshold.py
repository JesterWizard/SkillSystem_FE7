"""Every Defiant skill (Avo, Crit, and the 7 core-stat variants) boosts only
when the unit's current HP is at 25% of MAX HP or lower, and every variant is
actually wired into a calc loop that runs.

Threshold check pattern (unit+0x12 = max HP, unit+0x13 = cur HP):
    ldrb r0,[r4,#0x12]   @ max hp
    ldrb r1,[r4,#0x13]   @ cur hp
    lsl  r1,r1,#2        @ cur hp x4
    cmp  r1,r0
    bgt  GoBack          @ cur*4 > max  =>  cur > 25% of max  =>  skip boost

cur*4 <= max  <=>  cur <= max/4, i.e. current HP <= 25% of MAX HP -- not a
fixed/current-vs-current-only threshold, and not tied to a flat HP count.
"""
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SKILLS = ROOT / "EngineHacks" / "SkillSystem" / "Skills"

DEFIANT_AVO_S = SKILLS / "PreBattleSkills" / "DefiantAvo" / "DefiantAvo.s"
DEFIANT_CRIT_S = SKILLS / "PreBattleSkills" / "DefiantCrit" / "DefiantCrit.s"
DEFIANT_SKILL_S = (
    SKILLS / "StatModifierSkills" / "DefiantSkills" / "DefiantSkill.s"
)
DEFIANT_SKILLS_EVENT = (
    SKILLS / "StatModifierSkills" / "DefiantSkills" / "DefiantSkills.event"
)

PREBATTLE_CALC_LOOP = (
    ROOT
    / "EngineHacks"
    / "Necessary"
    / "CalcLoops"
    / "PreBattleCalcLoop"
    / "PreBattleCalcLoop.event"
)

STAT_GETTERS_DIR = ROOT / "EngineHacks" / "Necessary" / "StatGetters"
CORE_STAT_GETTERS = {
    "Str": "Power.event",
    "Mag": "Magic.event",
    "Skl": "Skill.event",
    "Spd": "Speed.event",
    "Lck": "Luck.event",
    "Def": "Defense.event",
    "Res": "Resistance.event",
}

SKILL_DEFINITIONS = ROOT / "EngineHacks" / "SkillSystem" / "skill_definitions.event"

THRESHOLD_RE = (
    r"ldrb\s+r0,\[r4,#0x12\]\s*@max hp\s*"
    r"ldrb\s+r1,\[r4,#0x13\]\s*@cur hp\s*"
    r"lsl\s+r1,r1,#2\s*@cur hp x4\s*"
    r"cmp\s+r1,r0\s*"
    r"bgt\s+GoBack"
)

# DefiantSkill.s runs in the stat getters, not the battle loop: r5 is the unit
# (not r4), so it reads offsets off r5 there instead.
THRESHOLD_RE_STATGETTER = (
    r"ldrb\s+r0,\[r5,#0x12\]\s*"
    r"ldrb\s+r1,\[r5,#0x13\]\s*"
    r"lsl\s+r1,r1,#2\s*"
    r"cmp\s+r1,r0\s*"
    r"bgt\s+GoBack"
)


class DefiantHpThresholdTests(unittest.TestCase):
    def test_defiant_avo_boosts_at_25_percent_max_hp_or_lower(self):
        src = DEFIANT_AVO_S.read_text(encoding="utf-8")
        self.assertRegex(src, THRESHOLD_RE)

    def test_defiant_crit_boosts_at_25_percent_max_hp_or_lower(self):
        src = DEFIANT_CRIT_S.read_text(encoding="utf-8")
        self.assertRegex(src, THRESHOLD_RE)

    def test_defiant_core_stat_skill_boosts_at_25_percent_max_hp_or_lower(self):
        src = DEFIANT_SKILL_S.read_text(encoding="utf-8")
        self.assertRegex(src, THRESHOLD_RE_STATGETTER)

    def test_defiant_avo_and_crit_wired_into_prebattle_calc_loop(self):
        src = PREBATTLE_CALC_LOOP.read_text(encoding="utf-8")
        self.assertRegex(src, r"POIN[^\n]*\bDefiantAvo\b")
        self.assertRegex(src, r"POIN[^\n]*\bDefiantCrit\b")

    def test_all_seven_core_stats_wire_defiant_into_their_getter(self):
        for stat, filename in CORE_STAT_GETTERS.items():
            with self.subTest(stat=stat):
                src = (STAT_GETTERS_DIR / filename).read_text(encoding="utf-8")
                self.assertRegex(src, rf"POIN[^\n]*\bprDefiant{stat}\b")

    def test_defiant_skills_event_defines_all_seven_stat_variants(self):
        src = DEFIANT_SKILLS_EVENT.read_text(encoding="utf-8")
        for stat in CORE_STAT_GETTERS:
            with self.subTest(stat=stat):
                self.assertIn(f"prDefiant{stat}", src)
                self.assertIn(f"Defiant{stat}ID", src)

    def test_defiant_skill_ids_are_defined_and_distinct(self):
        src = SKILL_DEFINITIONS.read_text(encoding="utf-8")
        ids = {}
        for stat in CORE_STAT_GETTERS:
            match = self.assertRegexReturn(
                src, rf"#define Defiant{stat}ID (\d+)"
            )
            ids[stat] = match
        self.assertRegex(src, r"#define DefiantAvoID (\d+)")
        self.assertRegex(src, r"#define DefiantCritID (\d+)")
        self.assertEqual(len(set(ids.values())), len(ids), "Defiant IDs collide")

    def assertRegexReturn(self, text, pattern):
        import re

        m = re.search(pattern, text)
        self.assertIsNotNone(m, f"pattern not found: {pattern}")
        return m.group(1)


if __name__ == "__main__":
    unittest.main()
