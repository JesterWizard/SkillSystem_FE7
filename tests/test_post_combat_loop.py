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
        defender_fail = src.split("=Defender", 1)
        self.assertGreater(len(defender_fail), 1)
        self.assertIn("RunSkills", defender_fail[1].split("Loop:", 1)[0])

    def test_actor_and_defender_stay_unit_pointers(self):
        """Post-combat skills read the actor through r4 and the defender
        through r5 using Unit offsets (curHP +0x13, state +0x0C, index +0x0B),
        and canto.s writes US_CANTO_PENDING back to [r4,#0x0C]. Converting
        either to a CharacterData pointer sends that write into ROM."""
        src = POST.read_text(encoding="utf-8")
        self.assertNotIn("blh	GetCharPtr", src)
        self.assertNotIn("mov	r4, r0", src)

    def test_event_uses_relocatable_loop_object(self):
        event = EVENT.read_text(encoding="utf-8")
        self.assertIn("post_loop.lyn.event", event)
        self.assertNotIn("post_loop.dmp", event)


if __name__ == "__main__":
    unittest.main()
