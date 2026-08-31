"""Liquid Ooze: drain attacks hurt the attacker instead of healing them.

Nosferatu / Runesword (weapon effect 2) go through Proc_StealHP. Sol inverts
in its own proc. SkillTester and GetItemWeaponEffect are intercepted, so this
does not prove a unit owns LiquidOozeID.

FE7_Hack.gba is required only for the loop-membership check.
"""
import struct
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from Tools.thumb_harness import Harness, assemble, symbol_offsets

KEEP_SRC = (
    ROOT
    / "EngineHacks/Necessary/CalcLoops/BattleProcCalcLoop/LifeSteal/keep_hpchange.s"
)
STEAL_SRC = (
    ROOT
    / "EngineHacks/Necessary/CalcLoops/BattleProcCalcLoop/LifeSteal/proc_stealhp.s"
)
SOL_SRC = ROOT / "EngineHacks/SkillSystem/Skills/ProcSkills/Sol/proc_sol.s"
STEAL_BAR_SRC = (
    ROOT
    / "EngineHacks/SkillSystem/Skills/StandaloneSkills/LiveToServe/LiveToServeHpBarSteal.s"
)
TICK_SRC = (
    ROOT
    / "EngineHacks/SkillSystem/Skills/StandaloneSkills/LiveToServe/LiveToServeHpBarTick.s"
)
LOOP_EVENT = (
    ROOT
    / "EngineHacks/Necessary/CalcLoops/BattleProcCalcLoop/BattleProcCalcLoop.event"
)

ACTOR = 0x0203A3F0
TARGET = 0x0203A470
BUFFER = 0x0203A600
BATTLE_DATA = 0x0203A3D8

HP = 0x13
ITEM = 0x4A
GET_ITEM_EFFECT = 0x08017424
D100 = 0x0802857C
MISS = 0x2
DEVIL = 0x80
HPSTEAL = 0x100
OOZE_DISPLAY = 0x1000  # LUT other-side drain; not Devil, not HPSTEAL
STEAL_HP_EFFECT = 2
POISON_EFFECT = 1


def _unit(hp=30, item=0x003E):
    buf = bytearray(0x80)
    buf[HP] = hp
    struct.pack_into("<H", buf, ITEM, item)
    return buf


def _run_steal(
    *,
    effect=STEAL_HP_EFFECT,
    ooze=False,
    damage=10,
    atk_hp=40,
    def_hp=30,
    hit_word=0,
    hp_change=0,
    round_attacker=ACTOR,
    loop_defender=TARGET,
):
    calls = {"effect": 0, "skill": 0}
    victim = TARGET if round_attacker == ACTOR else ACTOR

    def intercept(lr, r0, r1):
        if (lr & ~1) == GET_ITEM_EFFECT:
            calls["effect"] += 1
            return effect
        calls["skill"] += 1
        if not ooze:
            return 0
        # SkillTester r0 is the unit being tested; Ooze lives on the hit-taker.
        return 1 if (r0 & ~1) == victim else 0

    code = assemble(STEAL_SRC)
    offsets = symbol_offsets(STEAL_SRC)
    h = Harness(code, intercept_calls=intercept)

    if round_attacker == ACTOR:
        actor = _unit(hp=atk_hp)
        target = _unit(hp=def_hp)
    else:
        actor = _unit(hp=def_hp)
        target = _unit(hp=atk_hp)

    h.seed(ACTOR, bytes(actor))
    h.seed(TARGET, bytes(target))
    word = (hit_word & 0x00FFFFFF) | ((hp_change & 0xFF) << 24)
    h.seed(BUFFER, struct.pack("<I", word))
    stats = bytearray(0x10)
    struct.pack_into("<h", stats, 4, damage)
    h.seed(BATTLE_DATA, bytes(stats))
    h.run(
        offsets["End"],
        regs={
            "r0": round_attacker,
            "r1": loop_defender,
            "r2": BUFFER,
            "r3": BATTLE_DATA,
        },
    )
    out_word = struct.unpack("<I", h.read(BUFFER, 4))[0]
    out_change = struct.unpack("<b", h.read(BUFFER + 3, 1))[0]
    out_dmg = struct.unpack("<h", h.read(BATTLE_DATA + 4, 2))[0]
    calls["bar_flag"] = h.read(0x0203AA01, 1)[0]
    return out_word, out_change, out_dmg, calls


def _run_sol(*, ooze=False, damage=10, def_hp=30, hit_word=0):
    skill_calls = {"n": 0}

    def intercept(lr, r0, r1):
        if (lr & ~1) == D100:
            return 1
        skill_calls["n"] += 1
        if skill_calls["n"] == 1:
            return 1
        return 1 if ooze else 0

    code = assemble(SOL_SRC)
    offsets = symbol_offsets(SOL_SRC)
    h = Harness(code, intercept_calls=intercept)
    h.seed(ACTOR, bytes(_unit(hp=40)))
    h.seed(TARGET, bytes(_unit(hp=def_hp)))
    h.seed(BUFFER, struct.pack("<I", hit_word))
    stats = bytearray(0x10)
    stats[0x15 - 0x10] = 100
    struct.pack_into("<h", stats, 4, damage)
    h.seed(BATTLE_DATA, bytes(stats))
    # Sol reads skill rate from attacker+0x15 (unit skill stat), not battle data.
    atk = _unit(hp=40)
    atk[0x15] = 100
    h.seed(ACTOR, bytes(atk))
    h.run(
        offsets["End"],
        regs={"r0": ACTOR, "r1": TARGET, "r2": BUFFER, "r3": BATTLE_DATA},
    )
    out_word = struct.unpack("<I", h.read(BUFFER, 4))[0]
    out_change = struct.unpack("<b", h.read(BUFFER + 3, 1))[0]
    return out_word, out_change


class StealHpExecutionTests(unittest.TestCase):
    def test_nosferatu_heals_without_ooze(self):
        word, change, _, calls = _run_steal(ooze=False, damage=10, def_hp=30)
        self.assertEqual(calls["effect"], 1)
        self.assertTrue(word & HPSTEAL, f"hp-steal flag missing, buffer={word:#x}")
        self.assertFalse(word & DEVIL)
        self.assertFalse(word & OOZE_DISPLAY)
        self.assertEqual(change, 10)
        self.assertEqual(calls["bar_flag"], 0)

    def test_nosferatu_hurts_attacker_when_target_has_liquid_ooze(self):
        """Holder still takes the hit. 0x100 keeps both bars; 0x1000 inverts
        the caster's steal from heal to drain.
        """
        word, change, _, calls = _run_steal(ooze=True, damage=10, def_hp=30)
        self.assertTrue(word & HPSTEAL)
        self.assertFalse(word & DEVIL)
        self.assertTrue(word & OOZE_DISPLAY, f"ooze display bit missing, buffer={word:#x}")
        self.assertEqual(change, -10)
        self.assertEqual(calls["bar_flag"], 1)

    def test_ooze_caps_at_defender_current_hp(self):
        _, change, _, _ = _run_steal(ooze=True, damage=25, def_hp=8)
        self.assertEqual(change, -8)
        _, change, _, _ = _run_steal(ooze=False, damage=25, def_hp=8)
        self.assertEqual(change, 8)

    def test_miss_does_not_drain(self):
        word, change, _, calls = _run_steal(ooze=True, hit_word=MISS)
        self.assertEqual(calls["effect"], 0)
        self.assertFalse(word & HPSTEAL)
        self.assertEqual(change, 0)

    def test_non_steal_weapon_does_not_drain(self):
        word, change, _, calls = _run_steal(effect=POISON_EFFECT, ooze=True)
        self.assertEqual(calls["effect"], 1)
        self.assertEqual(calls["skill"], 0)
        self.assertFalse(word & HPSTEAL)
        self.assertEqual(change, 0)

    def test_zero_damage_does_not_drain(self):
        word, change, _, calls = _run_steal(damage=0, ooze=True)
        self.assertEqual(calls["skill"], 0)
        self.assertFalse(word & HPSTEAL)
        self.assertEqual(change, 0)

    def test_devil_or_counter_flag_skips_steal_without_clearing_it(self):
        word, change, dmg, calls = _run_steal(ooze=True, hit_word=DEVIL, damage=10)
        self.assertEqual(calls["skill"], 0)
        self.assertTrue(word & DEVIL)
        self.assertFalse(word & HPSTEAL)
        self.assertEqual(change, 0)
        self.assertEqual(dmg, 10)

    def test_counter_round_checks_the_hit_taker_for_ooze(self):
        """Proc loop hardcodes r1 = gBattleTarget; victim is the other struct."""
        word, change, _, calls = _run_steal(
            ooze=True,
            damage=10,
            atk_hp=40,
            def_hp=30,
            round_attacker=TARGET,
            loop_defender=TARGET,
        )
        self.assertEqual(calls["skill"], 1)
        self.assertEqual(change, -10)
        self.assertTrue(word & HPSTEAL)
        self.assertTrue(word & OOZE_DISPLAY)


class KeepHpChangeTests(unittest.TestCase):
    """FE8 succeeds because hpChange stays negative. FE7 0x29496 rewrote it."""

    GP = 0x0203A50C
    STATS = 0x0203A3D8
    HIT = BUFFER

    def _run(self, hit_word, hp_change, damage, flag=0):
        code = assemble(KEEP_SRC)
        offsets = symbol_offsets(KEEP_SRC)
        h = Harness(code)
        word = (hit_word & 0x00FFFFFF) | ((hp_change & 0xFF) << 24)
        h.seed(self.HIT, struct.pack("<I", word))
        h.seed(self.GP, struct.pack("<I", self.HIT))
        stats = bytearray(8)
        struct.pack_into("<H", stats, 4, damage)
        h.seed(self.STATS, bytes(stats))
        h.seed(0x0203AA01, bytes([flag]))
        h.run(
            offsets["KeepSkip"],
            regs={"r2": self.GP},
        )
        out = struct.unpack("<I", h.read(self.HIT, 4))[0]
        return struct.unpack("<b", h.read(self.HIT + 3, 1))[0], out

    def test_ooze_keeps_negative_hpchange(self):
        change, word = self._run(HPSTEAL | OOZE_DISPLAY, -10, 10)
        self.assertEqual(change, -10)
        self.assertTrue(word & OOZE_DISPLAY)

    def test_flag_keeps_negative_hpchange_without_0x1000(self):
        change, _ = self._run(HPSTEAL, -10, 10, flag=1)
        self.assertEqual(change, -10)

    def test_fe8_signal_negative_hpchange_plus_steal(self):
        change, _ = self._run(HPSTEAL, -10, 10)
        self.assertEqual(change, -10)

    def test_vanilla_nosferatu_still_stores_damage(self):
        change, _ = self._run(HPSTEAL, 10, 10)
        self.assertEqual(change, 10)

    def test_plain_hit_stores_damage(self):
        change, _ = self._run(0, 0, 7)
        self.assertEqual(change, 7)


class StealBarOozeTests(unittest.TestCase):
    """HPSTEAL dual bar: without 0x1000, taker drains and stealer heals.
    With 0x1000 both drain |hpChange| (Finish may have left hpChange negative).
    """

    def _side(self, entry, stop, hp, hp_change, flags):
        code = assemble(STEAL_BAR_SRC)
        offsets = symbol_offsets(STEAL_BAR_SRC)
        h = Harness(code)
        word = (flags & 0x00FFFFFF) | ((hp_change & 0xFF) << 24)
        h.seed(BUFFER, struct.pack("<I", word))
        out = h.run(
            offsets[stop],
            regs={"r0": hp, "r9": BUFFER},
            entry_offset=offsets[entry],
        )
        return out["r0"] & 0xFFFFFFFF

    def _stealer(self, hp, hp_change, flags):
        return self._side("LiveToServeStealA", "StealAOut", hp, hp_change, flags)

    def _taker(self, hp, hp_change, flags):
        return self._side("LiveToServeTakeA", "TakeADone", hp, hp_change, flags)

    def test_nosferatu_without_ooze_heals_the_stealer(self):
        self.assertEqual(self._stealer(37, 10, HPSTEAL), 47)

    def test_nosferatu_without_ooze_drains_the_taker(self):
        self.assertEqual(self._taker(40, 10, HPSTEAL), 30)

    def test_ooze_drains_the_stealer_instead(self):
        self.assertEqual(self._stealer(37, 10, HPSTEAL | OOZE_DISPLAY), 27)
        self.assertEqual(self._stealer(37, -10, HPSTEAL | OOZE_DISPLAY), 27)

    def test_ooze_flag_drains_the_stealer_without_0x1000(self):
        """Resire/LUT may not see 0x1000; 0x0203AA01 still inverts steal."""
        code = assemble(STEAL_BAR_SRC)
        offsets = symbol_offsets(STEAL_BAR_SRC)
        h = Harness(code)
        word = (HPSTEAL & 0x00FFFFFF) | (10 << 24)
        h.seed(BUFFER, struct.pack("<I", word))
        h.seed(0x0203AA01, b"\x01")
        out = h.run(
            offsets["StealAOut"],
            regs={"r0": 37, "r9": BUFFER},
            entry_offset=offsets["LiveToServeStealA"],
        )
        self.assertEqual(out["r0"] & 0xFFFFFFFF, 27)

    def test_ooze_drains_the_taker_even_if_hpchange_is_negative(self):
        """Negative hpChange is HP - -N = heal; abs so the holder also drops."""
        self.assertEqual(self._taker(40, 10, HPSTEAL | OOZE_DISPLAY), 30)
        self.assertEqual(self._taker(40, -10, HPSTEAL | OOZE_DISPLAY), 30)

    def test_ooze_stealer_floor_is_zero(self):
        self.assertEqual(self._stealer(4, 10, HPSTEAL | OOZE_DISPLAY), 0)
        self.assertEqual(self._taker(4, -10, HPSTEAL | OOZE_DISPLAY), 0)


GET_ANIM_POS = 0x08054678
HP_DISPLAY = 0x0203E0B8
HITS = 0x0203F000
PROC = 0x0203A000
AIS = 0x0203B000
# ldrb r0, [r0, #0x10] ; bx lr  — position byte on the fake AIS
_GET_ANIM_POS_STUB = bytes.fromhex("007c7047")


def _tick(
    flags,
    *,
    pos=0,
    delta=-1,
    hp0=37,
    hp1=40,
    cur=37,
    start=0,
    final=0,
    entry="LiveToServeHpBarTickMain",
    stop="TickMainDone",
    r6=None,
):
    """One apply. Returns (proc+0x2E, delta, final, display0, display1)."""
    code = assemble(TICK_SRC)
    offsets = symbol_offsets(TICK_SRC)
    h = Harness(code)
    h.seed(GET_ANIM_POS, _GET_ANIM_POS_STUB)
    h.seed(HITS, struct.pack("<I", flags))
    h.seed(0x0203A50C, struct.pack("<I", HITS))
    disp = bytearray(4)
    struct.pack_into("<HH", disp, 0, hp0, hp1)
    h.seed(HP_DISPLAY, bytes(disp))
    proc = bytearray(0x64)
    struct.pack_into("<i", proc, 0x48, delta)
    struct.pack_into("<i", proc, 0x4C, start)
    struct.pack_into("<i", proc, 0x50, final)
    struct.pack_into("<H", proc, 0x2E, cur)
    struct.pack_into("<I", proc, 0x60, AIS)
    struct.pack_into("<I", proc, 0x5C, AIS)
    h.seed(PROC, bytes(proc))
    ais = bytearray(0x12)
    struct.pack_into("<H", ais, 0xE, 1)
    ais[0x10] = pos
    h.seed(AIS, bytes(ais))
    regs = {"r5": PROC}
    if r6 is not None:
        regs["r6"] = r6
    h.run(
        offsets[stop],
        regs=regs,
        entry_offset=offsets[entry],
    )
    out_cur = struct.unpack_from("<H", h.read(PROC + 0x2E, 2))[0]
    out_delta = struct.unpack_from("<i", h.read(PROC + 0x48, 4))[0]
    out_final = struct.unpack_from("<i", h.read(PROC + 0x50, 4))[0]
    d0, d1 = struct.unpack_from("<HH", h.read(HP_DISPLAY, 4))
    return out_cur, out_delta, out_final, d0, d1


class HpBarTickOozeTests(unittest.TestCase):
    """Resire loop 1 ticks the holder only. Loop 2 drains the caster if LUT start > final."""

    def test_without_ooze_a_heal_stays_a_heal(self):
        cur, delta, final, d0, d1 = _tick(
            HPSTEAL, delta=1, cur=37, start=37, final=47
        )
        self.assertEqual(cur, 38)
        self.assertEqual(delta, 1)
        self.assertEqual(final, 47)
        self.assertEqual((d0, d1), (37, 40))

    def test_ooze_loop1_does_not_move_the_other_display(self):
        """Caster drops at spell end (loop 2), not when the hit lands."""
        cur, delta, final, d0, d1 = _tick(
            HPSTEAL | OOZE_DISPLAY,
            pos=0,
            delta=-1,
            hp0=40,
            hp1=37,
            cur=40,
            start=40,
            final=30,
            entry="LiveToServeHpBarTickResire",
            stop="TickResireDone",
        )
        self.assertEqual(cur, 39)
        self.assertEqual(delta, -1)
        self.assertEqual((d0, d1), (40, 37))

    def test_ooze_loop1_other_side_stays(self):
        cur, delta, final, d0, d1 = _tick(
            HPSTEAL | OOZE_DISPLAY,
            pos=1,
            delta=-1,
            hp0=37,
            hp1=40,
            cur=40,
            start=40,
            final=30,
            entry="LiveToServeHpBarTickResire",
            stop="TickResireDone",
        )
        self.assertEqual(cur, 39)
        self.assertEqual((d0, d1), (37, 40))

    def test_ooze_loop3_does_not_tick_a_heal(self):
        """Caster LUT is a heal. Freeze so loop 3 cannot tick the caster up."""
        cur, delta, final, d0, d1 = _tick(
            HPSTEAL | OOZE_DISPLAY,
            delta=1,
            cur=37,
            start=37,
            final=47,
            hp0=37,
            hp1=40,
            entry="LiveToServeHpBarTickResireSteal",
            stop="TickStealDone",
        )
        self.assertEqual(cur, 37)
        self.assertEqual(delta, 0)
        self.assertEqual(final, 37)

    def test_ooze_loop2_setup_freezes_the_heal(self):
        cur, delta, final, d0, d1 = _tick(
            HPSTEAL | OOZE_DISPLAY,
            delta=1,
            cur=37,
            start=37,
            final=47,
            entry="LiveToServeHpBarResireHealSetup",
            stop="TickSetupDone",
            r6=PROC,
        )
        self.assertEqual(delta, 0)
        self.assertEqual(final, 37)

    def test_vanilla_loop2_setup_still_heals(self):
        cur, delta, final, d0, d1 = _tick(
            HPSTEAL,
            delta=1,
            cur=37,
            start=37,
            final=47,
            entry="LiveToServeHpBarResireHealSetup",
            stop="TickSetupDone",
            r6=PROC,
        )
        self.assertEqual(delta, 1)
        self.assertEqual(final, 47)

    def test_ooze_loop2_drain_is_not_frozen(self):
        """Spell-end caster drop. LUT start > final must keep delta -1."""
        cur, delta, final, d0, d1 = _tick(
            HPSTEAL | OOZE_DISPLAY,
            delta=-1,
            cur=37,
            start=37,
            final=27,
            entry="LiveToServeHpBarResireHealSetup",
            stop="TickSetupDone",
            r6=PROC,
        )
        self.assertEqual(delta, -1)
        self.assertEqual(final, 27)

    def test_loop1_does_not_set_proc_mark(self):
        code = assemble(TICK_SRC)
        offsets = symbol_offsets(TICK_SRC)
        h = Harness(code)
        h.seed(GET_ANIM_POS, _GET_ANIM_POS_STUB)
        h.seed(HITS, struct.pack("<I", HPSTEAL | OOZE_DISPLAY))
        h.seed(0x0203A50C, struct.pack("<I", HITS))
        proc = bytearray(0x68)
        struct.pack_into("<i", proc, 0x48, -1)
        struct.pack_into("<H", proc, 0x2E, 40)
        struct.pack_into("<I", proc, 0x60, AIS)
        h.seed(PROC, bytes(proc))
        h.run(
            offsets["TickResireDone"],
            regs={"r5": PROC},
            entry_offset=offsets["LiveToServeHpBarTickResire"],
        )
        mark = struct.unpack_from("<I", h.read(PROC + 0x44, 4))[0]
        self.assertEqual(mark, 0)

    def test_anims_off_skips_steal_negate(self):
        code = assemble(TICK_SRC)
        offsets = symbol_offsets(TICK_SRC)
        h = Harness(code)
        h.seed(HITS, struct.pack("<I", HPSTEAL | OOZE_DISPLAY))
        h.seed(0x0203A50C, struct.pack("<I", HITS))
        out = h.run(
            offsets["MapHpADone"],
            regs={"r1": 10},
            entry_offset=offsets["MapHpSkipNegA"],
        )
        self.assertEqual(out["r0"] & 0xFFFF, 10)
        self.assertEqual(out["r1"] & 0xFFFF, 10 << 4)

    def test_anims_off_vanilla_steal_still_negates(self):
        code = assemble(TICK_SRC)
        offsets = symbol_offsets(TICK_SRC)
        h = Harness(code)
        h.seed(HITS, struct.pack("<I", HPSTEAL))
        h.seed(0x0203A50C, struct.pack("<I", HITS))
        out = h.run(
            offsets["MapHpADone"],
            regs={"r1": 10},
            entry_offset=offsets["MapHpSkipNegA"],
        )
        self.assertEqual(out["r0"] & 0xFFFFFFFF, (-10) & 0xFFFFFFFF)
        self.assertEqual(out["r1"] & 0xFFFF, ((-10) << 4) & 0xFFFF)

    def test_anims_off_b_skips_steal_negate(self):
        code = assemble(TICK_SRC)
        offsets = symbol_offsets(TICK_SRC)
        h = Harness(code)
        table = 0x0203B000
        h.seed(HITS, struct.pack("<I", HPSTEAL | OOZE_DISPLAY))
        h.seed(0x0203A50C, struct.pack("<I", HITS))
        h.seed(table, struct.pack("<h", 10))
        out = h.run(
            offsets["MapHpBDone"],
            regs={"r0": table, "r2": 0},
            entry_offset=offsets["MapHpSkipNegB"],
        )
        self.assertEqual(out["r0"] & 0xFFFF, 10)
        self.assertEqual(out["r1"] & 0xFFFF, 10 << 4)

    def test_proc_mark_freezes_loop2_without_flag_or_0x1000(self):
        """Loop 1 leaves proc+0x44. Loop 2 must still freeze if hits were copied."""
        code = assemble(TICK_SRC)
        offsets = symbol_offsets(TICK_SRC)
        h = Harness(code)
        h.seed(GET_ANIM_POS, _GET_ANIM_POS_STUB)
        h.seed(HITS, struct.pack("<I", HPSTEAL))
        h.seed(0x0203A50C, struct.pack("<I", HITS))
        proc = bytearray(0x68)
        struct.pack_into("<i", proc, 0x48, 1)
        struct.pack_into("<i", proc, 0x4C, 37)
        struct.pack_into("<i", proc, 0x50, 47)
        struct.pack_into("<H", proc, 0x2E, 37)
        struct.pack_into("<I", proc, 0x44, 1)
        h.seed(PROC, bytes(proc))
        h.run(
            offsets["TickSetupDone"],
            regs={"r6": PROC},
            entry_offset=offsets["LiveToServeHpBarResireHealSetup"],
        )
        delta = struct.unpack_from("<i", h.read(PROC + 0x48, 4))[0]
        final = struct.unpack_from("<i", h.read(PROC + 0x50, 4))[0]
        self.assertEqual(delta, 0)
        self.assertEqual(final, 37)

    def test_negative_hpchange_without_0x1000_is_ooze(self):
        """FE8 only negates hpChange. That must still freeze Resire's heal."""
        word = (HPSTEAL & 0x00FFFFFF) | ((-10 & 0xFF) << 24)
        cur, delta, final, d0, d1 = _tick(
            word,
            delta=1,
            cur=37,
            start=37,
            final=47,
            entry="LiveToServeHpBarResireHealSetup",
            stop="TickSetupDone",
            r6=PROC,
        )
        self.assertEqual(delta, 0)
        self.assertEqual(final, 37)

    def test_tickmain_still_drops_the_other_display(self):
        """Sol / non-Resire hit apply has no spell-end loop, so tick both bars."""
        cur, delta, final, d0, d1 = _tick(
            HPSTEAL | OOZE_DISPLAY,
            pos=0,
            delta=-1,
            hp0=40,
            hp1=37,
            cur=40,
            start=40,
            final=30,
        )
        self.assertEqual(cur, 39)
        self.assertEqual((d0, d1), (40, 36))

    def test_resire_loop1_own_bar_for_ten_ticks(self):
        flags = HPSTEAL | OOZE_DISPLAY
        hp0, hp1, cur = 40, 37, 40
        for step in range(10):
            cur, delta, final, d0, d1 = _tick(
                flags,
                pos=0,
                delta=-1,
                hp0=hp0,
                hp1=hp1,
                cur=cur,
                start=40,
                final=30,
                entry="LiveToServeHpBarTickResire",
                stop="TickResireDone",
            )
            self.assertEqual(cur, 39 - step)
            self.assertEqual((d0, d1), (40, 37), f"caster display moved at tick {step}")
            hp0, hp1 = d0, d1


class SolOozeExecutionTests(unittest.TestCase):
    def test_sol_heals_without_ooze(self):
        word, change = _run_sol(ooze=False, damage=12, def_hp=30)
        self.assertEqual(change, 12)
        self.assertTrue(word & 0x4100)

    def test_sol_hurts_attacker_when_target_has_liquid_ooze(self):
        word, change = _run_sol(ooze=True, damage=12, def_hp=30)
        self.assertEqual(change, -12)
        self.assertTrue(word & 0x4100)
        self.assertFalse(word & DEVIL)
        self.assertTrue(word & OOZE_DISPLAY)


class EfxHpBarOozeWiringTests(unittest.TestCase):
    """Devil/steal HP-bar tick must read FE7 hits; FE8 0x802aec4 never sees 0x80."""

    EFX = (
        ROOT / "EngineHacks/SkillSystem/Internals/efxHpBar.s",
        ROOT / "EngineHacks/SkillSystem/Internals/efxHpBarLive.s",
    )

    def test_hp_bar_reads_fe7_hits_and_ticks_devil(self):
        for path in self.EFX:
            text = path.read_text(encoding="utf-8")
            self.assertNotIn(
                "802aec4",
                text,
                f"{path.name} still uses FE8 gBattleHits",
            )
            self.assertIn("0x0203F000", text)
            self.assertIn("0x8C", text, f"{path.name} must mask 0x1180 (devil|steal|ooze)")
        steal_src = (
            ROOT
            / "EngineHacks/SkillSystem/Skills/StandaloneSkills/LiveToServe/LiveToServeHpBarSteal.s"
        ).read_text(encoding="utf-8")
        self.assertIn("0x1000", steal_src)
        self.assertIn("LiveToServeStealA", steal_src)
        tick_src = (
            ROOT
            / "EngineHacks/SkillSystem/Skills/StandaloneSkills/LiveToServe/LiveToServeHpBarTick.s"
        ).read_text(encoding="utf-8")
        self.assertIn("LiveToServeHpBarTickMain", tick_src)
        self.assertIn("OozeProcMark", tick_src)
        keep_src = (
            ROOT
            / "EngineHacks/Necessary/CalcLoops/BattleProcCalcLoop/LifeSteal/keep_hpchange.s"
        ).read_text(encoding="utf-8")
        self.assertIn("KeepHpChange", keep_src)
        self.assertIn("0x08029499", keep_src)
        self.assertIn("LiveToServeHpBarTickResire", tick_src)
        self.assertIn("LiveToServeHpBarTickResireSteal", tick_src)
        self.assertIn("LiveToServeHpBarResireHealSetup", tick_src)


class StealHpWiringTests(unittest.TestCase):
    def test_source_lists_stealhp_before_finish(self):
        text = LOOP_EVENT.read_text(encoding="utf-8")
        self.assertIn("Proc_StealHP", text)
        self.assertLess(text.index("Proc_StealHP"), text.index("POIN Proc_Finish"))

    def test_stealhp_is_in_the_built_proc_loop(self):
        import built_rom

        rom, sym = built_rom.load(), built_rom.symbols()
        for name in ("Proc_StealHP", "Proc_Finish", "ProcLoop_Start", "ProcLoopParent"):
            if name not in sym:
                self.fail(f"{name} missing from FE7_Hack.sym")
        table = rom.find(
            struct.pack("<I", sym["ProcLoop_Start"]),
            built_rom.offset(rom, sym["ProcLoopParent"]),
        )
        self.assertNotEqual(table, -1, "proc loop table not found")
        entries = []
        off = table
        while True:
            ptr = struct.unpack_from("<I", rom, off)[0]
            if ptr == 0:
                break
            entries.append(ptr & ~1)
            off += 4
        self.assertIn(sym["Proc_StealHP"] & ~1, entries)
        self.assertLess(
            entries.index(sym["Proc_StealHP"] & ~1),
            entries.index(sym["Proc_Finish"] & ~1),
        )

    def test_vanilla_steal_hp_is_skipped_after_the_proc_loop(self):
        """0x80294xx still runs after ProcLoopParent and used to heal Nosferatu
        by writing current HP, undoing Liquid Ooze. The bne-over-steal must
        become an always-skip.
        """
        import built_rom

        rom = built_rom.load()
        hw = struct.unpack_from("<H", rom, 0x29466)[0]
        self.assertEqual(
            hw,
            0xE012,
            f"vanilla steal at 0x29466 is {hw:#06x}, expected b 0xE012",
        )

    def test_fe8_hpchange_is_not_overwritten_by_damage(self):
        """FE8 keeps signed hpChange. FE7 0x29496 used to strb +damage on top."""
        import built_rom

        rom = built_rom.load()
        self.assertEqual(rom[0x29490:0x29494], bytes.fromhex("004b1847"))


@unittest.skipUnless((ROOT / "FE7_Hack.gba").exists(), "FE7_Hack.gba missing")
class RomHpBarTickOozeTests(unittest.TestCase):
    """Resire loop 2/3 freeze a heal LUT; a drain LUT must still tick."""

    def test_rom_loop3_freezes_the_heal(self):
        import sys

        sys.path.insert(0, str(ROOT / "tests"))
        from gba_machine import Gba, RETURN_MAGIC
        from unicorn import UC_HOOK_CODE
        from unicorn.arm_const import (
            UC_ARM_REG_LR,
            UC_ARM_REG_R5,
            UC_ARM_REG_SP,
        )

        rom = (ROOT / "FE7_Hack.gba").read_bytes()
        jump = bytes.fromhex("004b1847")
        if rom[0x4DB00:0x4DB04] != jump:
            self.skipTest("Resire steal apply not hooked yet")
        g = Gba(rom)
        g.w32(HITS, HPSTEAL | OOZE_DISPLAY)
        proc = bytearray(0x64)
        struct.pack_into("<i", proc, 0x48, 1)
        struct.pack_into("<i", proc, 0x4C, 37)
        struct.pack_into("<i", proc, 0x50, 47)
        struct.pack_into("<H", proc, 0x2E, 37)
        struct.pack_into("<I", proc, 0x60, AIS)
        g.uc.mem_write(PROC, bytes(proc))
        ais = bytearray(0x12)
        struct.pack_into("<H", ais, 0xE, 1)
        g.uc.mem_write(AIS, bytes(ais))
        uc = g.uc
        uc.reg_write(UC_ARM_REG_R5, PROC)
        uc.reg_write(UC_ARM_REG_SP, 0x03007F00)
        uc.reg_write(UC_ARM_REG_LR, RETURN_MAGIC | 1)
        stop = {"n": 0}

        def on_code(_u, addr, size, _):
            stop["n"] += 1
            if stop["n"] > 20000:
                _u.emu_stop()
            if addr == 0x0804DB08:
                _u.emu_stop()

        uc.hook_add(UC_HOOK_CODE, on_code)
        uc.emu_start(0x0804DB00 | 1, RETURN_MAGIC, timeout=2_000_000)
        self.assertEqual(g.r16(PROC + 0x2E), 37)
        self.assertEqual(g.r32(PROC + 0x48), 0)
        self.assertEqual(g.r32(PROC + 0x50), 37)

    def test_rom_loop2_setup_freezes_the_heal(self):
        import sys

        sys.path.insert(0, str(ROOT / "tests"))
        from gba_machine import Gba, RETURN_MAGIC
        from unicorn import UC_HOOK_CODE
        from unicorn.arm_const import (
            UC_ARM_REG_LR,
            UC_ARM_REG_R6,
            UC_ARM_REG_SP,
        )

        rom = (ROOT / "FE7_Hack.gba").read_bytes()
        if rom[0x4DA78:0x4DA7C] != bytes.fromhex("004b1847"):
            self.skipTest("Resire heal setup not hooked yet")
        g = Gba(rom)
        g.w32(HITS, HPSTEAL | OOZE_DISPLAY)
        proc = bytearray(0x64)
        struct.pack_into("<i", proc, 0x48, 1)
        struct.pack_into("<i", proc, 0x4C, 37)
        struct.pack_into("<i", proc, 0x50, 47)
        struct.pack_into("<H", proc, 0x2E, 37)
        g.uc.mem_write(PROC, bytes(proc))
        uc = g.uc
        uc.reg_write(UC_ARM_REG_R6, PROC)
        uc.reg_write(UC_ARM_REG_SP, 0x03007F00)
        uc.reg_write(UC_ARM_REG_LR, RETURN_MAGIC | 1)
        stop = {"n": 0}

        def on_code(_u, addr, size, _):
            stop["n"] += 1
            if stop["n"] > 20000:
                _u.emu_stop()
            if addr == 0x0804DA90:
                _u.emu_stop()

        uc.hook_add(UC_HOOK_CODE, on_code)
        uc.emu_start(0x0804DA78 | 1, RETURN_MAGIC, timeout=2_000_000)
        self.assertEqual(g.r32(PROC + 0x48), 0)
        self.assertEqual(g.r32(PROC + 0x50), 37)


@unittest.skipUnless(
    (ROOT / "FE7_Hack.gba").exists() and (ROOT / "FE7_clean.gba").exists(),
    "ROMs missing",
)
class IronSwordAnimDataTests(unittest.TestCase):
    """Lyn Lord sword/magic-sword AIS list and Iron Sword row must stay vanilla."""

    def test_iron_sword_and_lyn_lord_anim_match_clean(self):
        import struct

        hack = (ROOT / "FE7_Hack.gba").read_bytes()
        clean = (ROOT / "FE7_clean.gba").read_bytes()
        et = struct.unpack_from("<I", hack, 0x17438)[0] & 0x01FFFFFF
        self.assertEqual(hack[et + 36 : et + 72], clean[0xBE222C + 36 : 0xBE222C + 72])
        self.assertEqual(hack[et + 36 + 7], 0)
        self.assertEqual(struct.unpack_from("<I", hack, et + 36 + 8)[0], 1)
        self.assertEqual(hack[et + 36 + 0x1F], 0)
        c0 = 0xBE0158
        lyn = c0 + 2 * 0x54
        self.assertEqual(hack[lyn : lyn + 0x54], clean[lyn : lyn + 0x54])
        anim = struct.unpack_from("<I", hack, lyn + 0x38)[0] & 0x01FFFFFF
        self.assertEqual(hack[anim : anim + 12], clean[anim : anim + 12])


if __name__ == "__main__":
    unittest.main()
