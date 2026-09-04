from __future__ import annotations

import json
import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PROJECT = ROOT / "project.godot"
LEDGER = ROOT / "docs/operations/GODOT_TOOL_AUTHORITY_LEDGER.json"
GUT_PLUGIN = ROOT / "addons/gut/plugin.cfg"
GUT_LICENSE = ROOT / "addons/gut/LICENSE.md"
PROTECTED_PATHS = {
    "project.godot",
    "addons/",
    "scripts/",
    "scenes/",
    "assets/",
    "data/",
}
GUT_ADOPTION_LIFECYCLE = {
    "TRIAL_APPROVED",
    "CONSUMPTION_IMPLEMENTED",
    "EXACT_HEAD_VALIDATED",
    "ADOPTED_ACTIVE",
}
RECORDED_PRECEDING_HEAD = "22ac24db211a5d474efcc49a73c2a5369698c1a7"
RECORDED_WORKFLOW_RUN = 31131917325
RECORDED_WORKFLOW_JOB = 92722504253
RECORDED_ARTIFACT_ID = 8976370660
RECORDED_ARTIFACT_DIGEST = (
    "sha256:3f0c0fd5a2e9bb7a8a7608efa5c3c354f6ecfb5910d902de21566abf5d00177b"
)


def enabled_plugins() -> set[str]:
    text = PROJECT.read_text(encoding="utf-8")
    match = re.search(
        r"\[editor_plugins\]\s+enabled=PackedStringArray\((.*?)\)",
        text,
        re.DOTALL,
    )
    if match is None:
        return set()
    return set(re.findall(r'"([^"]+/plugin\.cfg)"', match.group(1)))


def load_ledger() -> dict:
    return json.loads(LEDGER.read_text(encoding="utf-8"))


class GodotToolAuthorityContractTests(unittest.TestCase):
    def test_all_enabled_plugins_are_declared(self) -> None:
        payload = load_ledger()
        declared = {item["plugin_cfg"] for item in payload["tools"]}
        self.assertEqual(enabled_plugins(), declared)

    def test_exact_gut_identity_is_declared(self) -> None:
        payload = load_ledger()
        gut = next(item for item in payload["tools"] if item["tool_id"] == "gut")
        self.assertEqual("9.7.1", gut["exact_version"])
        self.assertEqual("bitwes/Gut", gut["upstream_repository"])
        self.assertEqual("godot_4_7", gut["upstream_branch"])
        self.assertEqual(
            "aeb5d4f3f7f0a6c9b5e178876d6c99b791fda605",
            gut["upstream_commit"],
        )
        self.assertEqual("MIT", gut["license"])
        self.assertEqual("4.7.x", gut["compatible_godot"])
        self.assertIn(gut["adoption_state"], GUT_ADOPTION_LIFECYCLE)
        self.assertEqual("ADOPTED_ACTIVE", gut["adoption_state"])

    def test_gut_plugin_and_license_match_declared_metadata(self) -> None:
        plugin = GUT_PLUGIN.read_text(encoding="utf-8")
        license_text = GUT_LICENSE.read_text(encoding="utf-8")
        self.assertIn('version="9.7.1"', plugin)
        self.assertIn("The MIT License (MIT)", license_text)
        self.assertIn('Copyright (c) 2018 Tom "Butch" Wesley', license_text)

    def test_authoring_authority_is_unique(self) -> None:
        tools = load_ledger()["tools"]
        authors = [item for item in tools if item["authority"] == "GODOT_AUTHORING"]
        self.assertEqual(1, len(authors))
        self.assertEqual("higodot", authors[0]["tool_id"])

    def test_higodot_authority_state_is_not_addon_adoption_lifecycle(self) -> None:
        higodot = next(
            item for item in load_ledger()["tools"] if item["tool_id"] == "higodot"
        )
        self.assertEqual("ACTIVE_EDITOR_AUTHORITY", higodot["authority_state"])
        self.assertNotIn("adoption_state", higodot)
        self.assertNotIn("latest_exact_head_validation", higodot)

    def test_gut_has_no_product_mutation_scope(self) -> None:
        gut = next(item for item in load_ledger()["tools"] if item["tool_id"] == "gut")
        self.assertEqual("TEST_EXECUTION", gut["authority"])
        self.assertEqual([], gut["allowed_product_mutations"])
        self.assertTrue(PROTECTED_PATHS.issubset(set(gut["forbidden_mutation_paths"])))
        self.assertTrue(gut["consumption_paths"])
        self.assertTrue(gut["ci_commands"])
        self.assertTrue(gut["rollback_steps"])

    def test_recorded_validation_is_preceding_head_not_self_referential_latest(self) -> None:
        gut = next(item for item in load_ledger()["tools"] if item["tool_id"] == "gut")
        self.assertNotIn("latest_exact_head_validation", gut)
        validation = gut["recorded_preceding_validation"]
        self.assertEqual("PASS", validation["state"])
        self.assertEqual(RECORDED_PRECEDING_HEAD, validation["commit"])
        self.assertEqual("EXTERNAL_GITHUB_ACTIONS_AND_SHEET", gut["current_head_binding"])

    def test_recorded_validation_matches_merged_main_evidence(self) -> None:
        gut = next(item for item in load_ledger()["tools"] if item["tool_id"] == "gut")
        validation = gut["recorded_preceding_validation"]
        self.assertEqual(RECORDED_WORKFLOW_RUN, validation["workflow_run_id"])
        self.assertEqual(RECORDED_WORKFLOW_JOB, validation["workflow_job_id"])
        self.assertEqual(RECORDED_ARTIFACT_ID, validation["artifact_id"])
        self.assertEqual(RECORDED_ARTIFACT_DIGEST, validation["artifact_digest"])
        self.assertEqual(37, validation["focused_contract_tests"])
        self.assertEqual(5, validation["gut_tests"])
        self.assertEqual(17, validation["gut_assertions"])
        self.assertEqual(58, validation["legacy_entrypoints"])
        self.assertEqual(7, validation["canon_v2_entrypoints"])
        self.assertEqual(65, validation["full_regression_entrypoints"])
        self.assertEqual("PASS", validation["protected_diff"])


if __name__ == "__main__":
    unittest.main()
