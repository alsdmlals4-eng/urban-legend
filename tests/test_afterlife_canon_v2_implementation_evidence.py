from __future__ import annotations

import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DECISION = ROOT / "docs/decisions/D-2026-08-05-AFTERLIFE-STATION-CANON-V2-MIGRATION-DESIGN.md"
EVIDENCE = ROOT / "docs/implementation/2026-08-05-afterlife-station-canon-v2-migration-implementation-evidence.md"


class AfterlifeCanonV2ImplementationEvidenceTests(unittest.TestCase):
    def test_evidence_document_exists(self) -> None:
        self.assertTrue(EVIDENCE.is_file(), EVIDENCE)

    def test_decision_tracks_implementation_without_claiming_merge_or_human_qa(self) -> None:
        text = DECISION.read_text(encoding="utf-8")
        for token in (
            "IMPLEMENTATION_AUTHORIZED",
            "IMPLEMENTATION_COMPLETE",
            "AUTOMATED_QA_GREEN",
            "HUMAN_QA_NOT_RUN",
            "MERGE_NOT_AUTHORIZED",
            "Draft PR: `#146`",
            str(EVIDENCE.relative_to(ROOT)),
        ):
            self.assertIn(token, text)

    def test_evidence_records_tdd_and_exact_automation_scope(self) -> None:
        text = EVIDENCE.read_text(encoding="utf-8")
        for token in (
            "D-2026-08-05-AFTERLIFE-STATION-CANON-V2-MIGRATION-DESIGN",
            "Task 1~9",
            "RED",
            "GREEN",
            "30972203323",
            "30972503634",
            "1e2473889b68b4a714300133da180f1eb1a08414",
            "30973078497",
            "30973078429",
            "30973078408",
            "focused 8/8",
            "full Godot regression",
            "canonical_v2_projection",
            "legacy_content_snapshot",
        ):
            self.assertIn(token, text)

    def test_evidence_preserves_release_gates(self) -> None:
        text = EVIDENCE.read_text(encoding="utf-8")
        for token in (
            "HUMAN_QA_NOT_RUN",
            "MERGE_NOT_AUTHORIZED",
            "PR #145",
            "PR #146",
            "Draft",
            "이미지·게임 자산 변경 없음",
        ):
            self.assertIn(token, text)


if __name__ == "__main__":
    unittest.main()
