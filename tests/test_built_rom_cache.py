"""built_rom.load() must not re-read FE7_Hack.gba on every call.

ROM-phase tests each open the 32MB image. One process-wide cache is enough:
MAKE_HACK runs this suite in a fresh interpreter after assemble.
"""
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

sys.path.insert(0, str(Path(__file__).resolve().parent))
import built_rom  # noqa: E402


class BuiltRomCacheTests(unittest.TestCase):
    def test_load_returns_the_same_bytes_object(self):
        """Needs the assembled FE7_Hack.gba."""
        first = built_rom.load()
        second = built_rom.load()
        self.assertTrue(first is second)


if __name__ == "__main__":
    unittest.main()
