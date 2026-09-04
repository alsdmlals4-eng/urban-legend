from __future__ import annotations

import hashlib
import importlib.util
import json
import tempfile
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


def load_checker():
    path = ROOT / "tools/check_archive_governance.py"
    spec = importlib.util.spec_from_file_location("urban_archive_checker", path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


checker = load_checker()


class ArchiveRetentionGovernanceTests(unittest.TestCase):
    def test_current_repository_contract_passes(self) -> None:
        self.assertEqual([], checker.validate(ROOT))

    def test_shared_skill_is_pinned_without_local_body_copy(self) -> None:
        expected = checker.EXPECTED_BASE_COMMIT
        routes = json.loads((ROOT / "skills/BASE_SHARED_SKILL_ROUTES.json").read_text(encoding="utf-8"))
        project_adapter = json.loads((ROOT / "skills/PROJECT_BASE_SKILL_ADAPTER.json").read_text(encoding="utf-8"))
        archive_adapter = json.loads((ROOT / "docs/archive/ARCHIVE_RETENTION_ADAPTER.json").read_text(encoding="utf-8"))
        self.assertEqual(expected, routes["base"]["commit"])
        self.assertEqual(expected, project_adapter["base"]["commit"])
        self.assertEqual(expected, archive_adapter["base"]["commit"])
        self.assertFalse((ROOT / "skills/governing-legacy-retention-and-archives/SKILL.md").exists())

    def test_archive_policy_forbids_blank_files_and_secrets(self) -> None:
        adapter = json.loads((ROOT / "docs/archive/ARCHIVE_RETENTION_ADAPTER.json").read_text(encoding="utf-8"))
        self.assertTrue(adapter["policies"]["preserve_original_content"])
        self.assertFalse(adapter["policies"]["blank_placeholders_allowed"])
        self.assertFalse(adapter["policies"]["secrets_may_be_archived"])
        self.assertFalse(adapter["policies"]["default_active_authority"])
        self.assertEqual("NONE", adapter["policies"]["default_implementation_authority"])

    def test_existing_archive_history_is_preserved(self) -> None:
        readme = (ROOT / "docs/archive/README.md").read_text(encoding="utf-8")
        for token in (
            "PROJECT_STATUS_AND_ROADMAP_BACKUP.md",
            "CONTENT_DIRECTION_V09_BACKUP.md",
            "README_MVP001_038_PRE_GDD.md",
            "MVP_STATUS_AUDIT_2026-07-11.md",
            "git show 130466e66d3115876a85ba06f47b7661fae3f304",
        ):
            self.assertIn(token, readme)

    def test_empty_archived_markdown_is_rejected(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            for relative, content in (
                ("AGENTS.md", "agents"),
                ("docs/DOCUMENTATION_MAP.md", "map"),
                ("docs/CURRENT_STATUS.md", "status"),
                ("docs/PROJECT_CORE.md", "core"),
                ("docs/GAME_DESIGN_DOCUMENT.md", "gdd"),
                ("skills/SKILL_REGISTRY.json", "{}"),
            ):
                path = root / relative
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_text(content, encoding="utf-8")
            (root / "docs/archive").mkdir(parents=True)
            (root / "docs/archive/README.md").write_text(
                "현재 정본이 아니며 구현 권한이 없다\n원문을 비우지 않는다\n비밀키",
                encoding="utf-8",
            )
            empty = root / "docs/archive/empty.md"
            empty.write_text("---\narchive_metadata: true\n---\n", encoding="utf-8")

            archive_adapter = json.loads((ROOT / "docs/archive/ARCHIVE_RETENTION_ADAPTER.json").read_text(encoding="utf-8"))
            archive_adapter["paths"]["canonical_sources"] = [
                "docs/PROJECT_CORE.md",
                "docs/CURRENT_STATUS.md",
                "docs/GAME_DESIGN_DOCUMENT.md",
                "docs/DOCUMENTATION_MAP.md",
            ]
            (root / "docs/archive/ARCHIVE_RETENTION_ADAPTER.json").write_text(
                json.dumps(archive_adapter), encoding="utf-8"
            )
            manifest = {
                "schema_version": 1,
                "manifest_role": "project-archive-retention-index",
                "records": [{
                    "archive_id": "empty",
                    "classification": "ARCHIVE_HISTORY",
                    "original_path": "docs/old.md",
                    "current_path": "docs/archive/empty.md",
                    "content_sha256": hashlib.sha256(empty.read_bytes()).hexdigest(),
                    "archived_at": "2026-07-25",
                    "superseded_by": ["docs/CURRENT_STATUS.md"],
                    "reason": "test",
                    "active_authority": False,
                    "implementation_authority": "NONE",
                    "compatibility_consumers": [],
                    "rollback_ref": "a" * 40,
                    "validation_status": "NOT_RUN",
                }],
            }
            (root / "docs/archive/MANIFEST.json").write_text(json.dumps(manifest), encoding="utf-8")
            (root / "skills/BASE_SHARED_SKILL_ROUTES.json").write_text(
                (ROOT / "skills/BASE_SHARED_SKILL_ROUTES.json").read_text(encoding="utf-8"),
                encoding="utf-8",
            )
            (root / "skills/PROJECT_BASE_SKILL_ADAPTER.json").write_text(
                (ROOT / "skills/PROJECT_BASE_SKILL_ADAPTER.json").read_text(encoding="utf-8"),
                encoding="utf-8",
            )
            errors = checker.validate(root)
            self.assertIn("archived Markdown body is empty: docs/archive/empty.md", errors)


if __name__ == "__main__":
    unittest.main()
