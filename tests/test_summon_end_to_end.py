"""End-to-end summon: dispatch it the way the game does, stub nothing.

Entry is FE7's own ApplyUnitAction (0x0802F218), not the summon routine, so the
run also proves the installer's repoint of UnitActionFunctionPointer works:

    ApplyUnitAction
      -> GetUnit(gActionData.subject), gActiveUnit = it
      -> mov pc, table[actionId - 1]        <- the entry UnitMenuSkills writes
      -> SummonActionEntry -> SummonAction
           -> SummonClearAll -> GetUnit
           -> LoadUnit -> GetNextFreePlayerUnitStruct, ClearUnitStruct,
                          StoreNewUnitFromCode, LoadUnitStats, autolevelling,
                          LoadUnitSupports, CharStoreAI, ...
           -> the map animation proc
           -> RefreshFogAndUnitMaps, SMS_UpdateFromGameData

Only the GBA BIOS is emulated, since Unicorn has no BIOS.  Every instruction
that belongs to the game is genuine ROM code, so a crash anywhere in that chain
fails this test.

What it cannot show: that the unit menu reaches the action in the first place
(that needs the menu and target-selection procs), or how any of it looks on
screen.  Those still want an in-game check.
"""
from __future__ import annotations

import struct
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(Path(__file__).resolve().parent))

from gba_machine import Gba, IWRAM, ROM_LOAD, UNICORN_ERROR, Uc  # noqa: E402

if Uc is not None:  # pragma: no branch
    from unicorn import UC_HOOK_CODE  # noqa: E402
    from unicorn.arm_const import UC_ARM_REG_R0  # noqa: E402
from summon_symbols import HACK, action_symbols  # noqa: E402

APPLY_UNIT_ACTION = 0x0802F218
SUMMON_ACTION_ID = 0x05

SETUP_BATTLE_STRUCT_FOR_STAFF_USER = 0x0802A4B4
GIVE_INSTIGATOR_10_EXP = 0x0802A5D0
NEW_BLOCKING_6C = 0x080044F8
# GiveInstigator10Exp's blocking child: sleep 1, SaveInstigatorFromBattle, end.
EXP_SAVE_SCRIPT = 0x08B942A0
BEGIN_BATTLE_ANIMATIONS = 0x0802A3B0
NEW_EKR_BATTLE_DEAMON = 0x0804B1AC
SETUP_BATTLE_STRUCT_FOR_STAFF_TARGET = 0x0802A560
COPY_UNIT_TO_BATTLE_STRUCT = 0x080285D4
CLEAR_MOVE_UNITS = 0x0806CCB8

# The routine that actually renders the map exp bar: it news up 0x08C9D50C,
# which takes the game lock and plays the sequence through to the bar.
START_MAP_BATTLE_SEQUENCE = 0x0806F0DC
MAP_BATTLE_SCRIPT = 0x08C9D50C

# NOT an exp bar.  0x0802B678 is StartTradeMenu -- its only caller in the whole
# ROM is 0x08021E88, the A-button handler of the Trade target selection at
# 0x08B95C78.  Calling it from the summon opened a locked trade window between
# the summoner and the dragon; that was the freeze.
START_TRADE_MENU = 0x0802B678
TRADE_MENU_SCRIPT = 0x08B942F8
G_TRADE_MENU_PROC = 0x0203A514
PROC_TREE_ROOTS = 0x02026A30
SUMMON_ANIMATION_PROCS = 0x08C9DD24
FIND_6C = 0x080046A8
INITIALIZE_6C_ENGINE = 0x08004420
# Any script works as a stand-in parent; the summon only ever uses it as a
# blocking anchor. 0x08B93460's own script is the real one.
PARENT_PROC_SCRIPT = 0x08B93440
NEW_6C = 0x08004494
PROC_PARENT = 0x14
PROC_BLOCK_COUNT = 0x28
ITEM_TABLE_FILE = 0xBE222C
ITEM_ENTRY = 0x24
SIGNED_STAT_MAX = 0x7F
# Every player unit in this hack is held to 60 HP; a summon is no exception.
PLAYER_HP_CAP = 60
U_RANK_BLOCK = 0x28
PROC_FLAGS = 0x27
PROC_BLOCKED = 0x02

G_ACTIVE_UNIT = 0x03004690
G_ACTION_DATA = 0x0203A85C
RAM_SLOT_TABLE = 0x08B92EB0
CHAPTER_DATA = 0x0202BBF8
CHARACTER_TABLE = 0x08BDCE18
CLASS_TABLE = 0x08BE015C

SUMMONER_SLOT = 0x0202BD50  # player slot 1, from RAMSlotTable

UNIT_SIZE = 0x48
U_PCHARACTER = 0x00
U_PCLASS = 0x04
U_LEVEL = 0x08
U_INDEX = 0x0B
U_STATE = 0x0C
U_XPOS = 0x10
U_YPOS = 0x11
U_MAXHP = 0x12
U_CURHP = 0x13
U_ITEMS = 0x1E

US_UNSELECTABLE = 0x40

U_EXP = 0x09

# InstigatorAdd10Exp (0x0802A05C) writes into the gBattleActor copy; the exp bar
# proc's SaveInstigatorFromBattle (0x0802A5B4) is what puts it back on the Unit.
G_BATTLE_ACTOR = 0x0203A3F0
G_BATTLE_TARGET = 0x0203A470
BATTLE_EXP_GAIN = 0x6E
EXP_FOR_SUMMONING = 10

WIDTH, HEIGHT = 15, 10



def _init_proc_engine(g):
    """Initialize6CEngine (0x08004420), done in Python.

    Running the real routine under Unicorn costs ~30s per call because it walks
    64 proc slots a word at a time.  The state it produces is pure data, so it
    is written directly instead: every slot zeroed, the alloc list filled with
    pointers to those slots, the head pointing at the first, and the eight tree
    roots cleared.
    """
    proc_list = 0x02024E28
    alloc_list = 0x02026928
    alloc_head = 0x02026A2C
    tree_roots = 0x02026A30
    count = 64
    size = 0x6C

    g.uc.mem_write(proc_list, bytes(size * count))
    for i in range(count):
        g.w32(alloc_list + 4 * i, proc_list + size * i)
    g.w32(alloc_list + 4 * count, 0)
    g.w32(alloc_head, alloc_list)
    for i in range(8):
        g.w32(tree_roots + 4 * i, 0)


EXEC_6C = 0x08004690


def run_frames(g, limit=600):
    """Drive the proc engine like the game's main loop does.

    This is the check that isolated calls cannot make.  Creating a proc and
    asserting on its fields proves the routine that created it did not fault;
    it says nothing about whether the proc ever finishes.  A blocking child
    that never deletes itself, or a script whose callback faults three frames
    in, passes every structural assertion and freezes the game.

    Returns the number of frames until the tree is empty, or None if it was
    still running at `limit` -- which is what a hang looks like from here.
    """
    for frame in range(limit):
        alive = False
        for root in range(8):
            if g.r32(0x02026A30 + 4 * root):
                alive = True
                break
        if not alive:
            return frame
        g.run(EXEC_6C)
    return None


@unittest.skipUnless(Uc is not None, f"Unicorn unavailable: {UNICORN_ERROR}")
@unittest.skipUnless(HACK.exists(), "FE7_Hack.gba not built")
class SummonEndToEndTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.rom = HACK.read_bytes()
        cls.syms = action_symbols(cls.rom)
        assert cls.syms, (
            "SummonActionEntry is not reachable from UnitActionFunctionPointer; "
            "the summon action is not installed"
        )
        links = cls.syms["SummonLinks"]
        cls.character_id = struct.unpack_from("<I", cls.rom, links)[0]
        cls.class_id = struct.unpack_from("<I", cls.rom, links + 4)[0]
        cls.item_id = struct.unpack_from("<I", cls.rom, links + 8)[0]

    def _summon(self, *, tile=(5, 7), level=10, preexisting=None, hook=None):
        g = Gba(self.rom)
        if hook is not None:
            g.uc.hook_add(UC_HOOK_CODE, hook)

        g.w8(CHAPTER_DATA + 0x1B, 0)   # normal mode
        g.w8(CHAPTER_DATA + 0x0D, 0)   # no fog
        g.w8(CHAPTER_DATA + 0x15, 0)   # clear weather
        g.w16(CHAPTER_DATA + 0x0C, 0)  # camera x
        g.w16(CHAPTER_DATA + 0x0E, 0)  # camera y

        map_size = 0x0202E3D8
        g.w16(map_size, WIDTH)
        g.w16(map_size + 2, HEIGHT)

        def build_map(rows_at, data_at):
            g.w32(rows_at - 8, data_at)
            for y in range(HEIGHT + 4):
                g.w32(rows_at + 4 * y, data_at + y * (WIDTH + 2))
            g.uc.mem_write(data_at, bytes((WIDTH + 2) * (HEIGHT + 4)))

        build_map(0x02030000, 0x02031000)
        g.w32(0x0202E3DC, 0x02030000)  # unit
        build_map(0x02032000, 0x02033000)
        g.w32(0x0202E3E8, 0x02032000)  # range
        build_map(0x02034000, 0x02035000)
        g.w32(0x0202E3F0, 0x02034000)  # hidden
        build_map(0x02036000, 0x02037000)
        g.w32(0x0202E3E0, 0x02036000)  # terrain
        g.w32(0x0202E3EC, 0x02036000)  # fog
        g.w32(0x0202E3E4, 0x02036000)  # movement

        # Unit slots, initialised the way ClearUnits (0x080174D8) does: zero the
        # slot, then stamp its own index into +0x0B. ClearUnitStruct preserves
        # that byte, so a spawned unit inherits it; skipping this would leave
        # every unit with index 0, which is a harness artefact.
        for i in range(1, 0x100):
            entry = RAM_SLOT_TABLE - ROM_LOAD + 4 * i
            if entry + 4 > len(self.rom):
                break
            ptr = struct.unpack_from("<I", self.rom, entry)[0]
            if ptr:
                g.uc.mem_write(ptr, bytes(UNIT_SIZE))
                g.w8(ptr + U_INDEX, i)

        g.w32(SUMMONER_SLOT + U_PCHARACTER, CHARACTER_TABLE + 0x34 * 0x01)
        g.w32(SUMMONER_SLOT + U_PCLASS, CLASS_TABLE + 0x54 * 0x02)
        g.w8(SUMMONER_SLOT + U_LEVEL, level)
        g.w8(SUMMONER_SLOT + U_INDEX, 0x01)
        g.w32(SUMMONER_SLOT + U_STATE, 0)
        g.w8(SUMMONER_SLOT + U_XPOS, 4)
        g.w8(SUMMONER_SLOT + U_YPOS, 7)
        g.w8(SUMMONER_SLOT + U_CURHP, 20)
        g.w32(G_ACTIVE_UNIT, SUMMONER_SLOT)

        if preexisting is not None:
            slot = self._slot(preexisting)
            g.w32(slot + U_PCHARACTER, CHARACTER_TABLE + 0x34 * self.character_id)
            g.w32(slot + U_PCLASS, CLASS_TABLE + 0x54 * self.class_id)
            g.w8(slot + U_XPOS, 9)
            g.w8(slot + U_YPOS, 9)
            g.w8(slot + U_CURHP, 30)

        # The map selector's A press leaves exactly this behind.
        g.uc.mem_write(G_ACTION_DATA, bytes(0x24))
        g.w8(G_ACTION_DATA + 0x0C, 0x01)          # acting unit
        g.w8(G_ACTION_DATA + 0x0E, 4)             # where the summoner moved to
        g.w8(G_ACTION_DATA + 0x0F, 7)
        g.w8(G_ACTION_DATA + 0x11, SUMMON_ACTION_ID)
        g.w8(G_ACTION_DATA + 0x13, tile[0])       # chosen tile
        g.w8(G_ACTION_DATA + 0x14, tile[1])

        g.w32(G_ACTIVE_UNIT, SUMMONER_SLOT)

        # Bring the proc engine up for real and give the action a live parent
        # proc, the way the game does: ApplyUnitAction is a proc callback
        # (command 0x16 in the script at 0x08B93460), so r0 is a valid proc.
        # Passing 0 here would let a null parent slip through unnoticed -- which
        # is exactly how the exp bar came to be created with no parent to block.
        _init_proc_engine(g)
        g.set_args(PARENT_PROC_SCRIPT, 3)
        g.run(NEW_6C)
        parent = g.r0
        assert parent, "could not allocate a parent proc"

        g.set_args(parent)
        try:
            g.run(APPLY_UNIT_ACTION)
        except Exception as exc:  # UcError
            self.fail(
                f"summon chain crashed at pc={g.pc:#010x} "
                f"(swis={g.swi_counts}, unmapped={g.unmapped[:6]}): {exc}"
            )
        g.parent_proc = parent
        return g

    # -- helpers ---------------------------------------------------------
    def _slot(self, index):
        return struct.unpack_from(
            "<I", self.rom, RAM_SLOT_TABLE - ROM_LOAD + 4 * index
        )[0]

    def _dragons(self, g):
        found = []
        for i in range(1, 0x40):
            ptr = self._slot(i)
            if not ptr:
                continue
            pchar = g.r32(ptr + U_PCHARACTER)
            if not (ROM_LOAD <= pchar < ROM_LOAD + len(self.rom)):
                continue
            if self.rom[(pchar - ROM_LOAD) + 4] == self.character_id:
                found.append(ptr)
        return found

    def _dragon(self, g):
        found = self._dragons(g)
        self.assertEqual(len(found), 1, f"expected one summon, found {len(found)}")
        return found[0]

    # -- claims -----------------------------------------------------------
    def test_fe7s_own_dispatch_reaches_the_summon_action(self):
        g = self._summon()
        self.assertTrue(
            g.swi_counts, "no BIOS call happened; the chain probably never ran"
        )
        self.assertTrue(self._dragons(g), "no summon was created")

    def test_the_created_unit_is_the_configured_class(self):
        g = self._summon()
        pclass = g.r32(self._dragon(g) + U_PCLASS)
        self.assertEqual(self.rom[(pclass - ROM_LOAD) + 4], self.class_id)

    def test_the_dragon_stands_on_the_selected_tile(self):
        g = self._summon(tile=(5, 7))
        slot = self._dragon(g)
        self.assertEqual((g.r8(slot + U_XPOS), g.r8(slot + U_YPOS)), (5, 7))

    def test_the_summoner_does_not_move_to_the_selected_tile(self):
        """Writing the tile into gActionData +0x0E/+0x0F would teleport them."""
        g = self._summon(tile=(5, 7))
        self.assertEqual(
            (g.r8(SUMMONER_SLOT + U_XPOS), g.r8(SUMMONER_SLOT + U_YPOS)), (4, 7)
        )

    def test_the_dragon_is_alive_at_full_hp(self):
        g = self._summon()
        slot = self._dragon(g)
        cur, mx = g.r8(slot + U_CURHP), g.r8(slot + U_MAXHP)
        self.assertGreater(cur, 0, "spawned with 0 HP")
        self.assertEqual(cur, mx, "did not spawn at full HP")

    def test_the_dragon_has_real_combat_stats(self):
        """Proves LoadUnitStats and the autolevel path ran, not just a memset."""
        g = self._summon()
        slot = self._dragon(g)
        for name, off in (("pow", 0x14), ("skl", 0x15), ("spd", 0x16), ("def", 0x17)):
            with self.subTest(stat=name):
                self.assertGreater(g.r8(slot + off), 0, f"{name} is zero")

    def test_the_dragons_level_follows_the_summoner(self):
        for level in (1, 10, 20):
            with self.subTest(level=level):
                g = self._summon(level=level)
                self.assertEqual(g.r8(self._dragon(g) + U_LEVEL), level)

    def test_a_summoner_above_the_level_field_is_clamped_not_wrapped(self):
        """The level packs into 5 bits; 0x20 would overflow into the next field."""
        g = self._summon(level=0x2A)
        self.assertEqual(g.r8(self._dragon(g) + U_LEVEL), 0x1F)

    def test_the_dragon_keeps_a_usable_deployment_index(self):
        g = self._summon()
        self.assertNotEqual(g.r8(self._dragon(g) + U_INDEX), 0, "unit index wiped")

    def test_the_dragon_is_a_player_unit(self):
        """Allegiance bits in the definition are 0, so it fights on your side."""
        g = self._summon()
        self.assertLess(g.r8(self._dragon(g) + U_INDEX), 0x40)

    def test_the_dragon_carries_the_configured_weapon(self):
        g = self._summon()
        slot = self._dragon(g)
        items = [g.r16(slot + U_ITEMS + 2 * i) & 0xFF for i in range(5)]
        self.assertIn(self.item_id, items, f"inventory was {items}")

    def test_the_summoner_is_marked_as_having_acted(self):
        g = self._summon()
        self.assertEqual(
            g.r32(SUMMONER_SLOT + U_STATE) & US_UNSELECTABLE,
            US_UNSELECTABLE,
            "summoner could act again this turn",
        )

    def test_a_second_summon_replaces_the_first(self):
        g = self._summon(tile=(5, 7), preexisting=0x05)
        self.assertEqual(
            len(self._dragons(g)), 1, "the previous dragon was left on the field"
        )

    def test_the_replacement_is_the_new_one(self):
        g = self._summon(tile=(5, 7), preexisting=0x05)
        slot = self._dragon(g)
        self.assertEqual((g.r8(slot + U_XPOS), g.r8(slot + U_YPOS)), (5, 7))

    # -- the dragon is actually usable ------------------------------------
    def test_the_dragon_can_use_its_weapon(self):
        """The engine's own answer, on the unit the summon actually created.

        Asked via CanUnitUseWeapon rather than by reading a table, because the
        byte it reads (unit+0x33, for weaponType 0x0B) is one LoadUnitStats
        never writes -- an earlier fix patched the class table and was silently
        inert.
        """
        g = self._summon()
        slot = self._dragon(g)

        item = ITEM_TABLE_FILE + ITEM_ENTRY * self.item_id
        weapon_type = self.rom[item + 0x07]
        required = self.rom[item + 0x1C]
        have = g.r8(slot + U_RANK_BLOCK + weapon_type)

        self.assertGreaterEqual(
            have, required,
            f"unit+0x{U_RANK_BLOCK + weapon_type:02X} is 0x{have:02X}, "
            f"item 0x{self.item_id:02X} needs 0x{required:02X}",
        )

    def test_the_dragons_hp_fits_in_a_signed_byte(self):
        """GetUnitMaxHP reads maxHP with LDRSB; over 127 shows as 0/0."""
        for level in (1, 10, 20, 0x1F):
            with self.subTest(level=level):
                g = self._summon(level=level)
                slot = self._dragon(g)
                mx = g.r8(slot + U_MAXHP)
                self.assertLessEqual(
                    mx, SIGNED_STAT_MAX,
                    f"maxHP {mx} reads as {mx - 256} through LDRSB",
                )
                self.assertGreater(mx, 0)

    def test_the_dragon_is_held_to_the_player_hp_cap(self):
        """A player-controlled summon obeys the same 60 HP ceiling as everyone.

        The class's own cap is deliberately not used: Fire Dragon is boss data
        and caps at 127, which would leave the dragon at roughly double a real
        player unit.  Checked at the top level, where autolevelling has had the
        most chances to push past it.
        """
        for level in (10, 20, 0x1F):
            with self.subTest(level=level):
                g = self._summon(level=level)
                mx = g.r8(self._dragon(g) + U_MAXHP)
                self.assertLessEqual(
                    mx, PLAYER_HP_CAP,
                    f"maxHP {mx} is above the {PLAYER_HP_CAP} player cap",
                )

    def test_the_clamp_is_a_ceiling_not_a_constant(self):
        """A dragon that rolls under the cap keeps its own lower number.

        Guards against 'fixing' the cap by assigning 60 unconditionally, which
        would pass every ceiling assertion while erasing autolevelling.
        """
        g = self._summon(level=0x1F)
        slot = self._dragon(g)
        pclass = g.r32(slot + U_PCLASS)
        cap = self.rom[(pclass - ROM_LOAD) + 0x13]
        self.assertLessEqual(
            g.r8(slot + U_MAXHP), min(cap, PLAYER_HP_CAP),
            "the clamp let maxHP past the class's own cap",
        )

    def test_the_dragon_spawns_at_full_hp_after_the_clamp(self):
        """Clamping maxHP without curHP would leave it wounded on arrival."""
        g = self._summon(level=20)
        slot = self._dragon(g)
        self.assertEqual(g.r8(slot + U_CURHP), g.r8(slot + U_MAXHP))

    # -- animation / exp sequencing ---------------------------------------
    def test_the_action_blocks_only_on_a_script_that_ends_itself(self):
        """The freeze signature the harness can actually decide.

        Draining the proc tree is NOT a usable oracle here: the barrier, exp
        save and map-battle scripts all depend on graphics state this harness
        does not emulate, so none of them advance even in a build that works in
        game.  What IS decidable is structural -- who parked a blocker on the
        action proc, and whether that blocker's script can reach END.

        "No blockers at all" is the wrong invariant, and asserting it is how a
        frozen build stayed green: every vanilla action that leaves something
        running parks exactly this blocker.  ActionSteal and ActionDance both
        call GiveInstigator10Exp, which does NewBlocking6C(0x08B942A0, proc) --
        SLEEP 1, SaveInstigatorFromBattle, END.  It clears itself in two frames.

        What must never appear is a blocker whose script cannot terminate, or a
        second unrelated blocker nothing will clear.
        """
        g = self._summon()
        parent = g.parent_proc

        blockers = []
        node = g.r32(parent + 0x18)
        while node:
            if g.r8(node + PROC_FLAGS) & PROC_BLOCKED:
                blockers.append(g.r32(node))
            node = g.r32(node + 0x20)

        self.assertEqual(
            [hex(b) for b in blockers], [hex(EXP_SAVE_SCRIPT)],
            "the action proc's blockers are not the single self-clearing one "
            "ActionSteal leaves; anything else here hangs the summon",
        )
        self.assertEqual(
            g.r8(parent + PROC_BLOCK_COUNT), len(blockers),
            "the block count does not match the blocking children",
        )

    def test_the_trade_menu_is_never_opened(self):
        """The actual freeze, and the guard against reintroducing it.

        0x0802B678 was named StartExpBar in SummonAction.s.  It is
        StartTradeMenu: its only caller in the ROM is 0x08021E88, the A-button
        handler of the Trade target selection at 0x08B95C78, and the script it
        news up (0x08B942F8) opens with LockGame, draws a portrait for BOTH
        units with NewFace, lists both inventories and then runs an interactive
        cursor.  Calling it from the summon opened a trade window between the
        summoner and a dragon that has no portrait, with the game locked.
        """
        g = self._summon()
        self.assertNotIn(
            START_TRADE_MENU, [c & ~1 for c in g.calls],
            "the summon called StartTradeMenu (0x0802B678); this locks the "
            "game in a trade window and is the freeze",
        )
        self.assertEqual(
            g.r32(G_TRADE_MENU_PROC), 0,
            "a trade menu proc was recorded at 0x0203A514",
        )

    def test_the_barrier_animation_stays_a_root_proc(self):
        """SummonAnimation's proc must be left where SummonAnimation put it."""
        g = self._summon()

        children = set()
        node = g.r32(g.parent_proc + 0x18)
        while node:
            children.add(g.r32(node))
            node = g.r32(node + 0x20)
        self.assertNotIn(
            SUMMON_ANIMATION_PROCS, children,
            "the animation was re-hung under the action proc; SummonAnimation "
            "makes it a root (New6C(script, 3)) and vanilla parentage is what "
            "the map sequence's own game lock is timed against",
        )

        found = False
        for root in range(8):
            node = g.r32(PROC_TREE_ROOTS + 4 * root)
            while node:
                if g.r32(node) == SUMMON_ANIMATION_PROCS:
                    found = True
                node = g.r32(node + 0x20)
        self.assertTrue(found, "the barrier animation proc was never created")

    def test_the_map_battle_sequence_is_started(self):
        """The bar must actually be rendered, not just the exp banked.

        GiveInstigator10Exp (0x0802A5D0) only adds the number and blocks on
        0x08B942A0 (sleep, SaveInstigatorFromBattle, end); nothing about it
        draws.  An earlier revision called it alone, which is exactly why the
        exp arrived and no bar ever appeared.

        StartMapBattleSequence (0x0806F0DC) is the piece ActionSteal calls
        after it: it news up 0x08C9D50C, which opens with LockGame and plays
        the map sequence through to the exp bar and the unlock.
        """
        g = self._summon()
        calls = [c & ~1 for c in g.calls]
        self.assertIn(
            START_MAP_BATTLE_SEQUENCE, calls,
            "StartMapBattleSequence was never called, so nothing renders the "
            "exp bar",
        )

    def test_the_map_battle_proc_is_created_at_root(self):
        """0x08C9D50C must exist and must not hang off the action proc.

        It takes the game lock itself, so it does not need to block the action;
        ActionSteal leaves it at root (New6C(script, 3)).
        """
        g = self._summon()

        children = set()
        node = g.r32(g.parent_proc + 0x18)
        while node:
            children.add(g.r32(node))
            node = g.r32(node + 0x20)
        self.assertNotIn(
            MAP_BATTLE_SCRIPT, children,
            "the map battle sequence was re-hung under the action proc",
        )

        found = False
        for root in range(8):
            node = g.r32(PROC_TREE_ROOTS + 4 * root)
            while node:
                if g.r32(node) == MAP_BATTLE_SCRIPT:
                    found = True
                node = g.r32(node + 0x20)
        self.assertTrue(found, "the map battle proc was never created")

    def test_ten_exp_is_banked_on_the_summoner(self):
        """The exp lands on gBattleActor, credited to the summoner.

        SaveInstigatorFromBattle commits gBattleActor back onto the unit named
        by gBattleActor+0x0B, so if the struct was never set up for the
        summoner the exp goes to whoever fought last -- and a stale battle
        struct gets written over that unit.  That is why
        SetupBattleStructForStaffUser has to run first and cannot be skipped.
        """
        g = self._summon()
        calls = [c & ~1 for c in g.calls]
        self.assertIn(
            SETUP_BATTLE_STRUCT_FOR_STAFF_USER, calls,
            "gBattleActor was never set up; GiveInstigator10Exp would commit a "
            "stale battle struct onto an unrelated unit",
        )
        self.assertEqual(
            g.r8(G_BATTLE_ACTOR + BATTLE_EXP_GAIN), EXP_FOR_SUMMONING,
            "the summoner was not credited 10 exp",
        )
        self.assertEqual(
            g.r8(G_BATTLE_ACTOR + U_INDEX), g.r8(SUMMONER_SLOT + U_INDEX),
            "gBattleActor names a unit other than the summoner, so the exp "
            "would be committed to the wrong unit",
        )

    def test_the_battle_animator_is_never_started(self):
        """A summon must not call BeginBattleAnimations.  This is a softlock.

        ActionDance calls it; ActionSteal does not.  Dance can, because the
        danced-at unit is a real battle target with a sequence to play.  A
        summon has no battle at all -- the dragon is created a few instructions
        earlier and has no attack -- so the animator is handed two allied units
        and no script, and never terminates.  Steal is the right model: flat
        exp, no animation.

        An earlier revision added this call chasing a missing exp bar and hung
        the game.  The bar is not worth a softlock; this test is the guard.
        """
        seen = set()

        def watch(uc, address, size, _user):
            seen.add(address & ~1)

        self._summon(hook=watch)
        self.assertNotIn(
            BEGIN_BATTLE_ANIMATIONS, seen,
            "BeginBattleAnimations ran -- two allied units enter the battle "
            "animator with no script and the game softlocks",
        )

    def test_the_battle_target_is_staged_as_the_dragon(self):
        """gBattleTarget must name the dragon, ActionSteal's way.

        Steal stages the unit it acted on with CopyUnitToBattleStruct, not with
        SetupBattleStructForStaffTarget -- the latter is ActionDance's shape and
        pairs with BeginBattleAnimations, which softlocks here.  Leaving
        gBattleTarget stale instead is how the map sequence ends up drawing
        whoever fought last.
        """
        g = self._summon()
        calls = [c & ~1 for c in g.calls]
        self.assertIn(
            COPY_UNIT_TO_BATTLE_STRUCT, calls,
            "the dragon was never copied into gBattleTarget",
        )
        self.assertNotIn(
            SETUP_BATTLE_STRUCT_FOR_STAFF_TARGET, calls,
            "gBattleTarget was set up ActionDance's way; that pairs with the "
            "battle animator, which has nothing to play for a summon",
        )
        self.assertEqual(
            g.r8(G_BATTLE_TARGET + U_INDEX),
            g.r8(self._dragon(g) + U_INDEX),
            "gBattleTarget does not name the summoned dragon",
        )

    def test_a_higher_level_summon_is_stronger(self):
        """Autolevel grows by (level - baseLevel); a base of 20 would flatten it.

        Compares total stats rather than one stat, since any single growth can
        legitimately roll the same at both levels.
        """
        def total(level):
            g = self._summon(level=level)
            slot = self._dragon(g)
            return sum(g.r8(slot + off) for off in (0x12, 0x14, 0x15, 0x16, 0x17, 0x18))

        low, high = total(2), total(20)
        self.assertGreater(
            high, low,
            f"level 20 summon ({high}) is no stronger than level 2 ({low}); "
            "autolevelling is not being applied",
        )


EXEC_6C = 0x08004690


def run_frames(g, limit=600):
    """Drive the proc engine like the game's main loop does.

    This is the check that isolated calls cannot make.  Creating a proc and
    asserting on its fields proves the routine that created it did not fault;
    it says nothing about whether the proc ever finishes.  A blocking child
    that never deletes itself, or a script whose callback faults three frames
    in, passes every structural assertion and freezes the game.

    Returns the number of frames until the tree is empty, or None if it was
    still running at `limit` -- which is what a hang looks like from here.
    """
    for frame in range(limit):
        alive = False
        for root in range(8):
            if g.r32(0x02026A30 + 4 * root):
                alive = True
                break
        if not alive:
            return frame
        g.run(EXEC_6C)
    return None


@unittest.skipUnless(Uc is not None, f"Unicorn unavailable: {UNICORN_ERROR}")
@unittest.skipUnless(HACK.exists(), "FE7_Hack.gba not built")
class SummonChapterEndTests(unittest.TestCase):
    """SetNextChapter is replaced so the dragon never reaches the next map."""

    @classmethod
    def setUpClass(cls):
        cls.rom = HACK.read_bytes()
        cls.syms = action_symbols(cls.rom)
        assert cls.syms, "summon action is not installed"
        cls.character_id = struct.unpack_from(
            "<I", cls.rom, cls.syms["SummonLinks"]
        )[0]
        cls.class_id = struct.unpack_from(
            "<I", cls.rom, cls.syms["SummonLinks"] + 4
        )[0]

    def _slot(self, index):
        return struct.unpack_from(
            "<I", self.rom, RAM_SLOT_TABLE - ROM_LOAD + 4 * index
        )[0]

    def test_clearall_removes_the_dragon_and_leaves_everyone_else(self):
        g = Gba(self.rom)
        for i in range(1, 0x100):
            ptr = self._slot(i)
            if ptr:
                g.uc.mem_write(ptr, bytes(UNIT_SIZE))
                g.w8(ptr + U_INDEX, i)

        dragon = self._slot(0x03)
        g.w32(dragon + U_PCHARACTER, CHARACTER_TABLE + 0x34 * self.character_id)
        g.w32(dragon + U_PCLASS, CLASS_TABLE + 0x54 * self.class_id)
        g.w8(dragon + U_CURHP, 30)

        ally = self._slot(0x04)
        g.w32(ally + U_PCHARACTER, CHARACTER_TABLE + 0x34 * 0x01)
        g.w32(ally + U_PCLASS, CLASS_TABLE + 0x54 * 0x02)
        g.w8(ally + U_CURHP, 22)

        g.run(ROM_LOAD + self.syms["SummonClearAll"])

        self.assertEqual(g.r32(dragon + U_PCHARACTER), 0, "dragon slot not cleared")
        self.assertNotEqual(
            g.r32(ally + U_PCHARACTER), 0, "an ordinary unit was cleared too"
        )

    def test_clearall_leaves_an_enemy_dragon_alone(self):
        """Player slots only, so a Fire Dragon boss is never swept up."""
        g = Gba(self.rom)
        for i in range(1, 0x100):
            ptr = self._slot(i)
            if ptr:
                g.uc.mem_write(ptr, bytes(UNIT_SIZE))
                g.w8(ptr + U_INDEX, i)

        boss = self._slot(0x81)
        self.assertTrue(boss, "no enemy slot 0x81 in RAMSlotTable")
        g.w32(boss + U_PCHARACTER, CHARACTER_TABLE + 0x34 * self.character_id)
        g.w32(boss + U_PCLASS, CLASS_TABLE + 0x54 * self.class_id)
        g.w8(boss + U_CURHP, 60)

        g.run(ROM_LOAD + self.syms["SummonClearAll"])

        self.assertNotEqual(g.r32(boss + U_PCHARACTER), 0, "enemy dragon was cleared")


if __name__ == "__main__":
    unittest.main()
