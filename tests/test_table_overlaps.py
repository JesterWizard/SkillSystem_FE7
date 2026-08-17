"""Guardrail: SkillScroll vanilla slot must not land in mov-cost tables."""
import subprocess
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SCRIPT = ROOT / "Tests" / "scripts" / "check_table_overlaps.py"


class TableOverlapTests(unittest.TestCase):
    def test_skill_scroll_vanilla_slot_overlaps_mov_costs(self):
        # Documents the hazard: in-place 0x9F must be rejected.
        proc = subprocess.run(
            [
                sys.executable,
                str(SCRIPT),
                "--base",
                "0xBE222C",
                "--size",
                "0x24",
                "--id",
                "0x9F",
            ],
            capture_output=True,
            text=True,
            check=False,
        )
        self.assertEqual(proc.returncode, 1, proc.stdout + proc.stderr)
        self.assertIn("OVERLAP", proc.stdout)

    def test_vanilla_last_item_ok(self):
        proc = subprocess.run(
            [
                sys.executable,
                str(SCRIPT),
                "--base",
                "0xBE222C",
                "--size",
                "0x24",
                "--id",
                "0x9A",
            ],
            capture_output=True,
            text=True,
            check=False,
        )
        self.assertEqual(proc.returncode, 0, proc.stdout + proc.stderr)


if __name__ == "__main__":
    unittest.main()
