from __future__ import annotations

import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SKILL = ROOT / "skills/urban-legend-investigation-case-authoring/SKILL.md"
WORKFLOW = ROOT / "docs/workflows/INVESTIGATION_CASE_AUTHORING_WORKFLOW.md"
REGISTRY = ROOT / "skills/SKILL_REGISTRY.json"


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


if __name__ == "__main__":
    unittest.main()
