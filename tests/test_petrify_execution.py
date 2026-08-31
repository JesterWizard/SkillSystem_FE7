"""Petrify: Skill% chance to inflict FE7 stone (PetrifyStatusID 13, 3 turns).

Writes battle-unit statusOut (0x6F) and the real status byte (0x30), and sets
US_UNSELECTABLE on the defender so the unit cannot act. Vanilla FE7 has no
stone status; 0x3B is the FE8 packed byte and must not be used.
"""
import struct
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from Tools.thumb_harness import Harness, assemble, symbol_offsets

SRC = ROOT / "EngineHacks/SkillSystem/Skills/ProcSkills/Petrify/proc_petrify.s"
BOON_SRC = ROOT / "EngineHacks/SkillSystem/Skills/StandaloneSkills/Boon/Boon.s"

ATTACKER = 0x0203A3F0
DEFENDER = 0x0203A470
BUFFER = 0x0203A600
BATTLE_DATA = 0x0203A3D8
D100 = 0x0802857C

SKILL_FLAG = 0x4000
POISON_ATTR = 0x40
MISS = 0x2
DEFENDER_SKILL = 0x8000
UNSELECTABLE = 0x2
STATUS_OUT = 0x6F
UNIT_STATUS = 0x30
UNIT_STATE = 0x0C
SKL = 0x15
NONE_OUT = 0xFF
# ItemStatus(PetrifyStatusID, 3) = 13 | (3 << 4)
PETRIFY_BYTE = 0x3D
PETRIFY_ID_NIBBLE = 0xD


def _run(*, skill=True, roll=1, hit_word=0, status_out=NONE_OUT, state=0, status=0):
    def intercept(lr, r0, r1):
        if (lr & ~1) == D100:
            return roll
        return 1 if skill else 0

    code = assemble(SRC)
    offsets = symbol_offsets(SRC)
    h = Harness(code, intercept_calls=intercept)
    atk = bytearray(0x80)
    atk[SKL] = 100
    h.seed(ATTACKER, bytes(atk))
    dfd = bytearray(0x80)
    dfd[STATUS_OUT] = status_out
    dfd[UNIT_STATUS] = status
    struct.pack_into("<I", dfd, UNIT_STATE, state)
    h.seed(DEFENDER, bytes(dfd))
    h.seed(BUFFER, struct.pack("<I", hit_word) + b"\x00\x00\x00\x00")
    h.seed(BATTLE_DATA, bytes(0x10))
    h.run(
        offsets["End"],
        regs={"r0": ATTACKER, "r1": DEFENDER, "r2": BUFFER, "r3": BATTLE_DATA},
    )
    word = struct.unpack("<I", h.read(BUFFER, 4))[0]
    return {
        "word": word,
        "status_out": h.read(DEFENDER + STATUS_OUT, 1)[0],
        "status": h.read(DEFENDER + UNIT_STATUS, 1)[0],
        "state": struct.unpack("<I", h.read(DEFENDER + UNIT_STATE, 4))[0],
    }


class PetrifyExecutionTests(unittest.TestCase):
    def test_proc_writes_fe7_stone_and_unselectable(self):
        out = _run()
        self.assertTrue(out["word"] & SKILL_FLAG, f"skill flag missing, buffer={out['word']:#x}")
        self.assertTrue(out["word"] & POISON_ATTR, "status-inflict hit attr missing")
        self.assertEqual(out["status_out"], PETRIFY_BYTE)
        self.assertEqual(out["status"], PETRIFY_BYTE)
        self.assertTrue(out["state"] & UNSELECTABLE)

    def test_no_skill_leaves_defender_untouched(self):
        out = _run(skill=False)
        self.assertFalse(out["word"] & SKILL_FLAG)
        self.assertEqual(out["status_out"], NONE_OUT)
        self.assertEqual(out["status"], 0)
        self.assertFalse(out["state"] & UNSELECTABLE)

    def test_failed_roll_leaves_defender_untouched(self):
        out = _run(roll=0)
        self.assertFalse(out["word"] & SKILL_FLAG)
        self.assertEqual(out["status_out"], NONE_OUT)
        self.assertEqual(out["status"], 0)
        self.assertFalse(out["state"] & UNSELECTABLE)

    def test_miss_does_not_petrify(self):
        out = _run(hit_word=MISS)
        self.assertFalse(out["word"] & SKILL_FLAG)
        self.assertEqual(out["status_out"], NONE_OUT)
        self.assertFalse(out["state"] & UNSELECTABLE)

    def test_existing_status_out_skips(self):
        out = _run(status_out=0x32)
        self.assertFalse(out["word"] & SKILL_FLAG)
        self.assertEqual(out["status_out"], 0x32)
        self.assertFalse(out["state"] & UNSELECTABLE)

    def test_already_activated_skill_does_not_proc(self):
        out = _run(hit_word=SKILL_FLAG)
        self.assertEqual(out["word"], SKILL_FLAG)
        self.assertEqual(out["status_out"], NONE_OUT)
        out = _run(hit_word=DEFENDER_SKILL)
        self.assertEqual(out["word"], DEFENDER_SKILL)
        self.assertEqual(out["status_out"], NONE_OUT)


class PetrifyBoonExpiryTests(unittest.TestCase):
    """Duration tick must drop US_UNSELECTABLE when stone expires without Boon."""

    def _run_tick(self, *, has_boon, status):
        def intercept(lr, r0, r1):
            return 1 if has_boon else 0

        code = assemble(BOON_SRC)
        offsets = symbol_offsets(BOON_SRC)
        h = Harness(code, intercept_calls=intercept)
        unit = bytearray(0x48)
        unit[UNIT_STATUS] = status
        struct.pack_into("<I", unit, UNIT_STATE, UNSELECTABLE)
        h.seed(ATTACKER, bytes(unit))
        # Resume target 0x0801839F must be mapped; Boon bx's there.
        h.seed(0x0801839E, b"\x00\x00")
        h.run(
            offsets["BoonDone"],
            regs={
                "r0": ATTACKER,
                "r4": ATTACKER,
                "r2": status,
                "r3": ATTACKER + UNIT_STATUS,
                "r6": 0xF0,
            },
        )
        return {
            "status": h.read(ATTACKER + UNIT_STATUS, 1)[0],
            "state": struct.unpack("<I", h.read(ATTACKER + UNIT_STATE, 4))[0],
        }

    def test_last_turn_of_stone_clears_unselectable(self):
        # duration 1, status 13 = 0x1D; VanillaDec subtracts 1 -> duration 0
        out = self._run_tick(has_boon=False, status=0x1D)
        self.assertFalse(out["state"] & UNSELECTABLE)
        self.assertEqual(out["status"] & 0x0F, PETRIFY_ID_NIBBLE)

    def test_stone_with_time_left_stays_unselectable(self):
        out = self._run_tick(has_boon=False, status=PETRIFY_BYTE)  # 3 turns
        self.assertTrue(out["state"] & UNSELECTABLE)
        self.assertEqual(out["status"], 0x2D)  # duration 2, status 13


def _petrify_rom_blob():
    sys.path.insert(0, str(Path(__file__).resolve().parent))
    import built_rom  # FE7_Hack.gba

    rom, sym = built_rom.load(), built_rom.symbols()
    for name in ("Proc_Petrify", "Proc_Deadeye", "ProcLoop_Start", "ProcLoopParent"):
        if name not in sym:
            raise unittest.SkipTest(f"{name} missing from FE7_Hack.sym")
    size = (sym["Proc_Deadeye"] - sym["Proc_Petrify"]) & ~1
    if size < 0x20 or size > 0x200:
        raise unittest.SkipTest(f"Proc_Petrify size {size:#x} looks wrong")
    off = built_rom.offset(rom, sym["Proc_Petrify"], size)
    return rom, sym, rom[off:off + size]


class PetrifyProcLoopTests(unittest.TestCase):
    """Proc_Petrify must be reachable from the battle proc loop in FE7_Hack.gba."""

    def test_petrify_is_in_the_battle_proc_loop(self):
        rom, sym, _ = _petrify_rom_blob()
        sys.path.insert(0, str(Path(__file__).resolve().parent))
        import built_rom  # FE7_Hack.gba

        table = rom.find(
            struct.pack("<I", sym["ProcLoop_Start"]),
            built_rom.offset(rom, sym["ProcLoopParent"]),
        )
        self.assertNotEqual(table, -1, "proc loop table not found")
        found = False
        off = table
        while off + 4 <= len(rom):
            ptr = struct.unpack_from("<I", rom, off)[0]
            if ptr == 0:
                break
            if (ptr & ~1) == (sym["Proc_Petrify"] & ~1):
                found = True
                break
            off += 4
        self.assertTrue(found, "Proc_Petrify is not in ProcLoopParent")

    def test_petrify_id_is_enabled(self):
        _, _, blob = _petrify_rom_blob()
        tester = symbol_offsets(SRC)["SkillTester"]
        skill_id = blob[tester + 4]
        self.assertNotEqual(skill_id, 255, "PetrifyID is SKILL_OFF")
        self.assertTrue(1 <= skill_id <= 254, f"PetrifyID {skill_id} out of range")

    def test_rom_bytes_write_fe7_stone(self):
        _, _, blob = _petrify_rom_blob()
        offsets = symbol_offsets(SRC)

        def intercept(lr, r0, r1):
            if (lr & ~1) == D100:
                return 1
            return 1

        h = Harness(blob, intercept_calls=intercept)
        atk = bytearray(0x80)
        atk[SKL] = 100
        h.seed(ATTACKER, bytes(atk))
        dfd = bytearray(0x80)
        dfd[STATUS_OUT] = NONE_OUT
        h.seed(DEFENDER, bytes(dfd))
        h.seed(BUFFER, b"\x00\x00\x00\x00\x00\x00\x00\x00")
        h.seed(BATTLE_DATA, bytes(0x10))
        h.run(
            offsets["End"],
            regs={"r0": ATTACKER, "r1": DEFENDER, "r2": BUFFER, "r3": BATTLE_DATA},
        )
        self.assertEqual(h.read(DEFENDER + STATUS_OUT, 1)[0], PETRIFY_BYTE)
        self.assertEqual(h.read(DEFENDER + UNIT_STATUS, 1)[0], PETRIFY_BYTE)
        state = struct.unpack("<I", h.read(DEFENDER + UNIT_STATE, 4))[0]
        self.assertTrue(state & UNSELECTABLE)


if __name__ == "__main__":
    unittest.main()
