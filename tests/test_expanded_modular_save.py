"""Verify DEC-68 ExpandedModularSave hooks and SRAM layout in FE7_Hack.gba."""
from __future__ import annotations

import struct
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BUILT = ROOT / "FE7_Hack.gba"
if not BUILT.exists():
    BUILT = ROOT / "SkillsTest.gba"

# LynJump thumb trampoline: bx pc; nop
LYNJUMP_HEAD = bytes((0x78, 0x47, 0xC0, 0x46))

HOOK_SITES = {
    0x09E870: "GetSaveDataLocation",
    0x0A065C: "CopySaveGame",
    0x0A0810: "SaveGame",
    0x0A08EC: "LoadGame",
    0x0A1100: "SaveSuspend",
    0x0A1258: "LoadSuspend",
    0x0A09B4: "LoadSavedChapterState",
    0x0A13D8: "LoadSuspendedChapterState",
    0x0A09D4: "LoadSavedBonusClaimFlags",
}

EMS_GAME_SIZE = 0x1400
EMS_SUSPEND_SIZE = 0x2E78
EMS_LINK_SIZE = 0x8B4
EMS_GAME_OFFSETS = (0x2F4C, 0x434C, 0x574C)
EMS_LINK_OFFSET = 0x6B4C
EMS_BLOCK6_OFFSET = 0x7400
EMS_CONVOY_CHUNK_SIZE = 0x0190


class TestExpandedModularSave(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        if not BUILT.exists():
            raise unittest.SkipTest("FE7_Hack.gba not built yet")
        cls.rom = BUILT.read_bytes()

    def test_core_hooks_are_lynjumps(self):
        for off, name in HOOK_SITES.items():
            self.assertEqual(
                self.rom[off : off + 4],
                LYNJUMP_HEAD,
                f"{name} @ {off:#x} missing LynJump",
            )

    def test_write_save_block_info_sizes(self):
        self.assertEqual(struct.unpack_from("<H", self.rom, 0x09E7E4)[0], EMS_GAME_SIZE)
        self.assertEqual(struct.unpack_from("<H", self.rom, 0x09E7F0)[0], EMS_SUSPEND_SIZE)
        self.assertEqual(struct.unpack_from("<H", self.rom, 0x09E7FC)[0], EMS_LINK_SIZE)

    def test_checksum_stub_always_ok(self):
        # mov r0, #42; bx lr
        self.assertEqual(self.rom[0x0A1970 : 0x0A1970 + 4], bytes((0x2A, 0x20, 0x70, 0x47)))

    def test_gsaveblockdecl_layout(self):
        needle = struct.pack("<HHHHHH", *EMS_GAME_OFFSETS, 0x00D4, 0x00D4, EMS_LINK_OFFSET)
        # type bytes interleave: each decl is offset u16 + type u16
        pattern = b""
        for off, typ in (
            (EMS_GAME_OFFSETS[0], 0),
            (EMS_GAME_OFFSETS[1], 0),
            (EMS_GAME_OFFSETS[2], 0),
            (0x00D4, 1),
            (0x00D4, 1),
            (EMS_LINK_OFFSET, 2),
            (EMS_BLOCK6_OFFSET, 3),
        ):
            pattern += struct.pack("<HH", off, typ)
        idx = self.rom.find(pattern)
        self.assertNotEqual(idx, -1, "gSaveBlockDecl not found")
        # size lookup immediately after (ALIGN 4 — already aligned)
        sizes_off = idx + len(pattern)
        self.assertEqual(struct.unpack_from("<H", self.rom, sizes_off)[0], EMS_GAME_SIZE)
        self.assertEqual(struct.unpack_from("<H", self.rom, sizes_off + 2)[0], EMS_SUSPEND_SIZE)
        self.assertEqual(struct.unpack_from("<H", self.rom, sizes_off + 4)[0], EMS_LINK_SIZE)

    def test_game_blocks_do_not_overlap_link_or_block6(self):
        game_end = EMS_GAME_OFFSETS[2] + EMS_GAME_SIZE
        self.assertLessEqual(game_end, EMS_LINK_OFFSET)
        self.assertLessEqual(EMS_LINK_OFFSET + EMS_LINK_SIZE, EMS_BLOCK6_OFFSET)
        self.assertLessEqual(EMS_BLOCK6_OFFSET + 0xC00, 0x8000)

    def test_suspend_fits_before_game1(self):
        suspend_end = 0x00D4 + EMS_SUSPEND_SIZE
        self.assertEqual(suspend_end, EMS_GAME_OFFSETS[0])

    def test_convoy_chunk_size_present(self):
        # Chunk decl: offset u16, size u16, saver, loader, id…
        # Look for convoy size 0x0190 followed by pointers (common to game+suspend).
        count = 0
        for i in range(0, len(self.rom) - 8, 2):
            if struct.unpack_from("<H", self.rom, i)[0] != EMS_CONVOY_CHUNK_SIZE:
                continue
            # preceding halfword is a plausible chunk offset (< game/suspend size)
            prev = struct.unpack_from("<H", self.rom, i - 2)[0] if i >= 2 else 0xFFFF
            if prev in (0x0048, 0x0280):
                count += 1
        self.assertGreaterEqual(count, 2, "expected game+suspend convoy chunks of size 0x190")

    def test_savenewgame_passes_slot_in_r0(self):
        """SaveNewGame must mov r0, r8 before BL SaveGame (r0=slot), not mov r1, r8."""
        # Vanilla 0xA07DC is mov r1, r8 (WriteSaveBlockInfo args). MS_SaveGame wants r0.
        self.assertEqual(
            self.rom[0x0A07DC:0x0A07DE],
            bytes((0x40, 0x46)),
            "SaveNewGame @ 0xA07DC must be mov r0, r8 so the slot is not lost",
        )

    def test_game_chunk_savers_are_thumb(self):
        """POIN to Thumb code must be odd; even addresses crash on bx (DEC-68 new-game)."""
        idx = -1
        for i in range(0x1000000, len(self.rom) - 0x80, 4):
            if (
                struct.unpack_from("<HH", self.rom, i) == (0, 0x48)
                and struct.unpack_from("<HH", self.rom, i + 0x10) == (0x48, EMS_CONVOY_CHUNK_SIZE)
            ):
                idx = i
                break
        self.assertNotEqual(idx, -1, "gGameSaveChunks not found")
        for c in range(12):
            off = struct.unpack_from("<H", self.rom, idx + c * 0x10)[0]
            if off == 0xFFFF:
                break
            saver = struct.unpack_from("<I", self.rom, idx + c * 0x10 + 4)[0]
            loader = struct.unpack_from("<I", self.rom, idx + c * 0x10 + 8)[0]
            if saver:
                self.assertTrue(saver & 1, f"chunk@{off:#x} saver {saver:#x} missing Thumb bit")
            if loader:
                self.assertTrue(loader & 1, f"chunk@{off:#x} loader {loader:#x} missing Thumb bit")


if __name__ == "__main__":
    unittest.main()
