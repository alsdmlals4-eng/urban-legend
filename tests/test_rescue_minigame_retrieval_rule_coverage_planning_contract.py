from __future__ import annotations

import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DECISION_ID = "DEC-20260805-117-CANON-V2-RESCUE-MINIGAME-AND-RETRIEVAL-RULE-COVERAGE"
DECISION = ROOT / f"docs/decisions/{DECISION_ID}.md"
PLAN = ROOT / "docs/planning/2026-08-05-canon-v2-rescue-minigame-retrieval-rule-coverage-design.md"
AUDIT = ROOT / "docs/audits/2026-08-05-minigame-retrieval-rule-coverage-audit.md"
BATCH = ROOT / "docs/planning/2026-08-05-grillme-batch-3-approvals.md"
DESIGN_INTENT = ROOT / "DESIGN_INTENT.md"
PROJECT_BRIEF = ROOT / "PROJECT_BRIEF.md"


class RescueMinigameRetrievalRuleCoveragePlanningContractTests(unittest.TestCase):
    def test_authority_files_exist_and_share_decision_id(self) -> None:
        for path in (DECISION, PLAN, AUDIT, BATCH, DESIGN_INTENT, PROJECT_BRIEF):
            self.assertTrue(path.is_file(), path.relative_to(ROOT))
            text = path.read_text(encoding="utf-8")
            self.assertIn(DECISION_ID, text, path.relative_to(ROOT))
            self.assertNotIn("TODO", text, path.relative_to(ROOT))
            self.assertNotIn("TBD", text, path.relative_to(ROOT))

    def test_common_four_step_rescue_grammar_and_case_variation(self) -> None:
        combined = "\n".join(
            path.read_text(encoding="utf-8") for path in (DECISION, PLAN)
        )
        for required in (
            "공통 4단계 구출 문법",
            "피해자·현재 위험 확인",
            "안전 행동·금지 행동 확인",
            "사건별 핵심 조작",
            "구출 결과·회수 인계",
            "핵심 입력 1~2종",
            "30초",
            "1~3분",
            "사람 검증 전 달성 판정 금지",
            "저승역",
            "빨간 우산 골목",
            "폐주파수 방송국",
            "기록되지 않은 병동",
        ):
            self.assertIn(required, combined)

    def test_rescue_risk_retry_and_handoff_contract_is_explicit(self) -> None:
        combined = "\n".join(
            path.read_text(encoding="utf-8") for path in (DECISION, PLAN, AUDIT)
        )
        for required in (
            "안정 → 불안정 → 위험 → 임계 → 비가역 결과",
            "동일 의미 상태는 동일 결과",
            "실질적 변경",
            "구출 결과 패킷",
            "생존",
            "분리",
            "후유증",
            "보호 의무",
            "회수 초기 조건",
            "부분 성공",
            "실패 전진",
        ):
            self.assertIn(required, combined)

    def test_retrieval_rules_cover_actions_outcomes_and_independent_results(self) -> None:
        combined = "\n".join(
            path.read_text(encoding="utf-8") for path in (DECISION, PLAN, AUDIT)
        )
        for required in (
            "보호·관찰·대응·공격·장비·봉쇄·후퇴",
            "안정화",
            "봉쇄",
            "잔향 회수",
            "승인 철수",
            "공격 반복만으로 기본 승리 불가",
            "구출과 회수 결과를 독립 기록",
            "core_recovered 단일 결과",
        ):
            self.assertIn(required, combined)

    def test_audit_classifies_authority_data_runtime_and_test_gaps(self) -> None:
        audit = AUDIT.read_text(encoding="utf-8")
        for required in (
            "정본 준비 완료",
            "부분 연결",
            "구형 구현 충돌",
            "MINIGAME_SYSTEM_SPEC.md",
            "minigame_scene.gd",
            "route_restore_game.gd",
            "rain_dodge_game.gd",
            "rhythm_timing_game.gd",
            "battle_scene.gd",
            "game_state.gd",
            "result_scene.gd",
            "episode_001_afterlife_station_canon_v2.json",
            "afterlife_runtime_projection_test.gd",
            "minigame_rules_test.gd",
            "minigame_pipeline_test.gd",
        ):
            self.assertIn(required, audit)

    def test_accessibility_and_authorization_boundaries_remain_closed(self) -> None:
        combined = "\n".join(
            path.read_text(encoding="utf-8") for path in (DECISION, PLAN, AUDIT)
        )
        for required in (
            "접근성 대체 입력",
            "시간 압박 완화",
            "랭크 감점 금지",
            "IMPLEMENTATION_NOT_AUTHORIZED",
            "HUMAN_QA_NOT_RUN",
            "UI_ACCESSIBILITY_NOT_RUN",
            "MERGE_NOT_AUTHORIZED",
            "PR #149",
            "PR #151",
        ):
            self.assertIn(required, combined)

    def test_batch_records_third_approval_without_merge_claim(self) -> None:
        batch = BATCH.read_text(encoding="utf-8")
        counter = re.search(r"OPEN / (\d+)_OF_10", batch)
        self.assertIsNotNone(counter)
        self.assertGreaterEqual(int(counter.group(1)), 3)
        self.assertIn(DECISION_ID, batch)
        self.assertIn("APPROVED", batch)
        self.assertIn("BATCH_MERGE_NOT_STARTED", batch)
        self.assertNotIn("> 배치 병합: `BATCH_MERGED`", batch)


if __name__ == "__main__":
    unittest.main()
