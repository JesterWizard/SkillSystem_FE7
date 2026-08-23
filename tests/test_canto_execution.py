"""Executes canto.s under a real Thumb CPU emulator and asserts that
US_CANTO_PENDING (0x8000) is set exactly when the unit should get a re-move.

The bug this pins: canto.s gated the re-move on

    ldrb r0, [r6,#0x0C]   @ ActionData.subjectIndex  (a UNIT index)
    ldrb r1, [r4,#0x0B]   @ r4 is a CHARACTER pointer -> baseLevel
    cmp  r0, r1
    bne  End

post_loop.s converts the unit to a character pointer (GetCharPtr) before
running the post-combat skill loop, so r4 is CharacterData, whose +0x0B is
baseLevel -- not a unit index. Comparing a unit index against a level byte
only passes by coincidence, which is why healing yourself with a vulnerary
usually produced no canto.
"""
import struct
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from Tools.thumb_harness import CODE_BASE, Harness, assemble, symbol_offsets

SRC = ROOT / "EngineHacks/SkillSystem/Skills/PostBattleSkills/Canto/canto.s"

UNIT_ADDR = 0x0202BE4C
CHAR_ADDR = 0x0817FF00
CLASS_ADDR = 0x0817FE00
ACTIONDATA_ADDR = 0x0203A85C
ACTIVE_UNIT_ADDR = 0x03004690

UNIT_STATE = 0x0C
US_CANTO_PENDING = 0x8000

UNIT_ACTION_STAFF = 0x03
UNIT_ACTION_USE_ITEM = 0x1A
# FE7 self-use items (Vulnerary, Elixir, ...) write 0x17 at 0x08027674,
# not 0x1A. 0x17 is the ApplyUnitAction slot that actually calls
# ActionStaffDoorChestUseItem; 0x1A is the unused default stub.
UNIT_ACTION_SELF_ITEM = 0x17

SUBJECT_INDEX = 0x17
UNIT_INDEX = 0x17  # Unit+0x0B; the actor is the subject of its own action


def _run_canto(action_type, *, subject_index=SUBJECT_INDEX,
               unit_index=UNIT_INDEX, active_unit=None, move_used=4, unit_move=7,
               skill_present=True, state=0):
    """Runs canto.s and returns the unit's status bitfield afterwards."""
    code = bytearray(assemble(SRC))
    offsets = symbol_offsets(SRC)

    # canto.s calls out through the `blh` macro
    # (`ldr r3,=fn ; mov lr,r3 ; .short 0xf800`). The bare BL-suffix is not a
    # runnable instruction, so replace each ROM call site the way the harness
    # handles SkillTester: NOP the setup and force the return value into r0.
    # Sites are found by scanning for the `mov lr,r3`+suffix pair and matched
    # to routines by the literal each one loads -- never by a counted offset.
    NOP = 0x46C0
    returns = {
        0x08018B44: unit_move,  # GetUnitMaxMovement -> total movement
        0x080798F8: 0,          # event-flag check -> flag not set
        0x08019868: 0,          # UpdateUnitMapAndVision -> no-op
    }
    idx = -1
    while True:
        idx = code.find(struct.pack("<H", 0xF800), idx + 1)
        if idx == -1:
            break
        if code[idx - 2:idx] != struct.pack("<H", 0x469E):  # mov lr, r3
            continue
        # `ldr r3, =fn` is pc-relative: (pc & ~3) + 4 + imm8*4, pc = idx - 4.
        imm8 = code[idx - 4]
        lit = (((idx - 4) + 4) & ~3) + imm8 * 4
        if lit + 4 > len(code):
            continue  # SkillTester's literal is an unresolved @POIN fixup
        target = struct.unpack("<I", code[lit:lit + 4])[0]
        if target not in returns:
            continue  # SkillTester; the harness patches that one itself
        code[idx - 4:idx] = struct.pack("<HH", NOP, NOP)
        code[idx:idx + 2] = struct.pack("<H", 0x2000 | (returns[target] & 0xFF))

    h = Harness(bytes(code), skill_present=skill_present)

    # Unit: alive, with character/class pointers and the given state bits.
    h.seed(UNIT_ADDR + 0x00, struct.pack("<I", CHAR_ADDR))
    h.seed(UNIT_ADDR + 0x04, struct.pack("<I", CLASS_ADDR))
    h.seed(UNIT_ADDR + UNIT_STATE, struct.pack("<I", state))
    h.seed(UNIT_ADDR + 0x13, struct.pack("<B", 20))  # current HP, non-zero

    # Unit.index at +0x0B; character/class abilities at +0x28 (no CA_CANTO).
    h.seed(UNIT_ADDR + 0x0B, struct.pack("<b", unit_index))
    h.seed(CHAR_ADDR + 0x28, struct.pack("<I", 0))
    h.seed(CLASS_ADDR + 0x28, struct.pack("<I", 0))

    # gActiveUnit is what actually identifies the actor on every action path.
    h.seed(ACTIVE_UNIT_ADDR, struct.pack("<I", active_unit if active_unit is not None else UNIT_ADDR))
    h.seed(ACTIONDATA_ADDR + 0x0C, struct.pack("<B", subject_index))
    h.seed(ACTIONDATA_ADDR + 0x10, struct.pack("<B", move_used))
    h.seed(ACTIONDATA_ADDR + 0x11, struct.pack("<B", action_type))

    # post_loop.s runs the loop with r4 = unit/character ptr, r6 = ActionData.
    h.run(offsets["End"], regs={"r4": UNIT_ADDR, "r6": ACTIONDATA_ADDR})
    return struct.unpack("<I", h.read(UNIT_ADDR + UNIT_STATE, 4))[0]


class CantoExecutionTests(unittest.TestCase):
    def test_canto_after_self_targeted_vulnerary(self):
        state = _run_canto(UNIT_ACTION_SELF_ITEM)
        self.assertTrue(
            state & US_CANTO_PENDING,
            "using a vulnerary on yourself must still grant canto")

    def test_canto_after_staff(self):
        state = _run_canto(UNIT_ACTION_STAFF)
        self.assertTrue(state & US_CANTO_PENDING,
                        "staff use must grant canto")

    def test_no_canto_without_the_skill(self):
        state = _run_canto(UNIT_ACTION_USE_ITEM, skill_present=False)
        self.assertFalse(state & US_CANTO_PENDING,
                         "a unit without Canto must not get a re-move")

    def test_no_canto_after_plain_wait(self):
        state = _run_canto(0x01)
        self.assertFalse(state & US_CANTO_PENDING,
                         "waiting is not a canto-eligible action")

    def test_no_canto_for_a_different_unit(self):
        """The loop walks skills for the acting unit; a unit that is not the
        one in gActiveUnit must not be handed a re-move."""
        state = _run_canto(UNIT_ACTION_USE_ITEM, active_unit=0x0202C000)
        self.assertFalse(state & US_CANTO_PENDING,
                         "only the acting unit may canto")

    def test_no_second_canto_when_already_pending(self):
        state = _run_canto(UNIT_ACTION_USE_ITEM, state=US_CANTO_PENDING)
        self.assertEqual(
            state & US_CANTO_PENDING, US_CANTO_PENDING,
            "an already-pending canto must not be re-granted or cleared here")

    def test_no_canto_when_all_movement_spent(self):
        state = _run_canto(UNIT_ACTION_USE_ITEM, move_used=7, unit_move=7)
        self.assertFalse(state & US_CANTO_PENDING,
                         "a unit that used its whole move has nothing to canto with")

    def test_canto_after_vulnerary_with_stale_subject_index(self):
        """The reported bug, verbatim: Lyn moves 1 of 5, heals herself with a
        vulnerary, and expects to move the remaining 4.

        FE7's self-item setter (0x08027674) writes unitActionType 0x17, not
        the 0x1A Canto was ported to check. Staff is 0x03, so staff cantoed
        and the vulnerary did not.
        """
        state = _run_canto(UNIT_ACTION_SELF_ITEM, move_used=1, unit_move=5,
                           subject_index=0x03, unit_index=0x17)
        self.assertTrue(
            state & US_CANTO_PENDING,
            "vulnerary must grant canto even when subjectIndex is stale")

    def test_canto_still_refused_for_a_unit_that_did_not_act(self):
        """gActiveUnit, not subjectIndex, decides. A different unit must not
        be handed the re-move even when subjectIndex happens to match it."""
        other = 0x0202C000
        state = _run_canto(UNIT_ACTION_USE_ITEM, move_used=1, unit_move=5,
                           active_unit=other)
        self.assertFalse(state & US_CANTO_PENDING,
                         "only the unit in gActiveUnit may canto")
