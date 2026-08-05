from __future__ import annotations

import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
RUNNER = ROOT / "tests/run_afterlife_canon_v2_migration_tests.sh"
REGRESSION = ROOT / "tests/run_godot_regression.sh"
DEDICATED_WORKFLOW = ROOT / ".github/workflows/validate-afterlife-station-canon-v2-migration-design.yml"
ANNUAL_WORKFLOW = ROOT / ".github/workflows/validate-annual-mvp-001.yml"

EXPECTED_ENTRYPOINTS = (
    "res://tests/afterlife_migration/afterlife_canon_v2_loader_test.gd",
    "res://tests/afterlife_migration/afterlife_id_migration_registry_test.gd",
    "res://tests/afterlife_migration/afterlife_legacy_save_inspector_test.gd",
    "res://tests/afterlife_migration/afterlife_main_save_migrator_test.gd",
    "res://tests/afterlife_migration/afterlife_validation_save_migrator_test.gd",
    "res://tests/afterlife_migration/afterlife_migration_transaction_test.gd",
    "res://tests/afterlife_migration/afterlife_migration_integration_test.gd",
)


class AfterlifeCanonV2RunnerContractTests(unittest.TestCase):
    def test_focused_runner_exists_and_has_exact_seven_planned_entrypoints(self) -> None:
        self.assertTrue(RUNNER.is_file(), RUNNER)
        text = RUNNER.read_text(encoding="utf-8")
        for entrypoint in EXPECTED_ENTRYPOINTS:
            self.assertIn(entrypoint, text)
        self.assertEqual(text.count("res://tests/afterlife_migration/"), 7)
        self.assertIn("set -euo pipefail", text)
        self.assertIn("GODOT_TEST_TMP", text)
        self.assertIn("XDG_DATA_HOME", text)
        self.assertIn("Afterlife canon v2 migration: 7/7 entrypoints passed", text)

    def test_full_regression_and_ci_call_the_focused_runner(self) -> None:
        for path in (REGRESSION, DEDICATED_WORKFLOW, ANNUAL_WORKFLOW):
            text = path.read_text(encoding="utf-8")
            self.assertIn(
                "bash tests/run_afterlife_canon_v2_migration_tests.sh",
                text,
                str(path),
            )

    def test_dedicated_workflow_runs_contracts_focused_and_full_regression(self) -> None:
        text = DEDICATED_WORKFLOW.read_text(encoding="utf-8")
        for token in (
            "tests/test_afterlife_station_canon_v2_migration_design.py",
            "tests/test_afterlife_station_canon_v2_implementation_plan.py",
            "tests/test_afterlife_canon_v2_runner_contract.py",
            "Run focused Canon v2 migration suite",
            "Run full Godot regression",
        ):
            self.assertIn(token, text)

    def test_annual_workflow_watches_implementation_boundaries(self) -> None:
        text = ANNUAL_WORKFLOW.read_text(encoding="utf-8")
        for token in (
            '"data/episodes/episode_001_afterlife_station_canon_v2.json"',
            '"data/migrations/afterlife_station_canon_v2_id_migration.json"',
            '"scripts/data/afterlife_*.gd"',
            '"scripts/core/afterlife_*.gd"',
            '"tests/run_afterlife_canon_v2_migration_tests.sh"',
        ):
            self.assertIn(token, text)


if __name__ == "__main__":
    unittest.main()
