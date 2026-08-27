"""The summon's map popup, and drawing a class card without a mug.

Both read the built FE7_Hack.gba, so they cover the installed hooks rather than
the source.
"""
import os
import re
import struct
import sys
import unittest

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ROM = os.path.join(ROOT, "FE7_Hack.gba")
EVENT = os.path.join(ROOT, "EngineHacks", "SkillSystem", "Skills",
                     "UnitMenuSkills", "UnitMenuSkills.event")
TEXT = os.path.join(ROOT, "Text", "unitmenu_text.txt")

CLASS_TABLE = 0x08BE015C
CLASS_ENTRY = 0x54

PORTRAIT_TABLE = 0x08C96584
PORTRAIT_ENTRY = 0x1C

# The two vanilla sites this build replaces.
FACE_GFX_LOADER = 0x08006B9C     # called by face scripts 0x08B907C0 / 0x08B907F8
STEAL_POPUP_CALLBACK = 0x0806E2FC  # called by map battle tail script 0x08C9D6DC

NEW_POPUP_SIMPLE = 0x0800AD40
POPUP_STOLE_ITEM = 0x0800EEF4
UNLZ77 = 0x08013168

G_ACTION_DATA = 0x0203A85C
SUMMON_ACTION_ID = 0x05


def rom():
    with open(ROM, "rb") as fh:
        return fh.read()


def rd32(data, addr):
    return struct.unpack_from("<I", data, addr - 0x08000000)[0]


def define(name):
    with open(EVENT, "r", encoding="utf-8", errors="replace") as fh:
        body = fh.read()
    m = re.search(r"#define\s+%s\s+(0x[0-9A-Fa-f]+|\d+)" % name, body)
    assert m, "%s is not defined in UnitMenuSkills.event" % name
    return int(m.group(1), 0)


class SummonPopupTests(unittest.TestCase):
    """The popup must name the summon, not the dragon's weapon."""

    @classmethod
    def setUpClass(cls):
        if not os.path.exists(ROM):
            raise unittest.SkipTest("FE7_Hack.gba not built")
        cls.hack = rom()

    def test_the_class_name_text_id_matches_the_summoned_class(self):
        """SUMMON_CLASS_NAME_TEXT is ClassTable + 0x54*id + 0x00.

        Nothing at runtime can resolve a class name -- popup opcode 0x05
        resolves a CHARACTER name and there is no class equivalent -- so the id
        is baked into the popup definition.  This is the guard that keeps it
        honest if SUMMON_CLASS_ID is ever changed without it.
        """
        data = self.hack
        class_id = define("SUMMON_CLASS_ID")
        declared = define("SUMMON_CLASS_NAME_TEXT")
        entry = CLASS_TABLE + CLASS_ENTRY * class_id
        actual = struct.unpack_from("<H", data, entry - 0x08000000)[0]
        self.assertEqual(
            declared, actual,
            "SUMMON_CLASS_NAME_TEXT is %#06x but class %#04x is named by text "
            "%#06x; the popup would print the wrong class"
            % (declared, class_id, actual),
        )

    def test_the_popup_phrase_exists(self):
        with open(TEXT, "r", encoding="utf-8", errors="replace") as fh:
            body = fh.read()
        self.assertIn("## UM_SummonedPopup", body)

    def test_the_steal_popup_callback_is_replaced(self):
        """0x0806E2FC must no longer be vanilla.

        StartMapBattleSequence forces 0x0203E15E to 1, so vanilla's steal popup
        fires unconditionally on the summon's exp path and names gBattleTarget's
        weapon -- the dragon's own Flametongue.
        """
        data = self.hack
        vanilla = struct.unpack_from(
            "<HH", data, STEAL_POPUP_CALLBACK - 0x08000000)
        self.assertNotEqual(
            vanilla, (0xB580, 0xB081),
            "0x0806E2FC still starts with vanilla's prologue; the steal popup "
            "was never hooked",
        )


class SummonClassCardFaceTests(unittest.TestCase):
    """A class card has no mug graphics; the sprite face path must cope."""

    @classmethod
    def setUpClass(cls):
        if not os.path.exists(ROM):
            raise unittest.SkipTest("FE7_Hack.gba not built")
        cls.hack = rom()

    def test_the_summons_portrait_entry_really_has_no_mug(self):
        """The premise.  If this ever stops being true the hook is pointless."""
        data = self.hack
        entry = PORTRAIT_TABLE + PORTRAIT_ENTRY * 0xDE
        self.assertEqual(
            rd32(data, entry + 0x00), 0,
            "class card 0xDE grew a mug pointer; re-check the hook",
        )
        self.assertNotEqual(
            rd32(data, entry + 0x10), 0,
            "class card 0xDE has no graphics at +0x10",
        )

    def test_every_class_card_keeps_graphics_at_plus_ten(self):
        """The convention the hook relies on, across the whole card range."""
        data = self.hack
        for pid in range(0xBE, 0xE4):
            entry = PORTRAIT_TABLE + PORTRAIT_ENTRY * pid
            if rd32(data, entry + 0x00) != 0:
                continue          # this one has a real mug; not a class card
            self.assertNotEqual(
                rd32(data, entry + 0x10), 0,
                "portrait %#04x has neither a mug at +0x00 nor a card at +0x10"
                % pid,
            )

    def test_the_face_graphics_loader_is_replaced(self):
        data = self.hack
        vanilla = struct.unpack_from("<HH", data, FACE_GFX_LOADER - 0x08000000)
        self.assertNotEqual(
            vanilla, (0xB500, 0x6AC1),
            "0x08006B9C still starts with vanilla's prologue; the face loader "
            "was never hooked, so a class card still decompresses from NULL",
        )

    def test_the_face_scripts_still_reach_the_loader(self):
        """Both face proc scripts must still call the (now hooked) routine."""
        data = self.hack
        for script in (0x08B907C0, 0x08B907F8):
            ptrs = [rd32(data, script + 8 * i + 4) for i in range(7)]
            self.assertIn(
                FACE_GFX_LOADER | 1, ptrs,
                "face script %#010x no longer calls the graphics loader"
                % script,
            )


class FaceLoaderExecutionTests(unittest.TestCase):
    """Execute the installed loader and assert which pointer it decompresses.

    The structural tests above prove the hook is in the ROM.  They cannot prove
    it picks the right source, and picking the wrong one is the entire bug --
    so both sides of the branch are run here, plus the case where neither
    pointer exists.
    """

    PROC = 0x02020000
    ENTRY = 0x02020100

    @classmethod
    def setUpClass(cls):
        try:
            import unicorn  # noqa: F401
        except ImportError:
            raise unittest.SkipTest("unicorn not installed")
        if not os.path.exists(ROM):
            raise unittest.SkipTest("FE7_Hack.gba not built")
        cls.hack = rom()

    def _decompressed_from(self, mug, card, slot=0, vram_offset=0x40):
        from gba_machine import Gba
        g = Gba(self.hack)

        g.uc.mem_write(self.PROC, bytes(0x6C))
        g.uc.mem_write(self.ENTRY, bytes(PORTRAIT_ENTRY))
        g.w32(self.ENTRY + 0x00, mug)
        g.w32(self.ENTRY + 0x10, card)
        g.w32(self.PROC + 0x2C, self.ENTRY)
        g.w8(self.PROC + 0x40, slot)
        g.w32(0x0202A58C + 8 * slot, vram_offset)

        seen = []
        g.stub(UNLZ77, lambda m: seen.append((m.r0, m.r1)))

        g.set_args(self.PROC)
        g.run(FACE_GFX_LOADER)
        return seen

    def test_a_mug_is_still_loaded_from_plus_zero(self):
        """The no-op case.  A unit with a real portrait must be unaffected."""
        seen = self._decompressed_from(mug=0x08C95488, card=0)
        self.assertEqual(len(seen), 1, "the mug was not decompressed")
        self.assertEqual(
            seen[0][0], 0x08C95488,
            "a normal portrait no longer loads from entry+0x00",
        )

    def test_a_class_card_is_loaded_from_plus_ten(self):
        """The fix.  Vanilla passed 0 here and decompressed from open bus."""
        seen = self._decompressed_from(mug=0, card=0x08BE9DBC)
        self.assertEqual(len(seen), 1, "the class card was not decompressed")
        self.assertEqual(
            seen[0][0], 0x08BE9DBC,
            "a class card did not load from entry+0x10",
        )

    def test_neither_pointer_decompresses_nothing(self):
        """Never hand UnLZ77Decompress a null source, whatever the entry."""
        seen = self._decompressed_from(mug=0, card=0)
        self.assertEqual(
            seen, [],
            "an entry with no graphics at all still called UnLZ77Decompress",
        )

    def test_the_real_summon_class_card_loads(self):
        """The reported case, with the entry the ROM actually holds."""
        entry = PORTRAIT_TABLE + PORTRAIT_ENTRY * 0xDE
        seen = self._decompressed_from(
            mug=rd32(self.hack, entry + 0x00),
            card=rd32(self.hack, entry + 0x10),
        )
        self.assertEqual(len(seen), 1)
        self.assertEqual(seen[0][0], rd32(self.hack, entry + 0x10))
        self.assertNotEqual(seen[0][0], 0)

    def test_the_destination_is_still_the_slots_vram_offset(self):
        """The fix must only change the source, never where it lands."""
        seen = self._decompressed_from(
            mug=0, card=0x08BE9DBC, slot=2, vram_offset=0x1234)
        self.assertEqual(seen[0][1], 0x06010000 + 0x1234)


if __name__ == "__main__":
    unittest.main()

