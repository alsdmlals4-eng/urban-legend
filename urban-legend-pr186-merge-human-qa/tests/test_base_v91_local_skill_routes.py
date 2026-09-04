from __future__ import annotations

import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


def load(path: str) -> dict:
    return json.loads((ROOT / path).read_text(encoding="utf-8"))


class BaseV91LocalSkillRouteTests(unittest.TestCase):
    def test_project_discipline_view_preserves_every_active_local_skill(self) -> None:
        source = load("skills/SKILL_REGISTRY.json")["project_disciplines"]
        view = load("skills/PROJECT_LOCAL_SKILL_REGISTRY.json")
        self.assertEqual(view["source_registry"], "skills/SKILL_REGISTRY.json")
        self.assertEqual(view["source_section"], "project_disciplines")
        self.assertEqual(
            {(item["skill_id"], item["path"], item["status"]) for item in view["skills"]},
            {(item["skill_id"], item["path"], item["status"]) for item in source},
        )
        for item in view["skills"]:
            self.assertTrue((ROOT / item["path"]).is_file(), item["path"])

    def test_generated_snapshot_keeps_ten_project_local_routes(self) -> None:
        snapshot = load("skills/PROJECT_SKILL_SNAPSHOT.json")
        routes = snapshot["project_routes"]
        self.assertEqual(len(routes), 10)
        self.assertEqual({route["route_id"] for route in routes}, {
            item["skill_id"] for item in load("skills/PROJECT_LOCAL_SKILL_REGISTRY.json")["skills"]
        })
        self.assertTrue(all(route["status"] == "ACTIVE" for route in routes))


if __name__ == "__main__":
    unittest.main()
