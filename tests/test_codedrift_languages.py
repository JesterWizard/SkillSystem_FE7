"""CodeDrift FE7 adapters extract Thumb labels and EA defines."""
import unittest
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "Tools"))

PROVOKE = ROOT / "EngineHacks" / "SkillSystem" / "Skills" / "AISkills" / "Provoke" / "Provoke.s"
DEFS = ROOT / "EngineHacks" / "SkillSystem" / "skill_definitions.event"


def _adapters():
    try:
        from codedrift_languages import EventAdapter, ThumbAdapter
    except ImportError as exc:
        raise unittest.SkipTest(f"codedrift not installed: {exc}") from exc
    return EventAdapter, ThumbAdapter


class Fe7LanguageAdapterTests(unittest.TestCase):
    def test_thumb_adapter_finds_provoke_label(self):
        _EventAdapter, ThumbAdapter = _adapters()
        lines = PROVOKE.read_text(encoding="utf-8").splitlines()
        symbols = ThumbAdapter().extract_symbols(None, lines, "Provoke.s")
        names = {s.name for s in symbols}
        self.assertIn("SkillTester", names)

    def test_event_adapter_finds_skill_id_define(self):
        EventAdapter, _ThumbAdapter = _adapters()
        lines = DEFS.read_text(encoding="utf-8").splitlines()
        symbols = EventAdapter().extract_symbols(None, lines, "skill_definitions.event")
        names = {s.name for s in symbols}
        self.assertIn("ProvokeID", names)
        self.assertIn("SKILL_OFF", names)


if __name__ == "__main__":
    unittest.main()
