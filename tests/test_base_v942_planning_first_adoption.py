from __future__ import annotations

import json
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ADAPTER = ROOT / "skills/PROJECT_BASE_ADAPTER.json"
PAYLOAD = "7dd1a4f80388bc5faca767ff74a3eb32dc9d0ac8"
EVIDENCE = "da33a350d61b8adc52df97fccc7001708a933370"
FINALIZATION = "0b7c94f38d959efc0fc9442274c60b2e268a3c97"
REGISTRY = "693a0dff3f054ecdd653079909e044211473838e73dd9aff07734d1ce5694c59"


def load() -> dict:
    return json.loads(ADAPTER.read_text(encoding="utf-8"))


class BaseV942PlanningFirstAdoptionTests(unittest.TestCase):
    def test_current_release_identity(self) -> None:
        adapter = load()
        release = adapter["base_release"]
        self.assertEqual("9.4.3", release["version"])
        self.assertEqual(PAYLOAD, release["release_commit"])
        self.assertEqual(EVIDENCE, release["release_evidence_commit"])
        self.assertEqual(FINALIZATION, release["finalization_commit"])
        self.assertEqual(REGISTRY, adapter["skill_registry"]["base"]["sha256"])

    def test_planning_first_contract(self) -> None:
        adapter = load()
        policy = adapter["shared_overrides"]["managing-project-intake-and-work-contract"]["planning_first_governance"]
        self.assertEqual("docs/PLANNING_FIRST_GRILL_ME_BATCH_POLICY.md", policy["base_contract_source"])
        self.assertEqual("templates/project-operations/GRILL_ME_BATCH_CHECKPOINT.md", policy["checkpoint_template"])
        self.assertEqual("base-v9.4.3.lock.json", policy["base_release_lock"])
        self.assertEqual(FINALIZATION, policy["base_release_finalization_commit"])
        self.assertEqual(10, policy["max_approved_decisions_per_batch"])
        self.assertEqual("RECOMMENDED_DEFAULT", policy["numeric_default_state"])
        self.assertEqual("GRILL_ME_REQUIRED", policy["planning_conflict_state"])
        self.assertEqual("APPROVED_PENDING_MERGE", policy["pre_merge_sheet_state"])
        self.assertEqual("SYNCED_TO_MAIN", policy["post_merge_sheet_state"])
        self.assertEqual("NOT_RUN", policy["actual_project_batch_execution"])

    def test_project_boundaries_remain_unchanged(self) -> None:
        adapter = load()
        self.assertEqual("BLOCKED", adapter["gdd_sheet"]["sync_status"])
        self.assertEqual(["data/", "scripts/", "scenes/", "assets/", "addons/", "project.godot"], adapter["protected_paths"])
        self.assertEqual("NOT_RUN", adapter["shared_overrides"]["orchestrating-deepseek-worktrees"]["actual_external_ai_worktree_execution"])


if __name__ == "__main__":
    unittest.main()
