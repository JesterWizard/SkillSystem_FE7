import struct
import sys
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

try:
    from Tools.thumb_harness import CODE_BASE, Harness, assemble, symbol_offsets
except ImportError:
    CODE_BASE = Harness = assemble = symbol_offsets = None


CAPTURE = (
    ROOT
    / "EngineHacks"
    / "SkillSystem"
    / "Skills"
    / "UnitMenuSkills"
    / "Capture"
    / "Capture"
)
SOURCE = CAPTURE / "Preserve_Captured_Enemy.s"
DROP_SOURCE = CAPTURE / "Drop_Dead_Enemy.s"
UNIT = 0x0202BE4C
CHAR = 0x0817FF00
CARRIER = 0x0202BE4C
RESCUEE = 0x0202BF00
UNIT_LOOKUP = 0x08B92EB0
CHAPTER_DATA = 0x0202BBF8


@unittest.skipIf(Harness is None, "Unicorn/devkitARM is unavailable")
class PreserveCapturedEnemyExecutionTests(unittest.TestCase):
    def _run(self, allegiance, state):
        code = bytearray(assemble(SOURCE))
        offsets = symbol_offsets(SOURCE)
        # ClearUnitSupports has no observable effect in this harness. Replace
        # the three-halfword long-call sequence without touching the preceding
        # state write (the generic SkillTester patch expects five halfwords).
        call = code.find(b"\x00\xf8")
        self.assertGreaterEqual(call, 4)
        code[call - 4 : call + 2] = struct.pack("<HHH", 0x46C0, 0x46C0, 0x46C0)
        harness = Harness(bytes(code))

        unit = bytearray(0x48)
        unit[0:4] = struct.pack("<I", CHAR)
        unit[0x0B] = allegiance
        unit[0x0C:0x10] = struct.pack("<I", state)
        harness.seed(UNIT, bytes(unit))

        harness.run(
            offsets["End"],
            regs={
                "r0": UNIT,
                "lr": (CODE_BASE + offsets["End"]) | 1,
            },
        )
        return harness

    def test_rescued_enemy_keeps_character_pointer(self):
        harness = self._run(0x80, 0x20)

        self.assertEqual(harness.read(UNIT, 4), struct.pack("<I", CHAR))

    def test_unrescued_enemy_still_clears_character_pointer(self):
        harness = self._run(0x80, 0)

        self.assertEqual(harness.read(UNIT, 4), b"\0\0\0\0")

    def test_allied_unit_keeps_vanilla_dead_state(self):
        harness = self._run(0, 0)

        self.assertEqual(harness.read(UNIT, 4), struct.pack("<I", CHAR))
        self.assertEqual(
            struct.unpack("<I", harness.read(UNIT + 0x0C, 4))[0],
            5,
        )


@unittest.skipIf(Harness is None, "Unicorn/devkitARM is unavailable")
class DropCapturedEnemyExecutionTests(unittest.TestCase):
    def _run(self, allegiance, hp):
        code = assemble(DROP_SOURCE)
        offsets = symbol_offsets(DROP_SOURCE)
        harness = Harness(code)

        carrier = bytearray(0x48)
        carrier[0x0C:0x10] = struct.pack("<I", 0x10)
        carrier[0x1B] = 1

        rescuee = bytearray(0x48)
        rescuee[0:4] = struct.pack("<I", CHAR)
        rescuee[0x0B] = allegiance
        rescuee[0x0C:0x10] = struct.pack("<I", 0x21)
        rescuee[0x13] = hp

        harness.seed(CARRIER, bytes(carrier))
        harness.seed(RESCUEE, bytes(rescuee))
        harness.seed(UNIT_LOOKUP + 4, struct.pack("<I", RESCUEE))
        harness.seed(CHAPTER_DATA, bytes(0x10))
        harness.run(
            offsets["End"],
            regs={
                "r0": CARRIER,
                "r1": 7,
                "r2": 8,
                "lr": (CODE_BASE + offsets["End"]) | 1,
            },
        )
        return harness

    def test_one_hp_enemy_is_cleared_when_dropped(self):
        harness = self._run(0x80, 1)

        self.assertEqual(harness.read(RESCUEE, 4), b"\0\0\0\0")
        self.assertEqual(harness.read(RESCUEE + 0x13, 1), b"\0")
        self.assertEqual(
            struct.unpack("<I", harness.read(RESCUEE + 0x0C, 4))[0] & 0x0D,
            0x0D,
        )
        self.assertEqual(harness.read(CARRIER + 0x1B, 1), b"\0")

    def test_allied_one_hp_unit_is_not_cleared(self):
        harness = self._run(0, 1)

        self.assertEqual(
            harness.read(RESCUEE, 4), struct.pack("<I", CHAR)
        )
        self.assertEqual(harness.read(RESCUEE + 0x13, 1), b"\x01")
        self.assertEqual(harness.read(CARRIER + 0x1B, 1), b"\0")


if __name__ == "__main__":
    unittest.main()
