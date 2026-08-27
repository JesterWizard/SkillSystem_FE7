"""Can the summoned dragon actually equip the weapon it is handed?

Runs FE7's real CanUnitUseWeapon (0x08016380) out of the built ROM rather than
re-implementing its rules.  That chain ends in

    unit[0x28 + item.weaponType] >= item.requiredRank

Flametongue is weaponType 0x0B, so the byte read is unit+0x33 -- and
LoadUnitStats copies only EIGHT rank bytes (class+0x2C -> unit+0x28..0x2F).
unit+0x33 is therefore never populated from any table; SummonAction writes it
onto the spawned unit directly.  These tests model that unit, not a class row.

Both directions are asserted: with the byte set the weapon is usable, and with
it left at ClearUnitStruct's zero it is not.  The negative case is what proves
the write is load-bearing.
"""
from __future__ import annotations

import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(Path(__file__).resolve().parent))

from gba_machine import Gba, ROM_LOAD, UNICORN_ERROR, Uc  # noqa: E402

BUILT = ROOT / "FE7_Hack.gba"

CAN_UNIT_USE_WEAPON = 0x08016380
CHARACTER_TABLE = 0x08BDCE18
CLASS_TABLE = 0x08BE015C
CHAR_ENTRY = 0x34
CLASS_ENTRY = 0x54
ITEM_TABLE = 0x08BE222C
ITEM_ENTRY = 0x24

SUMMON_CHARACTER_ID = 0x86
SUMMON_CLASS_ID = 0x46
SUMMON_ITEM_ID = 0x8F

UNIT = 0x02020000
UNIT_SIZE = 0x48
RANK_BLOCK = 0x28


@unittest.skipUnless(Uc is not None, f"Unicorn unavailable: {UNICORN_ERROR}")
@unittest.skipUnless(BUILT.exists(), "FE7_Hack.gba not built")
class SummonWeaponUsabilityTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.rom = BUILT.read_bytes()
        item = ITEM_TABLE - ROM_LOAD + ITEM_ENTRY * SUMMON_ITEM_ID
        cls.weapon_type = cls.rom[item + 0x07]
        cls.required_rank = cls.rom[item + 0x1C]

    def _can_use(self, *, rank) -> int:
        """A spawned unit whose rank slot holds `rank`."""
        g = Gba(self.rom)
        g.uc.mem_write(UNIT, bytes(UNIT_SIZE))
        g.w32(UNIT + 0x00, CHARACTER_TABLE + CHAR_ENTRY * SUMMON_CHARACTER_ID)
        g.w32(UNIT + 0x04, CLASS_TABLE + CLASS_ENTRY * SUMMON_CLASS_ID)

        # LoadUnitStats copies class+0x2C..+0x33 into unit+0x28..+0x2F only.
        klass = CLASS_TABLE - ROM_LOAD + CLASS_ENTRY * SUMMON_CLASS_ID
        for i in range(8):
            g.w8(UNIT + RANK_BLOCK + i, self.rom[klass + 0x2C + i])
        g.w8(UNIT + RANK_BLOCK + self.weapon_type, rank)

        g.set_args(UNIT, SUMMON_ITEM_ID)
        g.run(CAN_UNIT_USE_WEAPON)
        return g.r0

    def test_the_dragon_can_use_its_weapon(self):
        self.assertEqual(
            self._can_use(rank=0xFF), 1,
            f"item 0x{SUMMON_ITEM_ID:02X} refused even at S rank",
        )

    def test_without_the_rank_write_the_weapon_is_refused(self):
        """ClearUnitStruct leaves this byte at 0, which is the vanilla state."""
        self.assertEqual(
            self._can_use(rank=0x00), 0,
            "the rank byte is not what gates this weapon",
        )

    def test_the_boundary_is_the_items_required_rank(self):
        """One below is refused, exactly at is accepted."""
        if self.required_rank == 0:
            self.skipTest("weapon has no rank requirement")
        self.assertEqual(self._can_use(rank=self.required_rank - 1), 0)
        self.assertEqual(self._can_use(rank=self.required_rank), 1)

    def test_the_class_table_cannot_supply_this_byte(self):
        """unit+0x33 is outside the 8-byte block LoadUnitStats copies."""
        self.assertGreaterEqual(
            RANK_BLOCK + self.weapon_type, RANK_BLOCK + 8,
            "weaponType is inside the copied block; the unit-side write would "
            "be unnecessary and the class table would be the right fix",
        )


if __name__ == "__main__":
    unittest.main()
