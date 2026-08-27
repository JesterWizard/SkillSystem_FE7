"""Execute Ardent Sacrifice and Reciprocal Aid out of FE7_Hack.gba.

Same failure mode as Sacrifice: FE8 C, action ids 0x2A/0x2B above
ApplyUnitAction's 0x1B ceiling.  They now share SacrificeAction.s on
0x1D and 0x1E through HighActionTable.  PlayerPhase[0x1E] is repointed
at the default path 0x0801CB68.

Both sides of every targeting gate are asserted.  Residual: skill lookup
is stubbed, HP is written directly (no map anim), Reciprocal Aid caps each
unit at their own max HP.  In-game still wants a look.
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
STATUS_POISON = 1


@unittest.skipUnless(Uc is not None, f"Unicorn unavailable: {UNICORN_ERROR}")
@unittest.skipUnless(HACK.exists(), "FE7_Hack.gba not built")
class ArdentReciprocalTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.rom = HACK.read_bytes()
        cls.syms = action_symbols(cls.rom)
        assert cls.syms, "ApplyUnitActionFE7 is not installed"
        cls.links = links(cls.rom)
        cls.ardent_cb = selection_callbacks(cls.rom, "ArdentSacrificeTargetSelection")
        cls.recip_cb = selection_callbacks(cls.rom, "ReciprocalAidTargetSelection")
        assert cls.ardent_cb["OnSelect"]
        assert cls.recip_cb["OnSelect"]

    def _slot(self, index):
        return struct.unpack_from(
            "<I", self.rom, RAM_SLOT_TABLE - ROM_LOAD + 4 * index
        )[0]

    def _machine(
        self,
        *,
        target=None,
        enemy=False,
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
        g.target = (
            place(
                tid,
                *target,
                hp=target_hp,
                maxhp=target_max,
                st=status,
                state=US_RESCUED if rescued else 0,
            )
            if target
            else 0
        )
        g.tid = tid
        g.tile = tile
        return g

    def _entries(self, g):
        out = []
        for i in range(g.r32(G_TARGET_ARRAY_SIZE)):
            at = G_TARGET_ARRAY + 0xC * i
            out.append((g.r8(at), g.r8(at + 1), g.r8(at + 2)))
        return out

    def _list(self, make, **kwargs):
        g = self._machine(**kwargs)
        g.set_args(g.actor)
        g.run(ROM_LOAD + self.syms[make])
        return g

    def _usability(self, routine, *, skill=True, **kwargs):
        g = self._machine(**kwargs)
        g.stub(self.links["SkillTester"], lambda m: m.set_args(1 if skill else 0))
        g.run(ROM_LOAD + self.syms[routine])
        return g

    def _select(self, callbacks, target=(5, 7), **kwargs):
        g = self._machine(target=target, **kwargs)
        entry = 0x0203E100
        g.w8(entry, target[0])
        g.w8(entry + 1, target[1])
        g.w8(entry + 2, g.tid)
        g.uc.mem_write(G_ACTION_DATA, bytes(0x24))
        g.set_args(0, entry)
        g.run(callbacks["OnSelect"] & ~1)
        return g

    def _act(self, do_action, action_id, **kwargs):
        g = self._machine(target=(5, 7), **kwargs)
        g.uc.mem_write(G_ACTION_DATA, bytes(0x24))
        g.w8(G_ACTION_DATA + 0x0C, ACTOR_INDEX)
        g.w8(G_ACTION_DATA + 0x0D, g.tid)
        g.w8(G_ACTION_DATA + 0x11, action_id)
        g.stub(REFRESH_ENTITY_MAPS)
        g.set_args(0x02026B00)
        g.run(ROM_LOAD + self.syms[do_action])
        return g

    def _dispatch(self, action_id, **kwargs):
        g = self._machine(target=(5, 7), **kwargs)
        g.uc.mem_write(G_ACTION_DATA, bytes(0x24))
        g.w8(G_ACTION_DATA + 0x0C, ACTOR_INDEX)
        g.w8(G_ACTION_DATA + 0x0D, ALLY_INDEX)
        g.w8(G_ACTION_DATA + 0x11, action_id)
        g.stub(REFRESH_ENTITY_MAPS)
        g.set_args(0x02026B00)
        g.run(APPLY_UNIT_ACTION)
        return g

    def test_action_ids_match_the_installer_and_fit_player_phase(self):
        for name, expected in (("ArdentSacrifice", 0x1D), ("ReciprocalAid", 0x1E)):
            with self.subTest(name=name):
                self.assertEqual(source_action_id(name), installer_action_id(name))
                self.assertEqual(installer_action_id(name), expected)
                pre = struct.unpack_from("<I", self.rom, 0x1CA80 + 4 * expected)[0]
                self.assertEqual(pre, 0x0801CB68, hex(expected))

    def test_high_action_table_reaches_both_entries(self):
        table = self.syms["HighActionTable"]
        ardent = struct.unpack_from("<I", self.rom, table + 4)[0]
        recip = struct.unpack_from("<I", self.rom, table + 8)[0]
        self.assertEqual(
            (ardent - ROM_LOAD) & ~1, self.syms["ArdentSacrificeActionEntry"]
        )
        self.assertEqual(
            (recip - ROM_LOAD) & ~1, self.syms["ReciprocalAidActionEntry"]
        )

    def test_menu_rows_call_the_fe7_native_routines(self):
        menu = SKILLS_MENU.read_text(encoding="utf-8", errors="replace")
        self.assertIn("$7C, ArdentSacrificeUsability, ArdentSacrificeEffect", menu)
        self.assertIn("$7D, ReciprocalAidUsability, ReciprocalAidEffect", menu)
        self.assertNotIn("$7C, ArdentSacrifice_Usability", menu)
        self.assertNotIn("$7D, ReciprocalAid_Usability", menu)

    def test_skill_id_links_are_filled_in(self):
        defs = (
            ROOT / "EngineHacks/SkillSystem/skill_definitions.event"
        ).read_text(encoding="utf-8", errors="replace")
        self.assertIn(f"#define ArdentSacrificeID {self.links['ArdentID']}", defs)
        self.assertIn(f"#define ReciprocalAidID {self.links['ReciprocalID']}", defs)
        self.assertNotEqual(self.links["ArdentHelp"], 0)
        self.assertNotEqual(self.links["ReciprocalHelp"], 0)

    def test_ardent_lists_a_hurt_ally(self):
        g = self._list("ArdentSacrificeMakeTargetList", target=(5, 7), target_hp=10)
        self.assertEqual(self._entries(g), [(5, 7, ALLY_INDEX)])

    def test_ardent_does_not_list_a_full_hp_poisoned_ally(self):
        g = self._list(
            "ArdentSacrificeMakeTargetList",
            target=(5, 7),
            target_hp=20,
            target_max=20,
            status=STATUS_POISON,
        )
        self.assertEqual(self._entries(g), [])

    def test_ardent_does_not_list_an_enemy(self):
        g = self._list(
            "ArdentSacrificeMakeTargetList", target=(5, 7), target_hp=10, enemy=True
        )
        self.assertEqual(self._entries(g), [])

    def test_ardent_hides_at_1_hp_and_without_the_skill(self):
        self.assertEqual(
            self._usability(
                "ArdentSacrificeUsability", target=(5, 7), target_hp=10, actor_hp=1
            ).r0,
            MENU_HIDDEN,
        )
        self.assertEqual(
            self._usability(
                "ArdentSacrificeUsability", skill=False, target=(5, 7), target_hp=10
            ).r0,
            MENU_HIDDEN,
        )

    def test_ardent_shows_at_2_hp_with_a_hurt_neighbour(self):
        g = self._usability(
            "ArdentSacrificeUsability", target=(5, 7), target_hp=10, actor_hp=2
        )
        self.assertEqual(g.r0, MENU_ENABLED)

    def test_ardent_a_press_writes_0x1d(self):
        g = self._select(self.ardent_cb)
        self.assertEqual(g.r8(G_ACTION_DATA + 0x11), 0x1D)
        self.assertEqual(g.r8(G_ACTION_DATA + 0x0D), ALLY_INDEX)
        self.assertEqual(g.r0, SELECTION_DONE)

    def test_ardent_caps_heal_at_10(self):
        g = self._act(
            "ArdentSacrificeDoAction", 0x1D, actor_hp=20, target_hp=5, target_max=20
        )
        self.assertEqual(g.r8(g.target + U_CURHP), 15)
        self.assertEqual(g.r8(g.actor + U_CURHP), 10)

    def test_ardent_caps_at_missing_hp_when_below_10(self):
        g = self._act(
            "ArdentSacrificeDoAction", 0x1D, actor_hp=20, target_hp=18, target_max=20
        )
        self.assertEqual(g.r8(g.target + U_CURHP), 20)
        self.assertEqual(g.r8(g.actor + U_CURHP), 18)

    def test_ardent_does_not_cure_poison(self):
        g = self._act(
            "ArdentSacrificeDoAction",
            0x1D,
            actor_hp=20,
            target_hp=10,
            status=STATUS_POISON,
        )
        self.assertEqual(g.r8(g.target + U_STATUS), STATUS_POISON)
        self.assertEqual(g.r8(g.target + U_CURHP), 20)

    def test_ardent_dispatch_through_the_hook(self):
        g = self._dispatch(0x1D, target_hp=10)
        self.assertEqual(g.r8(g.target + U_CURHP), 20)
        self.assertEqual(g.r8(g.actor + U_CURHP), 10)

    def test_reciprocal_lists_unequal_hp(self):
        g = self._list("ReciprocalAidMakeTargetList", target=(5, 7), target_hp=5)
        self.assertEqual(self._entries(g), [(5, 7, ALLY_INDEX)])

    def test_reciprocal_does_not_list_when_both_are_full(self):
        g = self._list(
            "ReciprocalAidMakeTargetList",
            target=(5, 7),
            actor_hp=20,
            actor_max=20,
            target_hp=15,
            target_max=15,
        )
        self.assertEqual(self._entries(g), [])

    def test_reciprocal_lists_a_full_ally_whose_max_can_take_the_swap(self):
        g = self._list(
            "ReciprocalAidMakeTargetList",
            target=(5, 7),
            actor_hp=10,
            actor_max=20,
            target_hp=15,
            target_max=15,
        )
        self.assertEqual(self._entries(g), [(5, 7, ALLY_INDEX)])

    def test_reciprocal_does_not_list_an_enemy(self):
        g = self._list(
            "ReciprocalAidMakeTargetList", target=(5, 7), target_hp=5, enemy=True
        )
        self.assertEqual(self._entries(g), [])

    def test_reciprocal_hides_without_the_skill_and_shows_at_1_hp(self):
        self.assertEqual(
            self._usability(
                "ReciprocalAidUsability", skill=False, target=(5, 7), target_hp=5
            ).r0,
            MENU_HIDDEN,
        )
        self.assertEqual(
            self._usability(
                "ReciprocalAidUsability",
                target=(5, 7),
                actor_hp=1,
                actor_max=20,
                target_hp=10,
            ).r0,
            MENU_ENABLED,
        )

    def test_reciprocal_a_press_writes_0x1e(self):
        g = self._select(self.recip_cb)
        self.assertEqual(g.r8(G_ACTION_DATA + 0x11), 0x1E)
        self.assertEqual(g.r8(G_ACTION_DATA + 0x0D), ALLY_INDEX)

    def test_reciprocal_swaps_when_the_actor_has_more_hp(self):
        g = self._act(
            "ReciprocalAidDoAction", 0x1E, actor_hp=20, target_hp=5, target_max=20
        )
        self.assertEqual(g.r8(g.actor + U_CURHP), 5)
        self.assertEqual(g.r8(g.target + U_CURHP), 20)

    def test_reciprocal_swaps_when_the_target_has_more_hp(self):
        g = self._act(
            "ReciprocalAidDoAction", 0x1E, actor_hp=5, target_hp=20, target_max=20
        )
        self.assertEqual(g.r8(g.actor + U_CURHP), 20)
        self.assertEqual(g.r8(g.target + U_CURHP), 5)

    def test_reciprocal_caps_each_unit_at_their_own_max(self):
        g = self._act(
            "ReciprocalAidDoAction",
            0x1E,
            actor_hp=20,
            actor_max=20,
            target_hp=10,
            target_max=15,
        )
        self.assertEqual(g.r8(g.target + U_CURHP), 15)
        self.assertEqual(g.r8(g.actor + U_CURHP), 15)

    def test_reciprocal_dispatch_through_the_hook(self):
        g = self._dispatch(0x1E, actor_hp=20, target_hp=5, target_max=20)
        self.assertEqual(g.r8(g.actor + U_CURHP), 5)
        self.assertEqual(g.r8(g.target + U_CURHP), 20)
        self.assertTrue(g.r32(g.actor + U_STATE) & US_UNSELECTABLE)


if __name__ == "__main__":
    unittest.main()
