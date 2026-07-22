from __future__ import annotations

import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ACTIVE_DOCS = [
    ROOT / "README.md",
    ROOT / "MVP_ROADMAP.md",
    ROOT / "TEST_CHECKLIST.md",
    ROOT / "docs/CURRENT_STATUS.md",
    ROOT / "docs/CURRENT_HANDOFF.md",
    ROOT / "docs/PROJECT_CONTEXT.md",
    ROOT / "docs/GAME_DESIGN_DOCUMENT.md",
    ROOT / "docs/CINEMATIC_FIELD_RECOVERY_UI.md",
    ROOT / "docs/planning/README.md",
    ROOT / "docs/planning/PROJECT_DIRECTION.md",
    ROOT / "docs/planning/ROADMAP_AND_HANDOFF.md",
    ROOT / "docs/GODOT_NATIVE_UI_ARCHITECTURE.md",
    ROOT / "docs/MINIGAME_SYSTEM_SPEC.md",
]
CORE_VALIDATION_QA = ROOT / "docs/qa/CORE_VALIDATION_SLICE_001.md"
REFERENCE_AUDIT_DOCS = ACTIVE_DOCS + [CORE_VALIDATION_QA]
BASELINE_DOCS = ACTIVE_DOCS
MARKDOWN_LINK = re.compile(r"\[[^\]]*\]\(([^)]+)\)")
BACKTICK_PATH = re.compile(r"`((?:docs|scripts|scenes|data|tests|tools|assets)/[^`]+|(?:README|MVP_ROADMAP|TEST_CHECKLIST|AGENTS)\.md)`")
STALE_FILE_PATTERNS = [
    re.compile(r"docs/qa/[A-Za-z0-9_.-]+\.md"),
    re.compile(r"docs/CODEX_GOAL_[A-Za-z0-9_.-]+\.md"),
    re.compile(r"(?:^|/)DESIGN_INTENT\.md"),
    re.compile(r"(?:^|/)PROJECT_BRIEF\.md"),
    re.compile(r"docs/CONTENT_DIRECTION_V09\.md"),
    re.compile(r"\.github/core-validation-1b/"),
    re.compile(r"apply-core-validation-1b\.yml"),
    re.compile(r"agent/core-validation-slice"),
]


class ActiveDocumentReferenceTests(unittest.TestCase):
    def test_active_documents_exist(self) -> None:
        for path in ACTIVE_DOCS:
            self.assertTrue(path.is_file(), path.relative_to(ROOT))

    def test_relative_markdown_links_resolve(self) -> None:
        failures: list[str] = []
        for path in ACTIVE_DOCS:
            text = path.read_text(encoding="utf-8")
            for raw_target in MARKDOWN_LINK.findall(text):
                target = raw_target.split("#", 1)[0].strip()
                if not target or "://" in target or target.startswith("mailto:"):
                    continue
                resolved = (path.parent / target).resolve()
                if not resolved.exists():
                    failures.append(f"{path.relative_to(ROOT)} -> {raw_target}")
        self.assertEqual([], failures)

    def test_backticked_repository_paths_exist(self) -> None:
        failures: list[str] = []
        for path in ACTIVE_DOCS:
            text = path.read_text(encoding="utf-8")
            for raw_target in BACKTICK_PATH.findall(text):
                target = raw_target.rstrip(".,:;")
                if any(token in target for token in ("*", "YYYY", "<", ">")):
                    continue
                resolved = ROOT / target
                if not resolved.exists():
                    failures.append(f"{path.relative_to(ROOT)} -> {target}")
        self.assertEqual([], failures)

    def test_active_design_docs_do_not_depend_on_stale_files(self) -> None:
        failures: list[str] = []
        for path in REFERENCE_AUDIT_DOCS:
            text = path.read_text(encoding="utf-8")
            for pattern in STALE_FILE_PATTERNS:
                match = pattern.search(text)
                if match:
                    failures.append(f"{path.relative_to(ROOT)} -> {match.group(0)}")
        self.assertEqual([], failures)

    def test_current_baseline_is_consistent(self) -> None:
        failures: list[str] = []
        for path in BASELINE_DOCS:
            text = path.read_text(encoding="utf-8")
            for required in ("CORE-VALIDATION-001", "Ver 4.2", "mvp-039"):
                if required not in text:
                    failures.append(f"{path.relative_to(ROOT)} missing {required}")
        self.assertEqual([], failures)

    def test_recovery_ui_spec_has_no_old_schema(self) -> None:
        text = (ROOT / "docs/CINEMATIC_FIELD_RECOVERY_UI.md").read_text(encoding="utf-8")
        self.assertNotIn("mvp-035", text)
        self.assertIn("anomaly_manual_records", text)
        self.assertIn("가설 → 근거 → 대응", text)

    def test_runtime_and_docx_builder_use_current_baseline(self) -> None:
        menu = (ROOT / "scripts/ui/main_menu.gd").read_text(encoding="utf-8")
        menu_test = (ROOT / "tests/test_mvp035_log_companion.gd").read_text(encoding="utf-8")
        builder = (ROOT / "tools/docs/build_game_design_doc.py").read_text(encoding="utf-8")
        self.assertIn('GAME_VERSION := "Ver 4.2"', menu)
        self.assertIn('"Ver 4.2"', menu_test)
        self.assertNotIn('"Ver 4.1"', menu_test)
        self.assertIn("MVP-043 + CORE-VALIDATION-001", builder)
        self.assertIn("Ver 4.2", builder)
        self.assertNotIn("Ver 4.3", builder)

    def test_current_specs_do_not_link_completed_qa_files(self) -> None:
        failures: list[str] = []
        for path in (ROOT / "docs").rglob("*.md"):
            relative = path.relative_to(ROOT).as_posix()
            if relative.startswith("docs/archive/") or relative.startswith("docs/qa/"):
                continue
            if relative in {
                "docs/DOCUMENTATION_MAP.md",
                "docs/DOCUMENT_LIFECYCLE.md",
                "docs/AI_SHARED_WORK_RULES.md",
                "docs/CONTENT_DIRECTION_V09.md",
            } or path.name.startswith("CODEX_GOAL_"):
                continue
            text = path.read_text(encoding="utf-8")
            for match in re.finditer(r"docs/qa/[A-Za-z0-9_.-]+\.md", text):
                failures.append(f"{relative} -> {match.group(0)}")
            for match in re.finditer(r"docs/CODEX_GOAL_[A-Za-z0-9_.-]+\.md", text):
                failures.append(f"{relative} -> {match.group(0)}")
        self.assertEqual([], failures)


if __name__ == "__main__":
    unittest.main()
