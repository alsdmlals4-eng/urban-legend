from __future__ import annotations

import re
import subprocess
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
    ROOT / "docs/planning/PROGRESSIVE_DISCLOSURE_PLAN.md",
    ROOT / "docs/GODOT_NATIVE_UI_ARCHITECTURE.md",
    ROOT / "docs/MINIGAME_SYSTEM_SPEC.md",
]
OPERATING_DOCS = [
    ROOT / "START_HERE.md",
    ROOT / "AGENTS.md",
    ROOT / "docs/OPERATING_MODEL.md",
    ROOT / "docs/WORK_MODE_AND_SKILL_ROUTING.md",
    ROOT / "docs/PROJECT_CORE.md",
    ROOT / "docs/DOCUMENTATION_MAP.md",
    ROOT / "docs/MVP_WORKFLOW_CHECKLIST.md",
    ROOT / "docs/AI_SKILL_ADOPTION_GUIDE.md",
]
CORE_INTEGRATED_SPEC = ROOT / "docs/superpowers/specs/2026-07-23-project-core-integrated-spec.md"
CORE_IMPLEMENTATION_PLAN = ROOT / "docs/superpowers/plans/2026-07-23-core-mvp-001-implementation-plan.md"
CORE_VALIDATION_QA = ROOT / "docs/qa/CORE_VALIDATION_SLICE_001.md"
PROGRESSIVE_DISCLOSURE_QA = ROOT / "docs/qa/PROGRESSIVE_DISCLOSURE_SLICE_001.md"
ALL_ROUTED_DOCS = ACTIVE_DOCS + OPERATING_DOCS
STALE_REFERENCE_DOCS = [
    path
    for path in ALL_ROUTED_DOCS + [CORE_VALIDATION_QA, PROGRESSIVE_DISCLOSURE_QA]
    if path not in {ROOT / "AGENTS.md", ROOT / "docs/DOCUMENTATION_MAP.md"}
]
BASELINE_DOCS = ACTIVE_DOCS
PROGRESSIVE_BASELINE_DOCS = [
    ROOT / "README.md",
    ROOT / "MVP_ROADMAP.md",
    ROOT / "TEST_CHECKLIST.md",
    ROOT / "docs/CURRENT_STATUS.md",
    ROOT / "docs/CURRENT_HANDOFF.md",
    ROOT / "docs/GAME_DESIGN_DOCUMENT.md",
    ROOT / "docs/planning/README.md",
    ROOT / "docs/planning/ROADMAP_AND_HANDOFF.md",
    ROOT / "docs/planning/PROGRESSIVE_DISCLOSURE_PLAN.md",
    ROOT / "docs/GODOT_NATIVE_UI_ARCHITECTURE.md",
]
MARKDOWN_LINK = re.compile(r"\[[^\]]*\]\(([^)]+)\)")
BACKTICK_PATH = re.compile(
    r"`((?:docs|scripts|scenes|data|tests|tools|assets)/[^`]+|"
    r"(?:README|MVP_ROADMAP|TEST_CHECKLIST|AGENTS|START_HERE)\.md)`"
)
STALE_FILE_PATTERNS = [
    re.compile(r"docs/qa/[A-Za-z0-9_.-]+\.md"),
    re.compile(r"docs/CODEX_GOAL_[A-Za-z0-9_.-]+\.md"),
    re.compile(r"(?:^|/)DESIGN_INTENT\.md"),
    re.compile(r"(?:^|/)PROJECT_BRIEF\.md"),
    re.compile(r"docs/CONTENT_DIRECTION_V09\.md"),
    re.compile(r"\.github/core-validation-1b/"),
    re.compile(r"apply-core-validation-1b\.yml"),
    re.compile(r"apply-core-validation-manual-promotion\.yml"),
    re.compile(r"agent/core-validation-slice"),
]
FORBIDDEN_TRACKED_PATHS = [
    re.compile(r"(?:^|/)__pycache__(?:/|$)"),
    re.compile(r"\.py[co]$"),
    re.compile(r"^\.github/core-validation-1b/"),
    re.compile(r"^\.github/workflows/apply-core-validation-(?:1b|manual-promotion)\.yml$"),
    re.compile(r"^\.github/workflows/progressive-disclosure-bootstrap\.yml$"),
    re.compile(r"^docs/URBAN_LEGEND_GAME_DESIGN\.docx$"),
]


class ActiveDocumentReferenceTests(unittest.TestCase):
    def test_active_and_operating_documents_exist(self) -> None:
        for path in ALL_ROUTED_DOCS:
            self.assertTrue(path.is_file(), path.relative_to(ROOT))
        self.assertTrue(CORE_INTEGRATED_SPEC.is_file())
        self.assertTrue(CORE_IMPLEMENTATION_PLAN.is_file())

    def test_relative_markdown_links_resolve(self) -> None:
        failures: list[str] = []
        for path in ALL_ROUTED_DOCS:
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
        for path in ALL_ROUTED_DOCS:
            text = path.read_text(encoding="utf-8")
            for raw_target in BACKTICK_PATH.findall(text):
                target = raw_target.rstrip(".,:;")
                if any(token in target for token in ("*", "YYYY", "<", ">")):
                    continue
                if target in {"docs/URBAN_LEGEND_GAME_DESIGN.docx", "docs/knowledge/"}:
                    continue
                resolved = ROOT / target
                if not resolved.exists():
                    failures.append(f"{path.relative_to(ROOT)} -> {target}")
        self.assertEqual([], failures)

    def test_active_design_docs_do_not_depend_on_stale_files(self) -> None:
        failures: list[str] = []
        for path in STALE_REFERENCE_DOCS:
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

    def test_progressive_disclosure_baseline_is_consistent(self) -> None:
        failures: list[str] = []
        for path in PROGRESSIVE_BASELINE_DOCS:
            text = path.read_text(encoding="utf-8")
            if "UX-PD-001" not in text or "2A" not in text:
                failures.append(f"{path.relative_to(ROOT)} missing UX-PD-001 2A")
        self.assertEqual([], failures)

    def test_core_mvp_001_authority_and_contract_are_aligned(self) -> None:
        doc_map = (ROOT / "docs/DOCUMENTATION_MAP.md").read_text(encoding="utf-8")
        core = (ROOT / "docs/PROJECT_CORE.md").read_text(encoding="utf-8")
        progressive = (ROOT / "docs/planning/PROGRESSIVE_DISCLOSURE_PLAN.md").read_text(encoding="utf-8")
        spec = CORE_INTEGRATED_SPEC.read_text(encoding="utf-8")
        plan = CORE_IMPLEMENTATION_PLAN.read_text(encoding="utf-8")

        self.assertIn("상세 게임 설계", doc_map)
        self.assertIn("CORE-MVP-001 마일스톤 계약", doc_map)
        self.assertIn(CORE_INTEGRATED_SPEC.relative_to(ROOT).as_posix(), doc_map)
        self.assertIn(CORE_IMPLEMENTATION_PLAN.relative_to(ROOT).as_posix(), core)
        self.assertIn(CORE_INTEGRATED_SPEC.relative_to(ROOT).as_posix(), core)
        self.assertIn("DEFERRED_FOR_REMAP", progressive)

        self.assertIn("적용 범위: `CORE-MVP-001` 마일스톤 계약", spec)
        self.assertNotIn("적용 범위: 프로젝트 정체성 전체", spec)
        self.assertIn("CoreMvp001Scene", spec)
        self.assertIn("CoreMvp001Scene", plan)
        self.assertNotIn("CoreMvp001Controller", spec + plan)
        self.assertIn("func start(case_data: Dictionary, run_seed: int = 1001) -> Dictionary", spec)
        self.assertIn("func start(case_data: Dictionary, run_seed: int = 1001) -> Dictionary", plan)

        fixed_ids = (
            "poc001_scene_broadcast_archive",
            "poc001_scene_platform_display",
            "poc001_scene_ticket_gate",
            "poc001_question_ticket_trigger",
        )
        for value in fixed_ids:
            self.assertIn(value, spec)
            self.assertIn(value, plan)
        for stale in ("poc001_scene_control_room", "poc001_question_safe_identifier"):
            self.assertNotIn(stale, spec + plan)

        public_states = (
            "BOOT", "ELIMINATION", "HYPOTHESIS_AUTHORING", "FIELD_TEST",
            "HYPOTHESIS_REFRESH", "RECOVERY_READY", "EMERGENCY_RECOVERY",
            "RECOVERY_TURN_START", "OMEN_READ", "RESPONSE_SELECTION",
            "CAPTURE_WINDOW", "EMERGENCY_CAPTURE", "RESULT_COMPARE",
            "MANUAL_PROMOTION", "COMPLETE",
        )
        for state in public_states:
            self.assertIn(state, spec)
            self.assertIn(state, plan)
        self.assertIn("INVESTIGATION_SITUATION은 UI 도입 단계", spec)
        self.assertIn("RESPONSE_RESOLUTION은 명령 내부 원자 전이", spec)

        for ux_contract in (
            "현재 단계 패널만 표시",
            "Footer는 고정",
            "ScrollContainer",
            "첫 유효 컨트롤로 포커스를 복구",
        ):
            self.assertIn(ux_contract, spec)
            self.assertIn(ux_contract, plan)

    def test_operating_entrypoints_reference_skill_router(self) -> None:
        combined = "\n".join(path.read_text(encoding="utf-8") for path in OPERATING_DOCS)
        for required in (
            "skills/SKILL_REGISTRY.json",
            "skills/BASE_SKILL_INDEX.json",
            "skills/urban-legend-investigation-case-authoring/SKILL.md",
        ):
            self.assertIn(required, combined)

    def test_preparation_progressive_disclosure_is_presentation_only(self) -> None:
        scene = (ROOT / "scenes/preparation_scene.tscn").read_text(encoding="utf-8")
        base = (ROOT / "scripts/scenes/preparation_scene.gd").read_text(encoding="utf-8")
        layer = (ROOT / "scripts/scenes/preparation_progressive_disclosure.gd").read_text(encoding="utf-8")
        self.assertIn("preparation_progressive_disclosure.gd", scene)
        self.assertNotIn("preparation_secondary_tools_opened", base)
        self.assertIn('extends "res://scripts/scenes/preparation_scene.gd"', layer)
        self.assertIn("set_tab_hidden", layer)
        self.assertIn("preparation_secondary_tools_opened", layer)

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

    def test_tracked_tree_has_no_generated_or_bootstrap_files(self) -> None:
        result = subprocess.run(
            ["git", "ls-files"],
            cwd=ROOT,
            check=True,
            capture_output=True,
            text=True,
        )
        tracked = [line.strip() for line in result.stdout.splitlines() if line.strip()]
        failures = [
            path
            for path in tracked
            if any(pattern.search(path) for pattern in FORBIDDEN_TRACKED_PATHS)
        ]
        self.assertEqual([], failures)


if __name__ == "__main__":
    unittest.main()
