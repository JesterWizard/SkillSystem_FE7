"""Executes HoardersBane's FindItemInConvoy under a real Thumb CPU emulator and
asserts it sees every slot of the 200-item expanded convoy.

The skill used to derive its convoy size with

    .equ ConvoySize, 0x802E7B8
    ldr r3, =ConvoySize ; ldrb r3, [r3]

but 0x802E7B8 is not a variable: per the decomp it is the `cmp r3, #0x63`
instruction inside AddItemToConvoy. The code was scraping that opcode's
immediate byte and using it as the slot count. It happened to read 0x63 (99) in
vanilla, and ExpandedConvoy.event patches the same immediate to 0xC7 (199) for
its 200-slot convoy -- so the scan covered slots 0..198 and the final slot was
invisible to both the search and the post-use pack-down loop.

A source-text or pointer-structure check cannot catch this: the instructions
look entirely reasonable and the convoy pointer repoint is genuinely correct.
Only executing the loop against a seeded 200-slot buffer shows slot 199 coming
back "not found".
"""
import struct
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

SRC = ROOT / "EngineHacks/SkillSystem/Skills/TurnSkills/HoardersBane.s"

CONVOY_BASE = 0x0203B200   # ConvoyExpansionRAM, per ExpandedConvoy.event
CONVOY_PTR_LITERAL = 0x0802E7B0  # real literal-pool slot holding &convoy
CONVOY_SLOTS = 200         # ConvoyItemCount, per ExpandedConvoy.event
VULNERARY = 0x1F
NOT_FOUND = -1


def _require():
    try:
        from Tools.thumb_harness import Harness, assemble, symbol_offsets  # noqa
    except ImportError as exc:  # unicorn not installed
        raise unittest.SkipTest(f"thumb harness unavailable: {exc}")
    from Tools.thumb_harness import AS
    if not Path(AS).exists():
        raise unittest.SkipTest("devkitARM not installed")


class HoardersBaneConvoyScan(unittest.TestCase):
    """FindItemInConvoy is a local label, so export it on a scratch copy."""

    @classmethod
    def setUpClass(cls):
        _require()
        if not SRC.exists():
            raise unittest.SkipTest(f"missing {SRC}")
        import re
        import tempfile
        from Tools.thumb_harness import assemble, symbol_offsets

        src = SRC.read_bytes()
        for label in (b"FindItemInConvoy", b"ExitFoundInConvoy"):
            src = re.sub(rb"(?m)^" + label + rb":",
                         b".global " + label + b"\n" + label + b":", src, count=1)
        cls._tmp = tempfile.TemporaryDirectory()
        probe = Path(cls._tmp.name) / "hb_probe.s"
        probe.write_bytes(src)
        cls.code = assemble(probe)
        cls.offsets = symbol_offsets(probe)

    @classmethod
    def tearDownClass(cls):
        if hasattr(cls, "_tmp"):
            cls._tmp.cleanup()

    def find(self, slot=None):
        """Return FindItemInConvoy's r0 for a convoy holding a vulnerary at `slot`."""
        from Tools.thumb_harness import Harness

        h = Harness(self.code)
        h.seed(CONVOY_PTR_LITERAL, struct.pack("<I", CONVOY_BASE))
        buf = bytearray(2 * (CONVOY_SLOTS + 16))  # slack so overrun is visible, not a fault
        if slot is not None:
            struct.pack_into("<H", buf, 2 * slot, (30 << 8) | VULNERARY)
        h.seed(CONVOY_BASE, bytes(buf))
        regs = h.run(self.offsets["ExitFoundInConvoy"],
                     regs={"r0": VULNERARY},
                     entry_offset=self.offsets["FindItemInConvoy"])
        r0 = regs["r0"]
        return r0 - (1 << 32) if r0 >= (1 << 31) else r0

    def test_finds_vulnerary_in_last_slot(self):
        """The regression: slot 199 was unreachable with the scraped size."""
        self.assertEqual(self.find(CONVOY_SLOTS - 1), 2 * (CONVOY_SLOTS - 1))

    def test_finds_vulnerary_across_the_boundary(self):
        for slot in (CONVOY_SLOTS - 3, CONVOY_SLOTS - 2, CONVOY_SLOTS - 1):
            with self.subTest(slot=slot):
                self.assertEqual(self.find(slot), 2 * slot)

    def test_finds_vulnerary_in_first_and_middle_slots(self):
        self.assertEqual(self.find(0), 0)
        self.assertEqual(self.find(1), 2)
        self.assertEqual(self.find(150), 300)

    def test_empty_convoy_reports_not_found(self):
        """The other side of the branch: absent must be -1, not a valid offset 0."""
        self.assertEqual(self.find(None), NOT_FOUND)

    def test_does_not_scan_past_the_convoy(self):
        """A vulnerary one slot beyond the array must not be reported as found."""
        self.assertEqual(self.find(CONVOY_SLOTS), NOT_FOUND)


if __name__ == "__main__":
    unittest.main()
