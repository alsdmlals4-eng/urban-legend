from __future__ import annotations

import hashlib
import json
import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
EXPECTED_BASE_INDEX_BLOB_SHA = "e227a227461a16162a9861ca858b5c4e267488cb"
EXPECTED_BASE_IDS = {'managing-game-project-operating-system', 'auditing-and-refining-ui-art', 'orchestrating-deepseek-worktrees', 'reviewing-and-validating-project-changes', 'establishing-project-core', 'synchronizing-local-and-github-state', 'maintaining-project-context-and-handoff', 'governing-game-user-research-coverage', 'designing-art-prompts-and-technique-cards', 'pruning-stale-and-nonfunctional-material', 'designing-vertical-slices', 'diagnosing-game-engine-runtime-failures', 'managing-base-change-proposals', 'evolving-project-discipline-skills', 'simplifying-skill-bodies', 'managing-design-documents', 'building-project-visual-dashboards', 'running-adversarial-review-and-refinement', 'managing-project-intake-and-work-contract', 'maintaining-long-running-task-continuity', 'identifying-project-core', 'auditing-canonical-reference-freshness', 'analyzing-and-refining-game-concepts', 'creating-user-learning-notes', 'refactoring-with-contract-preservation'}
NO_LOSS = {'urban-legend-narrative': ['미확보', '선택 기억', 'continuity-review'], 'urban-legend-game-design': ['처치', '위험 사례', 'balance-review'], 'urban-legend-ux-ui-accessibility': ['1280×720', '동등한', 'interaction-review'], 'urban-legend-engineering': ['저장', '보호 경로', 'compatibility-review'], 'urban-legend-technical-art-pipeline': ['Manifest', '재생성', 'pipeline-review'], 'urban-legend-art': ['식별성', '의미 키', 'asset-spec'], 'urban-legend-audio': ['음소거', '폴백', 'mix-review'], 'urban-legend-qa': ['NOT_RUN', 'release-gate', '원래 실패'], 'urban-legend-production-pm': ['차단 PR', 'rollback', 'production-handoff'], 'urban-legend-analytics-user-research': ['표본', '자기보고', 'synthesis']}
FRONT = re.compile(r"\A---\n(?P<body>.*?)\n---\n", re.DOTALL)
FIELD = re.compile(r"^(?P<key>[A-Za-z_][A-Za-z0-9_-]*):\s*(?P<value>.+?)\s*$", re.MULTILINE)
BACKTICK = re.compile(r"`([^`\n]+)`")
LOCAL_PREFIXES = ("skills/", "docs/", "tools/", "tests/", ".github/", "data/", "scripts/", "scenes/", "assets/")
LOCAL_SUFFIXES = {".md", ".json", ".py", ".yml", ".yaml", ".txt", ".tscn", ".gd", ".docx"}


def load(path: str) -> dict:
    return json.loads((ROOT / path).read_text(encoding="utf-8"))


def fields(text: str) -> dict[str, str]:
    match = FRONT.search(text)
    if not match:
        return {}
    return {m.group("key"): m.group("value").strip().strip("'\"") for m in FIELD.finditer(match.group("body"))}


def candidate(raw: str) -> Path | None:
    value = raw.strip().strip(".,;:").split("#", 1)[0]
    if not value or value.startswith(("http://", "https://", "mailto:")) or any(c in value for c in "<>*{}|"):
        return None
    if Path(value).suffix.lower() not in LOCAL_SUFFIXES:
        return None
    if value.startswith(LOCAL_PREFIXES) or value in {"AGENTS.md", "README.md", "START_HERE.md", "MVP_ROADMAP.md", "TEST_CHECKLIST.md", "project.godot"}:
        return ROOT / value
    return None


class SkillPackageIntegrityTests(unittest.TestCase):
    def setUp(self) -> None:
        self.registry = load("skills/SKILL_REGISTRY.json")
        self.index_path = ROOT / "skills/BASE_SKILL_INDEX.json"
        self.index = load("skills/BASE_SKILL_INDEX.json")

    def test_base_index_snapshot_is_frozen_and_complete(self) -> None:
        data = self.index_path.read_bytes()
        blob_sha = hashlib.sha1(f"blob {len(data)}\0".encode() + data).hexdigest()
        self.assertEqual(blob_sha, EXPECTED_BASE_INDEX_BLOB_SHA)
        ids = [x["skill_id"] for x in self.index["skills"]]
        self.assertEqual(set(ids), EXPECTED_BASE_IDS)
        self.assertEqual(len(ids), len(set(ids)))
        triggers = {}
        for item in self.index["skills"]:
            self.assertTrue(item["base_path"].endswith("/SKILL.md"))
            for tag in item["trigger_tags"]:
                triggers.setdefault(tag, []).append(item["skill_id"])
        self.assertIn("project-core", triggers)
        self.assertIn("adversarial-review", triggers)
        self.assertIn("skill-body-simplification", triggers)
        self.assertIn("runtime-failure", triggers)

    def test_registry_is_lean_and_routes_to_base_index(self) -> None:
        self.assertNotIn("base_skills", self.registry)
        self.assertEqual(self.registry["base"]["routing_index"], "skills/BASE_SKILL_INDEX.json")
        self.assertEqual(self.registry["base"]["coverage_map"], "skills/BASE_SKILL_COVERAGE.json")
        self.assertFalse(self.registry["base"]["copy_all_skill_bodies"])
        self.assertFalse(self.registry["routing_policy"]["load_all_skills"])

    def test_project_registry_and_packages_are_one_to_one(self) -> None:
        items = self.registry["project_disciplines"]
        expected = {x["path"] for x in items}
        actual = {p.relative_to(ROOT).as_posix() for p in (ROOT / "skills/disciplines").glob("*/SKILL.md")}
        self.assertEqual(actual, expected)
        self.assertEqual(len(items), 10)
        self.assertEqual(len(items), len({x["skill_id"] for x in items}))

    def test_compact_project_skill_bodies_keep_unique_capabilities(self) -> None:
        shared = "skills/disciplines/PROJECT_DISCIPLINE_CONTRACT.md"
        self.assertTrue((ROOT / shared).is_file())
        for item in self.registry["project_disciplines"]:
            path = ROOT / item["path"]
            text = path.read_text(encoding="utf-8")
            meta = fields(text)
            self.assertEqual(meta.get("name"), item["skill_id"])
            self.assertTrue(meta.get("description"))
            self.assertIn(shared, text)
            self.assertLessEqual(len(text.splitlines()), 65, f"Non-compact Skill body: {path}")
            for mode in item["skill_modes"]:
                self.assertIn(mode, text, f"Missing mode {mode}: {path}")
            for token in NO_LOSS[item["skill_id"]]:
                self.assertIn(token, text, f"Lost capability {token}: {path}")
            for source in item["canonical_sources"]:
                self.assertIn(source, text)
            self.assertTrue(item["support_skills"])

    def test_project_trigger_tags_and_support_references_are_valid(self) -> None:
        owners = {}
        duplicates = []
        all_ids = EXPECTED_BASE_IDS | {x["skill_id"] for x in self.registry["project_disciplines"]}
        for item in self.registry["project_disciplines"]:
            for tag in item["trigger_tags"]:
                if tag in owners:
                    duplicates.append(f"{tag}: {owners[tag]} / {item['skill_id']}")
                owners[tag] = item["skill_id"]
            self.assertTrue(set(item["support_skills"]) <= all_ids, item)
        self.assertEqual(duplicates, [])

    def test_representative_routing_examples(self) -> None:
        projects = self.registry["project_disciplines"]
        bases = self.index["skills"]
        for case in self.registry["routing_examples"]:
            tags = set(case["tags"])
            primary = [x["skill_id"] for x in projects if tags & set(x["trigger_tags"])]
            self.assertLessEqual(len(primary), 1, case)
            self.assertEqual(primary[0] if primary else None, case["expected_primary"], case)
            support = {x["skill_id"] for x in bases if tags & set(x["trigger_tags"])}
            self.assertEqual(support, set(case["expected_support"]), case)
            self.assertLessEqual(len(support), self.registry["routing_policy"]["max_foundation_skills"])

    def test_local_references_from_project_skill_bodies_exist(self) -> None:
        missing = []
        for item in self.registry["project_disciplines"]:
            path = ROOT / item["path"]
            for raw in set(BACKTICK.findall(path.read_text(encoding="utf-8"))):
                target = candidate(raw)
                if target is not None and not target.exists():
                    missing.append(f"{item['skill_id']} -> {raw}")
        self.assertEqual(missing, [])

    def test_entrypoints_expose_core_index_coverage_and_shared_contract(self) -> None:
        combined = "\n".join((ROOT / p).read_text(encoding="utf-8") for p in ["START_HERE.md", "README.md", "docs/OPERATING_MODEL.md", "docs/WORK_MODE_AND_SKILL_ROUTING.md", "docs/DOCUMENTATION_MAP.md"])
        for token in ("docs/PROJECT_CORE.md", "skills/BASE_SKILL_INDEX.json", "skills/BASE_SKILL_COVERAGE.json", "skills/disciplines/PROJECT_DISCIPLINE_CONTRACT.md"):
            self.assertIn(token, combined)


if __name__ == "__main__":
    unittest.main()
