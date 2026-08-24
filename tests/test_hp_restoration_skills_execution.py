"""Execute HP-restoration aura skills under Unicorn.

Amaterasu/Bond call NewAuraSkillCheck; Camaraderie/Relief call SkillTester
then GetUnitsInRange. Each 0xF800 is rewritten to `movs r0, #imm` so both
sides of every branch run. This does not prove in-game skill assignment.
"""
from __future__ import annotations

import re
import struct
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from Tools.thumb_harness import Harness, assemble, symbol_offsets

DEFS = ROOT / "EngineHacks/SkillSystem/skill_definitions.event"
INSTALLER = ROOT / (
    "EngineHacks/SkillSystem/Skills/HPRestorationSkills/HPRestorationSkills.event"
)
LOOP_EVENT = ROOT / (
    "EngineHacks/Necessary/CalcLoops/HPRestorationCalcLoop/"
    "HPRestorationCalcLoop.event"
)
LOOP_S = ROOT / (
    "EngineHacks/Necessary/CalcLoops/HPRestorationCalcLoop/"
    "HPRestorationCalcLoop.s"
)
PREBATTLE = ROOT / (
    "EngineHacks/Necessary/CalcLoops/PreBattleCalcLoop/"
    "PreBattleCalcLoop.event"
)
HP_DIR = ROOT / "EngineHacks/SkillSystem/Skills/HPRestorationSkills"
HACK = ROOT / "FE7_Hack.gba"

HOOK = 0x19B20
JUMP = bytes.fromhex("004b1847")
TERRAIN_TABLE = 0x08BE47C4
UNIT = 0x0203A3F0
BASE_HEAL = 5

AMATERASU_ID = 204
CAMARADERIE_ID = 205
RELIEF_ID = 206
BOND_ID = 207

F800 = bytes.fromhex("00f8")


def _macro(name: str) -> str:
    text = DEFS.read_text(encoding="utf-8")
    match = re.search(rf"^#define {name} (\S+)", text, re.M)
    if match is None:
        raise AssertionError(f"{name} missing")
    return match.group(1)


def _uncommented(path: Path) -> str:
    return re.sub(r"/\*.*?\*/", "", path.read_text(encoding="utf-8"), flags=re.S)


def _patch_returns(code: bytes, values: list[int]) -> bytes:
    buf = bytearray(code)
    found = 0
    idx = 0
    while True:
        idx = bytes(buf).find(F800, idx)
        if idx < 0:
            break
        if idx % 2:
            idx += 1
            continue
        imm = values[found] if found < len(values) else values[-1]
        buf[idx : idx + 2] = (0x2000 | (imm & 0xFF)).to_bytes(2, "little")
        found += 1
        idx += 2
    if found < len(values):
        raise AssertionError(f"wanted {len(values)} 0xF800 trampolines, found {found}")
    return bytes(buf)


def _run(src: Path, values: list[int], heal: int = BASE_HEAL) -> int:
    raw = assemble(src)
    offs = symbol_offsets(src)
    code = _patch_returns(raw, values)
    h = Harness(code, skill_present=False)
    h.seed(0, b"\x00")
    h.seed(UNIT, bytes(0x48))
    stop = offs["GoBack"] + 2
    regs = h.run(stop, regs={"r0": UNIT, "r1": heal})
    return regs["r0"]


class HpRestorationWiringTests(unittest.TestCase):
    def test_ids_are_enabled(self):
        self.assertEqual(_macro("AmaterasuID"), str(AMATERASU_ID))
        self.assertEqual(_macro("CamaraderieID"), str(CAMARADERIE_ID))
        self.assertEqual(_macro("ReliefID"), str(RELIEF_ID))
        self.assertEqual(_macro("BondID"), str(BOND_ID))

    def test_installer_includes_four_skills(self):
        text = _uncommented(INSTALLER)
        for name in ("Amaterasu", "Bond", "Camaraderie", "Relief"):
            self.assertIn(f'#include "{name}/{name}.lyn.event"', text)
            self.assertIn(f"{name}IDLink:", text)

    def test_calc_loop_lists_four_skills(self):
        text = _uncommented(LOOP_EVENT)
        poin = next(
            line for line in text.splitlines() if line.strip().startswith("POIN ")
        )
        for name in ("Amaterasu", "Bond", "Camaraderie", "Relief"):
            self.assertIn(name, poin)

    def test_amaterasu_is_marked_as_aura_skill(self):
        text = _uncommented(PREBATTLE)
        self.assertIn("AuraSkillEntry(AmaterasuID)", text)

    def test_loop_builds_aura_buffer(self):
        self.assertIn("MakeAuraSkillBuffer", LOOP_S.read_text(encoding="utf-8"))


class AmaterasuExecutionTests(unittest.TestCase):
    SRC = HP_DIR / "Amaterasu" / "Amaterasu.s"

    def test_aura_hit_adds_20(self):
        self.assertEqual(_run(self.SRC, [1]), BASE_HEAL + 20)

    def test_aura_miss_leaves_heal(self):
        self.assertEqual(_run(self.SRC, [0]), BASE_HEAL)


class BondExecutionTests(unittest.TestCase):
    SRC = HP_DIR / "Bond" / "Bond.s"

    def test_aura_hit_adds_10(self):
        self.assertEqual(_run(self.SRC, [1]), BASE_HEAL + 10)

    def test_aura_miss_leaves_heal(self):
        self.assertEqual(_run(self.SRC, [0]), BASE_HEAL)


class CamaraderieExecutionTests(unittest.TestCase):
    SRC = HP_DIR / "Camaraderie" / "Camaraderie.s"

    def test_no_skill_leaves_heal(self):
        self.assertEqual(_run(self.SRC, [0, 1]), BASE_HEAL)

    def test_skill_without_allies_leaves_heal(self):
        self.assertEqual(_run(self.SRC, [1, 0]), BASE_HEAL)

    def test_skill_with_allies_adds_10(self):
        self.assertEqual(_run(self.SRC, [1, 1]), BASE_HEAL + 10)


class ReliefExecutionTests(unittest.TestCase):
    SRC = HP_DIR / "Relief" / "Relief.s"

    def test_no_skill_leaves_heal(self):
        self.assertEqual(_run(self.SRC, [0, 0]), BASE_HEAL)

    def test_skill_with_allies_leaves_heal(self):
        self.assertEqual(_run(self.SRC, [1, 1]), BASE_HEAL)

    def test_skill_without_allies_adds_20(self):
        self.assertEqual(_run(self.SRC, [1, 0]), BASE_HEAL + 20)


class HpRestorationLoopRomTests(unittest.TestCase):
    """Walk the live HPRestorationLoop pointer list in FE7_Hack.gba."""

    SIGS = {
        "Amaterasu": bytes.fromhex("00220223"),
        "Bond": bytes.fromhex("00220323"),
        "Camaraderie": bytes.fromhex("00d00a35"),
        "Relief": bytes.fromhex("00d11435"),
    }

    @classmethod
    def setUpClass(cls):
        if not HACK.is_file():
            raise unittest.SkipTest("FE7_Hack.gba missing")
        cls.rom = HACK.read_bytes()

    def _loop_bodies(self) -> list[bytes]:
        rom = self.rom
        self.assertEqual(rom[HOOK : HOOK + 4], JUMP)
        func = struct.unpack_from("<I", rom, HOOK + 4)[0] & ~1
        off = func - 0x08000000
        body = rom[off : off + 80]
        lit = body.find(struct.pack("<I", TERRAIN_TABLE))
        self.assertNotEqual(lit, -1, "terrain table literal missing")
        aura = struct.unpack_from("<I", body, lit + 4)[0]
        self.assertTrue(
            0x08000000 <= (aura & ~1) < 0x0A000000,
            "MakeAuraSkillBuffer literal missing",
        )
        loop = struct.unpack_from("<I", body, lit + 8)[0]
        cursor = (loop & ~1) - 0x08000000
        bodies = []
        while True:
            ptr = struct.unpack_from("<I", rom, cursor)[0]
            if ptr == 0:
                break
            dest = (ptr & ~1) - 0x08000000
            bodies.append(rom[dest : dest + 48])
            cursor += 4
        return bodies

    def test_loop_contains_four_new_skills(self):
        bodies = self._loop_bodies()
        for name, sig in self.SIGS.items():
            self.assertTrue(
                any(sig in chunk for chunk in bodies),
                f"{name} not in HPRestorationLoop",
            )


if __name__ == "__main__":
    unittest.main()
