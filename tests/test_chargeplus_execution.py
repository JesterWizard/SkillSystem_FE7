"""Executes ChargePlus.s under a real Thumb CPU emulator against synthetic
unit/class/ActionData memory, and asserts the brave bit (item ability word
+0x4C, bit 0x20) ends up set exactly when the unit spent all its movement.

This complements the text-pattern checks in test_prebattle_skills_dec103.py:
those catch "did the source change in an expected way", this catches "does
the assembled code actually put the right struct field in the register the
comparison uses" -- the class of bug (class-Move + movBonus double-counted
into r0 while the real total sat untouched in r1) that a source-text
assertion can't see because the *instructions* still looked plausible.
"""
import struct
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from Tools.thumb_harness import Harness, assemble, symbol_offsets
SRC = ROOT / "EngineHacks/SkillSystem/Skills/PreBattleSkills/ChargePlus/ChargePlus.s"

ATTACKER_ADDR = 0x0203A3F0  # matches the `ldr r5,=0x203A3F0 @attacker` constant
DEFENDER_ADDR = 0x0203A470
DEFENDER_CLASS_ADDR = 0x0203A500  # only needs to be non-null; never dereferenced
ACTIONDATA_ADDR = 0x0203A85C
ITEM_ABILITY_OFF = 0x4C
BRAVE_BIT = 0x20


def _run_chargeplus(unit_movement: int, spaces_moved: int) -> int:
    """Returns the item ability word after running ChargePlus with the given
    unit movement (unit+0x1D) and spaces-moved-this-turn (ActionData+0x10)."""
    code = assemble(SRC)
    offsets = symbol_offsets(SRC)
    h = Harness(code)

    h.seed(DEFENDER_ADDR + 0x4, struct.pack("<I", DEFENDER_CLASS_ADDR))
    h.seed(ATTACKER_ADDR + 0x1D, struct.pack("<b", unit_movement))
    h.seed(ATTACKER_ADDR + ITEM_ABILITY_OFF, struct.pack("<I", 0))
    h.seed(ACTIONDATA_ADDR + 0x10, struct.pack("<B", spaces_moved & 0xFF))

    h.run(offsets["GoBack"], regs={"r0": ATTACKER_ADDR, "r1": DEFENDER_ADDR})
    return struct.unpack("<I", h.read(ATTACKER_ADDR + ITEM_ABILITY_OFF, 4))[0]


class ChargePlusExecutionTests(unittest.TestCase):
    def test_brave_bit_set_when_movement_fully_spent(self):
        ability = _run_chargeplus(unit_movement=5, spaces_moved=5)
        self.assertTrue(ability & BRAVE_BIT, "brave bit should be set when spaces_moved == unit_movement")

    def test_brave_bit_clear_when_movement_partially_spent(self):
        ability = _run_chargeplus(unit_movement=5, spaces_moved=4)
        self.assertFalse(ability & BRAVE_BIT, "brave bit must not fire before movement is fully spent")

    def test_brave_bit_clear_when_unit_did_not_move(self):
        ability = _run_chargeplus(unit_movement=5, spaces_moved=0)
        self.assertFalse(ability & BRAVE_BIT, "standing still must not look like 'moved to the edge of range'")

    def test_brave_bit_tracks_true_total_movement_not_just_bonus(self):
        # Regression guard for the double-counting bug: unit+0x1D already IS
        # the unit's total effective movement (getter-computed), not a small
        # delta to add on top of a separately-read class base move. A large
        # movement value (bigger than any real class base move) must still
        # compare correctly against spaces moved, proving no second term is
        # being summed in.
        ability = _run_chargeplus(unit_movement=12, spaces_moved=12)
        self.assertTrue(ability & BRAVE_BIT)
        ability = _run_chargeplus(unit_movement=12, spaces_moved=11)
        self.assertFalse(ability & BRAVE_BIT)

    def test_brave_bit_clear_when_unit_has_no_movement(self):
        ability = _run_chargeplus(unit_movement=0, spaces_moved=0)
        self.assertFalse(ability & BRAVE_BIT, "zero/negative movement must bail out, not compare 0 == 0")


if __name__ == "__main__":
    unittest.main()
