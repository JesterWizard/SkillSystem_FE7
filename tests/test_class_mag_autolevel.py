"""Str/Mag ClassMagAutolevel must not push lr before bx-return into UnitAutolevelCore."""
import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SRC = (
    ROOT
    / "EngineHacks"
    / "ExternalHacks"
    / "StrMagSplit"
    / "StrMagSplit"
    / "AutolevellingSaves"
    / "ClassMagAutolevel.s"
)
DMP = SRC.with_suffix(".dmp")


class ClassMagAutolevelTests(unittest.TestCase):
    def test_source_does_not_push_lr(self):
        text = SRC.read_text(encoding="utf-8")
        self.assertIsNone(re.search(r"^\s*push\s*\{[^}]*r14", text, re.M))
        self.assertIsNone(re.search(r"^\s*push\s*\{[^}]*lr", text, re.M | re.I))
        self.assertRegex(text, r"\bbx\s+r2\b")
        self.assertIn("ReturnAddr", text)

    def test_dmp_does_not_start_with_push(self):
        data = DMP.read_bytes()
        self.assertGreaterEqual(len(data), 0x30)
        self.assertNotEqual(data[1], 0xB5)


if __name__ == "__main__":
    unittest.main()
