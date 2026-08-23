"""assemble() and symbol_offsets() must share one assembler pass per source file.

Every execution test calls both, and many call them again per method. Spawning
arm-none-eabi-as twice for the same .s is the bulk of pre-assemble time.
"""
import subprocess
import tempfile
import unittest
from pathlib import Path
from unittest import mock

ROOT = Path(__file__).resolve().parents[1]

TINY_THUMB = ".thumb\n.global Foo\nFoo:\n\tbx lr\n"


class AssembleCacheTests(unittest.TestCase):
    def test_assemble_and_symbol_offsets_share_one_as_invocation(self):
        from Tools import thumb_harness as th

        if not th.AS.is_file():
            raise unittest.SkipTest("devkitARM not installed")

        with tempfile.TemporaryDirectory() as tmp:
            src = Path(tmp) / "cache_probe.s"
            src.write_text(TINY_THUMB, encoding="utf-8")
            as_calls = []
            real_run = subprocess.run

            def spy(cmd, *args, **kwargs):
                if cmd and "arm-none-eabi-as" in str(cmd[0]):
                    as_calls.append(cmd)
                return real_run(cmd, *args, **kwargs)

            with mock.patch.object(th.subprocess, "run", side_effect=spy):
                code = th.assemble(src)
                offsets = th.symbol_offsets(src)

        self.assertEqual(len(as_calls), 1, as_calls)
        self.assertTrue(code)
        self.assertIn("Foo", offsets)


if __name__ == "__main__":
    unittest.main()
