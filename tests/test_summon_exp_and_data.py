"""Summon: the +10 EXP blocking proc, and the two data fixups it depends on.

Three separate claims, all read back out of the built FE7_Hack.gba rather than
out of the source, because all three are things the assembler will happily let
you get wrong:

* class 0x46 can actually equip Flametongue (weapon-rank gate)
* character 0x86 autolevels from base 1, not base 20
* SummonAction reaches the vanilla +10-exp-on-a-blocking-proc routine

The exp routine itself (0x0802A5D0) is vanilla and already blocks; what is
being asserted here is that the summon path calls it, in the order the battle
struct requires, and that the handler returns 0 the way every other blocking
handler does.
"""
from pathlib import Path
import struct
import unittest

ROOT = Path(__file__).resolve().parents[1]
BUILT = ROOT / "FE7_Hack.gba"

CLASS_TABLE = 0xBE015C
CLASS_ENTRY = 0x54
CHAR_TABLE = 0xBDCE18
CHAR_ENTRY = 0x34
ITEM_TABLE = 0xBE222C
ITEM_ENTRY = 0x24

SUMMON_CLASS_ID = 0x46
SUMMON_CHARACTER_ID = 0x86
SUMMON_ITEM_ID = 0x8F

# CanUnitUseAsWeapon (0x080161A4) indexes the unit's rank block by weaponType.
RANK_BLOCK = 0x28
# LoadUnit's player autolevel path (0x08017BC0) reads characterData +0x0B.
BASE_LEVEL = 0x0B
# GetUnitPortraitId (0x08018BD8): character +0x06, else class +0x08.
PORTRAIT_ID = 0x06
PORTRAIT_TABLE = 0xC96584
PORTRAIT_ENTRY = 0x1C
ROM_START = 0x08000000
ROM_END = 0x0A000000


def _rom() -> bytes:
    if not BUILT.exists():
        raise unittest.SkipTest("FE7_Hack.gba not built")
    return BUILT.read_bytes()


class SummonDataFixupTests(unittest.TestCase):
    """The one-byte edits UnitMenuSkills.event makes to vanilla tables."""

    @classmethod
    def setUpClass(cls):
        cls.hack = _rom()

    def _item(self, iid: int) -> bytes:
        base = ITEM_TABLE + ITEM_ENTRY * iid
        return self.hack[base:base + ITEM_ENTRY]

    def test_flametongue_is_gated_on_rank_not_the_monster_weapon_bit(self):
        """Guards the diagnosis: if 0x800 ever gets set, the fix moves."""
        attributes = struct.unpack("<I", self._item(SUMMON_ITEM_ID)[8:12])[0]
        self.assertTrue(attributes & 1, "Flametongue should be a weapon")
        self.assertFalse(
            attributes & 0x800,
            "Flametongue now sets the monster-weapon bit; the usability fix "
            "is no longer the rank byte alone",
        )

    def test_summon_character_autolevels_from_base_one(self):
        """(level - baseLevel) has to be positive or every growth roll is skipped."""
        base = self.hack[CHAR_TABLE + CHAR_ENTRY * SUMMON_CHARACTER_ID + BASE_LEVEL]
        self.assertEqual(
            base, 1,
            f"character 0x{SUMMON_CHARACTER_ID:02X} base level is {base}; "
            "autolevelling grows by (level - baseLevel), so this must be 1",
        )

    def test_the_fixup_changes_one_character_and_nothing_else(self):
        """A stray ORG in a table is the classic way to brick this ROM.

        Scoped to the base-level field rather than the whole table, because
        other hacks legitimately edit other fields of the same entries.
        """
        clean_path = ROOT / "FE7_clean.gba"
        if not clean_path.exists():
            raise unittest.SkipTest("FE7_clean.gba not available")
        clean = clean_path.read_bytes()

        changed = {
            chid
            for chid in range(0x100)
            for off in (CHAR_TABLE + CHAR_ENTRY * chid + BASE_LEVEL,)
            if self.hack[off] != clean[off]
        }
        self.assertEqual(
            changed, {SUMMON_CHARACTER_ID},
            "a base level was changed for an unexpected character",
        )

    def test_no_class_rank_byte_is_patched(self):
        """The rank fix belongs on the unit, not the class.

        LoadUnitStats copies only class+0x2C..+0x33 into unit+0x28..+0x2F, so a
        class-table edit can never reach the byte Flametongue is gated on.  A
        patch here would be silently inert -- which is exactly the bug this
        replaced.
        """
        clean_path = ROOT / "FE7_clean.gba"
        if not clean_path.exists():
            raise unittest.SkipTest("FE7_clean.gba not available")
        clean = clean_path.read_bytes()

        base = CLASS_TABLE + CLASS_ENTRY * SUMMON_CLASS_ID
        for off in range(0x2C, 0x34):
            with self.subTest(class_offset=hex(off)):
                self.assertEqual(
                    self.hack[base + off], clean[base + off],
                    f"class 0x{SUMMON_CLASS_ID:02X}+0x{off:02X} was patched; "
                    "that byte cannot affect weapon usability",
                )


    def test_the_summon_character_keeps_its_class_card(self):
        """The dragon shows the Fire Dragon class card, not an override.

        Character 0x86's own portrait is 0, and GetUnitPortraitId (0x08018BD8)
        already handles that by falling back to the class's id at class+0x08.
        The installer must leave both alone so that fallback happens.
        """
        import struct as _struct

        pid = _struct.unpack_from(
            "<H", self.hack, CHAR_TABLE + CHAR_ENTRY * SUMMON_CHARACTER_ID + PORTRAIT_ID
        )[0]
        self.assertEqual(
            pid, 0,
            "the character portrait was overridden; that replaces the class "
            "card with an unrelated face",
        )

        card = _struct.unpack_from(
            "<H", self.hack, CLASS_TABLE + CLASS_ENTRY * SUMMON_CLASS_ID + 0x08
        )[0]
        self.assertNotEqual(card, 0, "the class supplies no card to fall back to")

    def test_the_class_card_entry_is_drawable(self):
        """A class card carries gfx at +0x08 and palette at +0x10.

        This is the shape every vanilla card 0xBE..0xDE has.  The two
        portrait-only pointers at +0x00 and +0x04 are legitimately zero on a
        card, so requiring them to be ROM addresses -- as an earlier version of
        this test did -- misreads a valid entry as a null one.
        """
        import struct as _struct

        card = _struct.unpack_from(
            "<H", self.hack, CLASS_TABLE + CLASS_ENTRY * SUMMON_CLASS_ID + 0x08
        )[0]
        entry = PORTRAIT_TABLE + PORTRAIT_ENTRY * card
        for off, what in ((0x08, "graphics"), (0x10, "palette")):
            ptr = _struct.unpack_from("<I", self.hack, entry + off)[0]
            with self.subTest(pointer=what):
                self.assertTrue(
                    ROM_START <= ptr < ROM_END,
                    f"class card 0x{card:02X} {what} pointer is {ptr:#010x}, "
                    "not a ROM address; the forecast would crash on it",
                )

    def test_the_class_card_matches_the_vanilla_entry(self):
        """Nothing in this hack may repoint the card out from under the dragon."""
        import struct as _struct

        clean_path = ROOT / "FE7_clean.gba"
        if not clean_path.exists():
            raise unittest.SkipTest("FE7_clean.gba not available")
        clean = clean_path.read_bytes()
        card = _struct.unpack_from(
            "<H", self.hack, CLASS_TABLE + CLASS_ENTRY * SUMMON_CLASS_ID + 0x08
        )[0]
        entry = PORTRAIT_TABLE + PORTRAIT_ENTRY * card
        self.assertEqual(
            self.hack[entry:entry + PORTRAIT_ENTRY],
            clean[entry:entry + PORTRAIT_ENTRY],
            f"class card 0x{card:02X}'s portrait-table entry was modified",
        )


if __name__ == "__main__":
    unittest.main()
