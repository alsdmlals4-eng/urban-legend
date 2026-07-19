"""Regression contract for the Base-derived Urban Legend operating system."""

from __future__ import annotations

import json
import subprocess
import sys
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
HUB = ROOT / "[기획서]" / "00_프로젝트_허브"
FOUNDATIONS = {
    "routing-project-work-by-discipline",
    "conducting-deep-requirement-interviews",
    "migrating-existing-game-project-structure",
    "maintaining-project-context-and-handoff",
    "evolving-project-discipline-skills",
    "transforming-requests-into-prompts",
    "publishing-discipline-bibles",
    "verifying-game-project-operating-system",
}


class BaseSyncContractTests(unittest.TestCase):
    def test_project_checker_accepts_required_foundation_skills(self) -> None:
        result = subprocess.run(
            [sys.executable, "tools/check_project_operating_system.py"],
            cwd=ROOT,
            check=False,
            capture_output=True,
            text=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

    def test_selected_foundation_skills_are_registered_and_present(self) -> None:
        registry = json.loads((HUB / "SKILL_REGISTRY.json").read_text(encoding="utf-8"))
        registered = {
            entry["skill_id"]
            for entry in registry["skills"]
            if entry.get("layer") == "foundation" and entry.get("status") == "ACTIVE"
        }
        self.assertTrue(FOUNDATIONS.issubset(registered))
        for skill_id in FOUNDATIONS:
            self.assertTrue((ROOT / "skills" / "foundations" / skill_id / "SKILL.md").is_file())

    def test_interview_and_governance_entrypoints_exist(self) -> None:
        required = [
            HUB / "INTERVIEW_REGISTRY.json",
            HUB / "AI_WORKFLOW.md",
            HUB / "HANDOFF.md",
            HUB / "ROADMAP.md",
            HUB / "DECISION_LOG.md",
            HUB / "CHANGELOG.md",
            ROOT / ".github" / "documentation-governance.json",
            ROOT / ".github" / "workflows" / "documentation-governance.yml",
            ROOT / "tools" / "check_documentation_governance.py",
            ROOT / "tools" / "check_skill_routing_governance.py",
            ROOT / "tools" / "check_design_document_publications.py",
            ROOT / "tools" / "check_interview_contract.py",
            ROOT / "tools" / "check_publication_environment.py",
        ]
        self.assertEqual([path for path in required if not path.is_file()], [])

    def test_existing_game_paths_remain_outside_governance_change_rules(self) -> None:
        config_path = ROOT / ".github" / "documentation-governance.json"
        self.assertTrue(config_path.is_file())
        config = json.loads(config_path.read_text(encoding="utf-8"))
        all_globs = [glob for rule in config["change_rules"] for glob in rule["source_globs"]]
        self.assertNotIn("scripts/**", all_globs)
        self.assertNotIn("scenes/**", all_globs)
        self.assertNotIn("data/**", all_globs)
        self.assertNotIn("assets/**", all_globs)


if __name__ == "__main__":
    unittest.main()
