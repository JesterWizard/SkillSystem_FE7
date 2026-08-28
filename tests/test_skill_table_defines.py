"""
Personal, class, and character skill tables can use any catalog name
from skill_definitions.event (CantoID, CritUpID, SKILL_OFF, ...).
"""
import re
import struct
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from lyn_bytes import lyn_to_bytes

ROOT = Path(__file__).resolve().parents[1]
DEFS = ROOT / "EngineHacks" / "SkillSystem" / "skill_definitions.event"
TABLE_DEFS = ROOT / "Tables" / "TableDefinitions.event"
PERSONAL_EVENT = ROOT / "Tables" / "NightmareModules" / "Skills" / "PersonalSkillEditor.event"
CLASS_EVENT = ROOT / "Tables" / "NightmareModules" / "Skills" / "ClassSkillEditor.event"
BYTE_ROW_RE = re.compile(r"^BYTE\s+(\S+)")
CLEAN_ROM = ROOT / "FE7_clean.gba"
HACK_ROM = ROOT / "FE7_Hack.gba"
COLORZCORE = ROOT / "EventAssembler" / "ColorzCore.exe"
C2EA_DIR = ROOT / "Tools" / "C2EA"
GET_SKILLS_LYN = ROOT / "EngineHacks" / "SkillSystem" / "Internals" / "asm" / "GetSkills.lyn.event"

DEFINE_RE = re.compile(r"^#define\s+(\w+)\s+(\S+)")

NMM = """# Test skill byte table

1
Test
0xD00000
1
1
NULL
NULL

Skill
0
1
NEHU
NULL
"""


def _catalog(text: str) -> dict[str, str]:
    mapping = {"SKILL_OFF": "255"}
    for line in text.splitlines():
        m = DEFINE_RE.match(line)
        if not m:
            continue
        name, rhs = m.group(1), m.group(2)
        if name == "SKILL_DEFINITIONS":
            continue
        mapping[name] = rhs
    return mapping


def _resolve(name, mapping, seen=None):
    seen = seen or frozenset()
    if name in seen:
        raise AssertionError(f"cyclic skill define {name}")
    if name not in mapping:
        raise AssertionError(f"unknown skill define {name}")
    rhs = mapping[name]
    if rhs.isdigit():
        return int(rhs)
    if rhs.lower().startswith("0x"):
        return int(rhs, 16)
    return _resolve(rhs, mapping, seen | {name})


class SkillTableDefineTests(unittest.TestCase):
    def test_table_definitions_includes_skill_catalog(self):
        text = TABLE_DEFS.read_text(encoding="utf-8")
        self.assertIn("skill_definitions.event", text)

    def test_skill_definitions_can_be_included_twice(self):
        if not CLEAN_ROM.is_file() or not COLORZCORE.is_file():
            self.skipTest("FE7_clean.gba or ColorzCore.exe missing")
        # ColorzCore resolves #include relative to the input file, not cwd,
        # and also fails on long C:/ absolute paths. Copy the catalog next
        # to the temp event so a basename include works.
        event = (
            '#include "skill_definitions.event"\n'
            '#include "skill_definitions.event"\n'
            "ORG 0\n"
            "BYTE CantoID\n"
        )
        with tempfile.TemporaryDirectory() as tmp:
            tmp_path = Path(tmp)
            rom = tmp_path / "out.gba"
            src = tmp_path / "test.event"
            (tmp_path / "skill_definitions.event").write_bytes(DEFS.read_bytes())
            rom.write_bytes(CLEAN_ROM.read_bytes())
            src.write_text(event, encoding="ascii")
            result = subprocess.run(
                [str(COLORZCORE), "A", "FE7", f"-output:{rom}", f"-input:{src}"],
                cwd=str(COLORZCORE.parent),
                capture_output=True,
                text=True,
            )
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
            self.assertEqual(rom.read_bytes()[:1], b"\xff")

    def test_c2ea_keeps_skill_id_names_in_byte_cells(self):
        sys.path.insert(0, str(C2EA_DIR))
        import c2ea  # noqa: E402

        with tempfile.TemporaryDirectory() as tmp:
            tmp_path = Path(tmp)
            nmm = tmp_path / "SkillByte.nmm"
            csv_path = tmp_path / "SkillByte.csv"
            out = tmp_path / "SkillByte.event"
            nmm.write_text(NMM, encoding="ascii")
            csv_path.write_text(
                '"0xD00000","Skill"\n"Lyn","CritUpID"\n',
                encoding="ascii",
            )
            c2ea.process(str(csv_path), str(nmm), str(out), None)
            self.assertIn("CritUpID", out.read_text(encoding="utf-8"))

    def test_personal_and_class_event_names_are_catalog_defines(self):
        mapping = _catalog(DEFS.read_text(encoding="utf-8"))
        for path in (PERSONAL_EVENT, CLASS_EVENT):
            for i, cell in _skill_bytes(path):
                if _is_numeric(cell):
                    continue
                self.assertIn(
                    cell,
                    mapping,
                    f"{path.name} index {i} uses {cell}, which is not in skill_definitions.event",
                )

    def test_named_personal_skills_assemble_to_catalog_ids(self):
        if not CLEAN_ROM.is_file() or not COLORZCORE.is_file():
            self.skipTest("FE7_clean.gba or ColorzCore.exe missing")
        mapping = _catalog(DEFS.read_text(encoding="utf-8"))
        named = [
            (i, cell)
            for i, cell in _skill_bytes(PERSONAL_EVENT)
            if cell and not _is_numeric(cell)
        ]
        if not named:
            return
        bytes_src = " ".join(name for _, name in named)
        event = (
            f'#include "{TABLE_DEFS.as_posix()}"\n'
            "ORG 0\n"
            f"BYTE {bytes_src}\n"
        )
        with tempfile.TemporaryDirectory() as tmp:
            tmp_path = Path(tmp)
            rom = tmp_path / "out.gba"
            src = tmp_path / "test.event"
            rom.write_bytes(CLEAN_ROM.read_bytes())
            src.write_text(event, encoding="ascii")
            result = subprocess.run(
                [str(COLORZCORE), "A", "FE7", f"-output:{rom}", f"-input:{src}"],
                cwd=str(COLORZCORE.parent),
                capture_output=True,
                text=True,
            )
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
            got = rom.read_bytes()[: len(named)]
            expected = bytes(_resolve(name, mapping) for _, name in named)
            self.assertEqual(got, expected)

    def test_hack_rom_personal_table_matches_event_catalog_names(self):
        if not HACK_ROM.is_file():
            self.skipTest("FE7_Hack.gba missing")
        mapping = _catalog(DEFS.read_text(encoding="utf-8"))
        rom = HACK_ROM.read_bytes()
        blob = lyn_to_bytes(GET_SKILLS_LYN)
        idx = rom.find(blob)
        self.assertNotEqual(idx, -1, "GetSkills lyn blob not found in FE7_Hack.gba")
        table_ptr = struct.unpack_from("<I", rom, idx + len(blob))[0]
        table_off = table_ptr & 0x01FFFFFF
        for char_id, cell in _skill_bytes(PERSONAL_EVENT):
            if _is_numeric(cell):
                continue
            expected = _resolve(cell, mapping)
            got = rom[table_off + char_id]
            self.assertEqual(
                got,
                expected,
                f"PersonalSkillTable[0x{char_id:02X}] is {got}, "
                f"event {cell} should assemble to {expected}",
            )
            self.assertNotIn(got, (0, 255), f"{cell} must be a listable personal skill")

    def test_level_up_skills_walk_c2ea_word_list_pointers(self):
        """c2ea emits WORD labels. At FreeSpace 0x1000000 that is 0x01xxxxxx, not POIN 0x09."""
        src = (
            ROOT
            / "EngineHacks"
            / "SkillSystem"
            / "Internals"
            / "asm"
            / "GetUnitLevelSkills.s"
        ).read_text(encoding="utf-8")
        self.assertIn("char_check_rom_banks", src)
        self.assertIn("class_check_rom_banks", src)


def _skill_bytes(path: Path) -> list[tuple[int, str]]:
    rows = []
    for line in path.read_text(encoding="utf-8").splitlines():
        m = BYTE_ROW_RE.match(line.split("//")[0].strip())
        if m:
            rows.append((len(rows), m.group(1)))
    return rows


def _is_numeric(cell: str) -> bool:
    try:
        int(cell, 0)
        return True
    except ValueError:
        return False


if __name__ == "__main__":
    unittest.main()
