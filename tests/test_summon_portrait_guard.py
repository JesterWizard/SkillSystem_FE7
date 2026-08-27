"""GetUnitPortraitId must never hand NewFace an id it cannot draw.

Reads the built FE7_Hack.gba and executes the patched getter, so this covers
the installed hook and not just the source.
"""
import os
import sys
import unittest

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

ROM = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
                   "FE7_Hack.gba")

GET_UNIT_PORTRAIT_ID = 0x08018BD8
NEW_FACE = 0x08006C34
CHARACTER_TABLE = 0x08BDCE18
CLASS_TABLE = 0x08BE015C
UNIT = 0x02020000
FALLBACK = 0xDE


class SummonPortraitGuardTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        try:
            import unicorn  # noqa: F401
        except ImportError:
            raise unittest.SkipTest("unicorn not installed")
        if not os.path.exists(ROM):
            raise unittest.SkipTest("FE7_Hack.gba not built")
        with open(ROM, "rb") as fh:
            cls.hack = fh.read()

    def _portrait_id(self, pchar, pclass):
        from gba_machine import Gba
        g = Gba(self.hack)
        g.w32(UNIT + 0x00, pchar)
        g.w32(UNIT + 0x04, pclass)
        g.set_args(UNIT)
        g.run(GET_UNIT_PORTRAIT_ID)
        return g.r0

    def _draws(self, portrait_id):
        from gba_machine import Gba
        from unicorn.arm_const import UC_ARM_REG_R0, UC_ARM_REG_SP
        g = Gba(self.hack)
        g.w32(0x030041C0, 0)
        g.w32(0x030041C4, 0)
        g.stub(0x08004494,
               lambda m: m.uc.reg_write(UC_ARM_REG_R0, 0x02030000))
        g.set_args(0, portrait_id, 0xB0, 0x0C)
        g.uc.reg_write(UC_ARM_REG_SP, 0x03007F00)
        g.uc.mem_write(0x03007F24, (2).to_bytes(4, "little"))
        try:
            g.run(NEW_FACE, sp=0x03007F00)
            return True
        except Exception:
            return False

    def test_new_face_still_cannot_draw_id_zero(self):
        """The premise of the guard.  If this ever stops faulting, the guard
        is unnecessary; while it faults, returning 0 hangs the popup."""
        self.assertFalse(
            self._draws(0),
            "NewFace(0) no longer faults; re-check whether the guard is needed",
        )

    def test_a_unit_with_no_portrait_anywhere_gets_the_class_card(self):
        """Vanilla returns 0 here, which is the freeze."""
        got = self._portrait_id(CHARACTER_TABLE + 0x34 * 0x86, 0)
        self.assertEqual(got, FALLBACK, "no-portrait unit did not fall back")

    def test_a_null_unit_pointer_does_not_return_zero(self):
        got = self._portrait_id(0, 0)
        self.assertEqual(got, FALLBACK, "null unit returned an undrawable id")

    def test_the_summon_keeps_its_own_class_card(self):
        """The dragon has a real class portrait; the guard must not override it."""
        got = self._portrait_id(CHARACTER_TABLE + 0x34 * 0x86,
                                CLASS_TABLE + 0x54 * 0x46)
        self.assertEqual(got, 0xDE, "the dragon lost its Fire Dragon class card")

    def test_an_ordinary_unit_is_unaffected(self):
        """Eliwood must still resolve to his own portrait, not the fallback."""
        got = self._portrait_id(CHARACTER_TABLE + 0x34 * 0x01,
                                CLASS_TABLE + 0x54 * 0x02)
        self.assertEqual(got, 0x02, "an ordinary unit's portrait changed")

    def test_every_id_the_guard_can_return_is_drawable(self):
        """The property that matters: no reachable return value hangs NewFace."""
        for pchar, pclass, label in (
            (CHARACTER_TABLE + 0x34 * 0x86, CLASS_TABLE + 0x54 * 0x46, "summon"),
            (CHARACTER_TABLE + 0x34 * 0x86, CLASS_TABLE + 0x54 * 0x86, "bad class"),
            (CHARACTER_TABLE + 0x34 * 0x86, 0, "null class"),
            (0, 0, "null unit"),
            (CHARACTER_TABLE + 0x34 * 0x01, CLASS_TABLE + 0x54 * 0x02, "ordinary"),
        ):
            got = self._portrait_id(pchar, pclass)
            self.assertNotEqual(got, 0, f"{label} returned the faulting id 0")
            self.assertTrue(self._draws(got),
                            f"{label} returned id {got:#x}, which NewFace cannot draw")


if __name__ == "__main__":
    unittest.main()
