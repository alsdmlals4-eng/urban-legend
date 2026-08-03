from __future__ import annotations

import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SKILL = ROOT / "skills/urban-legend-investigation-case-authoring/SKILL.md"
WORKFLOW = ROOT / "docs/workflows/INVESTIGATION_CASE_AUTHORING_WORKFLOW.md"
DECISION_2 = ROOT / "docs/decisions/D-2026-08-03-INVESTIGATION-HYPOTHESIS-STAGED-VALIDATION-AND-FEEDBACK.md"
DECISION_8 = ROOT / "docs/decisions/D-2026-08-04-INVESTIGATION-REVISION-EVIDENCE-REUSE-AND-POST-SESSION-TRUTH-REVEAL.md"
SECTION_18 = ROOT / "docs/planning/2026-08-04-investigation-system-design-batch-3-section-18-revision-and-truth-reveal.md"
BATCH = ROOT / "docs/planning/2026-08-03-investigation-system-design-batch-3.md"
LEDGER = ROOT / "docs/GRILLME_BATCH_3_LEDGER.md"


class InvestigationSessionTruthRevealTests(unittest.TestCase):
    def test_decision_and_section_exist_and_batch_advances(self) -> None:
        self.assertTrue(DECISION_8.is_file(), DECISION_8)
        self.assertTrue(SECTION_18.is_file(), SECTION_18)
        batch_text = BATCH.read_text(encoding="utf-8")
        ledger_text = LEDGER.read_text(encoding="utf-8")
        self.assertIn("GRILLME_BATCH_3_8_OF_10", batch_text)
        self.assertIn("8 / 10", ledger_text)
        self.assertIn(DECISION_8.stem, batch_text + ledger_text)

    def test_session_hides_truth_until_the_result_report(self) -> None:
        text = (
            DECISION_8.read_text(encoding="utf-8")
            + WORKFLOW.read_text(encoding="utf-8")
            + SKILL.read_text(encoding="utf-8")
        )
        for token in (
            "세션 중 정답·오답 비공개",
            "세션 종료 후 정답 공개",
            "슬롯별 정답 비교",
            "구출·회수 결과",
            "관찰 가능한 현상",
            "자동 정오 판정",
            "정답 근접도",
        ):
            self.assertIn(token, text)

    def test_players_may_place_any_unlocked_candidate_and_revise_before_execution(self) -> None:
        text = WORKFLOW.read_text(encoding="utf-8") + SKILL.read_text(encoding="utf-8")
        for token in (
            "임의 후보 배치",
            "정답 적합도로 차단하지 않는다",
            "이전 페이지 자유 수정",
            "최종 진입 확인",
            "실행 페이즈에서는 읽기 전용",
            "조사 페이즈로 후퇴",
        ):
            self.assertIn(token, text)

    def test_keywords_are_nonconsumable_evidence_references_with_provenance(self) -> None:
        text = WORKFLOW.read_text(encoding="utf-8") + SKILL.read_text(encoding="utf-8")
        for token in (
            "비소모 증거 참조",
            "동일 키워드 재사용",
            "단일 출처",
            "사용 위치 목록",
            "의미 관계가 성립",
            "[변조] 후보는 원본과 별도 후보",
        ):
            self.assertIn(token, text)

    def test_clue_records_support_deduction_without_revealing_answer_labels(self) -> None:
        text = WORKFLOW.read_text(encoding="utf-8") + DECISION_8.read_text(encoding="utf-8")
        for token in (
            "단서 [기록]",
            "원본 출처",
            "획득 장면",
            "관찰 사실",
            "정답 라벨",
            "플레이어가 직접 추론",
        ):
            self.assertIn(token, text)

    def test_earlier_staged_validation_no_longer_reveals_confirmed_truth_mid_session(self) -> None:
        text = DECISION_2.read_text(encoding="utf-8")
        for token in (
            "Decision 8 교정",
            "세션 중에는 `확인 규칙` 상태를 표시하지 않는다",
            "구조·근거·상충·실행 준비도",
            "정답 여부는 세션 종료 보고서",
        ):
            self.assertIn(token, text)


if __name__ == "__main__":
    unittest.main()
