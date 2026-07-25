from __future__ import annotations

import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CORE = ROOT / "docs/PROJECT_CORE.md"
GDD = ROOT / "docs/GAME_DESIGN_DOCUMENT.md"
BUILDER = ROOT / "tools/docs/build_game_design_doc.py"
FOUR_WEEK_SPEC = ROOT / "docs/superpowers/specs/2026-07-25-annual-mvp-001-four-week-month-design.md"
FOUR_WEEK_PLAN = ROOT / "docs/superpowers/plans/2026-07-25-annual-mvp-001-four-week-month-implementation-plan.md"


class AnnualMvp001DocumentContractTests(unittest.TestCase):
    def test_four_week_authority_documents_exist(self) -> None:
        self.assertTrue(FOUR_WEEK_SPEC.is_file())
        self.assertTrue(FOUR_WEEK_PLAN.is_file())

    def test_core_and_gdd_use_merged_four_week_status(self) -> None:
        core = CORE.read_text(encoding="utf-8")
        gdd = GDD.read_text(encoding="utf-8")
        for text in (core, gdd):
            self.assertIn("FOUR_WEEK_MERGED", text)
            self.assertIn("AUTOMATED_QA_PASSED", text)
            self.assertIn("1개월 = 4주 × 주당 3개 일정 슬롯 = 최대 12슬롯", text)
            self.assertIn("2주차: 활동 3개, 자율 출동 위험 0 또는 지연", text)
            self.assertIn("3주차: 활동 3개, 자율 출동 위험 15 또는 지연", text)
            self.assertIn("4주차: 활동 3개와 주간 결과 확인 후 긴급 강제 출동 위험 30", text)
            self.assertIn("HISTORICAL_REGRESSION_EVIDENCE", text)
            self.assertNotIn("연도제 구현: `NOT_IMPLEMENTED`", text)
        self.assertNotIn("ANNUAL-MVP-001은 3주 육성", gdd)

    def test_gdd_builder_matches_untracked_generated_mirror_policy(self) -> None:
        builder = BUILDER.read_text(encoding="utf-8")
        gitignore = (ROOT / ".gitignore").read_text(encoding="utf-8")
        self.assertIn('FORMAT_VERSION = "urban-legend-gdd-index-v4"', builder)
        self.assertIn("GDD v3.1", builder)
        self.assertIn("ANNUAL-MVP-001 4주", builder)
        self.assertIn("expected_images = len(image_paths(markdown))", builder)
        self.assertIn("/docs/URBAN_LEGEND_GAME_DESIGN.docx", gitignore)


if __name__ == "__main__":
    unittest.main()
