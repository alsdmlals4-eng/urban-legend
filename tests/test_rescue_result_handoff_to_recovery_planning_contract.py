from __future__ import annotations

import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DECISION_ID = "DEC-20260806-121-CANON-V2-RESCUE-RESULT-HANDOFF-TO-RECOVERY-INITIAL-CONDITIONS-AND-ACTION-CONSTRAINTS"
DECISION = ROOT / f"docs/decisions/{DECISION_ID}.md"
DESIGN = ROOT / "docs/planning/2026-08-06-canon-v2-rescue-result-handoff-to-recovery-initial-conditions-and-action-constraints-design.md"
AUDIT = ROOT / "docs/audits/2026-08-06-rescue-result-handoff-to-recovery-adversarial-review.md"
IMPLEMENTATION_PLAN = ROOT / "docs/superpowers/plans/2026-08-06-rescue-result-handoff-to-recovery.md"
BATCH = ROOT / "docs/planning/2026-08-05-grillme-batch-3-approvals.md"
DESIGN_INTENT = ROOT / "DESIGN_INTENT.md"
PROJECT_BRIEF = ROOT / "PROJECT_BRIEF.md"
WORKFLOW = ROOT / ".github/workflows/validate-base-operating-sync.yml"


class RescueResultHandoffToRecoveryPlanningContractTests(unittest.TestCase):
    def test_authority_files_exist_and_share_decision_id(self) -> None:
        placeholder_pattern = re.compile(r"(?mi)^\s*(?:[-*]\s*)?(?:TODO|TBD)(?:\s*:|\s*$)")
        for path in (DECISION, DESIGN, AUDIT, IMPLEMENTATION_PLAN, BATCH, DESIGN_INTENT, PROJECT_BRIEF):
            self.assertTrue(path.is_file(), path.relative_to(ROOT))
            text = path.read_text(encoding="utf-8")
            self.assertIn(DECISION_ID, text, path.relative_to(ROOT))
            self.assertIsNone(placeholder_pattern.search(text), path.relative_to(ROOT))

    def test_immutable_rescue_snapshot_is_separate_from_mutable_recovery_state(self) -> None:
        combined = "\n".join(path.read_text(encoding="utf-8") for path in (DECISION, DESIGN, AUDIT))
        for required in (
            "rescue_outcome_snapshot",
            "recovery_handoff_state",
            "active_protection_obligations",
            "protection_history",
            "구출 종료 당시 사실",
            "불변",
            "회수 중 변화",
            "과거를 다시 쓰지 않는다",
        ):
            self.assertIn(required, combined)

    def test_rescue_axes_create_initial_conditions_without_deciding_recovery_outcome(self) -> None:
        combined = "\n".join(path.read_text(encoding="utf-8") for path in (DECISION, DESIGN, AUDIT))
        for required in (
            "생존·안정",
            "생존·위중",
            "피해자 상실",
            "생존 불명·실종",
            "완전 분리",
            "부분 분리",
            "분리 실패",
            "비가역 연결",
            "후유증",
            "보호 의무",
            "구출 결과가 회수 대표 결과를 자동 결정하지 않는다",
            "구출 실패가 회수 실패를 자동으로 만들지 않는다",
        ):
            self.assertIn(required, combined)

    def test_protection_obligations_are_traceable_responsibilities(self) -> None:
        combined = "\n".join(path.read_text(encoding="utf-8") for path in (DECISION, DESIGN, AUDIT, IMPLEMENTATION_PLAN))
        for required in (
            "obligation_id",
            "target",
            "responsibility_type",
            "source_reason",
            "urgency",
            "affected_actions",
            "completion_condition",
            "breach_consequence",
            "status",
            "resolution_reason",
            "대피",
            "방호",
            "치료",
            "격리",
            "연결 감시",
            "2차 노출 차단",
            "신원·기록 보존",
            "매개체 분리",
            "안전 경로 유지",
        ):
            self.assertIn(required, combined)

    def test_action_constraints_use_forewarning_and_only_limited_hard_locks(self) -> None:
        combined = "\n".join(path.read_text(encoding="utf-8") for path in (DECISION, DESIGN, AUDIT))
        for required in (
            "선택 전에",
            "예상 결과",
            "기본적으로 행동을 잠그지 않는다",
            "물리적으로 실행 불가능",
            "확인된 괴이 규칙을 직접 위반",
            "관찰·괴이 매뉴얼 열람은 차단하지 않는다",
            "접근성 대체 입력과 시간 압박 완화는 불이익이 아니다",
        ):
            self.assertIn(required, combined)

    def test_handoff_never_changes_pattern_truth_or_repeats_rescue_puzzle(self) -> None:
        combined = "\n".join(path.read_text(encoding="utf-8") for path in (DECISION, DESIGN, AUDIT))
        for required in (
            "pattern_id",
            "correct_response_id",
            "객관적 의미",
            "변경하지 않는다",
            "같은 구출 퍼즐을 반복하지 않는다",
            "전역 고정 턴 수",
        ):
            self.assertIn(required, combined)

    def test_fail_forward_avoids_hidden_penalty_bundles_and_unwinnable_states(self) -> None:
        combined = "\n".join(path.read_text(encoding="utf-8") for path in (DECISION, DESIGN, AUDIT))
        for required in (
            "숨은 보정 금지",
            "단일 구출 등급으로 모든 수치를 일괄 변경하지 않는다",
            "죽음의 나선",
            "의미 있는 회수 행동",
            "승인 철수 판단 경로",
            "도구·지원·대체 경로",
        ):
            self.assertIn(required, combined)

    def test_legacy_numeric_handoff_and_save_resume_are_safe(self) -> None:
        combined = "\n".join(path.read_text(encoding="utf-8") for path in (DECISION, DESIGN, AUDIT, IMPLEMENTATION_PLAN))
        for required in (
            "LEGACY_NUMERIC_HANDOFF",
            "legacy bool",
            "완전 구출을 추정하지 않는다",
            "중복 생성하지 않는다",
            "초기 조건을 다시 적용하지 않는다",
            "idempotent",
            "handoff_validation_failed",
            "원자적",
            "rollback",
        ):
            self.assertIn(required, combined)

    def test_implementation_plan_is_tdd_first_and_execution_remains_closed(self) -> None:
        plan = IMPLEMENTATION_PLAN.read_text(encoding="utf-8")
        for required in (
            "# Rescue Result Handoff to Recovery Implementation Plan",
            "Write the failing test",
            "Run test to verify it fails",
            "scripts/core/rescue_recovery_handoff_policy.gd",
            "scripts/core/game_state.gd",
            "scripts/scenes/minigame_scene.gd",
            "scripts/scenes/battle_scene.gd",
            "scripts/scenes/result_scene.gd",
            "save migration",
            "IMPLEMENTATION_NOT_AUTHORIZED",
        ):
            self.assertIn(required, plan)

    def test_batch_preserves_sixth_real_approval_and_keeps_retraction_non_counting(self) -> None:
        batch = BATCH.read_text(encoding="utf-8")
        counter = re.search(r"OPEN / (\d+)_OF_10", batch)
        self.assertIsNotNone(counter)
        self.assertGreaterEqual(int(counter.group(1)), 6)
        self.assertIn(DECISION_ID, batch)
        self.assertIn("APPROVED", batch)
        self.assertIn("DEC-20260806-118-CANON-V2-FOUR-TURN-TELEGRAPH-PATTERN-CYCLE", batch)
        self.assertIn("RETRACTED / NON_COUNTING", batch)
        self.assertIn("BATCH_MERGE_NOT_STARTED", batch)

    def test_authorization_and_qa_boundaries_remain_closed(self) -> None:
        combined = "\n".join(path.read_text(encoding="utf-8") for path in (DECISION, DESIGN, AUDIT, IMPLEMENTATION_PLAN, BATCH))
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
        test_path = "tests/test_rescue_result_handoff_to_recovery_planning_contract.py"
        self.assertGreaterEqual(workflow.count(test_path), 2)


if __name__ == "__main__":
    unittest.main()