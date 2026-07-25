from __future__ import annotations

import json
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DATA_PATH = ROOT / "data/poc/annual_mvp_001/spring_vertical_slice.json"


class AnnualMvp001DataContractTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.data = json.loads(DATA_PATH.read_text(encoding="utf-8"))

    def test_campaign_shape(self) -> None:
        self.assertEqual("annual-mvp-001-v3", self.data["contract_version"])
        campaign = self.data["campaign"]
        self.assertEqual(4, campaign["max_weeks"])
        self.assertEqual(7, campaign["days_per_week"])
        self.assertEqual(5, campaign["auto_rest_fatigue_recovery_per_day"])
        self.assertNotIn("slots_per_week", campaign)
        self.assertEqual(2, campaign["voluntary_entry_week"])
        self.assertEqual(4, campaign["deadline_week"])
        self.assertEqual(15, campaign["week_3_entry_risk"])
        self.assertEqual(30, campaign["forced_entry_risk"])
        self.assertEqual(28, campaign["max_weeks"] * campaign["days_per_week"])

    def test_activity_day_costs_and_rest_contract(self) -> None:
        costs = {entry["id"]: entry["day_cost"] for entry in self.data["activities"]}
        self.assertEqual(
            {
                "annual001_activity_observation_drill": 2,
                "annual001_activity_analysis_desk": 2,
                "annual001_activity_field_training": 3,
                "annual001_activity_interview_duty": 2,
                "annual001_activity_signal_research": 3,
                "annual001_activity_companion_drill": 2,
                "annual001_activity_rest": 1,
            },
            costs,
        )
        self.assertTrue(all(1 <= value <= 3 for value in costs.values()))
        rest = next(entry for entry in self.data["activities"] if entry["id"] == "annual001_activity_rest")
        self.assertEqual("direct", rest["rest_mode"])
        self.assertTrue(rest["status_recovery_eligible"])
        self.assertEqual(-25, rest["deltas"]["fatigue"])

    def test_fixed_counts(self) -> None:
        self.assertEqual(7, len(self.data["activities"]))
        self.assertEqual(1, len(self.data["companions"]))
        self.assertEqual(3, len(self.data["support_skills"]))
        self.assertEqual(1, len(self.data["base_equipment"]))
        self.assertEqual(1, len(self.data["modules"]))
        self.assertEqual(2, len(self.data["research_projects"]))

    def test_ids_and_references(self) -> None:
        groups = (
            "activities",
            "companions",
            "support_skills",
            "base_equipment",
            "modules",
            "research_projects",
        )
        ids = [entry["id"] for group in groups for entry in self.data[group]]
        self.assertEqual(len(ids), len(set(ids)))
        self.assertTrue(all(value.startswith("annual001_") for value in ids))

        skills = {entry["id"] for entry in self.data["support_skills"]}
        modules = {entry["id"] for entry in self.data["modules"]}
        companion = self.data["companions"][0]
        self.assertIn(companion["unique_skill_id"], skills)
        for skill_id in companion["allowed_public_skill_ids"]:
            self.assertIn(skill_id, skills)
        for project in self.data["research_projects"]:
            for module_id in project.get("unlock_module_ids", []):
                self.assertIn(module_id, modules)
            for skill_id in project.get("unlock_skill_ids", []):
                self.assertIn(skill_id, skills)


if __name__ == "__main__":
    unittest.main()
