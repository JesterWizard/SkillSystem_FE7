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

    def test_wait_sets_acted_flag_before_combat_check(self):
        src = POST.read_text(encoding="utf-8")
        before_combat = src.split("cmp	r0, #UNIT_ACTION_COMBAT", 1)
        if len(before_combat) == 1:
            before_combat = src.split("cmp r0, #UNIT_ACTION_COMBAT", 1)
        before_combat = before_combat[0]
        self.assertRegex(before_combat, r"#0x0C")
        self.assertRegex(before_combat, r"orr")
        self.assertNotIn("PostCombatSkills", before_combat)

    def test_wait_does_not_run_post_combat_skills(self):
        src = POST.read_text(encoding="utf-8")
        self.assertIn("#0x11", src)
        self.assertIn("UNIT_ACTION_COMBAT", src)
        self.assertNotIn("UpdateUnitSMS", src)
        self.assertNotIn("0x08019BE0", src)

    def test_event_uses_relocatable_loop_object(self):
        event = EVENT.read_text(encoding="utf-8")
        self.assertIn("post_loop.lyn.event", event)
        self.assertNotIn("post_loop.dmp", event)


if __name__ == "__main__":
    unittest.main()
