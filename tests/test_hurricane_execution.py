"""Hurricane: dodges the first attack against this unit every turn.

Executes Proc_Hurricane's bytes straight out of the built FE7_Hack.gba, with
the whole ROM mapped, so the real CanSkillActivationFlagProc /
SetSkillActivationFlag routines and the real SkillActivationFlagTable /
SkillActivationFlagScope are the ones exercised. A source-only test would not
notice the skill being absent from the proc loop, the flag bit being
unassigned, or the ID lookup landing on the wrong table row.

Only the two `.short 0xf800` trampolines are rewritten -- Unicorn cannot decode
a lone BL-suffix halfword -- and the rewrites keep each call's observable
effect (SkillTester's boolean, GetUnit's array read).
"""
import struct
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))
sys.path.insert(0, str(Path(__file__).resolve().parent))

import built_rom  # noqa: E402  (FE7_Hack.gba loader with an assembled-ROM check)

BUILT = built_rom.BUILT
SYMS = built_rom.SYMS

ROM_BASE = 0x08000000
PAGE = 0x1000
STACK = 0x03000000
STACK_SIZE = 0x1000

# Battle unit / round memory. Real FE7 addresses, so the stat-screen guard and
# the buffer layout are exercised against realistic values.
ATTACKER = 0x0203A3F0
DEFENDER = 0x0203A470
ROUND_BUFFER = 0x0203A5EC
BATTLE_DATA = 0x0203A3D8
UNIT_LOOKUP = 0x02120000  # stand-in for the array GetUnit indexes
UNIT = 0x02130000         # the deployed Unit that owns the activation flags

SRC = ROOT / "EngineHacks/SkillSystem/Skills/ProcSkills/Hurricane/Hurricane.c"

DEFENDER_INDEX = 0x05
ACT_FLAGS = 0x3A
HURRICANE_BIT = 0
ATTR_MISS = 0x2
ATTR_ATTACKER_SKILL = 0x4000
ATTR_DEFENDER_SKILL = 0x8000

# gBattleStats.config, written wholesale by the engine before generating a
# battle: BattleGenerateSimulation stores 0x2, BattleGenerateReal 0x1 / 0x9.
CONFIG_REAL_COMBAT = 0x0001
CONFIG_FORECAST = 0x0002

GET_UNIT_LITERAL = struct.pack("<I", 0x08018D0D)  # thumb bit set by the C build
SKILL_TESTER_STUB = 0x02150000
GET_UNIT_STUB = 0x02140000

# lsls r0,r0,#2 ; ldr r1,[pc,#4] ; ldr r0,[r1,r0] ; bx lr ; .word UNIT_LOOKUP
# The literal must land at offset 8: a Thumb PC-relative load rounds PC down to
# a word boundary, so `[pc, #4]` at offset 2 reads offset 8.
GET_UNIT_STUB_CODE = bytes.fromhex("8000014908587047") + struct.pack("<I", UNIT_LOOKUP)


def _skill_tester_stub(present):
    """`movs r0, #present ; bx lr` -- a SkillTester that always answers."""
    return struct.pack("<HH", 0x2000 | (1 if present else 0), 0x4770)


_symbols = built_rom.symbols
_rom = built_rom.load

def _bounds():
    """Proc_Hurricane's extent in the ROM, from the symbol file.

    Hurricane is compiled from C, so there is no trailing EA literal block whose
    offset could be read from a .s -- gcc places its literal pool inside the
    routine. The routine runs from Proc_Hurricane to HurricaneID_Link.
    """
    rom, sym = _rom(), _symbols()
    for name in ("Proc_Hurricane", "HurricaneID_Link"):
        if name not in sym:
            raise unittest.SkipTest(f"{name} missing from FE7_Hack.sym")
    size = sym["HurricaneID_Link"] - sym["Proc_Hurricane"]
    base = built_rom.offset(rom, sym["Proc_Hurricane"], size)
    return rom, sym, base, size


def _skill_id():
    rom, sym = _rom(), _symbols()
    if "HurricaneID_Link" not in sym:
        raise unittest.SkipTest("HurricaneID_Link missing from FE7_Hack.sym")
    return struct.unpack_from(
        "<I", rom, built_rom.offset(rom, sym["HurricaneID_Link"], 4))[0]


class HurricaneWiringTests(unittest.TestCase):
    """Structural checks: the routine has to be reachable and correctly fed."""

    def test_hurricane_runs_first_in_the_battle_proc_loop(self):
        rom, sym = _rom(), _symbols()
        for name in ("Proc_Hurricane", "ProcLoop_Start", "ProcLoopParent"):
            self.assertIn(name, sym, f"{name} missing from the symbol file")
        table = rom.find(struct.pack("<I", sym["ProcLoop_Start"]),
                         built_rom.offset(rom, sym["ProcLoopParent"]))
        self.assertNotEqual(table, -1, "proc loop table not found")
        nxt = struct.unpack_from("<I", rom, table + 4)[0]
        self.assertEqual(
            nxt, sym["Proc_Hurricane"],
            "Hurricane must run immediately after ProcLoop_Start, before any "
            "skill that reads or edits the round's damage",
        )

    def test_hurricane_literals_point_at_the_activation_flag_routines(self):
        """The compiled routine must actually reference the flag API.

        With C the calls are resolved by lyn into literal pools inside the
        routine, so this checks the routine's own bytes carry those addresses
        rather than reading a fixed trailing block.
        """
        rom, sym, base, size = _bounds()
        body = rom[base:base + size]
        for name in ("SkillTester", "CanSkillActivationFlagProc", "SetSkillActivationFlag"):
            self.assertIn(name, sym, f"{name} missing from the symbol file")
            self.assertIn(
                struct.pack("<I", sym[name] | 1), body,
                f"Proc_Hurricane never references {name}")

        skill_id = _skill_id()
        self.assertNotEqual(skill_id, 255, "HurricaneID is SKILL_OFF; the skill is disabled")
        self.assertTrue(1 <= skill_id <= 254, f"HurricaneID {skill_id} is out of range")

    def test_hurricane_owns_a_once_per_turn_activation_bit(self):
        rom, sym = _rom(), _symbols()
        skill_id = _skill_id()
        entry = rom[built_rom.offset(rom, sym["SkillActivationFlagTable"], 256) + skill_id]
        self.assertNotEqual(entry, 0, "Hurricane has no activation flag; it would proc every round")
        bit = entry - 1
        self.assertEqual(bit, HURRICANE_BIT)
        scope = rom[built_rom.offset(rom, sym["SkillActivationFlagScope"], 16) + bit]
        self.assertEqual(scope, 0, "Hurricane resets every turn, not every map")


class HurricaneExecutionTests(unittest.TestCase):
    """Runs the ROM bytes. Both sides of every branch."""

    def _run(self, *, has_skill=True, flags=0x0000, attributes=0x0000, damage=7,
             class_data=0x08000000, initiated_by_hurricane_unit=False,
             config=CONFIG_REAL_COMBAT):
        """Run one round.

        `initiated_by_hurricane_unit` picks the combat direction. False models
        "the Hurricane unit was attacked": it is gBattleTarget, and the round's
        attacker is gBattleActor. True models "the Hurricane unit attacked and
        is now eating the counter": it is gBattleActor, and the round's attacker
        is gBattleTarget -- the direction where the proc loop's hardcoded r1
        points at the wrong unit.
        """
        try:
            from unicorn import Uc, UC_ARCH_ARM, UC_MODE_THUMB
            from unicorn.arm_const import (UC_ARM_REG_R0, UC_ARM_REG_R1, UC_ARM_REG_R2,
                                           UC_ARM_REG_R3, UC_ARM_REG_LR, UC_ARM_REG_SP)
        except ImportError as exc:
            raise unittest.SkipTest(f"unicorn unavailable: {exc}")

        rom, sym, base, code = _bounds()
        image = bytearray(rom)

        # The C build calls both helpers through ordinary long-call thunks that
        # Unicorn decodes, so nothing needs rewriting in the instruction stream:
        # only the two pooled destinations get pointed at stand-ins.
        tester_pool = image.find(struct.pack("<I", sym["SkillTester"] | 1), base, base + code)
        self.assertNotEqual(tester_pool, -1, "SkillTester literal missing from Proc_Hurricane")
        struct.pack_into("<I", image, tester_pool, SKILL_TESTER_STUB | 1)

        pool = image.find(GET_UNIT_LITERAL, base, base + code)
        self.assertNotEqual(pool, -1, "GetUnit literal missing from the pool")
        struct.pack_into("<I", image, pool, GET_UNIT_STUB | 1)

        uc = Uc(UC_ARCH_ARM, UC_MODE_THUMB)
        size = (len(image) + PAGE - 1) // PAGE * PAGE
        uc.mem_map(ROM_BASE, size)
        uc.mem_write(ROM_BASE, bytes(image) + bytes(size - len(image)))
        uc.mem_map(STACK, STACK_SIZE)
        uc.reg_write(UC_ARM_REG_SP, STACK + STACK_SIZE - 0x100)
        for addr in (0x0203A000, 0x02120000, 0x02130000,
                     GET_UNIT_STUB, SKILL_TESTER_STUB):
            uc.mem_map(addr, PAGE)
        uc.mem_write(GET_UNIT_STUB, GET_UNIT_STUB_CODE)
        uc.mem_write(SKILL_TESTER_STUB, _skill_tester_stub(has_skill))

        defender = ATTACKER if initiated_by_hurricane_unit else DEFENDER
        round_attacker = DEFENDER if initiated_by_hurricane_unit else ATTACKER
        uc.mem_write(defender + 0x4, struct.pack("<I", class_data))
        uc.mem_write(defender + 0xB, bytes([DEFENDER_INDEX]))
        uc.mem_write(UNIT_LOOKUP + DEFENDER_INDEX * 4, struct.pack("<I", UNIT))
        uc.mem_write(UNIT + ACT_FLAGS, struct.pack("<H", flags))
        # The other battle unit is a valid but skill-less bystander.
        other = ATTACKER if defender == DEFENDER else DEFENDER
        uc.mem_write(other + 0x4, struct.pack("<I", 0x08000000))
        uc.mem_write(other + 0xB, bytes([DEFENDER_INDEX + 1]))
        uc.mem_write(ROUND_BUFFER, struct.pack("<I", attributes))
        uc.mem_write(BATTLE_DATA, struct.pack("<H", config))
        uc.mem_write(BATTLE_DATA + 0x4, struct.pack("<h", damage))

        stop = ROM_BASE + 0x100  # cartridge header; never a valid return target
        for reg, val in ((UC_ARM_REG_R0, round_attacker), (UC_ARM_REG_R1, DEFENDER),
                         (UC_ARM_REG_R2, ROUND_BUFFER), (UC_ARM_REG_R3, BATTLE_DATA),
                         (UC_ARM_REG_LR, stop | 1)):
            uc.reg_write(reg, val)
        uc.emu_start((ROM_BASE + base) | 1, stop, timeout=200_000)

        return {
            "attributes": struct.unpack("<I", uc.mem_read(ROUND_BUFFER, 4))[0],
            "damage": struct.unpack("<h", uc.mem_read(BATTLE_DATA + 0x4, 2))[0],
            "flags": struct.unpack("<H", uc.mem_read(UNIT + ACT_FLAGS, 2))[0],
        }

    def test_first_attack_of_the_turn_is_dodged(self):
        out = self._run()
        self.assertTrue(out["attributes"] & ATTR_MISS, "the round should have become a miss")
        self.assertEqual(out["damage"], 0, "a dodged attack deals nothing")
        self.assertEqual(out["flags"], 1 << HURRICANE_BIT, "the dodge should have been spent")

    def test_second_attack_in_the_same_turn_connects(self):
        out = self._run(flags=1 << HURRICANE_BIT)
        self.assertFalse(out["attributes"] & ATTR_MISS, "only the first attack is dodged")
        self.assertEqual(out["damage"], 7, "damage must survive untouched")
        self.assertEqual(out["flags"], 1 << HURRICANE_BIT)

    def test_unit_without_the_skill_is_untouched(self):
        out = self._run(has_skill=False)
        self.assertFalse(out["attributes"] & ATTR_MISS)
        self.assertEqual(out["damage"], 7)
        self.assertEqual(out["flags"], 0x0000, "no skill, no flag spent")

    def test_an_already_missed_round_still_spends_the_dodge(self):
        """"Dodges the first attack" counts the first attack, hit or miss.

        ProcLoop_Start rolls true hit before Hurricane runs, so a round that
        missed on its own arrives already carrying ATTR_MISS. It is still the
        first attack against the unit, so it spends the charge -- there is just
        nothing left to rewrite. Letting the charge survive here would push the
        dodge onto the second swing of the same combat, which is what the skill
        firing late looks like in game.
        """
        out = self._run(attributes=ATTR_MISS)
        self.assertEqual(out["flags"], 1 << HURRICANE_BIT,
                         "a natural miss is still the first attack")
        self.assertEqual(out["damage"], 7, "a round Hurricane did not rewrite is untouched")

    def test_stands_down_when_another_skill_claimed_the_round(self):
        for attr, label in ((ATTR_ATTACKER_SKILL, "attacker"), (ATTR_DEFENDER_SKILL, "defender")):
            with self.subTest(skill=label):
                out = self._run(attributes=attr)
                self.assertFalse(out["attributes"] & ATTR_MISS)
                self.assertEqual(out["flags"], 0x0000)

    def test_battle_forecast_neither_dodges_nor_spends_the_charge(self):
        """The forecast runs this same loop; it must change nothing."""
        out = self._run(config=CONFIG_FORECAST)
        self.assertFalse(out["attributes"] & ATTR_MISS,
                         "the forecast must not turn the round into a miss")
        self.assertEqual(out["damage"], 7, "the forecast must not zero damage")
        self.assertEqual(out["flags"], 0x0000,
                         "opening the forecast must not spend the dodge")

    def test_stat_screen_forecast_is_skipped(self):
        # The proc loop also runs for the battle forecast, where the battle
        # unit has no class data. The dodge must not be spent on a preview.
        out = self._run(class_data=0)
        self.assertEqual(out["flags"], 0x0000, "forecast must not spend the dodge")
        self.assertFalse(out["attributes"] & ATTR_MISS)
        self.assertEqual(out["damage"], 7)

    def test_dodge_works_on_a_counterattack(self):
        # Regression: the proc loop passes only r0 (the round's attacker) and
        # hardcodes r1 = gBattleTarget, so a routine that trusted r1 tested the
        # wrong unit whenever the skill holder was the one who started the
        # fight. Hurricane derives the defender from r0 instead.
        out = self._run(initiated_by_hurricane_unit=True)
        self.assertTrue(out["attributes"] & ATTR_MISS,
                        "Hurricane must also dodge the counterattack after it attacks")
        self.assertEqual(out["damage"], 0)
        self.assertEqual(out["flags"], 1 << HURRICANE_BIT)

    def test_counterattack_dodge_is_still_once_per_turn(self):
        out = self._run(initiated_by_hurricane_unit=True, flags=1 << HURRICANE_BIT)
        self.assertFalse(out["attributes"] & ATTR_MISS)
        self.assertEqual(out["damage"], 7)

    def test_counterattack_without_the_skill_is_untouched(self):
        out = self._run(initiated_by_hurricane_unit=True, has_skill=False)
        self.assertFalse(out["attributes"] & ATTR_MISS)
        self.assertEqual(out["damage"], 7)
        self.assertEqual(out["flags"], 0x0000)

    def test_high_damage_round_is_zeroed(self):
        out = self._run(damage=99)
        self.assertEqual(out["damage"], 0)
        self.assertTrue(out["attributes"] & ATTR_MISS)

    def test_damage_data_in_the_high_bits_survives_the_rewrite(self):
        # The attribute word packs damage data above bit 18; the miss rewrite
        # must preserve it rather than clobber the whole word.
        high = 0xABC00000
        out = self._run(attributes=high)
        self.assertEqual(out["attributes"] & 0xFFF80000, high & 0xFFF80000)
        self.assertTrue(out["attributes"] & ATTR_MISS)


if __name__ == "__main__":
    unittest.main()
