from __future__ import annotations

import pathlib
import unittest


ROOT = pathlib.Path(__file__).resolve().parents[1]


class CoreMvp001StaticContractTest(unittest.TestCase):
    def test_debug_entry_and_isolated_paths_exist(self) -> None:
        main_menu = (ROOT / "scripts/ui/main_menu.gd").read_text(encoding="utf-8")
        self.assertIn("CORE-MVP-001 조사→전조→포획 PoC", main_menu)
        self.assertIn(
            "res://scenes/poc/core_mvp_001/core_mvp_001_scene.tscn",
            main_menu,
        )
        for path in [
            "data/poc/core_mvp_001/afterlife_station_poc.json",
            "scripts/poc/core_mvp_001/core_mvp_001_case_data.gd",
            "scripts/poc/core_mvp_001/core_mvp_001_state.gd",
            "scripts/poc/core_mvp_001/core_mvp_001_playtest_log.gd",
            "scripts/poc/core_mvp_001/core_mvp_001_scene.gd",
            "scenes/poc/core_mvp_001/core_mvp_001_scene.tscn",
        ]:
            self.assertTrue((ROOT / path).is_file(), path)

    def test_scene_contract_names_are_present(self) -> None:
        scene_script = (
            ROOT / "scripts/poc/core_mvp_001/core_mvp_001_scene.gd"
        ).read_text(encoding="utf-8")
        for name in [
            "PhaseHost",
            "InvestigationPanel",
            "InvestigationScroll",
            "HypothesisPanel",
            "HypothesisScroll",
            "FieldTestPanel",
            "FieldTestScroll",
            "RecoveryPanel",
            "RecoveryScroll",
            "ResultPanel",
            "ResultScroll",
            "Footer",
        ]:
            self.assertIn(name, scene_script)
        self.assertIn("debug_review_previous_panel", scene_script)
        self.assertIn("debug_return_to_current_panel", scene_script)

    def test_poc_does_not_reference_campaign_state_or_enemy_hp(self) -> None:
        poc_root = ROOT / "scripts/poc/core_mvp_001"
        combined = "\n".join(
            path.read_text(encoding="utf-8") for path in sorted(poc_root.glob("*.gd"))
        )
        self.assertNotIn("GameState", combined)
        self.assertNotIn("enemy_hp", combined)
        self.assertNotIn("data/episodes/", combined)


if __name__ == "__main__":
    unittest.main()
