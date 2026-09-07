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

    def test_schedule_truth_reports_the_verified_runtime_consumer(self) -> None:
        for statement in (
            "exactly one main case per cycle",
            "Day 1–9",
            "Day 10",
            "cycle main case lock",
            "IMPLEMENTED / FOCUSED_MACHINE_VERIFIED",
        ):
            self.assertIn(statement, self.text)
        self.assertNotIn("current runtime does not enforce the one-main-case limit", self.text)

    def test_keyword_truth_reports_the_m01_m04_player_authored_slice(self) -> None:
        for statement in (
            "candidate_keywords",
            "IMPLEMENTED_M01_M04",
            "player-facing keyword-composition consumer",
            "draft-only",
        ):
            self.assertIn(statement, self.text)
        self.assertNotIn("no player-facing keyword-composition consumer", self.text)

    def test_m04_vignette_status_is_not_left_at_the_preimplementation_state(self) -> None:
        self.assertIn("M04 sequential narrative vignettes", self.text)
        self.assertIn("IMPLEMENTED / FOCUSED_MACHINE_VERIFIED", self.text)
        self.assertNotIn("M04 vignette successor `NOT_IMPLEMENTED`", self.text)

    def test_m07_runtime_readback_is_not_left_as_unevaluated(self) -> None:
        for statement in (
            "CNT-M07",
            "episode_003_dead_frequency_station.json",
            "MVP-040 dead frequency slice: 20 passed, 0 failed",
            "IMPLEMENTED / RUNTIME_VERIFIED / HUMAN_QA_NOT_RUN",
        ):
            self.assertIn(statement, self.text)
        self.assertNotIn("PARTIAL / not evaluated this session", self.text)

    def test_keyword_flow_is_player_authored_and_never_an_answer_checker(self) -> None:
        for statement in (
            "readable inference sentences with blank keyword slots",
            "investigation memory, provenance",
            "semantic correct/wrong",
            "rescue minigame and field recovery",
            "normal-clear answer reveal",
        ):
            self.assertIn(statement, self.text)

    def test_recovery_explains_the_evidence_to_action_chain(self) -> None:
        for statement in (
            "telegraph → hypothesis → evidence → response",
            "not HP depletion",
            "wrong-response learning",
        ):
            self.assertIn(statement, self.text)

    def test_experience_hierarchy_keeps_calendar_as_support_not_primary_fun(self) -> None:
        for statement in (
            "Primary playable core",
            "investigation → deduction/manual → recovery",
            "Supporting campaign system",
            "not a separate primary fun loop",
        ):
            self.assertIn(statement, self.text)


if __name__ == "__main__":
    unittest.main()
