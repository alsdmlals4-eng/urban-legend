from __future__ import annotations

import json
import subprocess
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
BASE_C0_SHA = "2b595570bd237174b2b962a1eb54588b5ecc508d"
GODOT_ARCHIVE_SHA256 = "c7ff14fd28472c8d4f193043de30278dcf7e5241a1dcf7566b02e27addaa33ba"
DESCRIPTOR = ROOT / ".godot-live-editor/project-pilot.json"
ADOPTION_DOC = ROOT / "docs/GODOT_LIVE_EDITOR_ADOPTION.md"
WORKFLOW = ROOT / ".github/workflows/validate-godot-live-editor-pilot.yml"
ALLOWED_PATHS = {
    ".godot-live-editor/project-pilot.json",
    "docs/GODOT_LIVE_EDITOR_ADOPTION.md",
    "tests/test_godot_live_editor_adoption.py",
    ".github/workflows/validate-godot-live-editor-pilot.yml",
}
BEHAVIOR_TARGETS = [
    "res://tests/core_mvp_001_state_test.gd",
    "res://tests/core_mvp_001_scene_test.gd",
    "res://tests/validation/validation_save_repository_test.gd",
    "res://tests/validation/validation_session_test.gd",
    "res://tests/validation/validation_game_state_adapter_test.gd",
    "res://tests/validation/validation_save_isolation_test.gd",
    "res://tests/annual_mvp_001_state_test.gd",
    "res://tests/annual_mvp_001_scene_test.gd",
    "res://tests/mvp043_recovery_loop_test.gd",
    "res://tests/minigame_pipeline_test.gd",
    "res://tests/runtime_ui_editor_scene_test.gd",
    "res://tests/accessibility_settings_test.gd",
]


def _required_text(path: Path) -> str:
    assert path.is_file(), f"missing required adoption surface: {path.relative_to(ROOT)}"
    return path.read_text(encoding="utf-8")


def _changed_paths_from_main() -> set[str]:
    merge_base = subprocess.run(
        ["git", "merge-base", "HEAD", "origin/main"],
        cwd=ROOT,
        check=True,
        capture_output=True,
        text=True,
    ).stdout.strip()
    output = subprocess.run(
        ["git", "diff", "--name-only", f"{merge_base}..HEAD"],
        cwd=ROOT,
        check=True,
        capture_output=True,
        text=True,
    ).stdout
    return {line.strip() for line in output.splitlines() if line.strip()}


def test_descriptor_is_exact_urban_legend_contract() -> None:
    payload = json.loads(_required_text(DESCRIPTOR))
    assert payload["schema_version"] == "1"
    assert payload["project_identity"] == {
        "repository": "alsdmlals4-eng/urban-legend",
        "project_id": "urban-legend",
    }
    assert payload["base_pilot_commit"] == BASE_C0_SHA
    assert payload["project_state"] == "EXISTING_GODOT_PROJECT"
    assert payload["godot"] == {
        "version": "4.7.1-stable",
        "archive_sha256": GODOT_ARCHIVE_SHA256,
    }
    assert payload["project_file"] == "project.godot"
    assert payload["main_scene_source"] == "application/run/main_scene"
    assert payload["legacy_editor_plugins"] == ["res://addons/godot_ai/plugin.cfg"]
    assert payload["legacy_autoloads"] == ["_mcp_game_helper"]
    assert payload["legacy_disable_mode"] == "TEMPORARY_COPY_ONLY"
    assert payload["source_mutation_policy"] == "FORBIDDEN"
    assert payload["scratch_scene_path"] == "res://.godot-live-editor-pilot/scratch.tscn"
    assert payload["expected_platform"] == "PC"
    assert payload["behavior_checks"] == [
        {"kind": "GODOT_SCRIPT", "target": target, "timeout_seconds": 300}
        for target in BEHAVIOR_TARGETS
    ]


def test_source_authorities_and_main_scene_remain_installed() -> None:
    project = (ROOT / "project.godot").read_text(encoding="utf-8")
    assert 'run/main_scene="res://scenes/main_menu.tscn"' in project
    assert 'UrbanLegendState="*res://scripts/core/urban_legend_state.gd"' in project
    assert 'ValidationSession="*res://scripts/core/validation_session.gd"' in project
    assert 'GameState="*res://scripts/core/validation_game_state.gd"' in project
    assert '_mcp_game_helper="*res://addons/godot_ai/runtime/game_helper.gd"' in project
    assert 'enabled=PackedStringArray("res://addons/godot_ai/plugin.cfg")' in project
    assert (ROOT / "addons/godot_ai/plugin.cfg").is_file()
    for target in BEHAVIOR_TARGETS:
        assert (ROOT / target.removeprefix("res://")).is_file(), target


def test_document_preserves_bounded_pilot_and_full_regression_authority() -> None:
    text = _required_text(ADOPTION_DOC)
    for marker in (
        "LEGACY_GODOT_AI_SOURCE_PRESERVED",
        "DUAL_MUTATION_AUTHORITY_FORBIDDEN",
        "MAIN_SCENE_READ_ONLY",
        "SCRATCH_SCENE_MUTATION_ONLY",
        "SOURCE_TREE_UNCHANGED",
        "SELF_CONTAINED_EVIDENCE_BUNDLE",
        "58개 엔트리포인트",
        "expected_platform: PC",
        "android_device: NOT_RUN",
        "PRODUCTION_ADAPTER_READY: NOT_READY",
    ):
        assert marker in text
    for forbidden_claim in (
        "android_device: PASS",
        "HUMAN_USABILITY: PASS",
        "PRODUCTION_ADAPTER_READY: READY",
    ):
        assert forbidden_claim not in text


def test_workflow_uses_one_immutable_base_pin() -> None:
    text = _required_text(WORKFLOW)
    reusable = (
        "alsdmlals4-eng/Base/.github/workflows/"
        f"reusable-godot-project-pilot.yml@{BASE_C0_SHA}"
    )
    assert reusable in text
    assert f"base_pilot_commit: {BASE_C0_SHA}" in text
    assert "descriptor_path: .godot-live-editor/project-pilot.json" in text
    assert "permissions:\n  contents: read" in text
    assert "fetch-depth: 0" in text
    assert "persist-credentials: false" in text
    assert "@main" not in text
    assert text.count(BASE_C0_SHA) == 2


def test_change_surface_is_bounded_to_four_adoption_files() -> None:
    changed = _changed_paths_from_main()
    assert changed <= ALLOWED_PATHS, f"forbidden changed paths: {sorted(changed - ALLOWED_PATHS)}"
