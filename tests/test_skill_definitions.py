"""
Skill IDs are toggled with SkillEnabled/SkillDisabled, not by overwriting the catalog ID.

Disabled skills must still assemble as 255; enabled skills keep their assigned IDs.
"""
import json
import re
import subprocess
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DEFS = ROOT / "EngineHacks" / "SkillSystem" / "skill_definitions.event"
SNAPSHOT = Path(__file__).with_name("skill_id_snapshot.json")
CLEAN_ROM = ROOT / "FE7_clean.gba"
COLORZCORE = ROOT / "EventAssembler" / "ColorzCore.exe"

DEFINE_RE = re.compile(r"^#define\s+(\w+ID)\s+(\S+)")
ENABLED_RE = re.compile(r"^SkillEnabled\((\d+)\)$")
DISABLED_RE = re.compile(r"^SkillDisabled\((\d+)\)$")
ALIAS_RE = re.compile(r"^\w+ID$")
SKILL_OFF = 255


def _catalog_defines(text: str) -> list[tuple[str, str]]:
    rows = []
    for line in text.splitlines():
        m = DEFINE_RE.match(line)
        if not m:
            continue
        name, rhs = m.group(1), m.group(2)
        if ALIAS_RE.fullmatch(rhs):
            continue
        rows.append((name, rhs))
    return rows


def _resolved_ids(text: str) -> dict[str, int]:
    resolved = {}
    for name, rhs in _catalog_defines(text):
        en = ENABLED_RE.fullmatch(rhs)
        dis = DISABLED_RE.fullmatch(rhs)
        if en:
            resolved[name] = int(en.group(1))
        elif dis:
            resolved[name] = SKILL_OFF
        else:
            raise AssertionError(f"{name} must use SkillEnabled(id) or SkillDisabled(id), got {rhs}")
    return resolved


class SkillDefinitionToggleTests(unittest.TestCase):
    def test_toggle_macros_preserve_resolved_skill_ids(self):
        text = DEFS.read_text(encoding="utf-8")
        self.assertIn("#define SkillEnabled(id)", text)
        self.assertIn("#define SkillDisabled(id)", text)
        self.assertIn("#define SKILL_OFF 255", text)

        resolved = _resolved_ids(text)
        expected = json.loads(SNAPSHOT.read_text(encoding="utf-8"))
        self.assertEqual(resolved, expected)
        self.assertEqual(resolved["CantoID"], 1)
        self.assertEqual(resolved["AmischeID"], SKILL_OFF)
        self.assertIn("SkillDisabled(131)", text)

    def test_colorzcore_expands_enabled_and_disabled_ids(self):
        if not CLEAN_ROM.is_file() or not COLORZCORE.is_file():
            self.skipTest("FE7_clean.gba or ColorzCore.exe missing")
        event = (
            f'#include "{DEFS.as_posix()}"\n'
            "ORG 0\n"
            "BYTE CantoID\n"
            "BYTE BloodTideID\n"
            "BYTE AmischeID\n"
            "BYTE ProvokeID\n"
            "BYTE ArmorBoostID\n"
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
            self.assertEqual(rom.read_bytes()[:5], bytes([1, 255, 255, 43, 156]))


if __name__ == "__main__":
    unittest.main()
