"""Execute the summon tile picker and its blue highlight out of FE7_Hack.gba.

Two separate claims live here, and both are about code that runs before any
unit is created:

* which tiles end up in the engine's target list -- that is what the usability
  check counts and what the map selector lets you move between;
* what the tile renderer would draw.  0x08019454 reads the MOVEMENT map first
  and only falls through to the range map when that byte is negative, so blue
  squares mean: movement filled with -1, then a non-negative byte on each
  summonable tile, then DisplayMoveRangeGraphics with bit 0 set.

Everything below the entry point is genuine ROM code -- ClearMapWith,
MapAddInRange, ForEachPosInRange, AddTarget, the class movement-cost lookup.
Only DisplayMoveRangeGraphics is stubbed, because it allocates a graphics proc;
so this proves what the renderer would read, not that the proc draws.
"""
from __future__ import annotations

import struct
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(Path(__file__).resolve().parent))

from gba_machine import Gba, IWRAM, ROM_LOAD, UNICORN_ERROR, Uc  # noqa: E402
from summon_symbols import (  # noqa: E402
    HACK,
    SUMMON_TABLE_ENTRY,
    action_symbols,
)

G_ACTIVE_UNIT = 0x03004690
CHAPTER_DATA = 0x0202BBF8
MAP_SIZE = 0x0202E3D8
PP_MAP_UNIT = 0x0202E3DC
PP_MAP_TERRAIN = 0x0202E3E0
PP_MAP_MOVEMENT = 0x0202E3E4
PP_MAP_RANGE = 0x0202E3E8
PP_MAP_HIDDEN = 0x0202E3F0
G_TARGET_ARRAY = 0x0203DCF8
G_TARGET_ARRAY_SIZE = 0x0203DFF8
TARGET_ENTRY_SIZE = 0x0C

SHOW_MOVE_RANGE_GFX = 0x0801D2A0
CLASS_TABLE = 0x08BE015C
SUMMONER = 0x0202BD50

WIDTH, HEIGHT = 15, 10
STRIDE = WIDTH + 2
SPAN = STRIDE * (HEIGHT + 4)

# Scratch map buffers, all inside real EWRAM. Each map is a row-pointer table
# whose word at table-8 holds the base of the contiguous data block, because
# ClearMapWith memsets through that word.
LAYERS = {
    "unit": (0x02030000, 0x02031000, PP_MAP_UNIT),
    "movement": (0x02032000, 0x02033000, PP_MAP_MOVEMENT),
    "range": (0x02034000, 0x02035000, PP_MAP_RANGE),
    "hidden": (0x02036000, 0x02037000, PP_MAP_HIDDEN),
    "terrain": (0x02038000, 0x02039000, PP_MAP_TERRAIN),
}


def _mov_costs(rom: bytes, class_id: int) -> bytes:
    """The clear-weather movement cost table for a class."""
    base = (CLASS_TABLE - ROM_LOAD) + 0x54 * class_id
    ptr = struct.unpack_from("<I", rom, base + 0x38)[0]
    return rom[ptr - ROM_LOAD : ptr - ROM_LOAD + 0x40]


@unittest.skipUnless(Uc is not None, f"Unicorn unavailable: {UNICORN_ERROR}")
@unittest.skipUnless(HACK.exists(), "FE7_Hack.gba not built")
class SummonTilePickerTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.rom = HACK.read_bytes()
        cls.syms = action_symbols(cls.rom)
        # Not a skip. If the summon blob cannot be located from FE7's own
        # action table, the command is not installed -- which is the failure
        # this file exists to catch.
        assert cls.syms, (
            "SummonActionEntry is not reachable from UnitActionFunctionPointer; "
            "the summon action is not installed"
        )
        cls.class_id = struct.unpack_from(
            "<I", cls.rom, cls.syms["SummonLinks"] + 4
        )[0]
        costs = _mov_costs(cls.rom, cls.class_id)
        passable = [i for i, c in enumerate(costs[:0x20]) if 0 < c < 0x7F]
        blocked = [i for i, c in enumerate(costs[:0x20]) if c == 0 or c >= 0x7F]
        assert passable and blocked, f"class {cls.class_id:#x} mov costs look wrong"
        cls.good_terrain = passable[0]
        cls.bad_terrain = blocked[0]

    # -- machine setup --------------------------------------------------
    def _machine(self, *, summoner=(4, 7), occupied=(), terrain=None, hidden=()):
        g = Gba(self.rom)
        g.w16(MAP_SIZE, WIDTH)
        g.w16(MAP_SIZE + 2, HEIGHT)
        g.w8(CHAPTER_DATA + 0x15, 0)  # clear weather

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
        for x, y in hidden:
            g.w8(LAYERS["hidden"][1] + y * STRIDE + x, 0x01)

        unit = bytearray(0x48)
        unit[0x10], unit[0x11] = summoner
        g.uc.mem_write(SUMMONER, bytes(unit))
        g.w32(G_ACTIVE_UNIT, SUMMONER)
        g.w32(G_TARGET_ARRAY_SIZE, 0)
        return g

    def _pick(self, **kwargs):
        g = self._machine(**kwargs)
        g.set_args(SUMMONER)
        try:
            g.run(ROM_LOAD + self.syms["SummonMakeTargetList"])
        except Exception as exc:  # UcError
            self.fail(f"SummonMakeTargetList faulted at pc={g.pc:#x}: {exc}")
        return g

    def _tiles(self, g):
        count = g.r32(G_TARGET_ARRAY_SIZE)
        return {
            (
                g.s8(G_TARGET_ARRAY + TARGET_ENTRY_SIZE * i),
                g.s8(G_TARGET_ARRAY + TARGET_ENTRY_SIZE * i + 1),
            )
            for i in range(count)
        }

    # -- the target list ------------------------------------------------
    def test_all_four_cardinal_tiles_are_offered_when_they_are_free(self):
        g = self._pick(summoner=(4, 7))
        self.assertEqual(
            self._tiles(g), {(3, 7), (5, 7), (4, 6), (4, 8)}
        )

    def test_the_summoners_own_tile_is_never_offered(self):
        g = self._pick(summoner=(4, 7))
        self.assertNotIn((4, 7), self._tiles(g))

    def test_a_tile_holding_a_unit_is_rejected(self):
        g = self._pick(summoner=(4, 7), occupied=[(5, 7)])
        self.assertEqual(self._tiles(g), {(3, 7), (4, 6), (4, 8)})

    def test_a_tile_holding_a_fog_hidden_unit_is_rejected(self):
        g = self._pick(summoner=(4, 7), hidden=[(4, 6)])
        self.assertEqual(self._tiles(g), {(3, 7), (5, 7), (4, 8)})

    def test_terrain_the_summoned_class_cannot_cross_is_rejected(self):
        g = self._pick(summoner=(4, 7), terrain=self.bad_terrain)
        self.assertEqual(
            self._tiles(g),
            set(),
            f"terrain {self.bad_terrain:#x} costs 0 for class "
            f"{self.class_id:#x} but was still offered",
        )

    def test_the_map_edge_clips_the_offer(self):
        g = self._pick(summoner=(0, 0))
        self.assertEqual(self._tiles(g), {(1, 0), (0, 1)})

    def test_a_fully_boxed_in_summoner_offers_nothing(self):
        """This is the case the usability check turns into "hide the command"."""
        g = self._pick(summoner=(4, 7), occupied=[(3, 7), (5, 7), (4, 6), (4, 8)])
        self.assertEqual(self._tiles(g), set())
        self.assertEqual(g.r32(G_TARGET_ARRAY_SIZE), 0)

    # -- the blue highlight ---------------------------------------------
    def _highlight(self, **kwargs):
        g = self._pick(**kwargs)
        seen = []
        g.stub(SHOW_MOVE_RANGE_GFX, lambda m: seen.append(m.r0))
        # Poison movement with plausible leftovers from a previous move range,
        # so a routine that forgets to clear it fails instead of passing.
        g.uc.mem_write(LAYERS["movement"][1], bytes([0x03]) * SPAN)
        try:
            g.run(ROM_LOAD + self.syms["SummonShowRange"])
        except Exception as exc:  # UcError
            self.fail(f"SummonShowRange faulted at pc={g.pc:#x}: {exc}")
        return g, seen

    def _movement(self, g, x, y):
        row = g.r32(LAYERS["movement"][0] + 4 * y)
        return g.s8(row + x)

    def test_summonable_tiles_read_back_as_blue(self):
        g, _ = self._highlight(summoner=(4, 7))
        for tile in ((3, 7), (5, 7), (4, 6), (4, 8)):
            with self.subTest(tile=tile):
                self.assertGreaterEqual(
                    self._movement(g, *tile),
                    0,
                    "renderer takes the range branch here, so no blue square",
                )

    def test_every_other_tile_stays_unpainted(self):
        g, _ = self._highlight(summoner=(4, 7))
        blue = {(3, 7), (5, 7), (4, 6), (4, 8)}
        for y in range(HEIGHT):
            for x in range(WIDTH):
                if (x, y) in blue:
                    continue
                with self.subTest(tile=(x, y)):
                    self.assertLess(
                        self._movement(g, x, y),
                        0,
                        "stale movement byte would draw a blue square here",
                    )

    def test_a_rejected_tile_is_not_painted(self):
        g, _ = self._highlight(summoner=(4, 7), occupied=[(5, 7)])
        self.assertLess(self._movement(g, 5, 7), 0)

    def test_the_graphics_request_asks_for_the_movement_layer(self):
        _, seen = self._highlight(summoner=(4, 7))
        self.assertEqual(len(seen), 1, "DisplayMoveRangeGraphics was not called")
        self.assertEqual(
            seen[0] & 1, 1, f"flags {seen[0]:#x} do not include the blue layer"
        )


@unittest.skipUnless(Uc is not None, f"Unicorn unavailable: {UNICORN_ERROR}")
@unittest.skipUnless(HACK.exists(), "FE7_Hack.gba not built")
class SummonInstallationTests(unittest.TestCase):
    """Structural checks on the pointers EA wrote, which no execution reaches.

    A target-selection callback that loses its Thumb bit is reached by `bx` in
    ARM mode and crashes on the first instruction, and nothing in the summon
    routines themselves would show it.
    """

    @classmethod
    def setUpClass(cls):
        cls.rom = HACK.read_bytes()
        cls.syms = action_symbols(cls.rom)
        assert cls.syms, "the summon action is not installed"

    def _word(self, offset):
        return struct.unpack_from("<I", self.rom, offset)[0]

    def test_fe7s_action_table_points_at_the_summon_entry(self):
        entry = self._word(SUMMON_TABLE_ENTRY)
        self.assertEqual(
            (entry - ROM_LOAD) & ~1,
            self.syms["SummonActionEntry"],
            f"action id 0x05 resolves to {entry:#010x}, not SummonActionEntry",
        )

    def test_target_selection_callbacks_are_thumb_pointers(self):
        table = self.syms["SummonLinks"] - 0x20  # the struct sits just before
        for index, name in ((0, "init"), (1, "end"), (3, "switch in"), (5, "A press")):
            with self.subTest(callback=name):
                value = self._word(table + 4 * index)
                self.assertTrue(value & 1, f"{name} pointer {value:#010x} is even")

    def test_the_b_press_returns_to_the_unit_menu(self):
        table = self.syms["SummonLinks"] - 0x20
        self.assertEqual(
            self._word(table + 4 * 6),
            0x08021655,  # GenericSelection_BackToUM
        )

    def test_the_linked_ids_reached_the_rom(self):
        links = self.syms["SummonLinks"]
        self.assertEqual(self._word(links), 0x86, "character id")
        self.assertEqual(self._word(links + 4), 0x46, "class id")
        self.assertEqual(self._word(links + 8), 0x8F, "item id")
        self.assertNotEqual(self._word(links + 12), 0, "help text id is unset")


if __name__ == "__main__":
    unittest.main()
