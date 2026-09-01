from __future__ import annotations

import json
import subprocess
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
ADAPTER_PATH = ROOT / "skills/PROJECT_BASE_ADAPTER.json"
SKILL_ID = "orchestrating-deepseek-worktrees"
BASE_RELEASE_COMMIT = "210ec78292fa12ed7563ba743b322dd36103ae4a"
BASE_RELEASE_EVIDENCE = "bb61e68dc3028421b60c11b87ba2abd297ee6f78"
BASE_RELEASE_FINALIZATION = "5adc196c0185951f50e49ab5e51586eff8d60886"
BASE_REGISTRY_SHA256 = "08f882d0c77339e8f7ff187c35b79501e0a2958ab1ff1c7aaa1c0ef8dbee45d6"


def load_adapter() -> dict:
    return json.loads(ADAPTER_PATH.read_text(encoding="utf-8"))


def active_base_routes(adapter: dict) -> set[str]:
    return {
        route["skill_id"]
        for route in adapter["routing"]["base_routes"]
        if route.get("status") == "ACTIVE"
    }


class BaseSharedExternalAIAdapterTests(unittest.TestCase):
    def test_preserves_current_released_base_identity(self) -> None:
        adapter = load_adapter()
        self.assertEqual("9.4.4", adapter["base_release"]["version"])
        self.assertEqual(BASE_RELEASE_COMMIT, adapter["base_release"]["release_commit"])
        self.assertEqual(BASE_RELEASE_EVIDENCE, adapter["base_release"]["release_evidence_commit"])
        self.assertEqual(BASE_RELEASE_FINALIZATION, adapter["base_release"]["finalization_commit"])
        self.assertEqual(BASE_REGISTRY_SHA256, adapter["skill_registry"]["base"]["sha256"])

    def test_routes_external_ai_worktree_skill_without_copying_body(self) -> None:
        adapter = load_adapter()
        self.assertIn(SKILL_ID, active_base_routes(adapter))
        self.assertFalse((ROOT / "skills/orchestrating-deepseek-worktrees/SKILL.md").exists())

    def test_binds_project_isolation_and_v941_validator_boundary(self) -> None:
        adapter = load_adapter()
        override = adapter["shared_overrides"][SKILL_ID]
        self.assertEqual(".worktrees/", override["worktree_parent"])
        self.assertEqual("ai/deepseek-", override["task_branch_prefix"])
        self.assertEqual("drafts/external-ai/", override["draft_root"])
        self.assertEqual(["drafts/external-ai/**"], override["allowed_write_roots"])
        self.assertEqual("skills/PROJECT_BASE_ADAPTER.json#/protected_paths", override["protected_paths_source"])
        self.assertEqual("REVIEW_PENDING", override["result_state"])
        self.assertEqual("LOCAL_REVIEW_REQUIRED_BEFORE_CANON", override["integration_policy"])
        self.assertEqual("ADOPTED_FROM_BASE_V9_4_1", override["base_validator_adoption"])
        self.assertEqual("tools/check_external_ai_worktree_contract.py", override["base_validator_path"])
        self.assertEqual("base-v9.4.1.lock.json", override["base_release_lock"])
        self.assertEqual("NOT_RUN", override["actual_external_ai_worktree_execution"])
        self.assertTrue(adapter["protected_paths"])

    def test_worktree_parent_is_ignored_by_git(self) -> None:
        result = subprocess.run(["git", "check-ignore", "-q", ".worktrees/"], cwd=ROOT, check=False)
        self.assertEqual(0, result.returncode)

    def test_project_validation_discovers_adapter_test(self) -> None:
        adapter = load_adapter()
        self.assertIn("python tests/test_base_shared_external_ai_adapter.py", adapter["validators"])


if __name__ == "__main__":
    unittest.main()
