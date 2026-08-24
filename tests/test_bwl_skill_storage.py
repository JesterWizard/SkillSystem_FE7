"""Learned skills in unit->supports[]; support exp in gBwlSupportExp (DEC-59)."""
import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from lyn_bytes import lyn_to_bytes

ROOT = Path(__file__).resolve().parents[1]
INTERNALS = ROOT / "EngineHacks" / "SkillSystem" / "Internals"
REMOVE = ROOT / "EngineHacks" / "SkillSystem" / "RemoveSkillMenu"
EMS = ROOT / "EngineHacks" / "Necessary" / "ExpandedModularSave"

SOURCES = (
    INTERNALS / "addSkill.s",
    INTERNALS / "asm" / "GetSkills.s",
    REMOVE / "asm" / "GetSkillIdByIndex.s",
    REMOVE / "asm" / "ASMC" / "ASMC_ForgetSkill.s",
    REMOVE / "asm" / "Menu" / "MenuRemoveSkillCommand_ForgetEffect.s",
)

LYNS = (
    INTERNALS / "addSkill.lyn.event",
    INTERNALS / "asm" / "GetSkills.lyn.event",
    INTERNALS / "asm" / "BwlSupports.lyn.event",
)

BWL_TABLE = 0x0203E790
GBWL_SUPPORT = 0x0203FE10


class Fe7SupportSkillStorageTests(unittest.TestCase):
    def test_sources_use_unit_supports_not_bwl_for_skills(self):
        for path in SOURCES:
            text = path.read_text(encoding="utf-8")
            self.assertIn("UNIT_SUPPORTS", text, path.name)
            self.assertNotIn("BWLTable", text, path.name)
            self.assertNotIn("pBWLTable", text, path.name)
            self.assertNotIn("gBWLTable", text, path.name)

    def test_player_seven_other_six(self):
        add = (INTERNALS / "addSkill.s").read_text(encoding="utf-8")
        self.assertIn("LEARNED_SKILL_COUNT_PLAYER, 7", add)
        self.assertIn("LEARNED_SKILL_COUNT_OTHER, 6", add)
        skill_sys = (INTERNALS / "SkillSystem.event").read_text(encoding="utf-8")
        self.assertIn("#define MaxGenericLearnedSkills 7", skill_sys)

    def test_bwl_supports_module(self):
        text = (INTERNALS / "asm" / "BwlSupports.s").read_text(encoding="utf-8")
        self.assertIn("gBwlSupportExp = 0x0203FE10", text)
        self.assertIn("GetUnitSupportLevel_Bwl", text)
        self.assertIn("AddSupportPoints_Bwl", text)
        self.assertIn("InitBwlSupportsForUnit", text)
        skill_sys = (INTERNALS / "SkillSystem.event").read_text(encoding="utf-8")
        self.assertIn("jumpToHack(GetUnitSupportLevel_Bwl)", skill_sys)
        self.assertIn("jumpToHack(AddSupportPoints_Bwl)", skill_sys)

    def test_ems_chunk_declared(self):
        text = (EMS / "ExModularSave.event").read_text(encoding="utf-8")
        self.assertIn("SUD_SaveBwlSupports", text)
        self.assertIn("$01F0", text)

    def test_lyns_no_skill_bwl_base(self):
        want_bwl = BWL_TABLE.to_bytes(4, "little")
        want_sup = GBWL_SUPPORT.to_bytes(4, "little")
        for path in LYNS[:2]:
            data = lyn_to_bytes(path)
            self.assertNotIn(want_bwl, data, path.name)
        bwl_lyn = lyn_to_bytes(LYNS[2])
        self.assertIn(want_sup, bwl_lyn)

    def test_debugger_skills_and_supports_split(self):
        debugger = (
            ROOT / "EngineHacks" / "ExternalHacks" / "VeslyDebugger" / "Data" / "FE6_FE7.c"
        ).read_text(encoding="utf-8")
        self.assertIn("#define LearnedSkillCount 7", debugger)
        self.assertIn("return unit->supports", debugger)
        self.assertIn("gBwlSupportExp", debugger)
        self.assertIn("GetUnitBwlSupportRow", debugger)
        self.assertIn("return 6; /* keep supports[6] leader */", debugger)
        c_code = (
            ROOT / "EngineHacks" / "ExternalHacks" / "VeslyDebugger" / "C_Code.c"
        ).read_text(encoding="utf-8")
        self.assertIn("gBwlSupportExp", c_code)
        self.assertIn("GetUnitBwlSupportRow", c_code)
        self.assertNotIn("proc->tmp[i] = unit->supports[i]", c_code)
        self.assertIn("int limit = GetUnitLearnedSkillLimit(proc->unit)", debugger)
        self.assertIn("h = (limit * 2) + 2", debugger)
        lyn = (
            ROOT / "EngineHacks" / "ExternalHacks" / "VeslyDebugger" / "Data" / "FE7.lyn.event"
        ).read_text(encoding="utf-8")
        self.assertIn("SaveLearnedSkills:", lyn)
        self.assertIn("EditSkillsInit:", lyn)

    def test_debugger_support_names_follow_fe7_clone_chars(self):
        """Lyn 0x03 has NULL pSupportData; names live on clone 0x2D (same nameTextId)."""
        debugger = (
            ROOT / "EngineHacks" / "ExternalHacks" / "VeslyDebugger" / "Data" / "FE6_FE7.c"
        ).read_text(encoding="utf-8")
        self.assertIn("GetUnitSupportDataForDebug", debugger)
        self.assertIn("other->nameTextId == ch->nameTextId", debugger)
        self.assertIn("other->pSupportData", debugger)

    def test_getters_stop_at_first_empty_slot(self):
        skills = (INTERNALS / "asm" / "GetSkills.s").read_text(encoding="utf-8")
        tester = (
            INTERNALS / "NewSkillTester" / "_src" / "SkillTester.c"
        ).read_text(encoding="utf-8")
        self.assertIn("beq end_learned", skills)
        self.assertIn("unit->supports", tester)
        self.assertIn("0xC0", tester)


if __name__ == "__main__":
    unittest.main()
