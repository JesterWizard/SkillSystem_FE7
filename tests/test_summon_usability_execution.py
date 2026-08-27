"""Execute NewSummonUsability out of FE7_Hack.gba and check what it returns.

The unit menu reads the return value directly: 1 shows the command, 2 greys it
out, 3 hides it.  Every gate is asserted from both sides, because a routine that
always returned 1 would satisfy the "it appears" half on its own.

Only SkillTester is stubbed -- reaching the real one needs the whole skill-table
lookup -- so this does not prove the summoner owns the skill in a real chapter.
Everything else (the tile list, the map and terrain checks, GetTargetListSize)
is genuine ROM code.
"""
from __future__ import annotations

import struct
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(Path(__file__).resolve().parent))

from gba_machine import Gba, ROM_LOAD, UNICORN_ERROR, Uc  # noqa: E402
from summon_symbols import (  # noqa: E402
    HACK,
    USABILITY_LYN,
    action_symbols,
    blob_length,
    usability_blob_base,
)

G_ACTIVE_UNIT = 0x03004690
CHAPTER_DATA = 0x0202BBF8
MAP_SIZE = 0x0202E3D8
PP_MAP_UNIT = 0x0202E3DC
PP_MAP_TERRAIN = 0x0202E3E0
PP_MAP_MOVEMENT = 0x0202E3E4
PP_MAP_RANGE = 0x0202E3E8
PP_MAP_HIDDEN = 0x0202E3F0
G_TARGET_ARRAY_SIZE = 0x0203DFF8

CLASS_TABLE = 0x08BE015C
SUMMONER = 0x0202BD50
US_UNSELECTABLE = 0x40

MENU_ENABLED = 1
MENU_HIDDEN = 3

WIDTH, HEIGHT = 15, 10
STRIDE = WIDTH + 2
SPAN = STRIDE * (HEIGHT + 4)

LAYERS = {
    "unit": (0x02030000, 0x02031000, PP_MAP_UNIT),
    "movement": (0x02032000, 0x02033000, PP_MAP_MOVEMENT),
    "range": (0x02034000, 0x02035000, PP_MAP_RANGE),
    "hidden": (0x02036000, 0x02037000, PP_MAP_HIDDEN),
    "terrain": (0x02038000, 0x02039000, PP_MAP_TERRAIN),
}


@unittest.skipUnless(Uc is not None, f"Unicorn unavailable: {UNICORN_ERROR}")
@unittest.skipUnless(HACK.exists(), "FE7_Hack.gba not built")
class SummonUsabilityTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.rom = HACK.read_bytes()
        cls.entry = usability_blob_base(cls.rom)
        assert cls.entry > 0, "NewSummonUsability is not present in the ROM"
        # UnitMenuSkills.event appends `POIN SkillTester; WORD SummonID` right
        # after the blob, and the routine calls through that pointer.
        tail = cls.entry + blob_length(USABILITY_LYN)
        cls.skill_tester = struct.unpack_from("<I", cls.rom, tail)[0] & ~1
        cls.summon_id = struct.unpack_from("<I", cls.rom, tail + 4)[0]

        syms = action_symbols(cls.rom)
        assert syms, "the summon action is not installed"
        class_id = struct.unpack_from("<I", cls.rom, syms["SummonLinks"] + 4)[0]
        base = (CLASS_TABLE - ROM_LOAD) + 0x54 * class_id
        ptr = struct.unpack_from("<I", cls.rom, base + 0x38)[0] - ROM_LOAD
        costs = cls.rom[ptr : ptr + 0x20]
        cls.good_terrain = next(i for i, c in enumerate(costs) if 0 < c < 0x7F)
        cls.bad_terrain = next(i for i, c in enumerate(costs) if c == 0 or c >= 0x7F)

    def _run(self, *, skill=True, state=0, occupied=(), terrain=None, at=(4, 7)):
        g = Gba(self.rom)
        g.w16(MAP_SIZE, WIDTH)
        g.w16(MAP_SIZE + 2, HEIGHT)
        g.w8(CHAPTER_DATA + 0x15, 0)

        for rows, data, pointer in LAYERS.values():
            g.w32(rows - 8, data)
            for y in range(HEIGHT + 4):
                g.w32(rows + 4 * y, data + y * STRIDE)
            g.uc.mem_write(data, bytes(SPAN))
            g.w32(pointer, rows)

        fill = self.good_terrain if terrain is None else terrain
        g.uc.mem_write(LAYERS["terrain"][1], bytes([fill]) * SPAN)
        for x, y in occupied:
            g.w8(LAYERS["unit"][1] + y * STRIDE + x, 0x21)

        unit = bytearray(0x48)
        unit[0x10], unit[0x11] = at
        struct.pack_into("<I", unit, 0x0C, state)
        g.uc.mem_write(SUMMONER, bytes(unit))
        g.w32(G_ACTIVE_UNIT, SUMMONER)
        g.w32(G_TARGET_ARRAY_SIZE, 0)

        self.asked = []

        def skill_tester(m):
            self.asked.append((m.r0, m.r1))
            m.set_args(1 if skill else 0)

        g.stub(self.skill_tester, skill_tester)
        try:
            g.run(ROM_LOAD + self.entry)
        except Exception as exc:  # UcError
            self.fail(f"NewSummonUsability faulted at pc={g.pc:#x}: {exc}")
        return g.r0

    def test_an_open_neighbour_shows_the_command(self):
        self.assertEqual(self._run(), MENU_ENABLED)

    def test_without_the_skill_the_command_is_hidden(self):
        self.assertEqual(self._run(skill=False), MENU_HIDDEN)

    def test_a_unit_that_has_already_acted_cannot_summon(self):
        self.assertEqual(self._run(state=US_UNSELECTABLE), MENU_HIDDEN)

    def test_being_boxed_in_hides_the_command(self):
        boxed = [(3, 7), (5, 7), (4, 6), (4, 8)]
        self.assertEqual(self._run(occupied=boxed), MENU_HIDDEN)

    def test_one_free_tile_is_enough(self):
        self.assertEqual(
            self._run(occupied=[(3, 7), (5, 7), (4, 6)]), MENU_ENABLED
        )

    def test_impassable_terrain_all_round_hides_the_command(self):
        self.assertEqual(self._run(terrain=self.bad_terrain), MENU_HIDDEN)

    def test_a_corner_unit_can_still_summon(self):
        self.assertEqual(self._run(at=(0, 0)), MENU_ENABLED)

    def test_the_lookup_asks_about_the_active_unit_and_the_summon_skill(self):
        self._run()
        self.assertEqual(
            self.asked, [(SUMMONER, self.summon_id)], "wrong SkillTester arguments"
        )

    def test_the_skill_id_the_installer_linked_is_the_summon_skill(self):
        definitions = (
            ROOT / "EngineHacks/SkillSystem/skill_definitions.event"
        ).read_text(encoding="utf-8")
        self.assertIn(f"#define SummonID {self.summon_id}", definitions)


if __name__ == "__main__":
    unittest.main()
