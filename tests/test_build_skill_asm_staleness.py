"""The .lyn.event freshness check must not treat an equal mtime as up to date.

build_skill_asm.py skips assembling when the .lyn.event looks newer than its
.s. The comparison used `<`, so a source edit and a rebuild landing in the same
filesystem timestamp tick read as "fresh" -- the blob kept stale code, the build
printed success, and the ROM silently shipped the old routine. Windows makes
this easy to hit: NTFS mtime granularity is coarse relative to how fast an edit
can be followed by a build.

These are pure mtime-arithmetic tests over stale(); they do not assemble.
"""
import os
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))


def _stale():
    try:
        from Tools.build_skill_asm import stale
    except ImportError as exc:
        raise unittest.SkipTest(f"build_skill_asm unavailable: {exc}")
    return stale


class Staleness(unittest.TestCase):
    def setUp(self):
        import tempfile
        self.stale = _stale()
        self._tmp = tempfile.TemporaryDirectory()
        self.d = Path(self._tmp.name)
        self.src = self.d / "Skill.s"
        self.out = self.d / "Skill.lyn.event"
        self.src.write_text("@ source\n")
        self.out.write_text("// blob\n")

    def tearDown(self):
        self._tmp.cleanup()

    def touch(self, path, when):
        os.utime(path, (when, when))

    def test_equal_mtime_is_stale(self):
        """The regression: same tick must rebuild, not be assumed fresh."""
        self.touch(self.src, 1_000_000)
        self.touch(self.out, 1_000_000)
        self.assertTrue(self.stale(self.src, self.out))

    def test_older_output_is_stale(self):
        self.touch(self.src, 1_000_000)
        self.touch(self.out, 999_000)
        self.assertTrue(self.stale(self.src, self.out))

    def test_newer_output_is_fresh(self):
        """The other branch: a genuinely newer blob must still be skipped."""
        self.touch(self.src, 1_000_000)
        self.touch(self.out, 1_000_001)
        self.assertFalse(self.stale(self.src, self.out))

    def test_missing_output_is_stale(self):
        self.out.unlink()
        self.assertTrue(self.stale(self.src, self.out))

    def test_any_stale_output_restales_all(self):
        second = self.d / "Skill.dmp"
        second.write_text("x")
        self.touch(self.src, 1_000_000)
        self.touch(self.out, 1_000_001)
        self.touch(second, 1_000_000)
        self.assertTrue(self.stale(self.src, self.out, second))


if __name__ == "__main__":
    unittest.main()
