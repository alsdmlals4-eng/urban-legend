import json
import re
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
BASE_EPISODE_PATH = ROOT / "data/episodes/episode_001_afterlife_station.json"
OVERLAY_PATH = ROOT / "data/episodes/episode_001_afterlife_station_core_validation.json"
LOADER_PATH = ROOT / "scripts/data/episode_loader.gd"
GAME_STATE_PATH = ROOT / "scripts/core/game_state.gd"


class CoreValidationContractTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.base_episode = json.loads(BASE_EPISODE_PATH.read_text(encoding="utf-8"))
        cls.overlay = json.loads(OVERLAY_PATH.read_text(encoding="utf-8"))
        cls.overrides = cls.overlay["overrides"]
        cls.base_patterns = cls.base_episode["recovery_patterns"]
        cls.overlay_patterns = cls.overrides["recovery_patterns"]

    def test_overlay_targets_only_afterlife_station(self) -> None:
        self.assertEqual(
            self.overlay["target_episode_id"],
            self.base_episode["episode"]["id"],
        )
        self.assertEqual(self.overlay["contract_version"], "core-validation-001")
        self.assertEqual(set(self.overrides), {"recovery_patterns"})

    def test_overlay_preserves_pattern_and_response_behavior(self) -> None:
        base_by_id = {pattern["id"]: pattern for pattern in self.base_patterns}
        overlay_by_id = {pattern["id"]: pattern for pattern in self.overlay_patterns}
        self.assertEqual(list(base_by_id), list(overlay_by_id))

        for pattern_id, base_pattern in base_by_id.items():
            overlay_pattern = overlay_by_id[pattern_id]
            for key in ("id", "order", "telegraph", "related_clue_ids", "correct_response_id"):
                self.assertEqual(
                    overlay_pattern[key],
                    base_pattern[key],
                    f"{pattern_id} changed protected behavior field {key}",
                )

            base_responses = {response["id"]: response for response in base_pattern["responses"]}
            overlay_responses = {response["id"]: response for response in overlay_pattern["responses"]}
            self.assertEqual(list(base_responses), list(overlay_responses))
            for response_id, base_response in base_responses.items():
                overlay_response = overlay_responses[response_id]
                self.assertEqual(overlay_response["ability"], base_response["ability"])
                self.assertEqual(
                    overlay_response.get("stability_gain", 15),
                    base_response.get("stability_gain", 15),
                )

    def test_each_pattern_exposes_a_neutral_question_and_manual_draft(self) -> None:
        for pattern in self.overlay_patterns:
            self.assertTrue(pattern["question"].strip())
            self.assertTrue(pattern["manual_draft"].strip())
            self.assertTrue(pattern["description"].strip())
            self.assertNotIn(
                pattern["correct_response_id"],
                pattern["description"],
                f"{pattern['id']} prediction description leaked the response id",
            )

    def test_each_response_has_hypothesis_evidence_and_reasoning(self) -> None:
        for pattern in self.overlay_patterns:
            related_clues = set(pattern["related_clue_ids"])
            hypotheses = set()
            for response in pattern["responses"]:
                for key in (
                    "hypothesis",
                    "supporting_clue_ids",
                    "contradicted_clue_ids",
                    "reasoning",
                    "summary",
                ):
                    self.assertIn(key, response, f"{pattern['id']}:{response['id']} missing {key}")

                hypothesis = response["hypothesis"].strip()
                self.assertTrue(hypothesis)
                self.assertNotIn(hypothesis, hypotheses)
                hypotheses.add(hypothesis)

                supporting = set(response["supporting_clue_ids"])
                contradicted = set(response["contradicted_clue_ids"])
                self.assertTrue(supporting <= related_clues)
                self.assertTrue(contradicted <= related_clues)
                self.assertFalse(supporting & contradicted)
                self.assertTrue(response["reasoning"].strip())
                self.assertTrue(response["summary"].strip())

                if response["id"] == pattern["correct_response_id"]:
                    self.assertEqual(
                        supporting,
                        related_clues,
                        f"{pattern['id']} correct hypothesis must cite all authored related clues",
                    )
                    self.assertFalse(contradicted)
                else:
                    self.assertTrue(
                        contradicted,
                        f"{pattern['id']}:{response['id']} wrong hypothesis needs visible counterevidence",
                    )

    def test_overlay_loader_is_optional_and_target_checked(self) -> None:
        source = LOADER_PATH.read_text(encoding="utf-8")
        required_fragments = (
            'CORE_VALIDATION_OVERLAY_SUFFIX := "_core_validation.json"',
            "if not FileAccess.file_exists(overlay_path):",
            'target_episode_id != episode_id',
            'var overrides: Variant = overlay.get("overrides", {})',
            "var merged := base_data.duplicate(true)",
        )
        for fragment in required_fragments:
            self.assertIn(fragment, source)

    def test_save_schema_and_protected_recovery_ids_remain_unchanged(self) -> None:
        game_state_source = GAME_STATE_PATH.read_text(encoding="utf-8")
        self.assertRegex(game_state_source, re.compile(r'const SAVE_VERSION := "mvp-039"'))
        self.assertEqual(
            {pattern["correct_response_id"] for pattern in self.base_patterns},
            {pattern["correct_response_id"] for pattern in self.overlay_patterns},
        )


if __name__ == "__main__":
    unittest.main()
