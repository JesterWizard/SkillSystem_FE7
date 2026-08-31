"""Barricade / Barricade+: later hits in the same combat deal half damage.

ProcLoop_Start used r11 as the strike counter. The round wrapper calls
proc_truehit at the start of every hit, which clobbers r11, so the second
strike always looked like the first. Strike counts now live in BattleUnit+0x7F
on the unit taking the hit (derived from r0, because the proc loop hardcodes
r1 = gBattleTarget).

Runs ProcLoop_Start out of FE7_Hack.gba. Stubs: proc_truehit always hits,
d100Result never crits, SkillTester answers from the skill ID in r1.
"""
import struct
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))
sys.path.insert(0, str(Path(__file__).resolve().parent))

import built_rom  # noqa: E402

BUILT = built_rom.BUILT
SYMS = built_rom.SYMS

ROM_BASE = 0x08000000
PAGE = 0x1000
STACK = 0x03000000
STACK_SIZE = 0x1000

ATTACKER = 0x0203A3F0
DEFENDER = 0x0203A470
ROUND0 = 0x0203A5EC
BATTLE_DATA = 0x0203A3D8
HIT_COUNT_OFF = 0x7F

PROC_TRUEHIT = 0x080285A8
D100_RESULT = 0x0802857C

TRUEHIT_STUB = 0x02140000
D100_STUB = 0x02140010
SKILL_STUB = 0x02150000

# movs r0, #1 ; bx lr
TRUEHIT_STUB_CODE = bytes.fromhex("01207047")
# movs r0, #0 ; bx lr  -- d100Result returns 1 on a proc; 0 means no crit
D100_STUB_CODE = bytes.fromhex("00207047")

_rom = built_rom.load
_symbols = built_rom.symbols


def _skill_tester_stub(wanted_id: int) -> bytes:
    """cmp r1, #id ; beq +4 ; movs r0, #0 ; bx lr ; movs r0, #1 ; bx lr"""
    return struct.pack("<HHHHHH", 0x2900 | (wanted_id & 0xFF), 0xD001, 0x2000, 0x4770, 0x2001, 0x4770)


def _bounds():
    rom, sym = _rom(), _symbols()
    for name in ("ProcLoop_Start", "ExpertiseIDLink"):
        if name not in sym:
            raise unittest.SkipTest(f"{name} missing from FE7_Hack.sym")
    size = sym["ExpertiseIDLink"] - sym["ProcLoop_Start"]
    base = built_rom.offset(rom, sym["ProcLoop_Start"], size)
    return rom, sym, base, size


def _id_byte(sym_name: str) -> int:
    rom, sym = _rom(), _symbols()
    if sym_name not in sym:
        raise unittest.SkipTest(f"{sym_name} missing from FE7_Hack.sym")
    return rom[built_rom.offset(rom, sym[sym_name], 1)]


def _patch_word(image: bytearray, start: int, size: int, old: int, new: int) -> None:
    needle = struct.pack("<I", old)
    off = image.find(needle, start, start + size)
    if off == -1:
        raise unittest.SkipTest(f"literal {old:#x} missing from ProcLoop_Start")
    struct.pack_into("<I", image, off, new)


def _rewrite_blh_to_blx(image: bytearray, start: int, size: int) -> int:
    """Turn `mov lr, r3; .short 0xf800` into `blx r3; nop`.

    Unicorn rejects a lone BL-suffix halfword. ProcLoop_Start's blh macro
    already loaded the target into r3, so BLX r3 is the same call.
    """
    bl_suffix = b"\x00\xf8"
    blx_r3 = (0x4798).to_bytes(2, "little")
    nop = (0x46C0).to_bytes(2, "little")
    count = 0
    idx = start - 1
    end = start + size
    while True:
        idx = image.find(bl_suffix, idx + 1, end)
        if idx == -1:
            break
        if idx < start + 2:
            continue
        prev = int.from_bytes(image[idx - 2:idx], "little")
        if (prev & 0xFF87) != 0x4686:
            continue
        image[idx - 2:idx] = blx_r3
        image[idx:idx + 2] = nop
        count += 1
    return count


class BarricadeExecutionTests(unittest.TestCase):
    def _combat(self, *, skill_id: int, inflicter: int, mt: int, rounds: int,
                clobber_r11: bool = True):
        try:
            from unicorn import Uc, UC_ARCH_ARM, UC_MODE_THUMB
            from unicorn.arm_const import (
                UC_ARM_REG_R0, UC_ARM_REG_R1, UC_ARM_REG_R2, UC_ARM_REG_R3,
                UC_ARM_REG_LR, UC_ARM_REG_SP, UC_ARM_REG_R11,
            )
        except ImportError as exc:
            raise unittest.SkipTest(f"unicorn unavailable: {exc}")

        rom, sym, base, size = _bounds()
        image = bytearray(rom)
        tester = sym.get("SkillTester")
        if tester is None:
            raise unittest.SkipTest("SkillTester missing from FE7_Hack.sym")
        if _rewrite_blh_to_blx(image, base, size) < 3:
            raise unittest.SkipTest("ProcLoop_Start blh trampolines not found")
        _patch_word(image, base, size, PROC_TRUEHIT, TRUEHIT_STUB | 1)
        _patch_word(image, base, size, D100_RESULT, D100_STUB | 1)
        found = False
        for cand in (tester, tester | 1, tester & ~1):
            if image.find(struct.pack("<I", cand), base, base + size) != -1:
                _patch_word(image, base, size, cand, SKILL_STUB | 1)
                found = True
                break
        if not found:
            raise unittest.SkipTest("SkillTester literal missing from ProcLoop_Start")

        uc = Uc(UC_ARCH_ARM, UC_MODE_THUMB)
        rom_size = (len(image) + PAGE - 1) // PAGE * PAGE
        uc.mem_map(ROM_BASE, rom_size)
        uc.mem_write(ROM_BASE, bytes(image) + bytes(rom_size - len(image)))
        uc.mem_map(STACK, STACK_SIZE)
        uc.reg_write(UC_ARM_REG_SP, STACK + STACK_SIZE - 0x100)
        uc.mem_map(0x0203A000, PAGE)
        uc.mem_map(TRUEHIT_STUB, PAGE)
        uc.mem_map(SKILL_STUB, PAGE)
        uc.mem_write(TRUEHIT_STUB, TRUEHIT_STUB_CODE)
        uc.mem_write(D100_STUB, D100_STUB_CODE)
        uc.mem_write(SKILL_STUB, _skill_tester_stub(skill_id))
        uc.mem_write(ATTACKER, bytes(0x80))
        uc.mem_write(DEFENDER, bytes(0x80))

        stop = ROM_BASE + 0x100
        damages = []
        counts = []
        for i in range(rounds):
            if clobber_r11:
                uc.reg_write(UC_ARM_REG_R11, 0)
            uc.mem_write(ROUND0 + 4 * i, struct.pack("<I", 0))
            uc.mem_write(BATTLE_DATA + 4, struct.pack("<h", 0))
            uc.mem_write(BATTLE_DATA + 6, struct.pack("<h", mt))
            uc.mem_write(BATTLE_DATA + 8, struct.pack("<h", 0))
            uc.mem_write(BATTLE_DATA + 0xA, struct.pack("<H", 100))
            uc.mem_write(BATTLE_DATA + 0xC, struct.pack("<H", 0))
            for reg, val in (
                (UC_ARM_REG_R0, inflicter),
                (UC_ARM_REG_R1, DEFENDER),
                (UC_ARM_REG_R2, ROUND0 + 4 * i),
                (UC_ARM_REG_R3, BATTLE_DATA),
                (UC_ARM_REG_LR, stop | 1),
            ):
                uc.reg_write(reg, val)
            uc.emu_start((ROM_BASE + base) | 1, stop, timeout=200_000)
            damages.append(struct.unpack("<h", uc.mem_read(BATTLE_DATA + 4, 2))[0])
            taker = DEFENDER if inflicter == ATTACKER else ATTACKER
            counts.append(uc.mem_read(taker + HIT_COUNT_OFF, 1)[0])
        return {"damage": damages, "hits": counts}

    def test_first_hit_is_full_damage(self):
        out = self._combat(skill_id=_id_byte("BarricadeIDLink"), inflicter=ATTACKER, mt=10, rounds=1)
        self.assertEqual(out["damage"], [10])
        self.assertEqual(out["hits"], [1])

    def test_second_hit_is_halved_after_r11_is_clobbered(self):
        out = self._combat(skill_id=_id_byte("BarricadeIDLink"), inflicter=ATTACKER, mt=10, rounds=2)
        self.assertEqual(out["damage"], [10, 5], "second strike must half even if r11 is wiped")
        self.assertEqual(out["hits"], [1, 1])

    def test_no_skill_does_not_halve(self):
        out = self._combat(skill_id=0, inflicter=ATTACKER, mt=10, rounds=2)
        self.assertEqual(out["damage"], [10, 10])
        self.assertEqual(out["hits"], [0, 0])

    def test_counterattack_against_the_actor_is_halved_on_the_second_hit(self):
        # Proc loop passes r1 = gBattleTarget even when the target is attacking.
        # Barricade is on the actor, who is taking the counter.
        out = self._combat(skill_id=_id_byte("BarricadeIDLink"), inflicter=DEFENDER, mt=10, rounds=2)
        self.assertEqual(out["damage"], [10, 5])
        self.assertEqual(out["hits"], [1, 1])

    def test_barricade_plus_halves_each_successive_hit(self):
        out = self._combat(skill_id=_id_byte("BarricadePlusIDLink"), inflicter=ATTACKER, mt=8, rounds=3)
        self.assertEqual(out["damage"], [8, 4, 2])
        self.assertEqual(out["hits"], [1, 2, 3])

    def test_odd_damage_rounds_down(self):
        out = self._combat(skill_id=_id_byte("BarricadeIDLink"), inflicter=ATTACKER, mt=7, rounds=2)
        self.assertEqual(out["damage"], [7, 3])


if __name__ == "__main__":
    unittest.main()
