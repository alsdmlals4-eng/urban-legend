from __future__ import annotations

import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DECISION_ID = "DEC-20260806-120-CANON-V2-RECOVERY-OUTCOME-STATES-AND-INDEPENDENT-RESULT-PACKET"
DECISION = ROOT / f"docs/decisions/{DECISION_ID}.md"
DESIGN = ROOT / "docs/planning/2026-08-06-canon-v2-recovery-outcome-states-and-independent-result-packet-design.md"
AUDIT = ROOT / "docs/audits/2026-08-06-recovery-outcome-states-and-result-packet-adversarial-review.md"
IMPLEMENTATION_PLAN = ROOT / "docs/superpowers/plans/2026-08-06-recovery-outcome-states-and-result-packet.md"
BATCH = ROOT / "docs/planning/2026-08-05-grillme-batch-3-approvals.md"
DESIGN_INTENT = ROOT / "DESIGN_INTENT.md"
PROJECT_BRIEF = ROOT / "PROJECT_BRIEF.md"
WORKFLOW = ROOT / ".github/workflows/validate-base-operating-sync.yml"


class RecoveryOutcomeStatesAndResultPacketPlanningContractTests(unittest.TestCase):
    def test_authority_files_exist_and_share_decision_id(self) -> None:
        placeholder_pattern = re.compile(r"(?mi)^\s*(?:[-*]\s*)?(?:TODO|TBD)(?:\s*:|\s*$)")
        for path in (DECISION, DESIGN, AUDIT, IMPLEMENTATION_PLAN, BATCH, DESIGN_INTENT, PROJECT_BRIEF):
            self.assertTrue(path.is_file(), path.relative_to(ROOT))
            text = path.read_text(encoding="utf-8")
            self.assertIn(DECISION_ID, text, path.relative_to(ROOT))
            self.assertIsNone(placeholder_pattern.search(text), path.relative_to(ROOT))

    def test_six_representative_recovery_outcomes_are_distinct(self) -> None:
        combined = "\n".join(path.read_text(encoding="utf-8") for path in (DECISION, DESIGN, AUDIT))
        for required in (
            "residue_recovered",
            "잔향 회수 완료",
            "containment_complete",
            "봉쇄 완료",
            "stabilization_complete",
            "안정화 완료",
            "emergency_containment",
            "긴급 봉쇄",
            "approved_withdrawal",
            "승인 철수",
            "control_failure",
            "통제 실패",
        ):
            self.assertIn(required, combined)

    def test_outcome_classes_preserve_success_partial_exit_and_failure_boundaries(self) -> None:
        combined = "\n".join(path.read_text(encoding="utf-8") for path in (DECISION, DESIGN, AUDIT))
        for required in (
            "FULL_SUCCESS",
            "CONTROL_SUCCESS",
            "PROVISIONAL_SUCCESS",
            "PARTIAL_SUCCESS",
            "STRATEGIC_EXIT",
            "FAILURE",
            "긴급 봉쇄는 부분 성공",
            "승인 철수는 실패가 아니다",
            "강제 퇴각",
        ):
            self.assertIn(required, combined)

    def test_independent_result_packet_keeps_responsibility_axes_separate(self) -> None:
        combined = "\n".join(path.read_text(encoding="utf-8") for path in (DECISION, DESIGN, AUDIT))
        for required in (
            "대표 회수 결과",
            "피해자 생존·분리·후유증",
            "보호 의무",
            "요원 피해와 장비 손실",
            "현장·매개체·공공 노출",
            "잔향·증거·기록 확보",
            "후속 조사·재진입·감시",
            "판정 근거와 인과 이력",
            "단일 총점으로 덮어쓰지 않는다",
        ):
            self.assertIn(required, combined)

    def test_rescue_and_recovery_results_do_not_overwrite_each_other(self) -> None:
        combined = "\n".join(path.read_text(encoding="utf-8") for path in (DECISION, DESIGN, AUDIT))
        for required in (
            "구출 실패가 회수 실패를 자동으로 만들지 않는다",
            "회수 성공이 피해자 구출 성공을 자동으로 만들지 않는다",
            "회수 실패나 승인 철수가 이미 구출한 피해자를 소급 삭제하지 않는다",
            "피해자 결과와 회수 결과를 동등한 헤드라인",
            "단일 임무 성공/실패 배너 금지",
        ):
            self.assertIn(required, combined)

    def test_approved_withdrawal_has_explicit_eligibility_and_is_not_forced_retreat(self) -> None:
        combined = "\n".join(path.read_text(encoding="utf-8") for path in (DECISION, DESIGN, AUDIT))
        for required in (
            "안전 철수 경로",
            "철수 근거",
            "보호 대상과 중요 기록의 상태",
            "통제 붕괴 전에 의도적으로 종료",
            "승인 조건을 충족하지 못한 강제 퇴각은 `control_failure`",
        ):
            self.assertIn(required, combined)

    def test_legacy_boolean_is_compatibility_only_and_status_is_authoritative(self) -> None:
        combined = "\n".join(path.read_text(encoding="utf-8") for path in (DECISION, DESIGN, AUDIT, IMPLEMENTATION_PLAN))
        for required in (
            "core_recovered",
            "LEGACY_SINGLE_OUTCOME",
            "capture_success",
            "recovery_successful",
            "LEGACY_COMPAT_ONLY",
            "대표 결과 상태가 권위",
            "bool만으로 승인 철수와 통제 실패를 구분하지 않는다",
        ):
            self.assertIn(required, combined)

    def test_implementation_plan_is_tdd_first_and_does_not_authorize_execution(self) -> None:
        plan = IMPLEMENTATION_PLAN.read_text(encoding="utf-8")
        for required in (
            "# Recovery Outcome States and Result Packet Implementation Plan",
            "Write the failing test",
            "Run test to verify it fails",
            "scripts/core/game_state.gd",
            "scripts/scenes/battle_scene.gd",
            "scripts/scenes/result_scene.gd",
            "save migration",
            "IMPLEMENTATION_NOT_AUTHORIZED",
        ):
            self.assertIn(required, plan)

    def test_batch_keeps_fifth_approval_and_allows_later_approved_entries(self) -> None:
        batch = BATCH.read_text(encoding="utf-8")
        counter = re.search(r"OPEN / (\d+)_OF_10", batch)
        self.assertIsNotNone(counter)
        self.assertGreaterEqual(int(counter.group(1)), 5)
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
        test_path = "tests/test_recovery_outcome_states_and_result_packet_planning_contract.py"
        self.assertGreaterEqual(workflow.count(test_path), 2)


if __name__ == "__main__":
    unittest.main()
