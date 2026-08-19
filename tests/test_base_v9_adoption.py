from __future__ import annotations

import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
BASE_V9_RELEASE = "585a53a25be1b04c543196f5901551deb49c7691"
SNAPSHOT_SHA256 = "e30fca95d201a31937c7bddcbc341c79764d4940c318933a8902cb5bf901ba57"


class BaseV9AdoptionTests(unittest.TestCase):
    def test_v9_adapter_preserves_project_ownership_and_sheet_conflict(self) -> None:
        adapter = json.loads((ROOT / "skills/BASE_V9_ADAPTER.json").read_text(encoding="utf-8"))

        self.assertEqual(adapter["base"]["release_commit"], BASE_V9_RELEASE)
        self.assertEqual(adapter["base"]["snapshot_sha256"], SNAPSHOT_SHA256)
        self.assertFalse(adapter["base"]["copy_common_skill_bodies"])
        self.assertEqual(adapter["sheet"]["role"], "USER_FACING_GDD_WORKSPACE")
        self.assertEqual(adapter["sheet"]["sync_status"], "SHEET_GITHUB_CONFLICT")
        self.assertEqual(adapter["maturity"]["level"], 4)
        self.assertEqual(adapter["maturity"]["status"], "PROVISIONAL_PENDING_RUNTIME_REVALIDATION")

    def test_adoption_audit_keeps_game_implementation_and_human_validation_separate(self) -> None:
        audit = (ROOT / "docs/BASE_V9_ADOPTION_AUDIT.md").read_text(encoding="utf-8")

        for token in (
            "OPERATING_SYSTEM_ONLY",
            "HUMAN_VALIDATION_NOT_RUN",
            "NOT_RUN",
            "Control",
            "Container",
            "Theme",
            "Signal",
            "1280x720",
            "1920x1080",
            "OPEN_SOURCE_REFERENCE_CARD_ONLY",
        ):
            self.assertIn(token, audit)

    def test_pull_request_workflow_has_ci_and_adversarial_gates(self) -> None:
        workflow = (ROOT / ".github/workflows/validate-base-v9-adoption.yml").read_text(encoding="utf-8")

        self.assertIn("ci-gate", workflow)
        self.assertIn("adversarial-gate", workflow)


# Required-check bridge for the already-merged RM-TOOL-001 pilot and its
# Base Adoption Kit manifest boundary.
from tests.test_p0_schema_reuse import P0SchemaReuseTests


if __name__ == "__main__":
    unittest.main()