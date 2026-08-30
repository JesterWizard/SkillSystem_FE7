"""FE7 wiring for the standalone FE8 skill ports.

Unicorn executes Vantage (HP gate and Vantage+), Discipline (double WEXP),
LockTouch (0xFF), and Biorhythm (Tempest/Serenity/none). SkillTester is
stubbed by the harness; these tests do not assign skills to units.
"""
import re
import struct
import sys
import tempfile
import unittest
from pathlib import Path
from typing import List, Optional

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from Tools.thumb_harness import (
    CODE_BASE,
    Harness,
    NOP,
    SKILLTESTER_CALL,
    TRAMPOLINE_HALFWORDS,
    _is_trampoline_at,
    assemble,
    symbol_offsets,
)

DEFS = ROOT / "EngineHacks" / "SkillSystem" / "skill_definitions.event"
MASTER = ROOT / "EngineHacks" / "SkillSystem" / "Skills" / "MasterSkillInstaller.event"
STANDALONE = (
    ROOT
    / "EngineHacks"
    / "SkillSystem"
    / "Skills"
    / "StandaloneSkills"
    / "FE7Standalone.event"
)
TURN = ROOT / "EngineHacks" / "Necessary" / "CalcLoops" / "TurnLoop" / "Installer.event"
LOOP = ROOT / "EngineHacks" / "Necessary" / "CalcLoops" / "PreBattleCalcLoop" / "PreBattleCalcLoop.event"
CONFIG = ROOT / "EngineHacks" / "Config.event"
HACK = ROOT / "FE7_Hack.gba"

VANTAGE = ROOT / "EngineHacks/SkillSystem/Skills/StandaloneSkills/Vantage/vantage.s"
DISCIPLINE = ROOT / "EngineHacks/SkillSystem/Skills/StandaloneSkills/Discipline/Discipline.s"
LOCKTOUCH = ROOT / "EngineHacks/SkillSystem/Skills/StandaloneSkills/Locktouch/LockTouch.s"
CUNNINGFOG = ROOT / "EngineHacks/SkillSystem/Skills/StandaloneSkills/Locktouch/CunningFog.s"
BIORHYTHM = ROOT / "EngineHacks/SkillSystem/Skills/StandaloneSkills/Biorhythm/Biorhythm.s"
SHREWD = ROOT / "EngineHacks/SkillSystem/Skills/StandaloneSkills/ShrewdPotential/ShrewdPotential.s"
IDENTITY = ROOT / "EngineHacks/SkillSystem/Skills/UnitMenuSkills/Summon/IdentityProblemsName.s"
PORTRAIT = ROOT / "EngineHacks/SkillSystem/Skills/UnitMenuSkills/Summon/SummonPortraitGuard.s"
BOON = ROOT / "EngineHacks/SkillSystem/Skills/StandaloneSkills/Boon/Boon.s"
UNITMENU = ROOT / "EngineHacks/SkillSystem/Skills/UnitMenuSkills/UnitMenuSkills.event"
SAVIOR = ROOT / "EngineHacks/Necessary/StatGetters/_asm/HalveIfRescuing.s"
SBN = (
    ROOT
    / "EngineHacks/Necessary/ModularStatScreen/pages/signed_bonus_number.s"
)
ADJUST = (
    ROOT
    / "EngineHacks/Necessary/ModularStatScreen/pages/AdjustBarBaseForSavior.s"
)
SKIP_ARROWS = (
    ROOT
    / "EngineHacks/Necessary/ModularStatScreen/pages/SkipRescueArrowsIfSavior.s"
)
MSS_DEFS = (
    ROOT / "EngineHacks/Necessary/ModularStatScreen/pages/mss_defs.s"
)
LIVE = ROOT / "EngineHacks/SkillSystem/Skills/StandaloneSkills/LiveToServe/LiveToServe.s"
RALLYCHAOS = ROOT / "EngineHacks/SkillSystem/Skills/TurnSkills/RallyChaos.s"

ATTACKER = 0x0203A3F0
DEFENDER = 0x0203A470
STORE_ATK = 0x02001000
STORE_DEF = 0x02001004
UNIT = 0x02000000
CHAR = 0x02000100
TABLE = 0x02000200
CHAR_SIZE = 0x34
HIT = 50


ENABLED = {
    "TempestID": 38,
    "SerenityID": 41,
    "BoonID": 55,
    "CunningID": 68,
    "DisciplineID": 95,
    "LockTouchID": 96,
    "DisciplinePlusID": 111,
    "DragonsBloodID": 113,
    "IdentityProblemsID": 119,
    "RandomMugID": 129,
    "LiveToServeID": 130,
    "RallyChaosID": 142,
    "SaviorID": 164,
    "ShrewdPotentialID": 182,
    "SynchronizeID": 183,
    "TriangleAttackID": 184,
    "VantageID": 185,
    "VantagePlusID": 186,
    "VigorDanceID": 200,
    "WatchfulID": 254,
}


def _macro(name: str) -> str:
    text = DEFS.read_text(encoding="utf-8")
    m = re.search(rf"^#define\s+{name}\s+(\S+)", text, re.M)
    return m.group(1) if m else ""


def _patch_testers(code: bytes, returns: List[int]) -> bytes:
    patched = bytearray(code)
    idx = -1
    n = 0
    while n < len(returns):
        idx = code.find(SKILLTESTER_CALL, idx + 1)
        if idx == -1:
            break
        if not _is_trampoline_at(code, idx):
            continue
        span_start = idx - 8
        for i in range(4):
            patched[span_start + 2 * i : span_start + 2 * i + 2] = NOP.to_bytes(2, "little")
        patched[idx : idx + 2] = (0x2000 | (returns[n] & 0xFF)).to_bytes(2, "little")
        n += 1
    if n != len(returns):
        raise AssertionError(f"patched {n} SkillTester calls, wanted {len(returns)}")
    return bytes(patched)


class StandaloneSourceTests(unittest.TestCase):
    def test_ids_are_enabled(self):
        for name, sid in ENABLED.items():
            self.assertEqual(_macro(name), str(sid), name)
        self.assertEqual(_macro("InspiringTuneID"), "VigorDanceID")
        self.assertEqual(_macro("PointBlankID"), "137")

    def test_fe7_installer_not_fe8_orgs(self):
        master = MASTER.read_text(encoding="utf-8")
        self.assertIn("StandaloneSkills/FE7Standalone.event", master)
        self.assertNotRegex(
            master,
            r'^#include\s+"StandaloneSkills/StandaloneSkills\.event"',
            re.M,
        )
        text = STANDALONE.read_text(encoding="utf-8")
        self.assertIn("ORG $29028", text)
        self.assertIn("ORG $29B88", text)
        self.assertIn("ORG $2C360", text)
        for org in ("ORG $5314C", "ORG $531B0"):
            self.assertIn(org, text)
        self.assertNotIn("ORG $4DD8C", text)
        self.assertIn("ORG $18524", text)
        self.assertIn("ORG $2CD60", text)
        self.assertIn("ORG $27594", text)
        self.assertIn("ORG $175BC", text)
        self.assertIn("ORG $18390", text)
        self.assertNotIn("ORG $188F6", text)
        self.assertNotIn("ORG $2Af7C", text)
        self.assertNotIn("ORG $2EBD4", text)

    def test_turn_and_prebattle_wiring(self):
        turn = TURN.read_text(encoding="utf-8")
        self.assertNotIn("ClearBwlRallies Boon", turn)
        self.assertIn("StartOfTurnBuffFunctionEntry(RallyChaosID", turn)
        standalone = STANDALONE.read_text(encoding="utf-8")
        self.assertIn("ORG $18390", standalone)
        self.assertIn("POIN (Boon|1)", standalone)
        loop = LOOP.read_text(encoding="utf-8")
        self.assertIn("BiorhythmFunc", loop)
        cfg = CONFIG.read_text(encoding="utf-8")
        self.assertIn("#define MSG_HAS_VIGOR_DANCE", cfg)
        self.assertIn("#define BIORHYTHM", cfg)
        menu = UNITMENU.read_text(encoding="utf-8")
        self.assertIn("ORG $A8AC", menu)
        self.assertIn("ORG $23078", menu)
        self.assertIn("ORG $7FA98", menu)
        self.assertIn("ORG $94508", menu)
        self.assertIn("ORG $18BF4", menu)
        self.assertIn("ORG $85134", menu)
        self.assertIn("ORG $86CB4", menu)
        self.assertIn("SummonMiniPortraitGuard", menu)
        self.assertIn("WORD (CharacterTable+0x08000000)", menu)
        mss_left = (
            ROOT
            / "EngineHacks"
            / "Necessary"
            / "ModularStatScreen"
            / "pages"
            / "mss_leftstatscreen.s"
        ).read_text(encoding="utf-8")
        self.assertIn("MssIdentityName", mss_left)
        mss_defs = MSS_DEFS.read_text(encoding="utf-8")
        self.assertIn("MssIdentityName", mss_defs)
        self.assertIn("IdentityMugList:", menu)
        self.assertIn("BYTE 0x02 0x04 0x05", menu)
        self.assertNotIn("BYTE 0x01 0x02 0x03 0x09 0x0A 0x0C 0x22 0x23", menu)
        rally = (
            ROOT
            / "EngineHacks"
            / "SkillSystem"
            / "Skills"
            / "RallySkills"
            / "asm"
            / "RallyFx.s"
        ).read_text(encoding="utf-8")
        self.assertIn("ldr r0, =BuffFxProc", rally)
        common = (
            ROOT
            / "EngineHacks"
            / "Necessary"
            / "StatGetters"
            / "_Common.event"
        ).read_text(encoding="utf-8")
        self.assertIn("HalveIfRescuing.lyn.event", common)
        live = (
            ROOT
            / "EngineHacks"
            / "SkillSystem"
            / "Skills"
            / "StandaloneSkills"
            / "LiveToServe"
            / "LiveToServe.s"
        ).read_text(encoding="utf-8")
        self.assertIn("0x0203A3F0", live)
        self.assertIn("VanillaEpilogue", live)


class VantageExecutionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        try:
            assemble(VANTAGE)
        except Exception as exc:
            raise unittest.SkipTest(f"thumb harness unavailable: {exc}")
        cls.off = symbol_offsets(VANTAGE)

    def _run(self, cur: int, mx: int, testers: List[int]):
        h = Harness(_patch_testers(assemble(VANTAGE), testers))
        buf = bytearray(0x80)
        buf[0x12] = mx
        buf[0x13] = cur
        h.seed(ATTACKER, bytes(0x80))
        h.seed(DEFENDER, bytes(buf))
        h.seed(STORE_ATK, b"\x00" * 4)
        h.seed(STORE_DEF, b"\x00" * 4)
        h.run(
            self.off["VantageDone"],
            regs={"r0": STORE_ATK, "r1": STORE_DEF},
        )
        atk = struct.unpack("<I", h.read(STORE_ATK, 4))[0]
        dfn = struct.unpack("<I", h.read(STORE_DEF, 4))[0]
        return atk, dfn

    def test_vantage_swaps_at_half_hp(self):
        atk, dfn = self._run(4, 8, [0, 1])
        self.assertEqual(atk, DEFENDER)
        self.assertEqual(dfn, ATTACKER)

    def test_vantage_no_swap_above_half_hp(self):
        atk, dfn = self._run(5, 8, [0, 1])
        self.assertEqual(atk, ATTACKER)
        self.assertEqual(dfn, DEFENDER)

    def test_no_skill_never_swaps(self):
        atk, dfn = self._run(1, 8, [0, 0])
        self.assertEqual(atk, ATTACKER)
        self.assertEqual(dfn, DEFENDER)

    def test_vantage_plus_always_swaps_and_zeros_crit(self):
        raw = _patch_testers(assemble(VANTAGE), [1, 0])
        h = Harness(raw)
        buf = bytearray(0x80)
        buf[0x12] = 8
        buf[0x13] = 8
        buf[0x66] = 50
        buf[0x67] = 0
        buf[0x6A] = 40
        buf[0x6B] = 0
        h.seed(ATTACKER, bytes(0x80))
        h.seed(DEFENDER, bytes(buf))
        h.seed(STORE_ATK, b"\x00" * 4)
        h.seed(STORE_DEF, b"\x00" * 4)
        h.run(self.off["VantageDone"], regs={"r0": STORE_ATK, "r1": STORE_DEF})
        self.assertEqual(struct.unpack("<I", h.read(STORE_ATK, 4))[0], DEFENDER)
        swapped = h.read(DEFENDER, 0x70)
        crit = int.from_bytes(swapped[0x66:0x68], "little")
        bcrit = int.from_bytes(swapped[0x6A:0x6C], "little")
        self.assertEqual(crit, 0)
        self.assertEqual(bcrit, 0)


class DisciplineExecutionTests(unittest.TestCase):
    def test_no_skill_adds_product_to_current_wexp(self):
        # callHack_r3 at $29B88 is 12 bytes and overwrites vanilla add r6, r1, r6
        # plus mov r1, #0. The NoSkill path must apply both or WEXP never increases.
        try:
            code = assemble(DISCIPLINE)
        except Exception as extra:
            raise unittest.SkipTest(f"thumb harness unavailable: {extra}")
        off = symbol_offsets(DISCIPLINE)
        h = Harness(code, skill_present=False)
        h.seed(UNIT + 0x7B, b"\x02")
        regs = h.run(
            off["DisciplineDone"],
            regs={"r0": 3, "r1": UNIT + 0x7B, "r6": 10, "r7": UNIT},
        )
        self.assertEqual(regs["r0"], 6)
        self.assertEqual(regs["r6"], 16)
        self.assertEqual(regs["r1"], 0)

    def test_discipline_plus_doubles_and_adds(self):
        try:
            code = assemble(DISCIPLINE)
        except Exception as exc:
            raise unittest.SkipTest(f"thumb harness unavailable: {exc}")
        off = symbol_offsets(DISCIPLINE)
        h = Harness(code, skill_present=True)
        h.seed(UNIT + 0x7B, b"\x02")
        regs = h.run(
            off["DisciplinePlusDone"],
            regs={"r0": 3, "r1": UNIT + 0x7B, "r6": 10, "r7": UNIT},
        )
        self.assertEqual(regs["r0"], 12)
        self.assertEqual(regs["r6"], 22)


class LockTouchExecutionTests(unittest.TestCase):
    def test_returns_ff_when_skill_present(self):
        try:
            code = assemble(LOCKTOUCH)
        except Exception as exc:
            raise unittest.SkipTest(f"thumb harness unavailable: {exc}")
        off = symbol_offsets(LOCKTOUCH)
        h = Harness(code, skill_present=True)
        regs = h.run(off["LockTouchDone"], regs={"r0": UNIT, "r1": 0})
        self.assertEqual(regs["r0"], 0xFF)

    def test_cunning_also_returns_ff(self):
        try:
            raw = assemble(LOCKTOUCH)
        except Exception as exc:
            raise unittest.SkipTest(f"thumb harness unavailable: {exc}")
        off = symbol_offsets(LOCKTOUCH)
        h = Harness(_patch_testers(raw, [0, 1]))
        regs = h.run(off["LockTouchDone"], regs={"r0": UNIT, "r1": 0})
        self.assertEqual(regs["r0"], 0xFF)


class BiorhythmExecutionTests(unittest.TestCase):
    def _run(
        self,
        testers: Optional[List[int]],
        skill_present=None,
        table=b'\x06\x00',
        turn=0,
    ):
        raw = assemble(BIORHYTHM)
        off = symbol_offsets(BIORHYTHM)
        code = _patch_testers(raw, testers) if testers is not None else raw
        h = Harness(code, skill_present=True if skill_present is None else skill_present)
        pool = off['SkillTester']
        h.seed(CODE_BASE + pool + 12, struct.pack('<I', TABLE))
        h.seed(TABLE, table)
        bu = bytearray(0x70)
        struct.pack_into('<I', bu, 0, CHAR)
        struct.pack_into('<H', bu, 0x60, HIT)
        struct.pack_into('<H', bu, 0x62, HIT)
        h.seed(CHAR, b'\x00' * 8)
        chap = bytearray(0x14)
        struct.pack_into('<H', chap, 0x10, turn)
        h.seed(0x0202BBF8, bytes(chap))
        h.seed(ATTACKER, bytes(bu))
        h.run(off['GoBack'], regs={'r0': ATTACKER, 'r1': DEFENDER})
        return int.from_bytes(h.read(ATTACKER + 0x60, 2), 'little')

    def test_neutral_skills_add_ten(self):
        try:
            assemble(BIORHYTHM)
        except Exception as extra:
            raise unittest.SkipTest(f'thumb harness unavailable: {extra}')
        self.assertEqual(self._run([0, 0]), HIT + 10)

    def test_serenity_halves(self):
        try:
            assemble(BIORHYTHM)
        except Exception as extra:
            raise unittest.SkipTest(f'thumb harness unavailable: {extra}')
        self.assertEqual(self._run([1, 0]), HIT + 5)

    def test_tempest_doubles(self):
        try:
            assemble(BIORHYTHM)
        except Exception as extra:
            raise unittest.SkipTest(f'thumb harness unavailable: {extra}')
        self.assertEqual(self._run([0, 1]), HIT + 20)

    def test_zero_table_defaults_to_minus_ten(self):
        try:
            assemble(BIORHYTHM)
        except Exception as extra:
            raise unittest.SkipTest(f'thumb harness unavailable: {extra}')
        self.assertEqual(self._run([0, 0], table=b'\x00\x00'), HIT - 10)


CLASS = 0x02000180
RAMBYTE = 0x0203AA00
CLOCK = 0x03000010
NAMES = 0x02000400
MUGS = 0x02000410
NAME_CAMUS = 0xD53
NAME_ZEKE = 0xD55
NAME_SIRIUS = 0xD54
CHAR_NAME = 0x0123
JUMP = bytes.fromhex('004b1847')


def _char_table(*entries):
    buf = bytearray(CHAR_SIZE * (len(entries) + 1))
    for i, (name, portrait) in enumerate(entries, start=1):
        off = CHAR_SIZE * i
        struct.pack_into('<H', buf, off, name)
        struct.pack_into('<H', buf, off + 6, portrait)
    return bytes(buf)


CHAR_POOL = (
    (NAME_CAMUS, 0x02),
    (NAME_ZEKE, 0x0C),
    (NAME_SIRIUS, 0x09),
)


class ShrewdPotentialExecutionTests(unittest.TestCase):
    def _run(self, table, unit, present):
        raw = assemble(SHREWD)
        off = symbol_offsets(SHREWD)
        h = Harness(raw, skill_present=present)
        h.seed(CODE_BASE + off['SkillTester'] + 8, struct.pack('<I', 1))
        h.seed(TABLE, table)
        h.seed(UNIT, unit)
        h.run(
            off['ShrewdPotentialDone'],
            regs={'r0': TABLE, 'r1': UNIT, 'r4': UNIT},
            entry_offset=off['ShrewdPotential'],
        )
        return h.read(UNIT, 0x48)

    def test_nonzero_bonus_gains_extra(self):
        try:
            assemble(SHREWD)
        except Exception as extra:
            raise unittest.SkipTest(f'thumb harness unavailable: {extra}')
        table = bytearray(16)
        table[1] = 2
        unit = bytearray(0x48)
        unit[0x14] = 10
        out = self._run(bytes(table), bytes(unit), True)
        self.assertEqual(out[0x14], 13)

    def test_no_skill_applies_bonus_only(self):
        try:
            assemble(SHREWD)
        except Exception as extra:
            raise unittest.SkipTest(f'thumb harness unavailable: {extra}')
        table = bytearray(16)
        table[1] = 2
        unit = bytearray(0x48)
        unit[0x14] = 10
        out = self._run(bytes(table), bytes(unit), False)
        self.assertEqual(out[0x14], 12)

    def test_zero_bonus_gets_no_extra(self):
        try:
            assemble(SHREWD)
        except Exception as extra:
            raise unittest.SkipTest(f'thumb harness unavailable: {extra}')
        table = bytearray(16)
        unit = bytearray(0x48)
        unit[0x14] = 10
        out = self._run(bytes(table), bytes(unit), True)
        self.assertEqual(out[0x14], 10)

    def test_mag_at_0x47(self):
        try:
            assemble(SHREWD)
        except Exception as extra:
            raise unittest.SkipTest(f'thumb harness unavailable: {extra}')
        table = bytearray(16)
        table[9] = 3
        unit = bytearray(0x48)
        unit[0x47] = 5
        yes = self._run(bytes(table), bytes(unit), True)
        no = self._run(bytes(table), bytes(unit), False)
        self.assertEqual(yes[0x47], 9)
        self.assertEqual(no[0x47], 8)

    def test_mov_gets_no_extra(self):
        try:
            assemble(SHREWD)
        except Exception as extra:
            raise unittest.SkipTest(f'thumb harness unavailable: {extra}')
        table = bytearray(16)
        table[8] = 2
        unit = bytearray(0x48)
        unit[0x1A] = 5
        out = self._run(bytes(table), bytes(unit), True)
        self.assertEqual(out[0x1A], 7)


def _patch_skilltester_clobber_r3(code: bytes, skill_present: bool) -> bytes:
    """Replace SkillTester with `movs r3, #0` then `movs r0, #present`.

    Real SkillTester is allowed to clobber r0-r3. The default harness NOPs the
    `ldr r3, SkillTester` trampoline, so a routine that keeps chapter vision in
    r3 across the call passes Unicorn and still returns a pointer-sized range
    in-game (fog fully revealed).
    """
    patched = bytearray(code)
    idx = -1
    found = False
    while True:
        idx = code.find(SKILLTESTER_CALL, idx + 1)
        if idx == -1:
            break
        if not _is_trampoline_at(code, idx):
            continue
        found = True
        span_start = idx - 2 * (TRAMPOLINE_HALFWORDS - 1)
        for i in range(TRAMPOLINE_HALFWORDS - 1):
            patched[span_start + 2 * i : span_start + 2 * i + 2] = NOP.to_bytes(
                2, "little"
            )
        clobber = span_start + 2 * (TRAMPOLINE_HALFWORDS - 2)
        patched[clobber : clobber + 2] = (0x2300).to_bytes(2, "little")  # movs r3, #0
        movs_r0 = 0x2000 | (1 if skill_present else 0)
        patched[idx : idx + 2] = movs_r0.to_bytes(2, "little")
    if not found:
        raise AssertionError("CunningFog SkillTester trampoline not found")
    return bytes(patched)


class CunningFogExecutionTests(unittest.TestCase):
    def _run(self, present, steal=0, vision=3, torch=0):
        raw = assemble(CUNNINGFOG)
        off = symbol_offsets(CUNNINGFOG)
        h = Harness(_patch_skilltester_clobber_r3(raw, present))
        char = bytearray(0x2C)
        cls = bytearray(0x2C)
        struct.pack_into('<I', char, 0x28, steal)
        unit = bytearray(0x48)
        struct.pack_into('<I', unit, 0, CHAR)
        struct.pack_into('<I', unit, 4, CLASS)
        unit[0x31] = torch
        chap = bytearray(0x14)
        chap[0x0D] = vision
        h.seed(CHAR, bytes(char))
        h.seed(CLASS, bytes(cls))
        h.seed(UNIT, bytes(unit))
        h.seed(0x0202BBF8, bytes(chap))
        regs = h.run(
            off['CunningFogDone'],
            regs={'r0': UNIT},
            entry_offset=off['CunningFog'],
        )
        return regs['r0']

    def test_cunning_adds_five_in_fog(self):
        try:
            assemble(CUNNINGFOG)
        except Exception as extra:
            raise unittest.SkipTest(f'thumb harness unavailable: {extra}')
        self.assertEqual(self._run(True), 8)

    def test_no_skill_keeps_chapter_vision(self):
        try:
            assemble(CUNNINGFOG)
        except Exception as extra:
            raise unittest.SkipTest(f'thumb harness unavailable: {extra}')
        self.assertEqual(self._run(False), 3)

    def test_steal_bit_adds_five_without_skill(self):
        try:
            assemble(CUNNINGFOG)
        except Exception as extra:
            raise unittest.SkipTest(f'thumb harness unavailable: {extra}')
        self.assertEqual(self._run(False, steal=8), 8)

    def test_steal_and_cunning_do_not_stack(self):
        try:
            assemble(CUNNINGFOG)
        except Exception as extra:
            raise unittest.SkipTest(f'thumb harness unavailable: {extra}')
        self.assertEqual(self._run(True, steal=8), 8)


class IdentityNameExecutionTests(unittest.TestCase):
    def _run(self, present, idx=0, last_unit=0, last_clock=0, clock=0):
        raw = assemble(IDENTITY)
        off = symbol_offsets(IDENTITY)
        h = Harness(raw, skill_present=present)
        pool = off['SkillTester']
        h.seed(CODE_BASE + pool + 8, struct.pack('<I', RAMBYTE))
        h.seed(CODE_BASE + pool + 12, struct.pack('<I', TABLE))
        h.seed(CODE_BASE + pool + 16, struct.pack('<I', 3))
        h.seed(TABLE, _char_table(*CHAR_POOL))
        h.seed(RAMBYTE, bytes([idx, 0, 0, 0]) + struct.pack('<II', last_unit, last_clock))
        h.seed(CLOCK, struct.pack('<I', clock))
        char = bytearray(8)
        struct.pack_into('<H', char, 0, CHAR_NAME)
        unit = bytearray(8)
        struct.pack_into('<I', unit, 0, CHAR)
        h.seed(CHAR, bytes(char))
        h.seed(UNIT, bytes(unit))
        regs = h.run(
            off['IdentityNameIdDone'],
            regs={'r0': UNIT},
            entry_offset=off['IdentityNameId'],
        )
        return regs['r0']

    def test_skill_rolls_name(self):
        try:
            assemble(IDENTITY)
        except Exception as extra:
            raise unittest.SkipTest(f'thumb harness unavailable: {extra}')
        # Harness stubs every trampoline to 1, so NextRN_N yields Zeke.
        self.assertEqual(self._run(True), NAME_ZEKE)

    def test_no_skill_keeps_character_name(self):
        try:
            assemble(IDENTITY)
        except Exception as extra:
            raise unittest.SkipTest(f'thumb harness unavailable: {extra}')
        self.assertEqual(self._run(False, 1), CHAR_NAME)

    def test_trv_hook_resumes_after_getstring(self):
        text = IDENTITY.read_text(encoding='utf-8')
        self.assertIn('IdentityName_18CD4, 0x08018CE9', text)
        self.assertNotIn('0x08018CDD', text)
        self.assertIn('IdentityName_85134, 0x0808513D, r8', text)
        self.assertIn('IdentityName_86CB4, 0x08086CBD, r4', text)

    def test_same_frame_keeps_combo(self):
        try:
            assemble(IDENTITY)
        except Exception as extra:
            raise unittest.SkipTest(f'thumb harness unavailable: {extra}')
        self.assertEqual(
            self._run(True, idx=3, last_unit=UNIT, last_clock=0, clock=0),
            NAME_SIRIUS,
        )

    def test_new_frame_rerolls(self):
        try:
            assemble(IDENTITY)
        except Exception as extra:
            raise unittest.SkipTest(f'thumb harness unavailable: {extra}')
        self.assertEqual(
            self._run(True, idx=3, last_unit=UNIT, last_clock=0, clock=2),
            NAME_ZEKE,
        )


class SaviorExecutionTests(unittest.TestCase):
    """HalveIfRescuing calls SkillTester via bl+bx, not a lone 0xF800.

    The harness F800 patch would hide a broken trampoline, so these tests map a
    real Thumb stub at the POIN and let the routine bx to it.
    """

    STUB = 0x02010000

    def _run(self, present, rescuing, stat=10):
        raw = bytearray(assemble(SAVIOR))
        off = symbol_offsets(SAVIOR)
        need = off['SkillTester'] + 8
        if len(raw) < need:
            raw.extend(b'\x00' * (need - len(raw)))
        struct.pack_into('<I', raw, off['SkillTester'], self.STUB | 1)
        struct.pack_into('<I', raw, off['SkillTester'] + 4, 164)
        h = Harness(bytes(raw))
        stub = bytes.fromhex('01207047' if present else '00207047')
        h.seed(self.STUB, stub)
        unit = bytearray(0x10)
        if rescuing:
            struct.pack_into('<I', unit, 0xC, 0x10)
        h.seed(UNIT, bytes(unit))
        regs = h.run(
            off['HalveIfRescuingDone'],
            regs={'r0': stat, 'r1': UNIT},
            entry_offset=off['HalveIfRescuing'],
        )
        return regs['r0']

    def test_call_is_bl_bx_not_f800(self):
        text = SAVIOR.read_text(encoding='utf-8')
        self.assertIn('bl CallTester', text)
        self.assertNotIn('\t.short 0xf800', text)
        self.assertNotIn('\t.short 0xF800', text)

    def test_savior_skips_rescue_half(self):
        try:
            assemble(SAVIOR)
        except Exception as extra:
            raise unittest.SkipTest(f'thumb harness unavailable: {extra}')
        self.assertEqual(self._run(True, True), 10)

    def test_no_skill_halves_while_rescuing(self):
        try:
            assemble(SAVIOR)
        except Exception as extra:
            raise unittest.SkipTest(f'thumb harness unavailable: {extra}')
        self.assertEqual(self._run(False, True), 5)

    def test_not_rescuing_keeps_stat(self):
        try:
            assemble(SAVIOR)
        except Exception as extra:
            raise unittest.SkipTest(f'thumb harness unavailable: {extra}')
        self.assertEqual(self._run(False, False), 10)


@unittest.skipUnless(HACK.exists(), 'FE7_Hack.gba missing')
class SaviorRomExecutionTests(unittest.TestCase):
    """Walk the built GetUnitSkill chain and run HalveIfRescuing off the ROM."""

    GET_SKL = 0x18AF0
    STUB = 0x02010000
    SIG = bytes.fromhex('30b5041c0d1ce8681021')

    @classmethod
    def setUpClass(cls):
        try:
            from Tools.thumb_harness import Harness  # noqa: F401
        except ImportError as extra:
            raise unittest.SkipTest(f'thumb harness unavailable: {extra}')
        cls.rom = HACK.read_bytes()
        if cls.rom[cls.GET_SKL: cls.GET_SKL + 4] != bytes.fromhex('004b1847'):
            raise unittest.SkipTest('GetUnitSkill is not hooked')

    def _routine(self) -> bytes:
        getter = struct.unpack_from('<I', self.rom, self.GET_SKL + 4)[0]
        goff = (getter & ~1) - 0x08000000
        mods = struct.unpack_from('<I', self.rom, goff + 24)[0]
        cursor = (mods & ~1) - 0x08000000
        while True:
            ptr = struct.unpack_from('<I', self.rom, cursor)[0]
            if ptr == 0:
                break
            off = (ptr & ~1) - 0x08000000
            body = self.rom[off: off + 64]
            if body.startswith(self.SIG):
                end = body.find(bytes.fromhex('a4000000'))
                if end < 4:
                    raise AssertionError('SaviorID word missing from HalveIfRescuing')
                return bytearray(body[: end + 4])
            cursor += 4
        raise AssertionError('HalveIfRescuing not in the Skill modifier chain')

    def _run(self, present: bool, rescuing: bool, stat: int = 10) -> int:
        from Tools.thumb_harness import Harness

        body = self._routine()
        done = body.find(bytes.fromhex('201c30bc'))
        if done < 0:
            raise AssertionError('HalveIfRescuingDone (mov r0,r4; pop) missing')
        struct.pack_into('<I', body, len(body) - 8, self.STUB | 1)
        h = Harness(bytes(body))
        h.seed(self.STUB, bytes.fromhex('01207047' if present else '00207047'))
        unit = bytearray(0x10)
        if rescuing:
            struct.pack_into('<I', unit, 0xC, 0x10)
        h.seed(UNIT, bytes(unit))
        regs = h.run(done + 2, regs={'r0': stat, 'r1': UNIT})
        return regs['r0']

    def test_rom_savior_skips_rescue_half(self):
        self.assertEqual(self._run(True, True), 10)

    def test_rom_no_skill_halves_while_rescuing(self):
        self.assertEqual(self._run(False, True), 5)


class SaviorStatArrowTests(unittest.TestCase):
    """DrawBar prints r3 as the big number. Rescuing must use the getter so a
    non-Savior half is visible; Savior's unhalved getter is visible the same way.
    """

    RAW = 10
    GETTER = 5

    def _run(self, rescuing):
        raw = assemble(ADJUST)
        off = symbol_offsets(ADJUST)
        h = Harness(raw)
        unit = bytearray(0x20)
        if rescuing:
            struct.pack_into('<I', unit, 0xC, 0x10)
        unit[0x15] = self.RAW
        h.seed(UNIT, bytes(unit))
        regs = h.run(
            off['AdjustBarBaseDone'],
            regs={'r0': self.GETTER, 'r1': UNIT, 'r2': 0x15},
            entry_offset=off['AdjustBarBaseForSavior'],
        )
        return regs['r0'], regs['r3']

    def test_mss_skl_spd_bars_call_adjust(self):
        text = MSS_DEFS.read_text(encoding='utf-8')
        self.assertIn('AdjustBarBaseForSavior', text)
        self.assertGreaterEqual(text.count('AdjustBarBaseForSavior'), 2)

    def test_rescuing_uses_getter_as_base(self):
        try:
            assemble(ADJUST)
        except Exception as extra:
            raise unittest.SkipTest(f'thumb harness unavailable: {extra}')
        total, base = self._run(True)
        self.assertEqual(total, self.GETTER)
        self.assertEqual(base, self.GETTER)

    def test_not_rescuing_keeps_raw_base(self):
        try:
            assemble(ADJUST)
        except Exception as extra:
            raise unittest.SkipTest(f'thumb harness unavailable: {extra}')
        total, base = self._run(False)
        self.assertEqual(total, self.GETTER)
        self.assertEqual(base, self.RAW)


class RescueMinusHideTests(unittest.TestCase):
    """Rescue half is the getter. Hiding every minus while rescuing also hid
    the non-Savior penalty. DrawSignedBonusNumber must print negatives again.
    """

    def test_does_not_skip_minus_while_rescuing(self):
        text = SBN.read_text(encoding='utf-8')
        self.assertNotIn('SBN_RescueHidesMinus', text)


class SkipRescueArrowSpriteTests(unittest.TestCase):
    """Page-0 OBJ arrows at 0x08080F90. Savior resumes past them, still at Trv."""

    STUB = 0x02010000
    DRAW = 0x08080F91
    SKIP = 0x08080FA5
    NONE = 0x08080FD1

    def _run(self, present, rescuing):
        raw = bytearray(assemble(SKIP_ARROWS))
        off = symbol_offsets(SKIP_ARROWS)
        need = off['SkillTester'] + 8
        if len(raw) < need:
            raw.extend(b'\x00' * (need - len(raw)))
        struct.pack_into('<I', raw, off['SkillTester'], self.STUB | 1)
        struct.pack_into('<I', raw, off['SkillTester'] + 4, 164)
        h = Harness(bytes(raw))
        h.seed(self.STUB, bytes.fromhex('01207047' if present else '00207047'))
        ss = 0x0200310C
        unit = bytearray(0x10)
        if rescuing:
            struct.pack_into('<I', unit, 0xC, 0x10)
        h.seed(UNIT, bytes(unit))
        h.seed(ss + 0xC, struct.pack('<I', UNIT))
        regs = h.run(
            off['SkipRescueArrowsDone'],
            regs={'r4': ss},
            entry_offset=off['SkipRescueArrowsIfSavior'],
        )
        return regs['r0']

    def test_savior_rescuing_skips_arrow_sprites(self):
        try:
            assemble(SKIP_ARROWS)
        except Exception as extra:
            raise unittest.SkipTest(f'thumb harness unavailable: {extra}')
        self.assertEqual(self._run(True, True), self.SKIP)

    def test_no_skill_rescuing_keeps_arrow_sprites(self):
        try:
            assemble(SKIP_ARROWS)
        except Exception as extra:
            raise unittest.SkipTest(f'thumb harness unavailable: {extra}')
        self.assertEqual(self._run(False, True), self.DRAW)

    def test_not_rescuing_skips_arrow_block(self):
        try:
            assemble(SKIP_ARROWS)
        except Exception as extra:
            raise unittest.SkipTest(f'thumb harness unavailable: {extra}')
        self.assertEqual(self._run(True, False), self.NONE)


class RallyChaosSourceTests(unittest.TestCase):
    def test_is_always_applicable(self):
        text = RALLYCHAOS.read_text(encoding='utf-8')
        self.assertIn('mov r0, #1', text)
        self.assertIn('RallyCommandEffect_apply', text)
        self.assertNotIn('bl StartBuffFx', text)
        self.assertNotIn('bl GetUnitsInRange', text)


class RallyChaosExecutionTests(unittest.TestCase):
    """RallyChaosFunc: random bit on self and same-faction units within range 2.

    NextRN_N / GetUnit are blh (0xF800). RallyCommandEffect_apply is stubbed
    to OR r1 into unit+0x30 so the test can see who was buffed.
    """

    GET_UNIT = 0x08018D0D
    NEXT_RN = 0x08000E31
    APPLY = 0x0800F001
    STOP = 0x08FFFFF0
    SP = 0x03007F00
    UNIT_STRIDE = 0x48
    UNITS = 0x02010000
    CHAR = 0x02018000

    @classmethod
    def setUpClass(cls):
        try:
            from unicorn import Uc, UC_ARCH_ARM, UC_HOOK_CODE, UC_MODE_THUMB
            from unicorn.arm_const import (
                UC_ARM_REG_LR,
                UC_ARM_REG_PC,
                UC_ARM_REG_R0,
                UC_ARM_REG_R1,
                UC_ARM_REG_SP,
            )
        except ImportError as exc:
            raise unittest.SkipTest(f"unicorn unavailable: {exc}") from exc
        cls.Uc = Uc
        cls.UC_ARCH_ARM = UC_ARCH_ARM
        cls.UC_HOOK_CODE = UC_HOOK_CODE
        cls.UC_MODE_THUMB = UC_MODE_THUMB
        cls.UC_ARM_REG_LR = UC_ARM_REG_LR
        cls.UC_ARM_REG_PC = UC_ARM_REG_PC
        cls.UC_ARM_REG_R0 = UC_ARM_REG_R0
        cls.UC_ARM_REG_R1 = UC_ARM_REG_R1
        cls.UC_ARM_REG_SP = UC_ARM_REG_SP
        try:
            with tempfile.TemporaryDirectory() as tmp:
                src = Path(tmp) / "RallyChaos_test.s"
                text = RALLYCHAOS.read_text(encoding="utf-8").replace(
                    "bl RallyCommandEffect_apply",
                    "blh 0x0800F001",
                )
                src.write_text(text, encoding="utf-8")
                cls.code = assemble(src)
                cls.offs = symbol_offsets(src)
        except Exception as extra:
            raise unittest.SkipTest(f"thumb harness unavailable: {extra}") from extra

    def _unit(self, uid: int) -> int:
        return self.UNITS + uid * self.UNIT_STRIDE

    def _run(self, rn: int, caster: int, units: dict) -> dict:
        from unicorn import UcError

        uc = self.Uc(self.UC_ARCH_ARM, self.UC_MODE_THUMB)
        uc.mem_map(CODE_BASE, (len(self.code) + 0xFFF) & ~0xFFF)
        uc.mem_write(CODE_BASE, self.code)
        uc.mem_map(0x02000000, 0x20000)
        uc.mem_map(0x03000000, 0x10000)
        uc.mem_write(self.CHAR, b"\x01" * 8)
        lookup = {}
        for uid, spec in units.items():
            addr = self._unit(uid)
            buf = bytearray(self.UNIT_STRIDE)
            struct.pack_into("<I", buf, 0, self.CHAR)
            buf[0x0B] = uid
            struct.pack_into("<I", buf, 0xC, spec.get("state", 0))
            buf[0x10] = spec["x"]
            buf[0x11] = spec["y"]
            buf[0x30] = 0
            uc.mem_write(addr, bytes(buf))
            lookup[uid] = addr

        def on_code(uc_, addr, _size, _user_data):
            if struct.unpack("<H", bytes(uc_.mem_read(addr, 2)))[0] != 0xF800:
                return
            target = uc_.reg_read(self.UC_ARM_REG_LR) & ~1
            if target == (self.NEXT_RN & ~1):
                uc_.reg_write(self.UC_ARM_REG_R0, rn)
            elif target == (self.GET_UNIT & ~1):
                uid = uc_.reg_read(self.UC_ARM_REG_R0) & 0xFF
                uc_.reg_write(self.UC_ARM_REG_R0, lookup.get(uid, 0))
            elif target == (self.APPLY & ~1):
                unit = uc_.reg_read(self.UC_ARM_REG_R0)
                bit = uc_.reg_read(self.UC_ARM_REG_R1) & 0xFF
                cur = uc_.mem_read(unit + 0x30, 1)[0]
                uc_.mem_write(unit + 0x30, bytes([cur | bit]))
            else:
                raise AssertionError(f"unexpected blh {target:08X}")
            ret = (addr + 2) | 1
            uc_.reg_write(self.UC_ARM_REG_LR, ret)
            uc_.reg_write(self.UC_ARM_REG_PC, ret)

        uc.hook_add(self.UC_HOOK_CODE, on_code)
        uc.reg_write(self.UC_ARM_REG_SP, self.SP)
        uc.reg_write(self.UC_ARM_REG_LR, self.STOP | 1)
        uc.reg_write(self.UC_ARM_REG_R0, self._unit(caster))
        try:
            uc.emu_start(
                (CODE_BASE + self.offs["RallyChaosFunc"]) | 1,
                self.STOP,
                timeout=10_000_000,
                count=2_000_000,
            )
        except UcError as exc:
            pc = uc.reg_read(self.UC_ARM_REG_PC)
            raise AssertionError(f"Unicorn fault at {pc:08X}: {exc}") from exc
        out = {}
        for uid in units:
            out[uid] = uc.mem_read(self._unit(uid) + 0x30, 1)[0]
        return out

    def test_applies_to_self_and_ally_at_range_2(self):
        got = self._run(
            0,
            1,
            {
                1: {"x": 5, "y": 5},
                2: {"x": 5, "y": 7},
                3: {"x": 5, "y": 8},
                4: {"x": 6, "y": 5, "state": 0x04},
                0x80: {"x": 5, "y": 6},
            },
        )
        self.assertEqual(got[1], 1)
        self.assertEqual(got[2], 1)
        self.assertEqual(got[3], 0)
        self.assertEqual(got[4], 0)
        self.assertEqual(got[0x80], 0)

    def test_rn_3_writes_bit_8(self):
        got = self._run(3, 1, {1: {"x": 1, "y": 1}})
        self.assertEqual(got[1], 8)


class IdentityMugExecutionTests(unittest.TestCase):
    def _run_face(self, testers, entry, mini=0, portrait=0x0042, idx=0,
                  last_unit=0, last_clock=0, clock=0):
        raw = assemble(PORTRAIT)
        off = symbol_offsets(PORTRAIT)
        h = Harness(_patch_testers(raw, testers))
        pool = off['SkillTester']
        h.seed(CODE_BASE + pool + 12, struct.pack('<I', RAMBYTE))
        h.seed(CODE_BASE + pool + 16, struct.pack('<I', MUGS))
        h.seed(CODE_BASE + pool + 20, struct.pack('<I', MUGS))
        h.seed(CODE_BASE + pool + 24, struct.pack('<I', TABLE))
        h.seed(CODE_BASE + pool + 28, struct.pack('<I', 3))
        h.seed(MUGS, bytes([0x0C, 0x09, 0x0A, 0x00]))
        h.seed(TABLE, _char_table(*CHAR_POOL))
        h.seed(RAMBYTE, bytes([idx, 0, 0, 0]) + struct.pack('<II', last_unit, last_clock))
        h.seed(CLOCK, struct.pack('<I', clock))
        char = bytearray(12)
        struct.pack_into('<H', char, 6, portrait)
        char[8] = mini
        unit = bytearray(8)
        struct.pack_into('<I', unit, 0, CHAR)
        h.seed(CHAR, bytes(char))
        h.seed(UNIT, bytes(unit))
        regs = h.run(
            off['SummonPortraitGuard_HaveMug'],
            regs={'r0': UNIT},
            entry_offset=off[entry],
        )
        return regs['r0']

    def test_identity_rolls_mug(self):
        try:
            assemble(PORTRAIT)
        except Exception as extra:
            raise unittest.SkipTest(f'thumb harness unavailable: {extra}')
        self.assertEqual(
            self._run_face([0, 1, 1], 'SummonPortraitGuard'),
            0x0C,
        )

    def _run_mini(self, testers, mini, portrait, idx=1, last_unit=0,
                  last_clock=0, clock=0):
        return self._run_face(
            testers, 'SummonMiniPortraitGuard', mini=mini, portrait=portrait,
            idx=idx, last_unit=last_unit, last_clock=last_clock, clock=clock,
        )

    def test_identity_mini_rolls_mug(self):
        try:
            assemble(PORTRAIT)
        except Exception as extra:
            raise unittest.SkipTest(f'thumb harness unavailable: {extra}')
        self.assertEqual(self._run_mini([0, 1, 1], mini=0x06, portrait=0x0042), 0x0C)

    def test_same_frame_keeps_mug(self):
        try:
            assemble(PORTRAIT)
        except Exception as extra:
            raise unittest.SkipTest(f'thumb harness unavailable: {extra}')
        self.assertEqual(
            self._run_face(
                [0, 1], 'SummonPortraitGuard', idx=3,
                last_unit=UNIT, last_clock=0, clock=0,
            ),
            0x09,
        )

    def test_new_frame_rerolls_mug(self):
        try:
            assemble(PORTRAIT)
        except Exception as extra:
            raise unittest.SkipTest(f'thumb harness unavailable: {extra}')
        self.assertEqual(
            self._run_face(
                [0, 1, 1], 'SummonPortraitGuard', idx=3,
                last_unit=UNIT, last_clock=0, clock=2,
            ),
            0x0C,
        )

    def test_no_skill_mini_uses_dedicated_index(self):
        try:
            assemble(PORTRAIT)
        except Exception as extra:
            raise unittest.SkipTest(f'thumb harness unavailable: {extra}')
        self.assertEqual(self._run_mini([0, 0], mini=0x06, portrait=0x0042), 0x7F06)

    def test_no_skill_mini_falls_back_to_portrait(self):
        try:
            assemble(PORTRAIT)
        except Exception as extra:
            raise unittest.SkipTest(f'thumb harness unavailable: {extra}')
        self.assertEqual(self._run_mini([0, 0], mini=0, portrait=0x0042), 0x42)


class BoonExecutionTests(unittest.TestCase):
    """Hook at TickActiveFactionTurn 0x08018390 (r4=unit, r3=&status, r2=byte)."""

    def _run(self, present: bool, status: int, state: int = 0) -> tuple:
        try:
            raw = assemble(BOON)
        except Exception as extra:
            raise unittest.SkipTest(f"thumb harness unavailable: {extra}")
        off = symbol_offsets(BOON)
        h = Harness(raw, skill_present=present)
        unit = bytearray(0x48)
        struct.pack_into("<I", unit, 0, CHAR)
        struct.pack_into("<I", unit, 0xC, state)
        unit[0x30] = status
        h.seed(CHAR, b"\x01" * 8)
        h.seed(UNIT, bytes(unit))
        h.run(
            off["BoonDone"],
            regs={
                "r2": status,
                "r3": UNIT + 0x30,
                "r4": UNIT,
                "r6": 0xF0,
            },
        )
        return h.read(UNIT + 0x30, 1)[0], struct.unpack(
            "<I", h.read(UNIT + 0xC, 4)
        )[0]

    def test_clears_poison_duration(self):
        status, _ = self._run(True, 0x31)
        self.assertEqual(status, 0x01)

    def test_no_skill_ticks_poison(self):
        status, _ = self._run(False, 0x31)
        self.assertEqual(status, 0x21)

    def test_petrify_zeros_duration_and_state_bit(self):
        status, state = self._run(True, 0x2B, state=2)
        self.assertEqual(status, 0x0B)
        self.assertEqual(state, 0)


@unittest.skipUnless(HACK.exists(), 'FE7_Hack.gba missing')
class StandaloneRomTests(unittest.TestCase):
    def test_vantage_hook_at_29028(self):
        rom = HACK.read_bytes()
        self.assertEqual(rom[0x29028:0x2902C], JUMP)

    def test_livetoserve_extra_round_hooks(self):
        """Both arms of the plain (non-HPSTEAL) round builder are hooked."""
        rom = HACK.read_bytes()
        for off in (0x5314C, 0x531B0):
            self.assertEqual(rom[off:off + 4], JUMP, f"no hook at {off:X}")

    def test_livetoserve_leaves_the_hpsteal_arms_vanilla(self):
        """HPSTEAL is unused here, so Nosferatu's drain must stay untouched."""
        rom = HACK.read_bytes()
        for off in (0x5304C, 0x53078, 0x530B0, 0x530D8):
            self.assertNotEqual(rom[off:off + 4], JUMP, f"hook at {off:X}")

    def test_livetoserve_leaves_the_bar_procs_vanilla(self):
        """The Live tick, its proc-script entry and the bar parent stay stock."""
        rom = HACK.read_bytes()
        self.assertNotEqual(rom[0x4DD8C:0x4DD90], JUMP)
        self.assertNotEqual(rom[0x4D62C:0x4D630], JUMP)
        self.assertEqual(rom[0xB9AC58:0xB9AC5C], bytes.fromhex("71dd0408"))

    def test_shrewd_and_cunning_hooks(self):
        rom = HACK.read_bytes()
        self.assertEqual(rom[0x2CD60:0x2CD64], JUMP)
        self.assertEqual(rom[0x27594:0x27598], JUMP)
        self.assertEqual(rom[0x175BC:0x175C0], JUMP)

    def test_identity_name_hooks(self):
        rom = HACK.read_bytes()
        self.assertEqual(rom[0xA8AC:0xA8B0], JUMP)
        self.assertEqual(rom[0x23078:0x2307C], JUMP)
        self.assertEqual(rom[0x7FA98:0x7FA9C], JUMP)
        self.assertEqual(rom[0x94508:0x9450C], JUMP)
        self.assertEqual(rom[0x18BF4:0x18C04], rom[0x18BD8:0x18BE8])
        self.assertNotEqual(rom[0x18C04:0x18C08], rom[0x18BE8:0x18BEC])
        self.assertEqual(rom[0x85134:0x85138], JUMP)
        self.assertEqual(rom[0x86CB4:0x86CB8], JUMP)

    def test_boon_hooks_status_tick_at_18390(self):
        rom = HACK.read_bytes()
        self.assertEqual(rom[0x18390:0x18394], bytes.fromhex("00488746"))


GET_UNIT = 0x08018D0D
ADD_HP = 0x08018C7D
CUR_HP = 0x08018A71
MAX_HP = 0x08018AB1
VANILLA_AFTER = 0x0802C36C
VANILLA_EPI = 0x0802C38E
HIT_ITER = 0x0203A50C
HIT_BUF = 0x0203F000
ACTION = 0x0203A85C
HEALER_U = 0x02010000
TARGET_U = 0x02010048
LTS_SP = 0x03007F00
LTS_STOP = 0x08FFFFF0
HPSTEAL = 0x100
ABSADD_ABS = (
    ROOT
    / "EngineHacks"
    / "SkillSystem"
    / "Skills"
    / "StandaloneSkills"
    / "LiveToServe"
    / "LiveToServeHpAbsAdd.s"
)
HPBAR_ABS = (
    ROOT
    / "EngineHacks"
    / "SkillSystem"
    / "Skills"
    / "StandaloneSkills"
    / "LiveToServe"
    / "LiveToServeHpBar.s"
)
GET_ANIM = 0x08054679
DISP_HP = 0x0203E0B8
LTS_PROC = 0x02001000
LTS_AIS = 0x02002000


STAFF_HEAL_HOOK = 0x0802C360
STAFF_HEAL_END = 0x0802C38E  # VanillaEpilogue
UNIT_LOOKUP = 0x08B92EB0
GET_CUR_HP = 0x08018A70  # repointed by the SkillSystem to its stat getters
CLASS_ID_GETTER = 0x08016764
CLASS_HP_GETTER = 0x08016040
HEALER_U2, TARGET_U2 = 0x02010000, 0x02010100
HEALER_ID, TARGET_ID = 1, 2
HEAL_FLAG = 0x0203AA02
STUB_MAX_HP = 30


class LiveToServeExecutionTests(unittest.TestCase):
    """Run the installed staff-heal hack out of FE7_Hack.gba.

    This executes the ROM's own AddUnitHp rather than a stub, so a wrong
    function address or a wrong unit-struct offset fails here. GetUnit and
    AddUnitHp are real; only SkillTester (needs the skill tables),
    GetUnitCurrentHp (the SkillSystem repoints it at its stat-getter chain)
    and AddUnitHp's two class-data getters are emulated.

    Per tdd.md this does not test which unit owns the skill -- SkillTester's
    answer is a parameter here, both ways.
    """

    @classmethod
    def setUpClass(cls):
        if not HACK.exists():
            raise unittest.SkipTest("FE7_Hack.gba not built")
        try:
            from unicorn import Uc, UC_ARCH_ARM, UC_HOOK_CODE, UC_MODE_THUMB
            from unicorn.arm_const import UC_ARM_REG_PC
        except ImportError as extra:
            raise unittest.SkipTest(f"unicorn unavailable: {extra}") from extra
        cls.Uc, cls.UC_ARCH_ARM = Uc, UC_ARCH_ARM
        cls.UC_HOOK_CODE, cls.UC_MODE_THUMB = UC_HOOK_CODE, UC_MODE_THUMB
        cls.UC_ARM_REG_PC = UC_ARM_REG_PC
        cls.rom = HACK.read_bytes()
        # Follow the jumpToHack POIN at the staff-heal site to the hack, then
        # take the one expanded-ROM word in its literal pool: SkillTester.
        # Derived, not hardcoded, so editing LiveToServe.s cannot stale it.
        hack = struct.unpack_from("<I", cls.rom, STAFF_HEAL_HOOK - 0x08000000 + 4)[0]
        base = (hack & ~1) - 0x08000000
        cls.skilltester = None
        for off in range(base, base + 0x200, 4):
            word = struct.unpack_from("<I", cls.rom, off)[0]
            if 0x09000000 <= word < 0x0A000000:
                cls.skilltester = word & ~1
                break
        if cls.skilltester is None:
            raise AssertionError("no SkillTester pointer in the LiveToServe pool")

    def _run(self, present, heal, t_cur, h_cur):
        from unicorn import UcError
        from unicorn.arm_const import (
            UC_ARM_REG_LR, UC_ARM_REG_R0, UC_ARM_REG_R4, UC_ARM_REG_R5,
            UC_ARM_REG_R6, UC_ARM_REG_SP,
        )

        uc = self.Uc(self.UC_ARCH_ARM, self.UC_MODE_THUMB)
        uc.mem_map(0x08000000, (len(self.rom) + 0xFFF) & ~0xFFF)
        uc.mem_write(0x08000000, self.rom)
        uc.mem_map(0x02000000, 0x80000)
        uc.mem_map(0x03000000, 0x10000)

        uc.mem_write(CLASS_ID_GETTER, bytes.fromhex("00207047"))
        uc.mem_write(CLASS_HP_GETTER, bytes([STUB_MAX_HP, 0x20, 0x70, 0x47]))

        for base, cur in ((HEALER_U2, h_cur), (TARGET_U2, t_cur)):
            u = bytearray(0x48)
            u[0x12] = 0      # max-HP bonus; STUB_MAX_HP supplies the rest
            u[0x13] = cur
            uc.mem_write(base, bytes(u))
        uc.mem_write(UNIT_LOOKUP + HEALER_ID * 4, struct.pack("<I", HEALER_U2))
        uc.mem_write(UNIT_LOOKUP + TARGET_ID * 4, struct.pack("<I", TARGET_U2))

        # BattleInitItemEffect(Target) snapshots both units before the heal.
        uc.mem_write(ATTACKER, bytes(0x80))
        uc.mem_write(DEFENDER, bytes(0x80))
        uc.mem_write(ATTACKER + 0x13, bytes([h_cur]))
        uc.mem_write(DEFENDER + 0x13, bytes([t_cur]))

        act = bytearray(0x20)
        act[0x0C] = HEALER_ID
        act[0x0D] = TARGET_ID
        uc.mem_write(ACTION, bytes(act))
        uc.mem_write(HIT_ITER, struct.pack("<I", HIT_BUF))
        uc.mem_write(HIT_BUF, b"\x00" * 8)

        skill = 1 if present else 0

        def on_code(uc_, addr, _size, _ud):
            if addr == GET_CUR_HP:
                unit = uc_.reg_read(UC_ARM_REG_R0)
                uc_.reg_write(UC_ARM_REG_R0, uc_.mem_read(unit + 0x13, 1)[0])
                uc_.reg_write(self.UC_ARM_REG_PC, uc_.reg_read(UC_ARM_REG_LR) | 1)
                return
            if addr == self.skilltester:
                uc_.reg_write(UC_ARM_REG_R0, skill)
                uc_.reg_write(self.UC_ARM_REG_PC, uc_.reg_read(UC_ARM_REG_LR) | 1)
                return
            # `.short 0xf800` is the repo's blh trampoline: a lone BL low half,
            # so PC = LR. Unicorn decodes it as 32-bit Thumb-2, so do it here.
            if struct.unpack("<H", bytes(uc_.mem_read(addr, 2)))[0] == 0xF800:
                dest = uc_.reg_read(UC_ARM_REG_LR) | 1
                uc_.reg_write(UC_ARM_REG_LR, (addr + 2) | 1)
                uc_.reg_write(self.UC_ARM_REG_PC, dest)

        uc.hook_add(self.UC_HOOK_CODE, on_code)
        uc.reg_write(UC_ARM_REG_SP, LTS_SP)
        uc.reg_write(UC_ARM_REG_LR, LTS_STOP | 1)
        uc.reg_write(UC_ARM_REG_R4, ACTION)
        uc.reg_write(UC_ARM_REG_R5, heal)
        uc.reg_write(UC_ARM_REG_R6, 0xAABBCCDD)
        try:
            uc.emu_start(STAFF_HEAL_HOOK | 1, STAFF_HEAL_END,
                         timeout=10_000_000, count=2_000_000)
        except UcError as extra:
            pc = uc.reg_read(self.UC_ARM_REG_PC)
            raise AssertionError(f"Unicorn fault at {pc:08X}: {extra}") from extra
        hit = bytes(uc.mem_read(HIT_BUF, 8))
        return {
            "healer": uc.mem_read(HEALER_U2 + 0x13, 1)[0],
            "target": uc.mem_read(TARGET_U2 + 0x13, 1)[0],
            "actor_hp": uc.mem_read(ATTACKER + 0x13, 1)[0],
            "target_hp": uc.mem_read(DEFENDER + 0x13, 1)[0],
            "hp_change": struct.unpack("b", hit[3:4])[0],
            "next_byte": hit[5],
            "attrs": struct.unpack("<I", hit[:4])[0],
            "flag": uc.mem_read(HEAL_FLAG, 1)[0],
            "r6": uc.reg_read(UC_ARM_REG_R6),
            "pc": uc.reg_read(self.UC_ARM_REG_PC) & ~1,
        }

    def test_eliwood_6_sain_9_heal_10(self):
        got = self._run(True, 10, t_cur=9, h_cur=6)
        self.assertEqual(got["target"], 19)
        self.assertEqual(got["healer"], 16)
        self.assertEqual(got["hp_change"], -10)
        self.assertEqual(got["flag"], 10)
        self.assertEqual(got["actor_hp"], 16)
        self.assertEqual(got["target_hp"], 19)
        self.assertEqual(got["attrs"] & HPSTEAL, 0, "HPSTEAL drains real HP")
        self.assertEqual(got["next_byte"], 0, "FE7 hits are 4 bytes")
        self.assertEqual(got["r6"], 0xAABBCCDD, "r6 must reach the epilogue")

    def test_no_skill_heals_target_only(self):
        got = self._run(False, 10, t_cur=9, h_cur=6)
        self.assertEqual(got["target"], 19)
        self.assertEqual(got["healer"], 6)
        self.assertEqual(got["hp_change"], -10)
        self.assertEqual(got["flag"], 0)

    def test_overheal_is_clamped_by_add_unit_hp(self):
        """The heal is not pre-capped; AddUnitHp clamps each unit itself."""
        got = self._run(True, 10, t_cur=28, h_cur=25)
        self.assertEqual(got["target"], STUB_MAX_HP)
        self.assertEqual(got["healer"], STUB_MAX_HP)
        self.assertEqual(got["hp_change"], -2, "hpChange is the real delta")
        self.assertEqual(got["flag"], 5, "the healer's own real gain")

    def test_healer_never_loses_hp(self):
        for heal in (1, 5, 10, 30):
            with self.subTest(heal=heal):
                got = self._run(True, heal, t_cur=9, h_cur=6)
                self.assertGreaterEqual(got["healer"], 6)
                self.assertGreaterEqual(got["target"], 9)


ROUND_PATH_A = 0x0805311C  # recipient is position 1, so the healer is position 0
ROUND_PATH_B = 0x0805318C  # recipient is position 0, so the healer is position 1
ROUND_END = 0x080531E6
HEAL_FLAG = 0x0203AA02
# The LUT base is read out of the ROM, not hardcoded: the build relocates it
# from vanilla 0x0203E062 to make room for more rounds.
LUT_POOL = 0x53350  # GetHpRound's own literal pool
MAX_HP_POOL = 0x530A4  # the max-HP pair the stealer cap loads
SCRATCH = 0x02030000


class LiveToServeHpRoundTests(unittest.TestCase):
    """Run FE7_Hack's own HP-round builder and read the HP-round LUT back.

    The battle-anim HP bars are driven by the LUT at `LUT_POOL`'s address:
    the bar ctor 0x0804D5A4 spawns a bar for a position only when that
    position's round and round+1 differ, and the tick then walks
    0x0203E0B8[position] between them. A staff heal writes a single hit, so
    vanilla appends a round for the recipient only and the healer's bar can
    never move. LiveToServe appends the healer's round here.

    These tests execute the ROM bytes at 0x0805311C / 0x0805318C, including
    the two hooks, so they cover the wiring and the arithmetic together.
    Which position the engine gives the recipient is not modelled -- both
    assignments are asserted instead.
    """

    @classmethod
    def setUpClass(cls):
        if not HACK.exists():
            raise unittest.SkipTest("FE7_Hack.gba not built")
        try:
            from unicorn import Uc, UC_ARCH_ARM, UC_MODE_THUMB
            from unicorn.arm_const import UC_ARM_REG_PC
        except ImportError as extra:
            raise unittest.SkipTest(f"unicorn unavailable: {extra}") from extra
        cls.Uc = Uc
        cls.UC_ARCH_ARM = UC_ARCH_ARM
        cls.UC_MODE_THUMB = UC_MODE_THUMB
        cls.UC_ARM_REG_PC = UC_ARM_REG_PC
        cls.rom = HACK.read_bytes()
        cls.lut = struct.unpack_from("<I", cls.rom, LUT_POOL)[0]
        cls.max_hp = struct.unpack_from("<I", cls.rom, MAX_HP_POOL)[0]
        for name, addr in (("LUT", cls.lut), ("max HP", cls.max_hp)):
            if not 0x02000000 <= addr < 0x02040000:
                raise AssertionError(f"{name} pool holds {addr:08X}, not EWRAM")

    def _rounds(self, start, heal, pos0, pos1, max0, max1, flag=None):
        """Return round 1 of the LUT as (position 0 HP, position 1 HP)."""
        from unicorn import UcError
        from unicorn.arm_const import (
            UC_ARM_REG_R4,
            UC_ARM_REG_R5,
            UC_ARM_REG_R7,
            UC_ARM_REG_R8,
            UC_ARM_REG_R9,
            UC_ARM_REG_SP,
        )

        uc = self.Uc(self.UC_ARCH_ARM, self.UC_MODE_THUMB)
        uc.mem_map(0x08000000, (len(self.rom) + 0xFFF) & ~0xFFF)
        uc.mem_write(0x08000000, self.rom)
        uc.mem_map(0x02000000, 0x40000)
        uc.mem_map(0x03000000, 0x10000)

        # A plain staff-heal hit: no attributes, signed hpChange -heal at +3.
        uc.mem_write(HIT_BUF, struct.pack("<HBb", 0x0000, 0x00, -heal))
        # Round 0 is seeded from the on-screen HP by the builder's prologue.
        uc.mem_write(self.lut, struct.pack("<HH", pos0, pos1))
        uc.mem_write(self.max_hp, struct.pack("<HH", max0, max1))
        uc.mem_write(HEAL_FLAG, bytes([heal if flag is None else flag]))

        uc.reg_write(UC_ARM_REG_SP, LTS_SP)
        uc.reg_write(UC_ARM_REG_R4, SCRATCH)
        uc.reg_write(UC_ARM_REG_R5, SCRATCH + 4)
        uc.reg_write(UC_ARM_REG_R7, 0)  # position 0 round counter
        uc.reg_write(UC_ARM_REG_R8, 0)  # position 1 round counter
        uc.reg_write(UC_ARM_REG_R9, HIT_BUF)
        try:
            uc.emu_start(start | 1, ROUND_END, timeout=10_000_000, count=200_000)
        except UcError as extra:
            pc = uc.reg_read(self.UC_ARM_REG_PC)
            raise AssertionError(f"Unicorn fault at {pc:08X}: {extra}") from extra
        lut = bytes(uc.mem_read(self.lut, 8))
        self.flag_after = uc.mem_read(HEAL_FLAG, 1)[0]
        # halfword[round * 2 + position], masked the way GetHpRound masks it.
        return (
            struct.unpack_from("<H", lut, 4)[0] & 0xFFF,
            struct.unpack_from("<H", lut, 6)[0] & 0xFFF,
        )

    def test_eliwood_6_sain_9_heal_10_both_sides_get_a_round(self):
        # path A: recipient Sain at position 1, healer Eliwood at position 0
        got = self._rounds(ROUND_PATH_A, 10, pos0=6, pos1=9, max0=18, max1=19)
        self.assertEqual(got, (16, 19))
        # path B: the same pair with the positions swapped
        got = self._rounds(ROUND_PATH_B, 10, pos0=9, pos1=6, max0=19, max1=18)
        self.assertEqual(got, (19, 16))

    def test_the_flag_is_consumed(self):
        self._rounds(ROUND_PATH_A, 10, pos0=6, pos1=9, max0=18, max1=19)
        self.assertEqual(self.flag_after, 0)

    def test_no_skill_leaves_the_healer_without_a_round(self):
        """flag 0 is what LiveToServe writes when the healer lacks the skill."""
        got = self._rounds(
            ROUND_PATH_A, 10, pos0=6, pos1=9, max0=18, max1=19, flag=0
        )
        self.assertEqual(got, (0, 19))  # only the recipient's round is written
        got = self._rounds(
            ROUND_PATH_B, 10, pos0=9, pos1=6, max0=19, max1=18, flag=0
        )
        self.assertEqual(got, (19, 0))

    def test_healer_round_is_capped_at_max_hp(self):
        got = self._rounds(ROUND_PATH_A, 10, pos0=15, pos1=9, max0=18, max1=19)
        self.assertEqual(got, (18, 19))
        got = self._rounds(ROUND_PATH_B, 10, pos0=9, pos1=15, max0=19, max1=18)
        self.assertEqual(got, (19, 18))

    def test_healer_never_drains(self):
        for start, heal in ((ROUND_PATH_A, h) for h in (1, 5, 10, 30)):
            with self.subTest(path="A", heal=heal):
                p0, _ = self._rounds(start, heal, 6, 9, 18, 19)
                self.assertGreaterEqual(p0, 6)
        for start, heal in ((ROUND_PATH_B, h) for h in (1, 5, 10, 30)):
            with self.subTest(path="B", heal=heal):
                _, p1 = self._rounds(start, heal, 9, 6, 19, 18)
                self.assertGreaterEqual(p1, 6)


if __name__ == '__main__':
    unittest.main()
