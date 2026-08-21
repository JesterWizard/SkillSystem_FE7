"""DEC-103: Pre-Battle skills are enabled and wired into loops."""
import json
import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DEFS = ROOT / "EngineHacks" / "SkillSystem" / "skill_definitions.event"
LOOP = ROOT / "EngineHacks" / "Necessary" / "CalcLoops" / "PreBattleCalcLoop" / "PreBattleCalcLoop.event"
CALC = ROOT / "EngineHacks" / "Necessary" / "CalcLoops" / "CalcLoops.event"
DOUBLE = ROOT / "EngineHacks" / "Necessary" / "CalcLoops" / "CanUnitDoubleCalcLoop" / "CanUnitDoubleCalcLoop.event"
UNWIND = ROOT / "EngineHacks" / "Necessary" / "CalcLoops" / "CanUnitDoubleCalcLoop" / "NewBattleGetFollowUpOrder.c"
PROC = ROOT / "EngineHacks" / "Necessary" / "CalcLoops" / "BattleProcCalcLoop" / "BattleProcCalcLoop.event"
POST = ROOT / "EngineHacks" / "Necessary" / "CalcLoops" / "PostBattleCalcLoop" / "PostBattleCalcLoop.event"
PRE = ROOT / "EngineHacks" / "SkillSystem" / "Skills" / "PreBattleSkills" / "PreBattleSkills.event"
MASTER = ROOT / "EngineHacks" / "SkillSystem" / "Skills" / "MasterSkillInstaller.event"
TESTER = ROOT / "EngineHacks" / "SkillSystem" / "Internals" / "NewSkillTester" / "_src" / "SkillTester.c"
SNAPSHOT = Path(__file__).with_name("skill_id_snapshot.json")
DESC = ROOT / "EngineHacks" / "SkillSystem" / "skill_descriptions.event"
LOYALTY = ROOT / "EngineHacks" / "SkillSystem" / "Skills" / "PreBattleSkills" / "Loyalty" / "Loyalty.s"
THIGHS = ROOT / "EngineHacks" / "SkillSystem" / "Skills" / "PostBattleSkills" / "Cultured" / "NiceThighsTester.s"
PREBATTLE_DIR = ROOT / "EngineHacks" / "SkillSystem" / "Skills" / "PreBattleSkills"
UNSAFE_PREBATTLE = re.compile(
    r"MovGetter|prMovGetter|0x0?8018B44|0x0?8018B45|\bswi\b|\bsvc\b",
    re.I,
)

COMMENT_RE = re.compile(r"/\*.*?\*/", re.S)
DEFINE_RE = re.compile(r"^#define\s+(\w+ID)\s+(\S+)")
SKILL_OFF = 255

DEC103 = [
    ("AssassinateID", 139),
    ("CatchEmAllID", 151),
    ("ChargePlusID", 168),
    ("CulturedID", 121),
    ("DefiantDefID", 75),
    ("DefiantLckID", 74),
    ("DefiantMagID", 71),
    ("DefiantResID", 76),
    ("DefiantSklID", 72),
    ("DefiantSpdID", 73),
    ("DefiantStrID", 70),
    ("FortressDefenseID", 77),
    ("FortressResistanceID", 78),
    ("FullMetalBodyID", 86),
    ("HolyAuraID", 171),
    ("IndoorFighterID", 217),
    ("LethalityID", 9),
    ("LoyaltyID", 174),
    ("PersonalityID", 116),
    ("NiceThighsID", 115),
    ("NihilID", 114),
    ("OutdoorFighterID", 218),
    ("SilentPrideID", 181),
    ("SteadyBrawlerID", 44),
    ("TempestID", 45),
    ("SerenityID", 130),
    ("ThighdeologyID", 152),
    ("TraceID", 131),
]


def _active(path: Path) -> str:
    text = COMMENT_RE.sub("", path.read_text(encoding="utf-8"))
    return "\n".join(
        line for line in text.splitlines() if not line.lstrip().startswith("//")
    )


EA_EMIT_RE = re.compile(r"^(ALIGN|SHORT|BYTE|WORD|POIN)\b(.*)$", re.I)


def _ea_emitted_size(text: str) -> int:
    size = 0
    for raw in COMMENT_RE.sub("", text).splitlines():
        line = raw.split(";")[0].strip()
        if not line or line.lstrip().startswith("//") or line.startswith("#"):
            continue
        m = EA_EMIT_RE.match(line)
        if not m:
            continue
        op, rest = m.group(1).upper(), m.group(2)
        args = rest.replace(",", " ").split()
        if op == "ALIGN":
            n = int(args[0], 0)
            size = (size + n - 1) // n * n
        elif op == "SHORT":
            size += 2 * len(args)
        elif op == "BYTE":
            size += len(args)
        elif op in ("WORD", "POIN"):
            if size % 4:
                raise AssertionError(f"unaligned {op} at +{size}: {line}")
            size += 4 * max(len(args), 1)
    return size


def _asm_code(path: Path) -> str:
    lines = []
    for line in _active(path).splitlines():
        line = line.split("@", 1)[0]
        if line.strip():
            lines.append(line)
    return "\n".join(lines)


def _ids(text: str) -> dict[str, int]:
    resolved = {}
    for line in text.splitlines():
        m = DEFINE_RE.match(line)
        if not m:
            continue
        name, rhs = m.group(1), m.group(2)
        if re.fullmatch(r"\w+ID", rhs):
            continue
        resolved[name] = SKILL_OFF if rhs == "SKILL_OFF" else int(rhs)
    return resolved


class PreBattleDec103Tests(unittest.TestCase):
    def test_prebattle_loop_initializes_buffers_first(self):
        loop = _active(LOOP)
        self.assertRegex(
            loop,
            r"BtlLoopList:\s*\r?\nPOIN InitializePreBattleLoop",
        )

    def test_skilltester_rejects_empty_battle_target(self):
        tester = TESTER.read_text(encoding="utf-8")
        self.assertIn("!unit->pCharacterData || !unit->pClassData", tester)
        self.assertIn("itemData && IsSkillIDValid(itemData->skill)", tester)
        self.assertIn("i < limit && auraBuffer[i].skillID", tester)

    def test_opponent_skills_skip_stat_screen_defender(self):
        for rel in (
            Path("EngineHacks/SkillSystem/Skills/PreBattleSkills/Cultured/Cultured.s"),
            Path("EngineHacks/SkillSystem/Skills/PreBattleSkills/Thotslayer/Thotslayer.s"),
            Path("EngineHacks/SkillSystem/Skills/PreBattleSkills/Trace/trace.s"),
            Path("EngineHacks/SkillSystem/Skills/PreBattleSkills/ChargePlus/ChargePlus.s"),
            Path("EngineHacks/SkillSystem/Skills/PreBattleSkills/SteadyBrawler/SteadyBrawler.s"),
        ):
            src = (ROOT / rel).read_text(encoding="utf-8")
            self.assertIn("ldr", src)
            self.assertIn("cmpr5,#0", src.replace(" ", "").replace("\t", ""))
            self.assertRegex(src, r"ldr\s+r1,\s*\[r5,\s*#4\]")
            self.assertIn("beq", src)

    def test_doorfighter_and_loyalty_guard_invalid_data(self):
        indoor = (
            ROOT
            / "EngineHacks/SkillSystem/Skills/PreBattleSkills/DoorFighter/IndoorFighter.s"
        ).read_text(encoding="utf-8")
        outdoor = (
            ROOT
            / "EngineHacks/SkillSystem/Skills/PreBattleSkills/DoorFighter/OutdoorFighter.s"
        ).read_text(encoding="utf-8")
        loyalty = LOYALTY.read_text(encoding="utf-8")
        for src in (indoor, outdoor):
            self.assertIn("cmp r0,#0xFF", src)
            self.assertIn("cmp r1,#0xFF", src)
            self.assertRegex(src, r"cmp\s+r2,#0")
        self.assertIn("cmp r5,#0", loyalty)
        self.assertIn("beq Loop", loyalty)
        self.assertIn("0x8018D0D", loyalty)
        self.assertNotIn("0x202BD50", loyalty)

    def test_chargeplus_brave_only_when_full_movement(self):
        # gActionData+0x10 is ActionBattleStruct "Squares moved this turn"
        # (confirmed by the labeled FE7 decomp at 0x8018206, which feeds it
        # straight into BWL_AddTilesMoved). "Used up all movement" is
        # spaces_moved == unit_movement.
        def applies(spaces_moved, unit_movement):
            return unit_movement > 0 and spaces_moved == unit_movement

        self.assertTrue(applies(5, 5))
        self.assertFalse(applies(4, 5))
        self.assertFalse(applies(1, 5))
        self.assertFalse(applies(0, 5))
        self.assertFalse(applies(5, 0))

        src = (
            ROOT
            / "EngineHacks/SkillSystem/Skills/PreBattleSkills/ChargePlus/ChargePlus.s"
        )
        code = _asm_code(src)
        self.assertIn("0x12", code)
        self.assertIn("0x1D", code)
        self.assertIn("0x203A85C", code)
        self.assertIn("#0x10", code)
        self.assertRegex(code, r"cmp\s+r1,\s*r6")
        self.assertRegex(code, r"bne\s+GoBack")
        self.assertIn("0x20", code)
        self.assertNotRegex(code, r"bgt\s+GoBack")
        self.assertNotRegex(code, r"sub\s+r1,\s*r6,\s*r1")
        self.assertNotIn("CelerityID", code)
        self.assertNotIn("PoiseID", code)
        self.assertNotIn("MovGetter", code)
        self.assertNotIn("GetUnit", code)
        self.assertNotIn("RecordSpacesMoved", code)

    def test_prebattle_lyn_events_word_aligned(self):
        for path in PREBATTLE_DIR.rglob("*.lyn.event"):
            size = _ea_emitted_size(path.read_text(encoding="utf-8"))
            self.assertEqual(
                size % 4,
                0,
                f"{path.relative_to(ROOT)} emits {size} bytes (need % 4 == 0 before POIN)",
            )

    def test_prebattle_asm_avoids_forecast_unsafe_calls(self):
        for path in PREBATTLE_DIR.rglob("*.s"):
            if path.name.lower() == "roll12.s":
                continue
            code = _asm_code(path)
            hit = UNSAFE_PREBATTLE.search(code)
            self.assertIsNone(hit, f"{path.relative_to(ROOT)}: {hit.group(0) if hit else ''}")


    def test_catalog_ids_match_issue_list(self):
        ids = _ids(DEFS.read_text(encoding="utf-8"))
        for name, sid in DEC103:
            self.assertEqual(ids[name], sid, name)
        self.assertEqual(ids["Roll12ID"], SKILL_OFF)

    def test_snapshot_matches_definitions(self):
        ids = _ids(DEFS.read_text(encoding="utf-8"))
        expected = json.loads(SNAPSHOT.read_text(encoding="utf-8"))
        self.assertEqual(ids, expected)

    def test_prebattle_loop_wires_new_skills(self):
        loop = _active(LOOP)
        for name in (
            "AssassinateDamageBonus",
            "ChargePlus",
            "HolyAura",
            "Cultured",
            "SteadyBrawler",
            "IndoorFighter",
            "OutdoorFighter",
            "SilentPride",
            "Loyalty",
            "Thighdeology",
            "LethalitySkill",
            "TraceSkill",
        ):
            self.assertRegex(loop, rf"\b{name}\b")
        self.assertIn("AuraSkillEntry(NiceThighsID)", loop)
        self.assertRegex(loop, r"AuraSkillTable:\s*\nFILL 256".replace(r"\n", r"\r?\n"))

    def test_installers_and_stat_modifiers(self):
        pre = _active(PRE)
        self.assertIn("HolyAura/HolyAura.lyn.event", pre)
        self.assertIn("ChargePlus/ChargePlus.lyn.event", pre)
        self.assertIn("Cultured/Cultured.event", pre)
        self.assertIn("SteadyBrawler/SteadyBrawler.lyn.event", pre)
        self.assertNotIn("0x08018B45", pre)
        self.assertNotIn("prMovGetter", pre)
        self.assertNotIn("WORD CelerityID", pre)
        self.assertNotIn("WORD PoiseID", pre)
        master = _active(MASTER)
        self.assertIn("StatModifierSkills/StatModifierSkills.event", master)

    def test_lethality_proc_and_cultured_post_combat(self):
        proc = _active(PROC)
        self.assertIn("Proc_Lethality", proc)
        post = _active(POST)
        self.assertIn("CulturedPostCombat", post)

    def test_catchemall_and_fe7_ports(self):
        tester = TESTER.read_text(encoding="utf-8")
        self.assertIn("CatchEmAllIDLink", tester)
        loyalty = LOYALTY.read_text(encoding="utf-8")
        self.assertIn("0x2D", loyalty)
        self.assertNotIn("0x3B", loyalty)
        thighs = THIGHS.read_text(encoding="utf-8")
        self.assertIn("0x8018D0D", thighs)
        self.assertNotIn("0x8019431", thighs)

    def test_assassinate_followup_hooks_battle_unwind(self):
        calc = _active(CALC)
        self.assertIn("CanUnitDoubleCalcLoop/CanUnitDoubleCalcLoop.event", calc)
        double = _active(DOUBLE)
        self.assertIn("NewBattleGetFollowUpOrder.lyn.event", double)
        unwind = UNWIND.read_text(encoding="utf-8")
        self.assertIn("hasAssassinate", unwind)
        self.assertIn("DoesUnitImmediatelyFollowUp", unwind)
        self.assertIn("gpCurrentRound", unwind)

    def test_descriptions_cover_enabled_skills(self):
        desc = _active(DESC)
        for name, _ in DEC103:
            self.assertRegex(desc, rf"SkillDescription\(\s*{name}\s*,")


if __name__ == "__main__":
    unittest.main()
