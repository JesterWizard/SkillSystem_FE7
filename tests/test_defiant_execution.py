"""Execute the built ROM's Defiant Defense routine on a real ARM7TDMI core.

Every other Defiant test reads source or checks that bytes are wired into a
pointer list. None of them prove the shipped code actually returns a boosted
stat. This one locates prDefiantDef by walking the Defense modifier chain in
FE7_Hack.gba, then runs those exact ROM bytes under Unicorn against a
synthetic unit struct and asserts the returned value.

The reported bug was a unit at 4/16 HP with Defiant Defense showing no boost,
so 4/16 is the headline case: 4 * 4 == 16 is "at 25%", which must boost.

The skill-lookup call is stubbed by the harness (see thumb_harness's
_patch_skilltester_trampoline), so this isolates the threshold arithmetic and
the +4 from whether the unit actually owns the skill -- skill assignment is
editor data, which the project's TDD rules keep out of tests.
"""
import struct
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

HACK = ROOT / "FE7_Hack.gba"

DEF_GETTER = 0x18B70  # FE7 GetUnitDefense
UNIT = 0x02000000  # synthetic unit struct
UNIT_MAXHP = 0x12
UNIT_CURHP = 0x13
BASE_DEF = 10
DEFIANT_BONUS = 4

# DefiantSkill.lyn.event prologue + 25%-of-max-HP threshold check:
#   push {r4-r6,lr}; mov r4,r0; mov r5,r1;
#   ldrb r0,[r5,#0x12]; ldrb r1,[r5,#0x13]; lsl r1,r1,#2; cmp r1,r0
DEFIANT_SIG = bytes.fromhex("70b5041c0d1ca87ce97c89008142")

# Offsets within the routine (see DefiantSkill.lyn.event).
ROUTINE_LEN = 44
STOP_AT_POP = 40  # `pop {r4-r6,pc}`: r0 already holds the result


def _rom_off(addr: int) -> int:
    return (addr & ~1) - 0x08000000


def _find_defiant_def(rom: bytes) -> bytes:
    """Walk GetUnitDefense -> pDefenseModifiers and return the Defiant routine."""
    getter = _rom_off(struct.unpack_from("<I", rom, DEF_GETTER + 4)[0])
    modifier_list = struct.unpack_from("<I", rom, getter + 24)[0]

    cursor = _rom_off(modifier_list)
    while True:
        ptr = struct.unpack_from("<I", rom, cursor)[0]
        if ptr == 0:
            break
        off = _rom_off(ptr)
        body = rom[off : off + ROUTINE_LEN]
        if DEFIANT_SIG in body:
            return body
        cursor += 4
    raise AssertionError("no Defiant routine in the Defense modifier chain")


@unittest.skipUnless(HACK.exists(), "FE7_Hack.gba missing")
class DefiantDefenseExecutionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        try:
            from Tools.thumb_harness import Harness  # noqa: F401
        except ImportError as exc:  # unicorn or devkitARM absent
            raise unittest.SkipTest(f"thumb harness unavailable: {exc}")
        rom = HACK.read_bytes()  # FE7_Hack.gba — ROM test, after assemble
        if rom[DEF_GETTER : DEF_GETTER + 4] != bytes.fromhex("004b1847"):
            raise unittest.SkipTest("GetUnitDefense is not hooked")
        cls.code = _find_defiant_def(rom)

    def _run(self, cur_hp: int, max_hp: int, skill_present: bool = True) -> int:
        from Tools.thumb_harness import Harness

        h = Harness(self.code, skill_present=skill_present)
        h.seed(UNIT + UNIT_MAXHP, struct.pack("B", max_hp))
        h.seed(UNIT + UNIT_CURHP, struct.pack("B", cur_hp))
        regs = h.run(STOP_AT_POP, regs={"r0": BASE_DEF, "r1": UNIT})
        return regs["r0"]

    def test_reported_bug_four_of_sixteen_hp_boosts(self):
        """The exact reported case: 4/16 HP must apply +4 Defense."""
        self.assertEqual(self._run(cur_hp=4, max_hp=16), BASE_DEF + DEFIANT_BONUS)

    def test_exactly_at_threshold_boosts(self):
        # cur*4 == max is "at 25%", which the >= wording includes.
        for cur, mx in ((4, 16), (5, 20), (1, 4), (10, 40)):
            with self.subTest(hp=f"{cur}/{mx}"):
                self.assertEqual(self._run(cur, mx), BASE_DEF + DEFIANT_BONUS)

    def test_below_threshold_boosts(self):
        for cur, mx in ((1, 16), (2, 16), (3, 16)):
            with self.subTest(hp=f"{cur}/{mx}"):
                self.assertEqual(self._run(cur, mx), BASE_DEF + DEFIANT_BONUS)

    def test_above_threshold_does_not_boost(self):
        for cur, mx in ((5, 16), (8, 16), (16, 16), (9, 20)):
            with self.subTest(hp=f"{cur}/{mx}"):
                self.assertEqual(self._run(cur, mx), BASE_DEF)

    def test_no_boost_without_the_skill(self):
        self.assertEqual(
            self._run(cur_hp=4, max_hp=16, skill_present=False), BASE_DEF
        )


if __name__ == "__main__":
    unittest.main()
