from __future__ import annotations

import json
import unittest
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
CASE_PATH = ROOT / "data/poc/core_mvp_001/afterlife_station_poc.json"

FIXED_IDS = {
    "scenes": {
        "poc001_scene_broadcast_archive",
        "poc001_scene_platform_display",
        "poc001_scene_ticket_gate",
    },
    "clues": {
        "poc001_clue_broadcast_blank",
        "poc001_clue_reset_timing",
        "poc001_clue_official_identifier",
        "poc001_clue_display_mismatch",
        "poc001_clue_passenger_count",
        "poc001_question_ticket_trigger",
    },
    "choices": {
        "poc001_choice_move_before_end",
        "poc001_choice_follow_passenger_count",
        "poc001_choice_follow_display",
        "poc001_choice_hold_official_signal",
    },
    "hypotheses": {
        "poc001_hypothesis_display_route",
        "poc001_hypothesis_broadcast_blank",
    },
    "patterns": {
        "poc001_pattern_false_terminal",
        "poc001_pattern_boundary_fold",
        "poc001_pattern_ticket_imprint",
    },
}


class CoreMvp001DataContractTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.data = json.loads(CASE_PATH.read_text(encoding="utf-8"))

    def test_contract_version_and_scope(self) -> None:
        data = self.data
        self.assertEqual("core-mvp-001-v1", data["contract_version"])
        self.assertEqual(3, len(data["investigation_scenes"]))
        self.assertEqual(6, len(data["clues"]))
        self.assertEqual(4, len(data["choices"]))
        self.assertEqual(2, len(data["hypotheses"]))
        self.assertEqual(3, len(data["recovery_patterns"]))
        self.assertEqual(3, len(data["manual_records"]))

    def test_fixed_ids_are_exact_and_unique(self) -> None:
        sections = {
            "scenes": "investigation_scenes",
            "clues": "clues",
            "choices": "choices",
            "hypotheses": "hypotheses",
            "patterns": "recovery_patterns",
        }
        seen: set[str] = set()
        for label, key in sections.items():
            ids = {str(entry["id"]) for entry in self.data[key]}
            self.assertEqual(FIXED_IDS[label], ids, label)
            for entry_id in ids:
                self.assertTrue(entry_id.startswith("poc001_"), entry_id)
                self.assertNotIn(entry_id, seen, entry_id)
                seen.add(entry_id)

        for key in (
            "manual_records",
            "elimination_rules",
            "field_tests",
            "recovery_actions",
            "outcomes",
        ):
            for entry in self.data[key]:
                entry_id = str(entry["id"])
                self.assertTrue(entry_id.startswith("poc001_"), entry_id)
                self.assertNotIn(entry_id, seen, entry_id)
                seen.add(entry_id)

    def test_clue_roles_and_elimination_count(self) -> None:
        roles = [str(clue["role"]) for clue in self.data["clues"]]
        self.assertEqual(3, roles.count("support"))
        self.assertEqual(2, roles.count("contradiction"))
        self.assertEqual(1, roles.count("unresolved"))

        eliminated = {str(rule["choice_id"]) for rule in self.data["elimination_rules"]}
        self.assertEqual(
            {
                "poc001_choice_move_before_end",
                "poc001_choice_follow_passenger_count",
            },
            eliminated,
        )

    def test_all_local_references_resolve(self) -> None:
        ids = self._all_ids(self.data)
        reference_fields = {
            "scene_id",
            "clue_id",
            "record_id",
            "choice_id",
            "hypothesis_id",
            "field_test_id",
            "pattern_id",
            "action_id",
            "outcome_id",
            "capture_mark",
        }
        reference_list_fields = {
            "clue_ids",
            "required_supporting_clue_ids",
            "required_contradiction_clue_ids",
            "unresolved_question_ids",
            "generic_mitigation_action_ids",
            "valid_action_ids",
            "valid_action_ids_after_observation",
        }
        capture_marks = set(self.data["capture_rule"]["required_capture_marks"])

        def walk(value: Any) -> None:
            if isinstance(value, dict):
                for key, child in value.items():
                    if key in reference_fields and isinstance(child, str):
                        if key == "capture_mark":
                            self.assertIn(child, capture_marks, f"{key}={child}")
                        else:
                            self.assertIn(child, ids, f"{key}={child}")
                    elif key in reference_list_fields:
                        for item in child:
                            self.assertIn(str(item), ids, f"{key}={item}")
                    walk(child)
            elif isinstance(value, list):
                for child in value:
                    walk(child)

        walk(self.data)

    def test_hidden_pattern_and_capture_contract(self) -> None:
        patterns = self.data["recovery_patterns"]
        hidden = [pattern for pattern in patterns if pattern.get("first_use_hidden")]
        self.assertEqual(1, len(hidden))
        self.assertEqual("poc001_pattern_ticket_imprint", hidden[0]["id"])
        self.assertGreaterEqual(len(hidden[0]["generic_mitigation_action_ids"]), 1)
        self.assertEqual(18, hidden[0]["max_first_observation_damage"])

        sequence = self.data["recovery_sequence"]
        self.assertEqual(5, len(sequence))
        self.assertEqual("poc001_pattern_ticket_imprint", sequence[2])
        self.assertEqual("poc001_pattern_ticket_imprint", sequence[4])

        capture = self.data["capture_rule"]
        self.assertEqual(3, len(capture["required_capture_marks"]))
        self.assertEqual(5, capture["min_capture_turn"])
        self.assertEqual(8, capture["max_recovery_turn"])

    def test_enemy_hp_is_not_part_of_the_contract(self) -> None:
        serialized = json.dumps(self.data, ensure_ascii=False)
        self.assertNotIn("enemy_hp", serialized)

    @staticmethod
    def _all_ids(data: dict[str, Any]) -> set[str]:
        ids: set[str] = set()
        for key, value in data.items():
            if not isinstance(value, list):
                continue
            for entry in value:
                if isinstance(entry, dict) and isinstance(entry.get("id"), str):
                    ids.add(entry["id"])
        return ids


if __name__ == "__main__":
    unittest.main()
