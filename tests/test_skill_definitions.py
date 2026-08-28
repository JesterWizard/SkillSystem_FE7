"""
Skill IDs are toggled with a catalog number or SKILL_OFF.

Disabled skills must still assemble as 255; enabled skills keep their assigned IDs.
"""
import json
import re
import subprocess
import tempfile
import time
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DEFS = ROOT / "EngineHacks" / "SkillSystem" / "skill_definitions.event"
SNAPSHOT = Path(__file__).with_name("skill_id_snapshot.json")
CLEAN_ROM = ROOT / "FE7_clean.gba"
COLORZCORE = ROOT / "EventAssembler" / "ColorzCore.exe"

DEFINE_RE = re.compile(r"^#define\s+(\w+ID)\s+(\S+)")
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
        if rhs == "SKILL_OFF":
            resolved[name] = SKILL_OFF
        elif rhs.isdigit():
            resolved[name] = int(rhs)
        else:
            raise AssertionError(f"{name} must use a catalog id or SKILL_OFF, got {rhs}")
    return resolved


def _run_colorzcore(rom: Path, src: Path, attempts: int = 5) -> subprocess.CompletedProcess:
    """Retry when another ColorzCore exclusive-opens Language Raws."""
    last = None
    for attempt in range(attempts):
        last = subprocess.run(
            [str(COLORZCORE), "A", "FE7", f"-output:{rom}", f"-input:{src}"],
            cwd=str(COLORZCORE.parent),
            capture_output=True,
            text=True,
        )
        if last.returncode == 0:
            return last
        err = (last.stdout or "") + (last.stderr or "")
        if "being used by another process" not in err:
            return last
        time.sleep(0.25 * (attempt + 1))
    return last


class SkillDefinitionToggleTests(unittest.TestCase):
    def test_toggle_macros_preserve_resolved_skill_ids(self):
        text = DEFS.read_text(encoding="utf-8")
        self.assertNotIn("SkillEnabled", text)
        self.assertNotIn("SkillDisabled", text)
        self.assertIn("#define SKILL_OFF 255", text)

        resolved = _resolved_ids(text)
        expected = json.loads(SNAPSHOT.read_text(encoding="utf-8"))
        self.assertEqual(resolved, expected)
        self.assertEqual(resolved["EvenFootedID"], 1)
        self.assertEqual(resolved["CantoID"], SKILL_OFF)
        self.assertEqual(resolved["AmischeID"], 199)
        self.assertEqual(resolved["ShadowgiftID"], 197)
        self.assertEqual(resolved["LuminaID"], 198)
        self.assertEqual(resolved["BloodTideID"], SKILL_OFF)

        seen = {}
        for name, sid in resolved.items():
            if sid == SKILL_OFF:
                continue
            other = seen.get(sid)
            self.assertIsNone(other, f"{name} and {other} share skill id {sid}")
            seen[sid] = name

    def test_colorzcore_expands_enabled_and_disabled_ids(self):
        if not CLEAN_ROM.is_file() or not COLORZCORE.is_file():
            self.skipTest("FE7_clean.gba or ColorzCore.exe missing")
        # ColorzCore resolves #include relative to the input file, not cwd,
        # and also fails on long C:/ absolute paths. Copy the catalog next
        # to the temp event so a basename include works.
        event = (
            '#include "skill_definitions.event"\n'
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
            (tmp_path / "skill_definitions.event").write_bytes(DEFS.read_bytes())
            rom.write_bytes(CLEAN_ROM.read_bytes())
            src.write_text(event, encoding="ascii")
            result = _run_colorzcore(rom, src)
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
            self.assertEqual(rom.read_bytes()[:5], bytes([255, 255, 199, 43, 255]))


if __name__ == "__main__":
    unittest.main()
