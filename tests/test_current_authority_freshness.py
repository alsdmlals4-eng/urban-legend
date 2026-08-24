from __future__ import annotations

import json
import re
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
RUNTIME_MERGE = "8d303f0f9414950273be934fd28c8fb1b3a21e18"


class CurrentAuthorityFreshnessTests(unittest.TestCase):
    def read(self, relative_path: str) -> str:
        return (ROOT / relative_path).read_text(encoding="utf-8")

    def test_current_entrypoints_route_through_decision_overlay(self) -> None:
        for relative_path in ("START_HERE.md", "AGENTS.md", "docs/DOCUMENTATION_MAP.md"):
            text = self.read(relative_path)
            self.assertIn("CURRENT_DECISION_OVERLAY.md", text, relative_path)

        canon = json.loads(self.read("docs/current-planning-canon.json"))
        self.assertIn("docs/CURRENT_DECISION_OVERLAY.md", canon["active_entrypoints"])
        self.assertIn("docs/VALIDATION_TARGET_CANON.md", canon["active_entrypoints"])

    def test_validation_router_separates_m01_and_m04(self) -> None:
        text = self.read("docs/VALIDATION_TARGET_CANON.md")
        self.assertIn("M01_FIRST_SESSION", text)
        self.assertIn("M04_RELEASE_NEAR_VERTICAL_SLICE", text)
        self.assertIn("RUNTIME_IMPLEMENTED / AUTOMATED_GREEN / HUMAN_NOT_RUN", text)
        self.assertIn("SHARED_SYSTEM_BASELINE_IMPLEMENTED / PRODUCT_REFERENCE_ASSET_PENDING / HUMAN_NOT_RUN", text)
        self.assertIn(RUNTIME_MERGE, text)
        self.assertIn("Human QA", text)
        self.assertIn("NOT_RUN", text)
        self.assertNotIn("APPROVED_FINAL_PLANNING_BASELINE_PENDING_MAIN", text)

    def test_verified_ui_successor_is_not_frozen_as_current_state(self) -> None:
        start = self.read("START_HERE.md")
        overlay = self.read("docs/CURRENT_DECISION_OVERLAY.md")
        self.assertIn("PR #180", start)
        self.assertIn("predecessor history", start)
        self.assertIn("IMPLEMENTED / ISSUE_181_CLOSED", overlay)
        self.assertIn("product_version.gd", overlay)

        snapshot = start.split("## 현재 제품·Gate Snapshot", 1)[1].split(
            "## Verified successor와 미완료를 구분한다", 1
        )[0]
        self.assertNotIn("runtime_implementation: NOT_AUTHORIZED", snapshot)
        self.assertIn("runtime_implementation: MERGED_MAIN", snapshot)

    def test_base_version_has_single_current_owner(self) -> None:
        agents = self.read("AGENTS.md")
        base_rules = self.read("docs/BASE_RULES_VERSION.md")
        self.assertRegex(base_rules, r"base_version:\s*9\.4\.3")
        self.assertIn("docs/BASE_RULES_VERSION.md", agents)
        self.assertNotIn("Base `9.4.0`", agents)
        self.assertNotRegex(
            agents,
            re.compile(r"프로젝트 main 채택 커밋은 `(?:[0-9a-f]{40})`"),
        )

    def test_issue_status_alone_is_not_authority_after_181_completion(self) -> None:
        for relative_path in (
            "START_HERE.md",
            "AGENTS.md",
            "docs/CURRENT_DECISION_OVERLAY.md",
        ):
            text = self.read(relative_path)
            self.assertIn("Issue", text, relative_path)
        overlay = self.read("docs/CURRENT_DECISION_OVERLAY.md")
        self.assertIn("Issue #181", overlay)
        self.assertIn("completed", overlay)
        self.assertIn("open 상태만으로 구현 권한이나 current truth를 만들지 않는다", overlay)
        start = self.read("START_HERE.md")
        self.assertIn("DEFERRED_VALID / PLAN_LOCK", start)
        self.assertIn("CURRENT_VALID / IMPLEMENTATION_GATE", start)
        self.assertIn("predecessor history", start)

    def test_issue_disposition_audit_covers_all_baseline_open_issues(self) -> None:
        text = self.read(
            "docs/audits/2026-08-21-open-issue-and-authority-freshness-correction.md"
        )
        expected = {
            1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
            27, 28, 29, 30, 31, 44, 92, 97, 105, 112, 115, 119, 179, 181, 203, 212,
        }
        found = {int(value) for value in re.findall(r"\| #(\d+) \|", text)}
        self.assertEqual(expected, found)
        self.assertIn("#181", text)
        self.assertIn("KEEP_OPEN_DEFERRED_VALID", text)


if __name__ == "__main__":
    unittest.main()
