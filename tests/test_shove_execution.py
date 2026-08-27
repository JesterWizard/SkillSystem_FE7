"""Execute Shove out of FE7_Hack.gba: the list, the menu gate, the tile it
picks, and the push itself.

Shove used to be HeroesMovement's prebuilt .bin blobs, which are FE8 code that
nothing in this build ever reassembled -- their literal pools hold gActiveUnit
0x03004E50, gActionData 0x0203A958, StartTargetSelection 0x0804FA3C -- and its
action id 0x26 is above the 0x1B ceiling FE7's ApplyUnitAction enforces before
indexing UnitActionFunctionPointer.  So the command could not run at all.  It is
now FE7-native code on action id 0x0B; these tests execute that code.

Both sides of every gate are asserted.  A usability routine that returned 1
unconditionally, or a target list that added every adjacent unit regardless of
what is behind them, would pass the positive half on its own.

What this cannot show: that a unit in a real chapter owns the Shove skill (the
skill lookup is stubbed in the usability tests), or how the push looks on
screen.  Those still want an in-game check.
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
    from unicorn.arm_const import (  # noqa: E402
        UC_ARM_REG_R1,
        UC_ARM_REG_R2,
        UC_ARM_REG_R3,
    )

from shove_symbols import (  # noqa: E402
    ACTION_S,
    HACK,
    SKILLS_MENU,
    action_symbols,
    installer_action_id,
    links,
    selection_callbacks,
    source_action_id,
    table_entry_offset,
)

APPLY_UNIT_ACTION = 0x0802F218
NEW_UNIT_MOVE_PROC = 0x0801D47C  # Make6CKOIDO
REFRESH_ENTITY_MAPS = 0x08019ABC
NEW_6C = 0x08004494
EXEC_6C = 0x08004690
PROC_TREE_ROOTS = 0x02026A30
PROC_LIST = 0x02024E28
PROC_SIZE = 0x6C
PROC_PARENT = 0x14
PROC_BLOCK_COUNT = 0x28
PROC_UNIT = 0x30        # Make6CKOIDO: +0x2C facing, +0x30 unit, +0x34 MOVEUNIT
PROC_MU = 0x34
PROC_MU_MODE = 0x3C
PROC_OP_END = 0
PARENT_PROC_SCRIPT = 0x08B93440
# Make6CKOIDO's script -- the one-tile slide the vanilla model action
# (ActionDrop, 0x0802F3A4) also parks on its action proc.
SLIDE_SCRIPT = 0x08B935EC
VANILLA_DROP_ACTION_ID = 0x08
# LockGame (0x08015308) / UnlockGame (0x08015318) both count this byte.
GAME_LOCK = 0x0202BBB9
LOCK_GAME = 0x08015308
UNLOCK_GAME = 0x08015318

G_ACTIVE_UNIT = 0x03004690
G_ACTION_DATA = 0x0203A85C
G_TARGET_ARRAY = 0x0203DCF8
G_TARGET_ARRAY_SIZE = 0x0203DFF8
TARGET_ENTRY = 0xC

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
U_PCHARACTER = 0x00
U_PCLASS = 0x04
U_INDEX = 0x0B
U_STATE = 0x0C
U_XPOS = 0x10
U_YPOS = 0x11
U_CURHP = 0x13

US_UNSELECTABLE = 0x40

MENU_ENABLED = 1
MENU_HIDDEN = 3
SELECTION_DONE = 0x17

SHOVER_INDEX = 0x01
TARGET_INDEX = 0x02
SHOVER = (4, 7)

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
class ShoveTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.rom = HACK.read_bytes()
        cls.syms = action_symbols(cls.rom)
        assert cls.syms, (
            "ShoveActionEntry is not reachable from UnitActionFunctionPointer; "
            "the shove action is not installed"
        )
        cls.links = links(cls.rom)
        cls.callbacks = selection_callbacks(cls.rom)

        # Terrain the test class can and cannot stand on, read out of its own
        # clear-weather movement cost table (GetMovCostTablePtr, 0x080187D4).
        base = (CLASS_TABLE - ROM_LOAD) + 0x54 * TEST_CLASS
        costs_at = struct.unpack_from("<I", cls.rom, base + 0x38)[0] - ROM_LOAD
        costs = cls.rom[costs_at : costs_at + 0x20]
        cls.good_terrain = next(i for i, c in enumerate(costs) if 0 < c < 0x7F)
        cls.bad_terrain = next(i for i, c in enumerate(costs) if c == 0 or c >= 0x7F)

    # -- machine ---------------------------------------------------------
    def _slot(self, index):
        return struct.unpack_from(
            "<I", self.rom, RAM_SLOT_TABLE - ROM_LOAD + 4 * index
        )[0]

    def _machine(self, *, target=None, occupied=(), terrain=None, hidden=()):
        """A map with the shover at SHOVER and, optionally, a unit to push.

        `terrain` maps (x, y) -> terrain id; everything else is passable.
        """
        g = Gba(self.rom)
        g.w16(MAP_SIZE, WIDTH)
        g.w16(MAP_SIZE + 2, HEIGHT)
        g.w8(CHAPTER_DATA + 0x15, 0)  # clear weather -> class+0x38 cost table
        g.w8(CHAPTER_DATA + 0x0D, 0)  # no fog

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
        for x, y in hidden:
            g.w8(tile("hidden", x, y), 1)

        # ClearUnits (0x080174D8) zeroes every slot and stamps its own index
        # into +0x0B; GetUnit and AddTarget both rely on that byte.
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
            g.w8(tile("unit", x, y), index)
            return slot

        g.shover = place(SHOVER_INDEX, *SHOVER)
        g.w32(G_ACTIVE_UNIT, g.shover)
        g.target = place(TARGET_INDEX, *target) if target else 0

        filler = TARGET_INDEX + 1
        for x, y in occupied:
            place(filler, x, y)
            filler += 1

        g.tile = tile
        return g

    def _entries(self, g):
        out = []
        for i in range(g.r32(G_TARGET_ARRAY_SIZE)):
            at = G_TARGET_ARRAY + TARGET_ENTRY * i
            out.append((g.r8(at), g.r8(at + 1), g.r8(at + 2)))
        return out

    def _make_list(self, **kwargs):
        g = self._machine(**kwargs)
        g.set_args(g.shover)
        g.run(ROM_LOAD + self.syms["ShoveMakeTargetList"])
        return g

    def _usability(self, *, skill=True, **kwargs):
        g = self._machine(**kwargs)
        g.stub(self.links["SkillTester"], lambda m: m.set_args(1 if skill else 0))
        g.run(ROM_LOAD + self.syms["ShoveUsability"])
        return g

    # -- installation ----------------------------------------------------
    def test_the_action_id_is_the_same_in_the_source_and_the_installer(self):
        """The .s writes it into gActionData; the .event repoints that slot."""
        self.assertEqual(source_action_id(), installer_action_id())

    def test_fe7s_own_dispatch_table_reaches_the_shove_action(self):
        entry = struct.unpack_from("<I", self.rom, table_entry_offset())[0]
        self.assertEqual(
            entry, ROM_LOAD + self.syms["ShoveActionEntry"] + 1, f"{entry:#010x}"
        )

    def test_the_action_id_is_one_apply_unit_action_will_dispatch(self):
        """`sub r0,#1; cmp r0,#0x1A; bhi` -- ids above 0x1B are dropped."""
        self.assertLessEqual(installer_action_id(), 0x1B)
        self.assertGreaterEqual(installer_action_id(), 1)

    def test_the_menu_row_calls_the_fe7_native_routines(self):
        menu = SKILLS_MENU.read_text(encoding="utf-8", errors="replace")
        self.assertIn("$74, ShoveUsability", menu)
        self.assertIn("ShoveEffect", menu)
        self.assertNotIn("prShoveCommand_Usability", menu)

    def test_the_selection_definition_is_fully_populated(self):
        for slot in ("OnInit", "OnEnd", "OnSwitchIn", "OnSelect", "OnBPress"):
            self.assertTrue(self.callbacks[slot], slot)
        # B goes back to the unit menu through FE7's generic handler.
        self.assertEqual(self.callbacks["OnBPress"], 0x08021655)

    def test_the_help_text_and_skill_id_links_are_filled_in(self):
        defs = (
            ROOT / "EngineHacks/SkillSystem/skill_definitions.event"
        ).read_text(encoding="utf-8", errors="replace")
        self.assertIn(f"#define ShoveID {self.links['ShoveID']}", defs)
        self.assertNotEqual(self.links["SkillTester"], 0)
        self.assertNotEqual(self.links["HelpText"], 0)

    # -- target list -----------------------------------------------------
    def test_an_adjacent_unit_with_a_free_tile_behind_it_is_shovable(self):
        g = self._make_list(target=(5, 7))
        self.assertEqual(self._entries(g), [(5, 7, TARGET_INDEX)])

    def test_all_four_neighbours_are_shovable(self):
        for tile in ((5, 7), (3, 7), (4, 6), (4, 8)):
            with self.subTest(tile=tile):
                g = self._make_list(target=tile)
                self.assertEqual(self._entries(g), [(*tile, TARGET_INDEX)])

    def test_a_unit_with_someone_standing_behind_it_is_not_shovable(self):
        g = self._make_list(target=(5, 7), occupied=((6, 7),))
        self.assertEqual(self._entries(g), [])

    def test_a_unit_with_a_fog_hidden_unit_behind_it_is_not_shovable(self):
        """The unit map reads 0 there, so only the hidden map catches it."""
        g = self._make_list(target=(5, 7), hidden=((6, 7),))
        self.assertEqual(self._entries(g), [])

    def test_a_unit_backed_against_the_map_edge_is_not_shovable(self):
        g = self._machine(target=(0, 7))
        g.w8(g.shover + U_XPOS, 1)
        g.w8(g.tile("unit", *SHOVER), 0)
        g.w8(g.tile("unit", 1, 7), SHOVER_INDEX)
        g.set_args(g.shover)
        g.run(ROM_LOAD + self.syms["ShoveMakeTargetList"])
        self.assertEqual(self._entries(g), [])

    def test_a_unit_cannot_be_shoved_onto_terrain_it_cannot_cross(self):
        g = self._make_list(target=(5, 7), terrain={(6, 7): self.bad_terrain})
        self.assertEqual(self._entries(g), [])

    def test_the_terrain_check_follows_the_pushed_unit_not_the_shover(self):
        """A flier shoving a knight must not put the knight in a chasm."""
        g = self._machine(target=(5, 7), terrain={(6, 7): self.bad_terrain})
        # Give the shover a class that can cross anything; the answer must not
        # change, because it is the target that has to stand there.
        g.w32(g.shover + U_STATE, 0x800)  # flier movement cost table
        g.set_args(g.shover)
        g.run(ROM_LOAD + self.syms["ShoveMakeTargetList"])
        self.assertEqual(self._entries(g), [])

    def test_a_unit_that_is_not_adjacent_is_not_listed(self):
        g = self._make_list(target=(7, 7))
        self.assertEqual(self._entries(g), [])

    def test_the_shover_never_lists_itself(self):
        g = self._make_list()
        self.assertEqual(self._entries(g), [])

    # -- usability -------------------------------------------------------
    def test_the_command_shows_with_the_skill_and_a_shovable_neighbour(self):
        g = self._usability(target=(5, 7))
        self.assertEqual(g.r0, MENU_ENABLED)

    def test_the_command_hides_without_the_skill(self):
        g = self._usability(skill=False, target=(5, 7))
        self.assertEqual(g.r0, MENU_HIDDEN)

    def test_the_command_hides_when_there_is_nobody_to_shove(self):
        g = self._usability()
        self.assertEqual(g.r0, MENU_HIDDEN)

    def test_the_command_hides_when_the_shovable_neighbour_is_blocked(self):
        g = self._usability(target=(5, 7), occupied=((6, 7),))
        self.assertEqual(g.r0, MENU_HIDDEN)

    def test_the_command_hides_for_a_unit_that_has_already_acted(self):
        g = self._machine(target=(5, 7))
        g.w32(g.shover + U_STATE, US_UNSELECTABLE)
        g.stub(self.links["SkillTester"], lambda m: m.set_args(1))
        g.run(ROM_LOAD + self.syms["ShoveUsability"])
        self.assertEqual(g.r0, MENU_HIDDEN)

    # -- the A press -----------------------------------------------------
    def _select(self, target):
        g = self._machine(target=target)
        entry = 0x0203E100
        g.w8(entry, target[0])
        g.w8(entry + 1, target[1])
        g.w8(entry + 2, TARGET_INDEX)
        g.uc.mem_write(G_ACTION_DATA, bytes(0x24))
        g.set_args(0, entry)
        g.run(self.callbacks["OnSelect"] & ~1)
        return g

    def test_the_a_press_records_the_action_the_target_and_the_landing_tile(self):
        for target, dest in (
            ((5, 7), (6, 7)),
            ((3, 7), (2, 7)),
            ((4, 6), (4, 5)),
            ((4, 8), (4, 9)),
        ):
            with self.subTest(target=target):
                g = self._select(target)
                self.assertEqual(g.r8(G_ACTION_DATA + 0x11), installer_action_id())
                self.assertEqual(g.r8(G_ACTION_DATA + 0x0D), TARGET_INDEX)
                self.assertEqual(
                    (g.r8(G_ACTION_DATA + 0x13), g.r8(G_ACTION_DATA + 0x14)), dest
                )
                self.assertEqual(g.r0, SELECTION_DONE)

    def test_the_a_press_does_not_write_the_shovers_own_destination(self):
        """+0x0E/+0x0F is where PlayerPhase walks the acting unit to."""
        g = self._select((5, 7))
        self.assertEqual((g.r8(G_ACTION_DATA + 0x0E), g.r8(G_ACTION_DATA + 0x0F)), (0, 0))

    # -- the action ------------------------------------------------------
    def _act(self, target=(5, 7), dest=(6, 7)):
        g = self._machine(target=target)
        g.uc.mem_write(G_ACTION_DATA, bytes(0x24))
        g.w8(G_ACTION_DATA + 0x0C, SHOVER_INDEX)
        g.w8(G_ACTION_DATA + 0x0D, TARGET_INDEX)
        g.w8(G_ACTION_DATA + 0x11, installer_action_id())
        g.w8(G_ACTION_DATA + 0x13, dest[0])
        g.w8(G_ACTION_DATA + 0x14, dest[1])

        moves = []

        def on_move(m):
            moves.append(
                (
                    m.r0,
                    m.uc.reg_read(UC_ARM_REG_R1),
                    m.uc.reg_read(UC_ARM_REG_R2),
                    m.uc.reg_read(UC_ARM_REG_R3),
                )
            )

        g.stub(NEW_UNIT_MOVE_PROC, on_move)
        g.stub(REFRESH_ENTITY_MAPS)
        g.moves = moves
        g.set_args(0x02026B00)  # a stand-in parent proc; only passed through
        g.run(ROM_LOAD + self.syms["ShoveAction"])
        return g

    def test_the_action_puts_the_pushed_unit_on_the_recorded_tile(self):
        g = self._act()
        self.assertEqual((g.r8(g.target + U_XPOS), g.r8(g.target + U_YPOS)), (6, 7))

    def test_the_action_does_not_move_the_shover(self):
        g = self._act()
        self.assertEqual((g.r8(g.shover + U_XPOS), g.r8(g.shover + U_YPOS)), SHOVER)

    def test_the_action_ends_the_shovers_turn(self):
        g = self._act()
        self.assertTrue(g.r32(g.shover + U_STATE) & US_UNSELECTABLE)

    def test_the_action_yields_so_the_move_proc_can_run(self):
        self.assertEqual(self._act().r0, 0)

    def test_the_slide_is_staged_from_the_tile_the_unit_is_still_on(self):
        """Make6CKOIDO builds the MU from unit->xPos, so the write must follow.

        Facing ids come from GetFacingFromTo (0x0801D3DC): 0 left, 1 right,
        2 down, 3 up.  Mode 1 is the one that deletes the MU and refreshes the
        map when the slide ends.
        """
        for target, dest, facing in (
            ((5, 7), (6, 7), 1),
            ((3, 7), (2, 7), 0),
            ((4, 6), (4, 5), 3),
            ((4, 8), (4, 9), 2),
        ):
            with self.subTest(dest=dest):
                g = self._act(target=target, dest=dest)
                self.assertEqual(len(g.moves), 1, "the slide was never staged")
                unit, dir_id, mode, parent = g.moves[0]
                self.assertEqual(unit, g.target)
                self.assertEqual(dir_id, facing)
                self.assertEqual(mode, 1)
                self.assertEqual(parent, 0x02026B00)

    def test_a_missing_target_is_a_no_op_rather_than_a_null_write(self):
        g = self._machine()
        g.uc.mem_write(G_ACTION_DATA, bytes(0x24))
        g.w8(G_ACTION_DATA + 0x0D, 0)  # GetUnit(0) returns null
        g.stub(NEW_UNIT_MOVE_PROC)
        g.stub(REFRESH_ENTITY_MAPS)
        g.set_args(0x02026B00)
        g.run(ROM_LOAD + self.syms["ShoveAction"])
        self.assertEqual(g.r0, 0)
        self.assertFalse(g.r32(g.shover + U_STATE) & US_UNSELECTABLE)

    # -- the whole dispatch ----------------------------------------------
    def _dispatch(self, action_id=None):
        g = self._machine(target=(5, 7))
        g.uc.mem_write(G_ACTION_DATA, bytes(0x24))
        g.w8(G_ACTION_DATA + 0x0C, SHOVER_INDEX)
        g.w8(G_ACTION_DATA + 0x0D, TARGET_INDEX)
        g.w8(G_ACTION_DATA + 0x11, action_id or installer_action_id())
        g.w8(G_ACTION_DATA + 0x13, 6)
        g.w8(G_ACTION_DATA + 0x14, 7)
        g.w8(GAME_LOCK, 0)

        _init_proc_engine(g)
        g.set_args(PARENT_PROC_SCRIPT, 3)
        g.run(NEW_6C)
        g.parent = g.r0
        self.assertTrue(g.parent, "could not allocate a parent proc")

        g.set_args(g.parent)
        try:
            g.run(APPLY_UNIT_ACTION)
        except Exception as exc:  # UcError
            self.fail(
                f"shove crashed at pc={g.pc:#010x} "
                f"(unmapped={g.unmapped[:6]}): {exc}"
            )
        return g

    def test_fe7s_own_dispatch_reaches_the_action_and_stages_the_slide(self):
        """Entry is FE7's ApplyUnitAction, so the table repoint is under test.

        The blocker has to MATCH the vanilla model action rather than be absent:
        ActionDrop (0x0802F3A4) parks the same Make6CKOIDO slide on the action
        proc.  Asserting "no blockers" would be asserting the shape of the bug.
        """
        g = self._dispatch()
        slide = find_proc(g, SLIDE_SCRIPT)
        self.assertTrue(slide, "no slide proc was created")
        self.assertEqual(g.r32(slide + PROC_UNIT), g.target)
        self.assertTrue(g.r32(slide + PROC_MU), "the slide has no MOVEUNIT")
        self.assertEqual(g.r8(slide + PROC_MU_MODE), 1, "mode 1 deletes+refreshes")
        self.assertEqual(g.r32(slide + PROC_PARENT), g.parent)
        self.assertEqual(g.r32(g.parent + PROC_BLOCK_COUNT), 1)

    def test_the_slide_is_parented_exactly_like_the_vanilla_drop(self):
        """Differential against ActionDrop (action id 0x08) in this same harness.

        Vanilla parks the KOIDO slide plus its own rescue-specific follow-up, so
        drop blocks twice where a plain push blocks once; everything the two
        share -- the script, the parent, the live MOVEUNIT -- has to agree.
        """
        mine = self._dispatch()
        theirs = self._dispatch(action_id=VANILLA_DROP_ACTION_ID)
        a, b = find_proc(mine, SLIDE_SCRIPT), find_proc(theirs, SLIDE_SCRIPT)
        self.assertTrue(b, "the harness never reached vanilla ActionDrop")
        self.assertEqual(mine.r32(a + PROC_PARENT), mine.parent)
        self.assertEqual(theirs.r32(b + PROC_PARENT), theirs.parent)
        self.assertTrue(mine.r32(a + PROC_MU) and theirs.r32(b + PROC_MU))
        self.assertEqual(mine.r32(mine.parent + PROC_BLOCK_COUNT), 1)
        self.assertEqual(theirs.r32(theirs.parent + PROC_BLOCK_COUNT), 2)

    def test_the_slide_script_ends_and_never_takes_the_game_lock(self):
        """A script that locks the game and cannot reach UnlockGame IS a freeze.

        Whether the slide proc *finishes* cannot be tested here: the MOVEUNIT it
        waits on advances off VBlank state Unicorn does not emulate, so vanilla
        ActionDrop's identical slide does not finish under this harness either.
        What is checkable is the script itself.
        """
        ops = proc_script(self.rom, SLIDE_SCRIPT)
        self.assertIn(PROC_OP_END, [op for op, _ in ops], "the script has no END")
        for _, arg in ops:
            self.assertNotIn(arg & ~1, (LOCK_GAME, UNLOCK_GAME))

    def test_the_push_does_not_leave_the_game_locked(self):
        g = self._dispatch()
        run_frames(g, 60)
        self.assertEqual(g.r8(GAME_LOCK), 0, "LockGame was never balanced")

    def test_the_dispatched_push_lands_the_unit_and_spends_the_turn(self):
        g = self._dispatch()
        self.assertEqual((g.r8(g.target + U_XPOS), g.r8(g.target + U_YPOS)), (6, 7))
        self.assertEqual((g.r8(g.shover + U_XPOS), g.r8(g.shover + U_YPOS)), SHOVER)
        self.assertTrue(g.r32(g.shover + U_STATE) & US_UNSELECTABLE)


def _init_proc_engine(g):
    """Initialize6CEngine (0x08004420), done in Python.

    Running the real routine under Unicorn costs ~30s per call because it walks
    64 proc slots a word at a time.  The state it produces is pure data, so it
    is written directly instead.
    """
    proc_list = 0x02024E28
    alloc_list = 0x02026928
    alloc_head = 0x02026A2C
    count = 64
    size = 0x6C

    g.uc.mem_write(proc_list, bytes(size * count))
    for i in range(count):
        g.w32(alloc_list + 4 * i, proc_list + size * i)
    g.w32(alloc_list + 4 * count, 0)
    g.w32(alloc_head, alloc_list)
    for i in range(8):
        g.w32(PROC_TREE_ROOTS + 4 * i, 0)


def find_proc(g, script):
    """Find6C (0x080046A8): the first live proc running `script`, or 0.

    Delete6C clears proc+0x00, which is why vanilla can scan the slots this way.
    """
    for i in range(64):
        at = PROC_LIST + PROC_SIZE * i
        if g.r32(at) == script:
            return at
    return 0


def proc_script(rom, addr, limit=32):
    """Decode a proc script: 8-byte records, op in the low byte of word 0."""
    off = addr - ROM_LOAD
    out = []
    for i in range(limit):
        word0, word1 = struct.unpack_from("<II", rom, off + 8 * i)
        out.append((word0 & 0xFF, word1))
        if word0 & 0xFF == PROC_OP_END:
            break
    return out


def run_frames(g, count):
    """Drive the proc engine like the game's main loop does.

    Emphatically not "run until the tree is empty": MOVEUNIT procs outlive the
    action in vanilla as well, and several vanilla scripts wait on VBlank state
    Unicorn does not emulate, so an empty tree is a condition a working build
    never reaches here.
    """
    for _ in range(count):
        g.run(EXEC_6C)


if __name__ == "__main__":
    unittest.main()
