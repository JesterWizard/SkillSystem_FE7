"""The runner must put ROM-loading tests in --rom, even when load() is in a helper."""
import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import run_tests  # noqa: E402


def _cases(modname):
    loader = unittest.TestLoader()
    return list(run_tests._flatten(loader.loadTestsFromName(modname)))


class PhaseSplitTests(unittest.TestCase):
    def test_hurricane_execution_is_rom_phase(self):
        cases = _cases("test_hurricane_execution")
        self.assertTrue(cases)
        missed = [run_tests._label(t) for t in cases if not run_tests.needs_built_rom(t)]
        self.assertEqual(missed, [])

    def test_chargeplus_execution_is_source_phase(self):
        cases = _cases("test_chargeplus_execution")
        self.assertTrue(cases)
        rom = [run_tests._label(t) for t in cases if run_tests.needs_built_rom(t)]
        self.assertEqual(rom, [])


if __name__ == "__main__":
    unittest.main()
