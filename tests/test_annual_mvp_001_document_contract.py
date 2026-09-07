from __future__ import annotations

import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CORE = ROOT / "docs/PROJECT_CORE.md"
MASTER_GDD = ROOT / "docs/design/PROJECT_AI_PRODUCTION_SPEC.md"
HISTORICAL_GDD = ROOT / "docs/GAME_DESIGN_DOCUMENT.md"
BUILDER = ROOT / "tools/docs/build_game_design_doc.py"
FOUR_WEEK_SPEC = ROOT / "docs/superpowers/specs/2026-07-25-annual-mvp-001-four-week-month-design.md"
FOUR_WEEK_PLAN = ROOT / "docs/superpowers/plans/2026-07-25-annual-mvp-001-four-week-month-implementation-plan.md"
SEVEN_DAY_SPEC = ROOT / "docs/superpowers/specs/2026-07-25-annual-mvp-001-seven-day-scheduling-design.md"
SEVEN_DAY_PLAN = ROOT / "docs/superpowers/plans/2026-07-25-annual-mvp-001-seven-day-scheduling-implementation-plan.md"


class AnnualMvp001DocumentContractTests(unittest.TestCase):
    def test_authority_documents_exist(self) -> None:
        for path in (FOUR_WEEK_SPEC, FOUR_WEEK_PLAN, SEVEN_DAY_SPEC, SEVEN_DAY_PLAN):
            self.assertTrue(path.is_file(), path.relative_to(ROOT))

    def test_historical_detail_is_preserved_but_master_gdd_owns_current_systems(self) -> None:
        core = CORE.read_text(encoding="utf-8")
        historical = HISTORICAL_GDD.read_text(encoding="utf-8")
        master = MASTER_GDD.read_text(encoding="utf-8")
        for text in (core, historical):
            self.assertIn("SEVEN_DAY_SCHEDULING_MERGED", text)
            self.assertIn("AUTOMATED_QA_PASSED", text)
            self.assertNotIn("SEVEN_DAY_SCHEDULING_ON_BRANCH", text)
            self.assertNotIn("CI_PENDING", text)
            self.assertIn("1개월 = 4주 × 주당 7일 = 총 28일", text)
            self.assertIn("annual-mvp-001-v3", text)
            self.assertIn("일정은 주차 경계를 넘", text)
            self.assertIn("자동 휴식", text)
            self.assertIn("1일당 피로 5", text)
            self.assertIn("HISTORICAL_REGRESSION_EVIDENCE", text)
            self.assertIn("POC_PASSED", text)
        self.assertIn("2주차 자율 출동 위험 0", historical)
        self.assertIn("3주차 자율 출동 위험 15", historical)
        self.assertIn("4주차 7일 결과 확인 후 긴급 강제 출동 위험 30", historical)
        self.assertNotIn("ANNUAL-MVP-001은 3주 육성", historical)
        self.assertIn("HISTORICAL_REFERENCE / NOT_CURRENT_PRODUCT_AUTHORITY", historical)
        for section in (
            "## 07. 10-day schedule system",
            "## 08. Investigation phase",
            "## 09. Keyword and anomaly-manual system",
            "## 10. Rescue and recovery phase",
        ):
            self.assertIn(section, master)

    def test_direct_and_automatic_rest_are_distinct(self) -> None:
        combined = CORE.read_text(encoding="utf-8") + "\n" + HISTORICAL_GDD.read_text(encoding="utf-8")
        self.assertIn("직접 휴식", combined)
        self.assertIn("피로 -25", combined)
        self.assertIn("상태 회복 가능", combined)
        self.assertIn("관계·특수 회복·추가 보상 없음", combined)

    def test_gdd_builder_matches_untracked_generated_mirror_policy(self) -> None:
        builder = BUILDER.read_text(encoding="utf-8")
        gitignore = (ROOT / ".gitignore").read_text(encoding="utf-8")
        self.assertIn('FORMAT_VERSION = "urban-legend-master-gdd-v6"', builder)
        self.assertIn('"design" / "PROJECT_AI_PRODUCTION_SPEC.md"', builder)
        self.assertIn("Master GDD", builder)
        self.assertIn("10일·반일 캠페인", builder)
        self.assertIn("expected_images = len(image_paths(markdown))", builder)
        self.assertIn("/docs/URBAN_LEGEND_GAME_DESIGN.docx", gitignore)


if __name__ == "__main__":
    unittest.main()
