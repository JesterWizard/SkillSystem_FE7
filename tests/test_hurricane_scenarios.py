"""Hurricane across a whole turn, replayed against the built FE7_Hack.gba.

The per-round tests in test_hurricane_execution.py run one round in isolation.
That cannot catch the two bugs that actually showed up in play -- a defender
resolved from the wrong register, and a turn reset wired into a proc-script
loop so it re-ran after every unit action. Both only appear as a *sequence*.

So this file drives the real ROM routines over a scripted battle: several
rounds inside one turn, then the real ResetTurnActivationFlags, then the next
turn. Hurricane is compiled from C and reaches its helpers through ordinary
long-call thunks, so the instruction stream is left untouched: only the pooled
SkillTester and GetUnit addresses are repointed at stand-ins. SkillTester's
stand-in reads a per-unit byte, so "which unit owns Hurricane" is modelled
rather than hardcoded -- a constant would hide a wrong-defender bug.

Scenario names come from the reported behaviour, verbatim.
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

HURRICANE_SRC = ROOT / "EngineHacks/SkillSystem/Skills/ProcSkills/Hurricane/Hurricane.c"
FLAGS_SRC = ROOT / "EngineHacks/SkillSystem/Internals/SkillActivationFlags/SkillActivationFlags.c"

ROM_BASE = 0x08000000
PAGE = 0x1000
STACK = 0x03000000
STACK_SIZE = 0x1000

BATTLE_ACTOR = 0x0203A3F0   # the unit that started the fight
BATTLE_TARGET = 0x0203A470  # the unit that was attacked
ROUND_BUFFER = 0x0203A5EC
BATTLE_DATA = 0x0203A3D8
UNIT_LOOKUP = 0x02120000
UNIT_BASE = 0x02130000
UNIT_STRIDE = 0x100

ACT_FLAGS = 0x3A
HAS_SKILL_BYTE = 0x1B  # spare unit byte used as the SkillTester stub's answer
HURRICANE_BIT = 0
ATTR_MISS = 0x2

# gBattleStats.config, written wholesale by the engine before generating a
# battle: BattleGenerateSimulation stores 0x2, BattleGenerateReal 0x1 / 0x9.
CONFIG_REAL_COMBAT = 0x0001
CONFIG_FORECAST = 0x0002

GET_UNIT_LITERAL = struct.pack("<I", 0x08018D0D)  # thumb bit set by the C build
GET_UNIT_STUB = 0x02140000
SKILL_TESTER_STUB = 0x02150000

# lsls r0,r0,#2 ; ldr r1,[pc,#4] ; ldr r0,[r1,r0] ; bx lr ; .word UNIT_LOOKUP
# The literal must land at offset 8: a Thumb PC-relative load rounds PC down to
# a word boundary, so `[pc, #4]` at offset 2 reads offset 8.
GET_UNIT_STUB_CODE = bytes.fromhex("8000014908587047") + struct.pack("<I", UNIT_LOOKUP)

# ldrb r0, [r0, #HAS_SKILL_BYTE] ; bx lr
# The answer depends on which battle unit was passed in, which is the whole
# point -- a constant would hide a wrong-defender bug.
SKILL_TESTER_STUB_CODE = bytes.fromhex("c07e7047")

ACTOR_INDEX = 0x05
TARGET_INDEX = 0x0A


def _offsets(src, name):
    from Tools.thumb_harness import symbol_offsets
    return symbol_offsets(src)[name]


class Battlefield:
    """A ROM image plus RAM, driving Proc_Hurricane and ResetTurnActivationFlags."""

    def __init__(self, test, hurricane_on_actor):
        from unicorn import Uc, UC_ARCH_ARM, UC_MODE_THUMB
        from unicorn.arm_const import UC_ARM_REG_SP

        rom = built_rom.load()
        sym = built_rom.symbols()
        self.test = test
        self.sym = sym
        image = bytearray(rom)

        # Hurricane is compiled from C: its extent runs to HurricaneID_Link,
        # and both helper calls go through ordinary thunks Unicorn can decode.
        # Only the pooled destinations are redirected.
        for name in ("Proc_Hurricane", "HurricaneID_Link", "SkillTester",
                     "ResetTurnActivationFlags"):
            if name not in sym:
                raise unittest.SkipTest(f"{name} missing from FE7_Hack.sym")
        code = sym["HurricaneID_Link"] - sym["Proc_Hurricane"]
        self.entry = built_rom.offset(rom, sym["Proc_Hurricane"], code)
        self.reset_entry = built_rom.offset(rom, sym["ResetTurnActivationFlags"])

        self._repoint(image, self.entry, code,
                      struct.pack("<I", sym["SkillTester"] | 1),
                      SKILL_TESTER_STUB | 1, "SkillTester")
        self._repoint(image, self.entry, code,
                      GET_UNIT_LITERAL, GET_UNIT_STUB | 1, "GetUnit")

        # The reset loop has its own GetUnit literal.
        reset_end = built_rom.offset(
            rom, sym["SkillActivationFlagTurnResetProc"] & ~1)
        self._repoint(image, self.reset_entry, reset_end - self.reset_entry,
                      GET_UNIT_LITERAL, GET_UNIT_STUB | 1, "GetUnit (reset loop)")

        self.uc = Uc(UC_ARCH_ARM, UC_MODE_THUMB)
        size = (len(image) + PAGE - 1) // PAGE * PAGE
        self.uc.mem_map(ROM_BASE, size)
        self.uc.mem_write(ROM_BASE, bytes(image) + bytes(size - len(image)))
        self.uc.mem_map(STACK, STACK_SIZE)
        self.uc.reg_write(UC_ARM_REG_SP, STACK + STACK_SIZE - 0x100)
        for addr in (0x0203A000, UNIT_LOOKUP, UNIT_BASE,
                     GET_UNIT_STUB, SKILL_TESTER_STUB):
            self.uc.mem_map(addr, PAGE)
        self.uc.mem_write(GET_UNIT_STUB, GET_UNIT_STUB_CODE)
        self.uc.mem_write(SKILL_TESTER_STUB, SKILL_TESTER_STUB_CODE)

        self.uc.mem_write(UNIT_LOOKUP, bytes(0x100 * 4))
        for bu, index in ((BATTLE_ACTOR, ACTOR_INDEX), (BATTLE_TARGET, TARGET_INDEX)):
            unit = UNIT_BASE + index * UNIT_STRIDE
            self.uc.mem_write(bu + 0x4, struct.pack("<I", 0x08000000))  # class data
            self.uc.mem_write(bu + 0xB, bytes([index]))
            self.uc.mem_write(UNIT_LOOKUP + index * 4, struct.pack("<I", unit))
            self.uc.mem_write(unit, struct.pack("<I", 0x08000000))      # pCharacterData
            self.uc.mem_write(unit + 0xB, bytes([index]))
            self.uc.mem_write(unit + ACT_FLAGS, struct.pack("<H", 0))

        holder = BATTLE_ACTOR if hurricane_on_actor else BATTLE_TARGET
        self.holder_index = ACTOR_INDEX if hurricane_on_actor else TARGET_INDEX
        self.uc.mem_write(holder + HAS_SKILL_BYTE, b"\x01")

    # -- stubs -------------------------------------------------------------

    def _repoint(self, image, base, size, literal, target, what):
        """Point one pooled call destination at a stand-in routine.

        The C build reaches SkillTester and GetUnit through normal long-call
        thunks, so unlike the old hand-written assembly there is no `.short
        0xf800` to rewrite -- swapping the pooled address is enough, and the
        real call sequence still executes.
        """
        pool = image.find(literal, base, base + size)
        self.test.assertNotEqual(pool, -1, f"{what} literal missing")
        struct.pack_into("<I", image, pool, target)

    # -- driving -----------------------------------------------------------

    def _call(self, entry, regs):
        from unicorn.arm_const import (UC_ARM_REG_R0, UC_ARM_REG_R1, UC_ARM_REG_R2,
                                       UC_ARM_REG_R3, UC_ARM_REG_LR)
        stop = ROM_BASE + 0x100  # cartridge header; never a real return target
        mapping = {"r0": UC_ARM_REG_R0, "r1": UC_ARM_REG_R1,
                   "r2": UC_ARM_REG_R2, "r3": UC_ARM_REG_R3}
        for name, val in regs.items():
            self.uc.reg_write(mapping[name], val)
        self.uc.reg_write(UC_ARM_REG_LR, stop | 1)
        self.uc.emu_start((ROM_BASE + entry) | 1, stop, timeout=1_000_000)

    def round(self, attacker, damage=7, already_missed=False,
              config=CONFIG_REAL_COMBAT):
        """Run one combat round; return "hit" or "dodged"."""
        # ProcLoop_Start leaves damage at 0 on a round it already ruled a miss.
        attrs = ATTR_MISS if already_missed else 0
        self.uc.mem_write(BATTLE_DATA, struct.pack("<H", config))
        self.uc.mem_write(ROUND_BUFFER, struct.pack("<I", attrs))
        self.uc.mem_write(BATTLE_DATA + 0x4, struct.pack("<h", 0 if already_missed else damage))
        self._call(self.entry, {"r0": attacker, "r1": BATTLE_TARGET,
                                "r2": ROUND_BUFFER, "r3": BATTLE_DATA})
        out = struct.unpack("<I", self.uc.mem_read(ROUND_BUFFER, 4))[0]
        dealt = struct.unpack("<h", self.uc.mem_read(BATTLE_DATA + 0x4, 2))[0]
        if out & ATTR_MISS:
            self.test.assertEqual(dealt, 0, "a missed round must deal no damage")
            return "missed" if already_missed else "dodged"
        return "hit"

    def start_of_player_phase(self):
        """Run the real once-per-turn reset over every unit."""
        self._call(self.reset_entry, {})

    def flags(self, index=None):
        index = self.holder_index if index is None else index
        addr = UNIT_BASE + index * UNIT_STRIDE + ACT_FLAGS
        return struct.unpack("<H", self.uc.mem_read(addr, 2))[0]

    def charged(self):
        return not (self.flags() & (1 << HURRICANE_BIT))


class ScenarioTests(unittest.TestCase):
    """Reported scenarios, replayed step by step."""

    def test_scenario_1_attack_then_counter_then_enemy_phase(self):
        # Hurricane unit initiates: it is gBattleActor, the enemy gBattleTarget.
        f = Battlefield(self, hurricane_on_actor=True)
        self.assertTrue(f.charged(), "starts the turn charged")

        # Player phase: our unit swings first. It is attacking, not defending.
        self.assertEqual(f.round(attacker=BATTLE_ACTOR), "hit",
                         "Hurricane must not affect its owner's own attack")
        self.assertTrue(f.charged(), "attacking must not spend the dodge")

        # The enemy counters. This is the first attack against our unit.
        self.assertEqual(f.round(attacker=BATTLE_TARGET), "dodged")
        self.assertFalse(f.charged(), "the counter should have spent the dodge")

        # Any further attack this turn connects.
        self.assertEqual(f.round(attacker=BATTLE_TARGET), "hit")
        self.assertEqual(f.round(attacker=BATTLE_TARGET), "hit")

        # Enemy phase, same turn: still spent.
        self.assertEqual(f.round(attacker=BATTLE_TARGET), "hit",
                         "the dodge is once per turn, not once per combat")

        # Start of next turn: recharged.
        f.start_of_player_phase()
        self.assertTrue(f.charged(), "the reset must give the dodge back")
        self.assertEqual(f.round(attacker=BATTLE_TARGET), "dodged")

    def test_scenario_2_no_attack_then_enemy_phase(self):
        # Our unit is attacked, so it is gBattleTarget.
        f = Battlefield(self, hurricane_on_actor=False)
        self.assertTrue(f.charged())

        # Enemy phase: the enemy initiates, our unit has not acted this turn.
        self.assertEqual(f.round(attacker=BATTLE_ACTOR), "dodged")
        self.assertFalse(f.charged())

        self.assertEqual(f.round(attacker=BATTLE_ACTOR), "hit",
                         "only the first attack of the turn is dodged")

        f.start_of_player_phase()
        self.assertTrue(f.charged())
        self.assertEqual(f.round(attacker=BATTLE_ACTOR), "dodged")

    def test_a_natural_miss_spends_the_dodge_and_the_double_connects(self):
        """The whole combat is resolved up front by MakeBattle (0x08028FB0).

        If a natural miss left the charge up, Hurricane would dodge the *second*
        round of that same combat instead of the first -- the enemy misses, then
        appears to be blocked on the follow-up swing. Reads as the skill firing
        inconsistently.
        """
        f = Battlefield(self, hurricane_on_actor=False)
        self.assertEqual(f.round(attacker=BATTLE_ACTOR, already_missed=True), "missed")
        self.assertFalse(f.charged(), "a natural miss is still the first attack")
        self.assertEqual(f.round(attacker=BATTLE_ACTOR), "hit",
                         "the doubling round must not be dodged")

    def test_previewing_targets_all_turn_never_spends_the_dodge(self):
        """Players open the forecast constantly -- on every target they hover.

        Each of those runs this same proc loop. Reported symptom: "as soon as I
        open the forecast menu the bit is being set", so the enemy phase that
        followed had no dodge left.
        """
        f = Battlefield(self, hurricane_on_actor=False)
        for _ in range(10):
            self.assertEqual(f.round(attacker=BATTLE_ACTOR, config=CONFIG_FORECAST),
                             "hit", "a forecast must never show a dodge")
            self.assertTrue(f.charged(), "a forecast must never spend the dodge")

        # The real fight, finally.
        self.assertEqual(f.round(attacker=BATTLE_ACTOR), "dodged")
        self.assertFalse(f.charged())

    def test_the_reset_does_not_run_between_actions(self):
        """Guards the proc-script-loop bug: the reset belongs above LABEL(0)."""
        f = Battlefield(self, hurricane_on_actor=False)
        self.assertEqual(f.round(attacker=BATTLE_ACTOR), "dodged")
        for _ in range(5):  # five more unit actions in the same turn
            self.assertEqual(f.round(attacker=BATTLE_ACTOR), "hit")
        self.assertFalse(f.charged())

    def test_the_other_unit_never_gains_a_flag(self):
        f = Battlefield(self, hurricane_on_actor=False)
        f.round(attacker=BATTLE_ACTOR)
        self.assertEqual(f.flags(ACTOR_INDEX), 0,
                         "the attacker must not have its flags touched")

    def test_a_unit_without_hurricane_is_never_dodging(self):
        f = Battlefield(self, hurricane_on_actor=True)
        # Attack the enemy (gBattleTarget), which has no Hurricane.
        for _ in range(3):
            self.assertEqual(f.round(attacker=BATTLE_ACTOR), "hit")
        self.assertEqual(f.flags(TARGET_INDEX), 0)


if __name__ == "__main__":
    unittest.main()
