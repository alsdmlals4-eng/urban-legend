from __future__ import annotations

import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
ROOT_ENTRY = ROOT / "START_HUMAN_QA.cmd"
ORCHESTRATOR = ROOT / "tools/qa/start_afterlife_canon_v2_human_qa.ps1"
CHECKLIST = ROOT / "tools/qa/afterlife_canon_v2_human_qa_checklist.json"
BASE_RUNNER = ROOT / "tools/qa/run_afterlife_canon_v2_human_qa.ps1"
WINDOWS_PREFLIGHT = ROOT / "tests/windows/run_afterlife_canon_v2_one_click_preflight.ps1"
GUIDE = ROOT / "docs/qa/2026-08-06-one-click-human-qa-package.md"
LEGACY_GUIDE = ROOT / "docs/qa/2026-08-05-afterlife-canon-v2-local-human-qa-runner.md"
WINDOWS_WORKFLOW = ROOT / ".github/workflows/validate-afterlife-station-canon-v2-windows-platform-qa.yml"
MIGRATION_WORKFLOW = ROOT / ".github/workflows/validate-afterlife-station-canon-v2-migration-design.yml"


class AfterlifeCanonV2OneClickHumanQaTests(unittest.TestCase):
    def test_required_package_files_exist(self) -> None:
        for path in (
            ROOT_ENTRY,
            ORCHESTRATOR,
            CHECKLIST,
            BASE_RUNNER,
            WINDOWS_PREFLIGHT,
            GUIDE,
            LEGACY_GUIDE,
            WINDOWS_WORKFLOW,
            MIGRATION_WORKFLOW,
        ):
            self.assertTrue(path.is_file(), path)

    def test_cmd_prefers_pwsh_and_preserves_arguments_and_exit_code(self) -> None:
        text = ROOT_ENTRY.read_text(encoding="utf-8")
        for token in (
            "pwsh.exe",
            "powershell.exe",
            "-ExecutionPolicy Bypass",
            "%~dp0",
            "%*",
            "HUMAN_QA_NO_PAUSE",
            "exit /b",
        ):
            self.assertIn(token, text)

    def test_checklist_is_authoritative_ordered_and_complete(self) -> None:
        payload = json.loads(CHECKLIST.read_text(encoding="utf-8"))
        self.assertEqual(payload["schema_version"], 1)
        self.assertEqual(payload["allowed_statuses"], ["PASS", "FAIL", "BLOCKED", "NOT_RUN"])
        items = payload["items"]
        self.assertEqual(len(items), 18)
        ids = [item["id"] for item in items]
        self.assertEqual(len(ids), len(set(ids)))
        self.assertTrue(all(item["required"] is True for item in items))
        joined = "\n".join(f"{item['id']} {item['title_ko']} {item['category']}" for item in items)
        for token in (
            "1280x720",
            "1920x1080",
            "keyboard_focus",
            "gamepad_focus",
            "save_restart",
            "validation_isolation",
            "protection_obligation",
            "termination_preview",
            "independent_result_axes",
        ):
            self.assertIn(token, joined)

    def test_orchestrator_declares_expected_inputs_and_functions(self) -> None:
        text = ORCHESTRATOR.read_text(encoding="utf-8-sig")
        for token in (
            "$GodotBinary",
            "$SourceMain",
            "$SourceValidation",
            "$QaRoot",
            "$AllowVersionMismatch",
            "$NonInteractive",
            "$SkipLaunch",
            "$DefaultChecklistStatus",
            "$NoPause",
            "Resolve-GodotBinary",
            "Test-GodotVersion",
            "Resolve-SourceSaves",
            "Show-HumanQaChecklist",
            "Read-HumanQaResults",
            "Write-HumanQaSummary",
        ):
            self.assertIn(token, text)

    def test_orchestrator_is_windows_powershell_51_utf8_safe(self) -> None:
        raw = ORCHESTRATOR.read_bytes()
        self.assertTrue(raw.startswith(b"\xef\xbb\xbf"), "PowerShell 5.1 requires a UTF-8 BOM for non-ASCII source")
        text = raw.decode("utf-8-sig")
        self.assertIn("System.Text.UTF8Encoding", text)
        self.assertIn("System.IO.File]::ReadAllText", text)
        self.assertNotIn("Get-Content -LiteralPath $ChecklistPath -Raw", text)

    def test_orchestrator_delegates_to_existing_runner(self) -> None:
        text = ORCHESTRATOR.read_text(encoding="utf-8-sig")
        for token in (
            "run_afterlife_canon_v2_human_qa.ps1",
            "-Stage Prepare",
            "-Stage Launch",
            "-Stage Collect",
            "-WaitForExit",
        ):
            self.assertIn(token, text)
        self.assertNotIn("Move-Item", text)
        self.assertNotIn("SOURCE_COPY_HASH_MISMATCH", text)

    def test_godot_discovery_is_bounded_and_version_checked(self) -> None:
        text = ORCHESTRATOR.read_text(encoding="utf-8-sig")
        for token in (
            "GODOT_BINARY",
            "Get-Command",
            "App Paths",
            "LOCALAPPDATA",
            "Downloads",
            "Desktop",
            "--version",
            "4.7.1",
            "AllowVersionMismatch",
            "BLOCKED_GODOT_NOT_FOUND",
            "BLOCKED_GODOT_VERSION",
        ):
            self.assertIn(token, text)
        for forbidden in (
            "Get-ChildItem C:\\ -Recurse",
            "Invoke-WebRequest",
            "Start-BitsTransfer",
            "winget install",
            "choco install",
        ):
            self.assertNotIn(forbidden, text)

    def test_state_machine_and_classifications_are_explicit(self) -> None:
        text = ORCHESTRATOR.read_text(encoding="utf-8-sig")
        for token in (
            "PREFLIGHT",
            "READY",
            "PREPARED",
            "LAUNCHED",
            "HUMAN_REVIEW_RECORDED",
            "EVIDENCE_COLLECTED",
            "COMPLETE",
            "BLOCKED_NO_MAIN_SAVE",
            "PREPARE_FAILED",
            "LAUNCH_FAILED",
            "SOURCE_MUTATED",
            "COLLECT_FAILED",
            "USER_CANCELLED",
            "HUMAN_QA_REVIEW_COMPLETE_PASS",
            "HUMAN_QA_REVIEW_COMPLETE_FAIL",
            "HUMAN_QA_REVIEW_BLOCKED",
            "HUMAN_QA_INCOMPLETE",
            "AUTOMATED_EVIDENCE_COLLECTION_FAILED",
        ):
            self.assertIn(token, text)

    def test_shareable_summary_keeps_private_boundaries(self) -> None:
        text = ORCHESTRATOR.read_text(encoding="utf-8-sig")
        for token in (
            "human-qa-summary.json",
            "HUMAN_QA_SUMMARY.md",
            "ACTUAL_USER_SAVE_CONTENT_NOT_RECORDED",
            "source_main_unchanged",
            "repository_head",
            "godot_version",
        ):
            self.assertIn(token, text)
        for forbidden in (
            '"source_path"',
            "source-map.local.json",
            "Get-Content -LiteralPath $sourceMain -Raw",
            "Get-Content -LiteralPath $sourceValidation -Raw",
        ):
            self.assertNotIn(forbidden, text)

    def test_windows_preflight_uses_fixture_and_never_auto_passes(self) -> None:
        text = WINDOWS_PREFLIGHT.read_text(encoding="utf-8")
        for token in (
            "main_mvp039_recovery.json",
            "Get-FileHash",
            "start_afterlife_canon_v2_human_qa.ps1",
            "-NonInteractive",
            "-SkipLaunch",
            "-DefaultChecklistStatus NOT_RUN",
            "HUMAN_QA_INCOMPLETE",
            "NOT_RUN",
            "18",
        ):
            self.assertIn(token, text)
        self.assertNotIn("HUMAN_QA_REVIEW_COMPLETE_PASS", text)

    def test_active_workflows_run_contract_and_both_powershell_hosts(self) -> None:
        windows = WINDOWS_WORKFLOW.read_text(encoding="utf-8")
        migration = MIGRATION_WORKFLOW.read_text(encoding="utf-8")
        for text in (windows, migration):
            for token in (
                "test_afterlife_canon_v2_one_click_human_qa.py",
                "run_afterlife_canon_v2_one_click_preflight.ps1",
                "START_HUMAN_QA.cmd",
                "start_afterlife_canon_v2_human_qa.ps1",
                "afterlife_canon_v2_human_qa_checklist.json",
            ):
                self.assertIn(token, text)
        for shell in ("shell: pwsh", "shell: powershell"):
            self.assertIn(shell, windows)
            self.assertIn(shell, migration)

    def test_docs_present_one_click_as_normal_path_and_keep_expert_path(self) -> None:
        guide = GUIDE.read_text(encoding="utf-8")
        legacy = LEGACY_GUIDE.read_text(encoding="utf-8")
        for token in (
            "START_HUMAN_QA.cmd",
            "PASS",
            "FAIL",
            "BLOCKED",
            "NOT_RUN",
            "human-qa-summary.json",
            "HUMAN_QA_SUMMARY.md",
            ".control",
            "AppData",
        ):
            self.assertIn(token, guide)
        self.assertIn("START_HUMAN_QA.cmd", legacy)
        for token in ("-Stage Prepare", "-Stage Launch", "-Stage Collect"):
            self.assertIn(token, legacy)


if __name__ == "__main__":
    unittest.main()
