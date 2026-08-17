"""Learned skills must use FE7 BWL_GetEntry's table, not the next entry."""
import re
import struct
import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from lyn_bytes import lyn_to_bytes

ROOT = Path(__file__).resolve().parents[1]
CLEAN_ROM = ROOT / "FE7_clean.gba"
INTERNALS = ROOT / "EngineHacks" / "SkillSystem" / "Internals"

FE7_BWL_GET_ENTRY_LITERAL_OFF = 0xA0570
FE7_BWL_TABLE = 0x0203E790
WRONG_BASE = 0x0203E7A0

SOURCES = (
    INTERNALS / "addSkill.s",
    INTERNALS / "asm" / "GetSkills.s",
)
LYNS = (
    INTERNALS / "addSkill.lyn.event",
    INTERNALS / "asm" / "GetSkills.lyn.event",
)

ASSIGN_RE = re.compile(
    r"(?:\.set\s+BWLTable\s*,\s*|BWLTable\s*=\s*)(0x[0-9A-Fa-f]+)"
)


class Fe7BwlSkillStorageTests(unittest.TestCase):
    def test_clean_rom_bwl_get_entry_table_base(self):
        if not CLEAN_ROM.is_file():
            self.skipTest("FE7_clean.gba missing")
        word = struct.unpack_from("<I", CLEAN_ROM.read_bytes(), FE7_BWL_GET_ENTRY_LITERAL_OFF)[0]
        self.assertEqual(word, FE7_BWL_TABLE)

    def test_skill_writers_match_bwl_get_entry(self):
        for path in SOURCES:
            text = path.read_text(encoding="utf-8")
            match = ASSIGN_RE.search(text)
            self.assertIsNotNone(match, path.name)
            self.assertEqual(int(match.group(1), 16), FE7_BWL_TABLE, path.name)

    def test_lyns_use_fe7_bwl_table_literal(self):
        want = struct.pack("<I", FE7_BWL_TABLE)
        wrong = struct.pack("<I", WRONG_BASE)
        for path in LYNS:
            data = lyn_to_bytes(path)
            self.assertIn(want, data, path.name)
            self.assertNotIn(wrong, data, path.name)

    def test_debugger_writes_bwl_not_ewram_buffer(self):
        debugger = (
            ROOT / "EngineHacks" / "ExternalHacks" / "VeslyDebugger" / "Data" / "FE6_FE7.c"
        ).read_text(encoding="utf-8")
        ram_map = (ROOT / "Asm" / "ram_map_ewram.s").read_text(encoding="utf-8")
        skill_sys = (INTERNALS / "SkillSystem.event").read_text(encoding="utf-8")
        self.assertIn("0x0203E790", debugger)
        self.assertIn("pid * 0x10 + 1", debugger)
        self.assertNotIn("0x0203F540", debugger)
        self.assertNotIn("gLearnedSkillRam", ram_map)
        self.assertNotIn("LearnedSkillRamSize", ram_map)
        self.assertIn("PidStatsAddActAmt", skill_sys)
        self.assertIn("$9FFAC", skill_sys)
        self.assertIn("PidStatsAddFavval", skill_sys)
        self.assertNotIn("$A91D0", skill_sys)

    def test_getters_stop_at_first_empty_bwl_slot(self):
        skills = (INTERNALS / "asm" / "GetSkills.s").read_text(encoding="utf-8")
        tester = (
            INTERNALS / "NewSkillTester" / "_src" / "SkillTester.c"
        ).read_text(encoding="utf-8")
        self.assertIn("beq end_learned", skills)
        self.assertNotIn("skip_bwl", skills)
        self.assertIn("break;", tester)


if __name__ == "__main__":
    unittest.main()
