"""Skill index tracks ID, category, live installer, and file pack."""
import json
import unittest
from contextlib import redirect_stdout
from io import StringIO
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "Tools"))
from build_skill_index import (  # noqa: E402
    live_category_list,
    lookup,
    main as index_main,
    rewrite_prompt,
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
        buf = StringIO()
        with redirect_stdout(buf):
            rc = index_main(["--skill", "ProvokeID"])
        self.assertEqual(rc, 0)
        out = buf.getvalue()
        self.assertIn("live=yes", out)
        self.assertIn("ProvokeID", out)

    def test_nullify_file_pack_lists_event_and_asm(self):
        row = lookup("Nullify")
        self.assertIsNotNone(row)
        sources = row["sources"]
        self.assertTrue(any(p.endswith("EffectivenessSkills/Nullify.event") for p in sources))
        self.assertTrue(any(p.endswith("Effectiveness_Skills.s") for p in sources))
        self.assertEqual(row["folder"], "")
        self.assertTrue(
            row["installer"].endswith("EffectivenessSkills/EffectivenessSkills.event")
        )
        self.assertFalse(any(p.endswith("test_skill_index.py") for p in row["tests"]))

    def test_slayer_pack_includes_nullify_event(self):
        row = lookup("Slayer")
        self.assertTrue(any(p.endswith("EffectivenessSkills/Nullify.event") for p in row["sources"]))

    def test_skill_cli_json_pack(self):
        buf = StringIO()
        with redirect_stdout(buf):
            rc = index_main(["--skill", "Nullify", "--json"])
        self.assertEqual(rc, 0)
        data = json.loads(buf.getvalue())
        self.assertEqual(data["macro"], "NullifyID")
        self.assertTrue(any(p.endswith("Nullify.event") for p in data["sources"]))

    def test_prompt_rewrite_injects_nullify_pack(self):
        out = rewrite_prompt("please implement the Nullify skill thanks")
        self.assertIn("IMPLEMENT SKILL: Nullify", out)
        self.assertIn("NullifyID", out)
        self.assertIn("Nullify.event", out)
        self.assertIn("Documentation/skill-index.md", out)

    def test_prompt_rewrite_no_match(self):
        out = rewrite_prompt("refactor the build scripts")
        self.assertIn("NO_SKILL_MATCH", out)


if __name__ == "__main__":
    unittest.main()
