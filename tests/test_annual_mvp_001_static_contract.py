from __future__ import annotations

import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


class AnnualMvp001StaticContractTests(unittest.TestCase):
    def test_required_runtime_files_exist(self) -> None:
        required = (
            "data/poc/annual_mvp_001/spring_vertical_slice.json",
            "scripts/poc/annual_mvp_001/annual_mvp_001_data.gd",
            "scripts/poc/annual_mvp_001/annual_mvp_001_state.gd",
            "scripts/poc/annual_mvp_001/annual_mvp_001_support_resolver.gd",
            "scripts/poc/annual_mvp_001/annual_mvp_001_incident_adapter.gd",
            "scripts/poc/annual_mvp_001/annual_mvp_001_save_data.gd",
            "scripts/poc/annual_mvp_001/annual_mvp_001_scene.gd",
            "scenes/poc/annual_mvp_001/annual_mvp_001_scene.tscn",
        )
        for relative in required:
            self.assertTrue((ROOT / relative).is_file(), relative)

    def test_main_menu_has_separate_annual_dev_entry(self) -> None:
        menu = (ROOT / "scripts/ui/main_menu.gd").read_text(encoding="utf-8")
        self.assertIn("ANNUAL-MVP-001 육성→사건→연구 PoC", menu)
        self.assertIn("res://scenes/poc/annual_mvp_001/annual_mvp_001_scene.tscn", menu)
        self.assertIn("CORE-MVP-001 조사→전조→포획 PoC", menu)
        self.assertIn("res://scenes/poc/core_mvp_001/core_mvp_001_scene.tscn", menu)

    def test_regression_runner_registers_six_annual_tests(self) -> None:
        runner = (ROOT / "tests/run_godot_regression.sh").read_text(encoding="utf-8")
        for name in (
            "annual_mvp_001_data_test",
            "annual_mvp_001_state_test",
            "annual_mvp_001_support_resolver_test",
            "annual_mvp_001_incident_adapter_test",
            "annual_mvp_001_save_data_test",
            "annual_mvp_001_scene_test",
        ):
            self.assertIn(name, runner)
        self.assertIn("49/49", runner)

    def test_runtime_does_not_reference_protected_main_state(self) -> None:
        combined = "\n".join(
            path.read_text(encoding="utf-8")
            for path in (ROOT / "scripts/poc/annual_mvp_001").glob("*.gd")
        )
        for forbidden in (
            "GameState",
            "mvp-039",
            "mvp-038",
            "res://data/episodes/",
            "res://scripts/scenes/investigation_scene.gd",
            "res://scripts/scenes/battle_scene.gd",
        ):
            self.assertNotIn(forbidden, combined)

    def test_support_effects_cannot_change_reasoning_contract(self) -> None:
        core_state = (ROOT / "scripts/poc/core_mvp_001/core_mvp_001_state.gd").read_text(encoding="utf-8")
        self.assertIn("func apply_external_support", core_state)
        self.assertIn('["health_restore", "risk_reduction"]', core_state)
        support_section = core_state.split("func apply_external_support", 1)[1].split("func execute_capture", 1)[0]
        for forbidden in ("capture_marks +=", "_understanding =", "_selected_hypothesis_id =", "_observed_pattern_ids.append"):
            self.assertNotIn(forbidden, support_section)

    def test_annual_scene_uses_shared_theme_and_korean_font_candidates(self) -> None:
        scene = (ROOT / "scripts/poc/annual_mvp_001/annual_mvp_001_scene.gd").read_text(encoding="utf-8")
        theme_factory = (ROOT / "scripts/ui/ui_theme_factory.gd").read_text(encoding="utf-8")
        self.assertIn('ThemeFactory = preload("res://scripts/ui/ui_theme_factory.gd")', scene)
        self.assertIn("theme = ThemeFactory.create_theme()", scene)
        self.assertIn("SystemFont.new()", theme_factory)
        for font_name in ("Noto Sans CJK KR", "Noto Sans KR", "Malgun Gothic", "Apple SD Gothic Neo"):
            self.assertIn(font_name, theme_factory)


if __name__ == "__main__":
    unittest.main()
