"""DEC-87: Provoke, Shade, Shade+ AI targeting hooks."""
import re
import struct
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

DEFS = ROOT / "EngineHacks" / "SkillSystem" / "skill_definitions.event"
MASTER = ROOT / "EngineHacks" / "SkillSystem" / "Skills" / "MasterSkillInstaller.event"
AIS = ROOT / "EngineHacks" / "SkillSystem" / "Skills" / "AISkills" / "AISkills.event"
PROVOKE = ROOT / "EngineHacks" / "SkillSystem" / "Skills" / "AISkills" / "Provoke" / "Provoke.s"
SHADE = ROOT / "EngineHacks" / "SkillSystem" / "Skills" / "AISkills" / "Shade" / "Shade.s"
SHADEPLUS = ROOT / "EngineHacks" / "SkillSystem" / "Skills" / "AISkills" / "ShadePlus" / "ShadePlus.s"
HACK = ROOT / "FE7_Hack.gba"

PROVOKE_ID, SHADE_ID, SHADEPLUS_ID = 43, 246, 247
GP_AI = 0x030013C0
G_TARGET = 0x0203A470
G_ACTOR = 0x0203A3F0
HOOK_PROVOKE, HOOK_SHADE, HOOK_SHADEPLUS = 0x39054, 0x39218, 0x386A0
# Continue after the isEnemy check (0x386C0). Skip must hit adds r6,#1
# (0x38702). Landing on cmp r6,#0xBF (0x38704) never advances the unit
# id and hangs enemy phase when Shade+ is the current candidate.
TRUE_RET, FALSE_RET = 0x080386C1, 0x08038703
JUMP = bytes.fromhex("004b1847")


def _active(path: Path) -> str:
    return "\n".join(
        line
        for line in path.read_text(encoding="utf-8").splitlines()
        if not line.lstrip().startswith("//")
    )


class AiSkillSourceTests(unittest.TestCase):
    def test_ids_are_enabled(self):
        text = DEFS.read_text(encoding="utf-8")
        for name, sid in (
            ("ProvokeID", PROVOKE_ID),
            ("ShadeID", SHADE_ID),
            ("ShadePlusID", SHADEPLUS_ID),
        ):
            m = re.search(rf"^#define\s+{name}\s+(\S+)", text, re.M)
            self.assertIsNotNone(m, name)
            self.assertEqual(int(m.group(1)), sid, name)

    def test_aiskills_installed_at_fe7_hooks(self):
        self.assertIn("AISkills/AISkills.event", _active(MASTER))
        hooks = _active(AIS)
        self.assertIn("$39054", hooks)
        self.assertIn("$39218", hooks)
        self.assertIn("$386A0", hooks)
        self.assertNotIn("$3DF78", hooks)
        self.assertNotIn("$3E154", hooks)
        self.assertNotIn("$3D5A0", hooks)
        self.assertNotIn("LungeAI", hooks)
        self.assertIn("ProvokeID", hooks)
        self.assertIn("ShadeID", hooks)
        self.assertIn("ShadePlusID", hooks)


class ProvokeExecutionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        try:
            from Tools.thumb_harness import assemble  # noqa: F401
        except ImportError as exc:
            raise unittest.SkipTest(f"thumb harness unavailable: {exc}")

    def _run(self, score, coeff, skill_present):
        from Tools.thumb_harness import Harness, assemble, symbol_offsets

        off = symbol_offsets(PROVOKE)
        table = 0x02001000
        h = Harness(assemble(PROVOKE), skill_present=skill_present)
        h.seed(GP_AI, struct.pack("<I", table))
        h.seed(table, struct.pack("<B", coeff))
        h.seed(G_TARGET, b"\x00" * 4)
        sp = 0x03000F00
        h.seed(sp, struct.pack("<II", 0, 0x0800BEEF))
        regs = h.run(
            off["Done"],
            regs={"r0": GP_AI, "r1": score, "sp": sp},
        )
        return regs["r0"], regs["r4"]

    def test_provoke_sets_weight_255_when_present(self):
        r0, r4 = self._run(score=10, coeff=2, skill_present=True)
        self.assertEqual(r4, 0xFF)
        self.assertEqual(r0, 0xFF)

    def test_provoke_caps_vanilla_weight_at_40(self):
        r0, r4 = self._run(score=30, coeff=2, skill_present=False)
        self.assertEqual(r4, 0x28)
        self.assertEqual(r0, 0x28)

    def test_provoke_keeps_uncapped_vanilla_weight(self):
        r0, r4 = self._run(score=10, coeff=2, skill_present=False)
        self.assertEqual(r4, 20)
        self.assertEqual(r0, 20)


class ShadeExecutionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        try:
            from Tools.thumb_harness import assemble  # noqa: F401
        except ImportError as exc:
            raise unittest.SkipTest(f"thumb harness unavailable: {exc}")

    def _run(self, cur_hp, coeff, skill_present, score_reg=40):
        from Tools.thumb_harness import Harness, assemble, symbol_offsets

        off = symbol_offsets(SHADE)
        table = 0x02001000
        h = Harness(assemble(SHADE), skill_present=skill_present)
        h.seed(GP_AI, struct.pack("<I", table))
        h.seed(table + 7, struct.pack("<B", coeff))
        h.seed(G_ACTOR + 0x13, struct.pack("<b", cur_hp))
        h.seed(G_TARGET, b"\x00" * 4)
        regs = h.run(off["Done"], regs={"r4": score_reg})
        return regs["r0"], regs["r4"]

    def test_shade_forces_score_1_and_returns_0(self):
        r0, r4 = self._run(cur_hp=16, coeff=2, skill_present=True, score_reg=40)
        self.assertEqual(r4, 1)
        self.assertEqual(r0, 0)

    def test_shade_absent_uses_20_minus_hp_times_coeff(self):
        r0, r4 = self._run(cur_hp=16, coeff=2, skill_present=False, score_reg=40)
        self.assertEqual(r0, 8)
        self.assertEqual(r4, 40)

    def test_shade_absent_clamps_negative_weight_to_0(self):
        r0, _ = self._run(cur_hp=30, coeff=2, skill_present=False)
        self.assertEqual(r0, 0)


class ShadePlusExecutionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        try:
            from Tools.thumb_harness import assemble  # noqa: F401
        except ImportError as exc:
            raise unittest.SkipTest(f"thumb harness unavailable: {exc}")

    def _run(self, skill_present, unit_ok=True, enemy=True, state=0):
        from Tools.thumb_harness import CODE_BASE, Harness, assemble, symbol_offsets

        off = symbol_offsets(SHADEPLUS)
        unit = 0x02020000
        char = 0x02020100
        stub = 0x02010000
        sp = 0x03000F00
        raw = assemble(SHADEPLUS)
        h = Harness(raw, skill_present=skill_present)
        h.seed(char, b"\x01" * 4)
        h.seed(unit, struct.pack("<I", char if unit_ok else 0))
        h.seed(unit + 0xC, struct.pack("<I", state))
        ret = stub + 4
        h.seed(
            stub,
            struct.pack(
                "<HHHH",
                0x2000 | (1 if enemy else 0),
                0x4770,
                0x46C0,
                0x46C0,
            ),
        )
        h.seed(sp + 0x24, struct.pack("<I", stub | 1))
        r4 = unit if unit_ok else 0
        regs = h.run(off["GoBack"], regs={"r4": r4, "sp": sp})
        return regs["r1"]

    def test_shadeplus_skip_returns_to_unit_id_increment(self):
        self.assertEqual(FALSE_RET, 0x08038702 | 1)
        self.assertEqual(TRUE_RET, 0x080386C0 | 1)

    def test_shadeplus_skips_target_when_present(self):
        self.assertEqual(self._run(skill_present=True), FALSE_RET)

    def test_shadeplus_allows_target_when_absent(self):
        self.assertEqual(self._run(skill_present=False), TRUE_RET)

    def test_shadeplus_skips_null_unit(self):
        self.assertEqual(self._run(skill_present=False, unit_ok=False), FALSE_RET)

    def test_shadeplus_skips_dead_or_hidden_unit(self):
        self.assertEqual(self._run(skill_present=False, state=0x10025), FALSE_RET)

    def test_shadeplus_skips_non_enemy(self):
        self.assertEqual(self._run(skill_present=False, enemy=False), FALSE_RET)


class AiSkillRomTests(unittest.TestCase):
    def test_rom_has_jumptohack_at_fe7_sites(self):
        if not HACK.exists():
            raise unittest.SkipTest("FE7_Hack.gba missing")
        rom = HACK.read_bytes()
        for off in (HOOK_PROVOKE, HOOK_SHADE, HOOK_SHADEPLUS):
            self.assertEqual(rom[off : off + 4], JUMP, hex(off))
        self.assertEqual(rom[0x3901C : 0x39020], bytes.fromhex("322118e0"))


if __name__ == "__main__":
    unittest.main()
