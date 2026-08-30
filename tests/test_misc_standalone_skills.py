"""FE7 wiring for the standalone FE8 skill ports.

Unicorn executes Vantage (HP gate and Vantage+), Discipline (double WEXP),
LockTouch (0xFF), and Biorhythm (Tempest/Serenity/none). SkillTester is
stubbed by the harness; these tests do not assign skills to units.
"""
import re
import struct
import sys
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
        self.assertIn("IdentityProblemsNames", menu)
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
NAMES = 0x02000400
MUGS = 0x02000410
NAME_CAMUS = 0xD53
NAME_ZEKE = 0xD55
NAME_SIRIUS = 0xD54
CHAR_NAME = 0x0123
JUMP = bytes.fromhex('004b1847')


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
    def _run(self, present, idx):
        raw = assemble(IDENTITY)
        off = symbol_offsets(IDENTITY)
        h = Harness(raw, skill_present=present)
        pool = off['SkillTester']
        h.seed(CODE_BASE + pool + 8, struct.pack('<I', RAMBYTE))
        h.seed(CODE_BASE + pool + 12, struct.pack('<I', NAMES))
        h.seed(NAMES, struct.pack('<HHHH', NAME_CAMUS, NAME_ZEKE, NAME_SIRIUS, 0))
        h.seed(RAMBYTE, bytes([idx]))
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

    def test_skill_uses_stored_name(self):
        try:
            assemble(IDENTITY)
        except Exception as extra:
            raise unittest.SkipTest(f'thumb harness unavailable: {extra}')
        self.assertEqual(self._run(True, 0), NAME_CAMUS)
        self.assertEqual(self._run(True, 1), NAME_ZEKE)
        self.assertEqual(self._run(True, 2), NAME_SIRIUS)

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

    def test_skill_uses_index_past_three(self):
        try:
            assemble(IDENTITY)
        except Exception as extra:
            raise unittest.SkipTest(f'thumb harness unavailable: {extra}')
        raw = assemble(IDENTITY)
        off = symbol_offsets(IDENTITY)
        h = Harness(raw, skill_present=True)
        pool = off['SkillTester']
        names = 0x02000400
        extra = 0x0D50
        h.seed(CODE_BASE + pool + 8, struct.pack('<I', RAMBYTE))
        h.seed(CODE_BASE + pool + 12, struct.pack('<I', names))
        h.seed(names, struct.pack('<HHHHH', NAME_CAMUS, NAME_ZEKE, NAME_SIRIUS, extra, 0))
        h.seed(RAMBYTE, bytes([3]))
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
        self.assertEqual(regs['r0'], extra)


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


class IdentityMugExecutionTests(unittest.TestCase):
    def test_identity_uses_stored_mug(self):
        try:
            raw = assemble(PORTRAIT)
        except Exception as extra:
            raise unittest.SkipTest(f'thumb harness unavailable: {extra}')
        off = symbol_offsets(PORTRAIT)
        h = Harness(_patch_testers(raw, [0, 1]))
        pool = off['SkillTester']
        h.seed(CODE_BASE + pool + 12, struct.pack('<I', RAMBYTE))
        h.seed(CODE_BASE + pool + 16, struct.pack('<I', TABLE))
        h.seed(CODE_BASE + pool + 20, struct.pack('<I', MUGS))
        h.seed(MUGS, bytes([0x0C, 0x09, 0x0A, 0x00]))
        h.seed(RAMBYTE, b'\x01')
        char = bytearray(8)
        struct.pack_into('<H', char, 6, 0x0042)
        unit = bytearray(8)
        struct.pack_into('<I', unit, 0, CHAR)
        h.seed(CHAR, bytes(char))
        h.seed(UNIT, bytes(unit))
        regs = h.run(
            off['SummonPortraitGuard_HaveMug'],
            regs={'r0': UNIT},
            entry_offset=off['SummonPortraitGuard'],
        )
        self.assertEqual(regs['r0'], 0x09)


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

    def test_boon_hooks_status_tick_at_18390(self):
        rom = HACK.read_bytes()
        self.assertEqual(rom[0x18390:0x18394], bytes.fromhex("00488746"))


if __name__ == '__main__':
    unittest.main()
