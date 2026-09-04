from __future__ import annotations

import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
WORKFLOW = ROOT / ".github/workflows/validate-afterlife-station-canon-v2-windows-platform-qa.yml"
HARNESS = ROOT / "tests/windows/run_afterlife_canon_v2_windows_platform_preflight.ps1"
PHASE_TEST = ROOT / "tests/afterlife_migration/afterlife_windows_platform_phase_test.gd"
LOCK_TEST = ROOT / "tests/afterlife_migration/afterlife_windows_locked_file_test.gd"
EVIDENCE = ROOT / "docs/qa/2026-08-05-afterlife-canon-v2-windows-platform-preflight-evidence.md"
DECISION = ROOT / "docs/decisions/D-2026-08-05-AFTERLIFE-STATION-CANON-V2-MIGRATION-DESIGN.md"


class AfterlifeCanonV2WindowsPlatformQaTests(unittest.TestCase):
    def test_required_windows_preflight_files_exist(self) -> None:
        for path in (WORKFLOW, HARNESS, PHASE_TEST, LOCK_TEST, EVIDENCE, DECISION):
            self.assertTrue(path.is_file(), path)

    def test_workflow_uses_windows_runner_and_isolated_appdata(self) -> None:
        text = WORKFLOW.read_text(encoding="utf-8")
        for token in (
            "runs-on: windows-latest",
            "shell: pwsh",
            "AFTERLIFE_QA_APPDATA",
            "run_afterlife_canon_v2_windows_platform_preflight.ps1",
            "actions/upload-artifact@v4",
            "afterlife-windows-platform-failure",
        ):
            self.assertIn(token, text)

    def test_powershell_harness_requires_hash_lock_crash_and_write_failure_checks(self) -> None:
        text = HARNESS.read_text(encoding="utf-8")
        for token in (
            "Set-StrictMode -Version Latest",
            "$ErrorActionPreference = 'Stop'",
            "Get-FileHash",
            "-Algorithm SHA256",
            "FileShare]::None",
            "PREPARED",
            "COMMITTED_PENDING_RUNTIME_APPLY",
            "ROLLBACK_RESTORED",
            "SOURCE_CHANGED",
            "WRITE_FAILED",
            "AFTERLIFE WINDOWS PLATFORM PREFLIGHT: PASS",
        ):
            self.assertIn(token, text)

    def test_godot_phase_test_uses_real_transaction_states(self) -> None:
        text = PHASE_TEST.read_text(encoding="utf-8")
        for token in (
            "afterlife_migration_transaction.gd",
            "prepare",
            "commit_prepared",
            "recover_pending",
            "PREPARED",
            "COMMITTED_PENDING_RUNTIME_APPLY",
            "ROLLBACK_RESTORED",
        ):
            self.assertIn(token, text)

    def test_locked_file_test_preserves_source_and_reports_non_success(self) -> None:
        text = LOCK_TEST.read_text(encoding="utf-8")
        for token in (
            "afterlife_migrating_game_state.gd",
            "source_checksum",
            "locked",
            "MIGRATION_VALIDATION_FAILED",
            "SOURCE_CHANGED",
            "WRITE_FAILED",
            "REPLACE_FAILED",
        ):
            self.assertIn(token, text)

    def test_evidence_keeps_automated_and_human_qa_boundaries_separate(self) -> None:
        text = EVIDENCE.read_text(encoding="utf-8")
        for token in (
            "WINDOWS_PLATFORM_PREFLIGHT",
            "AUTOMATED_WINDOWS_PLATFORM_PREFLIGHT_GREEN",
            "HUMAN_QA_NOT_RUN",
            "ACTUAL_USER_SAVE_NOT_AVAILABLE",
            "MERGE_NOT_AUTHORIZED",
            "Windows 10",
            "Windows 11",
            "UI_ACCESSIBILITY_NOT_RUN",
        ):
            self.assertIn(token, text)

    def test_green_evidence_records_exact_validated_runs_and_boundaries(self) -> None:
        text = EVIDENCE.read_text(encoding="utf-8")
        for token in (
            "55fec577ed43573087c23e6eab0df04e0ee9346e",
            "31004882572",
            "31004882698",
            "31004882551",
            "31004882625",
            "Windows Server 2025",
            "FileShare.None",
            "expected access denied",
            "failure artifact: not created because the GREEN run had no failure",
        ):
            self.assertIn(token, text)

    def test_decision_records_windows_preflight_without_promoting_human_qa_or_merge(self) -> None:
        text = DECISION.read_text(encoding="utf-8")
        for token in (
            "AUTOMATED_WINDOWS_PLATFORM_PREFLIGHT_GREEN",
            "ACTUAL_USER_SAVE_NOT_AVAILABLE",
            "HUMAN_QA_NOT_RUN",
            "UI_ACCESSIBILITY_NOT_RUN",
            "MERGE_NOT_AUTHORIZED",
            "PR: `#148`",
            "31004882572",
            "31004882698",
        ):
            self.assertIn(token, text)


if __name__ == "__main__":
    unittest.main()
