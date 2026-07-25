from pathlib import Path
import unittest


ROOT = Path(__file__).resolve().parents[1]
REPORT = ROOT / "docs/research/2026-07-26-genre-benchmark.md"
RECOMMENDATIONS = ROOT / "docs/planning/ANNUAL_BENCHMARK_RECOMMENDATIONS.md"
DECISIONS = ROOT / "docs/DECISION_LOG.md"


class GenreBenchmarkContractTest(unittest.TestCase):
    def read(self, path: Path) -> str:
        self.assertTrue(path.exists(), f"missing required document: {path}")
        return path.read_text(encoding="utf-8")

    def test_benchmark_targets_are_preserved(self) -> None:
        text = self.read(REPORT)
        for title in (
            "Persona 5 Royal",
            "I Was a Teenage Exocolonist",
            "Long Live the Queen",
            "Citizen Sleeper",
            "WORLD OF HORROR",
            "The Case of the Golden Idol",
            "Return of the Obra Dinn",
            "PARANORMASIGHT",
            "Strange Horticulture",
        ):
            self.assertIn(title, text)

    def test_current_fixed_contract_is_not_replaced(self) -> None:
        text = self.read(REPORT) + self.read(RECOMMENDATIONS)
        for token in (
            "4주 × 7일",
            "위험 0/15/30",
            "권나래 고정",
            "기존 승인 설계 변경: 없음",
            "구현 승인: 없음",
            "poc_passed: NOT_DECLARED",
            "production_expansion: NOT_APPROVED",
        ):
            self.assertIn(token, text)

    def test_all_p0_recommendations_are_recorded(self) -> None:
        text = self.read(RECOMMENDATIONS)
        for recommendation_id in (
            "BENCH-P0-001",
            "BENCH-P0-002",
            "BENCH-P0-003",
            "BENCH-P0-004",
            "BENCH-P0-005",
            "BENCH-P0-006",
            "BENCH-P0-007",
        ):
            self.assertIn(recommendation_id, text)
        self.assertIn("RECOMMENDED_FOR_REVIEW", text)

    def test_rejected_patterns_remain_explicit(self) -> None:
        text = self.read(RECOMMENDATIONS)
        for rejected_id in (
            "BENCH-X-001",
            "BENCH-X-002",
            "BENCH-X-003",
            "BENCH-X-004",
            "BENCH-X-005",
            "BENCH-X-006",
            "BENCH-X-007",
        ):
            self.assertIn(rejected_id, text)

    def test_decision_log_links_benchmark_sources(self) -> None:
        text = self.read(DECISIONS)
        self.assertIn("D-2026-07-26-ANNUAL-GENRE-BENCHMARK", text)
        self.assertIn("BENCHMARK_RESEARCH_COMPLETE / RECOMMENDED_FOR_REVIEW", text)
        self.assertIn("docs/research/2026-07-26-genre-benchmark.md", text)
        self.assertIn("docs/planning/ANNUAL_BENCHMARK_RECOMMENDATIONS.md", text)
        self.assertIn("구현 승인: `NOT_GRANTED`", text)

    def test_no_placeholders_remain(self) -> None:
        for path in (REPORT, RECOMMENDATIONS):
            text = self.read(path)
            self.assertNotIn("TBD", text)
            self.assertNotIn("TODO", text)


if __name__ == "__main__":
    unittest.main()
