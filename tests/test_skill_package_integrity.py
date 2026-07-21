from __future__ import annotations

import json
import re
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
REGISTRY_PATH = ROOT / "skills/SKILL_REGISTRY.json"
FRONT_MATTER = re.compile(r"\A---\n(?P<body>.*?)\n---\n", re.DOTALL)
FIELD = re.compile(r"^(?P<key>[A-Za-z_][A-Za-z0-9_-]*):\s*(?P<value>.+?)\s*$", re.MULTILINE)
BACKTICK = re.compile(r"`([^`\n]+)`")
MARKDOWN_LINK = re.compile(r"\[[^\]]+\]\(([^)]+)\)")
LOCAL_PREFIXES = ("skills/", "docs/", "tools/", "tests/", ".github/", "data/", "scripts/", "scenes/", "assets/")
LOCAL_SUFFIXES = {".md", ".json", ".py", ".yml", ".yaml", ".txt", ".tscn", ".gd", ".docx"}
EXPECTED_BASE_SOURCE_BLOB = "2291bce0d139905f8b8b6721ffbc9859774dcb06"
EXPECTED_BASE_TRIGGERS = {
    "managing-project-intake-and-work-contract": {
        "new-request", "cross-discipline", "ambiguous-scope", "material-ambiguity",
        "work-order", "acceptance-criteria", "work-decomposition", "task-breakdown",
        "dependency-map", "execution-sequence", "parallel-plan", "cold-start",
        "work-mode-selection", "automatic-skill-routing", "skill-execution-report",
    },
    "managing-game-project-operating-system": {
        "new-project", "missing-operating-system", "existing-project", "safe-migration",
        "document-restructure", "operating-system-health", "post-migration", "major-gate",
        "cold-start-failure", "legacy-file", "versioned-duplicate", "stale-copy",
        "obsolete-file", "legacy-reconciliation",
    },
    "evolving-project-discipline-skills": {
        "skill-audit", "skill-learning", "skill-consolidation", "missing-discipline-skill",
    },
    "managing-design-documents": {
        "design-document", "responsibility-map", "roadmap-structure", "pdf-publication",
        "publication-stale", "approved-image-change", "document-restructure",
    },
    "maintaining-project-context-and-handoff": {
        "handoff", "active-context-change", "phase-boundary", "new-chat",
    },
    "analyzing-and-refining-game-concepts": {
        "core-concept", "pointed-fun", "game-direction", "benchmark-research",
        "competitor-analysis", "player-reviews", "user-sentiment", "playtest-design",
        "telemetry-events", "funnel-analysis", "ab-testing", "swot", "mda", "dde",
        "digital-dopamine-design", "rapid-reward", "instant-feedback", "reward-latency",
        "poc", "concept-recalibration", "production-direction",
    },
    "designing-vertical-slices": {
        "vertical-slice", "first-playable", "production-proof", "quality-bar",
        "pipeline-proof", "playtest-evidence", "external-playtest",
        "accessibility-target", "performance-budget",
    },
    "orchestrating-deepseek-worktrees": {
        "external-ai", "large-draft", "isolated-worktree",
    },
    "reviewing-and-validating-project-changes": {
        "change-review", "contract-check", "external-ai-result", "diff-review",
        "reference-freshness", "static-validation", "runtime-validation",
        "accessibility-review", "input-barrier", "performance-profile", "target-platform",
        "frame-time", "memory-budget", "regression", "evidence-report",
    },
    "auditing-canonical-reference-freshness": {
        "canonical-source-change", "stale-reference", "rename", "path-migration",
        "schema-change", "skill-id-change", "document-id-change", "generator-change",
        "publication-stale", "propagation-gap",
    },
    "designing-art-prompts-and-technique-cards": {
        "art-direction", "image-prompt", "technique-card",
    },
    "auditing-and-refining-ui-art": {
        "ui-art-audit", "godot-ui", "web-ui", "visual-refinement", "render-review",
    },
    "managing-base-change-proposals": {
        "project-learning", "base-promotion", "repeated-pattern", "base-change-proposal",
        "promotion-review", "approved-base-change",
    },
}


def load_registry() -> dict:
    return json.loads(REGISTRY_PATH.read_text(encoding="utf-8"))


def front_matter_fields(text: str) -> dict[str, str]:
    match = FRONT_MATTER.search(text)
    if not match:
        return {}
    return {
        field.group("key"): field.group("value").strip().strip("'\"")
        for field in FIELD.finditer(match.group("body"))
    }


def candidate_local_path(raw: str) -> Path | None:
    value = raw.strip().strip(".,;:").split("#", 1)[0]
    if not value or value.startswith(("http://", "https://", "mailto:")):
        return None
    if any(token in value for token in ("<", ">", "*", "{", "}", "|")):
        return None
    if Path(value).suffix.lower() not in LOCAL_SUFFIXES:
        return None
    if value.startswith(LOCAL_PREFIXES) or value in {"AGENTS.md", "README.md", "START_HERE.md", "MVP_ROADMAP.md", "TEST_CHECKLIST.md"}:
        return ROOT / value
    return None


class SkillPackageIntegrityTests(unittest.TestCase):
    def setUp(self) -> None:
        self.registry = load_registry()

    def test_base_snapshot_matches_pinned_registry_contract(self) -> None:
        self.assertEqual(self.registry["base"]["source_registry_blob_sha"], EXPECTED_BASE_SOURCE_BLOB)
        skills = self.registry["base_skills"]
        by_id = {item["skill_id"]: item for item in skills}
        self.assertEqual(set(by_id), set(EXPECTED_BASE_TRIGGERS))
        self.assertEqual(len(skills), len(by_id), "Duplicate Base skill IDs")
        for skill_id, expected_tags in EXPECTED_BASE_TRIGGERS.items():
            item = by_id[skill_id]
            self.assertEqual(set(item["trigger_tags"]), expected_tags, f"Base trigger drift: {skill_id}")
            self.assertEqual(item["status"], "ACTIVE")
            self.assertFalse(item["load_by_default"])
            self.assertTrue(item["discipline"])
            self.assertTrue(item["use_when"])
            self.assertTrue(item["do_not_use_when"])
            self.assertTrue(item["review_triggers"])
            self.assertTrue(item["last_reviewed_commit"])
            self.assertTrue(item["knowledge_state"])
            self.assertTrue(item["base_path"].startswith("skills/"))
            self.assertTrue(item["base_path"].endswith("/SKILL.md"))
            self.assertTrue((ROOT / item["learning_log"]).is_file())

    def test_project_registry_and_skill_packages_are_one_to_one(self) -> None:
        items = self.registry["project_disciplines"]
        expected_paths = {item["path"] for item in items}
        actual_paths = {
            path.relative_to(ROOT).as_posix()
            for path in (ROOT / "skills/disciplines").glob("*/SKILL.md")
        }
        self.assertEqual(len(items), 10, "Consolidated project discipline count must remain 10")
        self.assertEqual(len(items), len({item["skill_id"] for item in items}), "Duplicate project skill IDs")
        self.assertEqual(len(items), len(expected_paths), "Duplicate project skill paths")
        self.assertEqual(actual_paths, expected_paths, "Registry and project Skill packages differ")

    def test_each_project_skill_contract_matches_registry(self) -> None:
        for item in self.registry["project_disciplines"]:
            path = ROOT / item["path"]
            self.assertTrue(path.is_file(), item["path"])
            fields = front_matter_fields(path.read_text(encoding="utf-8"))
            self.assertEqual(fields.get("name"), item["skill_id"], f"Front matter mismatch: {path}")
            self.assertTrue(fields.get("description"), f"Missing description: {path}")
            self.assertEqual(path.parent.name, item["skill_id"])
            self.assertEqual(item["layer"], "discipline")
            self.assertEqual(item["status"], "ACTIVE")
            self.assertFalse(item["load_by_default"])
            for field in ("trigger_tags", "use_when", "do_not_use_when", "skill_modes", "canonical_sources", "review_triggers"):
                self.assertTrue(item[field], f"Empty {field}: {item['skill_id']}")
            self.assertTrue((ROOT / item["learning_log"]).is_file())
            for raw_path in item["canonical_sources"]:
                self.assertTrue((ROOT / raw_path).exists(), f"{item['skill_id']} -> {raw_path}")

    def test_project_trigger_tags_are_unique(self) -> None:
        owners: dict[str, str] = {}
        duplicates: list[str] = []
        for item in self.registry["project_disciplines"]:
            for tag in item["trigger_tags"]:
                if tag in owners:
                    duplicates.append(f"{tag}: {owners[tag]} / {item['skill_id']}")
                owners[tag] = item["skill_id"]
        self.assertEqual(duplicates, [], "Ambiguous project trigger tags:\n" + "\n".join(duplicates))

    def test_skill_documents_reference_existing_local_artifacts(self) -> None:
        missing: list[str] = []
        for item in self.registry["project_disciplines"]:
            skill_path = ROOT / item["path"]
            text = skill_path.read_text(encoding="utf-8", errors="replace")
            references = set(BACKTICK.findall(text)) | set(MARKDOWN_LINK.findall(text))
            for raw in sorted(references):
                candidate = candidate_local_path(raw)
                if candidate is not None and not candidate.exists():
                    missing.append(f"{item['skill_id']} -> {raw}")
        self.assertEqual(missing, [], "Missing Skill references:\n" + "\n".join(missing))

    def test_representative_routing_examples(self) -> None:
        project_items = self.registry["project_disciplines"]
        base_items = self.registry["base_skills"]
        for case in self.registry["routing_examples"]:
            tags = set(case["tags"])
            primary_matches = [
                item["skill_id"] for item in project_items
                if tags & set(item["trigger_tags"])
            ]
            self.assertLessEqual(len(primary_matches), 1, f"Multiple primary skills: {case}")
            actual_primary = primary_matches[0] if primary_matches else None
            self.assertEqual(actual_primary, case["expected_primary"], case)
            actual_support = {
                item["skill_id"] for item in base_items
                if tags & set(item["trigger_tags"])
            }
            self.assertEqual(actual_support, set(case["expected_support"]), case)
            self.assertLessEqual(len(actual_support), self.registry["routing_policy"]["max_foundation_skills"])

    def test_integration_review_was_consolidated_without_orphan(self) -> None:
        active_ids = {item["skill_id"] for item in self.registry["project_disciplines"]}
        self.assertNotIn("urban-legend-integration-review", active_ids)
        self.assertFalse((ROOT / "skills/disciplines/urban-legend-integration-review/SKILL.md").exists())
        aliases = (ROOT / self.registry["legacy_aliases"]).read_text(encoding="utf-8")
        self.assertIn("urban-legend-integration-review", aliases)
        replacements = "\n".join(
            " ".join(item["replacement"])
            for item in self.registry["consolidations"]
            if item["removed_skill_id"] == "urban-legend-integration-review"
        )
        self.assertIn("reviewing-and-validating-project-changes", replacements)
        self.assertIn("managing-game-project-operating-system", replacements)

    def test_entrypoints_route_selectively_without_loading_all_skills(self) -> None:
        combined = "\n".join(
            (ROOT / path).read_text(encoding="utf-8")
            for path in (
                "START_HERE.md",
                "AGENTS.md",
                "docs/OPERATING_MODEL.md",
                "docs/WORK_MODE_AND_SKILL_ROUTING.md",
                "docs/DOCUMENTATION_MAP.md",
            )
        )
        self.assertIn("skills/SKILL_REGISTRY.json", combined)
        self.assertIn("skills/PROJECT_PATH_ADAPTER.json", combined)
        self.assertFalse(self.registry["routing_policy"]["load_all_skills"])
        self.assertEqual(self.registry["routing_policy"]["max_primary_discipline_skills"], 1)
        self.assertLessEqual(self.registry["routing_policy"]["max_foundation_skills"], 3)
        for item in self.registry["project_disciplines"]:
            self.assertNotIn("[기획서]/", item["path"])


if __name__ == "__main__":
    unittest.main()
