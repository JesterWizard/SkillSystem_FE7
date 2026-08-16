"""
HookUnitLoading must resume FE7 UnitLoadSupports, not jump into item code.

A wrong return/BL here black-screens when Lyn's hut loads units.
"""
import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
HOOK_S = ROOT / "EngineHacks" / "SkillSystem" / "Internals" / "asm" / "HookUnitLoading.s"
CLASS_LEVEL_EVENT = (
    ROOT / "Tables" / "NightmareModules" / "Skills" / "ClassLevelUpSkillEditor.event"
)
CHAR_LEVEL_EVENT = (
    ROOT / "Tables" / "NightmareModules" / "Skills" / "CharacterLevelUpSkillEditor.event"
)

# FE7U UnitLoadSupports is at 0x080179F0; jumpToHack is 8 bytes.
FE7_UNIT_LOAD_SUPPORTS_RESUME = 0x080179F9
FE7_GET_UNIT_SUPPORTER_COUNT = 0x08026628


def _hex_literals(text: str) -> set[int]:
    return {int(m.group(0), 16) for m in re.finditer(r"0x080[0-9A-Fa-f]+", text)}


def _c2ea_words(path: Path) -> list[int]:
    words = []
    for line in path.read_text(encoding="utf-8").splitlines():
        m = re.search(r"_C2EA_\w+\((0x[0-9A-Fa-f]+)\)", line)
        if m:
            words.append(int(m.group(1), 16))
    return words


class HookUnitLoadingTests(unittest.TestCase):
    def test_hook_resumes_unit_load_supports(self):
        src = HOOK_S.read_text(encoding="utf-8")
        literals = _hex_literals(src)
        self.assertIn(
            FE7_UNIT_LOAD_SUPPORTS_RESUME,
            literals,
            "HookUnitLoading must bx back to UnitLoadSupports+8 (0x080179F9)",
        )
        self.assertNotIn(
            0x080176F8,
            literals,
            "0x080176F8 is FE7 item/inventory code, not UnitLoadSupports",
        )

    def test_hook_calls_get_unit_supporter_count(self):
        src = HOOK_S.read_text(encoding="utf-8")
        literals = _hex_literals(src)
        self.assertIn(
            FE7_GET_UNIT_SUPPORTER_COUNT,
            literals,
            "Overwritten BL must be GetUnitSupporterCount (0x08026628)",
        )
        self.assertNotIn(
            0x08024C98,
            literals,
            "0x08024C98 is ApplyUnitSpritePalettes, not GetUnitSupporterCount",
        )

    def test_level_up_skill_tables_have_no_wild_pointers(self):
        for path in (CLASS_LEVEL_EVENT, CHAR_LEVEL_EVENT):
            for i, word in enumerate(_c2ea_words(path)):
                self.assertEqual(
                    word,
                    0,
                    f"{path.name} index 0x{i:02X} is 0x{word:08X}; "
                    "non-ROM pointers hang AutoloadSkills on unit load",
                )


if __name__ == "__main__":
    unittest.main()
