"""DEC-95: twelve doubling skills enabled and wired into CanUnitDoubleCalcLoop."""
from __future__ import annotations

import re
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from Tools.thumb_harness import Harness, assemble, symbol_offsets

DEFS = ROOT / "EngineHacks/SkillSystem/skill_definitions.event"
MASTER = ROOT / "EngineHacks/SkillSystem/Skills/MasterSkillInstaller.event"
LOOP = (
    ROOT
    / "EngineHacks/Necessary/CalcLoops/CanUnitDoubleCalcLoop/CanUnitDoubleCalcLoop.event"
)
UNWIND = (
    ROOT
    / "EngineHacks/Necessary/CalcLoops/CanUnitDoubleCalcLoop/NewBattleGetFollowUpOrder.c"
)
HOOKS = (
    ROOT
    / "EngineHacks/Necessary/CalcLoops/CanUnitDoubleCalcLoop/Hooks.s"
)
LOOP_DEFS = (
    ROOT
    / "EngineHacks/Necessary/CalcLoops/CanUnitDoubleCalcLoop/Definitions.s"
)
ICONS = ROOT / "EngineHacks/SkillSystem/skill_icons.event"
HACK = ROOT / "FE7_Hack.gba"
FORECAST_STATS = 0x0803351C
WARY = (
    ROOT
    / "EngineHacks/SkillSystem/Skills/UnitDoublingSkills/WaryFighter/WaryFighter.s"
)
MOON = (
    ROOT
    / "EngineHacks/SkillSystem/Skills/UnitDoublingSkills/Moonlight/Moonlight.s"
)
BUILD_ASM = ROOT / "Tools/build_skill_asm.py"

SKILL_OFF = 255
IDS = {
    "WaryFighterID": 213,
    "MoonlightID": 214,
    "RecklessFighterID": 215,
    "LastWordID": 216,
    "BoldFighterID": 217,
    "VengefulFighterID": 218,
    "QuickLearnerID": 219,
    "PassionsFlowID": 220,
    "BidingBlowID": 221,
    "AdvantageChaserID": 222,
    "PridefulWarriorID": 223,
    "QuickRiposteID": 224,
}

LOOP_POINS = (
    "IsAttackerWeaponUnableToDouble",
    "WaryFighter",
    "MoonlightDoublingFunc",
    "QuickRiposte",
    "RecklessFighter",
    "PridefulWarrior",
    "BoldFighter",
    "VengefulFighter",
    "AdvantageChaser",
    "LastWord",
    "QuickLearner",
    "PassionsFlow",
    "BidingBlow",
)

C_FUNCS = (
    "BidingBlow",
    "PassionsFlow",
    "QuickLearner",
    "BoldFighter",
    "QuickRiposte",
    "VengefulFighter",
    "LastWord",
    "PridefulWarrior",
    "RecklessFighter",
    "AdvantageChaser",
)


def _active(path: Path) -> str:
    return "\n".join(
        line
        for line in path.read_text(encoding="utf-8").splitlines()
        if not line.lstrip().startswith("//")
    )


def _macro(name: str) -> str:
    match = re.search(rf"^#define {name} (\S+)", DEFS.read_text(encoding="utf-8"), re.M)
    if match is None:
        raise AssertionError(f"{name} missing")
    return match.group(1)


def _run_double_func(src: Path, skill_present: bool) -> int:
    code = assemble(src)
    offs = symbol_offsets(src)
    h = Harness(code, skill_present=skill_present)
    regs = h.run(offs["GoBack"], regs={"r0": 0x0203A3F0, "r1": 0x0203A470})
    return regs["r0"]


class DoublingSkillWiringTests(unittest.TestCase):
    def test_ids_are_enabled(self):
        for name, sid in IDS.items():
            self.assertEqual(_macro(name), str(sid), name)
            self.assertNotEqual(sid, SKILL_OFF)

    def test_unit_doubling_category_is_live(self):
        self.assertIn("UnitDoublingSkills/UnitDoublingSkills.event", _active(MASTER))

    def test_calc_loop_lists_doubling_skills(self):
        text = _active(LOOP)
        self.assertIn("NewBattleGetFollowUpOrder.lyn.event", text)
        for name in LOOP_POINS:
            self.assertRegex(text, rf"\bPOIN\b.*\b{name}\b", name)

    def test_c_skills_are_defined(self):
        src = UNWIND.read_text(encoding="utf-8")
        for name in C_FUNCS:
            self.assertRegex(src, rf"\bint {name}\s*\(", name)

    def test_c_source_is_rebuilt_by_skill_asm(self):
        text = BUILD_ASM.read_text(encoding="utf-8")
        self.assertIn("NewBattleGetFollowUpOrder.c", text)

    def test_passions_flow_does_not_pass_null_bonuses(self):
        src = UNWIND.read_text(encoding="utf-8")
        self.assertNotRegex(src, r"struct SupportBonuses\s*\*\s*bonuses\s*=\s*0")
        self.assertRegex(src, r"struct SupportBonuses\s+bonuses")

    def test_get_eff_lvl_uses_flag_tests_not_bit_magnitude(self):
        src = UNWIND.read_text(encoding="utf-8")
        self.assertNotRegex(src, r"10\s*\*\s*\(\s*attrb\s*&")
        self.assertNotRegex(src, r"20\s*\*\s*\(\s*attrb\s*&")
        self.assertIn("CA_PROMOTED", src)
        self.assertIn("CA_MAXLEVEL10", src)

    def test_quick_learner_only_when_attacking(self):
        src = UNWIND.read_text(encoding="utf-8")
        body = re.search(
            r"int QuickLearner\s*\(.*?\n\}", src, re.S
        ).group(0)
        self.assertIn("gBattleActor", body)

    def test_prideful_warrior_swaps_unwind_order(self):
        src = UNWIND.read_text(encoding="utf-8")
        self.assertIn("PridefulWarriorID_Link", src)
        self.assertIn("gBattleTarget", src)
        self.assertIn("gBattleActor", src)

    def test_forecast_hook_counts_both_follow_ups(self):
        hooks = HOOKS.read_text(encoding="utf-8")
        self.assertRegex(
            hooks,
            r"SET_FUNC\s+NewInitBattleForecastBattleStats,\s*0x0*803351D",
        )
        src = UNWIND.read_text(encoding="utf-8")
        self.assertIn("followUp == BothFollowUp", src)
        self.assertIn("hitCountB", src)

    def test_forecast_uses_fe7_item_effectiveness(self):
        src = UNWIND.read_text(encoding="utf-8")
        body = re.search(
            r"void NewInitBattleForecastBattleStats\s*\(.*?\n\}\s*$",
            src,
            re.S | re.M,
        )
        self.assertIsNotNone(body)
        self.assertNotIn("IsUnitEffectiveAgainst", body.group(0))
        defs = LOOP_DEFS.read_text(encoding="utf-8")
        self.assertRegex(
            defs,
            r"SET_FUNC\s+IsItemEffectiveAgainst,\s*0x0*8016821",
        )

    def test_last_word_and_biding_blow_use_wip_icon(self):
        icons = ICONS.read_text(encoding="utf-8")
        self.assertRegex(
            icons,
            r"ORG SkillIcon\(LastWordID\)\s*\n#incbin \"SkillIcons/WIP.dmp\"",
        )
        self.assertRegex(
            icons,
            r"ORG SkillIcon\(BidingBlowID\)\s*\n#incbin \"SkillIcons/WIP.dmp\"",
        )

    def test_passions_flow_uses_fe7_support_bonuses(self):
        defs = LOOP_DEFS.read_text(encoding="utf-8")
        self.assertRegex(
            defs,
            r"SET_FUNC\s+GetUnitSupportBonuses,\s*0x0*8026A19",
        )
        self.assertNotRegex(defs, r"SET_FUNC\s+GetUnitSupportBonuses,\s*0x80285B1")


class WaryFighterExecutionTests(unittest.TestCase):
    def test_skill_present_forbids_double(self):
        self.assertEqual(_run_double_func(WARY, True), 0)

    def test_skill_absent_no_change(self):
        self.assertEqual(_run_double_func(WARY, False), 2)


class MoonlightDoublingExecutionTests(unittest.TestCase):
    def test_skill_present_forbids_double(self):
        self.assertEqual(_run_double_func(MOON, True), 0)

    def test_skill_absent_no_change(self):
        self.assertEqual(_run_double_func(MOON, False), 2)


if __name__ == "__main__":
    unittest.main()
