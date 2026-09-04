from __future__ import annotations

import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DECISION_ID = "DEC-20260805-116-CANON-V2-RESCUE-RETRIEVAL-ROLE-BOUNDARY"
DECISION = ROOT / f"docs/decisions/{DECISION_ID}.md"
PLAN = ROOT / "docs/planning/2026-08-05-canon-v2-rescue-retrieval-role-boundary-design.md"
BATCH = ROOT / "docs/planning/2026-08-05-grillme-batch-3-approvals.md"
AUDIT = ROOT / "docs/audits/2026-08-05-rescue-retrieval-role-boundary-adversarial-review.md"
DESIGN_INTENT = ROOT / "DESIGN_INTENT.md"
PROJECT_BRIEF = ROOT / "PROJECT_BRIEF.md"


class RescueRetrievalRoleBoundaryPlanningContractTests(unittest.TestCase):
    def test_authority_files_exist_and_share_decision_id(self) -> None:
        for path in (DECISION, PLAN, BATCH, AUDIT, DESIGN_INTENT, PROJECT_BRIEF):
            self.assertTrue(path.is_file(), path.relative_to(ROOT))
            text = path.read_text(encoding="utf-8")
            self.assertIn(DECISION_ID, text, path.relative_to(ROOT))
            self.assertNotIn("TODO", text, path.relative_to(ROOT))
            self.assertNotIn("TBD", text, path.relative_to(ROOT))

    def test_same_rule_different_responsibility_contract(self) -> None:
        combined = "\n".join(
            path.read_text(encoding="utf-8") for path in (DECISION, PLAN)
        )
        for required in (
            "같은 규칙, 다른 책임",
            "피해자 분리·보호",
            "생존",
            "분리",
            "후유증 최소화",
            "현상 통제",
            "안정화",
            "봉쇄",
            "잔향 회수",
            "승인 철수",
        ):
            self.assertIn(required, combined)

    def test_phase_handoff_preserves_failure_forward_without_auto_resolution(self) -> None:
        combined = "\n".join(
            path.read_text(encoding="utf-8") for path in (DECISION, PLAN, AUDIT)
        )
        for required in (
            "구출 성공이 회수 전투 자동 승리",
            "구출 실패",
            "회수 전투를 자동 삭제",
            "보호 의무",
            "초기 조건",
            "공격 반복만으로 기본 승리 불가",
            "규칙 자체를 임의로 변경하지 않는다",
        ):
            self.assertIn(required, combined)

    def test_batch_records_second_approval_without_merge_claim(self) -> None:
        batch = BATCH.read_text(encoding="utf-8")
        counter = re.search(r"OPEN / (\d+)_OF_10", batch)
        self.assertIsNotNone(counter)
        self.assertGreaterEqual(int(counter.group(1)), 2)
        self.assertIn(DECISION_ID, batch)
        self.assertIn("APPROVED", batch)
        self.assertIn("BATCH_MERGE_NOT_STARTED", batch)
        self.assertNotIn("> 배치 병합: `BATCH_MERGED`", batch)

    def test_authorization_and_existing_qa_boundaries_remain_closed(self) -> None:
        combined = "\n".join(
            path.read_text(encoding="utf-8") for path in (DECISION, PLAN, AUDIT)
        )
        for required in (
            "IMPLEMENTATION_NOT_AUTHORIZED",
            "HUMAN_QA_NOT_RUN",
            "UI_ACCESSIBILITY_NOT_RUN",
            "MERGE_NOT_AUTHORIZED",
            "PR #149",
            "PR #151",
        ):
            self.assertIn(required, combined)

    def test_adversarial_review_covers_role_collapse_and_fairness_risks(self) -> None:
        audit = AUDIT.read_text(encoding="utf-8")
        for required in (
            "단계 중복",
            "구출 자동 승리",
            "구출 실패 강제 전투",
            "규칙 변조",
            "피해자 도구화",
            "전투 일반화",
            "이중 클라이맥스",
        ):
            self.assertIn(required, audit)


if __name__ == "__main__":
    unittest.main()
