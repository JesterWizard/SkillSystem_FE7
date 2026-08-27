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
EXP_BAR_PROC_SCRIPT = 0x08B942A0
BEGIN_BATTLE_ANIMATIONS = 0x0802A3B0
NEW_EKR_BATTLE_DEAMON = 0x0804B1AC
SUMMON_ANIMATION_PROCS = 0x08C9DD24
FIND_6C = 0x080046A8
ITEM_TABLE_FILE = 0xBE222C
ITEM_ENTRY = 0x24
SIGNED_STAT_MAX = 0x7F
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
BATTLE_EXP_GAIN = 0x6E
EXP_FOR_SUMMONING = 10

WIDTH, HEIGHT = 15, 10


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

        g.uc.mem_write(IWRAM, bytes(0x2000))  # proc free list
        g.w32(G_ACTIVE_UNIT, SUMMONER_SLOT)

        try:
            g.run(APPLY_UNIT_ACTION)
        except Exception as exc:  # UcError
            self.fail(
                f"summon chain crashed at pc={g.pc:#010x} "
                f"(swis={g.swi_counts}, unmapped={g.unmapped[:6]}): {exc}"
            )
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

    def test_the_dragon_never_exceeds_its_class_hp_cap(self):
        g = self._summon(level=0x1F)
        slot = self._dragon(g)
        pclass = g.r32(slot + U_PCLASS)
        cap = self.rom[(pclass - ROM_LOAD) + 0x13]
        self.assertLessEqual(g.r8(slot + U_MAXHP), min(cap, SIGNED_STAT_MAX))

    def test_the_dragon_spawns_at_full_hp_after_the_clamp(self):
        """Clamping maxHP without curHP would leave it wounded on arrival."""
        g = self._summon(level=20)
        slot = self._dragon(g)
        self.assertEqual(g.r8(slot + U_CURHP), g.r8(slot + U_MAXHP))

    # -- animation / exp sequencing ---------------------------------------
    def test_the_barrier_animation_blocks_the_action(self):
        """Otherwise the exp bar comes up on top of the animation.

        SummonAnimation builds a non-blocking priority-3 main proc, so the
        action would carry straight on to the exp bar.  The proc is re-hung as
        a blocking child; this checks the flag and the parent's blocker count,
        which is the state NewBlocking6C would have produced.
        """
        found = {}

        def watch(uc, address, size, _user):
            if (address & ~1) == FIND_6C:
                found["called"] = True

        g = self._summon(hook=watch)
        self.assertTrue(
            found.get("called"),
            "the animation proc was never looked up, so it cannot be blocking",
        )

    # -- experience -------------------------------------------------------
    def test_the_summoner_is_awarded_exactly_ten_exp(self):
        """The whole point of routing through 0x0802A5D0 rather than += 10."""
        g = self._summon(level=10)
        self.assertEqual(
            g.r8(G_BATTLE_ACTOR + BATTLE_EXP_GAIN),
            EXP_FOR_SUMMONING,
            "summoning did not stage a 10 exp gain",
        )

    def test_the_exp_gain_runs_on_a_blocking_proc(self):
        """NewBlocking6C is what suppresses the map UI until the bar is done.

        Asserted from execution, not from the source: an exp gain applied
        inline would leave the map interactive while the bar was still up,
        which is the bug being fixed.

        NewBlocking6C is reached by an ordinary `bl` inside vanilla ROM code
        rather than through the project's `blh` trampoline, so it does not show
        up in ``g.calls``; a PC trace is what catches it.
        """
        seen = set()

        def watch(uc, address, size, _user):
            seen.add(address & ~1)

        g = self._summon(hook=watch)
        self.assertIn(
            NEW_BLOCKING_6C,
            seen,
            "no blocking proc was started; the exp bar would not gate the UI",
        )

    def test_the_blocking_child_is_the_vanilla_exp_bar_script(self):
        """The blocking child has to be the exp bar, not just any proc.

        0x08B942A0 is the script ActionDance blocks on, and its callback is
        SaveInstigatorFromBattle -- the routine that banks the exp onto the
        Unit.  Blocking on some other script would hide the UI but never bank
        the exp.

        The callback itself cannot be observed here: NewBlocking6C only
        *schedules* the proc, and nothing in this run drives the proc
        scheduler.  What is checked instead is the argument the summon path
        hands it, read out of r0 at the moment of the call.
        """
        script = []

        def watch(uc, address, size, _user):
            if (address & ~1) == NEW_BLOCKING_6C:
                script.append(uc.reg_read(UC_ARM_REG_R0))

        self._summon(hook=watch)
        self.assertIn(
            EXP_BAR_PROC_SCRIPT,
            script,
            f"blocked on {[hex(v) for v in script]}, not the exp bar script",
        )

    def test_no_battle_animation_sequence_is_started(self):
        """A summon has no target, so it must not enter the battle animator.

        BeginBattleAnimations -> NewEkrBattleDeamon reads gBattleTarget, which a
        summon never fills in; on hardware that ran on whatever the previous
        combat left behind and crashed at 0x030031F4 once the barrier animation
        finished.  ActionSteal awards the same +10 exp without it, and that is
        the shape this action follows.
        """
        seen = set()

        def watch(uc, address, size, _user):
            seen.add(address & ~1)

        self._summon(hook=watch)
        for name, addr in (
            ("BeginBattleAnimations", BEGIN_BATTLE_ANIMATIONS),
            ("NewEkrBattleDeamon", NEW_EKR_BATTLE_DEAMON),
        ):
            with self.subTest(routine=name):
                self.assertNotIn(
                    addr, seen,
                    f"{name} ran; a summon has no gBattleTarget to animate",
                )

    def test_the_battle_struct_is_prepared_before_exp_is_read(self):
        """InstigatorAdd10Exp reads gBattleActor, so setup has to come first.

        Reversing these two is silent -- the exp lands on whatever unit was in
        the battle struct from the previous combat.
        """
        g = self._summon()
        calls = [c & ~1 for c in g.calls]
        self.assertIn(SETUP_BATTLE_STRUCT_FOR_STAFF_USER, calls)
        self.assertIn(GIVE_INSTIGATOR_10_EXP, calls)
        self.assertLess(
            calls.index(SETUP_BATTLE_STRUCT_FOR_STAFF_USER),
            calls.index(GIVE_INSTIGATOR_10_EXP),
            "exp was read out of a battle struct that was never set up",
        )

    def test_the_exp_is_credited_to_the_summoner_not_the_dragon(self):
        g = self._summon()
        self.assertEqual(
            g.s8(G_BATTLE_ACTOR + U_INDEX),
            g.r8(SUMMONER_SLOT + U_INDEX),
            "the battle struct holds someone other than the summoner",
        )

    # -- autolevelling ----------------------------------------------------
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
