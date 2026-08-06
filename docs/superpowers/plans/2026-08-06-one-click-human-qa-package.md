# One-click Windows Human QA Package Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a repository-root `START_HUMAN_QA.cmd` flow that automatically discovers the local save and Godot 4.7.1, delegates safe copy/launch/collection to the existing runner, records explicit human judgments, and emits privacy-safe evidence.

**Architecture:** Keep `tools/qa/run_afterlife_canon_v2_human_qa.ps1` as the single authority for save copying, SHA-256 verification, isolated `APPDATA`, launch, and evidence collection. Add a thin Windows command entry point, one orchestration script, and one authoritative checklist JSON. CI exercises the complete non-interactive path with a fixture and real Godot version discovery without claiming visual QA passed.

**Tech Stack:** Windows CMD, Windows PowerShell 5.1, PowerShell 7, JSON, Python `unittest`, GitHub Actions `windows-latest`, Godot 4.7.1.

## Global Constraints

- The normal user path is one action: run repository-root `START_HUMAN_QA.cmd` after pulling `main`.
- The original saves are read-only inputs; no move, deletion, overwrite, or content upload is allowed.
- `tools/qa/run_afterlife_canon_v2_human_qa.ps1` remains the single authority for `Prepare`, `Launch`, and `Collect` save safety behavior.
- Godot auto-download, installation, permanent PATH changes, and arbitrary full-disk recursion are prohibited.
- Default accepted engine version is Godot `4.7.1`; other versions require explicit `-AllowVersionMismatch`.
- Human-observed items may only be `PASS`, `FAIL`, `BLOCKED`, or `NOT_RUN` and must never be auto-promoted to PASS.
- PowerShell 7 is preferred; Windows PowerShell 5.1 is the supported fallback.
- `.control`, isolated `AppData`, actual save content, and original absolute save paths are never shareable evidence.
- Product runtime, scenes, authored episode data, canon decisions, and reward values are out of scope.

---

## File Structure

- Create `START_HUMAN_QA.cmd`: double-clickable entry point, PowerShell host selection, exit-code preservation, optional pause suppression for CI.
- Create `tools/qa/start_afterlife_canon_v2_human_qa.ps1`: preflight, deterministic Godot discovery, orchestration, human checklist input, summary generation.
- Create `tools/qa/afterlife_canon_v2_human_qa_checklist.json`: authoritative ordered checklist and allowed statuses.
- Create `tests/test_afterlife_canon_v2_one_click_human_qa.py`: static contract, privacy boundary, state/classification, and workflow wiring tests.
- Create `tests/windows/run_afterlife_canon_v2_one_click_preflight.ps1`: fixture-based Windows integration test of the non-interactive complete flow.
- Create `docs/qa/2026-08-06-one-click-human-qa-package.md`: user-facing one-click guide and evidence-sharing boundary.
- Modify `.github/workflows/validate-afterlife-station-canon-v2-windows-platform-qa.yml`: trigger and run new contract/integration tests.
- Modify `.github/workflows/validate-afterlife-station-canon-v2-migration-design.yml`: include new files and contract in Ubuntu/Windows regression paths.
- Modify `docs/qa/2026-08-05-afterlife-canon-v2-local-human-qa-runner.md`: point normal users to the one-click entry while retaining expert three-stage instructions.
- Modify `docs/qa/2026-08-05-afterlife-canon-v2-local-human-qa-runner-evidence.md`: record exact implementation head and workflow evidence after GREEN.
- Modify PR #163 description as implementation evidence changes from `NOT_RUN` to exact RED/GREEN runs.

---

### Task 1: Establish RED contracts for the one-click package

**Files:**
- Create: `tests/test_afterlife_canon_v2_one_click_human_qa.py`
- Modify: `.github/workflows/validate-afterlife-station-canon-v2-windows-platform-qa.yml`
- Modify: `.github/workflows/validate-afterlife-station-canon-v2-migration-design.yml`

**Interfaces:**
- Consumes: repository paths and current three-stage runner contract.
- Produces: failing tests that define exact entry-point, orchestrator, checklist, summary, privacy, PowerShell compatibility, and CI requirements.

- [ ] **Step 1: Write the failing Python contract**

Create a `unittest.TestCase` that asserts the following files exist:

```python
ROOT_ENTRY = ROOT / "START_HUMAN_QA.cmd"
ORCHESTRATOR = ROOT / "tools/qa/start_afterlife_canon_v2_human_qa.ps1"
CHECKLIST = ROOT / "tools/qa/afterlife_canon_v2_human_qa_checklist.json"
WINDOWS_PREFLIGHT = ROOT / "tests/windows/run_afterlife_canon_v2_one_click_preflight.ps1"
GUIDE = ROOT / "docs/qa/2026-08-06-one-click-human-qa-package.md"
```

Assert the entry point contains `pwsh`, `powershell.exe`, `-ExecutionPolicy Bypass`, `%~dp0`, `%*`, and `exit /b`.

Assert the orchestrator contains:

```text
Resolve-GodotBinary
Test-GodotVersion
Show-HumanQaChecklist
Read-HumanQaResults
Write-HumanQaSummary
run_afterlife_canon_v2_human_qa.ps1
-Stage Prepare
-Stage Launch
-Stage Collect
HUMAN_QA_REVIEW_COMPLETE_PASS
HUMAN_QA_REVIEW_COMPLETE_FAIL
HUMAN_QA_REVIEW_BLOCKED
HUMAN_QA_INCOMPLETE
ACTUAL_USER_SAVE_CONTENT_NOT_RECORDED
```

Assert it does not contain `Invoke-WebRequest`, `Start-BitsTransfer`, `winget install`, `choco install`, `Move-Item`, or save JSON body serialization.

Parse the checklist JSON and assert exactly 18 unique IDs, four allowed statuses, and required items for `1280x720`, `1920x1080`, keyboard, gamepad, save restart, Validation isolation, protection obligations, termination preview, and independent result axes.

- [ ] **Step 2: Wire the RED test into both active workflows**

Add the new paths to both workflow `pull_request.paths` lists and execute:

```yaml
python -m unittest tests/test_afterlife_canon_v2_one_click_human_qa.py
```

On Windows also invoke the not-yet-created integration harness:

```yaml
./tests/windows/run_afterlife_canon_v2_one_click_preflight.ps1 -GodotBinary godot
```

- [ ] **Step 3: Push the test-only commit and verify RED**

Expected: the Python contract fails because `START_HUMAN_QA.cmd`, the orchestrator, checklist, guide, and Windows preflight do not exist. The failure must not come from unrelated existing tests.

- [ ] **Step 4: Record the exact RED workflow run IDs in PR #163**

Record the exact head SHA, failing test names, and both workflow run IDs before implementation.

- [ ] **Step 5: Commit**

```bash
git add tests/test_afterlife_canon_v2_one_click_human_qa.py .github/workflows/validate-afterlife-station-canon-v2-windows-platform-qa.yml .github/workflows/validate-afterlife-station-canon-v2-migration-design.yml
git commit -m "test: define one-click Human QA package contracts"
```

---

### Task 2: Add the authoritative checklist and CMD entry point

**Files:**
- Create: `tools/qa/afterlife_canon_v2_human_qa_checklist.json`
- Create: `START_HUMAN_QA.cmd`
- Test: `tests/test_afterlife_canon_v2_one_click_human_qa.py`

**Interfaces:**
- Produces: JSON object `{schema_version, allowed_statuses, items}` and a root entry point that calls `tools/qa/start_afterlife_canon_v2_human_qa.ps1` with all user arguments unchanged.

- [ ] **Step 1: Create the checklist data**

Use this schema:

```json
{
  "schema_version": 1,
  "allowed_statuses": ["PASS", "FAIL", "BLOCKED", "NOT_RUN"],
  "items": [
    {
      "id": "load_existing_save",
      "category": "migration",
      "title_ko": "기존 저장을 정상적으로 불러올 수 있다",
      "required": true
    }
  ]
}
```

Add all 18 ordered items from the approved design. IDs must be lower snake case and stable.

- [ ] **Step 2: Create the CMD entry point**

Implement:

```bat
@echo off
setlocal
chcp 65001 >nul
set "SCRIPT=%~dp0tools\qa\start_afterlife_canon_v2_human_qa.ps1"
where pwsh.exe >nul 2>nul
if %ERRORLEVEL% EQU 0 (
  pwsh.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT%" %*
) else (
  powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT%" %*
)
set "EXIT_CODE=%ERRORLEVEL%"
if not "%HUMAN_QA_NO_PAUSE%"=="1" pause
exit /b %EXIT_CODE%
```

- [ ] **Step 3: Run the focused Python contract**

Expected: checklist and entry-point assertions pass; orchestrator, guide, and integration assertions remain RED.

- [ ] **Step 4: Commit**

```bash
git add START_HUMAN_QA.cmd tools/qa/afterlife_canon_v2_human_qa_checklist.json tests/test_afterlife_canon_v2_one_click_human_qa.py
git commit -m "feat: add one-click QA entry and checklist"
```

---

### Task 3: Implement deterministic Godot and save preflight

**Files:**
- Create: `tools/qa/start_afterlife_canon_v2_human_qa.ps1`
- Test: `tests/test_afterlife_canon_v2_one_click_human_qa.py`

**Interfaces:**
- Parameters:

```powershell
param(
    [string]$GodotBinary,
    [string]$SourceMain,
    [string]$SourceValidation,
    [string]$QaRoot,
    [switch]$AllowVersionMismatch,
    [switch]$NonInteractive,
    [switch]$SkipLaunch,
    [ValidateSet('PASS','FAIL','BLOCKED','NOT_RUN')]
    [string]$DefaultChecklistStatus = 'NOT_RUN',
    [switch]$NoPause
)
```

- Produces:
  - `Resolve-GodotBinary([string]$ExplicitPath) -> string`
  - `Test-GodotVersion([string]$Path) -> ordered dictionary {path, raw, semantic, accepted}`
  - `Resolve-SourceSaves() -> ordered dictionary {main, validation}`
  - deterministic exit codes and no save mutation before `Prepare`.

- [ ] **Step 1: Add static tests for discovery precedence and version policy**

Assert the script contains explicit path, `GODOT_BINARY`, `Get-Command`, App Paths registry, bounded known roots, `--version`, `4.7.1`, and `AllowVersionMismatch`. Assert no `Get-ChildItem C:\ -Recurse` or automatic download command exists.

- [ ] **Step 2: Implement bounded discovery**

Discovery order:

1. `-GodotBinary`
2. `$env:GODOT_BINARY`
3. `Get-Command godot`, `godot4`, `Godot`
4. `HKCU:` and `HKLM:` App Paths entries for `Godot.exe`
5. repository-local `.tools/godot`, `%LOCALAPPDATA%\Programs`, `%USERPROFILE%\Downloads`, and `%USERPROFILE%\Desktop`, each with depth-limited direct/glob enumeration

Deduplicate with case-insensitive full paths on Windows. Never recurse across a whole drive.

- [ ] **Step 3: Implement version validation**

Run `& $candidate --version`, capture the first line, and match `4.7.1` with optional official suffix text. Reject mismatch unless `-AllowVersionMismatch` is present. Include only executable path and version in display output; do not display save contents.

- [ ] **Step 4: Implement save and repository preflight**

Infer repository root from `$PSScriptRoot\..\..`; require `project.godot` and the existing runner. Default saves:

```powershell
Join-Path $env:APPDATA "Godot\app_userdata\urban-legend\urban_legend_save.json"
Join-Path $env:APPDATA "Godot\app_userdata\urban-legend\urban_legend_validation_save.json"
```

Block with `BLOCKED_NO_MAIN_SAVE` when the main save is absent. Validation is optional. Default QA root is Desktop `urban-legend-qa\yyyyMMdd-HHmmss`.

- [ ] **Step 5: Run focused contracts**

Expected: entry point, checklist, discovery, version, and save-preflight assertions pass; complete-flow assertions remain RED.

- [ ] **Step 6: Commit**

```bash
git add tools/qa/start_afterlife_canon_v2_human_qa.ps1 tests/test_afterlife_canon_v2_one_click_human_qa.py
git commit -m "feat: add deterministic one-click QA preflight"
```

---

### Task 4: Implement Prepare, launch, checklist capture, Collect, and summary

**Files:**
- Modify: `tools/qa/start_afterlife_canon_v2_human_qa.ps1`
- Test: `tests/test_afterlife_canon_v2_one_click_human_qa.py`

**Interfaces:**
- Consumes existing runner commands:

```powershell
& $Runner -Stage Prepare -SourceMain $sourceMain -SourceValidation $sourceValidation -QaRoot $qaRoot
& $Runner -Stage Launch -QaRoot $qaRoot -GodotBinary $godot -RepoRoot $repoRoot -WaitForExit
& $Runner -Stage Collect -QaRoot $qaRoot
```

- Produces:
  - `<QA_ROOT>/.control/launcher-state.local.json`
  - `<QA_ROOT>/evidence/human-qa-summary.json`
  - `<QA_ROOT>/evidence/HUMAN_QA_SUMMARY.md`

- [ ] **Step 1: Add tests for state transitions and classification**

Assert states appear exactly:

```text
PREFLIGHT READY PREPARED LAUNCHED HUMAN_REVIEW_RECORDED EVIDENCE_COLLECTED COMPLETE
```

Assert failure states appear and all four final classification rules are encoded.

- [ ] **Step 2: Show checklist before launch**

`Show-HumanQaChecklist` reads and validates JSON schema/version/statuses and prints numbered Korean titles before `Launch`. Invalid or duplicate checklist IDs must stop before Prepare.

- [ ] **Step 3: Delegate Prepare and Launch**

Call the existing runner rather than reproducing copy/hash/APPDATA behavior. `-SkipLaunch` is legal only with `-NonInteractive`; this is the CI path and must classify every checklist item with `DefaultChecklistStatus`, default `NOT_RUN`.

- [ ] **Step 4: Capture human results after Godot exits**

For each item, accept empty input as `NOT_RUN`; otherwise loop until the input is one of the four allowed values. Optional notes are stored only in evidence output after rejecting obvious absolute Windows paths and lines longer than 500 characters. Do not serialize save content.

- [ ] **Step 5: Delegate Collect and generate summaries**

Read only the existing manifest/collection summary metadata. Count statuses and classify:

```powershell
if ($failCount -gt 0) { 'HUMAN_QA_REVIEW_COMPLETE_FAIL' }
elseif ($blockedCount -gt 0) { 'HUMAN_QA_REVIEW_BLOCKED' }
elseif ($notRunCount -gt 0) { 'HUMAN_QA_INCOMPLETE' }
else { 'HUMAN_QA_REVIEW_COMPLETE_PASS' }
```

The summary includes repository, exact HEAD, Godot version, original-unchanged booleans, item statuses, counts, and privacy warning. It must not include `source_path`, `qa_root` absolute source mapping, `.control` content, or save bodies.

- [ ] **Step 6: Run focused contracts**

Expected: all Python contract tests pass except missing Windows integration harness and guide.

- [ ] **Step 7: Commit**

```bash
git add tools/qa/start_afterlife_canon_v2_human_qa.ps1 tests/test_afterlife_canon_v2_one_click_human_qa.py
git commit -m "feat: orchestrate one-click Human QA flow"
```

---

### Task 5: Add Windows end-to-end preflight

**Files:**
- Create: `tests/windows/run_afterlife_canon_v2_one_click_preflight.ps1`
- Modify: `.github/workflows/validate-afterlife-station-canon-v2-windows-platform-qa.yml`
- Modify: `.github/workflows/validate-afterlife-station-canon-v2-migration-design.yml`
- Test: `tests/test_afterlife_canon_v2_one_click_human_qa.py`

**Interfaces:**
- Parameters:

```powershell
param([Parameter(Mandatory = $true)][string]$GodotBinary)
```

- Executes orchestrator with fixture, explicit QA root, `-NonInteractive -SkipLaunch -DefaultChecklistStatus NOT_RUN -NoPause`.

- [ ] **Step 1: Create the Windows harness**

Use `tests/fixtures/afterlife_migration/main_mvp039_recovery.json` as source. Record source SHA-256 before and after. Invoke:

```powershell
./tools/qa/start_afterlife_canon_v2_human_qa.ps1 `
  -GodotBinary $GodotBinary `
  -SourceMain $source `
  -QaRoot $qaRoot `
  -NonInteractive `
  -SkipLaunch `
  -DefaultChecklistStatus NOT_RUN `
  -NoPause
```

- [ ] **Step 2: Assert generated evidence**

Require:

```text
manifest.status == EVIDENCE_COLLECTED
collection-summary.source_main_unchanged == true
human-qa-summary.classification == HUMAN_QA_INCOMPLETE
human-qa-summary.counts.NOT_RUN == 18
```

Assert source SHA is unchanged and `.control` is not copied into `evidence`.

- [ ] **Step 3: Run the harness under both hosts**

On `windows-latest`, run once with `shell: pwsh` and once with `shell: powershell`. Pass the setup-godot `godot` executable explicitly.

- [ ] **Step 4: Run focused Windows workflow**

Expected: both PowerShell hosts pass, source hash remains unchanged, and no Human PASS classification is emitted.

- [ ] **Step 5: Commit**

```bash
git add tests/windows/run_afterlife_canon_v2_one_click_preflight.ps1 .github/workflows/validate-afterlife-station-canon-v2-windows-platform-qa.yml .github/workflows/validate-afterlife-station-canon-v2-migration-design.yml tests/test_afterlife_canon_v2_one_click_human_qa.py
git commit -m "test: add Windows one-click QA preflight"
```

---

### Task 6: Document the one-click user path and privacy boundary

**Files:**
- Create: `docs/qa/2026-08-06-one-click-human-qa-package.md`
- Modify: `docs/qa/2026-08-05-afterlife-canon-v2-local-human-qa-runner.md`
- Test: `tests/test_afterlife_canon_v2_one_click_human_qa.py`

**Interfaces:**
- Produces user-facing instructions that require only `git pull` and double-clicking `START_HUMAN_QA.cmd` for the normal path.

- [ ] **Step 1: Write the guide**

Include:

```text
Normal path: pull main -> close Godot -> run START_HUMAN_QA.cmd
```

Explain Godot selection, missing-save behavior, checklist values, result classifications, evidence location, and retry/resume behavior.

- [ ] **Step 2: Preserve expert instructions**

At the top of the old guide, direct normal users to the new one-click guide. Keep the existing `Prepare`, `Launch`, and `Collect` commands as expert/recovery documentation.

- [ ] **Step 3: Document sharing rules**

Explicitly list shareable files:

```text
evidence/manifest.json
evidence/collection-summary.json
evidence/human-qa-summary.json
evidence/HUMAN_QA_SUMMARY.md
```

Explicitly prohibit `.control/**`, `AppData/**`, original saves, and unreviewed logs.

- [ ] **Step 4: Run focused contracts**

Expected: all one-click Python contracts pass.

- [ ] **Step 5: Commit**

```bash
git add docs/qa/2026-08-06-one-click-human-qa-package.md docs/qa/2026-08-05-afterlife-canon-v2-local-human-qa-runner.md tests/test_afterlife_canon_v2_one_click_human_qa.py
git commit -m "docs: add one-click Human QA guide"
```

---

### Task 7: Full verification, evidence, and adversarial review

**Files:**
- Modify: `docs/qa/2026-08-05-afterlife-canon-v2-local-human-qa-runner-evidence.md`
- Modify: PR #163 description/commentary
- Optional create: `docs/audits/2026-08-06-one-click-human-qa-package-adversarial-review.md`

**Interfaces:**
- Produces exact validated head, workflow runs, test counts, residual risks, and merge gate status.

- [ ] **Step 1: Run focused tests**

```text
python -m unittest tests/test_afterlife_canon_v2_one_click_human_qa.py
python -m unittest tests/test_afterlife_canon_v2_local_human_qa_runner.py
python -m unittest tests/test_afterlife_canon_v2_windows_platform_qa.py
```

- [ ] **Step 2: Run Windows integration under PowerShell 7 and 5.1**

Expected: both passes with fixture source SHA unchanged and `HUMAN_QA_INCOMPLETE`.

- [ ] **Step 3: Run full repository gates**

Require PASS for:

- Canon v2 Migration Ubuntu and Windows jobs
- independent Windows Platform QA
- full Python matrix
- full Godot regression
- core/docs workflow
- Project Base Adapter

- [ ] **Step 4: Perform adversarial review**

Check at minimum:

- argument quoting for paths with spaces
- PowerShell 5.1 JSON/UTF-8 compatibility
- multiple Godot candidate selection
- false version acceptance/rejection
- missing main save and optional Validation behavior
- source/destination aliasing and QA root containment
- no full-drive recursion or network installation
- no absolute source path or save content in shareable evidence
- no automatic Human PASS from CI
- abnormal Godot exit and partial evidence handling
- dirty worktree warning without destructive cleanup
- all exception paths preserve existing runner `APPDATA` restoration

- [ ] **Step 5: Record exact evidence and residual boundary**

Set automated status only after exact-head GREEN:

```text
AUTOMATED_ONE_CLICK_HUMAN_QA_PACKAGE_GREEN
HUMAN_QA_NOT_RUN
UI_ACCESSIBILITY_NOT_RUN
MERGE_NOT_AUTHORIZED
```

Actual Windows visual/layout/gamepad/save-content judgment remains open until the user runs the package locally.

- [ ] **Step 6: Commit evidence**

```bash
git add docs/qa/2026-08-05-afterlife-canon-v2-local-human-qa-runner-evidence.md docs/audits/2026-08-06-one-click-human-qa-package-adversarial-review.md
git commit -m "docs: record one-click Human QA verification"
```

- [ ] **Step 7: Final PR gate**

Verify exact head, mergeability, no unresolved review threads, and all required checks. Keep PR Draft until the automated package is GREEN. Merge to `main` only under the user's already-recorded implementation direction and after the final evidence review shows no scope expansion or unresolved failure.
