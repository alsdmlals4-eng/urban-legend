from __future__ import annotations

import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DECISION_10 = ROOT / "docs/decisions/D-2026-08-04-INVESTIGATION-OUTCOME-SCOPED-TRUTH-REVEAL-AND-OPT-IN-FULL-DISCLOSURE.md"
SECTION_20 = ROOT / "docs/planning/2026-08-04-investigation-system-design-batch-3-section-20-outcome-scoped-truth-reveal.md"
BATCH = ROOT / "docs/planning/2026-08-03-investigation-system-design-batch-3.md"
LEDGER = ROOT / "docs/GRILLME_BATCH_3_LEDGER.md"
WORKFLOW = ROOT / "docs/workflows/INVESTIGATION_CASE_AUTHORING_WORKFLOW.md"
SKILL = ROOT / "skills/urban-legend-investigation-case-authoring/SKILL.md"


class InvestigationOutcomeScopedTruthRevealTests(unittest.TestCase):
    def test_decision_and_section_exist_and_batch_reaches_ten(self) -> None:
        self.assertTrue(DECISION_10.is_file(), DECISION_10)
        self.assertTrue(SECTION_20.is_file(), SECTION_20)
        text = BATCH.read_text(encoding="utf-8") + LEDGER.read_text(encoding="utf-8")
        self.assertIn("GRILLME_BATCH_3_10_OF_10", text)
        self.assertIn("10 / 10", text)
        self.assertIn("Section 20", text)
        self.assertIn("GRILLME_BATCH_3_9_OF_10", text)
        self.assertIn("9 / 10", text)

    def test_normal_clear_automatically_reveals_complete_current_case_truth(self) -> None:
        text = DECISION_10.read_text(encoding="utf-8") + WORKFLOW.read_text(encoding="utf-8")
        for token in (
            "정상 클리어",
            "전체 정답 자동 공개",
            "다섯 의미 슬롯",
            "슬롯별 정답 비교",
            "answer_viewed",
            "다음 사건의 미획득 증거나 정답은 공개하지 않는다",
        ):
            self.assertIn(token, text)

    def test_failure_and_approved_withdrawal_reveal_only_field_verified_scope(self) -> None:
        text = DECISION_10.read_text(encoding="utf-8") + WORKFLOW.read_text(encoding="utf-8") + SKILL.read_text(encoding="utf-8")
        for token in (
            "실패",
            "승인 철수",
            "검증된 슬롯",
            "직접 관찰된 현상",
            "실패를 일으킨 행동",
            "위험 사례",
            "미검증 슬롯은 숨김",
            "정답 근접도",
        ):
            self.assertIn(token, text)

    def test_player_can_opt_into_full_disclosure_with_explicit_spoiler_warning(self) -> None:
        text = DECISION_10.read_text(encoding="utf-8") + WORKFLOW.read_text(encoding="utf-8")
        for token in (
            "공식 정답 전체 공개",
            "명시적 선택",
            "사전 경고",
            "answer_viewed로 전환",
            "비정본 재현",
            "재현 숙련 등급",
            "최초 조사 정본을 덮어쓰지 않는다",
        ):
            self.assertIn(token, text)

    def test_partial_report_preserves_spoiler_limited_reinvestigation_without_rewriting_history(self) -> None:
        text = DECISION_10.read_text(encoding="utf-8") + SKILL.read_text(encoding="utf-8")
        for token in (
            "정답 비공개 후속 재조사",
            "partial_truth_revealed",
            "answer_viewed로 전환하지 않는다",
            "최초 실패와 위험 사례를 보존",
            "후속 결과를 추가 기록",
            "최초 조사 S 랭크를 덮어쓰지 않는다",
        ):
            self.assertIn(token, text)

    def test_safety_accessibility_and_economy_cannot_be_held_hostage_by_hidden_answers(self) -> None:
        text = DECISION_10.read_text(encoding="utf-8") + WORKFLOW.read_text(encoding="utf-8")
        for token in (
            "필수 안전 정보",
            "명확히 예고된 비가역 결과",
            "접근성 기능",
            "동일한 경고와 선택",
            "전체 정답 공개를 강제하지 않는다",
            "정답 공개 자체에 보상 없음",
            "유료화·시간 잠금 금지",
        ):
            self.assertIn(token, text)


if __name__ == "__main__":
    unittest.main()
