"""Vesly Support After Battle: config, wiring, and distance gate."""
import re
import struct
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

CONFIG = ROOT / "EngineHacks" / "Config.event"
MASTER = ROOT / "EngineHacks" / "_MasterHackInstaller.event"
POST_EVENT = (
    ROOT
    / "EngineHacks"
    / "Necessary"
    / "CalcLoops"
    / "PostBattleCalcLoop"
    / "PostBattleCalcLoop.event"
)
INSTALLER = (
    ROOT / "EngineHacks" / "ExternalHacks" / "SupportPostBattle" / "Installer.event"
)
SRC = (
    ROOT
    / "EngineHacks"
    / "ExternalHacks"
    / "SupportPostBattle"
    / "PostBattleSupports.s"
)
DESTRUCTOR = (
    ROOT
    / "EngineHacks"
    / "ExternalHacks"
    / "SupportPostBattle"
    / "MapEmoticon"
    / "Show_map_emotion_Destructor.s"
)
PARAMS = DESTRUCTOR.with_name("Show_map_emotion_by_params.s")
HACK_ROM = ROOT / "FE7_Hack.gba"

PROCESS_SUPPORT_GAINS_BL = 0x1536E
NOP = bytes.fromhex("c046c046")


def _config_enabled() -> bool:
    text = CONFIG.read_text(encoding="utf-8")
    return bool(re.search(r"(?m)^#define SUPPORT_AFTER_BATTLE\b", text))


class SupportAfterBattleSourceTests(unittest.TestCase):
    def test_config_option_exists(self):
        text = CONFIG.read_text(encoding="utf-8")
        self.assertRegex(text, r"SUPPORT_AFTER_BATTLE")

    def test_master_installer_gates_include(self):
        text = MASTER.read_text(encoding="utf-8")
        self.assertIn("#ifdef SUPPORT_AFTER_BATTLE", text)
        self.assertIn("ExternalHacks/SupportPostBattle/Installer.event", text)

    def test_post_combat_loop_lists_hook(self):
        text = POST_EVENT.read_text(encoding="utf-8")
        self.assertIn("SUPPORT_AFTER_BATTLE", text)
        self.assertIn("PostBattleSupports_Hook", text)

    def test_nop_player_phase_support_gains(self):
        text = INSTALLER.read_text(encoding="utf-8")
        self.assertIn("$1536E", text)
        self.assertIn("$46C0", text)

    def test_uses_bwl_support_exp_not_unit_supports(self):
        src = SRC.read_text(encoding="utf-8")
        self.assertIn("gBwlSupportExp", src)
        self.assertIn("SupportLevelFromExp", src)
        self.assertNotIn("GetUnitSupportLevel", src)
        self.assertNotIn("add r0, #0x32", src)
        self.assertNotIn("GetActionSupportRate.mulRom", src)
        self.assertNotIn("blh AddSupportPoints", src)

    def test_lyn_mode_uses_named_clone_support_data(self):
        src = SRC.read_text(encoding="utf-8")
        self.assertIn("GetUnitSupportData", src)
        self.assertIn("GetCharacterData", src)
        self.assertIn("GetSupportPartnerUnit", src)
        self.assertNotIn("GetUnitSupporterCount", src)
        self.assertNotIn("GetUnitSupporterUnit", src)

    def test_heart_fx_yields_so_map_can_draw(self):
        src = SRC.read_text(encoding="utf-8")
        self.assertIn("PostCombatYield", src)
        self.assertIn("ProcStartBlocking", src)
        self.assertIn("HeartWaitProc", src)
        installer = INSTALLER.read_text(encoding="utf-8")
        self.assertIn("HeartWaitProc:", installer)
        self.assertRegex(installer, r"SHORT 0x0E SUPPORT_AFTER_BATTLE_HEART_FRAMES")

    def test_heart_fx_draws_with_putsprite(self):
        dest = DESTRUCTOR.read_text(encoding="utf-8")
        params = PARAMS.read_text(encoding="utf-8")
        self.assertIn("PutSprite", dest)
        self.assertIn("0x080069F4", dest)
        self.assertIn("gObject_16x16", dest)
        self.assertIn("Show_map_emotion_params.copy_top:", params)
        self.assertIn("Show_map_emotion_params.copy_bot:", params)
        self.assertIn("EnablePaletteSync", params)
        self.assertNotIn("Decompress", params)
        self.assertNotIn("TCS_Update", dest)
        self.assertNotIn("TCS_New", params)

    def test_frame_timer_is_seeded_before_the_loop_reads_it(self):
        params = PARAMS.read_text(encoding="utf-8")
        self.assertRegex(params, r"mov\s+r1,\s*#0\s*\n\s*str\s+r1,\s*\[r7,\s*#0x64\]")

    def test_gfx_and_palette_are_installed_once_not_every_frame(self):
        params = PARAMS.read_text(encoding="utf-8")
        dest = DESTRUCTOR.read_text(encoding="utf-8")
        self.assertIn("CopyToPaletteBuffer", params)
        self.assertIn("EnablePaletteSync", params)
        self.assertNotIn("Decompress", params)
        self.assertNotIn("Decompress", dest)
        self.assertNotIn("CopyToPaletteBuffer", dest)

    def test_loop_stops_drawing_once_it_breaks(self):
        dest = DESTRUCTOR.read_text(encoding="utf-8")
        self.assertIn("blh Proc_Break", dest)
        self.assertIn("b Show_map_emotion_Destructor.end", dest)
        self.assertLess(dest.index("blh Proc_Break"), dest.index("Show_map_emotion_Destructor.draw:"))

    def test_heart_uses_high_obj_vram(self):
        params = PARAMS.read_text(encoding="utf-8")
        self.assertIn(".equ OBJ_VRAM, 0x06014380", params)
        self.assertIn(".equ OBJ_TILE, 0x21C", params)

    def test_support_rates_are_driven_by_config(self):
        config = (ROOT / "EngineHacks" / "Config.event").read_text(encoding="utf-8")
        installer = INSTALLER.read_text(encoding="utf-8")
        knobs = {
            "SupportRateCombat": "SUPPORT_RATE_COMBAT",
            "SupportRateKill": "SUPPORT_RATE_KILL",
            "SupportRateStaff": "SUPPORT_RATE_STAFF",
            "SupportRateDance": "SUPPORT_RATE_DANCE",
            "SupportDistanceLink": "SUPPORT_AFTER_BATTLE_DISTANCE",
            "PlayerPhaseOnly": "SUPPORT_AFTER_BATTLE_PLAYER_PHASE_ONLY",
            "HeartDisplayFrames": "SUPPORT_AFTER_BATTLE_HEART_FRAMES",
        }
        for symbol, define in knobs.items():
            self.assertRegex(config, rf"#define {define} \d+")
            self.assertRegex(installer, rf"ORG {symbol};\s*WORD {define}")

    def test_heart_display_window_is_one_number(self):
        # The proc's break frame, the AP anim length and the blocking sleep all
        # have to agree or the heart is cut off or lingers.
        installer = INSTALLER.read_text(encoding="utf-8")
        self.assertEqual(installer.count("SUPPORT_AFTER_BATTLE_HEART_FRAMES"), 3)
        dest = DESTRUCTOR.read_text(encoding="utf-8")
        self.assertIn("HeartDisplayFrames", dest)
        self.assertNotIn("#0x27", dest)

    def test_heart_loads_obj_palette(self):
        installer = INSTALLER.read_text(encoding="utf-8")
        self.assertIn("emotion02_palette:", installer)
        self.assertIn("emotion21_palette:", installer)
        self.assertIn('#incbin "MapEmoticon/png/02_heart_pal.dmp"', installer)
        self.assertIn('#incbin "MapEmoticon/png/21_goldheart_pal.dmp"', installer)
        self.assertIn('#incbin "MapEmoticon/png/02_heart_16x16.bin"', installer)
        self.assertIn("EmotionEntry(emotion02_heart, 0xE, emotion02_palette)", installer)
        self.assertIn("EmotionEntry(emotion21_goldheart, 0xA, emotion21_palette)", installer)
        self.assertNotIn("emoticonPalette", installer)
        self.assertNotIn("02_heart_kenpuku.png.dmp", installer)
        self.assertNotIn("SHORT 0x0000 0x7FFF", installer)
        pal02 = (
            ROOT
            / "EngineHacks"
            / "ExternalHacks"
            / "SupportPostBattle"
            / "MapEmoticon"
            / "png"
            / "02_heart_pal.dmp"
        ).read_bytes()
        pal21 = (
            ROOT
            / "EngineHacks"
            / "ExternalHacks"
            / "SupportPostBattle"
            / "MapEmoticon"
            / "png"
            / "21_goldheart_pal.dmp"
        ).read_bytes()
        self.assertEqual(len(pal02), 32)
        self.assertNotEqual(pal02, pal21)
        self.assertIn(b"\x1b\x00", pal02)


class SupportAfterBattleDistanceTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        try:
            from Tools.thumb_harness import Harness, assemble, symbol_offsets
        except ImportError as exc:
            raise unittest.SkipTest(f"thumb harness unavailable: {exc}")
        if not SRC.is_file():
            raise unittest.SkipTest("PostBattleSupports.s missing")
        cls.Harness = Harness
        cls.code = assemble(SRC)
        cls.offsets = symbol_offsets(SRC)

    def _distance(self, ax, ay, bx, by) -> int:
        UNIT_A = 0x02000000
        UNIT_B = 0x02000100
        h = self.Harness(self.code)
        h.seed(UNIT_A + 0x10, bytes((ax, ay)))
        h.seed(UNIT_B + 0x10, bytes((bx, by)))
        entry = self.offsets["AreUnitsWithinSupportDistance"]
        stop = self.offsets["AreUnitsWithinSupportDistance_end"]
        regs = h.run(stop, regs={"r0": UNIT_A, "r1": UNIT_B}, entry_offset=entry)
        return regs["r0"]

    def test_adjacent_is_within_range(self):
        self.assertEqual(self._distance(5, 5, 6, 5), 1)

    def test_manhattan_3_is_within_range(self):
        self.assertEqual(self._distance(5, 5, 8, 5), 1)

    def test_manhattan_4_is_out_of_range(self):
        self.assertEqual(self._distance(5, 5, 9, 5), 0)

    def _support_level(self, exp: int) -> int:
        h = self.Harness(self.code)
        entry = self.offsets["SupportLevelFromExp"]
        stop = self.offsets["SupportLevelFromExp_end"]
        regs = h.run(stop, regs={"r0": exp}, entry_offset=entry)
        return regs["r0"]

    def test_support_exp_below_c_is_not_a_rank_up(self):
        self.assertEqual(self._support_level(0), 0)
        self.assertEqual(self._support_level(79), 0)

    def test_support_exp_80_is_not_c(self):
        # Vanilla talk gate: C bonuses start at 81. Exp 80 is "ready to talk".
        self.assertEqual(self._support_level(80), 0)
        self.assertEqual(self._support_level(81), 1)
        self.assertEqual(self._support_level(160), 1)

    def _add_points(self, old: int, rate: int, pid: int = 1, slot: int = 0) -> int:
        import struct

        UNIT = 0x02000000
        CHAR = 0x02001000
        BWL = 0x0203FE10
        h = self.Harness(self.code)
        h.seed(CHAR + 4, bytes((pid,)))
        h.seed(UNIT, struct.pack("<I", CHAR))
        h.seed(BWL + pid * 7 + slot, bytes((old,)))
        entry = self.offsets["AddSupportPointsN"]
        stop = self.offsets["AddSupportPointsN_end"]
        h.run(stop, regs={"r0": UNIT, "r1": slot, "r2": rate}, entry_offset=entry)
        return h.read(BWL + pid * 7 + slot, 1)[0]

    def test_add_support_points_stop_at_talk_gate(self):
        self.assertEqual(self._add_points(50, 50), 80)
        self.assertEqual(self._add_points(80, 50), 80)
        self.assertEqual(self._add_points(81, 50), 131)
        self.assertEqual(self._add_points(130, 50), 160)
        self.assertEqual(self._add_points(160, 50), 160)
        self.assertEqual(self._add_points(200, 50), 240)

    def test_support_exp_161_is_b(self):
        self.assertEqual(self._support_level(161), 2)
        self.assertEqual(self._support_level(240), 2)

    def test_support_exp_241_is_a(self):
        self.assertEqual(self._support_level(241), 3)


@unittest.skipUnless(HACK_ROM.exists(), "FE7_Hack.gba missing")
class SupportAfterBattleRomTests(unittest.TestCase):
    def test_player_phase_support_bl_nops_when_enabled(self):
        if not _config_enabled():
            self.skipTest("SUPPORT_AFTER_BATTLE off")
        rom = HACK_ROM.read_bytes()
        self.assertEqual(rom[PROCESS_SUPPORT_GAINS_BL : PROCESS_SUPPORT_GAINS_BL + 4], NOP)

    def test_can_unit_support_now_is_hooked(self):
        rom = HACK_ROM.read_bytes()
        self.assertEqual(rom[0x26778:0x2677C], bytes.fromhex("004b1847"))

    def test_can_unit_support_now_true_at_eighty(self):
        try:
            from gba_machine import Gba, UNICORN_ERROR
        except ImportError:
            from Tests.gba_machine import Gba, UNICORN_ERROR
        if UNICORN_ERROR:
            self.skipTest(f"unicorn unavailable: {UNICORN_ERROR}")
        from unicorn.arm_const import UC_ARM_REG_R0

        rom = HACK_ROM.read_bytes()
        gba = Gba(rom)
        unit = 0x02020000
        char = 0x02020100
        partner = 0x02020200
        gba.uc.mem_write(unit, bytes(0x48))
        gba.uc.mem_write(char, bytes(0x10))
        gba.w32(unit, char)
        gba.w8(char + 4, 1)
        gba.w8(0x0202BBF8 + 20, 0)
        gba.w8(0x0203FE10 + 7, 80)

        def ret0(g):
            g.uc.reg_write(UC_ARM_REG_R0, 0)

        def ret_partner(g):
            g.uc.reg_write(UC_ARM_REG_R0, partner)

        def ret_bwl(g):
            g.uc.reg_write(UC_ARM_REG_R0, 0x0203E790)

        gba.stub(0x08026BF0, ret0)
        gba.stub(0x080266B8, ret0)
        gba.stub(0x0802664C, ret_partner)
        gba.stub(0x080A0550, ret_bwl)
        gba.set_args(unit, 0)
        gba.run(0x08026778)
        self.assertEqual(gba.r0, 1)

        gba.w8(0x0203FE10 + 7, 50)
        gba.set_args(unit, 0)
        gba.run(0x08026778)
        self.assertEqual(gba.r0, 0)


HEART_BIN = (
    ROOT
    / "EngineHacks"
    / "ExternalHacks"
    / "SupportPostBattle"
    / "MapEmoticon"
    / "png"
    / "02_heart_16x16.bin"
)
OBJ_VRAM = 0x06014380
OBJ_VRAM_GOLD = 0x06014400
OBJ_TILE = 0x21C
OBJ_TILE_GOLD = 0x220
G_CAMERA = 0x0202BBC4
G_CHAPTER = 0x0202BBF8
FAKE_PROC = 0x02019000
PUTSPRITE = 0x080069F4
COPY_PAL = 0x08001084
PROC_START = 0x08004494
PROC_BREAK = 0x080046A0
M4A = 0x080BE594
PARAMS_PROLOGUE = bytes.fromhex("f0b5051c0e1c141c2d013601")


def _tile_pixels(tile: bytes):
    rows = []
    for y in range(8):
        row = []
        for x in range(0, 8, 2):
            by = tile[y * 4 + x // 2]
            row.append(by & 0xF)
            row.append(by >> 4)
        rows.append(row)
    return rows


def _full_heart_pixels():
    raw = HEART_BIN.read_bytes()
    return _canvas_from_1d_tiles([raw[i * 32 : (i + 1) * 32] for i in range(4)])


def _canvas_from_1d_tiles(tiles):
    canvas = [[0] * 16 for _ in range(16)]
    for i, tile in enumerate(tiles):
        pix = _tile_pixels(tile)
        tx, ty = i % 2, i // 2
        for y in range(8):
            for x in range(8):
                canvas[ty * 8 + y][tx * 8 + x] = pix[y][x]
    return canvas


@unittest.skipUnless(HACK_ROM.exists(), "FE7_Hack.gba missing")
class SupportHeartUnicornTests(unittest.TestCase):
    """Execute the emoticon loader/drawer. 1D OBJ mapping (FE7 map DISPCNT)."""

    @classmethod
    def setUpClass(cls):
        try:
            from gba_machine import Gba, UNICORN_ERROR
        except ImportError:
            try:
                from Tests.gba_machine import Gba, UNICORN_ERROR
            except ImportError as exc:
                raise unittest.SkipTest(f"gba_machine unavailable: {exc}")
        if UNICORN_ERROR:
            raise unittest.SkipTest(f"unicorn unavailable: {UNICORN_ERROR}")
        cls.Gba = Gba
        cls.rom = HACK_ROM.read_bytes()
        idx = cls.rom.find(PARAMS_PROLOGUE)
        if idx < 0:
            raise unittest.SkipTest("Show_map_emotion_params not in FE7_Hack.gba")
        cls.params = 0x08000000 + idx
        cls.expected = _full_heart_pixels()
        cls.nonzero = sum(v > 0 for row in cls.expected for v in row)

    def _gba(self):
        gba = self.Gba(self.rom)
        gba.w16(G_CAMERA, 0)
        gba.w16(G_CAMERA + 2, 0)
        gba.w8(G_CHAPTER + 0x41, 0)
        gba.uc.mem_write(FAKE_PROC, bytes(0x70))
        gba.uc.mem_write(OBJ_VRAM, bytes(0x80))
        gba.uc.mem_write(OBJ_VRAM + 0x400, bytes(0x80))
        gba.uc.mem_write(OBJ_VRAM_GOLD, bytes(0x80))
        gba.uc.mem_write(OBJ_VRAM_GOLD + 0x400, bytes(0x80))

        from unicorn.arm_const import UC_ARM_REG_R0

        def proc_start(g):
            g.uc.reg_write(UC_ARM_REG_R0, FAKE_PROC)

        gba.stub(PROC_START, proc_start)
        gba.stub(M4A, None)
        gba.stub(PROC_BREAK, None)
        return gba

    def _run_params(self, gba, tx=5, ty=7):
        gba.set_args(tx, ty, 2)
        gba.run(self.params)
        return gba

    def _vram_2d_tiles(self, gba):
        raw0 = bytes(gba.uc.mem_read(OBJ_VRAM, 0x40))
        raw1 = bytes(gba.uc.mem_read(OBJ_VRAM + 0x400, 0x40))
        return [
            raw0[0:32],
            raw0[32:64],
            raw1[0:32],
            raw1[32:64],
        ]

    def test_loader_puts_all_four_heart_tiles_in_1d_obj_vram(self):
        from unicorn.arm_const import UC_ARM_REG_R0  # noqa: F401 — ROM-phase marker

        gba = self._gba()
        self._run_params(gba)
        got = _canvas_from_1d_tiles(self._vram_2d_tiles(gba))
        self.assertEqual(
            got,
            self.expected,
            "2D OBJ 16x16 at tile 0x21C must occupy 0x21C,0x21D and 0x23C,0x23D",
        )
        self.assertGreater(self.nonzero, 80)
        pal = ROOT / "EngineHacks/ExternalHacks/SupportPostBattle/MapEmoticon/png/02_heart_pal.dmp"
        buf = 0x02022860 + (16 + 0xE) * 32
        self.assertEqual(bytes(gba.uc.mem_read(buf, 32)), pal.read_bytes())

    def test_emotion_21_loads_its_own_palette_slot(self):
        pal = ROOT / "EngineHacks/ExternalHacks/SupportPostBattle/MapEmoticon/png/21_goldheart_pal.dmp"
        gold = ROOT / "EngineHacks/ExternalHacks/SupportPostBattle/MapEmoticon/png/21_goldheart_16x16.bin"
        gba = self._gba()
        self._run_params(gba)
        red_top = bytes(gba.uc.mem_read(OBJ_VRAM, 0x40))
        gba.set_args(5, 7, 21)
        gba.run(self.params)
        buf = 0x02022860 + (16 + 0xA) * 32
        self.assertEqual(bytes(gba.uc.mem_read(buf, 32)), pal.read_bytes())
        raw = gold.read_bytes()
        self.assertEqual(bytes(gba.uc.mem_read(OBJ_VRAM, 0x40)), red_top)
        self.assertEqual(bytes(gba.uc.mem_read(OBJ_VRAM_GOLD, 0x40)), raw[:0x40])
        self.assertEqual(bytes(gba.uc.mem_read(OBJ_VRAM_GOLD + 0x400, 0x40)), raw[0x40:])
        self.assertEqual(gba.r16(FAKE_PROC + 0x34), OBJ_TILE_GOLD)

    def test_drawer_puts_a_16x16_heart_over_the_unit(self):
        from unicorn.arm_const import UC_ARM_REG_R1, UC_ARM_REG_R2, UC_ARM_REG_R3, UC_ARM_REG_SP

        dest_idx = self.rom.find(bytes.fromhex("f4690008"))
        if dest_idx < 0:
            self.fail("destructor does not call PutSprite (0x080069F4)")
        start = dest_idx
        while start > dest_idx - 0x80:
            hw = int.from_bytes(self.rom[start : start + 2], "little")
            if hw in (0xB530, 0xB570):
                break
            start -= 2
        else:
            self.fail("could not find destructor prologue")
        entry = 0x08000000 + start

        gba = self._gba()
        self._run_params(gba, tx=5, ty=7)
        draws = []

        def putsprite(g):
            sp = g.uc.reg_read(UC_ARM_REG_SP)
            oam2 = struct.unpack("<I", bytes(g.uc.mem_read(sp, 4)))[0]
            draws.append(
                {
                    "x": g.uc.reg_read(UC_ARM_REG_R1) & 0xFFFF,
                    "y": g.uc.reg_read(UC_ARM_REG_R2) & 0xFFFF,
                    "obj": g.uc.reg_read(UC_ARM_REG_R3),
                    "oam2": oam2,
                }
            )

        gba.stub(PUTSPRITE, putsprite)
        gba.set_args(FAKE_PROC)
        gba.run(entry)

        self.assertTrue(draws, "no sprite was queued over the unit")
        # Unit at (5,7), camera 0: x = 5*16+4 = 84, y = 7*16-8 = 104.
        xs = [d["x"] for d in draws]
        ys = [d["y"] for d in draws]
        self.assertIn(84, xs)
        self.assertTrue(any(abs(y - 104) <= 8 for y in ys), ys)

        self.assertEqual(draws[0]["oam2"] & 0x3FF, OBJ_TILE)
        obj = draws[0]["obj"]
        count = gba.r16(obj)
        attr1 = gba.r16(obj + 4)
        self.assertGreaterEqual(count, 1)
        size16 = (count == 1 and (attr1 & 0xC000) == 0x4000) or count == 4
        self.assertTrue(size16, f"object is not 16x16 (count={count} attr1={attr1:04X})")

        got = _canvas_from_1d_tiles(self._vram_2d_tiles(gba))
        self.assertEqual(got, self.expected)


if __name__ == "__main__":
    unittest.main()
