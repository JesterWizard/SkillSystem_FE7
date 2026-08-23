"""Post-combat loop must use the active unit pointer, not IWRAM at +0x1A."""
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
POST = (
    ROOT
    / "EngineHacks"
    / "Necessary"
    / "CalcLoops"
    / "PostBattleCalcLoop"
    / "post_loop.s"
)
EVENT = POST.with_name("PostBattleCalcLoop.event")


class PostCombatLoopTests(unittest.TestCase):
    def test_loads_active_unit_pointer_before_deployment_id(self):
        src = POST.read_text(encoding="utf-8")
        self.assertRegex(src, r"ldr\s+r4,\s*\[r4\]")
        self.assertRegex(src, r"#0x0B")
        self.assertNotRegex(src, r"#0x1A")

    def test_wait_sets_acted_flag_before_skill_loop(self):
        src = POST.read_text(encoding="utf-8")
        before_skills = src.split("PostCombatSkills", 1)[0]
        self.assertRegex(before_skills, r"#0x0C")
        self.assertRegex(before_skills, r"orr")
        self.assertIn("UNIT_ACTION_WAIT", before_skills)

    def test_wait_does_not_run_post_combat_skills(self):
        src = POST.read_text(encoding="utf-8")
        self.assertIn("#0x11", src)
        self.assertIn("UNIT_ACTION_WAIT", src)
        self.assertNotIn("UpdateUnitSMS", src)
        self.assertNotIn("0x08019BE0", src)

    def test_item_and_staff_reach_the_skill_loop(self):
        src = POST.read_text(encoding="utf-8")
        after_wait = src.split("UNIT_ACTION_WAIT", 1)[1]
        self.assertIn("PostCombatSkills", after_wait)
        self.assertNotIn("beq	End\nldr	r7, =PostCombatSkills", src)
        self.assertIn("RunSkills", src)

    def test_missing_defender_still_runs_canto_skills(self):
        src = POST.read_text(encoding="utf-8")
        self.assertIn("RunSkills", src)
        defender_fail = src.split("ldr	r5, =Defender", 1)
        self.assertGreater(len(defender_fail), 1)
        self.assertIn("RunSkills", defender_fail[1].split("Loop:", 1)[0])

    def test_event_uses_relocatable_loop_object(self):
        event = EVENT.read_text(encoding="utf-8")
        self.assertIn("post_loop.lyn.event", event)
        self.assertNotIn("post_loop.dmp", event)


if __name__ == "__main__":
    unittest.main()
