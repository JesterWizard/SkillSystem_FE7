"""Debugger Promote: Lyn Lord -> Blade Lord via vanilla MakePromote + StartPromotionAnim.

Reproduces the reported 'select Promote and the CPU loops' hang by executing the
shipped PromoAction bytes under Unicorn.  Does not prove the 2D class-change
anim looks right on hardware.
"""
from __future__ import annotations

import collections
import struct
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(Path(__file__).resolve().parent))

import built_rom  # noqa: E402
from gba_machine import Gba, UNICORN_ERROR, Uc  # noqa: E402

if Uc is not None:
    from unicorn import UC_HOOK_CODE, UcError  # noqa: E402
    from unicorn.arm_const import (  # noqa: E402
        UC_ARM_REG_LR,
        UC_ARM_REG_PC,
        UC_ARM_REG_R0,
        UC_ARM_REG_R1,
    )

G_ACTIVE_UNIT = 0x03004690
G_ACTION_DATA = 0x0203A85C
G_BATTLE_STATS = 0x0203A3D8
G_BM_ST = 0x0202BBB8
G_PLAY_ST = 0x0202BBF8
BATTLE_ACTOR = 0x0203A3F0
BATTLE_TARGET = 0x0203A470
PROMO_WORK = 0x0203F000
CLASS_TABLE = 0x08BE015C
CHAR_TABLE = 0x08BDCE18
CLASS_ENTRY = 0x54
CHAR_ENTRY = 0x34
LYN_CHAR = 1
LYN_LORD = 2
BLADE_LORD = 8
MAKE_PROMOTE = 0x0802CBAC
START_PROMO_ANIM = 0x0802A3B0
ACTION_PROMOTE = 0x0802CC68
LOCK_GAME = 0x08015308
PROC_START = 0x08004494
UNIT = 0x02010000
PROC = 0x02018000
BATTLE_CONFIG_PROMOTION = 0x10
INSN_CAP = 2_000_000


def _hist_report(hist: collections.Counter) -> str:
    top = hist.most_common(12)
    return ", ".join(f"{pc:08X}x{n}" for pc, n in top)


class DebuggerPromoExecutionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        if UNICORN_ERROR:
            raise unittest.SkipTest(f"unicorn unavailable: {UNICORN_ERROR}")
        cls.rom = built_rom.load()
        cls.sym = built_rom.symbols()
        if "PromoAction" not in cls.sym:
            raise unittest.SkipTest("PromoAction missing from FE7_Hack.sym")
        cls.promo_action = cls.sym["PromoAction"] & ~1
        cls.proc_script = cls.sym.get("DebuggerProcCmd", 0) & ~1

    def _seed_lyn_lord(self, gba: Gba) -> None:
        char = CHAR_TABLE + LYN_CHAR * CHAR_ENTRY
        klass = CLASS_TABLE + LYN_LORD * CLASS_ENTRY
        gba.uc.mem_write(UNIT, b"\x00" * 0x80)
        gba.w32(UNIT, char)
        gba.w32(UNIT + 4, klass)
        gba.w8(UNIT + 8, 10)
        gba.w8(UNIT + 9, 0)
        gba.w8(UNIT + 0xB, 1)
        gba.w8(UNIT + 0x10, 1)
        gba.w8(UNIT + 0x12, 22)
        gba.w8(UNIT + 0x13, 22)
        for stat in range(0x14, 0x1E):
            gba.w8(UNIT + stat, 8)
        gba.w32(G_ACTIVE_UNIT, UNIT)
        gba.w8(G_ACTION_DATA + 0xC, 1)
        gba.w8(G_ACTION_DATA + 0x12, 0xFF)
        gba.w8(G_BM_ST + 1, 0)
        gba.w16(G_BATTLE_STATS, 0)
        gba.w8(G_PLAY_ST + 0x1B, 0)  # chapterStateBits
        gba.w8(G_PLAY_ST + 0x42, 0)  # anims: map / solo default

    def _run_counted(self, gba: Gba, entry: int, cap: int = INSN_CAP):
        hist: collections.Counter[int] = collections.Counter()
        hits = {
            "MakePromote": 0,
            "StartPromotionAnim": 0,
            "ActionPromote": 0,
            "LockGame": 0,
            "Proc_Start": 0,
        }

        def on_code(uc, address, size, _user):
            hist[address] += 1
            if address == MAKE_PROMOTE:
                hits["MakePromote"] += 1
            elif address == START_PROMO_ANIM:
                hits["StartPromotionAnim"] += 1
            elif address == ACTION_PROMOTE:
                hits["ActionPromote"] += 1
            elif address == LOCK_GAME:
                hits["LockGame"] += 1
            elif address == PROC_START:
                hits["Proc_Start"] += 1
            if sum(hist.values()) >= cap:
                uc.emu_stop()

        gba.uc.hook_add(UC_HOOK_CODE, on_code)
        try:
            gba.run(entry, timeout=5_000_000)
        except UcError as exc:
            pc = gba.uc.reg_read(UC_ARM_REG_PC)
            raise AssertionError(
                f"Unicorn fault at {pc:08X}: {exc}; hot={_hist_report(hist)}"
            ) from exc
        return hist, hits

    def test_make_promote_turns_lyn_lord_into_blade_lord(self):
        gba = Gba(self.rom)
        self._seed_lyn_lord(gba)
        gba.set_args(UNIT, 0xFFFFFFFF, 0)
        hist, hits = self._run_counted(gba, MAKE_PROMOTE)
        self.assertLess(
            sum(hist.values()),
            INSN_CAP,
            f"MakePromote looped; hot={_hist_report(hist)}",
        )
        klass = gba.r32(UNIT + 4)
        self.assertEqual(
            klass,
            CLASS_TABLE + BLADE_LORD * CLASS_ENTRY,
            f"pClassData {klass:#x} (must not be Mag promo hook)",
        )
        self.assertEqual(gba.r8(klass + 4), BLADE_LORD)
        self.assertEqual(gba.r16(G_BATTLE_STATS), BATTLE_CONFIG_PROMOTION)
        self.assertEqual(hits["ActionPromote"], 0)

    def test_promo_action_returns_and_starts_vanilla_anim(self):
        gba = Gba(self.rom)
        self._seed_lyn_lord(gba)
        gba.uc.mem_write(PROC, b"\x00" * 0x80)
        if self.proc_script:
            gba.w32(PROC, self.proc_script)
            gba.w32(PROC + 4, self.proc_script)

        skipped = []

        def skip_anim(uc, address, size, _user):
            if address in (START_PROMO_ANIM, 0x0806CCB8):
                skipped.append(address)
                uc.reg_write(UC_ARM_REG_PC, uc.reg_read(UC_ARM_REG_LR))

        gba.uc.hook_add(UC_HOOK_CODE, skip_anim)
        gba.set_args(PROC)
        hist, hits = self._run_counted(gba, self.promo_action)
        pc = gba.uc.reg_read(UC_ARM_REG_PC)
        self.assertLess(
            sum(hist.values()),
            INSN_CAP,
            f"PromoAction looped; pc={pc:08X} hot={_hist_report(hist)} hits={hits}",
        )
        self.assertEqual(hits["ActionPromote"], 0)
        self.assertGreaterEqual(hits["MakePromote"], 1, hits)
        self.assertIn(START_PROMO_ANIM, skipped)
        klass = gba.r32(UNIT + 4)
        self.assertEqual(klass, CLASS_TABLE + BLADE_LORD * CLASS_ENTRY)
        if self.proc_script:
            cur = gba.r32(PROC + 4)
            op = gba.r16(cur)
            lab = struct.unpack("<h", gba.uc.mem_read(cur + 2, 2))[0]
            self.assertEqual(op, 11, f"current opcode {op} at {cur:#x}")
            self.assertEqual(lab, 22, f"label {lab} at {cur:#x}")
        self.assertNotEqual(pc & ~1, self.promo_action)


if __name__ == "__main__":
    unittest.main()
