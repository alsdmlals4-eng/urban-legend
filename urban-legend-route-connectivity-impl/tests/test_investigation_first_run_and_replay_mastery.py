from __future__ import annotations

import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DECISION_9 = ROOT / "docs/decisions/D-2026-08-04-INVESTIGATION-FIRST-RUN-CANON-AND-REPLAY-MASTERY-SEPARATION.md"
SECTION_19 = ROOT / "docs/planning/2026-08-04-investigation-system-design-batch-3-section-19-first-run-and-replay-mastery.md"
BATCH = ROOT / "docs/planning/2026-08-03-investigation-system-design-batch-3.md"
LEDGER = ROOT / "docs/GRILLME_BATCH_3_LEDGER.md"
WORKFLOW = ROOT / "docs/workflows/INVESTIGATION_CASE_AUTHORING_WORKFLOW.md"
SKILL = ROOT / "skills/urban-legend-investigation-case-authoring/SKILL.md"


class InvestigationFirstRunAndReplayMasteryTests(unittest.TestCase):
    def test_decision_and_section_exist_and_batch_advances(self) -> None:
        self.assertTrue(DECISION_9.is_file(), DECISION_9)
        self.assertTrue(SECTION_19.is_file(), SECTION_19)
        text = BATCH.read_text(encoding="utf-8") + LEDGER.read_text(encoding="utf-8")
        self.assertIn("GRILLME_BATCH_3_9_OF_10", text)
        self.assertIn("9 / 10", text)
        self.assertIn("Section 19", text)

    def test_first_spoiler_free_resolution_owns_rank_and_campaign_canon(self) -> None:
        text = DECISION_9.read_text(encoding="utf-8") + WORKFLOW.read_text(encoding="utf-8")
        for token in (
            "최초 조사 기록",
            "정답 비공개 상태",
            "최초 사건 결과 확정",
            "최초 조사 등급",
            "최초 조사 S 랭크",
            "캠페인 정본",
            "피해자 상태",
            "세력 반응",
            "기본 성장 보상",
            "1회 지급",
        ):
            self.assertIn(token, text)

    def test_answer_viewed_replay_is_noncanonical_mastery_record(self) -> None:
        text = DECISION_9.read_text(encoding="utf-8") + WORKFLOW.read_text(encoding="utf-8") + SKILL.read_text(encoding="utf-8")
        for token in (
            "정답 공개 후 기록 재현",
            "answer_viewed",
            "비정본 재현",
            "재현 숙련 등급",
            "최초 조사 S 랭크를 덮어쓰지 않는다",
            "캠페인 정본을 덮어쓰지 않는다",
            "피해자 상태를 덮어쓰지 않는다",
            "세력 반응을 덮어쓰지 않는다",
        ):
            self.assertIn(token, text)

    def test_replay_rewards_cannot_become_progression_farm(self) -> None:
        text = DECISION_9.read_text(encoding="utf-8") + WORKFLOW.read_text(encoding="utf-8")
        for token in (
            "반복 파밍 불가",
            "중복 성장 보상 금지",
            "전투력·필수 성장에 영향을 주지 않는",
            "도감·기록 완성",
            "선택적 외형 보상",
            "사건당 1회",
            "캠페인 진행 필수 조건으로 사용하지 않는다",
        ):
            self.assertIn(token, text)

    def test_pre_reveal_retry_and_accessibility_do_not_taint_first_run(self) -> None:
        text = DECISION_9.read_text(encoding="utf-8") + SKILL.read_text(encoding="utf-8")
        for token in (
            "정답 보고서가 열리기 전",
            "체크포인트 재개",
            "같은 최초 조사 세션",
            "answer_viewed로 전환하지 않는다",
            "접근성 기능",
            "최초 조사 자격을 박탈하지 않는다",
        ):
            self.assertIn(token, text)

    def test_system_labels_spoiler_state_without_claiming_external_cheat_detection(self) -> None:
        text = DECISION_9.read_text(encoding="utf-8")
        for token in (
            "시스템 내부 공개 이력",
            "first_run",
            "answer_viewed",
            "replay_mastery",
            "외부 공략 열람 여부를 판정하지 않는다",
            "최초 조사와 기록 재현을 한 화면에서 혼동시키지 않는다",
        ):
            self.assertIn(token, text)


if __name__ == "__main__":
    unittest.main()
