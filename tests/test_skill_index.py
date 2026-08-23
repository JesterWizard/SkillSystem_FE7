"""Skill index tracks ID, category, live installer, and .s path."""
import unittest
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "Tools"))
from build_skill_index import (  # noqa: E402
    live_category_list,
    lookup,
    main as index_main,
    rows,
)

INSTALLER = ROOT / "EngineHacks" / "SkillSystem" / "Skills" / "MasterSkillInstaller.event"


class SkillIndexTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.rows = {r["macro"]: r for r in rows()}
        cls.live, cls.dead = live_category_list()

    def test_live_categories_match_installer(self):
        self.assertIn("AISkills", self.live)
        self.assertIn("PreBattleSkills", self.live)
        self.assertIn("StandaloneSkills/Bargain", self.live)
        self.assertIn("StandaloneSkills/Lunge", self.live)
        self.assertIn("StandaloneSkills", self.dead)
        self.assertIn("AuraSkills", self.dead)
        self.assertIn("PostActionSkills", self.dead)
        self.assertNotIn("charge_table.event", self.live)
        self.assertNotIn("charge_table.event", self.dead)

    def test_provoke_is_live_ai_skill(self):
        row = self.rows["ProvokeID"]
        self.assertEqual(row["id"], "43")
        self.assertEqual(row["off"], "no")
        self.assertEqual(row["category"], "AISkills")
        self.assertEqual(row["live"], "yes")
        self.assertTrue(row["source"].endswith("Provoke/Provoke.s"))

    def test_anathema_is_skill_off(self):
        row = self.rows["AnathemaID"]
        self.assertEqual(row["id"], "OFF")
        self.assertEqual(row["off"], "yes")
        self.assertEqual(row["category"], "AuraSkills")
        self.assertEqual(row["live"], "no")

    def test_blood_tide_is_skill_off(self):
        row = self.rows["BloodTideID"]
        self.assertEqual(row["id"], "OFF")
        self.assertEqual(row["off"], "yes")

    def test_bargain_live_lunge_live_other_standalone_dead(self):
        self.assertEqual(self.rows["BargainID"]["live"], "yes")
        self.assertEqual(self.rows["LungeID"]["live"], "yes")
        self.assertTrue(self.rows["LungeID"]["source"].endswith("Lunge/lunge.s"))
        triangle = self.rows.get("TriangleAttackID")
        if triangle is not None:
            self.assertEqual(triangle["live"], "no")

    def test_lookup_reads_event_files_not_the_markdown(self):
        by_name = lookup("Provoke")
        by_macro = lookup("AnathemaID")
        self.assertEqual(by_name["live"], "yes")
        self.assertEqual(by_macro["live"], "no")
        self.assertIsNone(lookup("NotARealSkill"))

    def test_skill_cli_prints_a_live_row(self):
        from contextlib import redirect_stdout
        from io import StringIO

        buf = StringIO()
        with redirect_stdout(buf):
            rc = index_main(["--skill", "ProvokeID"])
        self.assertEqual(rc, 0)
        out = buf.getvalue()
        self.assertIn("live=yes", out)
        self.assertIn("ProvokeID", out)


if __name__ == "__main__":
    unittest.main()
