from __future__ import annotations

import json
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GUT_TEST = ROOT / "tests/gut/test_validation_route_mapper.gd"
CONFIG = ROOT / ".gutconfig.json"
WORKFLOW = ROOT / ".github/workflows/validate-gut-test-authority.yml"
GITIGNORE = ROOT / ".gitignore"
AUTHORITY_LEDGER = ROOT / "docs/operations/GODOT_TOOL_AUTHORITY_LEDGER.json"
VALIDATION_DOC = ROOT / "docs/validation/GUT_9_7_1_ADOPTION_VALIDATION.md"


class GutTestAuthorityCiContractTests(unittest.TestCase):
    def test_project_owned_gut_consumer_exists(self) -> None:
        text = GUT_TEST.read_text(encoding="utf-8")
        self.assertIn("extends GutTest", text)
        self.assertIn("ValidationRouteMapper", text)
        for marker in (
            "SIT-001",
            "SIT-004",
            "SIT-003",
            "SIT-999",
            "completed",
            "INVALID_LIFECYCLE",
        ):
            self.assertIn(marker, text)

    def test_gut_config_has_deterministic_discovery_and_junit(self) -> None:
        config = json.loads(CONFIG.read_text(encoding="utf-8"))
        self.assertEqual(["res://tests/gut"], config["dirs"])
        self.assertTrue(config["include_subdirs"])
        self.assertTrue(config["should_exit"])
        self.assertEqual(".artifacts/gut/junit.xml", config["junit_xml_file"])

    def test_ci_runs_godot_471_gut_junit_full_regression_and_diff_gate(self) -> None:
        text = WORKFLOW.read_text(encoding="utf-8")
        for marker in (
            "version: 4.7.1",
            "addons/gut/gut_cmdln.gd",
            "-gdir=res://tests/gut",
            "-gjunit_xml_file=.artifacts/gut/junit.xml",
            "test -s .artifacts/gut/junit.xml",
            "bash tests/run_godot_regression.sh",
            "git diff --exit-code -- project.godot addons scripts scenes assets data",
            "git status --porcelain --untracked-files=all",
        ):
            self.assertIn(marker, text)

    def test_ci_checks_out_and_records_the_exact_pr_head(self) -> None:
        text = WORKFLOW.read_text(encoding="utf-8")
        exact_head_expression = "${{ github.event.pull_request.head.sha || github.sha }}"
        self.assertIn(f"ref: {exact_head_expression}", text)
        self.assertIn(f"CANDIDATE_SHA: {exact_head_expression}", text)
        self.assertIn(
            'printf \'%s\\n\' "${CANDIDATE_SHA}" > .artifacts/gut/candidate-sha.txt',
            text,
        )
        self.assertIn("gut-test-authority-${{ env.CANDIDATE_SHA }}", text)

    def test_ci_revalidates_merged_main(self) -> None:
        text = WORKFLOW.read_text(encoding="utf-8")
        self.assertIn("push:", text)
        self.assertIn("branches:", text)
        self.assertIn("- main", text)

    def test_ci_captures_logs_and_emits_machine_summary(self) -> None:
        text = WORKFLOW.read_text(encoding="utf-8")
        for marker in (
            "tee .artifacts/gut/gut-output.log",
            "tee .artifacts/gut/full-regression.log",
            'artifact_dir / "summary.json"',
            "gut_assertions",
            "legacy_entrypoints",
            "canon_v2_entrypoints",
            "full_regression_entrypoints",
        ):
            self.assertIn(marker, text)

    def test_ci_pins_and_compares_the_complete_official_gut_tree(self) -> None:
        text = WORKFLOW.read_text(encoding="utf-8")
        for marker in (
            "repository: bitwes/Gut",
            "ref: aeb5d4f3f7f0a6c9b5e178876d6c99b791fda605",
            "path: .gut-upstream",
            "git diff --no-index --exit-code",
            ".gut-upstream/addons/gut",
            "addons/gut",
            ".artifacts/gut/upstream-tree-compare.txt",
        ):
            self.assertIn(marker, text)

    def test_ledger_uses_recorded_preceding_evidence_not_false_current_head(self) -> None:
        payload = json.loads(AUTHORITY_LEDGER.read_text(encoding="utf-8"))
        gut = next(item for item in payload["tools"] if item["tool_id"] == "gut")
        self.assertEqual("MATCH_UPSTREAM_AEB5D4F3", gut["installed_tree_match"])
        self.assertNotIn("latest_exact_head_validation", gut)
        self.assertEqual("PASS", gut["recorded_preceding_validation"]["state"])
        self.assertEqual(
            "EXTERNAL_GITHUB_ACTIONS_AND_SHEET",
            gut["current_head_binding"],
        )

    def test_validation_doc_records_actual_logged_counts(self) -> None:
        text = VALIDATION_DOC.read_text(encoding="utf-8")
        for marker in (
            "GUT assertions | 17 PASS",
            "legacy regression entrypoints | 58 PASS",
            "Canon v2 focused entrypoints | 7 PASS",
            "full Godot regression entrypoints | 65 PASS",
        ):
            self.assertIn(marker, text)
        self.assertNotIn("GUT assertions | 20 PASS", text)
        self.assertNotIn("full Godot regression total | 43 PASS", text)

    def test_generated_gut_artifacts_are_ignored(self) -> None:
        self.assertIn(".artifacts/", GITIGNORE.read_text(encoding="utf-8"))


if __name__ == "__main__":
    unittest.main()
