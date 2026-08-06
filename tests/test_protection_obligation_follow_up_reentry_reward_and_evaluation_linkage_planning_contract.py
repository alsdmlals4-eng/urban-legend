from __future__ import annotations

import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DECISION_ID = "DEC-20260806-123-CANON-V2-PROTECTION-OBLIGATION-FOLLOW-UP-REENTRY-REWARD-AND-EVALUATION-LINKAGE"
DECISION = ROOT / f"docs/decisions/{DECISION_ID}.md"
DESIGN = ROOT / "docs/planning/2026-08-06-canon-v2-protection-obligation-follow-up-reentry-reward-and-evaluation-linkage-design.md"
AUDIT = ROOT / "docs/audits/2026-08-06-protection-obligation-follow-up-reentry-reward-and-evaluation-linkage-adversarial-review.md"
IMPLEMENTATION_PLAN = ROOT / "docs/superpowers/plans/2026-08-06-protection-obligation-follow-up-reentry-reward-and-evaluation-linkage.md"
BATCH = ROOT / "docs/planning/2026-08-05-grillme-batch-3-approvals.md"
DESIGN_INTENT = ROOT / "DESIGN_INTENT.md"
PROJECT_BRIEF = ROOT / "PROJECT_BRIEF.md"
WORKFLOW = ROOT / ".github/workflows/validate-base-operating-sync.yml"


class ProtectionObligationFollowUpReentryRewardAndEvaluationLinkagePlanningContractTests(unittest.TestCase):
    def test_authority_files_exist_and_share_decision_id(self) -> None:
        placeholder_pattern = re.compile(r"(?mi)^\s*(?:[-*]\s*)?(?:TODO|TBD)(?:\s*:|\s*$)")
        for path in (DECISION, DESIGN, AUDIT, IMPLEMENTATION_PLAN, BATCH, DESIGN_INTENT, PROJECT_BRIEF):
            self.assertTrue(path.is_file(), path.relative_to(ROOT))
            text = path.read_text(encoding="utf-8")
            self.assertIn(DECISION_ID, text, path.relative_to(ROOT))
            self.assertIsNone(placeholder_pattern.search(text), path.relative_to(ROOT))

    def test_each_obligation_status_has_a_distinct_follow_up_meaning(self) -> None:
        combined = "\n".join(path.read_text(encoding="utf-8") for path in (DECISION, DESIGN, AUDIT))
        for required in (
            "completed",
            "transferred",
            "deferred_with_owner",
            "breached",
            "unresolved",
            "상태별 후속 의미",
            "자동으로 같은 후속 임무를 생성하지 않는다",
        ):
            self.assertIn(required, combined)

    def test_follow_up_records_are_causal_append_only_and_traceable(self) -> None:
        combined = "\n".join(path.read_text(encoding="utf-8") for path in (DECISION, DESIGN, AUDIT, IMPLEMENTATION_PLAN))
        for required in (
            "follow_up_id",
            "source_obligation_id",
            "source_status",
            "source_reason",
            "case_canon_reference",
            "accountable_owner",
            "trigger_condition",
            "resolution_state",
            "causal_history",
            "append-only",
            "원래 구출 결과·회수 결과·보호 의무 이력을 덮어쓰지 않는다",
        ):
            self.assertIn(required, combined)

    def test_follow_up_and_reentry_are_bounded_and_do_not_create_infinite_rework(self) -> None:
        combined = "\n".join(path.read_text(encoding="utf-8") for path in (DECISION, DESIGN, AUDIT))
        for required in (
            "dedupe_key",
            "하나의 활성 루트 후속 기록",
            "저작된 단계 상한",
            "무한 재조사",
            "무한 재진입",
            "accepted_residual_risk",
            "closed_no_action",
            "escalated_once",
            "핵심 캠페인 진행을 영구 차단하지 않는다",
        ):
            self.assertIn(required, combined)

    def test_reentry_eligibility_is_separate_from_obligation_status_and_never_automatic(self) -> None:
        combined = "\n".join(path.read_text(encoding="utf-8") for path in (DECISION, DESIGN, AUDIT))
        for required in (
            "reentry_eligibility",
            "actionable_reason",
            "hazard_state",
            "route_state",
            "authority_state",
            "capability_state",
            "재진입은 자동 생성하지 않는다",
            "재진입 자격과 보호 의무 상태를 같은 값으로 취급하지 않는다",
            "대체 후속 경로",
        ):
            self.assertIn(required, combined)

    def test_evaluation_uses_separate_axes_without_erasing_incident_history(self) -> None:
        combined = "\n".join(path.read_text(encoding="utf-8") for path in (DECISION, DESIGN, AUDIT))
        for required in (
            "현상 통제 축",
            "보호 책임 축",
            "증거·기록 무결성 축",
            "후속 실행 축",
            "숙련 평가 축",
            "단일 종합 점수",
            "서로 덮어쓰지 않는다",
            "원래 breach를 성공으로 소급 변경하지 않는다",
        ):
            self.assertIn(required, combined)

    def test_reward_linkage_is_campaign_neutral_and_cannot_farm_harm(self) -> None:
        combined = "\n".join(path.read_text(encoding="utf-8") for path in (DECISION, DESIGN, AUDIT, IMPLEMENTATION_PLAN))
        for required in (
            "캠페인 필수 전력과 분리",
            "기본 진행 보상을 박탈하지 않는다",
            "피해·위반을 반복 생성해 보상을 파밍",
            "영구 능력치",
            "필수 스킬",
            "최고 성능 캠페인 장비",
            "사건 기록",
            "표창",
            "비필수 부록",
            "코스메틱",
            "기록 재현 전용",
        ):
            self.assertIn(required, combined)

    def test_mastery_impact_is_limited_previewed_and_incident_specific(self) -> None:
        combined = "\n".join(path.read_text(encoding="utf-8") for path in (DECISION, DESIGN, AUDIT))
        for required in (
            "사건별 숙련 상한",
            "회피 가능하고 중대한 breach",
            "사전 저작",
            "결과 화면에서 근거 공개",
            "모든 미완료 의무가 자동으로 S 랭크를 차단하지 않는다",
            "정확한 랭크 임계값은 미승인",
            "핵심 엔딩·필수 동료·필수 세계관 진실을 잠그지 않는다",
        ):
            self.assertIn(required, combined)

    def test_status_specific_rules_preserve_owner_responsibility_and_original_consequences(self) -> None:
        combined = "\n".join(path.read_text(encoding="utf-8") for path in (DECISION, DESIGN, AUDIT))
        for required in (
            "completed는 기본적으로 재작업을 요구하지 않는다",
            "transferred는 인계 수락과 책임 주체를 검증한다",
            "deferred_with_owner는 trigger_condition이 성립할 때만 활성화한다",
            "breached는 복구가 아니라 추가 피해 완화와 책임 이행을 다룬다",
            "unresolved는 조용히 완료 처리하지 않는다",
            "사망이나 피해가 유리한 보상 경로가 되지 않는다",
        ):
            self.assertIn(required, combined)

    def test_save_migration_and_accessibility_are_idempotent_and_neutral(self) -> None:
        combined = "\n".join(path.read_text(encoding="utf-8") for path in (DECISION, DESIGN, AUDIT, IMPLEMENTATION_PLAN))
        for required in (
            "idempotent",
            "원자적",
            "rollback",
            "같은 dedupe_key를 중복 생성하지 않는다",
            "legacy provenance",
            "과거 저장에서 breach나 완료를 추정하지 않는다",
            "접근성 대체 입력과 시간 완화",
            "평가·보상·재진입 자격 불이익 금지",
        ):
            self.assertIn(required, combined)

    def test_implementation_plan_is_tdd_first_and_execution_remains_closed(self) -> None:
        plan = IMPLEMENTATION_PLAN.read_text(encoding="utf-8")
        for required in (
            "# Protection Obligation Follow-up, Re-entry, Reward, and Evaluation Linkage Implementation Plan",
            "Write the failing test",
            "Run test to verify it fails",
            "scripts/core/protection_follow_up_policy.gd",
            "scripts/core/protection_obligation_policy.gd",
            "scripts/core/recovery_outcome_policy.gd",
            "scripts/core/game_state.gd",
            "scripts/scenes/result_scene.gd",
            "save migration",
            "IMPLEMENTATION_NOT_AUTHORIZED",
        ):
            self.assertIn(required, plan)

    def test_batch_records_eighth_real_approval_and_keeps_retraction_non_counting(self) -> None:
        batch = BATCH.read_text(encoding="utf-8")
        counter = re.search(r"OPEN / (\d+)_OF_10", batch)
        self.assertIsNotNone(counter)
        self.assertEqual(int(counter.group(1)), 8)
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
        test_path = "tests/test_protection_obligation_follow_up_reentry_reward_and_evaluation_linkage_planning_contract.py"
        self.assertGreaterEqual(workflow.count(test_path), 2)


if __name__ == "__main__":
    unittest.main()
