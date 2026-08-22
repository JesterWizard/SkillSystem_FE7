"""Trace: during forecast/combat, SkillTester treats the holder as having
the opponent's first listed skill. The copy lives in the skill buffer only,
so leaving the forecast or finishing combat drops it with the battle structs.
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

G_BATTLE_STATS = 0x0203A3D8
G_BATTLE_ACTOR = 0x0203A3F0
G_BATTLE_TARGET = 0x0203A470
ATK_BUF = 0x0202A9D4
DEF_BUF = 0x0202AA24
NEGATED = 0x0203F000
NIHIL_LINK = 0x0203F100
CATCH_LINK = 0x0203F104
TRACE_LINK = 0x0203F108
CHAR_ATK = 0x0203F180
CHAR_DEF = 0x0203F1A0
CLASS_DATA = 0x0203F1C0
PERSONAL = 0x0203F200
CLASS_SKILLS = 0x0203F300
CONFIG = 0x0203F400
DUMMY_ITEM = 0x0203F480
UNIT_ATK = 0x0203E000
UNIT_DEF = 0x0203E080

TRACE_ID = 131
COPIED_ID = 9
ATK_INDEX = 1
DEF_INDEX = 0x80
ATK_CHAR = 5
DEF_CHAR = 6

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
	SET_FUNC GetItemAttributes, 0x0203F711
	SET_FUNC GetItemData, 0x0203F701
	SET_FUNC GetUnitEquippedWeapon, 0x0203F715
	SET_FUNC AreAllegiancesEqual, 0x0203F711
	SET_FUNC AreAllegiancesAllied, 0x0203F711
"""


def _linked_src() -> Path:
    text = STUB + "\n" + SRC.read_text(encoding="utf-8", errors="replace")
    tmp = Path(tempfile.gettempdir()) / "SkillTester_trace_link.s"
    tmp.write_text(text, encoding="utf-8")
    return tmp


def _load():
    src = _linked_src()
    return assemble(src), symbol_offsets(src)


def _unit(h: Harness, addr: int, index: int, char_addr: int) -> None:
    h.seed(addr + 0x00, struct.pack("<I", char_addr))
    h.seed(addr + 0x04, struct.pack("<I", CLASS_DATA))
    h.seed(addr + 0x0B, bytes([index]))
    h.seed(addr + 0x1E, b"\x00" * 10)
    h.seed(addr + 0x32, bytes(7))


def _tables(h: Harness, atk_personal: int, def_personal: int) -> None:
    h.seed(NEGATED, bytes(256))
    h.seed(NIHIL_LINK, struct.pack("<I", 114))
    h.seed(CATCH_LINK, struct.pack("<I", 255))
    h.seed(TRACE_LINK, struct.pack("<I", TRACE_ID))
    h.seed(CHAR_ATK, b"\x00" * 8)
    h.seed(CHAR_ATK + 0x04, bytes([ATK_CHAR]))
    h.seed(CHAR_DEF, b"\x00" * 8)
    h.seed(CHAR_DEF + 0x04, bytes([DEF_CHAR]))
    h.seed(CLASS_DATA, b"\x00" * 8)
    pers = bytearray(256)
    pers[ATK_CHAR] = atk_personal
    pers[DEF_CHAR] = def_personal
    h.seed(PERSONAL, bytes(pers))
    h.seed(CLASS_SKILLS, bytes(256))
    h.seed(CONFIG, struct.pack("<HBB", 0, 7, 0))
    h.seed(DUMMY_ITEM, bytes(0x24))
    h.map_page(0x02000000, 0x40000)
    # Thumb thunks in EWRAM: GetItemData returns DUMMY_ITEM; others return 0.
    h.seed(0x0203F700, bytes.fromhex("014870470000000080F40302"))
    h.seed(0x0203F710, bytes.fromhex("0020704700207047"))


def _halt(code: bytes) -> int:
    return (len(code) + 1) & ~1


def _skills(h: Harness, buf: int) -> list[int]:
    raw = h.read(buf, 12)
    out = []
    for b in raw[1:]:
        if b == 0:
            break
        out.append(b)
    return out


def _make_buffer(code, offsets, config: int, atk_personal: int, def_personal: int,
                 fn="MakeSkillBuffer", unit=UNIT_ATK, buf=ATK_BUF):
    h = Harness(code, skill_present=True)
    _tables(h, atk_personal, def_personal)
    h.seed(G_BATTLE_STATS, struct.pack("<H", config))
    _unit(h, UNIT_ATK, ATK_INDEX, CHAR_ATK)
    _unit(h, UNIT_DEF, DEF_INDEX, CHAR_DEF)
    _unit(h, G_BATTLE_ACTOR, ATK_INDEX, CHAR_ATK)
    _unit(h, G_BATTLE_TARGET, DEF_INDEX, CHAR_DEF)
    h.seed(buf, bytes(12))
    stop = _halt(code)
    h.run(
        stop,
        regs={"r0": unit, "r1": buf, "lr": (CODE_BASE + stop) | 1},
        entry_offset=offsets[fn],
    )
    return _skills(h, buf)


class TraceExecutionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        try:
            cls.code, cls.offsets = _load()
        except Exception as exc:
            raise unittest.SkipTest(f"thumb harness unavailable: {exc}") from exc
        if "MakeSkillBuffer" not in cls.offsets:
            raise unittest.SkipTest("missing MakeSkillBuffer in SkillTester.s")

    def test_forecast_copies_opponent_first_skill(self):
        skills = _make_buffer(self.code, self.offsets, 2, TRACE_ID, COPIED_ID)
        self.assertIn(TRACE_ID, skills)
        self.assertIn(COPIED_ID, skills)

    def test_no_copy_without_trace(self):
        skills = _make_buffer(self.code, self.offsets, 2, 0, COPIED_ID)
        self.assertNotIn(COPIED_ID, skills)

    def test_no_copy_outside_battle(self):
        skills = _make_buffer(self.code, self.offsets, 0, TRACE_ID, COPIED_ID)
        self.assertEqual(skills, [TRACE_ID])


if __name__ == "__main__":
    unittest.main()
