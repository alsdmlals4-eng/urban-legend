# Afterlife Canon v2 Local Human QA Runner Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 실제 사용자 저장을 repository나 ChatGPT에 업로드하지 않고 Windows PC에서 복사본·SHA-256·격리 APPDATA·증거 디렉터리를 안전하게 준비하고, Godot 실행 전후 증거를 수집하는 로컬 Human QA runner를 제공한다.

**Architecture:** PowerShell runner는 원본 저장을 읽기 전용 입력으로 취급하고 QA 전용 폴더로 복사한 뒤 해시 일치를 검증한다. `Prepare`, `Launch`, `Collect` 단계는 분리되며, 자동 CI는 합성 fixture로 `Prepare`와 `Collect`의 안전 계약만 검증한다. 실제 화면·조작·Windows 10/11 판정은 계속 Human QA로 남는다.

**Tech Stack:** PowerShell 5.1+/7.x, Godot 4.7.1, Python unittest, GitHub Actions `windows-latest`, JSON, SHA-256.

## Global Constraints

- Decision ID는 `D-2026-08-05-AFTERLIFE-STATION-CANON-V2-MIGRATION-DESIGN`을 유지한다.
- 원본 저장 파일을 수정·이동·삭제하지 않는다.
- 저장 본문이나 개인정보를 repository·CI artifact·문서에 포함하지 않는다.
- 기본 QA 루트는 repository 밖 사용자 Desktop 아래에 생성한다.
- 명시적 `-QaRoot`는 CI나 사용자 지정 격리 경로에만 사용한다.
- `Prepare` 직후 원본과 QA 복사본 SHA-256이 다르면 `BLOCKED`로 종료한다.
- `Collect` 시 원본 SHA-256이 바뀌면 즉시 실패한다.
- 자동 상태는 `AUTOMATED_LOCAL_HUMAN_QA_RUNNER_PREFLIGHT_GREEN`으로만 기록한다.
- 실제 사용자 저장이 없으면 `ACTUAL_USER_SAVE_NOT_AVAILABLE`을 유지한다.
- 실제 UI·접근성·Windows 10/11 판정은 `HUMAN_QA_NOT_RUN`을 유지한다.
- 별도 승인 전 stacked PR은 Draft·미병합 상태를 유지한다.

---

### Task 1: Runner Contract RED

**Files:**
- Create: `tests/test_afterlife_canon_v2_local_human_qa_runner.py`
- Modify: `.github/workflows/validate-afterlife-station-canon-v2-migration-design.yml`

**Interfaces:**
- Consumes: 승인된 Human QA Plan과 Windows platform preflight 계약.
- Produces: runner·문서·workflow가 반드시 만족해야 하는 정적 계약.

- [ ] **Step 1: Write the failing test**

검증 항목:
- `tools/qa/run_afterlife_canon_v2_human_qa.ps1` 존재
- `Prepare`, `Launch`, `Collect` 단계
- `SourceMain`, `SourceValidation`, `QaRoot`, `GodotBinary`
- `Get-FileHash -Algorithm SHA256`
- source와 QA destination의 경로 분리
- 원본 해시 불변 확인
- `APPDATA` 저장·복원
- 익명 manifest와 저장 본문 비포함
- 실제 Human QA·병합 상태 분리

- [ ] **Step 2: Run test to verify it fails**

Run: `python -m unittest tests/test_afterlife_canon_v2_local_human_qa_runner.py`
Expected: runner·evidence 문서 부재로 FAIL.

- [ ] **Step 3: Commit RED**

```bash
git add tests/test_afterlife_canon_v2_local_human_qa_runner.py .github/workflows/validate-afterlife-station-canon-v2-migration-design.yml
git commit -m "test: define local Human QA runner contract"
```

### Task 2: Safe Local PowerShell Runner

**Files:**
- Create: `tools/qa/run_afterlife_canon_v2_human_qa.ps1`
- Create: `docs/qa/2026-08-05-afterlife-canon-v2-local-human-qa-runner-evidence.md`
- Modify: `docs/qa/2026-08-05-afterlife-canon-v2-human-qa-plan.md`

**Interfaces:**
- Consumes: source save paths and optional QA root.
- Produces: isolated APPDATA tree, anonymous `manifest.json`, hash files, launch log, collection summary.

- [ ] **Step 1: Implement `Prepare`**

- Resolve and validate source paths.
- Create timestamped QA root outside repository by default.
- Copy source to isolated `Godot/app_userdata/urban-legend`.
- Compare SHA-256 and write anonymous manifest.
- Never include save JSON body in manifest.

- [ ] **Step 2: Implement `Launch`**

- Require an existing manifest.
- Temporarily set `APPDATA` to the QA root.
- Launch Godot with exact repository path.
- Restore `APPDATA` in `finally`.

- [ ] **Step 3: Implement `Collect`**

- Re-hash original source and fail if changed.
- Hash QA before/after files and transaction artifacts.
- Write status `EVIDENCE_COLLECTED / HUMAN_REVIEW_REQUIRED`.
- Do not mark Human QA PASS automatically.

- [ ] **Step 4: Run static contract**

Run: `python -m unittest tests/test_afterlife_canon_v2_local_human_qa_runner.py`
Expected: PASS.

### Task 3: Windows CI Prepare/Collect Preflight

**Files:**
- Modify: `.github/workflows/validate-afterlife-station-canon-v2-windows-platform-qa.yml`
- Modify: `.github/workflows/validate-afterlife-station-canon-v2-migration-design.yml`

**Interfaces:**
- Consumes: representative `main_mvp039_recovery.json` fixture.
- Produces: Windows prepare/collect evidence proving source bytes remain unchanged.

- [ ] **Step 1: Add Windows runner invocation**

Run runner `Prepare` with a temporary QA root, then `Collect` without launching UI.

- [ ] **Step 2: Verify manifest**

Assert:
- status is `PREPARED` then `EVIDENCE_COLLECTED`
- source and copied SHA-256 match
- source path is outside QA destination
- source hash remains unchanged

- [ ] **Step 3: Run exact-head workflows**

Expected:
- Documentation PASS
- independent Windows PASS
- Migration Ubuntu+Windows PASS
- ANNUAL/Godot full regression PASS

### Task 4: Canon and Sheet Synchronization

**Files:**
- Modify: `docs/decisions/D-2026-08-05-AFTERLIFE-STATION-CANON-V2-MIGRATION-DESIGN.md`
- Modify: PR body
- Update linked Google Sheet with the same Decision ID.

**Interfaces:**
- Consumes: exact green HEAD and run IDs.
- Produces: canonical status and audit trail.

- [ ] **Step 1: Record status**

Use:

```text
AUTOMATED_LOCAL_HUMAN_QA_RUNNER_PREFLIGHT_GREEN
/ ACTUAL_USER_SAVE_NOT_AVAILABLE
/ HUMAN_QA_NOT_RUN
/ UI_ACCESSIBILITY_NOT_RUN
/ MERGE_NOT_AUTHORIZED
```

- [ ] **Step 2: Adversarial review**

Check privacy leakage, source mutation risk, path aliasing, APPDATA restoration, PowerShell 5.1 compatibility, and automatic/Human QA boundary.

- [ ] **Step 3: Update Draft PR and Sheet**

Record exact HEAD, CI runs, review ID, changed files, and remaining Human QA gates without changing Ready/merge state.

## Self-Review

- Spec coverage: source protection, isolated copy, hash evidence, local launch, evidence collection, CI preflight, status boundary covered.
- Placeholder scan: no TBD/TODO/implement-later markers.
- Type consistency: stages are exactly `Prepare`, `Launch`, `Collect`; status names are fixed above.
- Scope: no product runtime, scene, asset, reward, or migration semantics change.