from __future__ import annotations

import re
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


class CurrentAuthorityFreshnessTests(unittest.TestCase):
    def read(self, relative_path: str) -> str:
        return (ROOT / relative_path).read_text(encoding="utf-8")

    def test_current_entrypoints_route_through_decision_overlay(self) -> None:
        for relative_path in ("START_HERE.md", "AGENTS.md", "docs/DOCUMENTATION_MAP.md"):
            text = self.read(relative_path)
            self.assertIn("CURRENT_DECISION_OVERLAY.md", text, relative_path)

    def test_validation_router_separates_m01_and_m04(self) -> None:
        text = self.read("docs/VALIDATION_TARGET_CANON.md")
        self.assertIn("M01_FIRST_SESSION", text)
        self.assertIn("M04_RELEASE_NEAR_VERTICAL_SLICE", text)
        self.assertIn("PLAN_LOCK", text)
        self.assertIn("Human QA", text)
        self.assertIn("NOT_RUN", text)
        self.assertNotIn("APPROVED_FINAL_PLANNING_BASELINE_PENDING_MAIN", text)

    def test_verified_ui_successor_is_not_frozen_as_not_started(self) -> None:
        start = self.read("START_HERE.md")
        overlay = self.read("docs/CURRENT_DECISION_OVERLAY.md")
        self.assertIn("PR #180", overlay)
        self.assertIn("MERGED", overlay)
        self.assertNotIn("ui_hierarchy_runtime_implementation: NOT_STARTED", start)
        self.assertNotIn("BLOCKED_HIGODOT_UNAVAILABLE_IN_CHATGPT_SESSION", start)

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

    def test_open_issue_status_alone_is_not_authority(self) -> None:
        for relative_path in (
            "START_HERE.md",
            "AGENTS.md",
            "docs/CURRENT_DECISION_OVERLAY.md",
        ):
            text = self.read(relative_path)
            self.assertIn("Issue", text, relative_path)
        overlay = self.read("docs/CURRENT_DECISION_OVERLAY.md")
        self.assertIn("open", overlay)
        self.assertIn("구현 권한", overlay)
        self.assertIn("DEFERRED_VALID", overlay)

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
