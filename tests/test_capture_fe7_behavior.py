from pathlib import Path
import unittest


ROOT = Path(__file__).resolve().parents[1]
CAPTURE = (
    ROOT
    / "EngineHacks"
    / "SkillSystem"
    / "Skills"
    / "UnitMenuSkills"
    / "Capture"
    / "Capture"
)


class CaptureFe7BehaviorTests(unittest.TestCase):
    def test_installs_fe7_entry_hooks(self):
        event = (CAPTURE / "Capture.event").read_text()

        self.assertIn("#ifdef _FE7_", event)
        self.assertIn("ORG $2F960", event)
        self.assertIn("jumpToHack(After_Battle_Rescue)", event)
        self.assertIn("ORG $25224", event)
        self.assertIn("ORG $25298", event)
        self.assertIn("SHORT 0x46C0", event)
        self.assertIn("SHORT 0xD00E", event)
        self.assertIn("ORG $23CC0", event)
        self.assertIn("jumpToHack(Trade_Target_List)", event)
        self.assertIn("ORG $2B0D4", event)
        self.assertIn("ORG $2B0EC", event)
        self.assertIn("ORG $2AE14", event)
        self.assertIn("callHack_r3(Trade_Item_Usability_Fix)", event)
        self.assertIn("callHack_r3(Trade_Portrait_Fix1)", event)
        self.assertIn("callHack_r3(Trade_Portrait_Fix2)", event)

        for invalid_fe8_hook in (
            "ORG $2D7D4",
            "ORG $2D7EC",
        ):
            self.assertNotIn(invalid_fe8_hook, event)

    def test_post_battle_handler_rescues_before_vanilla_death_processing(self):
        source = (CAPTURE / "After_Battle_Rescue.s").read_text()

        self.assertIn("0x0802F754", source)
        self.assertIn("0x08017DE4", source)
        self.assertIn("0x0802F808", source)
        self.assertIn("strb\tr0, [r4, #0x13]", source)

    def test_preserves_rescued_enemy_unit_data_from_fe7_kill_unit(self):
        event = (CAPTURE / "Capture.event").read_text()
        source = (CAPTURE / "Preserve_Captured_Enemy.s").read_text()

        self.assertIn("ORG $17E90", event)
        self.assertIn("jumpToHack(Preserve_Captured_Enemy)", event)
        self.assertIn("[r4, #0xC]", source)
        self.assertIn("0x20", source)
        self.assertIn("str\tr0, [r4]", source)
        self.assertIn("0x08026844", source)

    def test_trade_target_list_allows_a_carried_one_hp_enemy(self):
        source = (CAPTURE / "Trade_Target_List.s").read_text()

        self.assertIn("0x080238C4", source)
        self.assertIn("[r4, #0x13]", source)
        self.assertIn("[r0, #0x1B]", source)
        self.assertIn("CheckCapturedEnemy", source)
        self.assertIn("EnlistCapturedEnemy", source)
        self.assertIn("0x0804ACFC", source)

    def test_trade_portrait_helpers_fall_back_to_the_blank_mug(self):
        for helper in ("Trade_Portrait_Fix1.s", "Trade_Portrait_Fix2.s"):
            with self.subTest(helper=helper):
                source = (CAPTURE / helper).read_text()
                self.assertIn("0x08018BD8", source)
                self.assertIn("@blank mug", source)
                self.assertIn("mov\t\tr1,r0", source)
                self.assertIn("str\t\tr0,[sp]", source)

    def test_capture_modifier_is_present_for_all_fe7_battle_stats(self):
        stat_getters = ROOT / "EngineHacks" / "Necessary" / "StatGetters"

        for stat in ("Power", "Skill", "Speed", "Defense", "Resistance", "Luck"):
            with self.subTest(stat=stat):
                source = (stat_getters / f"{stat}.event").read_text()
                self.assertIn("prHalveIfCapturing", source)


if __name__ == "__main__":
    unittest.main()
