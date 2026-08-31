"""Tests for newly ported FE8 proc skills in FE7 SkillSystem."""
import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from lyn_bytes import lyn_to_bytes

ROOT = Path(__file__).resolve().parents[1]
PROC_DIR = ROOT / "EngineHacks" / "SkillSystem" / "Skills" / "ProcSkills"
CALC_DIR = ROOT / "EngineHacks" / "Necessary" / "CalcLoops"


class ProcSkillsPortTests(unittest.TestCase):
    def test_aether_wiring_and_hit_count(self):
        hit_src = (PROC_DIR / "Adept" / "get_battle_unit_hit_count.s").read_text(encoding="utf-8")
        self.assertIn("AetherID", hit_src)
        self.assertIn("lsr r0, r0, #1", hit_src)
        self.assertIn("0x42", hit_src)

        aether_src = (PROC_DIR / "Aether" / "proc_aether.s").read_text(encoding="utf-8")
        self.assertIn("AetherSwing", aether_src)
        self.assertIn("FirstHit", aether_src)
        self.assertIn("LunaHit", aether_src)
        self.assertIn("LiquidOozeID", aether_src)

    def test_barricade_and_barricade_plus_halving(self):
        start_src = (CALC_DIR / "BattleProcCalcLoop" / "ProcStart" / "proc_start.s").read_text(encoding="utf-8")
        self.assertIn("lsr r0, r0, r1 @ r0 has corrected damage.", start_src)
        self.assertIn("lsr r0, r0, #0x01 @ r0 has the corrected damage.", start_src)

    def test_counter_and_countermagic_attacker_hp_update(self):
        counter_src = (PROC_DIR / "Counter" / "proc_counter.s").read_text(encoding="utf-8")
        self.assertIn("strb r1, [r4, #0x13]", counter_src)
        self.assertIn("#0x80", counter_src)
        self.assertNotIn("0x0203AA02", counter_src)

        countermagic_src = (PROC_DIR / "Countermagic" / "proc_countermagic.s").read_text(encoding="utf-8")
        self.assertIn("strb r1, [r4, #0x13]", countermagic_src)
        self.assertIn("#0x80", countermagic_src)
        self.assertNotIn("0x0203AA02", countermagic_src)

    def test_corona_activation_check(self):
        corona_src = (PROC_DIR / "Corona" / "proc_corona.s").read_text(encoding="utf-8")
        self.assertIn("CheckRate:", corona_src)
        self.assertIn("d100Result", corona_src)

    def test_downwitharch_fe7_string_lookup(self):
        arch_src = (PROC_DIR / "DownWithArch" / "proc_downwitharch.s").read_text(encoding="utf-8")
        self.assertIn("0x08012C61", arch_src)
        self.assertNotIn("0x815D48C", arch_src)

    def test_devil_skills_fe7_item_effect(self):
        devil_src = (PROC_DIR / "Devil" / "proc_devil.s").read_text(encoding="utf-8")
        self.assertIn("0x8017424", devil_src)
        self.assertNotIn("0x080177C0", devil_src)

    def test_activation_rate_calc_loop_fe7_addresses(self):
        event_src = (CALC_DIR / "SkillActivationChanceCalcLoop" / "SkillActivationChanceCalcLoop.event").read_text(encoding="utf-8")
        self.assertIn("ORG $2857C", event_src)
        self.assertNotIn("ORG $2A52E", event_src)

        loop_src = (CALC_DIR / "SkillActivationChanceCalcLoop" / "SkillActivationChanceCalcLoop.s").read_text(encoding="utf-8")
        self.assertIn("0x08000E60", loop_src)
        self.assertNotIn("0x802A53B", loop_src)

    def test_proc_loop_parent_wiring(self):
        proc_parent = (CALC_DIR / "BattleProcCalcLoop" / "BattleProcCalcLoop.event").read_text(encoding="utf-8")
        self.assertIn("DownWithArch", proc_parent)
        self.assertIn("Proc_BlackMagic", proc_parent)
        self.assertIn("Proc_Corona", proc_parent)
        self.assertIn("Proc_Corrosion", proc_parent)
        self.assertIn("Proc_Moonbow", proc_parent)
        self.assertIn("Proc_Aether", proc_parent)
        self.assertIn("Proc_Ignis", proc_parent)
        self.assertIn("Proc_Luna", proc_parent)
        self.assertIn("Proc_Devil", proc_parent)
        self.assertIn("Proc_Counter", proc_parent)
        self.assertIn("Proc_Foresight", proc_parent)


if __name__ == "__main__":
    unittest.main()
