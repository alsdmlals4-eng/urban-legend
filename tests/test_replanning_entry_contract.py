import json
from pathlib import Path
import unittest


ROOT = Path(__file__).resolve().parents[1]


class ReplanningEntryContract(unittest.TestCase):
    def test_survival_core_distinguishes_belief_from_world_rules(self):
        canon = json.loads((ROOT / "docs/current-planning-canon.json").read_text(encoding="utf-8"))
        core = canon["replanning_review"]["survival_core"]
        self.assertEqual(core["status"], "USER_APPROVED_DIRECTION / RUNTIME_NOT_VERIFIED")
        self.assertEqual(core["manual_role"], "PLAYER_BELIEF_AND_REFERENCE_NOT_WORLD_TRUTH")
        self.assertIn("RECOVERY", core["application_surfaces"])
        self.assertIn("MINIGAME", core["application_surfaces"])
        self.assertIn("SAME_WORLD_AND_ACTION_SAME_OUTCOME_REGARDLESS_OF_NOTE", core["acceptance"])
        self.assertIn("RULE_INFORMED_ACTION_HAS_OBSERVABLE_CONSEQUENCE", core["acceptance"])
        self.assertTrue((ROOT / canon["replanning_review"]["consumer_audit"]).is_file())

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
