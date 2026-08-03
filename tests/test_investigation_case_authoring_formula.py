from __future__ import annotations

import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SKILL = ROOT / "skills/urban-legend-investigation-case-authoring/SKILL.md"
WORKFLOW = ROOT / "docs/workflows/INVESTIGATION_CASE_AUTHORING_WORKFLOW.md"
REGISTRY = ROOT / "skills/SKILL_REGISTRY.json"
DECISION_4 = ROOT / "docs/decisions/D-2026-08-03-INVESTIGATION-MUTATED-KEYWORDS-AND-MANUAL-DRIVEN-EXECUTION.md"
SECTION_14 = ROOT / "docs/planning/2026-08-03-investigation-system-design-batch-3-section-14-manual-driven-execution.md"
DECISION_5 = ROOT / "docs/decisions/D-2026-08-04-INVESTIGATION-PAGE-LOCAL-CANDIDATE-POOL-AND-DIFFICULTY-CURVE.md"
SECTION_15 = ROOT / "docs/planning/2026-08-04-investigation-system-design-batch-3-section-15-candidate-pool.md"


class InvestigationCaseAuthoringFormulaTests(unittest.TestCase):
    def test_registered_project_skill_routes_case_authoring(self) -> None:
        registry = json.loads(REGISTRY.read_text(encoding="utf-8"))
        matches = [
            item
            for item in registry.get("project_local_skills", [])
            if item.get("skill_id") == "urban-legend-investigation-case-authoring"
        ]
        self.assertEqual(len(matches), 1)
        item = matches[0]
        self.assertEqual(item["status"], "ACTIVE")
        self.assertEqual(item["path"], "skills/urban-legend-investigation-case-authoring/SKILL.md")
        self.assertIn("investigation-case-authoring", item["trigger_tags"])
        self.assertIn("manual-rule-authoring", item["trigger_tags"])

    def test_skill_links_the_case_authoring_workflow(self) -> None:
        self.assertTrue(WORKFLOW.is_file(), WORKFLOW)
        text = SKILL.read_text(encoding="utf-8")
        self.assertIn("docs/workflows/INVESTIGATION_CASE_AUTHORING_WORKFLOW.md", text)
        for token in (
            "2~3장",
            "3~5개",
            "원시 관찰 기록",
            "사건 키워드",
            "추론 키워드",
            "그럴듯한 오답",
            "괴이 매뉴얼",
            "피해자 구출",
            "회수 전투",
        ):
            self.assertIn(token, text)

    def test_workflow_defines_backward_case_authoring_and_clue_provenance(self) -> None:
        text = WORKFLOW.read_text(encoding="utf-8")
        for token in (
            "괴이의 실제 규칙",
            "완성 괴이 매뉴얼",
            "완성 조사문",
            "정답 키워드",
            "원시 단서",
            "획득 장면",
            "그럴듯한 오답 가설",
            "후속 반증 단서",
            "구출·회수 전투",
            "출처",
            "획득 행동",
            "사용 슬롯",
        ):
            self.assertIn(token, text)

    def test_workflow_keeps_keyword_budget_and_mixed_refinement(self) -> None:
        text = WORKFLOW.read_text(encoding="utf-8")
        for token in (
            "2~3장",
            "장당 3~5개",
            "직접 관찰·증언 키워드",
            "비교·모순 키워드",
            "복수 단서 연결 추론 키워드",
            "18~24개",
            "즉시 사건 키워드",
            "원시 관찰 기록",
            "정제 키워드",
        ):
            self.assertIn(token, text)

    def test_mutated_keywords_are_derived_candidates_without_new_acquisition_paths(self) -> None:
        self.assertTrue(DECISION_4.is_file(), DECISION_4)
        self.assertTrue(SECTION_14.is_file(), SECTION_14)
        skill_text = SKILL.read_text(encoding="utf-8")
        workflow_text = WORKFLOW.read_text(encoding="utf-8")
        for token in (
            "[변조]",
            "기존 정상 키워드",
            "변수 하나",
            "별도 획득·생성 경로를 만들지 않는다",
            "조사 기억",
            "완성 중인 괴이 매뉴얼",
        ):
            self.assertIn(token, skill_text + workflow_text)

    def test_manual_drives_rescue_and_variable_length_recovery_patterns(self) -> None:
        text = SKILL.read_text(encoding="utf-8") + WORKFLOW.read_text(encoding="utf-8")
        for token in (
            "피해자 구출 미니게임",
            "최소 2턴",
            "첫 턴",
            "중간 턴",
            "마지막 턴",
            "대응 선택",
            "패턴 발현",
            "결과 산출",
            "평상 진행",
            "패턴 준비 완료 상태를 표시하지 않는다",
            "[파훼]",
            "[취약]",
        ):
            self.assertIn(token, text)

    def test_recovery_turn_order_is_not_fixed_to_four_turns(self) -> None:
        text = WORKFLOW.read_text(encoding="utf-8")
        self.assertIn("N ≥ 2", text)
        self.assertIn("전조 횟수 = N - 1", text)
        self.assertIn("첫 턴: [전조] → 선택 → 평상 진행", text)
        self.assertIn("중간 턴: 선택 → [전조] → 평상 진행", text)
        self.assertIn("마지막 턴: 대응 선택 → 패턴 발현 → 결과 산출 → 평상 진행", text)
        self.assertIn("4턴은 예시일 뿐", text)

    def test_page_local_candidate_pool_has_progressive_budgets(self) -> None:
        self.assertTrue(DECISION_5.is_file(), DECISION_5)
        self.assertTrue(SECTION_15.is_file(), SECTION_15)
        text = SKILL.read_text(encoding="utf-8") + WORKFLOW.read_text(encoding="utf-8")
        for token in (
            "장별 후보 풀",
            "현재 조사문",
            "초반 사건",
            "5~6개",
            "표준 사건",
            "7~10개",
            "핵심 사건",
            "9~12개",
        ):
            self.assertIn(token, text)

    def test_candidate_search_and_sort_never_reveal_answer_fitness(self) -> None:
        text = WORKFLOW.read_text(encoding="utf-8")
        for token in (
            "키워드 이름",
            "원본 출처",
            "획득 순서",
            "가나다순",
            "정상·변조 여부",
            "정답 적합도",
            "이 슬롯에 들어갈 수 있는 후보만 보기",
            "제공하지 않는다",
            "미획득 키워드",
        ):
            self.assertIn(token, text)


if __name__ == "__main__":
    unittest.main()
