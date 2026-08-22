"""Execute NewSkillTester NihilTester/SkillTester under Unicorn.

Nihil is not a pre-battle stat writer — it is SkillTester returning false when
the opponent's buffer has Nihil and NegatedSkills[skillID] is set, during a
real or forecast battle. Old list-walking nihilTester*.s is unused; this is
the C path installed from SkillTester.lyn.event.
"""
import struct
import sys
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from Tools.thumb_harness import CODE_BASE, Harness, assemble, symbol_offsets

SRC = ROOT / "EngineHacks/SkillSystem/Internals/NewSkillTester/_src/SkillTester.s"
HACK = ROOT / "FE7_Hack.gba"

G_BATTLE_STATS = 0x0203A3D8
G_BATTLE_ACTOR = 0x0203A3F0
G_BATTLE_TARGET = 0x0203A470
ATK_BUF = 0x0202A9D4
DEF_BUF = 0x0202AA24
NEGATED = 0x0203F000
NIHIL_LINK = 0x0203F100
CATCH_LINK = 0x0203F104
CHAR_DATA = 0x0203F180
CLASS_DATA = 0x0203F1A0
PERSONAL = 0x0203F200
CLASS_SKILLS = 0x0203F300
CONFIG = 0x0203F400
UNIT_ATK = 0x0203E000
UNIT_DEF = 0x0203E080

NIHIL_ID = 114
LETHALITY_ID = 9
ATK_INDEX = 1
DEF_INDEX = 0x80
CHAR_ID = 5


STUB = """
	.macro SET_DATA name, value
	.global \\name
	.type   \\name, object
	.set    \\name, \\value
	.endm
	.macro SET_FUNC name, value
	.global \\name
	.type   \\name, function
	.set    \\name, \\value
	.endm
	SET_DATA gBattleStats, 0x0203A3D8
	SET_DATA gBattleActor, 0x0203A3F0
	SET_DATA gBattleTarget, 0x0203A470
	SET_DATA gAttackerSkillBuffer, 0x0202A9D4
	SET_DATA gDefenderSkillBuffer, 0x0202AA24
	SET_DATA gAuraSkillBuffer, 0x0202B024
	SET_DATA gUnitRangeBuffer, 0x0202B470
	SET_DATA NegatedSkills, 0x0203F000
	SET_DATA NihilIDLink, 0x0203F100
	SET_DATA CatchEmAllIDLink, 0x0203F104
	SET_DATA TraceIDLink, 0x0203F108
	SET_DATA PersonalSkillTable, 0x0203F200
	SET_DATA ClassSkillTable, 0x0203F300
	SET_DATA gSkillTestConfig, 0x0203F400
	SET_DATA PassiveSkillBit, 0x0203F408
	SET_DATA gUnitLookup, 0x0203F500
	SET_DATA AuraSkillTable, 0x0203F600
	SET_FUNC GetItemAttributes, 0x0801727D
	SET_FUNC GetItemData, 0x080174AD
	SET_FUNC GetUnitEquippedWeapon, 0x08016765
	SET_FUNC AreAllegiancesEqual, 0x080238C5
	SET_FUNC AreAllegiancesAllied, 0x080238B1
"""


def _linked_src() -> Path:
    text = STUB + "\n" + SRC.read_text(encoding="utf-8", errors="replace")
    tmp = Path(tempfile.gettempdir()) / "SkillTester_nihil_link.s"
    tmp.write_text(text, encoding="utf-8")
    return tmp


def _load():
    src = _linked_src()
    return assemble(src), symbol_offsets(src)


def _unit(h: Harness, addr: int, index: int) -> None:
    h.seed(addr + 0x00, struct.pack("<I", CHAR_DATA))
    h.seed(addr + 0x04, struct.pack("<I", CLASS_DATA))
    h.seed(addr + 0x0B, bytes([index]))


def _tables(h: Harness, negated_ids=(), nihil_id=NIHIL_ID, catch_id=255, personal=0) -> None:
    table = bytearray(256)
    for sid in negated_ids:
        table[sid] = 1
    h.seed(NEGATED, bytes(table))
    h.seed(NIHIL_LINK, struct.pack("<I", nihil_id))
    h.seed(CATCH_LINK, struct.pack("<I", catch_id))
    h.seed(CHAR_DATA, b"\x00" * 8)
    h.seed(CHAR_DATA + 0x04, bytes([CHAR_ID]))
    h.seed(CLASS_DATA, b"\x00" * 8)
    pers = bytearray(256)
    pers[CHAR_ID] = personal
    h.seed(PERSONAL, bytes(pers))
    h.seed(CLASS_SKILLS, bytes(256))
    h.seed(CONFIG, struct.pack("<HBB", 0, 7, 0))


def _buffer(h: Harness, addr: int, last: int, skills: list[int]) -> None:
    blob = bytes([last & 0xFF] + [s & 0xFF for s in skills] + [0])
    h.seed(addr, blob)


def _halt(code: bytes) -> int:
    return (len(code) + 1) & ~1


def _run(h: Harness, code: bytes, offsets, fn: str, r0: int, r1: int) -> int:
    stop = _halt(code)
    return h.run(
        stop,
        regs={"r0": r0, "r1": r1, "lr": (CODE_BASE + stop) | 1},
        entry_offset=offsets[fn],
    )["r0"]


def _call(code, offsets, fn: str, r0: int, r1: int, config: int) -> int:
    h = Harness(code, skill_present=True)
    _tables(h, negated_ids=(LETHALITY_ID,), personal=NIHIL_ID)
    h.seed(G_BATTLE_STATS, struct.pack("<H", config))
    _unit(h, UNIT_ATK, ATK_INDEX)
    _unit(h, UNIT_DEF, DEF_INDEX)
    _unit(h, G_BATTLE_ACTOR, ATK_INDEX)
    _unit(h, G_BATTLE_TARGET, DEF_INDEX)
    _buffer(h, ATK_BUF, ATK_INDEX, [LETHALITY_ID])
    _buffer(h, DEF_BUF, DEF_INDEX, [NIHIL_ID])
    return _run(h, code, offsets, fn, r0, r1)


class NihilExecutionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        try:
            cls.code, cls.offsets = _load()
        except Exception as exc:
            raise unittest.SkipTest(f"thumb harness unavailable: {exc}") from exc
        for name in ("NihilTester", "MakeSkillBuffer"):
            if name not in cls.offsets:
                raise unittest.SkipTest(f"missing {name} in SkillTester.s")

    def test_nihil_tester_true_when_defender_has_nihil(self):
        r0 = _call(self.code, self.offsets, "NihilTester", UNIT_ATK, LETHALITY_ID, 1)
        self.assertEqual(r0, 1)

    def test_nihil_tester_true_on_forecast(self):
        r0 = _call(self.code, self.offsets, "NihilTester", UNIT_ATK, LETHALITY_ID, 2)
        self.assertEqual(r0, 1)

    def test_nihil_tester_false_outside_battle(self):
        r0 = _call(self.code, self.offsets, "NihilTester", UNIT_ATK, LETHALITY_ID, 0)
        self.assertEqual(r0, 0)

    def test_nihil_tester_false_when_skill_not_negatable(self):
        h = Harness(self.code, skill_present=True)
        _tables(h, negated_ids=(), personal=NIHIL_ID)
        h.seed(G_BATTLE_STATS, struct.pack("<H", 1))
        _unit(h, UNIT_ATK, ATK_INDEX)
        _unit(h, G_BATTLE_ACTOR, ATK_INDEX)
        _unit(h, G_BATTLE_TARGET, DEF_INDEX)
        r0 = _run(h, self.code, self.offsets, "NihilTester", UNIT_ATK, LETHALITY_ID)
        self.assertEqual(r0, 0)

    def test_nihil_tester_false_when_opponent_lacks_nihil(self):
        h = Harness(self.code, skill_present=True)
        _tables(h, negated_ids=(LETHALITY_ID,), personal=0)
        h.seed(G_BATTLE_STATS, struct.pack("<H", 1))
        _unit(h, UNIT_ATK, ATK_INDEX)
        _unit(h, G_BATTLE_ACTOR, ATK_INDEX)
        _unit(h, G_BATTLE_TARGET, DEF_INDEX)
        _buffer(h, DEF_BUF, DEF_INDEX, [NIHIL_ID])
        r0 = _run(h, self.code, self.offsets, "NihilTester", UNIT_ATK, LETHALITY_ID)
        self.assertEqual(r0, 0)

    def test_nihil_tester_uses_attacker_for_defender_unit(self):
        h = Harness(self.code, skill_present=True)
        _tables(h, negated_ids=(LETHALITY_ID,), personal=NIHIL_ID)
        h.seed(G_BATTLE_STATS, struct.pack("<H", 1))
        _unit(h, UNIT_DEF, DEF_INDEX)
        _unit(h, G_BATTLE_ACTOR, ATK_INDEX)
        _unit(h, G_BATTLE_TARGET, DEF_INDEX)
        r0 = _run(h, self.code, self.offsets, "NihilTester", UNIT_DEF, LETHALITY_ID)
        self.assertEqual(r0, 1)

    def test_nihil_finds_personal_skill_when_buffer_clobbered(self):
        h = Harness(self.code, skill_present=True)
        _tables(h, negated_ids=(LETHALITY_ID,), personal=NIHIL_ID)
        h.seed(G_BATTLE_STATS, struct.pack("<H", 1))
        _unit(h, UNIT_ATK, ATK_INDEX)
        _unit(h, G_BATTLE_ACTOR, ATK_INDEX)
        _unit(h, G_BATTLE_TARGET, DEF_INDEX)
        h.seed(DEF_BUF, struct.pack("<I", UNIT_DEF))
    def test_nihil_finds_learned_skill(self):
        h = Harness(self.code, skill_present=True)
        _tables(h, negated_ids=(LETHALITY_ID,), personal=0)
        h.seed(G_BATTLE_STATS, struct.pack("<H", 1))
        _unit(h, UNIT_ATK, ATK_INDEX)
        _unit(h, G_BATTLE_ACTOR, ATK_INDEX)
        _unit(h, G_BATTLE_TARGET, DEF_INDEX)
        h.seed(G_BATTLE_TARGET + 0x32, bytes([NIHIL_ID, 0]))
        r0 = _run(h, self.code, self.offsets, "NihilTester", UNIT_ATK, LETHALITY_ID)
        self.assertEqual(r0, 1)


@unittest.skipUnless(HACK.exists(), "FE7_Hack.gba missing")
class NihilRomTests(unittest.TestCase):
    def test_negated_skills_is_id_index_table(self):
        rom = HACK.read_bytes()
        prefix = bytes.fromhex("d8a30302")
        mid = bytes.fromhex("70a40302f0a30302")
        found = None
        start = 0
        while True:
            i = rom.find(prefix, start)
            if i < 0:
                break
            if rom[i + 8 : i + 16] == mid:
                found = struct.unpack_from("<I", rom, i + 4)[0]
                break
            start = i + 1
        self.assertIsNotNone(found, "NihilTester literal pool missing from FE7_Hack.gba")
        table = (found & ~1) - 0x08000000
        self.assertEqual(rom[table + LETHALITY_ID], 1)
        self.assertEqual(rom[table + NIHIL_ID], 0)


if __name__ == "__main__":
    unittest.main()
