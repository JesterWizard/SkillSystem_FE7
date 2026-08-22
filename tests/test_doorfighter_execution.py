"""Executes IndoorFighter.s / OutdoorFighter.s under Unicorn and asserts
+10 hit/+10 avo only when the attacker stands on a listed terrain ID.

Complements test_prebattle_skills_dec103.py source guards: those cannot see
the FE7 gMapTerrain address being wrong, which makes the terrain loop never
match and the boost never apply.
"""
import struct
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from Tools.thumb_harness import CODE_BASE, Harness, assemble, symbol_offsets

INDOOR_SRC = ROOT / "EngineHacks/SkillSystem/Skills/PreBattleSkills/DoorFighter/IndoorFighter.s"
OUTDOOR_SRC = ROOT / "EngineHacks/SkillSystem/Skills/PreBattleSkills/DoorFighter/OutdoorFighter.s"

ATTACKER_ADDR = 0x0203A3F0
DEFENDER_ADDR = 0x0203A470
GMAP_TERRAIN = 0x0202E3E0
ROW_TABLE = 0x02030000
TERRAIN_ROW = 0x02031000
TERRAIN_LIST = 0x02032000
HIT_OFF = 0x60
AVO_OFF = 0x62
HIT_BASE = 80
AVO_BASE = 40
BOOST = 10


def _run(src: Path, *, skill_present: bool, terrain_id: int, listed: bytes,
         x: int = 3, y: int = 2, map_ptr=ROW_TABLE) -> tuple[int, int]:
    code = assemble(src)
    offsets = symbol_offsets(src)
    h = Harness(code, skill_present=skill_present)

    h.seed(GMAP_TERRAIN, struct.pack("<I", map_ptr))
    h.seed(ROW_TABLE + y * 4, struct.pack("<I", TERRAIN_ROW))
    row = bytearray(0x20)
    row[x & 0xFF] = terrain_id
    h.seed(TERRAIN_ROW, bytes(row))
    h.seed(TERRAIN_LIST, listed)
    h.seed(CODE_BASE + offsets["SkillTester"] + 8, struct.pack("<I", TERRAIN_LIST))

    h.seed(ATTACKER_ADDR + 0x10, struct.pack("<BB", x, y))
    h.seed(ATTACKER_ADDR + HIT_OFF, struct.pack("<HH", HIT_BASE, AVO_BASE))

    h.run(offsets["GoBack"], regs={"r0": ATTACKER_ADDR, "r1": DEFENDER_ADDR})
    hit, avo = struct.unpack("<HH", h.read(ATTACKER_ADDR + HIT_OFF, 4))
    return hit, avo


class IndoorFighterExecutionTests(unittest.TestCase):
    def test_boost_applies_on_listed_indoor_terrain(self):
        hit, avo = _run(INDOOR_SRC, skill_present=True, terrain_id=24, listed=b"\x18\x00")
        self.assertEqual((hit, avo), (HIT_BASE + BOOST, AVO_BASE + BOOST))

    def test_no_boost_without_skill(self):
        hit, avo = _run(INDOOR_SRC, skill_present=False, terrain_id=24, listed=b"\x18\x00")
        self.assertEqual((hit, avo), (HIT_BASE, AVO_BASE))

    def test_no_boost_on_unlisted_terrain(self):
        hit, avo = _run(INDOOR_SRC, skill_present=True, terrain_id=1, listed=b"\x18\x00")
        self.assertEqual((hit, avo), (HIT_BASE, AVO_BASE))


class OutdoorFighterExecutionTests(unittest.TestCase):
    def test_boost_applies_on_listed_outdoor_terrain(self):
        hit, avo = _run(OUTDOOR_SRC, skill_present=True, terrain_id=1, listed=b"\x01\x00")
        self.assertEqual((hit, avo), (HIT_BASE + BOOST, AVO_BASE + BOOST))

    def test_no_boost_without_skill(self):
        hit, avo = _run(OUTDOOR_SRC, skill_present=False, terrain_id=1, listed=b"\x01\x00")
        self.assertEqual((hit, avo), (HIT_BASE, AVO_BASE))

    def test_no_boost_on_unlisted_terrain(self):
        hit, avo = _run(OUTDOOR_SRC, skill_present=True, terrain_id=24, listed=b"\x01\x00")
        self.assertEqual((hit, avo), (HIT_BASE, AVO_BASE))


EVENT = ROOT / "EngineHacks/SkillSystem/Skills/PreBattleSkills/DoorFighter/DoorFighter.event"

# FE7 interiors (EngineHacks/.../constants/terrains.h). Floor 0x17 is the
# chapter-3 building tile that the FE8 list left on OutdoorFighter.
FE7_INDOOR = (
    0x17, 0x18, 0x1D, 0x1E, 0x1F, 0x20, 0x21, 0x22, 0x2D, 0x2E,
    0x30, 0x38, 0x39, 0x3B, 0x3C, 0x3D, 0x3F,
)


def _byte_list(label: str) -> list[int]:
    text = EVENT.read_text(encoding="utf-8")
    start = text.index(label)
    chunk = text[start : text.index("ALIGN 4", start + 1)]
    ids: list[int] = []
    for line in chunk.splitlines():
        line = line.split("//")[0].strip()
        if not line.upper().startswith("BYTE"):
            continue
        for tok in line.split()[1:]:
            ids.append(int(tok, 0))
    if not ids or ids[-1] != 0:
        raise AssertionError(f"{label} must be 0-terminated")
    return ids[:-1]


class DoorFighterTerrainListTests(unittest.TestCase):
    def test_fe7_floor_is_indoor_not_outdoor(self):
        indoor = _byte_list("IndoorTerrainList:")
        outdoor = _byte_list("OutdoorTerrainList:")
        self.assertIn(0x17, indoor)
        self.assertNotIn(0x17, outdoor)

    def test_indoor_list_covers_fe7_interior_ids(self):
        indoor = set(_byte_list("IndoorTerrainList:"))
        missing = [tid for tid in FE7_INDOOR if tid not in indoor]
        self.assertEqual(missing, [])

    def test_indoor_and_outdoor_lists_do_not_overlap(self):
        indoor = set(_byte_list("IndoorTerrainList:"))
        outdoor = set(_byte_list("OutdoorTerrainList:"))
        self.assertEqual(indoor & outdoor, set())


if __name__ == "__main__":
    unittest.main()

