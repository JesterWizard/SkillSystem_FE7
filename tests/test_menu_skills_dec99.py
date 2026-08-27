"""DEC-99: 27 Unit Menu skills enabled, wired, and executed."""
from __future__ import annotations

import json
import re
import struct
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from Tools import thumb_harness as th

DEFS = ROOT / "EngineHacks/SkillSystem/skill_definitions.event"
MASTER = ROOT / "EngineHacks/SkillSystem/Skills/MasterSkillInstaller.event"
HACK_INSTALLER = ROOT / "EngineHacks/_MasterHackInstaller.event"
UNIT_MENU = ROOT / "EngineHacks/Necessary/UnitMenu/UnitMenu.event"
SKILLS_MENU = (
    ROOT / "EngineHacks/SkillSystem/Skills/UnitMenuSkills/SkillsMenu.event"
)
RALLY_FX_S = ROOT / "EngineHacks/SkillSystem/Skills/RallySkills/asm/RallyFx.s"
PREBATTLE = (
    ROOT
    / "EngineHacks/Necessary/CalcLoops/PreBattleCalcLoop/PreBattleCalcLoop.event"
)
PROC_LOOP = (
    ROOT
    / "EngineHacks/Necessary/CalcLoops/BattleProcCalcLoop/BattleProcCalcLoop.event"
)
SNAPSHOT = Path(__file__).with_name("skill_id_snapshot.json")
HACK = ROOT / "FE7_Hack.gba"
CLEAN = ROOT / "FE7_clean.gba"

# FE8 UnitMenu.event ORG sites. On FE7 these are Thumb / jump-table
# bytes, not menu geometry. Patching them loops chapter start.
FE8_UNIT_MENU_ORGS = (
    0x1CA86,
    0x1D44E,
    0x1D450,
    0x1D4FA,
    0x1D4FC,
    0x22772,
    0x22774,
    0x22818,
    0x2281A,
    0x23660,
    0x23662,
    0x59D1F2,
    0x59D1F8,
    0x59D216,
)
GAMBLE_S = ROOT / "EngineHacks/SkillSystem/Skills/PreBattleSkills/Gamble/Gamble.s"
MERCY_S = ROOT / "EngineHacks/SkillSystem/Skills/ProcSkills/Mercy/proc_mercy.s"
PIVOT_S = (
    ROOT
    / "EngineHacks/SkillSystem/Skills/UnitMenuSkills/HeroesMovement/asm/GetOppositePosition.s"
)
STAN_DEFS = (
    ROOT
    / "EngineHacks/SkillSystem/Skills/UnitMenuSkills/_StanHaxCommon/asm"
)

SKILL_OFF = 255
IDS = {
    "RallyStrID": 225,
    "RallyMagID": 226,
    "RallySklID": 227,
    "RallySpdID": 228,
    "RallyLukID": 229,
    "RallyDefID": 230,
    "RallyResID": 231,
    "RallyMovID": 232,
    "RallySpectrumID": 233,
    "CaptureID": 234,
    "DanceID": 235,
    "GambleID": 236,
    "MercyID": 237,
    "SummonID": 238,
    "SupplyID": 239,
    "ShoveID": 240,
    "SmiteID": 241,
    "PivotID": 242,
    "RepositionID": 243,
    "SwapID": 244,
    "SwarpID": 245,
    "StealID": 246,
    "StealPlusID": 247,
    "DrawBackID": 248,
    "SacrificeID": 249,
    "ArdentSacrificeID": 250,
    "ReciprocalAidID": 251,
}

ATTACKER = 0x0203A3F0
FLAG = 0x0203F101
UNIT = 0x02000000
HIT_OFF, CRIT_OFF = 0x60, 0x66


def _active(path: Path) -> str:
    return "\n".join(
        line
        for line in path.read_text(encoding="utf-8").splitlines()
        if not line.lstrip().startswith("//")
    )


def _macro(name: str) -> str:
    match = re.search(rf"^#define {name} (\S+)", DEFS.read_text(encoding="utf-8"), re.M)
    if match is None:
        raise AssertionError(f"{name} missing")
    return match.group(1)


class MenuSkillWiringTests(unittest.TestCase):
    def test_ids_are_enabled(self):
        for name, sid in IDS.items():
            self.assertEqual(_macro(name), str(sid), name)
            self.assertNotEqual(sid, SKILL_OFF)

    def test_snapshot_matches_enabled_ids(self):
        snap = json.loads(SNAPSHOT.read_text(encoding="utf-8"))
        for name, sid in IDS.items():
            self.assertEqual(snap[name], sid, name)

    def test_category_and_menu_are_installed(self):
        master = _active(MASTER)
        installer = _active(HACK_INSTALLER)
        menu = _active(UNIT_MENU)
        self.assertIn("UnitMenuSkills/UnitMenuSkills.event", master)
        self.assertIn("RallySkills/RallySkills.event", master)
        self.assertIn("Necessary/UnitMenu/UnitMenu.event", installer)
        self.assertIn("ORG $B95AB4", menu)
        rally = (
            ROOT
            / "EngineHacks/SkillSystem/Skills/RallySkills/RallySkills.event"
        ).read_text(encoding="utf-8")
        self.assertIn("#define MSG_HAS_RALLY_FX", rally)
        self.assertIn("Necessary/UnitActionRework/UnitActionRework.event", installer)
        self.assertIn("SkillsUsability", menu)
        self.assertIn("SkillsEffect", menu)
        self.assertIn("SkillsMenu.event", _active(
            ROOT / "EngineHacks/SkillSystem/Skills/UnitMenuSkills/UnitMenuSkills.event"
        ))
        skills = _active(SKILLS_MENU)
        self.assertNotIn("RallyCommandUsability", skills)
        for token in (
            "GambleUsability",
            "MercyUsability",
            "Capture_Usability",
            "RallyStrCommandUsability",
            "RallySklCommandUsability",
            "RallySpdCommandUsability",
            "RallyDefCommandUsability",
            "RallyResCommandUsability",
            "RallyLukCommandUsability",
            "RallyMovCommandUsability",
            "RallySpectrumCommandUsability",
            # Heroes movement commands are FE7-native; HeroesMovement's
            # blobs are FE8 and the menu must not reach them.
            "ShoveUsability",
            "SmiteUsability",
            "PivotUsability",
            "RepositionUsability",
            "SwapUsability",
            "SwarpUsability",
            "DrawBackUsability",
            "Sacrifice_Usability",
            "ArdentSacrifice_Usability",
            "ReciprocalAid_Usability",
        ):
            self.assertIn(token, skills, token)
            self.assertNotIn(token, menu, token)
        for token in (
            "prSmiteCommand_Usability",
            "prPivotCommand_Usability",
            "prRepositionCommand_Usability",
            "prSwapCommand_Usability",
            "prSwarpCommand_Usability",
            "DrawBack_Usability",
        ):
            self.assertNotIn(token, skills, token)
        for token in (
            "NewDanceUsability",
            "NewSupplyUsability",
        ):
            self.assertIn(token, menu, token)
        self.assertNotIn("NewSummonUsability", menu)
        self.assertIn(
        "SkillsMenuCommand(SkillMenuName97, UM_SummonName, UM_SummonDesc, "
        "$7F, NewSummonUsability, SummonEffect",
            skills,
        )

    def test_rally_hover_does_not_use_fe8_proc_or_gfx(self):
        rally_s = (
            ROOT / "EngineHacks/SkillSystem/Skills/RallySkills/asm/Rally.s"
        ).read_text(encoding="utf-8")
        rally_fx = (
            ROOT / "EngineHacks/SkillSystem/Skills/RallySkills/asm/RallyFx.s"
        ).read_text(encoding="utf-8")
        aura = (
            ROOT
            / "EngineHacks/SkillSystem/Skills/RallySkills/MapAuraFx/MapAuraFx.event"
        ).read_text(encoding="utf-8")
        # FE7 StartProc is $8004494 (same numeric site as FE8). SkillsRef
        # $8002C7C is mid-function: pop/bx into EWRAM (crash $2025080).
        self.assertIn("StartProc = 0x08004494", rally_s)
        self.assertNotIn("0x08002C7C", rally_s)
        self.assertIn("StartProc = 0x08004494", rally_fx)
        self.assertNotIn("0x08002C7C", rally_fx)
        self.assertNotIn('#include "Src/MapAuraFx.lyn.event"', aura)
        self.assertNotIn("08A032AC", aura)
        # Hover used to StartProc(RallyPreviewFxProc, 3). FE7 parent=3 is
        # not a tree id; the proc script is then misread and PC lands in
        # BuffAnim_ASMC (debugger: RalliesNumberOfBits_Link at $902276C).
        switch_in = rally_s.split("RallyCommandSwitchIn:")[1].split("RallyCommandSwitchOut:")[0]
        self.assertNotIn("StartProc", switch_in)
        self.assertNotIn("0x08032858", rally_fx)
        self.assertNotIn("0x08075115", rally_fx)
        self.assertNotIn("BeginUnitHealAnim", rally_fx)
        self.assertNotIn("AddMapAuraFxUnit:", aura)
        start_fx = rally_fx.split("StartRallyFx:")[1].split("BXR3:")[0]
        self.assertIn("RallySeqProc", start_fx)
        self.assertNotIn("LockGame", start_fx)
        self.assertNotIn("AddMapAuraFxUnit", start_fx)
        self.assertIn("RallySeq_GetNextUnit", rally_fx)
        start_bar = rally_fx.split("StartBarrierOnUnit:")[1].split("StartBarrierOnUnit.end:")[0]
        self.assertIn("0x08073878", start_bar)
        self.assertNotIn("0x0802A3B0", start_bar)
        self.assertNotIn("0x08C9D634", start_bar)
        self.assertNotIn("RallyBarrierProc", start_bar)
        self.assertNotIn("UNIT_STATE_HIDDEN", rally_fx)
        self.assertNotIn("BeginUnitHealAnim", start_bar)
        self.assertNotIn("0x08032858", start_bar)
        self.assertNotIn("0x08075115", start_bar)
        asmc = rally_s.split("BuffAnim_ASMC:")[1].split("GetUnit =")[0]
        self.assertNotIn("0x0800BC50", asmc)
        self.assertNotIn("StartBuffFx", asmc)

    def test_skills_menu_uses_fe7_submenu_hooks(self):
        skills = SKILLS_MENU.read_text(encoding="utf-8")
        defn = skills.split("SkillsMenuDef:")[1].split("SkillsMenu:")[0]
        self.assertIn("POIN SkillsMenu", defn)
        self.assertNotIn("WORD 0\nWORD 0\nPOIN SkillsMenu", defn.replace("\r", ""))
        self.assertIn("BYTE 10", defn)
        self.assertNotIn("BYTE 14", defn)
        self.assertIn("SkillsMenuOnEnd", defn)
        self.assertIn("SkillsMenuBPress", defn)
        self.assertNotIn("0x2176D", skills)
        self.assertIn("0x4A9D5", skills)
        self.assertIn("0x4A909", skills)
        self.assertNotIn("0x22861", skills)
        src = (
            ROOT / "EngineHacks/SkillSystem/Skills/UnitMenuSkills/SkillsMenu.s"
        ).read_text(encoding="utf-8")
        self.assertIn("0x804A255", src)
        self.assertIn("0x0804A424", src)
        self.assertIn("mov r0,#0x04", src)
        self.assertIn("bl SaveParentMenu", src)
        self.assertIn("bl RestoreParentMenu", src)
        self.assertIn("strh r2,[r0,r3]", src)
        self.assertIn("ldrh r1,[r4,r3]", src)
        self.assertNotIn("SkillsMenuKeepParent", src)

    def test_gamble_and_mercy_are_in_calc_loops(self):
        self.assertIn("POIN Gamble", _active(PREBATTLE))
        self.assertIn("Proc_Mercy", _active(PROC_LOOP))

    def test_fe7_guards_not_fe8(self):
        heroes = (
            ROOT
            / "EngineHacks/SkillSystem/Skills/UnitMenuSkills/HeroesMovement/HeroesMovement.event"
        ).read_text(encoding="utf-8")
        capture = (
            ROOT
            / "EngineHacks/SkillSystem/Skills/UnitMenuSkills/Capture/Capture/Capture.event"
        ).read_text(encoding="utf-8")
        action = (
            ROOT / "EngineHacks/Necessary/UnitActionRework/UnitActionRework.event"
        ).read_text(encoding="utf-8")
        self.assertIn("_FE7_", heroes)
        self.assertNotIn("is for FE8", heroes)
        self.assertIn("#ifdef _FE7_", capture)
        self.assertIn("_FE7_", action)
        self.assertNotIn("assembled for FE8", action)


class GambleExecutionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        try:
            th.assemble(GAMBLE_S)
        except Exception as exc:
            raise unittest.SkipTest(f"thumb harness unavailable: {exc}") from exc

    def _run(self, flag: int, hit: int, crit: int, as_attacker: bool) -> tuple[int, int]:
        code = th.assemble(GAMBLE_S)
        offs = th.symbol_offsets(GAMBLE_S)
        h = th.Harness(code, skill_present=False)
        buf = bytearray(0x80)
        struct.pack_into("<H", buf, HIT_OFF, hit)
        struct.pack_into("<H", buf, CRIT_OFF, crit)
        h.seed(ATTACKER, bytes(buf))
        h.seed(FLAG, bytes([flag]))
        actor = ATTACKER if as_attacker else ATTACKER + 0x80
        h.run(offs["End"], {"r0": actor, "r1": ATTACKER + 0x80})
        out = h.read(ATTACKER, 0x80)
        return (
            int.from_bytes(out[HIT_OFF : HIT_OFF + 2], "little"),
            int.from_bytes(out[CRIT_OFF : CRIT_OFF + 2], "little"),
        )

    def test_flag_halves_hit_and_doubles_crit(self):
        self.assertEqual(self._run(5, 100, 20, True), (50, 40))

    def test_no_flag_leaves_stats(self):
        self.assertEqual(self._run(0, 100, 20, True), (100, 20))

    def test_defender_side_leaves_stats(self):
        self.assertEqual(self._run(5, 100, 20, False), (100, 20))


class MercyExecutionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        try:
            th.assemble(MERCY_S)
        except Exception as exc:
            raise unittest.SkipTest(f"thumb harness unavailable: {exc}") from exc

    def _run(self, flag: int, hp: int, dmg: int, miss: bool) -> int:
        code = th.assemble(MERCY_S)
        offs = th.symbol_offsets(MERCY_S)
        h = th.Harness(code, skill_present=False)
        defender = bytearray(0x48)
        defender[0x13] = hp
        battle = bytearray(0x10)
        struct.pack_into("<h", battle, 4, dmg)
        buf = bytearray(4)
        if miss:
            struct.pack_into("<I", buf, 0, 2)
        h.seed(ATTACKER, b"\x00" * 0x48)
        h.seed(UNIT, bytes(defender))
        h.seed(UNIT + 0x80, bytes(battle))
        h.seed(UNIT + 0x100, bytes(buf))
        h.seed(FLAG, bytes([flag]))
        h.run(
            offs["End"],
            {
                "r0": ATTACKER,
                "r1": UNIT,
                "r2": UNIT + 0x100,
                "r3": UNIT + 0x80,
            },
        )
        return int.from_bytes(h.read(UNIT + 0x80 + 4, 2), "little", signed=True)

    def test_lethal_hit_leaves_one_hp(self):
        self.assertEqual(self._run(4, 10, 25, False), 9)

    def test_nonlethal_hit_unchanged(self):
        self.assertEqual(self._run(4, 10, 3, False), 3)

    def test_no_flag_kills(self):
        self.assertEqual(self._run(0, 10, 25, False), 25)

    def test_miss_skips_mercy(self):
        self.assertEqual(self._run(4, 10, 25, True), 25)


class PivotGeometryTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        try:
            th.assemble(PIVOT_S, include_dirs=[STAN_DEFS])
        except Exception as exc:
            raise unittest.SkipTest(f"thumb harness unavailable: {exc}") from exc

    def test_pivot_east_of_ally(self):
        code = th.assemble(PIVOT_S, include_dirs=[STAN_DEFS])
        offs = th.symbol_offsets(PIVOT_S, include_dirs=[STAN_DEFS])
        h = th.Harness(code, skill_present=False)
        unit = bytearray(0x48)
        unit[0x10] = 5
        unit[0x11] = 5
        h.seed(UNIT, bytes(unit))
        regs = h.run(
            offs["GetOppositePosition_End"],
            {"r0": UNIT, "r1": 6, "r2": 5},
            offs["GetOppositePosition"],
        )
        self.assertEqual(regs["r1"], 7)
        self.assertEqual(regs["r2"], 5)


class RallyNamedMenuAndBwlTests(unittest.TestCase):
    def test_submenu_lists_each_rally_by_name(self):
        text = (
            ROOT / "Text" / "unitmenu_text.txt"
        ).read_text(encoding="utf-8")
        for label, name in (
            ("UM_RallyStr", "Rally Str"),
            ("UM_RallyMag", "Rally Mag"),
            ("UM_RallySkl", "Rally Skl"),
            ("UM_RallySpd", "Rally Spd"),
            ("UM_RallyDef", "Rally Def"),
            ("UM_RallyRes", "Rally Res"),
            ("UM_RallyLuk", "Rally Luk"),
            ("UM_RallyMov", "Rally Mov"),
            ("UM_RallySpectrum", "Rally Spectrum"),
        ):
            self.assertIn(f"## {label}", text, label)
            self.assertIn(name, text, name)
            self.assertIn(label, _active(SKILLS_MENU), label)
        self.assertIn("SkillsMenuCommand", _active(SKILLS_MENU))
        self.assertIn("SkillMenuName80", _active(SKILLS_MENU))
        self.assertIn("SkillMenuName82", _active(SKILLS_MENU))
        self.assertIn("RallyMagCommandUsability", _active(SKILLS_MENU))
        for cmd in (
            "$68",
            "$69",
            "$6A",
            "$6B",
            "$6C",
            "$6D",
            "$6E",
            "$6F",
            "$7E",
        ):
            self.assertIn(cmd, _active(SKILLS_MENU), cmd)
        self.assertNotIn("BYTE $80 0", _active(SKILLS_MENU))

    def test_apply_writes_bwl_pad_byte(self):
        rally_s = (
            ROOT / "EngineHacks/SkillSystem/Skills/RallySkills/asm/Rally.s"
        ).read_text(encoding="utf-8")
        apply = rally_s.split("RallyCommandEffect_apply:")[1].split(
            "RallyCommandSwitchIn:"
        )[0]
        self.assertIn("GetBwlEntryForUnit", apply)
        self.assertIn("BWL_RALLY_BYTE", apply)
        self.assertIn("BWL_GetEntry", rally_s)
        self.assertIn("BWL_RALLY_BYTE = 0x0F", rally_s)
        self.assertNotIn("RalliesOffset_Link", apply)
        self.assertNotIn("GetUnitDebuffEntry", apply)
        self.assertIn("ClearBwlRallies", rally_s)
        self.assertIn("RallyMagCommandUsability", rally_s)
        self.assertIn("GetUnitRallyMagFlag", rally_s)
        self.assertIn("BWL_RALLY_MAG_BYTE = 0x0E", rally_s)
        turn = (
            ROOT
            / "EngineHacks/Necessary/CalcLoops/TurnLoop/Installer.event"
        ).read_text(encoding="utf-8")
        self.assertIn("ClearBwlRallies", turn)

    def test_stat_getters_read_bwl_rally_flags(self):
        rally_stat = (
            ROOT / "EngineHacks/Necessary/StatGetters/_asm/RallyStat.s"
        ).read_text(encoding="utf-8")
        self.assertIn("GetUnitBwlRallyFlags", rally_stat)
        mag = rally_stat.split("prRallyMag:")[1].split("prRallyStr:")[0]
        self.assertIn("GetUnitRallyMagFlag", mag)
        self.assertIn("MagRallyAmount_Link", mag)
        self.assertNotIn("GetUnitDebuffEntry", rally_stat)
        install = (
            ROOT
            / "EngineHacks/Necessary/StatGetters/_InstallStatGetters.event"
        ).read_text(encoding="utf-8")
        self.assertIn("MSG_HAS_RALLY_FX", install)
        stubs = (
            ROOT
            / "EngineHacks/Necessary/StatGetters/_MissingModuleStubs.event"
        ).read_text(encoding="utf-8")
        rally_stub = stubs.split("prRallyStr:")[0]
        self.assertIn("MSG_HAS_RALLY_FX", stubs)
        self.assertIn("#ifndef MSG_HAS_RALLY_FX", stubs)

    def test_bwl_data_doc_maps_rally_byte(self):
        doc = (ROOT / "Documentation" / "BWLData.md").read_text(encoding="utf-8")
        self.assertIn("0x0F", doc)
        self.assertIn("Rally", doc)
        self.assertIn("0x08", doc)
        self.assertIn("0x0E", doc)
        self.assertIn("Rally Mag", doc)


class RallyBarrierFxTests(unittest.TestCase):
    def test_seq_proc_locks_until_unlock(self):
        text = RALLY_FX_S.read_text(encoding="utf-8")
        seq = text.split("RallySeqProc:")[1].split("RallySeq_OnInit:")[0]
        self.assertIn("LockGame", seq)
        self.assertIn("UnlockGame", seq)

    def test_barrier_ap_on_unit_skips_map_anim_battle(self):
        text = RALLY_FX_S.read_text(encoding="utf-8")
        start = text.split("StartBarrierOnUnit:")[1].split(
            "AddMapAuraFxUnit:"
        )[0]
        self.assertIn("0x08073878", start)
        self.assertIn("0x08C9DD24", start)
        self.assertIn("0x080044F8", start)
        self.assertNotIn("0x0802A3B0", start)
        self.assertNotIn("0x08C9D634", start)
        self.assertNotIn("0x0802A4B4", start)
        self.assertNotIn("0x08032858", start)
        self.assertNotIn("0x08075115", start)
        self.assertNotIn("0x0806CCB8", start)
        wait = text.split("WaitForBarrierEnd:")[1].split(
            "WaitForBarrierEndProc:"
        )[0]
        self.assertIn("0x080046A8", wait)
        self.assertNotIn("0x08029c24", wait)
        self.assertNotIn("0x0806CCB8", wait)


class RallySeqNextUnitTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        try:
            th.assemble(RALLY_FX_S)
        except Exception as exc:
            raise unittest.SkipTest(f"thumb harness unavailable: {exc}") from exc

    def _next(self, index: int, units: bytes) -> tuple[int, int]:
        code = th.assemble(RALLY_FX_S)
        offs = th.symbol_offsets(RALLY_FX_S)
        h = th.Harness(code, skill_present=False)
        proc = bytearray(0x48)
        proc[0x2E] = index
        proc[0x38 : 0x38 + len(units)] = units
        h.seed(UNIT, bytes(proc))
        regs = h.run(
            offs["RallySeq_GetNextUnit_End"],
            {"r0": UNIT},
            offs["RallySeq_GetNextUnit"],
        )
        out = h.read(UNIT, 0x48)
        return regs["r0"], out[0x2E]

    def test_returns_first_then_advances(self):
        self.assertEqual(self._next(0, b"\x01\x02\x00"), (1, 1))

    def test_returns_next_then_advances(self):
        self.assertEqual(self._next(1, b"\x01\x02\x00"), (2, 2))

    def test_terminator_returns_zero(self):
        self.assertEqual(self._next(2, b"\x01\x02\x00"), (0, 2))

    def test_barrier_null_unit_skips_ap(self):
        code = th.assemble(RALLY_FX_S)
        offs = th.symbol_offsets(RALLY_FX_S)
        h = th.Harness(code, skill_present=False)
        regs = h.run(
            offs["StartBarrierOnUnit_End"],
            {"r0": 0, "r1": 0},
            offs["StartBarrierOnUnit"],
        )
        self.assertEqual(regs["r0"], 0)


@unittest.skipUnless(HACK.exists() and CLEAN.exists(), "FE7_Hack.gba or FE7_clean.gba missing")
class MenuSkillRomTests(unittest.TestCase):
    def test_fe8_unit_menu_orgs_do_not_clobber_fe7(self):
        hack = HACK.read_bytes()  # FE7_Hack.gba
        clean = CLEAN.read_bytes()
        for off in FE8_UNIT_MENU_ORGS:
            n = 4 if off == 0x59D1F8 else 1
            self.assertEqual(
                hack[off : off + n],
                clean[off : off + n],
                f"FE8 UnitMenu ORG ${off:X} overwrote FE7 ROM",
            )

    def test_fe7_unit_menu_items_pointer_is_repointed(self):
        hack = HACK.read_bytes()  # FE7_Hack.gba
        clean = CLEAN.read_bytes()
        ptr = struct.unpack_from("<I", hack, 0xB95AB4)[0]
        self.assertTrue(0x09000000 <= (ptr & ~1) < 0x0A000000, hex(ptr))
        vanilla = struct.unpack_from("<I", clean, 0xB95AB4)[0]
        self.assertEqual(vanilla, 0x08B95314)
        seize = clean[0xB95314 : 0xB95318]
        off = ptr - 0x08000000
        self.assertEqual(hack[off : off + 4], seize)

    def test_capture_does_not_hook_fe7_mid_functions(self):
        hack = HACK.read_bytes()  # FE7_Hack.gba
        clean = CLEAN.read_bytes()
        for off in (0x183B0, 0x22CD0, 0x32264, 0x846E4):
            self.assertEqual(hack[off : off + 4], clean[off : off + 4], hex(off))

    def test_skills_menu_def_items_pointer_is_in_freespace(self):
        hack = HACK.read_bytes()  # FE7_Hack.gba
        needle = bytes([1, 3, 10, 0, 0, 0, 0, 0])
        off = 0
        found = None
        while True:
            i = hack.find(needle, off)
            if i < 0:
                break
            items = struct.unpack_from("<I", hack, i + 8)[0]
            if 0x09000000 <= items < 0x0A000000:
                found = (i, items)
                break
            off = i + 1
        self.assertIsNotNone(found, "SkillsMenuDef not in ROM")
        _i, items = found
        helpb = struct.unpack_from("<I", hack, _i + 0x20)[0]
        self.assertEqual(helpb, 0x0804A909, hex(helpb))
        bpress = struct.unpack_from("<I", hack, _i + 0x18)[0]
        self.assertTrue(0x09000000 <= (bpress & ~1) < 0x0A000000, hex(bpress))
        onend = struct.unpack_from("<I", hack, _i + 0x10)[0]
        self.assertTrue(0x09000000 <= (onend & ~1) < 0x0A000000, hex(onend))

    def test_skills_menu_command_ids_are_unique(self):
        hack = HACK.read_bytes()  # FE7_Hack.gba
        needle = bytes([1, 3, 10, 0, 0, 0, 0, 0])
        off = 0
        items = None
        while True:
            i = hack.find(needle, off)
            if i < 0:
                break
            ptr = struct.unpack_from("<I", hack, i + 8)[0]
            if 0x09000000 <= ptr < 0x0A000000:
                items = ptr
                break
            off = i + 1
        self.assertIsNotNone(items)
        base = items - 0x08000000
        ids = []
        names = []
        firsts = []
        for n in range(24):
            e = base + n * 0x24
            nameptr, namemsg = struct.unpack_from("<IH", hack, e)
            if nameptr == 0 and namemsg == 0:
                break
            ids.append(hack[e + 9])
            names.append(nameptr)
            noff = (nameptr & 0x01FFFFFF)
            self.assertNotEqual(hack[noff], 0, hex(nameptr))
            firsts.append(hack[noff])
        self.assertGreaterEqual(len(ids), 8, ids)
        self.assertEqual(len(ids), len(set(ids)), ids)
        self.assertTrue(all(i < 0x80 for i in ids), ids)
        self.assertEqual(len(names), len(set(names)), names)
        self.assertEqual(len(firsts), len(set(firsts)), firsts)


if __name__ == "__main__":
    unittest.main()
