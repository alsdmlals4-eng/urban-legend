from __future__ import annotations

import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CORE = ROOT / "docs/PROJECT_CORE.md"
GDD = ROOT / "docs/GAME_DESIGN_DOCUMENT.md"
BUILDER = ROOT / "tools/docs/build_game_design_doc.py"
FOUR_WEEK_SPEC = ROOT / "docs/superpowers/specs/2026-07-25-annual-mvp-001-four-week-month-design.md"
FOUR_WEEK_PLAN = ROOT / "docs/superpowers/plans/2026-07-25-annual-mvp-001-four-week-month-implementation-plan.md"
SEVEN_DAY_SPEC = ROOT / "docs/superpowers/specs/2026-07-25-annual-mvp-001-seven-day-scheduling-design.md"
SEVEN_DAY_PLAN = ROOT / "docs/superpowers/plans/2026-07-25-annual-mvp-001-seven-day-scheduling-implementation-plan.md"


class AnnualMvp001DocumentContractTests(unittest.TestCase):
    def test_authority_documents_exist(self) -> None:
        for path in (FOUR_WEEK_SPEC, FOUR_WEEK_PLAN, SEVEN_DAY_SPEC, SEVEN_DAY_PLAN):
            self.assertTrue(path.is_file(), path.relative_to(ROOT))

    def test_core_and_gdd_use_active_seven_day_status(self) -> None:
        core = CORE.read_text(encoding="utf-8")
        gdd = GDD.read_text(encoding="utf-8")
        for text in (core, gdd):
            self.assertIn("SEVEN_DAY_SCHEDULING_ON_BRANCH", text)
            self.assertIn("CI_PENDING", text)
            self.assertIn("1개월 = 4주 × 주당 7일 = 총 28일", text)
            self.assertIn("annual-mvp-001-v3", text)
            self.assertIn("일정은 주차 경계를 넘", text)
            self.assertIn("자동 휴식", text)
            self.assertIn("1일당 피로 5", text)
            self.assertIn("HISTORICAL_REGRESSION_EVIDENCE", text)
            self.assertIn("POC_PASSED", text)
        self.assertIn("2주차 자율 출동 위험 0", gdd)
        self.assertIn("3주차 자율 출동 위험 15", gdd)
        self.assertIn("4주차 7일 결과 확인 후 긴급 강제 출동 위험 30", gdd)
        self.assertNotIn("ANNUAL-MVP-001은 3주 육성", gdd)

    def test_direct_and_automatic_rest_are_distinct(self) -> None:
        combined = CORE.read_text(encoding="utf-8") + "\n" + GDD.read_text(encoding="utf-8")
        self.assertIn("직접 휴식", combined)
        self.assertIn("피로 -25", combined)
        self.assertIn("상태 회복 가능", combined)
        self.assertIn("관계·특수 회복·추가 보상 없음", combined)

    def test_gdd_builder_matches_untracked_generated_mirror_policy(self) -> None:
        builder = BUILDER.read_text(encoding="utf-8")
        gitignore = (ROOT / ".gitignore").read_text(encoding="utf-8")
        self.assertIn('FORMAT_VERSION = "urban-legend-gdd-index-v5"', builder)
        self.assertIn("GDD v3.2", builder)
        self.assertIn("ANNUAL-MVP-001 4주×7일", builder)
        self.assertIn("expected_images = len(image_paths(markdown))", builder)
        self.assertIn("/docs/URBAN_LEGEND_GAME_DESIGN.docx", gitignore)


if __name__ == "__main__":
    unittest.main()
