from __future__ import annotations

import json
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BASE_COMMIT = "41a20584dd2ee51d917e5c9d7cab6838e1ceba7e"
BASE_REGISTRY_BLOB = "14950c9361b3c939990560ae8cc683a936633e89"
OLD_BASE_COMMIT = "ee265576da7f67d3278f8099dd97d4e714ef0651"
REQUIRED_BASE_SKILLS = {'managing-game-project-operating-system', 'auditing-and-refining-ui-art', 'orchestrating-deepseek-worktrees', 'reviewing-and-validating-project-changes', 'establishing-project-core', 'synchronizing-local-and-github-state', 'maintaining-project-context-and-handoff', 'governing-game-user-research-coverage', 'designing-art-prompts-and-technique-cards', 'pruning-stale-and-nonfunctional-material', 'designing-vertical-slices', 'diagnosing-game-engine-runtime-failures', 'managing-base-change-proposals', 'evolving-project-discipline-skills', 'simplifying-skill-bodies', 'managing-design-documents', 'building-project-visual-dashboards', 'running-adversarial-review-and-refinement', 'managing-project-intake-and-work-contract', 'maintaining-long-running-task-continuity', 'identifying-project-core', 'auditing-canonical-reference-freshness', 'analyzing-and-refining-game-concepts', 'creating-user-learning-notes', 'refactoring-with-contract-preservation'}
REQUIRED_ADAPTER_ROLES = {'skill_registry', 'skill_learning_log', 'project_discipline_skill_root', 'project_discipline_contract', 'base_sync_audit', 'operating_model', 'project_agents', 'base_version', 'legacy_skill_aliases', 'work_mode_and_skill_routing', 'project_core', 'game_design_source', 'project_start_here', 'project_context', 'base_skill_coverage', 'active_context', 'roadmap', 'design_document_registry_equivalent', 'documentation_map', 'base_skill_index', 'validation_contract', 'game_design_generator', 'game_design_docx_derivative', 'handoff'}


def load(path: str) -> dict:
    return json.loads((ROOT / path).read_text(encoding="utf-8"))


class BaseOperatingSyncTests(unittest.TestCase):
    def setUp(self) -> None:
        self.registry = load("skills/SKILL_REGISTRY.json")
        self.index = load("skills/BASE_SKILL_INDEX.json")
        self.coverage = load("skills/BASE_SKILL_COVERAGE.json")
        self.adapter = load("skills/PROJECT_PATH_ADAPTER.json")

    def test_cold_start_and_new_contracts_exist(self) -> None:
        required = [
            "START_HERE.md", "AGENTS.md", "docs/OPERATING_MODEL.md",
            "docs/WORK_MODE_AND_SKILL_ROUTING.md", "docs/CURRENT_STATUS.md",
            "docs/PROJECT_CORE.md", "docs/DOCUMENTATION_MAP.md",
            "docs/BASE_RULES_VERSION.md", "skills/SKILL_REGISTRY.json",
            "skills/BASE_SKILL_INDEX.json", "skills/BASE_SKILL_COVERAGE.json",
            "skills/PROJECT_PATH_ADAPTER.json",
            "skills/disciplines/PROJECT_DISCIPLINE_CONTRACT.md",
            "skills/LEGACY_SKILL_ALIASES.md", "skills/SKILL_LEARNING_LOG.md",
        ]
        self.assertEqual([p for p in required if not (ROOT / p).is_file()], [])

    def test_base_pin_has_one_human_authority_and_consistent_machine_sources(self) -> None:
        self.assertEqual(self.registry["base"]["commit"], BASE_COMMIT)
        self.assertEqual(self.registry["base"]["source_registry_blob_sha"], BASE_REGISTRY_BLOB)
        self.assertEqual(self.index["source"]["commit"], BASE_COMMIT)
        self.assertEqual(self.index["source"]["registry_blob_sha"], BASE_REGISTRY_BLOB)
        self.assertEqual(self.adapter["base"]["commit"], BASE_COMMIT)
        version = (ROOT / "docs/BASE_RULES_VERSION.md").read_text(encoding="utf-8")
        self.assertIn(BASE_COMMIT, version)
        active_docs = ["START_HERE.md", "README.md", "docs/OPERATING_MODEL.md", "docs/WORK_MODE_AND_SKILL_ROUTING.md", "docs/CURRENT_STATUS.md", "docs/DOCUMENTATION_MAP.md", "docs/MVP_WORKFLOW_CHECKLIST.md"]
        for path in active_docs:
            text = (ROOT / path).read_text(encoding="utf-8")
            self.assertNotIn(OLD_BASE_COMMIT, text, path)
            self.assertNotIn(BASE_COMMIT, text, f"Base pin duplicated outside authority: {path}")

    def test_latest_base_skill_set_and_coverage_are_complete(self) -> None:
        ids = {x["skill_id"] for x in self.index["skills"]}
        self.assertEqual(ids, REQUIRED_BASE_SKILLS)
        self.assertEqual(len(ids), 25)
        self.assertEqual(self.index["source"]["active_skill_count"], 25)
        self.assertFalse(self.registry["routing_policy"]["load_all_skills"])
        for item in self.index["skills"]:
            self.assertTrue(item["trigger_tags"])
            self.assertTrue(item["base_path"].endswith("/SKILL.md"))
        self.assertEqual(len(self.coverage["responsibilities"]), 18)
        for row in self.coverage["responsibilities"]:
            self.assertIn(row["status"], {"COVERED", "COVERED_EXISTING"})
            self.assertTrue(set(row["skills"]) <= ids, row)

    def test_project_core_is_identified_but_not_silently_confirmed(self) -> None:
        text = (ROOT / "docs/PROJECT_CORE.md").read_text(encoding="utf-8")
        self.assertIn("상태: `IDENTIFIED`", text)
        self.assertIn("아직 `CORE_CONFIRMED`", text)
        for term in ("괴이 기록국", "안정화 상태", "위험 사례", "잔향", "괴이 매뉴얼", "TECHNICAL_FOUNDATION", "REQUIRES_REAPPROVAL"):
            self.assertIn(term, text)

    def test_path_adapter_and_publication_compatibility(self) -> None:
        self.assertEqual(set(self.adapter["role_bindings"]), REQUIRED_ADAPTER_ROLES)
        for role, raw in self.adapter["role_bindings"].items():
            self.assertTrue((ROOT / raw).exists(), f"{role} -> {raw}")
        pub = self.adapter["publication_compatibility"]
        self.assertEqual(pub["base_v3_registry_migration"], "DEFERRED_REQUIRES_SEPARATE_APPROVAL")
        for field in ("source", "docx", "generator"):
            self.assertTrue((ROOT / pub[field]).exists())

    def test_project_disciplines_and_aliases_are_preserved(self) -> None:
        items = self.registry["project_disciplines"]
        self.assertEqual(len(items), 10)
        for item in items:
            self.assertTrue((ROOT / item["path"]).is_file())
            for source in item["canonical_sources"]:
                self.assertTrue((ROOT / source).exists(), f"{item['skill_id']} -> {source}")
        aliases = (ROOT / "skills/LEGACY_SKILL_ALIASES.md").read_text(encoding="utf-8")
        self.assertIn("urban-legend-integration-review", aliases)

    def test_project_invariants_and_protected_paths_remain(self) -> None:
        agents = (ROOT / "AGENTS.md").read_text(encoding="utf-8")
        core = (ROOT / "docs/PROJECT_CORE.md").read_text(encoding="utf-8")
        for term in ("괴이 기록국", "안정화 상태", "위험 사례", "잔향", "괴이 매뉴얼", "기록관 아카"):
            self.assertIn(term, agents + core)
        for path in ("scripts/core/game_state.gd", "data/episodes", "project.godot", "knowledge/base-pack"):
            self.assertIn(path, agents + core)

    def test_non_destructive_project_sources_remain(self) -> None:
        required = ["docs/planning/PROJECT_DIRECTION.md", "docs/planning/NARRATIVE_CONTENT_PLAN.md", "docs/planning/ART_PRESENTATION_PLAN.md", "docs/GAME_DESIGN_DOCUMENT.md", "MVP_ROADMAP.md", "TEST_CHECKLIST.md"]
        self.assertEqual([p for p in required if not (ROOT / p).is_file()], [])


if __name__ == "__main__":
    unittest.main()
