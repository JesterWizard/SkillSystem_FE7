"""DEC-110: End Turn must be available in the prologue when tutorials are off.

Vanilla FE7 hides End via the ASM tutorial (separate from the event-pointer
table DisableTutorials.event already stubs). FEBuilder's Tutorial Disabler
rewrites that ASM; this file checks those writes are installed and that
IsTutorial's chapter-state path returns 0 even when the prologue tutorial
bit is set.
"""
from __future__ import annotations

import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))
sys.path.insert(0, str(Path(__file__).resolve().parent))

import built_rom  # noqa: E402

CONFIG = ROOT / "EngineHacks" / "Config.event"
DISABLER = ROOT / "EngineHacks" / "Necessary" / "DisableTutorials.event"

# FE7U IsTutorial (0x0802DEEC). Second path reads gPlaySt+0x14 bit 0x80 and
# gPlaySt+0x41 bit 4; vanilla returns 1 in the prologue, which hides End.
ISTUTORIAL = 0x0802DEEC
ISTUTORIAL_SIZE = 0x34
BL_OFFSET = 2
PATCH_SITE = 0x2DF06  # bne -> b, so the second path always returns 0
PLAY_ST = 0x0202BBF8
PLAY_ST_FLAGS = 0x14
PLAY_ST_TUTORIAL = 0x41
TUTORIAL_BIT = 0x10  # bit 4; IsTutorial shifts it to r0

# FEBuilder Tutorial Disabler: chapter-indexed ASM tutorial runners.
ASM_STUBS = (0x78FC8, 0x79004, 0x7905C, 0x790C4, 0x79104)
MOV_R0_BX_LR = bytes.fromhex("00 20 70 47")
UNCOND_B_7 = bytes.fromhex("07 e0")


def _tutorials_disabled() -> bool:
    for line in CONFIG.read_text(encoding="utf-8").splitlines():
        stripped = line.split("//", 1)[0].strip()
        if stripped == "#define DISABLE_TUTORIALS":
            return True
    return False


class DisableTutorialsSourceTests(unittest.TestCase):
    def test_disabler_rewrites_istutorial_second_path(self):
        if not _tutorials_disabled():
            raise unittest.SkipTest("DISABLE_TUTORIALS is commented out")
        text = DISABLER.read_text(encoding="utf-8")
        self.assertIn("ORG 0x2DF06", text)
        self.assertIn("SHORT 0xE007", text)

    def test_disabler_stubs_asm_tutorial_runners(self):
        if not _tutorials_disabled():
            raise unittest.SkipTest("DISABLE_TUTORIALS is commented out")
        text = DISABLER.read_text(encoding="utf-8")
        for addr in ASM_STUBS:
            self.assertIn(f"ORG 0x{addr:X}", text)
        self.assertIn("SHORT 0x2000 0x4770", text)


class IsTutorialRomTests(unittest.TestCase):
    def test_patch_site_is_unconditional_branch(self):
        if not _tutorials_disabled():
            raise unittest.SkipTest("DISABLE_TUTORIALS is commented out")
        rom = built_rom.load()
        self.assertEqual(rom[PATCH_SITE:PATCH_SITE + 2], UNCOND_B_7)

    def test_asm_tutorial_runners_return_immediately(self):
        if not _tutorials_disabled():
            raise unittest.SkipTest("DISABLE_TUTORIALS is commented out")
        rom = built_rom.load()
        for addr in ASM_STUBS:
            self.assertEqual(rom[addr:addr + 4], MOV_R0_BX_LR, hex(addr))

    def test_istutorial_returns_clear_when_prologue_tutorial_bit_is_set(self):
        """Prologue state that vanilla treats as 'tutorial on' must return 0."""
        if not _tutorials_disabled():
            raise unittest.SkipTest("DISABLE_TUTORIALS is commented out")
        try:
            from Tools.thumb_harness import CODE_BASE, Harness
        except ImportError as exc:
            raise unittest.SkipTest(f"thumb harness unavailable: {exc}")

        rom = built_rom.load()
        off = built_rom.offset(rom, ISTUTORIAL, ISTUTORIAL_SIZE)
        code = bytearray(rom[off:off + ISTUTORIAL_SIZE])
        # Skip the save-config BL so the chapter-state path runs.
        code[BL_OFFSET:BL_OFFSET + 4] = bytes.fromhex("01 20 00 00")

        h = Harness(bytes(code))
        h.seed(PLAY_ST + PLAY_ST_FLAGS, b"\x00")
        h.seed(PLAY_ST + PLAY_ST_TUTORIAL, bytes([TUTORIAL_BIT]))
        out = h.run(
            len(code),
            regs={"lr": (CODE_BASE + len(code)) | 1},
        )
        self.assertEqual(out["r0"], 0)


if __name__ == "__main__":
    unittest.main()
