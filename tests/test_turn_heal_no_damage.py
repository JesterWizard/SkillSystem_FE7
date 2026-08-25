"""Regression coverage for full-health turn-heal animation suppression."""
from __future__ import annotations

import re
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SOURCE = (
    ROOT
    / "EngineHacks/Necessary/CalcLoops/HPRestorationCalcLoop/"
    "HPRestorationCalcLoop.s"
)


class TurnHealNoDamageTests(unittest.TestCase):
    def test_full_health_units_return_zero_before_restoration_modifiers(self):
        source = SOURCE.read_text(encoding="utf-8")
        self.assertRegex(
            source,
            re.compile(
                r"ldrb r2,\[r5,#0x12\].*?"
                r"ldrb r3,\[r5,#0x13\].*?"
                r"cmp r3,r2.*?"
                r"bge NoHealthToRestore",
                re.DOTALL,
            ),
        )


if __name__ == "__main__":
    unittest.main()
