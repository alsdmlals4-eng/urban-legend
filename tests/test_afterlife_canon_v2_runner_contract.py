from __future__ import annotations

import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
RUNNER = ROOT / "tests/run_afterlife_canon_v2_migration_tests.sh"
REGRESSION = ROOT / "tests/run_godot_regression.sh"
DEDICATED_WORKFLOW = ROOT / ".github/workflows/validate-afterlife-station-canon-v2-migration-design.yml"
ANNUAL_WORKFLOW = ROOT / ".github/workflows/validate-annual-mvp-001.yml"

EXPECTED_AFTERLIFE_ENTRYPOINTS = (
    "res://tests/afterlife_migration/afterlife_canon_v2_loader_test.gd",
    "res://tests/afterlife_migration/afterlife_id_migration_registry_test.gd",
    "res://tests/afterlife_migration/afterlife_legacy_save_inspector_test.gd",
    "res://tests/afterlife_migration/afterlife_main_save_migrator_test.gd",
    "res://tests/afterlife_migration/afterlife_validation_save_migrator_test.gd",
    "res://tests/afterlife_migration/afterlife_migration_transaction_test.gd",
    "res://tests/afterlife_migration/afterlife_migration_integration_test.gd",
    "res://tests/afterlife_migration/afterlife_runtime_projection_test.gd",
    "res://tests/afterlife_migration/afterlife_real_fixture_contract_test.gd",
)
EXPECTED_MONTHLY_ENTRYPOINTS = (
    "res://tests/monthly_state/monthly_state_policy_test.gd",
    "res://tests/monthly_state/monthly_state_save_compatibility_test.gd",
    "res://tests/monthly_state/monthly_state_cross_case_persistence_test.gd",
)
EXPECTED_FIRST_SESSION_ENTRYPOINTS = (
    "res://tests/first_session/m01_first_session_orchestration_test.gd",
    "res://tests/first_session/m01_first_session_runtime_sync_test.gd",
)
WINDOWS_USER_DATA_ISOLATION_ENTRYPOINT = "res://tests/validation/windows_user_data_isolation_test.gd"
EXPECTED_ENTRYPOINTS = (
    (WINDOWS_USER_DATA_ISOLATION_ENTRYPOINT,)
    + EXPECTED_AFTERLIFE_ENTRYPOINTS
    + EXPECTED_MONTHLY_ENTRYPOINTS
    + EXPECTED_FIRST_SESSION_ENTRYPOINTS
)


class AfterlifeCanonV2RunnerContractTests(unittest.TestCase):
    def test_focused_runner_has_all_runtime_reconciliation_entrypoints(self) -> None:
        self.assertTrue(RUNNER.is_file(), RUNNER)
        text = RUNNER.read_text(encoding="utf-8")
        declared_entrypoints = tuple(
            line.strip().strip('"')
            for line in text.splitlines()
            if line.strip().startswith('"res://tests/')
        )
        self.assertEqual(declared_entrypoints, EXPECTED_ENTRYPOINTS)
        self.assertEqual(declared_entrypoints[0], WINDOWS_USER_DATA_ISOLATION_ENTRYPOINT)
        self.assertEqual(len(declared_entrypoints), 15)
        self.assertEqual(text.count("res://tests/afterlife_migration/"), 9)
        self.assertEqual(text.count("res://tests/monthly_state/"), 3)
        self.assertEqual(text.count("res://tests/first_session/"), 2)
        self.assertIn("set -euo pipefail", text)
        self.assertIn("GODOT_TEST_TMP", text)
        self.assertIn("XDG_DATA_HOME", text)
        self.assertIn("Afterlife canon v2 migration: ${#entrypoints[@]}/${#entrypoints[@]} entrypoints passed", text)

    def test_full_regression_and_ci_call_the_focused_runner(self) -> None:
        expected_calls = {
            REGRESSION: 'bash "$PROJECT_ROOT/tests/run_afterlife_canon_v2_migration_tests.sh"',
            DEDICATED_WORKFLOW: "bash tests/run_afterlife_canon_v2_migration_tests.sh",
            ANNUAL_WORKFLOW: "bash tests/run_afterlife_canon_v2_migration_tests.sh",
        }
        for path, expected_call in expected_calls.items():
            text = path.read_text(encoding="utf-8")
            self.assertIn(
                expected_call,
                text,
                str(path),
            )

    def test_dedicated_workflow_runs_contracts_focused_and_full_regression(self) -> None:
        text = DEDICATED_WORKFLOW.read_text(encoding="utf-8")
        for token in (
            "tests/test_afterlife_station_canon_v2_migration_design.py",
            "tests/test_afterlife_station_canon_v2_implementation_plan.py",
            "tests/test_afterlife_canon_v2_runner_contract.py",
            "tests/test_afterlife_canon_v2_human_qa_plan.py",
            '"scripts/core/monthly_state_policy.gd"',
            '"scripts/core/m01_first_session_orchestrator.gd"',
            '"scripts/core/m01_first_session_runtime_sync.gd"',
            '"tests/monthly_state/**"',
            '"tests/first_session/**"',
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
            '"scripts/core/monthly_state_policy.gd"',
            '"scripts/core/m01_first_session_orchestrator.gd"',
            '"scripts/core/m01_first_session_runtime_sync.gd"',
            '"tests/monthly_state/**"',
            '"tests/first_session/**"',
            '"tests/fixtures/afterlife_migration/**"',
            '"tests/run_afterlife_canon_v2_migration_tests.sh"',
        ):
            self.assertIn(token, text)


if __name__ == "__main__":
    unittest.main()
