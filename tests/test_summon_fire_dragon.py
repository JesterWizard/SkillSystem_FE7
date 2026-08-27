"""Source-level wiring for the FE7 Fire Dragon summon.

FE7 has no summon of its own.  The entries _UnitMenuDefs.event labels
UM_Summon / UM_Summon_DK are Give and Take (their selection handler at
0x08021874 writes action id 0x0C), and the ids in UnitActionRework's table are
FE8's.  So the command is built on FE7's tile-selection path -- Drop -- and its
action rides FE7's own ApplyUnitAction through a free action id.

These checks are about *which engine seams* the skill attaches to.  What the
code actually computes is asserted by the execution tests.
"""
from pathlib import Path
import unittest


ROOT = Path(__file__).resolve().parents[1]
SUMMON = ROOT / "EngineHacks/SkillSystem/Skills/UnitMenuSkills/Summon"
ACTION = SUMMON / "SummonAction.s"
USABILITY = SUMMON / "NewSummonUsability.s"
MENU = ROOT / "EngineHacks/Necessary/UnitMenu/UnitMenu.event"
SKILLS_MENU = ROOT / "EngineHacks/SkillSystem/Skills/UnitMenuSkills/UnitMenuSkills.event"
SKILLS_SUBMENU = ROOT / "EngineHacks/SkillSystem/Skills/UnitMenuSkills/SkillsMenu.event"
ACTION_REWORK = ROOT / "EngineHacks/Necessary/UnitActionRework/UnitActionRework.event"
TEXT = ROOT / "Text/unitmenu_text.txt"


class SummonFireDragonWiringTests(unittest.TestCase):
    def setUp(self):
        self.action = ACTION.read_text(encoding="utf-8")
        self.usability = USABILITY.read_text(encoding="utf-8")
        self.installer = SKILLS_MENU.read_text(encoding="utf-8")

    def test_command_lives_in_the_skills_menu_with_its_own_hover(self):
        self.assertNotIn("NewSummonUsability", MENU.read_text(encoding="utf-8"))
        self.assertIn(
            "SkillsMenuCommand(SkillMenuName97, UM_SummonName, UM_SummonDesc, "
            "$7F, NewSummonUsability, SummonEffect, SummonHover, SummonUnhover)",
            SKILLS_SUBMENU.read_text(encoding="utf-8"),
        )

    def test_text_entries_exist_for_name_description_and_prompt(self):
        text = TEXT.read_text(encoding="utf-8")
        for label in ("## UM_SummonName", "## UM_SummonDesc", "## UM_SummonSelect"):
            with self.subTest(label=label):
                self.assertIn(label, text)

    def test_action_hangs_off_fe7s_own_dispatch_table(self):
        """Not UnitActionRework: that table is FE8 data and is not installed."""
        self.assertIn("ORG ($2F248 + 4*(5-1))", self.installer)
        self.assertIn("POIN SummonActionEntry", self.installer)
        rework = ACTION_REWORK.read_text(encoding="utf-8")
        self.assertNotIn("SummonAction", rework)

    def test_the_chosen_action_id_is_one_vanilla_fe7_never_writes(self):
        """0x05 has no writer in FE7 and its table slot is the default stub.

        0x07/0x08 are Give and Take despite the FE8-derived comments, so taking
        either would hijack a live command.
        """
        self.assertIn(".equ SummonActionID,         0x05", self.action)

    def test_selected_tile_avoids_the_movement_fields(self):
        """gActionData +0x0E/+0x0F is where PlayerPhase moves the summoner to.

        Writing the summon tile there teleports the summoner onto it.  FE7's own
        tile-target command (DropSelection_OnSelect) uses +0x13/+0x14 instead.
        """
        select = self.action.split("SummonSelect_OnSelect:", 1)[1]
        select = select.split("SummonActionEntry:", 1)[0]
        self.assertIn("strb r0,[r2,#0x13]", select)
        self.assertIn("strb r0,[r2,#0x14]", select)
        self.assertNotIn("#0x0E", select)
        self.assertNotIn("#0x0F", select)

    def test_action_entry_unwinds_applyunitactions_frame(self):
        """ApplyUnitAction enters handlers with `mov pc`, sharing its frame."""
        entry = self.action.split("SummonActionEntry:", 1)[1]
        entry = entry.split("SummonAction:", 1)[0]
        self.assertIn("pop {r4,r5}", entry)
        self.assertIn("pop {r1}", entry)

    def test_selection_callbacks_keep_the_thumb_bit(self):
        """NewTargetSelection reaches them through `bx`, so bit 0 must be set."""
        table = self.action.split("SummonTargetSelection:", 1)[1]
        for name in (
            "SummonSelect_OnInit",
            "SummonSelect_OnEnd",
            "SummonSelect_OnSwitchIn",
            "SummonSelect_OnSelect",
        ):
            with self.subTest(callback=name):
                self.assertIn(f".word {name}+1", table)

    def test_highlight_uses_the_blue_movement_layer(self):
        """0x08019454 draws blue from the movement map and only reads the range
        map when the movement byte is negative, so blue needs both halves."""
        show = self.action.split("SummonShowRange:", 1)[1]
        show = show.split("SummonHover:", 1)[0]
        self.assertIn("ppMapMovement", show)
        self.assertIn("mov r0,#1                   @ blue movement squares only", show)

    def test_summon_ids_are_configurable_from_the_installer(self):
        for define, value in (
            ("SUMMON_CHARACTER_ID", "0x86"),
            ("SUMMON_CLASS_ID", "0x46"),
            ("SUMMON_ITEM_ID", "0x8F"),
        ):
            with self.subTest(define=define):
                self.assertIn(f"#define {define} {value}", self.installer)
        for word in (
            "WORD SUMMON_CHARACTER_ID",
            "WORD SUMMON_CLASS_ID",
            "WORD SUMMON_ITEM_ID",
            "WORD UM_SummonSelect",
        ):
            with self.subTest(word=word):
                self.assertIn(word, self.installer)

    def test_old_dragons_and_chapter_end_are_cleaned(self):
        self.assertIn("SummonClearAll", self.action)
        # Only the player block, so an enemy dragon of the same character stays.
        self.assertIn(".equ LastPlayerUnitID,       0x40", self.action)
        self.assertIn("replaceWithHack(SummonSetNextChapter)", self.installer)

    def test_usability_builds_the_tile_list_and_respects_having_acted(self):
        self.assertIn("blh SummonMakeTargetList,r3", self.usability)
        self.assertIn("GetTargetListSize,0x0804B175", self.usability)
        self.assertIn("mov r1,#0x40", self.usability)


if __name__ == "__main__":
    unittest.main()
