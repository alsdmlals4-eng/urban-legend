from __future__ import annotations

import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
RUNNER = ROOT / "tools/qa/run_afterlife_canon_v2_human_qa.ps1"
GUIDE = ROOT / "docs/qa/2026-08-05-afterlife-canon-v2-local-human-qa-runner.md"
EVIDENCE = ROOT / "docs/qa/2026-08-05-afterlife-canon-v2-local-human-qa-runner-evidence.md"
ADDENDUM = ROOT / "docs/decisions/D-2026-08-05-AFTERLIFE-STATION-CANON-V2-MIGRATION-DESIGN-LOCAL-HUMAN-QA-RUNNER-ADDENDUM.md"
WINDOWS_WORKFLOW = ROOT / ".github/workflows/validate-afterlife-station-canon-v2-windows-platform-qa.yml"
MIGRATION_WORKFLOW = ROOT / ".github/workflows/validate-afterlife-station-canon-v2-migration-design.yml"
VALIDATED_IMPLEMENTATION_HEAD = "652efecbb9e4dfbd7a388bc894983cd8f0cc08a9"
VALIDATED_RUNS = (
    "31008696028",  # Documentation
    "31008696020",  # Independent Windows
    "31008696047",  # Migration Ubuntu + Windows
    "31008696037",  # ANNUAL / Godot
)


class AfterlifeCanonV2LocalHumanQaRunnerTests(unittest.TestCase):
    def test_required_runner_files_exist(self) -> None:
        for path in (RUNNER, GUIDE, EVIDENCE, ADDENDUM, WINDOWS_WORKFLOW, MIGRATION_WORKFLOW):
            self.assertTrue(path.is_file(), path)

    def test_runner_has_three_explicit_stages_and_inputs(self) -> None:
        text = RUNNER.read_text(encoding="utf-8")
        for token in (
            "ValidateSet('Prepare', 'Launch', 'Collect')",
            "$Stage",
            "$SourceMain",
            "$SourceValidation",
            "$QaRoot",
            "$GodotBinary",
            "Set-StrictMode -Version Latest",
            "$ErrorActionPreference = 'Stop'",
        ):
            self.assertIn(token, text)

    def test_prepare_is_copy_only_and_hash_verified(self) -> None:
        text = RUNNER.read_text(encoding="utf-8")
        for token in (
            "Get-FileHash",
            "-Algorithm SHA256",
            "Copy-Item",
            "SOURCE_COPY_HASH_MISMATCH",
            "SOURCE_AND_QA_PATH_COLLISION",
            "ACTUAL_USER_SAVE_CONTENT_NOT_RECORDED",
            "manifest.json",
            "PREPARED",
        ):
            self.assertIn(token, text)
        self.assertNotIn("Move-Item", text)
        self.assertNotIn("Remove-Item -LiteralPath $SourceMain", text)

    def test_launch_restores_appdata_even_on_failure(self) -> None:
        text = RUNNER.read_text(encoding="utf-8")
        for token in (
            "$PreviousAppData = $env:APPDATA",
            "$env:APPDATA = $layout.app_data",
            "try {",
            "finally {",
            "$env:APPDATA = $PreviousAppData",
            "Start-Process",
            "-PassThru",
        ):
            self.assertIn(token, text)

    def test_collect_rechecks_source_and_never_auto_passes_human_qa(self) -> None:
        text = RUNNER.read_text(encoding="utf-8")
        for token in (
            "SOURCE_MUTATED_AFTER_PREPARE",
            "EVIDENCE_COLLECTED",
            "HUMAN_REVIEW_REQUIRED",
            "HUMAN_QA_NOT_RUN",
            "UI_ACCESSIBILITY_NOT_RUN",
            "MERGE_NOT_AUTHORIZED",
        ):
            self.assertIn(token, text)
        self.assertNotIn("HUMAN_QA_PASS", text)

    def test_docs_keep_real_save_and_automation_boundaries_separate(self) -> None:
        guide = GUIDE.read_text(encoding="utf-8")
        evidence = EVIDENCE.read_text(encoding="utf-8")
        addendum = ADDENDUM.read_text(encoding="utf-8")
        for text in (guide, evidence, addendum):
            for token in (
                "AUTOMATED_LOCAL_HUMAN_QA_RUNNER_PREFLIGHT_GREEN",
                "ACTUAL_USER_SAVE_NOT_AVAILABLE",
                "HUMAN_QA_NOT_RUN",
                "UI_ACCESSIBILITY_NOT_RUN",
                "MERGE_NOT_AUTHORIZED",
            ):
                self.assertIn(token, text)
        for token in (
            "run_afterlife_canon_v2_human_qa.ps1",
            "-Stage Prepare",
            "-Stage Launch",
            "-Stage Collect",
        ):
            self.assertIn(token, guide)
        self.assertIn("D-2026-08-05-AFTERLIFE-STATION-CANON-V2-MIGRATION-DESIGN", addendum)

    def test_windows_workflows_execute_runner_preflight(self) -> None:
        for workflow in (WINDOWS_WORKFLOW, MIGRATION_WORKFLOW):
            text = workflow.read_text(encoding="utf-8")
            for token in (
                "test_afterlife_canon_v2_local_human_qa_runner.py",
                "run_afterlife_canon_v2_human_qa.ps1",
                "-Stage Prepare",
                "-Stage Collect",
                "main_mvp039_recovery.json",
            ):
                self.assertIn(token, text)

    def test_green_evidence_records_validated_head_and_runs(self) -> None:
        evidence = EVIDENCE.read_text(encoding="utf-8")
        addendum = ADDENDUM.read_text(encoding="utf-8")
        for text in (evidence, addendum):
            self.assertIn(VALIDATED_IMPLEMENTATION_HEAD, text)
            for run_id in VALIDATED_RUNS:
                self.assertIn(run_id, text)
            self.assertIn("AUTOMATED_LOCAL_HUMAN_QA_RUNNER_PREFLIGHT_GREEN", text)
            self.assertNotIn("AUTOMATED_LOCAL_HUMAN_QA_RUNNER_PREFLIGHT_PENDING", text)
        for token in (
            "PREPARED",
            "EVIDENCE_COLLECTED",
            "ACTUAL_USER_SAVE_CONTENT_NOT_RECORDED",
            "LOCAL HUMAN QA RUNNER PREFLIGHT: PASS",
        ):
            self.assertIn(token, evidence)


if __name__ == "__main__":
    unittest.main()
