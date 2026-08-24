"""Execute Amische, Shadowgift, and Lumina under a real Thumb CPU.

Amische refuses non-iron weapons when present and is a no-op when absent.
DoesUnitHaveWRank (the live Shadowgift/Lumina path in WeaponLockLoop) grants
Dark/Light tomes from the unit's other magic ranks when the matching skill
is present, and leaves native rank as the only path when it is not.

Literal pools that lyn fills at assemble-into-ROM time are appended here so
ItemTable / IronWeaponsList pointers resolve. SkillTester is stubbed by the
harness; these tests isolate the rank/list arithmetic, not skill assignment.
"""
from __future__ import annotations

import struct
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from Tools.thumb_harness import Harness, assemble, symbol_offsets

AMISCHE_SRC = ROOT / "EngineHacks/SkillSystem/Skills/WeaponUsabilitySkills/Amische/Amische.s"
WRANK_SRC = (
    ROOT
    / "EngineHacks/Necessary/CalcLoops/WeaponUsabilityCalcLoop/DoesUnitHaveWRank.s"
)
CALC_EVENT = (
    ROOT
    / "EngineHacks/Necessary/CalcLoops/WeaponUsabilityCalcLoop/WeaponUsabilityCalcLoop.event"
)
MASTER = ROOT / "EngineHacks/SkillSystem/Skills/MasterSkillInstaller.event"
LOOPS = ROOT / "EngineHacks/Necessary/CalcLoops/CalcLoops.event"
DEFS = ROOT / "EngineHacks/SkillSystem/skill_definitions.event"
HACK = ROOT / "FE7_Hack.gba"

UNIT = 0x02000000
ITEM_TABLE = 0x02010000
IRON_LIST = 0x02020000
ITEM_SIZE = 0x24
WTYPE_OFF = 7
WRANK_OFF = 0x1C
UNIT_RANKS = 0x28

WTYPE_SWORD = 0
WTYPE_STAFF = 4
WTYPE_ANIMA = 5
WTYPE_LIGHT = 6
WTYPE_DARK = 7

IRON_SWORD = 0x01
IRON_LANCE = 0x14
IRON_AXE = 0x1F
IRON_BOW = 0x2C
STEEL_SWORD = 0x03
STEEL_BOW = 0x2D

RANK_NONE = 0
RANK_E = 1
RANK_D = 31
RANK_C = 71
RANK_B = 121
RANK_A = 181
RANK_S = 251

HOOK = 0x161A4
JUMP_TO_HACK = bytes.fromhex("004b1847")


def _item_entry(wtype: int, wrank: int) -> bytes:
    data = bytearray(ITEM_SIZE)
    data[WTYPE_OFF] = wtype
    data[WRANK_OFF] = wrank
    return bytes(data)


def _ranks(**kwargs: int) -> bytes:
    names = ("sword", "lance", "axe", "bow", "staff", "anima", "light", "dark")
    out = bytearray(8)
    for name, value in kwargs.items():
        out[names.index(name)] = value
    return bytes(out)


def _pad(code: bytes, offset: int, nbytes: int) -> bytearray:
    buf = bytearray(code)
    if len(buf) < offset + nbytes:
        buf.extend(b"\x00" * (offset + nbytes - len(buf)))
    return buf


def _prep_amische() -> tuple[bytes, dict[str, int]]:
    raw = assemble(AMISCHE_SRC)
    offsets = symbol_offsets(AMISCHE_SRC)
    pool = offsets["SkillTester"]
    code = _pad(raw, pool, 12)
    struct.pack_into("<I", code, pool + 8, IRON_LIST)
    return bytes(code), offsets


def _run_amische(item: int, skill_present: bool) -> int:
    code, offsets = _prep_amische()
    h = Harness(code, skill_present=skill_present)
    h.seed(IRON_LIST, bytes([IRON_SWORD, IRON_LANCE, IRON_AXE, IRON_BOW, 0]))
    regs = h.run(offsets["GoBack"], regs={"r0": UNIT, "r1": item, "r2": RANK_A})
    return regs["r0"]


def _prep_wrank(staff_shadow: int = 0, staff_lumina: int = 0) -> tuple[bytes, dict[str, int]]:
    raw = assemble(WRANK_SRC)
    offsets = symbol_offsets(WRANK_SRC)
    pool = offsets["ItemTable"]
    code = _pad(raw, pool, 24)
    struct.pack_into("<I", code, pool, ITEM_TABLE)
    struct.pack_into("<I", code, pool + 16, staff_shadow)
    struct.pack_into("<I", code, pool + 20, staff_lumina)
    return bytes(code), offsets


def _run_wrank(
    *,
    wtype: int,
    required: int,
    native: int,
    skill_present: bool,
    staff_shadow: int = 0,
    staff_lumina: int = 0,
    item_id: int = 1,
    **rank_kwargs: int,
) -> int:
    code, offsets = _prep_wrank(staff_shadow, staff_lumina)
    h = Harness(code, skill_present=skill_present)
    h.seed(ITEM_TABLE + ITEM_SIZE * item_id, _item_entry(wtype, required))
    h.seed(UNIT + UNIT_RANKS, _ranks(**rank_kwargs))
    regs = h.run(
        offsets["GoBack"],
        regs={"r0": UNIT, "r1": item_id, "r2": native},
        entry_offset=offsets["DoesUnitHaveWRank"],
    )
    return regs["r0"]


class WeaponUsabilityWiringTests(unittest.TestCase):
    def test_ids_are_enabled(self):
        text = DEFS.read_text(encoding="utf-8")
        self.assertIn("#define ShadowgiftID 197", text)
        self.assertIn("#define LuminaID 198", text)
        self.assertIn("#define AmischeID 199", text)

    def test_category_and_calc_loop_are_installed(self):
        master = MASTER.read_text(encoding="utf-8")
        loops = LOOPS.read_text(encoding="utf-8")
        calc = CALC_EVENT.read_text(encoding="utf-8")
        self.assertRegex(
            master,
            r'(?m)^#include "WeaponUsabilitySkills/WeaponUsabilitySkills\.event"',
        )
        self.assertRegex(
            loops,
            r'(?m)^#include "WeaponUsabilityCalcLoop/WeaponUsabilityCalcLoop\.event"',
        )
        self.assertIn("jumpToHack(CanUnitWieldWeapon)", calc)
        self.assertIn("POIN Amische", calc)
        self.assertIn("POIN DoesUnitHaveWRank", calc)


class AmischeExecutionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        try:
            assemble(AMISCHE_SRC)
        except Exception as exc:
            raise unittest.SkipTest(f"thumb harness unavailable: {exc}")

    def test_absent_allows_iron_and_steel(self):
        self.assertEqual(_run_amische(IRON_SWORD, False), 1)
        self.assertEqual(_run_amische(STEEL_SWORD, False), 1)

    def test_present_allows_each_iron(self):
        for item in (IRON_SWORD, IRON_LANCE, IRON_AXE, IRON_BOW):
            with self.subTest(item=item):
                self.assertEqual(_run_amische(item, True), 1)

    def test_present_rejects_non_iron(self):
        self.assertEqual(_run_amische(STEEL_SWORD, True), 0)
        self.assertEqual(_run_amische(STEEL_BOW, True), 0)

    def test_present_matches_item_id_not_durability(self):
        self.assertEqual(_run_amische(IRON_SWORD | 0x2800, True), 1)
        self.assertEqual(_run_amische(STEEL_SWORD | 0x2800, True), 0)


class ShadowgiftLuminaExecutionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        try:
            assemble(WRANK_SRC)
        except Exception as exc:
            raise unittest.SkipTest(f"thumb harness unavailable: {exc}")

    def test_native_rank_sufficient_skips_skills(self):
        self.assertEqual(
            _run_wrank(
                wtype=WTYPE_DARK,
                required=RANK_C,
                native=RANK_C,
                skill_present=False,
                dark=RANK_C,
            ),
            1,
        )
        self.assertEqual(
            _run_wrank(
                wtype=WTYPE_LIGHT,
                required=RANK_C,
                native=RANK_C,
                skill_present=False,
                light=RANK_C,
            ),
            1,
        )

    def test_native_rank_just_below_fails_without_skill(self):
        self.assertEqual(
            _run_wrank(
                wtype=WTYPE_DARK,
                required=RANK_C,
                native=RANK_C - 1,
                skill_present=False,
                dark=RANK_C - 1,
                light=RANK_S,
                anima=RANK_S,
            ),
            0,
        )
        self.assertEqual(
            _run_wrank(
                wtype=WTYPE_LIGHT,
                required=RANK_C,
                native=RANK_C - 1,
                skill_present=False,
                light=RANK_C - 1,
                dark=RANK_S,
                anima=RANK_S,
            ),
            0,
        )

    def test_shadowgift_uses_light_rank_at_and_around_threshold(self):
        for light, expect in ((RANK_C - 1, 0), (RANK_C, 1), (RANK_C + 1, 1)):
            with self.subTest(light=light):
                self.assertEqual(
                    _run_wrank(
                        wtype=WTYPE_DARK,
                        required=RANK_C,
                        native=RANK_NONE,
                        skill_present=True,
                        light=light,
                    ),
                    expect,
                )

    def test_shadowgift_uses_anima_rank(self):
        self.assertEqual(
            _run_wrank(
                wtype=WTYPE_DARK,
                required=RANK_C,
                native=RANK_NONE,
                skill_present=True,
                anima=RANK_C,
            ),
            1,
        )

    def test_shadowgift_staff_option_off_ignores_staff(self):
        self.assertEqual(
            _run_wrank(
                wtype=WTYPE_DARK,
                required=RANK_C,
                native=RANK_NONE,
                skill_present=True,
                staff_shadow=0,
                staff=RANK_S,
            ),
            0,
        )

    def test_shadowgift_staff_option_on_uses_staff(self):
        self.assertEqual(
            _run_wrank(
                wtype=WTYPE_DARK,
                required=RANK_C,
                native=RANK_NONE,
                skill_present=True,
                staff_shadow=1,
                staff=RANK_C,
            ),
            1,
        )
        self.assertEqual(
            _run_wrank(
                wtype=WTYPE_DARK,
                required=RANK_C,
                native=RANK_NONE,
                skill_present=True,
                staff_shadow=1,
                staff=RANK_C - 1,
            ),
            0,
        )

    def test_lumina_uses_dark_rank_at_and_around_threshold(self):
        for dark, expect in ((RANK_C - 1, 0), (RANK_C, 1), (RANK_C + 1, 1)):
            with self.subTest(dark=dark):
                self.assertEqual(
                    _run_wrank(
                        wtype=WTYPE_LIGHT,
                        required=RANK_C,
                        native=RANK_NONE,
                        skill_present=True,
                        dark=dark,
                    ),
                    expect,
                )

    def test_lumina_uses_anima_rank(self):
        self.assertEqual(
            _run_wrank(
                wtype=WTYPE_LIGHT,
                required=RANK_C,
                native=RANK_NONE,
                skill_present=True,
                anima=RANK_C,
            ),
            1,
        )

    def test_lumina_staff_option_off_ignores_staff(self):
        self.assertEqual(
            _run_wrank(
                wtype=WTYPE_LIGHT,
                required=RANK_C,
                native=RANK_NONE,
                skill_present=True,
                staff_lumina=0,
                staff=RANK_S,
            ),
            0,
        )

    def test_lumina_staff_option_on_uses_staff(self):
        self.assertEqual(
            _run_wrank(
                wtype=WTYPE_LIGHT,
                required=RANK_C,
                native=RANK_NONE,
                skill_present=True,
                staff_lumina=1,
                staff=RANK_C,
            ),
            1,
        )

    def test_sword_is_unaffected_by_gift_skills(self):
        self.assertEqual(
            _run_wrank(
                wtype=WTYPE_SWORD,
                required=RANK_C,
                native=RANK_NONE,
                skill_present=True,
                anima=RANK_S,
                light=RANK_S,
                dark=RANK_S,
            ),
            0,
        )


@unittest.skipUnless(HACK.is_file(), "FE7_Hack.gba missing")
class WeaponUsabilityRomTests(unittest.TestCase):
    def test_can_unit_wield_weapon_hook_is_installed(self):
        # FE7_Hack.gba — ROM test, after assemble
        rom = HACK.read_bytes()
        self.assertEqual(
            rom[HOOK : HOOK + 4],
            JUMP_TO_HACK,
            "CanUnitUseWeapon at 0x161A4 must be jumpToHack",
        )
        target = (struct.unpack_from("<I", rom, HOOK + 4)[0] & ~1) - 0x08000000
        self.assertEqual(
            rom[target : target + 2],
            bytes.fromhex("f0b5"),
            "hook target must start with push {r4-r7,lr}",
        )


if __name__ == "__main__":
    unittest.main()
