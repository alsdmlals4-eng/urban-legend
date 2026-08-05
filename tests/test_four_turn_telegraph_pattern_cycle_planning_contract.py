from __future__ import annotations

import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DECISION_ID = "DEC-20260806-118-CANON-V2-FOUR-TURN-TELEGRAPH-PATTERN-CYCLE"
DECISION = ROOT / f"docs/decisions/{DECISION_ID}.md"
PLAN = ROOT / "docs/planning/2026-08-06-canon-v2-four-turn-telegraph-pattern-cycle-design.md"
AUDIT = ROOT / "docs/audits/2026-08-06-four-turn-telegraph-pattern-cycle-adversarial-review.md"
BATCH = ROOT / "docs/planning/2026-08-05-grillme-batch-3-approvals.md"
DESIGN_INTENT = ROOT / "DESIGN_INTENT.md"
PROJECT_BRIEF = ROOT / "PROJECT_BRIEF.md"
WORKFLOW = ROOT / ".github/workflows/validate-base-operating-sync.yml"


class FourTurnTelegraphPatternCyclePlanningContractTests(unittest.TestCase):
    def test_authority_files_exist_and_share_decision_id(self) -> None:
        for path in (DECISION, PLAN, AUDIT, BATCH, DESIGN_INTENT, PROJECT_BRIEF):
            self.assertTrue(path.is_file(), path.relative_to(ROOT))
            text = path.read_text(encoding="utf-8")
            self.assertIn(DECISION_ID, text, path.relative_to(ROOT))
            self.assertNotIn("TODO", text, path.relative_to(ROOT))
            self.assertNotIn("TBD", text, path.relative_to(ROOT))

    def test_exact_asymmetric_four_turn_cadence_is_preserved(self) -> None:
        combined = "\n".join(path.read_text(encoding="utf-8") for path in (DECISION, PLAN))
        for required in (
            "전조 → 패턴 시스템",
            "1턴: 전조 1 → 선택 → 평상 진행",
            "2턴: 선택 → 전조 2 → 평상 진행",
            "3턴: 선택 → 전조 3 → 평상 진행",
            "4턴: 대응 선택 → 패턴 발현 → 결과 산출 → 평상 진행",
            "비대칭 정보 구조",
        ):
            self.assertIn(required, combined)

    def test_turn_two_and_three_reveals_do_not_retroactively_change_committed_choices(self) -> None:
        combined = "\n".join(path.read_text(encoding="utf-8") for path in (DECISION, PLAN, AUDIT))
        for required in (
            "2턴과 3턴의 선택은 새 전조 공개 전에 확정",
            "소급 변경하지 않는다",
            "전조 2는 3턴 이후 판단",
            "전조 3은 4턴 대응",
            "세 전조를 모두 누적",
        ):
            self.assertIn(required, combined)

    def test_normal_actions_and_pattern_response_are_separate_responsibilities(self) -> None:
        combined = "\n".join(path.read_text(encoding="utf-8") for path in (DECISION, PLAN))
        for required in (
            "평상 선택",
            "전용 대응 선택",
            "1~3턴",
            "4턴",
            "패턴을 조기 해결하지 않는다",
            "추가 평상 선택을 끼워 넣지 않는다",
            "다음 패턴 주기",
        ):
            self.assertIn(required, combined)

    def test_telegraphs_are_persistent_evidence_not_answer_reveal(self) -> None:
        combined = "\n".join(path.read_text(encoding="utf-8") for path in (DECISION, PLAN, AUDIT))
        for required in (
            "전조는 근거이지 정답 공개가 아니다",
            "각 전조는 개별적으로 의미",
            "세 전조를 함께 읽으면",
            "전조 1에서 정답을 사실상 확정",
            "전조 3이 정답 문구를 직접 제시",
            "현행 규칙 스트립",
            "행동 비용 없음",
        ):
            self.assertIn(required, combined)

    def test_cycle_state_contract_covers_save_resume_and_interruption(self) -> None:
        combined = "\n".join(path.read_text(encoding="utf-8") for path in (DECISION, PLAN, AUDIT))
        for required in (
            "pattern_cycle_id",
            "pattern_id",
            "cycle_turn",
            "ordered_telegraphs",
            "revealed_telegraph_count",
            "normal_action_history",
            "response_choice",
            "manifestation_result",
            "next_cycle_state",
            "저장·재개",
            "재추첨 금지",
            "승인 철수",
            "중단된 주기",
        ):
            self.assertIn(required, combined)

    def test_audit_records_current_runtime_and_data_conflicts(self) -> None:
        audit = AUDIT.read_text(encoding="utf-8")
        for required in (
            "battle_scene.gd",
            "_begin_recovery_turn",
            "_select_pattern_response",
            "select_next_recovery_pattern",
            "단일 telegraph",
            "즉시 결과 산출",
            "cycle_turn 상태 없음",
            "pending pattern 상태 없음",
            "전조 누적 원장 없음",
            "LEGACY_RUNTIME_CONFLICT",
        ):
            self.assertIn(required, audit)

    def test_guardrails_block_unfair_or_mutable_pattern_resolution(self) -> None:
        combined = "\n".join(path.read_text(encoding="utf-8") for path in (DECISION, PLAN, AUDIT))
        for required in (
            "4턴 전 조기 대응 금지",
            "패턴 정답을 바꾸지 않는다",
            "예고되지 않은 결정적 규칙",
            "색상이나 음향만으로 전조",
            "평상 행동 반복만으로 자동 승리 금지",
            "저장·불러오기 재추첨",
            "패턴 발현은 선택 결과로 새로 생성되지 않는다",
        ):
            self.assertIn(required, combined)

    def test_batch_records_fourth_approval_without_merge_claim(self) -> None:
        batch = BATCH.read_text(encoding="utf-8")
        counter = re.search(r"OPEN / (\d+)_OF_10", batch)
        self.assertIsNotNone(counter)
        self.assertGreaterEqual(int(counter.group(1)), 4)
        self.assertIn(DECISION_ID, batch)
        self.assertIn("APPROVED", batch)
        self.assertIn("BATCH_MERGE_NOT_STARTED", batch)
        self.assertNotIn("> 배치 병합: `BATCH_MERGED`", batch)

    def test_authorization_and_qa_boundaries_remain_closed(self) -> None:
        combined = "\n".join(path.read_text(encoding="utf-8") for path in (DECISION, PLAN, AUDIT))
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
        test_path = "tests/test_four_turn_telegraph_pattern_cycle_planning_contract.py"
        self.assertGreaterEqual(workflow.count(test_path), 2)


if __name__ == "__main__":
    unittest.main()
