from __future__ import annotations

import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
GDD = ROOT / "docs/design/PROJECT_AI_PRODUCTION_SPEC.md"


class MasterGddCoreSystemCoverageTests(unittest.TestCase):
    """The human-facing GDD must explain the actual playable core, not just name it."""

    @classmethod
    def setUpClass(cls) -> None:
        cls.text = GDD.read_text(encoding="utf-8")

    def test_each_core_player_system_has_a_dedicated_explanation(self) -> None:
        required_sections = (
            "## 07. 10-day schedule system",
            "## 08. Investigation phase",
            "## 09. Keyword and anomaly-manual system",
            "## 10. Rescue and recovery phase",
        )
        for section in required_sections:
            self.assertIn(section, self.text)

    def test_schedule_truth_distinguishes_product_contract_from_runtime(self) -> None:
        for statement in (
            "exactly one main case per cycle",
            "Day 1–9",
            "Day 10",
            "current runtime does not enforce the one-main-case limit",
        ):
            self.assertIn(statement, self.text)

    def test_keyword_truth_never_promotes_a_design_only_system(self) -> None:
        for statement in (
            "candidate_keywords",
            "APPROVED_DESIGN / NOT_IMPLEMENTED",
            "no player-facing keyword-composition consumer",
        ):
            self.assertIn(statement, self.text)

    def test_recovery_explains_the_evidence_to_action_chain(self) -> None:
        for statement in (
            "telegraph → hypothesis → evidence → response",
            "not HP depletion",
            "wrong-response learning",
        ):
            self.assertIn(statement, self.text)


if __name__ == "__main__":
    unittest.main()
