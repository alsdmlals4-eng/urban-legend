import json
from pathlib import Path
import unittest


ROOT = Path(__file__).resolve().parents[1]


class ReplanningEntryContract(unittest.TestCase):
    def test_replanning_is_distinct_from_implemented_baseline(self):
        canon = json.loads((ROOT / "docs/current-planning-canon.json").read_text(encoding="utf-8"))
        review = canon["replanning_review"]
        self.assertEqual(review["status"], "IN_PROGRESS")
        self.assertEqual(review["existing_images_for_new_production"], "REFERENCE_ONLY")
        self.assertEqual(review["runtime_replacement"], "NOT_RUN")
        self.assertEqual(review["human_qa"], "NOT_RUN")
        for key in ("research", "aseprite_boundary"):
            self.assertTrue((ROOT / review[key]).is_file())

    def test_active_routers_do_not_hide_replanning(self):
        for name in ("AGENTS.md", "START_HERE.md", "MVP_ROADMAP.md",
                     "docs/CURRENT_HANDOFF.md", "docs/CURRENT_PLANNING_CANON.md",
                     "docs/CURRENT_DECISION_OVERLAY.md"):
            text = (ROOT / name).read_text(encoding="utf-8")
            with self.subTest(name=name):
                self.assertIn("replanning_review", text[:2500])

    def test_research_preserves_evidence_ceiling(self):
        text = (ROOT / "docs/research/2026-09-10-replanning-element-review.md").read_text(encoding="utf-8")
        for marker in ("NOT_FINAL_DESIGN", "공개 세션 개요", "SWOT", "독창성", "trade-off", "runtime"):
            self.assertIn(marker, text)


if __name__ == "__main__":
    unittest.main()
