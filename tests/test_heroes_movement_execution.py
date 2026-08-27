"""Execute the FE7-native Heroes movement commands out of FE7_Hack.gba.

Same failure mode Shove had: HeroesMovement's .bin blobs are FE8, and their
action ids sit above ApplyUnitAction's 0x1B ceiling.  Each command is rebuilt
against FE7 routines on a vanilla nop slot.  Both sides of every targeting
gate are asserted.

Residual: Mag/2 for Swarp is unit+0x47 (this build's Str/Mag split), skill
lookup is stubbed, and 2-tile slides use one Make6CKOIDO (gameplay coords are
asserted; the extra tile is a snap).  In-game still wants a look.
"""
from __future__ import annotations

import struct
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(Path(__file__).resolve().parent))

from gba_machine import Gba, ROM_LOAD, UNICORN_ERROR, Uc  # noqa: E402

if Uc is not None:  # pragma: no branch
    from unicorn.arm_const import UC_ARM_REG_R1, UC_ARM_REG_R2, UC_ARM_REG_R3  # noqa: E402

from heroes_move_symbols import (  # noqa: E402
    HACK,
    SKILLS,
    SKILLS_MENU,
    action_symbols,
    installer_action_id,
    links,
    selection_callbacks,
    source_action_id,
    table_entry_offset,
)

APPLY_UNIT_ACTION = 0x0802F218
NEW_UNIT_MOVE_PROC = 0x0801D47C
REFRESH_ENTITY_MAPS = 0x08019ABC
G_ACTIVE_UNIT = 0x03004690
G_ACTION_DATA = 0x0203A85C
G_TARGET_ARRAY = 0x0203DCF8
G_TARGET_ARRAY_SIZE = 0x0203DFF8
CHAPTER_DATA = 0x0202BBF8
MAP_SIZE = 0x0202E3D8
PP_MAP_UNIT = 0x0202E3DC
PP_MAP_TERRAIN = 0x0202E3E0
PP_MAP_MOVEMENT = 0x0202E3E4
PP_MAP_RANGE = 0x0202E3E8
PP_MAP_FOG = 0x0202E3EC
PP_MAP_HIDDEN = 0x0202E3F0
RAM_SLOT_TABLE = 0x08B92EB0
CHARACTER_TABLE = 0x08BDCE18
CLASS_TABLE = 0x08BE015C
TEST_CLASS = 0x02
UNIT_SIZE = 0x48
U_PCHARACTER, U_PCLASS, U_INDEX, U_STATE = 0x00, 0x04, 0x0B, 0x0C
U_XPOS, U_YPOS, U_CURHP, U_MAG = 0x10, 0x11, 0x13, 0x47
US_UNSELECTABLE = 0x40
MENU_ENABLED, MENU_HIDDEN, SELECTION_DONE = 1, 3, 0x17
ACTOR_INDEX, ALLY_INDEX, ENEMY_INDEX = 0x01, 0x02, 0x81
ACTOR = (4, 7)
WIDTH, HEIGHT = 15, 10
LAYERS = {
    "unit": (0x02030000, 0x02031000, PP_MAP_UNIT),
    "movement": (0x02032000, 0x02033000, PP_MAP_MOVEMENT),
    "range": (0x02034000, 0x02035000, PP_MAP_RANGE),
    "hidden": (0x02036000, 0x02037000, PP_MAP_HIDDEN),
    "terrain": (0x02038000, 0x02039000, PP_MAP_TERRAIN),
    "fog": (0x0203A000, 0x0203B000, PP_MAP_FOG),
}


@unittest.skipUnless(Uc is not None, f"Unicorn unavailable: {UNICORN_ERROR}")
@unittest.skipUnless(HACK.exists(), "FE7_Hack.gba not built")
class HeroesMovementTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.rom = HACK.read_bytes()
        cls.syms = {n: action_symbols(cls.rom, n) for n in SKILLS}
        cls.links = {n: links(cls.rom, n) for n in SKILLS}
        cls.callbacks = {n: selection_callbacks(cls.rom, n) for n in SKILLS}
        for n, s in cls.syms.items():
            assert s, f"{n}ActionEntry is not reachable from UnitActionFunctionPointer"
        base = (CLASS_TABLE - ROM_LOAD) + 0x54 * TEST_CLASS
        costs_at = struct.unpack_from("<I", cls.rom, base + 0x38)[0] - ROM_LOAD
        costs = cls.rom[costs_at : costs_at + 0x20]
        cls.good_terrain = next(i for i, c in enumerate(costs) if 0 < c < 0x7F)
        cls.bad_terrain = next(i for i, c in enumerate(costs) if c == 0 or c >= 0x7F)

    def _slot(self, index):
        return struct.unpack_from("<I", self.rom, RAM_SLOT_TABLE - ROM_LOAD + 4 * index)[0]

    def _machine(self, *, target=None, enemy=False, occupied=(), terrain=None, mag=0):
        g = Gba(self.rom)
        g.w16(MAP_SIZE, WIDTH)
        g.w16(MAP_SIZE + 2, HEIGHT)
        g.w8(CHAPTER_DATA + 0x15, 0)
        g.w8(CHAPTER_DATA + 0x0D, 0)
        stride = WIDTH + 2
        for rows_at, data_at, pointer in LAYERS.values():
            g.w32(rows_at - 8, data_at)
            for y in range(HEIGHT + 4):
                g.w32(rows_at + 4 * y, data_at + y * stride)
            g.uc.mem_write(data_at, bytes(stride * (HEIGHT + 4)))
            g.w32(pointer, rows_at)

        def tile(layer, x, y):
            _, data_at, _ = LAYERS[layer]
            return data_at + y * stride + x

        for y in range(HEIGHT):
            for x in range(WIDTH):
                g.w8(tile("terrain", x, y), self.good_terrain)
        for (x, y), value in (terrain or {}).items():
            g.w8(tile("terrain", x, y), value)
        for i in range(1, 0x100):
            ptr = self._slot(i)
            if ptr:
                g.uc.mem_write(ptr, bytes(UNIT_SIZE))
                g.w8(ptr + U_INDEX, i)

        def place(index, x, y):
            slot = self._slot(index)
            g.w32(slot + U_PCHARACTER, CHARACTER_TABLE + 0x34 * 0x01)
            g.w32(slot + U_PCLASS, CLASS_TABLE + 0x54 * TEST_CLASS)
            g.w8(slot + U_INDEX, index)
            g.w32(slot + U_STATE, 0)
            g.w8(slot + U_XPOS, x)
            g.w8(slot + U_YPOS, y)
            g.w8(slot + U_CURHP, 20)
            g.w8(slot + U_MAG, mag)
            g.w8(tile("unit", x, y), index)
            return slot

        g.actor = place(ACTOR_INDEX, *ACTOR)
        g.w32(G_ACTIVE_UNIT, g.actor)
        g.w8(g.actor + U_MAG, mag)
        tid = ENEMY_INDEX if enemy else ALLY_INDEX
        g.target = place(tid, *target) if target else 0
        g.tid = tid
        filler = 3
        for x, y in occupied:
            place(filler, x, y)
            filler += 1
        g.tile = tile
        return g

    def _entries(self, g):
        out = []
        for i in range(g.r32(G_TARGET_ARRAY_SIZE)):
            at = G_TARGET_ARRAY + 0xC * i
            out.append((g.r8(at), g.r8(at + 1), g.r8(at + 2)))
        return out

    def _list(self, name, **kwargs):
        g = self._machine(**kwargs)
        g.set_args(g.actor)
        g.run(ROM_LOAD + self.syms[name][f"{name}MakeTargetList"])
        return g

    def _usability(self, name, *, skill=True, **kwargs):
        g = self._machine(**kwargs)
        g.stub(self.links[name]["SkillTester"], lambda m: m.set_args(1 if skill else 0))
        g.run(ROM_LOAD + self.syms[name][f"{name}Usability"])
        return g

    def _select(self, name, target, **kwargs):
        g = self._machine(target=target, **kwargs)
        entry = 0x0203E100
        g.w8(entry, target[0])
        g.w8(entry + 1, target[1])
        g.w8(entry + 2, g.tid)
        g.uc.mem_write(G_ACTION_DATA, bytes(0x24))
        g.set_args(0, entry)
        g.run(self.callbacks[name]["OnSelect"] & ~1)
        return g

    def _act(self, name, target=(5, 7), dest=None, **kwargs):
        g = self._machine(target=target, **kwargs)
        g.uc.mem_write(G_ACTION_DATA, bytes(0x24))
        g.w8(G_ACTION_DATA + 0x0C, ACTOR_INDEX)
        g.w8(G_ACTION_DATA + 0x0D, g.tid)
        g.w8(G_ACTION_DATA + 0x11, installer_action_id(name))
        if dest:
            g.w8(G_ACTION_DATA + 0x13, dest[0])
            g.w8(G_ACTION_DATA + 0x14, dest[1])
        g.stub(NEW_UNIT_MOVE_PROC)
        g.stub(REFRESH_ENTITY_MAPS)
        g.stub(0x0806CCB8)  # DeleteAllMoveUnits
        g.set_args(0x02026B00)
        entry = "DrawBackDoAction" if name == "DrawBack" else f"{name}Action"
        g.run(ROM_LOAD + self.syms[name][entry])
        return g

    # -- installation ----------------------------------------------------
    def test_each_action_id_matches_the_installer_and_fits_fe7s_table(self):
        seen = set()
        for name in SKILLS:
            with self.subTest(name=name):
                sid = source_action_id(name)
                iid = installer_action_id(name)
                self.assertEqual(sid, iid)
                self.assertLessEqual(iid, 0x1B)
                self.assertGreaterEqual(iid, 1)
                self.assertNotIn(iid, seen)
                seen.add(iid)
                entry = struct.unpack_from("<I", self.rom, table_entry_offset(name))[0]
                self.assertEqual(
                    entry, ROM_LOAD + self.syms[name][f"{name}ActionEntry"] + 1
                )
                # 0x0801CA38 indexes 0x0801CA80 by action id before
                # ApplyUnitAction.  Take/Give (0x09/0x0A) go to 0x0801CB40
                # and cancel when those commands' flags are not set.
                pre = struct.unpack_from("<I", self.rom, 0x1CA80 + 4 * iid)[0]
                self.assertEqual(pre, 0x0801CB68, hex(iid))

    def test_the_menu_rows_call_the_fe7_native_routines(self):
        menu = SKILLS_MENU.read_text(encoding="utf-8", errors="replace")
        for name in SKILLS:
            self.assertIn(f"{name}Usability", menu)
            self.assertIn(f"{name}Effect", menu)
            self.assertNotIn(f"pr{name}Command_Usability", menu)
        self.assertNotIn("DrawBack_Usability", menu)

    def test_b_press_returns_to_the_unit_menu(self):
        for name in SKILLS:
            with self.subTest(name=name):
                self.assertEqual(self.callbacks[name]["OnBPress"], 0x08021655)

    # -- Smite -----------------------------------------------------------
    def test_smite_lists_a_unit_with_two_free_tiles_behind_it(self):
        g = self._list("Smite", target=(5, 7))
        self.assertEqual(self._entries(g), [(5, 7, ALLY_INDEX)])

    def test_smite_still_lists_when_only_the_first_tile_is_free(self):
        g = self._list("Smite", target=(5, 7), occupied=((7, 7),))
        self.assertEqual(self._entries(g), [(5, 7, ALLY_INDEX)])

    def test_smite_does_not_list_when_the_first_tile_is_blocked(self):
        g = self._list("Smite", target=(5, 7), occupied=((6, 7),))
        self.assertEqual(self._entries(g), [])

    def test_smite_records_a_two_tile_dest_when_both_are_free(self):
        g = self._select("Smite", (5, 7))
        self.assertEqual(g.r8(G_ACTION_DATA + 0x11), installer_action_id("Smite"))
        self.assertEqual((g.r8(G_ACTION_DATA + 0x13), g.r8(G_ACTION_DATA + 0x14)), (7, 7))

    def test_smite_records_a_one_tile_dest_when_the_second_is_blocked(self):
        g = self._select("Smite", (5, 7), occupied=((7, 7),))
        self.assertEqual((g.r8(G_ACTION_DATA + 0x13), g.r8(G_ACTION_DATA + 0x14)), (6, 7))

    def test_smite_hides_without_the_skill(self):
        g = self._usability("Smite", skill=False, target=(5, 7))
        self.assertEqual(g.r0, MENU_HIDDEN)

    def test_smite_shows_with_the_skill_and_a_free_lane(self):
        g = self._usability("Smite", target=(5, 7))
        self.assertEqual(g.r0, MENU_ENABLED)

    def test_smite_pushes_the_target_and_not_the_actor(self):
        g = self._act("Smite", dest=(7, 7))
        self.assertEqual((g.r8(g.target + U_XPOS), g.r8(g.target + U_YPOS)), (7, 7))
        self.assertEqual((g.r8(g.actor + U_XPOS), g.r8(g.actor + U_YPOS)), ACTOR)
        self.assertTrue(g.r32(g.actor + U_STATE) & US_UNSELECTABLE)

    # -- Pivot -----------------------------------------------------------
    def test_pivot_lists_an_ally_with_a_free_tile_behind_them(self):
        g = self._list("Pivot", target=(5, 7))
        self.assertEqual(self._entries(g), [(5, 7, ALLY_INDEX)])

    def test_pivot_does_not_list_an_enemy(self):
        g = self._list("Pivot", target=(5, 7), enemy=True)
        self.assertEqual(self._entries(g), [])

    def test_pivot_does_not_list_when_the_landing_tile_is_blocked(self):
        g = self._list("Pivot", target=(5, 7), occupied=((6, 7),))
        self.assertEqual(self._entries(g), [])

    def test_pivot_a_press_does_not_queue_a_walk_through_the_ally(self):
        """+0x0E/+0x0F is the walk dest; writing it on A-press delays Pivot until B."""
        g = self._select("Pivot", (5, 7))
        self.assertEqual((g.r8(G_ACTION_DATA + 0x13), g.r8(G_ACTION_DATA + 0x14)), (6, 7))
        self.assertEqual((g.r8(G_ACTION_DATA + 0x0E), g.r8(G_ACTION_DATA + 0x0F)), (0, 0))

    def test_pivot_moves_the_actor_and_then_sets_the_walk_dest(self):
        g = self._act("Pivot", dest=(6, 7))
        self.assertEqual((g.r8(g.actor + U_XPOS), g.r8(g.actor + U_YPOS)), (6, 7))
        self.assertEqual((g.r8(g.target + U_XPOS), g.r8(g.target + U_YPOS)), (5, 7))
        self.assertEqual((g.r8(G_ACTION_DATA + 0x0E), g.r8(G_ACTION_DATA + 0x0F)), (6, 7))

    # -- Reposition ------------------------------------------------------
    def test_reposition_lists_an_ally_with_a_free_tile_behind_the_actor(self):
        g = self._list("Reposition", target=(5, 7))
        self.assertEqual(self._entries(g), [(5, 7, ALLY_INDEX)])

    def test_reposition_does_not_list_an_enemy(self):
        g = self._list("Reposition", target=(5, 7), enemy=True)
        self.assertEqual(self._entries(g), [])

    def test_reposition_does_not_list_when_the_landing_tile_is_blocked(self):
        g = self._list("Reposition", target=(5, 7), occupied=((3, 7),))
        self.assertEqual(self._entries(g), [])

    def test_reposition_records_the_tile_behind_the_actor(self):
        g = self._select("Reposition", (5, 7))
        self.assertEqual((g.r8(G_ACTION_DATA + 0x13), g.r8(G_ACTION_DATA + 0x14)), (3, 7))

    def test_reposition_moves_the_ally_and_not_the_actor(self):
        g = self._act("Reposition", dest=(3, 7))
        self.assertEqual((g.r8(g.target + U_XPOS), g.r8(g.target + U_YPOS)), (3, 7))
        self.assertEqual((g.r8(g.actor + U_XPOS), g.r8(g.actor + U_YPOS)), ACTOR)

    # -- Swap ------------------------------------------------------------
    def test_swap_lists_an_adjacent_ally(self):
        g = self._list("Swap", target=(5, 7))
        self.assertEqual(self._entries(g), [(5, 7, ALLY_INDEX)])

    def test_swap_does_not_list_an_enemy(self):
        g = self._list("Swap", target=(5, 7), enemy=True)
        self.assertEqual(self._entries(g), [])

    def test_swap_does_not_list_a_unit_that_is_not_adjacent(self):
        g = self._list("Swap", target=(7, 7))
        self.assertEqual(self._entries(g), [])

    def test_swap_a_press_does_not_queue_a_walk_onto_the_ally(self):
        g = self._select("Swap", (5, 7))
        self.assertEqual((g.r8(G_ACTION_DATA + 0x0E), g.r8(G_ACTION_DATA + 0x0F)), (0, 0))

    def test_swap_exchanges_the_two_tiles(self):
        g = self._act("Swap")
        self.assertEqual((g.r8(g.actor + U_XPOS), g.r8(g.actor + U_YPOS)), (5, 7))
        self.assertEqual((g.r8(g.target + U_XPOS), g.r8(g.target + U_YPOS)), ACTOR)
        self.assertEqual((g.r8(G_ACTION_DATA + 0x0E), g.r8(G_ACTION_DATA + 0x0F)), (5, 7))

    # -- Swarp -----------------------------------------------------------
    def test_swarp_lists_an_ally_inside_mag_by_2(self):
        g = self._list("Swarp", target=(6, 7), mag=4)
        self.assertEqual(self._entries(g), [(6, 7, ALLY_INDEX)])

    def test_swarp_does_not_list_an_ally_outside_mag_by_2(self):
        g = self._list("Swarp", target=(7, 7), mag=4)
        self.assertEqual(self._entries(g), [])

    def test_swarp_does_not_list_when_mag_is_zero(self):
        g = self._list("Swarp", target=(5, 7), mag=0)
        self.assertEqual(self._entries(g), [])

    def test_swarp_does_not_list_an_enemy_in_range(self):
        g = self._list("Swarp", target=(5, 7), enemy=True, mag=4)
        self.assertEqual(self._entries(g), [])

    def test_swarp_hides_when_mag_is_zero(self):
        g = self._usability("Swarp", mag=0, target=(5, 7))
        self.assertEqual(g.r0, MENU_HIDDEN)

    def test_swarp_a_press_does_not_queue_a_walk_onto_the_ally(self):
        g = self._select("Swarp", (6, 7), mag=4)
        self.assertEqual((g.r8(G_ACTION_DATA + 0x0E), g.r8(G_ACTION_DATA + 0x0F)), (0, 0))

    def test_swarp_swaps_at_range(self):
        g = self._act("Swarp", target=(6, 7), mag=4)
        self.assertEqual((g.r8(g.actor + U_XPOS), g.r8(g.actor + U_YPOS)), (6, 7))
        self.assertEqual((g.r8(g.target + U_XPOS), g.r8(g.target + U_YPOS)), ACTOR)
        self.assertEqual((g.r8(G_ACTION_DATA + 0x0E), g.r8(G_ACTION_DATA + 0x0F)), (6, 7))

    # -- Draw Back -------------------------------------------------------
    def test_drawback_lists_an_ally_with_space_behind_the_actor(self):
        g = self._list("DrawBack", target=(5, 7))
        self.assertEqual(self._entries(g), [(5, 7, ALLY_INDEX)])

    def test_drawback_does_not_list_an_enemy(self):
        g = self._list("DrawBack", target=(5, 7), enemy=True)
        self.assertEqual(self._entries(g), [])

    def test_drawback_does_not_list_when_the_tile_behind_the_actor_is_blocked(self):
        g = self._list("DrawBack", target=(5, 7), occupied=((3, 7),))
        self.assertEqual(self._entries(g), [])

    def test_drawback_a_press_does_not_queue_a_walk(self):
        g = self._select("DrawBack", (5, 7))
        dest = (3, 7)
        self.assertEqual((g.r8(G_ACTION_DATA + 0x13), g.r8(G_ACTION_DATA + 0x14)), dest)
        self.assertEqual((g.r8(G_ACTION_DATA + 0x0E), g.r8(G_ACTION_DATA + 0x0F)), (0, 0))

    def test_drawback_steps_the_actor_back_and_pulls_the_ally(self):
        g = self._act("DrawBack", dest=(3, 7))
        self.assertEqual((g.r8(g.actor + U_XPOS), g.r8(g.actor + U_YPOS)), (3, 7))
        self.assertEqual((g.r8(g.target + U_XPOS), g.r8(g.target + U_YPOS)), ACTOR)
        self.assertEqual((g.r8(G_ACTION_DATA + 0x0E), g.r8(G_ACTION_DATA + 0x0F)), (3, 7))


if __name__ == "__main__":
    unittest.main()
