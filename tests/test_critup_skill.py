"""CritUp must be in the pre-battle loop and add +15 to battle crit as a halfword."""
import re
import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from lyn_bytes import lyn_to_bytes

ROOT = Path(__file__).resolve().parents[1]
LOOP = ROOT / "EngineHacks" / "Necessary" / "CalcLoops" / "PreBattleCalcLoop" / "PreBattleCalcLoop.event"
SRC = ROOT / "EngineHacks" / "SkillSystem" / "Skills" / "PreBattleSkills" / "CritUp" / "CritUpSkill.s"
LYN = ROOT / "EngineHacks" / "SkillSystem" / "Skills" / "PreBattleSkills" / "CritUp" / "CritUpSkill.lyn.event"
GET_SKILLS = ROOT / "EngineHacks" / "SkillSystem" / "Internals" / "asm" / "GetSkills.s"
SKILL_TESTER_C = (
    ROOT / "EngineHacks" / "SkillSystem" / "Internals" / "NewSkillTester" / "_src" / "SkillTester.c"
)
LYN_LIST = ROOT / "Tables" / "LevelUpSkillLists.event"
CHAR_LEVEL_CSV = ROOT / "Tables" / "NightmareModules" / "Skills" / "CharacterLevelUpSkillEditor.csv"

COMMENT_RE = re.compile(r"/\*.*?\*/", re.S)
BTL_LIST_RE = re.compile(r"^BtlLoopList:\s*\n((?:POIN[^\n]*\n)+)", re.M)


class CritUpSkillTests(unittest.TestCase):
    def test_prebattle_loop_calls_critup(self):
        text = LOOP.read_text(encoding="utf-8")
        match = BTL_LIST_RE.search(text)
        self.assertIsNotNone(match, "BtlLoopList missing")
        active = COMMENT_RE.sub("", match.group(1))
        self.assertRegex(active, r"\bCritUpSkill\b")

    def test_source_adds_halfword_crit(self):
        src = SRC.read_text(encoding="utf-8")
        self.assertRegex(src, r"ldrh")
        self.assertRegex(src, r"strh")
        self.assertRegex(src, r"add\s+r\d+\s*,\s*#(?:15|0x0F)")

    def test_dmp_uses_halfword_store(self):
        data = lyn_to_bytes(LYN)
        self.assertIn(b"\x60\x5A", data)
        self.assertIn(b"\x60\x52", data)
        self.assertNotIn(b"\x21\x70", data, "old strb r1, [r4] must not remain")

    def test_display_and_tester_use_level_up_list_not_bwl(self):
        skills = GET_SKILLS.read_text(encoding="utf-8")
        tester = SKILL_TESTER_C.read_text(encoding="utf-8")
        self.assertIn("GetInitialSkillList", skills)
        self.assertNotIn("BWLTable", skills)
        self.assertIn("GetInitialSkillList_Pointer", tester)
        self.assertNotIn("unitBWL->skills", tester)

    def test_skill_getters_do_not_wipe_ewram_on_read(self):
        skills = GET_SKILLS.read_text(encoding="utf-8")
        tester = SKILL_TESTER_C.read_text(encoding="utf-8")
        self.assertNotIn("EnsureLearnedSkillRam.zero", skills)
        self.assertNotIn("LearnedSkillRamSize", skills)
        self.assertNotIn("for (int i = 0; i < 4 + LEARNED_SLOTS_SIZE + 0x46", tester)

    def test_tutorial_lyn_level_list_is_critup(self):
        lists = LYN_LIST.read_text(encoding="utf-8")
        csv = CHAR_LEVEL_CSV.read_text(encoding="utf-8")
        self.assertIn("LevelUpSkill(1, CritUpID)", lists)
        self.assertNotIn("CantoID", lists)
        self.assertNotIn("LockTouchID", lists)
        self.assertIn("LynTutorialSkillList", csv.splitlines()[4])


if __name__ == "__main__":
    unittest.main()
