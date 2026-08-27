"""Execute Sacrifice out of FE7_Hack.gba: the list, the menu gate, HP drain,
and status cure.

Sacrifice.c is FE8 (action 0x29, FE8 CLib).  0x29 is above ApplyUnitAction's
0x1B ceiling, so the command could not run.  It is now FE7-native code on
action id 0x1C, reached through ApplyUnitActionFE7 at 0x0802F218.

Both sides of every gate are asserted.  Residual: skill lookup is stubbed,
and the FE8 vulnerary/bomb map anim is not ported -- HP and status are
written directly.  In-game still wants a look at the HP bars.
"""
from __future__ import annotations

import struct
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(Path(__file__).resolve().parent))

from gba_machine import Gba, ROM_LOAD, UNICORN_ERROR, Uc  # noqa: E402

from sacrifice_symbols import (  # noqa: E402
    HACK,
    JUMP_TO_HACK,
    SKILLS_MENU,
    action_symbols,
    installer_action_id,
    links,
    selection_callbacks,
    source_action_id,
)

APPLY_UNIT_ACTION = 0x0802F218
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
U_XPOS, U_YPOS, U_MAXHP, U_CURHP, U_STATUS = 0x10, 0x11, 0x12, 0x13, 0x30
US_UNSELECTABLE, US_RESCUED = 0x40, 0x20
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

STATUS_POISON, STATUS_SLEEP, STATUS_SILENCE, STATUS_BERSERK = 1, 2, 3, 4
STATUS_ATTACK, STATUS_SICK, STATUS_PETRIFY = 5, 9, 11


@unittest.skipUnless(Uc is not None, f"Unicorn unavailable: {UNICORN_ERROR}")
@unittest.skipUnless(HACK.exists(), "FE7_Hack.gba not built")
class SacrificeTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.rom = HACK.read_bytes()
        cls.syms = action_symbols(cls.rom)
        assert cls.syms, (
            "ApplyUnitAction is not hooked to ApplyUnitActionFE7; "
            "Sacrifice is not installed"
        )
        cls.links = links(cls.rom)
        cls.callbacks = selection_callbacks(cls.rom)

    def _slot(self, index):
        return struct.unpack_from(
            "<I", self.rom, RAM_SLOT_TABLE - ROM_LOAD + 4 * index
        )[0]

    def _machine(
        self,
        *,
        target=None,
        enemy=False,
        occupied=(),
        actor_hp=20,
        actor_max=20,
        target_hp=10,
        target_max=20,
        status=0,
        rescued=False,
    ):
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
                g.w8(tile("terrain", x, y), 1)
        for i in range(1, 0x100):
            ptr = self._slot(i)
            if ptr:
                g.uc.mem_write(ptr, bytes(UNIT_SIZE))
                g.w8(ptr + U_INDEX, i)

        def place(index, x, y, *, hp, maxhp, st=0, state=0):
            slot = self._slot(index)
            g.w32(slot + U_PCHARACTER, CHARACTER_TABLE + 0x34 * 0x01)
            g.w32(slot + U_PCLASS, CLASS_TABLE + 0x54 * TEST_CLASS)
            g.w8(slot + U_INDEX, index)
            g.w32(slot + U_STATE, state)
            g.w8(slot + U_XPOS, x)
            g.w8(slot + U_YPOS, y)
            g.w8(slot + U_MAXHP, maxhp)
            g.w8(slot + U_CURHP, hp)
            g.w8(slot + U_STATUS, st)
            g.w8(tile("unit", x, y), index)
            return slot

        g.actor = place(ACTOR_INDEX, *ACTOR, hp=actor_hp, maxhp=actor_max)
        g.w32(G_ACTIVE_UNIT, g.actor)
        tid = ENEMY_INDEX if enemy else ALLY_INDEX
        state = US_RESCUED if rescued else 0
        g.target = (
            place(
                tid,
                *target,
                hp=target_hp,
                maxhp=target_max,
                st=status,
                state=state,
            )
            if target
            else 0
        )
        g.tid = tid
        filler = 3
        for x, y in occupied:
            place(filler, x, y, hp=20, maxhp=20)
            filler += 1
        g.tile = tile
        return g

    def _entries(self, g):
        out = []
        for i in range(g.r32(G_TARGET_ARRAY_SIZE)):
            at = G_TARGET_ARRAY + 0xC * i
            out.append((g.r8(at), g.r8(at + 1), g.r8(at + 2)))
        return out

    def _list(self, **kwargs):
        g = self._machine(**kwargs)
        g.set_args(g.actor)
        g.run(ROM_LOAD + self.syms["SacrificeMakeTargetList"])
        return g

    def _usability(self, *, skill=True, **kwargs):
        g = self._machine(**kwargs)
        g.stub(self.links["SkillTester"], lambda m: m.set_args(1 if skill else 0))
        g.run(ROM_LOAD + self.syms["SacrificeUsability"])
        return g

    def _select(self, target=(5, 7), **kwargs):
        g = self._machine(target=target, **kwargs)
        entry = 0x0203E100
        g.w8(entry, target[0])
        g.w8(entry + 1, target[1])
        g.w8(entry + 2, g.tid)
        g.uc.mem_write(G_ACTION_DATA, bytes(0x24))
        g.set_args(0, entry)
        g.run(self.callbacks["OnSelect"] & ~1)
        return g

    def _act(self, **kwargs):
        g = self._machine(target=(5, 7), **kwargs)
        g.uc.mem_write(G_ACTION_DATA, bytes(0x24))
        g.w8(G_ACTION_DATA + 0x0C, ACTOR_INDEX)
        g.w8(G_ACTION_DATA + 0x0D, g.tid)
        g.w8(G_ACTION_DATA + 0x11, installer_action_id())
        g.stub(REFRESH_ENTITY_MAPS)
        g.set_args(0x02026B00)
        g.run(ROM_LOAD + self.syms["SacrificeDoAction"])
        return g

    def test_the_action_id_is_the_same_in_the_source_and_the_installer(self):
        self.assertEqual(source_action_id(), installer_action_id())
        self.assertEqual(installer_action_id(), 0x1C)

    def test_apply_unit_action_is_hooked(self):
        self.assertEqual(self.rom[0x2F218:0x2F21C], JUMP_TO_HACK)
        entry = struct.unpack_from("<I", self.rom, 0x2F21C)[0]
        self.assertEqual(entry, ROM_LOAD + self.syms["ApplyUnitActionFE7"] + 1)

    def test_player_phase_sends_0x1c_down_the_default_path(self):
        pre = struct.unpack_from("<I", self.rom, 0x1CA80 + 4 * 0x1C)[0]
        self.assertEqual(pre, 0x0801CB68)

    def test_high_action_table_reaches_the_sacrifice_entry(self):
        table = self.syms["HighActionTable"]
        entry = struct.unpack_from("<I", self.rom, table)[0]
        self.assertEqual((entry - ROM_LOAD) & ~1, self.syms["SacrificeActionEntry"])

    def test_the_menu_row_calls_the_fe7_native_routines(self):
        menu = SKILLS_MENU.read_text(encoding="utf-8", errors="replace")
        self.assertIn("$7B, SacrificeUsability, SacrificeEffect", menu)
        self.assertNotIn("$7B, Sacrifice_Usability", menu)

    def test_b_press_returns_to_the_unit_menu(self):
        self.assertEqual(self.callbacks["OnBPress"], 0x08021655)

    def test_the_help_text_and_skill_id_links_are_filled_in(self):
        defs = (
            ROOT / "EngineHacks/SkillSystem/skill_definitions.event"
        ).read_text(encoding="utf-8", errors="replace")
        self.assertIn(f"#define SacrificeID {self.links['SkillID']}", defs)
        self.assertNotEqual(self.links["SkillTester"], 0)
        self.assertNotEqual(self.links["HelpText"], 0)

    def test_a_hurt_adjacent_ally_is_listed(self):
        g = self._list(target=(5, 7), target_hp=10)
        self.assertEqual(self._entries(g), [(5, 7, ALLY_INDEX)])

    def test_all_four_neighbours_are_listed(self):
        for tile in ((5, 7), (3, 7), (4, 6), (4, 8)):
            with self.subTest(tile=tile):
                g = self._list(target=tile, target_hp=10)
                self.assertEqual(self._entries(g), [(*tile, ALLY_INDEX)])

    def test_a_full_hp_ally_is_not_listed(self):
        g = self._list(target=(5, 7), target_hp=20, target_max=20)
        self.assertEqual(self._entries(g), [])

    def test_a_full_hp_poisoned_ally_is_listed(self):
        g = self._list(
            target=(5, 7), target_hp=20, target_max=20, status=STATUS_POISON
        )
        self.assertEqual(self._entries(g), [(5, 7, ALLY_INDEX)])

    def test_a_full_hp_ally_with_an_attack_buff_is_not_listed(self):
        g = self._list(
            target=(5, 7), target_hp=20, target_max=20, status=STATUS_ATTACK
        )
        self.assertEqual(self._entries(g), [])

    def test_an_enemy_is_not_listed(self):
        g = self._list(target=(5, 7), target_hp=10, enemy=True)
        self.assertEqual(self._entries(g), [])

    def test_a_rescued_ally_is_not_listed(self):
        g = self._list(target=(5, 7), target_hp=10, rescued=True)
        self.assertEqual(self._entries(g), [])

    def test_a_unit_that_is_not_adjacent_is_not_listed(self):
        g = self._list(target=(7, 7), target_hp=10)
        self.assertEqual(self._entries(g), [])

    def test_the_command_shows_with_the_skill_and_a_hurt_neighbour(self):
        g = self._usability(target=(5, 7), target_hp=10)
        self.assertEqual(g.r0, MENU_ENABLED)

    def test_the_command_hides_without_the_skill(self):
        g = self._usability(skill=False, target=(5, 7), target_hp=10)
        self.assertEqual(g.r0, MENU_HIDDEN)

    def test_the_command_hides_when_the_actor_is_at_1_hp(self):
        g = self._usability(target=(5, 7), target_hp=10, actor_hp=1)
        self.assertEqual(g.r0, MENU_HIDDEN)

    def test_the_command_shows_when_the_actor_is_at_2_hp(self):
        g = self._usability(target=(5, 7), target_hp=10, actor_hp=2)
        self.assertEqual(g.r0, MENU_ENABLED)

    def test_the_command_hides_when_there_is_nobody_to_heal(self):
        g = self._usability()
        self.assertEqual(g.r0, MENU_HIDDEN)

    def test_the_command_hides_for_a_unit_that_has_already_acted(self):
        g = self._machine(target=(5, 7), target_hp=10)
        g.w32(g.actor + U_STATE, US_UNSELECTABLE)
        g.stub(self.links["SkillTester"], lambda m: m.set_args(1))
        g.run(ROM_LOAD + self.syms["SacrificeUsability"])
        self.assertEqual(g.r0, MENU_HIDDEN)

    def test_the_a_press_records_the_action_and_the_target(self):
        g = self._select((5, 7))
        self.assertEqual(g.r8(G_ACTION_DATA + 0x11), installer_action_id())
        self.assertEqual(g.r8(G_ACTION_DATA + 0x0D), ALLY_INDEX)
        self.assertEqual(g.r0, SELECTION_DONE)

    def test_the_a_press_does_not_write_the_actors_own_destination(self):
        g = self._select((5, 7))
        self.assertEqual((g.r8(G_ACTION_DATA + 0x0E), g.r8(G_ACTION_DATA + 0x0F)), (0, 0))

    def test_drain_fills_the_target_and_leaves_the_rest_on_the_actor(self):
        g = self._act(actor_hp=20, target_hp=5, target_max=20)
        self.assertEqual(g.r8(g.target + U_CURHP), 20)
        self.assertEqual(g.r8(g.actor + U_CURHP), 5)

    def test_drain_caps_at_the_actors_hp_minus_one(self):
        g = self._act(actor_hp=2, target_hp=1, target_max=20)
        self.assertEqual(g.r8(g.actor + U_CURHP), 1)
        self.assertEqual(g.r8(g.target + U_CURHP), 2)

    def test_drain_caps_at_missing_hp(self):
        g = self._act(actor_hp=20, target_hp=18, target_max=20)
        self.assertEqual(g.r8(g.target + U_CURHP), 20)
        self.assertEqual(g.r8(g.actor + U_CURHP), 18)

    def test_a_full_hp_poisoned_ally_is_cured_without_hp_drain(self):
        g = self._act(actor_hp=20, target_hp=20, target_max=20, status=STATUS_POISON)
        self.assertEqual(g.r8(g.actor + U_CURHP), 20)
        self.assertEqual(g.r8(g.target + U_CURHP), 20)
        self.assertEqual(g.r8(g.target + U_STATUS), 0)

    def test_hurt_and_poisoned_is_healed_and_cured(self):
        g = self._act(actor_hp=20, target_hp=10, target_max=20, status=STATUS_POISON)
        self.assertEqual(g.r8(g.target + U_CURHP), 20)
        self.assertEqual(g.r8(g.actor + U_CURHP), 10)
        self.assertEqual(g.r8(g.target + U_STATUS), 0)

    def test_sleep_silence_berserk_sick_petrify_are_cured(self):
        for st in (STATUS_SLEEP, STATUS_SILENCE, STATUS_BERSERK, STATUS_SICK, STATUS_PETRIFY):
            with self.subTest(status=st):
                g = self._act(actor_hp=20, target_hp=20, target_max=20, status=st)
                self.assertEqual(g.r8(g.target + U_STATUS), 0, st)

    def test_an_attack_buff_is_not_cleared_when_healing(self):
        g = self._act(actor_hp=20, target_hp=10, target_max=20, status=STATUS_ATTACK)
        self.assertEqual(g.r8(g.target + U_CURHP), 20)
        self.assertEqual(g.r8(g.target + U_STATUS), STATUS_ATTACK)

    def test_the_action_ends_the_actors_turn(self):
        g = self._act(target_hp=10)
        self.assertTrue(g.r32(g.actor + U_STATE) & US_UNSELECTABLE)

    def test_the_action_yields(self):
        self.assertEqual(self._act(target_hp=10).r0, 0)

    def test_a_missing_target_is_a_no_op(self):
        g = self._machine()
        g.uc.mem_write(G_ACTION_DATA, bytes(0x24))
        g.w8(G_ACTION_DATA + 0x0D, 0)
        g.stub(REFRESH_ENTITY_MAPS)
        g.set_args(0x02026B00)
        g.run(ROM_LOAD + self.syms["SacrificeDoAction"])
        self.assertEqual(g.r0, 0)
        self.assertFalse(g.r32(g.actor + U_STATE) & US_UNSELECTABLE)

    def test_dispatch_through_the_hook_applies_the_heal(self):
        g = self._machine(target=(5, 7), target_hp=10)
        g.uc.mem_write(G_ACTION_DATA, bytes(0x24))
        g.w8(G_ACTION_DATA + 0x0C, ACTOR_INDEX)
        g.w8(G_ACTION_DATA + 0x0D, ALLY_INDEX)
        g.w8(G_ACTION_DATA + 0x11, installer_action_id())
        g.stub(REFRESH_ENTITY_MAPS)
        g.set_args(0x02026B00)
        g.run(APPLY_UNIT_ACTION)
        self.assertEqual(g.r8(g.target + U_CURHP), 20)
        self.assertEqual(g.r8(g.actor + U_CURHP), 10)
        self.assertTrue(g.r32(g.actor + U_STATE) & US_UNSELECTABLE)


if __name__ == "__main__":
    unittest.main()
