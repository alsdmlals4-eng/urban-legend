from __future__ import annotations

import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DECISION_ID = "DEC-20260805-115-CANON-V2-RULE-STRIP-CONTINUITY"
DECISION = ROOT / f"docs/decisions/{DECISION_ID}.md"
PLAN = ROOT / "docs/planning/2026-08-05-canon-v2-rule-strip-continuity-design.md"
BATCH = ROOT / "docs/planning/2026-08-05-grillme-batch-3-approvals.md"
AUDIT = ROOT / "docs/audits/2026-08-05-rule-strip-continuity-adversarial-review.md"
DESIGN_INTENT = ROOT / "DESIGN_INTENT.md"
PROJECT_BRIEF = ROOT / "PROJECT_BRIEF.md"


class RuleStripContinuityPlanningContractTests(unittest.TestCase):
    def test_authority_files_exist_and_share_decision_id(self) -> None:
        for path in (DECISION, PLAN, BATCH, AUDIT, DESIGN_INTENT, PROJECT_BRIEF):
            self.assertTrue(path.is_file(), path.relative_to(ROOT))
            text = path.read_text(encoding="utf-8")
            self.assertIn(DECISION_ID, text, path.relative_to(ROOT))
            self.assertNotIn("TODO", text, path.relative_to(ROOT))
            self.assertNotIn("TBD", text, path.relative_to(ROOT))

    def test_single_state_and_phase_presentation_contract(self) -> None:
        combined = "\n".join(
            path.read_text(encoding="utf-8") for path in (DECISION, PLAN)
        )
        for required in (
            "단일 권위 상태",
            "전체 괴이 매뉴얼 작업공간",
            "현행 규칙 스트립",
            "행동 관련",
            "즉시 표시",
            "단축키 또는 버튼",
            "정답 자동 공개 금지",
            "PC 사이드 패널",
            "모바일 접이식 카드",
        ):
            self.assertIn(required, combined)

    def test_accessibility_and_authorization_boundaries(self) -> None:
        combined = "\n".join(
            path.read_text(encoding="utf-8") for path in (DECISION, PLAN, AUDIT)
        )
        for required in (
            "색상만으로 구분 금지",
            "키보드",
            "게임패드",
            "텍스트 확대",
            "모션 감소",
            "IMPLEMENTATION_NOT_AUTHORIZED",
            "HUMAN_QA_NOT_RUN",
            "MERGE_NOT_AUTHORIZED",
            "PR #149",
        ):
            self.assertIn(required, combined)

    def test_batch_counter_is_one_of_ten_without_merge_claim(self) -> None:
        batch = BATCH.read_text(encoding="utf-8")
        self.assertIn("1_OF_10", batch)
        self.assertIn("APPROVED", batch)
        self.assertIn("EARLY_CANON_CHECKPOINT", batch)
        self.assertIn("BATCH_MERGE_NOT_STARTED", batch)
        self.assertNotIn("BATCH_MERGED", batch)

    def test_adversarial_review_covers_known_failure_modes(self) -> None:
        audit = AUDIT.read_text(encoding="utf-8")
        for required in (
            "독립 정본화",
            "정답 오라클",
            "화면 과밀",
            "숨은 진실 누설",
            "포커스 함정",
            "모바일은 연기",
            "구출과 회수의 역할 경계",
        ):
            self.assertIn(required, audit)


if __name__ == "__main__":
    unittest.main()
