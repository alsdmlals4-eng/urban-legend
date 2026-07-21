from __future__ import annotations

import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
BASE_COMMIT = "ee265576da7f67d3278f8099dd97d4e714ef0651"
REQUIRED_BASE_SKILLS = {
    "managing-project-intake-and-work-contract",
    "managing-game-project-operating-system",
    "managing-design-documents",
    "evolving-project-discipline-skills",
    "maintaining-project-context-and-handoff",
    "analyzing-and-refining-game-concepts",
    "designing-vertical-slices",
    "orchestrating-deepseek-worktrees",
    "reviewing-and-validating-project-changes",
    "auditing-canonical-reference-freshness",
    "designing-art-prompts-and-technique-cards",
    "auditing-and-refining-ui-art",
    "managing-base-change-proposals",
}
LEGACY_ACTIVE_IDS = {
    "routing-project-work-by-discipline",
    "conducting-deep-requirement-interviews",
    "transforming-requests-into-prompts",
    "installing-game-project-operating-system",
    "migrating-existing-game-project-structure",
    "verifying-game-project-operating-system",
    "writing-game-design-documents",
    "publishing-discipline-bibles",
    "promoting-project-knowledge",
    "reviewing-and-implementing-base-change-proposals",
    "reviewing-external-ai-drafts",
}


class BaseOperatingSyncTests(unittest.TestCase):
    def setUp(self) -> None:
        self.registry_path = ROOT / "skills/SKILL_REGISTRY.json"
        self.registry = json.loads(self.registry_path.read_text(encoding="utf-8"))

    def test_cold_start_entrypoints_exist(self) -> None:
        required = [
            "START_HERE.md",
            "AGENTS.md",
            "docs/OPERATING_MODEL.md",
            "docs/WORK_MODE_AND_SKILL_ROUTING.md",
            "docs/CURRENT_STATUS.md",
            "docs/DOCUMENTATION_MAP.md",
            "docs/BASE_RULES_VERSION.md",
            "skills/SKILL_REGISTRY.json",
            "skills/LEGACY_SKILL_ALIASES.md",
            "skills/SKILL_LEARNING_LOG.md",
        ]
        missing = [path for path in required if not (ROOT / path).is_file()]
        self.assertEqual(missing, [], f"Missing cold-start files: {missing}")

    def test_base_commit_is_pinned_consistently(self) -> None:
        files = [
            "START_HERE.md",
            "docs/OPERATING_MODEL.md",
            "docs/WORK_MODE_AND_SKILL_ROUTING.md",
            "docs/BASE_RULES_VERSION.md",
            "skills/SKILL_REGISTRY.json",
            "skills/SKILL_LEARNING_LOG.md",
        ]
        missing = [
            path for path in files
            if BASE_COMMIT not in (ROOT / path).read_text(encoding="utf-8")
        ]
        self.assertEqual(missing, [], f"Base commit mismatch: {missing}")
        self.assertEqual(self.registry["base"]["commit"], BASE_COMMIT)

    def test_automatic_routing_contract(self) -> None:
        policy = self.registry["routing_policy"]
        self.assertFalse(policy["load_all_skills"])
        self.assertEqual(policy["default_selection"], "automatic-trigger-match")
        self.assertTrue(policy["automatic_selection"])
        self.assertFalse(policy["user_skill_declaration_required"])
        self.assertTrue(policy["require_trigger_match"])
        self.assertTrue(policy["require_execution_report"])
        self.assertEqual(policy["work_modes"], ["PLAN", "BUILD", "REVIEW"])
        self.assertEqual(policy["max_primary_discipline_skills"], 1)
        self.assertLessEqual(policy["max_foundation_skills"], 3)

    def test_current_base_skill_set_is_complete(self) -> None:
        skills = self.registry["base_skills"]
        ids = {item["skill_id"] for item in skills}
        self.assertEqual(ids, REQUIRED_BASE_SKILLS)
        self.assertEqual(len(skills), len(ids), "Duplicate Base skill IDs")
        for item in skills:
            self.assertEqual(item["status"], "ACTIVE")
            self.assertFalse(item["load_by_default"])
            self.assertTrue(item["trigger_tags"])
            self.assertTrue(item["base_path"].startswith("skills/"))
            self.assertTrue(item["base_path"].endswith("/SKILL.md"))

    def test_legacy_ids_are_not_active(self) -> None:
        ids = {item["skill_id"] for item in self.registry["base_skills"]}
        self.assertFalse(ids & LEGACY_ACTIVE_IDS)
        aliases = (ROOT / "skills/LEGACY_SKILL_ALIASES.md").read_text(encoding="utf-8")
        for legacy_id in LEGACY_ACTIVE_IDS:
            self.assertIn(legacy_id, aliases)

    def test_project_canonical_sources_are_preserved(self) -> None:
        missing: list[str] = []
        for discipline in self.registry["project_disciplines"]:
            self.assertEqual(discipline["status"], "ACTIVE")
            self.assertFalse(discipline["load_by_default"])
            self.assertTrue(discipline["trigger_tags"])
            for raw_path in discipline["canonical_sources"]:
                if not (ROOT / raw_path).exists():
                    missing.append(f"{discipline['skill_id']} -> {raw_path}")
        self.assertEqual(missing, [], "Missing project canonical sources:\n" + "\n".join(missing))

    def test_project_invariants_remain_in_agents(self) -> None:
        agents = (ROOT / "AGENTS.md").read_text(encoding="utf-8")
        for term in ("괴이 기록국", "안정화 상태", "위험 사례", "잔향", "괴이 매뉴얼", "기록관 아카"):
            self.assertIn(term, agents)
        for protected in ("scripts/core/game_state.gd", "data/episodes", "project.godot", "knowledge/base-pack"):
            self.assertIn(protected, agents)

    def test_legacy_local_copies_route_to_current_contract(self) -> None:
        shared = (ROOT / "docs/AI_SHARED_WORK_RULES.md").read_text(encoding="utf-8")
        workflow = (ROOT / "docs/AI_WORKFLOW_RULES.md").read_text(encoding="utf-8")
        self.assertIn("COMPATIBILITY_STUB", shared)
        self.assertIn("docs/OPERATING_MODEL.md", shared)
        self.assertIn("docs/WORK_MODE_AND_SKILL_ROUTING.md", workflow)

    def test_non_destructive_project_paths_remain(self) -> None:
        required = [
            "docs/CURRENT_STATUS.md",
            "docs/planning/README.md",
            "docs/planning/PROJECT_DIRECTION.md",
            "docs/planning/NARRATIVE_CONTENT_PLAN.md",
            "docs/planning/ART_PRESENTATION_PLAN.md",
            "docs/GAME_DESIGN_DOCUMENT.md",
            "MVP_ROADMAP.md",
            "TEST_CHECKLIST.md",
        ]
        missing = [path for path in required if not (ROOT / path).is_file()]
        self.assertEqual(missing, [], f"Current canonical paths moved or removed: {missing}")


if __name__ == "__main__":
    unittest.main()
