from __future__ import annotations

import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ACTIVE_DOCS = (
    ROOT / "docs/CURRENT_STATUS.md",
    ROOT / "docs/CURRENT_HANDOFF.md",
    ROOT / "docs/PROJECT_CORE.md",
    ROOT / "docs/GAME_DESIGN_DOCUMENT.md",
    ROOT / "MVP_ROADMAP.md",
    ROOT / "TEST_CHECKLIST.md",
    ROOT / "docs/PROJECT_CONTEXT.md",
    ROOT / "docs/planning/PROJECT_DIRECTION.md",
    ROOT / "docs/planning/ROADMAP_AND_HANDOFF.md",
)


class ProjectDocumentSyncTests(unittest.TestCase):
    def test_active_documents_exist(self) -> None:
        for path in ACTIVE_DOCS:
            self.assertTrue(path.is_file(), path.relative_to(ROOT))

    def test_seven_day_contract_is_consistent(self) -> None:
        texts = {}
        for path in ACTIVE_DOCS:
            text = path.read_text(encoding="utf-8")
            texts[path] = text
            self.assertNotIn("SEVEN_DAY_SCHEDULING_ON_BRANCH", text, path.relative_to(ROOT))
            self.assertNotIn("CI_PENDING", text, path.relative_to(ROOT))
        combined = "\n".join(texts.values())
        for required in (
            "annual-mvp-001-v3",
            "주당 7일",
            "자동 휴식",
            "HISTORICAL_REGRESSION_EVIDENCE",
            "PR #76",
            "run #121",
            "POC_PASSED",
            "NOT_RUN",
            "NOT_DECLARED",
            "NOT_APPROVED",
        ):
            self.assertIn(required, combined)

    def test_update_governance_is_recorded(self) -> None:
        protocol = (ROOT / "docs/PROJECT_UPDATE_PROTOCOL.md").read_text(encoding="utf-8")
        decisions = (ROOT / "docs/DECISION_LOG.md").read_text(encoding="utf-8")
        for required in (
            "CURRENT_STATUS",
            "CURRENT_HANDOFF",
            "PROJECT_CORE",
            "GAME_DESIGN_DOCUMENT",
            "MVP_ROADMAP",
            "TEST_CHECKLIST",
            "자동 검증",
            "사람",
            "HISTORICAL_REGRESSION_EVIDENCE",
        ):
            self.assertIn(required, protocol)
        for decision_id in (
            "D-2026-07-23-CORE-001",
            "D-2026-07-25-ANNUAL-BASELINE",
            "D-2026-07-25-ANNUAL-FOUR-WEEK",
            "D-2026-07-25-ANNUAL-SEVEN-DAY",
            "D-2026-07-26-DOC-GOVERNANCE",
        ):
            self.assertIn(decision_id, decisions)


if __name__ == "__main__":
    unittest.main()
