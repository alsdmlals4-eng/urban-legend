from __future__ import annotations

import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DECISION_ID = "DEC-20260806-119-CANON-V2-RECOVERY-PATTERN-POOL-SELECTION-AND-JUDGMENT"
DECISION = ROOT / f"docs/decisions/{DECISION_ID}.md"
PLAN = ROOT / "docs/planning/2026-08-06-canon-v2-recovery-pattern-pool-selection-and-judgment-design.md"
AUDIT = ROOT / "docs/audits/2026-08-06-recovery-pattern-pool-selection-and-judgment-adversarial-review.md"
BATCH = ROOT / "docs/planning/2026-08-05-grillme-batch-3-approvals.md"
DESIGN_INTENT = ROOT / "DESIGN_INTENT.md"
PROJECT_BRIEF = ROOT / "PROJECT_BRIEF.md"
WORKFLOW = ROOT / ".github/workflows/validate-base-operating-sync.yml"


class RecoveryPatternPoolSelectionAndJudgmentPlanningContractTests(unittest.TestCase):
    def test_authority_files_exist_and_share_decision_id(self) -> None:
        for path in (DECISION, PLAN, AUDIT, BATCH, DESIGN_INTENT, PROJECT_BRIEF):
            self.assertTrue(path.is_file(), path.relative_to(ROOT))
            text = path.read_text(encoding="utf-8")
            self.assertIn(DECISION_ID, text, path.relative_to(ROOT))
            self.assertNotIn("TODO", text, path.relative_to(ROOT))
            self.assertNotIn("TBD", text, path.relative_to(ROOT))

    def test_pattern_judgment_unit_matches_project_authority(self) -> None:
        combined = "\n".join(path.read_text(encoding="utf-8") for path in (DECISION, PLAN, AUDIT))
        for required in (
            "괴이별 패턴 풀",
            "완성된 패턴 하나 선택",
            "단일 전조 공개",
            "가설",
            "근거",
            "대응",
            "즉시 정오 판정",
            "안정도",
            "피해",
            "다음 패턴 또는 회수 종결",
            "전역 고정 턴 수 없음",
        ):
            self.assertIn(required, combined)

    def test_hybrid_selection_covers_unseen_then_controls_repetition(self) -> None:
        combined = "\n".join(path.read_text(encoding="utf-8") for path in (DECISION, PLAN, AUDIT))
        for required in (
            "미관측 패턴을 저작 순서로 우선",
            "모든 패턴을 확인한 뒤",
            "즉시 반복 회피",
            "유효 후보",
            "사건별 가중치",
            "순수 고정 순서 금지",
            "완전 무작위 금지",
        ):
            self.assertIn(required, combined)

    def test_selected_pattern_and_correct_response_do_not_mutate_during_judgment(self) -> None:
        combined = "\n".join(path.read_text(encoding="utf-8") for path in (DECISION, PLAN, AUDIT))
        for required in (
            "전조 공개 전에 패턴을 확정",
            "판정이 끝날 때까지 같은 pattern_id",
            "correct_response_id",
            "대응에 따라 패턴을 교체하지 않는다",
            "저장·불러오기 재추첨 금지",
        ):
            self.assertIn(required, combined)

    def test_telegraph_and_evidence_fairness_is_preserved(self) -> None:
        combined = "\n".join(path.read_text(encoding="utf-8") for path in (DECISION, PLAN, AUDIT))
        for required in (
            "전조는 정답 공개가 아니다",
            "조사 기록과 괴이 매뉴얼",
            "예고되지 않은 결정적 조건 금지",
            "오대응 이유",
            "색상·음향만으로 전달 금지",
            "매뉴얼 열람은 행동 비용 없음",
        ):
            self.assertIn(required, combined)

    def test_repeated_patterns_preserve_rule_identity_and_causal_history(self) -> None:
        combined = "\n".join(path.read_text(encoding="utf-8") for path in (DECISION, PLAN, AUDIT))
        for required in (
            "같은 패턴이 재등장",
            "같은 규칙과 정답",
            "별도 variant pattern_id",
            "현장 상태는 결과 범위",
            "패턴 정답을 바꾸지 않는다",
            "선택 이유와 결과 인과",
        ):
            self.assertIn(required, combined)

    def test_existing_state_is_reused_without_fixed_turn_schema(self) -> None:
        audit = AUDIT.read_text(encoding="utf-8")
        for required in (
            "current_recovery_pattern_id",
            "last_recovery_pattern_id",
            "seen_recovery_pattern_ids",
            "confirmed_recovery_pattern_id",
            "recovery_pattern_history",
            "cycle_turn 요구 없음",
            "ordered_telegraphs 요구 없음",
            "LEGACY_SINGLE_OUTCOME",
        ):
            self.assertIn(required, audit)

    def test_batch_preserves_fourth_approval_and_allows_later_valid_approvals(self) -> None:
        batch = BATCH.read_text(encoding="utf-8")
        counter = re.search(r"OPEN / (\d+)_OF_10", batch)
        self.assertIsNotNone(counter)
        self.assertGreaterEqual(int(counter.group(1)), 4)
        self.assertIn(f"| 4 | `{DECISION_ID}`", batch)
        self.assertIn(DECISION_ID, batch)
        self.assertIn("APPROVED", batch)
        self.assertIn("DEC-20260806-118-CANON-V2-FOUR-TURN-TELEGRAPH-PATTERN-CYCLE", batch)
        self.assertIn("RETRACTED / NON_COUNTING", batch)
        self.assertIn("BATCH_MERGE_NOT_STARTED", batch)

    def test_authorization_and_qa_boundaries_remain_closed(self) -> None:
        combined = "\n".join(path.read_text(encoding="utf-8") for path in (DECISION, PLAN, AUDIT, BATCH))
        for required in (
            "IMPLEMENTATION_NOT_AUTHORIZED",
            "HUMAN_QA_NOT_RUN",
            "UI_ACCESSIBILITY_NOT_RUN",
            "MERGE_NOT_AUTHORIZED",
            "PR #149",
            "PR #151",
        ):
            self.assertIn(required, combined)

    def test_documentation_workflow_executes_this_contract(self) -> None:
        workflow = WORKFLOW.read_text(encoding="utf-8")
        test_path = "tests/test_recovery_pattern_pool_selection_and_judgment_planning_contract.py"
        self.assertGreaterEqual(workflow.count(test_path), 2)


if __name__ == "__main__":
    unittest.main()
