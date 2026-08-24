"""DEC-94: Dark Bargain, Hoarder's Bane, Soul Sap, Indoor March, Nature Rush."""
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
MASTER = ROOT / "EngineHacks/SkillSystem/Skills/MasterSkillInstaller.event"
CALCS = ROOT / "EngineHacks/Necessary/CalcLoops/CalcLoops.event"
TURN_EVENT = ROOT / "EngineHacks/Necessary/CalcLoops/TurnLoop/Installer.event"
MOV_EVENT = ROOT / "EngineHacks/Necessary/StatGetters/Movement.event"
TURN_SKILLS = ROOT / "EngineHacks/SkillSystem/Skills/TurnSkills"
MOV_SKILLS = ROOT / "EngineHacks/SkillSystem/Skills/MovementSkills"
HACK = ROOT / "FE7_Hack.gba"

DARK_BARGAIN_ID = 208
HOARDERS_BANE_ID = 209
SOUL_SAP_ID = 210
INDOOR_MARCH_ID = 211
NATURE_RUSH_ID = 212

UNIT = 0x02000000
EXP_SPENT = 0x02026B8C
TERRAIN = 0x0202E3E0
MAP_PTRS = 0x02001000
MAP_ROW = 0x02001100
PHASE_SWITCH = 0xB937AC
F800 = bytes.fromhex("00f8")


def _macro(name: str) -> str:
    match = re.search(rf"^#define {name} (\S+)", DEFS.read_text(encoding="utf-8"), re.M)
    if match is None:
        raise AssertionError(f"{name} missing")
    return match.group(1)


def _active(path: Path) -> str:
    return "\n".join(
        line
        for line in path.read_text(encoding="utf-8").splitlines()
        if not line.lstrip().startswith("//")
    )


def _patch_f800(code: bytes, values: list[int]) -> bytes:
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


class TurnSkillWiringTests(unittest.TestCase):
    def test_ids_are_enabled(self):
        self.assertEqual(_macro("DarkBargainID"), str(DARK_BARGAIN_ID))
        self.assertEqual(_macro("HoardersBaneID"), str(HOARDERS_BANE_ID))
        self.assertEqual(_macro("SoulSapID"), str(SOUL_SAP_ID))
        self.assertEqual(_macro("IndoorMarchID"), str(INDOOR_MARCH_ID))
        self.assertEqual(_macro("NatureRushID"), str(NATURE_RUSH_ID))

    def test_turn_skills_are_installed(self):
        self.assertIn("TurnSkills/Installer.event", _active(MASTER))
        self.assertIn("MovementSkills/MovementSkills.event", _active(MASTER))
        self.assertIn("TurnLoop/Installer.event", _active(CALCS))

    def test_end_of_turn_heal_table_lists_three_skills(self):
        text = _active(TURN_EVENT)
        self.assertIn("EndOfTurnHealFunctionEntry(HoardersBaneID", text)
        self.assertIn("EndOfTurnHealFunctionEntry(DarkBargainID", text)
        self.assertIn("EndOfTurnHealFunctionEntry(SoulSapID", text)

    def test_heal_sources_use_fe7_getunit(self):
        soul = (TURN_SKILLS / "SoulSap.s").read_text(encoding="utf-8")
        hoard = (TURN_SKILLS / "HoardersBane.s").read_text(encoding="utf-8")
        self.assertIn("0x8018d0c", soul.lower())
        self.assertNotIn("0x8019430", soul.lower())
        self.assertIn("0x8018d0c", hoard.lower())
        self.assertNotIn("0x8019430", hoard.lower())

    def test_heal_anim_uses_fe7_map_anim_addresses(self):
        hoard = (TURN_SKILLS / "HoardersBane.s").read_text(encoding="utf-8").lower()
        self.assertIn("0x08032858", hoard)
        self.assertNotIn("0x08035804", hoard)
        self.assertIn("0x8c9d634", hoard)
        self.assertNotIn("0x89a3874", hoard)
        self.assertIn("0x8c9d00c", hoard)
        self.assertNotIn("0x89a2c48", hoard)
        self.assertNotIn("0x8028130", hoard)
        self.assertIn("0x08032710", hoard)
        self.assertNotIn("0x08032750", hoard)
        self.assertNotIn("0x080321c8", hoard)
        self.assertIn("darkbargain_expspent", hoard)
        self.assertIn("0x02026b8c", hoard)
        self.assertIn("#0x6e", hoard)
        self.assertIn("#0x71", hoard)
        self.assertIn("org $7006c", _active(ROOT / "EngineHacks/SkillSystem/Skills/TurnSkills/Installer.event").lower())
        self.assertIn("#0x42", hoard)
        self.assertIn("healanim_prepsprite", hoard)
        self.assertIn("healanim_restoresprite", hoard)

    def test_ids_match_asm_immediates(self):
        indoor = (MOV_SKILLS / "IndoorMarch" / "IndoorMarch.s").read_text(encoding="utf-8")
        rush = (MOV_SKILLS / "NatureRush" / "NatureRush.s").read_text(encoding="utf-8")
        self.assertIn("mov r1, #211", indoor)
        self.assertIn("mov r1, #212", rush)
        text = _active(MOV_EVENT)
        self.assertIn("prIndoorMarch", text)
        self.assertIn("prNatureRush", text)

    def test_phase_switch_hook_is_fe7(self):
        text = _active(TURN_EVENT)
        self.assertIn("$B937AC", text)
        self.assertNotIn("$59A288", text)


class DarkBargainExecutionTests(unittest.TestCase):
    SRC = TURN_SKILLS / "DarkBargain.s"

    def _unit(self, exp: int, hp: int, maxhp: int) -> bytes:
        buf = bytearray(0x48)
        buf[9] = exp
        buf[0x12] = maxhp
        buf[0x13] = hp
        return bytes(buf)

    def _can(self, exp: int) -> int:
        off = symbol_offsets(self.SRC)
        h = Harness(assemble(self.SRC), skill_present=False)
        h.seed(UNIT, self._unit(exp, 10, 20))
        return h.run(
            off["Exit_DarkBargain_CanUnitHeal"],
            regs={"r0": UNIT},
            entry_offset=off["DarkBargain_CanUnitHeal"],
        )["r0"]

    def _heal(self, exp: int, hp: int, maxhp: int) -> tuple[int, int, int]:
        code = assemble(self.SRC)
        start = symbol_offsets(self.SRC)["DarkBargain_HealAmount"]
        end = code.find(b"\x70\x47", start + 4)
        h = Harness(code, skill_present=False)
        h.seed(UNIT, self._unit(exp, hp, maxhp))
        h.seed(EXP_SPENT, b"\xFF")
        regs = h.run(end, regs={"r0": UNIT}, entry_offset=start)
        return regs["r0"], h.read(UNIT + 9, 1)[0], h.read(EXP_SPENT, 1)[0]

    def _bar_step(self, exp_from: int, exp_to: int) -> int:
        proc = 0x02001000
        code = assemble(self.SRC)
        offs = symbol_offsets(self.SRC)
        buf = bytearray(0x68)
        struct.pack_into("<HH", buf, 0x64, exp_from, exp_to)
        h = Harness(code, skill_present=False)
        h.seed(proc, bytes(buf))
        h.run(
            offs["MapAnimExpBar_Step_Drawn"],
            regs={"r0": proc},
            entry_offset=offs["MapAnimExpBar_Step"],
        )
        return int.from_bytes(h.read(proc + 0x64, 2), "little")

    def test_zero_exp_cannot_heal(self):
        self.assertEqual(self._can(0), 0)

    def test_mid_exp_can_heal(self):
        self.assertEqual(self._can(50), 1)

    def test_level_up_exp_cannot_heal(self):
        self.assertEqual(self._can(100), 0)

    def test_heal_capped_by_missing_hp(self):
        healed, exp, spent = self._heal(50, 10, 20)
        self.assertEqual(healed, 10)
        self.assertEqual(exp, 40)
        self.assertEqual(spent, 10)

    def test_heal_uses_all_exp_when_hurt_enough(self):
        healed, exp, spent = self._heal(50, 10, 80)
        self.assertEqual(healed, 50)
        self.assertEqual(exp, 0)
        self.assertEqual(spent, 50)

    def test_exp_bar_decrements_toward_lower_to(self):
        self.assertEqual(self._bar_step(50, 40), 49)

    def test_exp_bar_increments_toward_higher_to(self):
        self.assertEqual(self._bar_step(10, 20), 11)


def _run_march(src: Path, skill: bool, terrain: int) -> int:
    raw = assemble(src)
    offs = symbol_offsets(src)
    code = _patch_f800(raw, [1 if skill else 0])
    h = Harness(code, skill_present=False)
    unit = bytearray(0x48)
    unit[0x10] = 0
    unit[0x11] = 0
    h.seed(UNIT, bytes(unit))
    h.seed(TERRAIN, struct.pack("<I", MAP_PTRS))
    h.seed(MAP_PTRS, struct.pack("<I", MAP_ROW))
    h.seed(MAP_ROW, bytes([terrain]) + b"\x00" * 15)
    stop = offs["GoBack"] + 2
    return h.run(stop, regs={"r0": 5, "r1": UNIT})["r0"]


class HealAnimSpriteTests(unittest.TestCase):
    SRC = TURN_SKILLS / "HoardersBane.s"

    def _prep(self, state: int) -> tuple[int, int]:
        offs = symbol_offsets(self.SRC)
        h = Harness(assemble(self.SRC), skill_present=False)
        unit = bytearray(0x48)
        struct.pack_into("<I", unit, 0x0C, state)
        h.seed(UNIT, bytes(unit))
        regs = h.run(
            offs["HealAnim_PrepSprite_Exit"],
            regs={"r0": UNIT},
            entry_offset=offs["HealAnim_PrepSprite"],
        )
        now = int.from_bytes(h.read(UNIT + 0x0C, 4), "little")
        return regs["r0"], now

    def _restore(self, saved: int) -> int:
        offs = symbol_offsets(self.SRC)
        h = Harness(assemble(self.SRC), skill_present=False)
        unit = bytearray(0x48)
        struct.pack_into("<I", unit, 0x0C, 0x43)
        h.seed(UNIT, bytes(unit))
        h.run(
            offs["HealAnim_RestoreSprite_Exit"],
            regs={"r0": UNIT, "r1": saved},
            entry_offset=offs["HealAnim_RestoreSprite"],
        )
        return int.from_bytes(h.read(UNIT + 0x0C, 4), "little")

    def test_prep_hides_sms_and_clears_grey(self):
        original, now = self._prep(0x42)
        self.assertEqual(original, 0x42)
        self.assertEqual(now & 1, 1)
        self.assertEqual(now & 0x42, 0)

    def test_restore_does_not_eat_turn(self):
        self.assertEqual(self._restore(0), 0)

    def test_restore_keeps_already_acted(self):
        self.assertEqual(self._restore(0x42), 0x42)


class IndoorMarchExecutionTests(unittest.TestCase):
    SRC = MOV_SKILLS / "IndoorMarch" / "IndoorMarch.s"

    def test_no_skill_leaves_mov(self):
        self.assertEqual(_run_march(self.SRC, False, 0x17), 5)

    def test_indoor_floor_adds_two(self):
        self.assertEqual(_run_march(self.SRC, True, 0x17), 7)

    def test_plains_leave_mov(self):
        self.assertEqual(_run_march(self.SRC, True, 0x01), 5)


class NatureRushExecutionTests(unittest.TestCase):
    SRC = MOV_SKILLS / "NatureRush" / "NatureRush.s"

    def test_no_skill_leaves_mov(self):
        self.assertEqual(_run_march(self.SRC, False, 0x0C), 5)

    def test_forest_adds_two(self):
        self.assertEqual(_run_march(self.SRC, True, 0x0C), 7)

    def test_indoor_floor_leaves_mov(self):
        self.assertEqual(_run_march(self.SRC, True, 0x17), 5)


@unittest.skipUnless(HACK.exists(), "FE7_Hack.gba missing")
class TurnLoopRomTests(unittest.TestCase):
    def test_phase_switch_calls_turn_loop_master(self):
        rom = HACK.read_bytes()  # FE7_Hack.gba
        self.assertEqual(rom[PHASE_SWITCH : PHASE_SWITCH + 2], bytes((0x16, 0x00)))
        dest = struct.unpack_from("<I", rom, PHASE_SWITCH + 4)[0]
        self.assertTrue(0x09000000 <= (dest & ~1) < 0x0A000000, hex(dest))


if __name__ == "__main__":
    unittest.main()
