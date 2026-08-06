from __future__ import annotations

import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DECISION_ID = "DEC-20260806-122-CANON-V2-PROTECTION-OBLIGATION-COST-PRIORITY-AND-RECOVERY-TERMINATION-ELIGIBILITY"
DECISION = ROOT / f"docs/decisions/{DECISION_ID}.md"
DESIGN = ROOT / "docs/planning/2026-08-06-canon-v2-protection-obligation-cost-priority-and-recovery-termination-eligibility-design.md"
AUDIT = ROOT / "docs/audits/2026-08-06-protection-obligation-cost-priority-and-termination-eligibility-adversarial-review.md"
IMPLEMENTATION_PLAN = ROOT / "docs/superpowers/plans/2026-08-06-protection-obligation-cost-priority-and-termination-eligibility.md"
BATCH = ROOT / "docs/planning/2026-08-05-grillme-batch-3-approvals.md"
DESIGN_INTENT = ROOT / "DESIGN_INTENT.md"
PROJECT_BRIEF = ROOT / "PROJECT_BRIEF.md"
WORKFLOW = ROOT / ".github/workflows/validate-base-operating-sync.yml"


class ProtectionObligationCostPriorityAndTerminationEligibilityPlanningContractTests(unittest.TestCase):
    def test_authority_files_exist_and_share_decision_id(self) -> None:
        placeholder_pattern = re.compile(r"(?mi)^\s*(?:[-*]\s*)?(?:TODO|TBD)(?:\s*:|\s*$)")
        for path in (DECISION, DESIGN, AUDIT, IMPLEMENTATION_PLAN, BATCH, DESIGN_INTENT, PROJECT_BRIEF):
            self.assertTrue(path.is_file(), path.relative_to(ROOT))
            text = path.read_text(encoding="utf-8")
            self.assertIn(DECISION_ID, text, path.relative_to(ROOT))
            self.assertIsNone(placeholder_pattern.search(text), path.relative_to(ROOT))

    def test_cost_priority_and_termination_are_three_separate_channels(self) -> None:
        combined = "\n".join(path.read_text(encoding="utf-8") for path in (DECISION, DESIGN, AUDIT))
        for required in (
            "행동 비용",
            "표시 우선순위",
            "종결 자격",
            "서로 분리",
            "단일 의무 점수",
            "자동 승패",
        ):
            self.assertIn(required, combined)

    def test_action_costs_are_causal_visible_bounded_and_not_global_taxes(self) -> None:
        combined = "\n".join(path.read_text(encoding="utf-8") for path in (DECISION, DESIGN, AUDIT, IMPLEMENTATION_PLAN))
        for required in (
            "cost_adjustment_id",
            "obligation_id",
            "affected_action",
            "cost_channel",
            "source_reason",
            "base cost",
            "additional cost",
            "관련 행동에만",
            "전역 비용 인상 금지",
            "모든 의미 있는 행동을 불가능하게 만들지 않는다",
            "관찰·괴이 매뉴얼·결과 미리보기는 비용을 부과하지 않는다",
            "접근성 대체 입력과 시간 압박 완화는 비용이 아니다",
        ):
            self.assertIn(required, combined)

    def test_priority_orders_attention_without_forcing_actions_or_hidden_modifiers(self) -> None:
        combined = "\n".join(path.read_text(encoding="utf-8") for path in (DECISION, DESIGN, AUDIT))
        for required in (
            "priority_class",
            "priority_reason",
            "critical",
            "urgent",
            "watch",
            "자동 실행하지 않는다",
            "강제 대상 선택",
            "숨은 성공률 보정",
            "동일 우선순위",
            "created_order",
            "obligation_id",
            "결정적 순서",
        ):
            self.assertIn(required, combined)

    def test_fail_forward_preserves_meaningful_paths_and_explicit_alternatives(self) -> None:
        combined = "\n".join(path.read_text(encoding="utf-8") for path in (DECISION, DESIGN, AUDIT))
        for required in (
            "최소 하나의 의미 있는 회수 행동",
            "보호 행동",
            "도구·지원",
            "책임 이관",
            "후속 책임이 명시된 연기",
            "승인 철수 판단",
            "죽음의 나선",
            "모든 의무를 먼저 처리해야만 회수를 진행",
        ):
            self.assertIn(required, combined)

    def test_control_outcomes_remain_independent_from_protection_obligation_status(self) -> None:
        combined = "\n".join(path.read_text(encoding="utf-8") for path in (DECISION, DESIGN, AUDIT))
        for required in (
            "residue_recovered",
            "containment_complete",
            "stabilization_complete",
            "emergency_containment",
            "미완료 보호 의무만으로 대표 회수 결과를 자동 강등하지 않는다",
            "보호 축",
            "현상 통제 축",
            "서로 덮어쓰지 않는다",
        ):
            self.assertIn(required, combined)

    def test_approved_withdrawal_has_accountable_obligation_gates_without_hard_locking_exit(self) -> None:
        combined = "\n".join(path.read_text(encoding="utf-8") for path in (DECISION, DESIGN, AUDIT))
        for required in (
            "approved_withdrawal",
            "completed",
            "transferred",
            "deferred_with_owner",
            "breached",
            "unresolved",
            "accountable_owner",
            "follow_up_condition",
            "중대 보호 의무가 책임 있게 인계되지 않은 상태",
            "승인 철수 자격 없음",
            "후퇴 선택 자체를 숨기거나 잠그지 않는다",
            "control_failure",
        ):
            self.assertIn(required, combined)

    def test_termination_preview_explains_eligibility_and_non_blocking_consequences(self) -> None:
        combined = "\n".join(path.read_text(encoding="utf-8") for path in (DECISION, DESIGN, AUDIT, IMPLEMENTATION_PLAN))
        for required in (
            "termination_candidate",
            "eligible",
            "blocking_reasons",
            "non_blocking_consequences",
            "accountable_transfer",
            "종결 확정 전에",
            "상위 결과가 성립하지 않는 이유",
            "미완료 의무와 후속 책임",
        ):
            self.assertIn(required, combined)

    def test_cost_application_and_priority_are_idempotent_across_save_resume(self) -> None:
        combined = "\n".join(path.read_text(encoding="utf-8") for path in (DECISION, DESIGN, AUDIT, IMPLEMENTATION_PLAN))
        for required in (
            "applied_once",
            "같은 cost_adjustment_id를 중복 적용하지 않는다",
            "저장·불러오기",
            "idempotent",
            "원자적",
            "rollback",
            "LEGACY_NUMERIC_HANDOFF",
            "기존 시작 안정도 보정을 보호 의무 비용으로 소급 해석하지 않는다",
        ):
            self.assertIn(required, combined)

    def test_pattern_truth_information_access_and_accessibility_remain_neutral(self) -> None:
        combined = "\n".join(path.read_text(encoding="utf-8") for path in (DECISION, DESIGN, AUDIT))
        for required in (
            "pattern_id",
            "correct_response_id",
            "전조의 객관적 의미",
            "변경하지 않는다",
            "관찰",
            "괴이 매뉴얼",
            "접근성",
            "랭크·보상·종결 자격 불이익 금지",
        ):
            self.assertIn(required, combined)

    def test_implementation_plan_is_tdd_first_and_execution_remains_closed(self) -> None:
        plan = IMPLEMENTATION_PLAN.read_text(encoding="utf-8")
        for required in (
            "# Protection Obligation Cost, Priority, and Termination Eligibility Implementation Plan",
            "Write the failing test",
            "Run test to verify it fails",
            "scripts/core/protection_obligation_policy.gd",
            "scripts/core/rescue_recovery_handoff_policy.gd",
            "scripts/core/recovery_outcome_policy.gd",
            "scripts/core/game_state.gd",
            "scripts/scenes/battle_scene.gd",
            "scripts/scenes/result_scene.gd",
            "save migration",
            "IMPLEMENTATION_NOT_AUTHORIZED",
        ):
            self.assertIn(required, plan)

    def test_batch_preserves_seventh_real_approval_and_keeps_retraction_non_counting(self) -> None:
        batch = BATCH.read_text(encoding="utf-8")
        counter = re.search(r"OPEN / (\d+)_OF_10", batch)
        self.assertIsNotNone(counter)
        self.assertGreaterEqual(int(counter.group(1)), 7)
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
        test_path = "tests/test_protection_obligation_cost_priority_and_termination_eligibility_planning_contract.py"
        self.assertGreaterEqual(workflow.count(test_path), 2)


if __name__ == "__main__":
    unittest.main()
