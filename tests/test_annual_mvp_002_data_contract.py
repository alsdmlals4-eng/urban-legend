from __future__ import annotations

import json
import unittest
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
BASE_DATA_PATH = ROOT / "data/poc/annual_mvp_001/spring_vertical_slice.json"
DATA_PATH = ROOT / "data/poc/annual_mvp_002/companion_equipment_research.json"
FORBIDDEN_EFFECT_KEYS = {
    "clue_id",
    "hypothesis_id",
    "pattern_id",
    "capture_condition",
    "answer",
    "auto_solution",
    "new_core_clue",
    "answer_hypothesis",
    "unobserved_pattern",
}


class AnnualMvp002DataContractTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.base_data = json.loads(BASE_DATA_PATH.read_text(encoding="utf-8"))
        cls.data = json.loads(DATA_PATH.read_text(encoding="utf-8"))

    def test_contract_and_fixed_counts(self) -> None:
        self.assertEqual("annual-mvp-002-v1", self.data["contract_version"])
        self.assertEqual(self.base_data["contract_version"], self.data["base_contract_version"])
        self.assertEqual(3, len(self.data["companions"]))
        self.assertEqual(3, len(self.data["unique_skills"]))
        self.assertEqual(6, len(self.data["support_skills"]))
        self.assertEqual(3, len(self.data["equipment"]))
        self.assertEqual(6, len(self.data["modules"]))
        self.assertEqual(4, len(self.data["research_resources"]))
        self.assertEqual(8, len(self.data["research_nodes"]))

    def test_ids_are_unique_and_namespaced(self) -> None:
        groups = (
            "companions",
            "unique_skills",
            "support_skills",
            "equipment",
            "modules",
            "research_resources",
            "research_nodes",
        )
        ids = [entry["id"] for group in groups for entry in self.data[group]]
        self.assertEqual(len(ids), len(set(ids)))
        self.assertTrue(all(value.startswith("annual002_") for value in ids))
        base_ids = {
            entry["id"]
            for group in (
                "activities",
                "companions",
                "support_skills",
                "base_equipment",
                "modules",
                "research_projects",
            )
            for entry in self.base_data[group]
        }
        self.assertTrue(base_ids.isdisjoint(ids))

    def test_companion_and_skill_references(self) -> None:
        unique_skills = {entry["id"] for entry in self.data["unique_skills"]}
        support_skills = {entry["id"] for entry in self.data["support_skills"]}
        owners = [entry["owner_companion_id"] for entry in self.data["unique_skills"]]
        companion_ids = {entry["id"] for entry in self.data["companions"]}
        self.assertEqual(len(owners), len(set(owners)))
        self.assertEqual(companion_ids, set(owners))
        for companion in self.data["companions"]:
            self.assertIn(companion["unique_skill_id"], unique_skills)
            self.assertLessEqual(len(companion["public_skill_ids"]), 2)
            for skill_id in companion["public_skill_ids"]:
                self.assertIn(skill_id, support_skills)
            self.assertIn(companion["availability"], {"AVAILABLE", "UNAVAILABLE"})
            self.assertGreaterEqual(companion["work_trust"], 0)
            self.assertLessEqual(companion["work_trust"], 100)
            self.assertGreaterEqual(companion["personal_bond"], 0)
            self.assertLessEqual(companion["personal_bond"], 100)

    def test_support_probability_and_readiness_contract(self) -> None:
        for skill in self.data["support_skills"]:
            self.assertGreaterEqual(skill["base_chance"], 0)
            self.assertLessEqual(skill["base_chance"], 90)
            self.assertEqual(20, skill["readiness_gain"])
            self.assertEqual(100, skill["readiness_guarantee"])
            self.assertIn("effect_category", skill)
            self.assertIn("trigger", skill)
            self.assertIn("trigger_label", skill)
        for skill in self.data["unique_skills"]:
            self.assertEqual(1, skill["incident_limit"])
            self.assertIn("effect_category", skill)
            self.assertIn("trigger", skill)

    def test_equipment_modules_match_family_and_slots(self) -> None:
        equipment = {entry["id"]: entry for entry in self.data["equipment"]}
        module_ids = {entry["id"] for entry in self.data["modules"]}
        self.assertEqual({"observation", "protection", "containment"}, {entry["family"] for entry in equipment.values()})
        for entry in equipment.values():
            self.assertIn(entry["module_slots"], {1, 2})
            self.assertEqual(2, len(entry["allowed_module_ids"]))
            for module_id in entry["allowed_module_ids"]:
                self.assertIn(module_id, module_ids)
        for module in self.data["modules"]:
            compatible = [entry for entry in equipment.values() if module["id"] in entry["allowed_module_ids"]]
            self.assertEqual(1, len(compatible))
            self.assertEqual(module["family"], compatible[0]["family"])

    def test_research_graph_is_acyclic_and_costs_non_negative(self) -> None:
        nodes = {entry["id"]: entry for entry in self.data["research_nodes"]}
        resources = {entry["id"] for entry in self.data["research_resources"]}
        for node in nodes.values():
            self.assertGreaterEqual(node["progress_required"], 1)
            for resource_id, value in node["resource_cost"].items():
                self.assertIn(resource_id, resources)
                self.assertGreaterEqual(value, 0)
            for prerequisite_id in node["prerequisite_ids"]:
                self.assertIn(prerequisite_id, nodes)

        visiting: set[str] = set()
        visited: set[str] = set()

        def visit(node_id: str) -> None:
            if node_id in visiting:
                self.fail(f"research prerequisite cycle detected at {node_id}")
            if node_id in visited:
                return
            visiting.add(node_id)
            for prerequisite_id in nodes[node_id]["prerequisite_ids"]:
                visit(prerequisite_id)
            visiting.remove(node_id)
            visited.add(node_id)

        for node_id in nodes:
            visit(node_id)

    def test_effects_cannot_encode_core_answers(self) -> None:
        def walk(value: Any) -> None:
            if isinstance(value, dict):
                self.assertTrue(FORBIDDEN_EFFECT_KEYS.isdisjoint(value.keys()), value)
                for nested in value.values():
                    walk(nested)
            elif isinstance(value, list):
                for nested in value:
                    walk(nested)

        walk(self.data)

    def test_fixed_base_contract_is_unchanged(self) -> None:
        self.assertEqual("annual-mvp-001-v3", self.base_data["contract_version"])
        campaign = self.base_data["campaign"]
        self.assertEqual(4, campaign["max_weeks"])
        self.assertEqual(7, campaign["days_per_week"])
        self.assertEqual(15, campaign["week_3_entry_risk"])
        self.assertEqual(30, campaign["forced_entry_risk"])


if __name__ == "__main__":
    unittest.main()
