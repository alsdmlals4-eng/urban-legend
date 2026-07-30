# Base v9.3 · Vertical Slice v9 Migration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 괴이기록국(urban-legend)의 canonical Base Adapter와 모든 소비처를 Base v9.3 및 Vertical Slice v9 계약으로 정렬하고, 제품 보호 경로와 프로젝트 고유 Skill을 무손실 보존한다.

**Architecture:** `skills/PROJECT_BASE_ADAPTER.json`만 수동 machine authority로 갱신하고 Snapshot·호환 Adapter·router·dashboard는 Base v9.3 생성기로 재생성한다. 사람용 문서는 canonical Adapter를 참조하도록 정리한다. Google Sheet는 migration PR에서 읽기 전용으로 유지하고, 병합된 main을 재조회한 뒤 별도 sync-close 단계에서 계약된 범위만 갱신한다.

**Tech Stack:** Git, GitHub, Python 3, `jsonschema`, Base v9.3 project operating tools, Markdown, JSON, Google Sheets, Godot 4.7 project contracts

## Global Constraints

- Project: `괴이기록국(urban-legend)`
- Repository: `alsdmlals4-eng/urban-legend`
- Issue: `#119`
- Branch: `chore/base-v9.3-vertical-slice-v9`
- Base version: `9.3.0`
- Base release commit: `30ca6c7b5f93521f0eb0eed42d01437cd43c50ae`
- Base evidence commit: `462a86db192d23d0f386281a1eb54b0a8cbad62e`
- Base Registry raw-byte SHA-256: `9847bb2b225c776ad7916930f0f48c490bc2a898bea8e02ea1fdd0e6caac60c1`
- Current platform: `PC_CURRENT`, 16:9, mouse and keyboard
- Future platform: `MOBILE_FUTURE_CONSIDERATION_NOT_IMPLEMENTED`
- Do not change `data/`, `scripts/`, `scenes/`, `assets/`, `addons/`, or `project.godot`.
- Do not change game rules, save Schema, IDs, episode data, economy, endings or character canon.
- Do not claim Godot runtime, device, accessibility or human validation without new evidence.
- Do not write a branch SHA to Google Sheets as CURRENT.
- Do not hand-edit generated compatibility views.

---

### Task 1: Lock the Application and Reconciliation Contract

**Files:**
- Create: `docs/superpowers/specs/2026-07-31-base-v9-3-vertical-slice-v9-migration-design.md`
- Create: `docs/superpowers/plans/2026-07-31-base-v9-3-vertical-slice-v9-migration.md`
- Create: `docs/goals/CODEX_GOAL_BASE_V9_3_VERTICAL_SLICE_V9.md`
- Create: `docs/vertical-slice/VERTICAL_SLICE_PROJECT_APPLICATION_v9.md`
- Create: `docs/vertical-slice/VERTICAL_SLICE_RECONCILIATION_PACKET_v9.md`

**Interfaces:**
- Consumes: Issue `#119`, Base v9.3 lock, current Adapter, current Google Sheet readback
- Produces: one approved implementation contract for Codex and reviewers

- [x] **Step 1: Create Issue #119 and the isolated branch**

Expected branch:

```text
chore/base-v9.3-vertical-slice-v9
```

- [x] **Step 2: Write the approved design and this implementation plan**

- [ ] **Step 3: Write the Codex Goal with the required first line**

The first line after the title must be:

```text
/goal Implement GitHub Issue #119 exactly as specified.
```

- [ ] **Step 4: Record the six required Vertical Slice reconciliation artifacts**

The reconciliation packet must include Baseline Recovery, Legacy Traceability, Source/Consumer Map, Finding Ledger, Readiness/Critical Gate and Approval Bundle/Change Plan.

- [ ] **Step 5: Commit the planning contract**

```bash
git add docs/superpowers/specs/2026-07-31-base-v9-3-vertical-slice-v9-migration-design.md \
        docs/superpowers/plans/2026-07-31-base-v9-3-vertical-slice-v9-migration.md \
        docs/goals/CODEX_GOAL_BASE_V9_3_VERTICAL_SLICE_V9.md \
        docs/vertical-slice/VERTICAL_SLICE_PROJECT_APPLICATION_v9.md \
        docs/vertical-slice/VERTICAL_SLICE_RECONCILIATION_PACKET_v9.md
git commit -m "docs: define Base v9.3 migration contract"
```

### Task 2: Add Failing v9.3 Contract Tests

**Files:**
- Create: `tests/test_base_v93_operating_contract.py`
- Modify: `tests/test_active_document_references.py`

**Interfaces:**
- Consumes: expected Base v9.3 pins and project route counts
- Produces: deterministic failure before Adapter and authority documents are updated

- [ ] **Step 1: Add the v9.3 Adapter pin test**

```python
from __future__ import annotations

import json
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ADAPTER = ROOT / "skills/PROJECT_BASE_ADAPTER.json"


class BaseV93OperatingContractTests(unittest.TestCase):
    def test_adapter_uses_released_base_v93_pins(self) -> None:
        adapter = json.loads(ADAPTER.read_text(encoding="utf-8"))
        self.assertEqual(adapter["base_release"]["version"], "9.3.0")
        self.assertEqual(
            adapter["base_release"]["release_commit"],
            "30ca6c7b5f93521f0eb0eed42d01437cd43c50ae",
        )
        self.assertEqual(
            adapter["base_release"]["release_evidence_commit"],
            "462a86db192d23d0f386281a1eb54b0a8cbad62e",
        )
        self.assertEqual(
            adapter["skill_registry"]["base"]["sha256"],
            "9847bb2b225c776ad7916930f0f48c490bc2a898bea8e02ea1fdd0e6caac60c1",
        )

    def test_project_identity_and_platform_boundary_are_explicit(self) -> None:
        project = json.loads(ADAPTER.read_text(encoding="utf-8"))["project"]
        self.assertEqual(project["name"], "괴이기록국(urban-legend)")
        self.assertEqual(project["platform_current"], ["PC"])
        self.assertEqual(project["platform_future_consideration"], ["MOBILE"])
        self.assertEqual(project["mobile_status"], "FUTURE_CONSIDERATION_NOT_IMPLEMENTED")

    def test_project_routes_and_protected_paths_are_preserved(self) -> None:
        adapter = json.loads(ADAPTER.read_text(encoding="utf-8"))
        self.assertEqual(len(adapter["routing"]["project_routes"]), 10)
        self.assertEqual(
            adapter["protected_paths"],
            ["data/", "scripts/", "scenes/", "assets/", "addons/", "project.godot"],
        )


if __name__ == "__main__":
    unittest.main()
```

- [ ] **Step 2: Add active-document assertions**

Assert that current authority documents reference `Base v9.3`, the v9 prompt and Issue #119, and do not present `VERTICAL_SLICE_INTEGRATED_EXECUTION_PROMPT_v8.md` as active.

- [ ] **Step 3: Run the focused tests and verify Red**

```bash
python -m unittest tests/test_base_v93_operating_contract.py tests/test_active_document_references.py -v
```

Expected: FAIL because the Adapter and human authority documents still declare v9.1/v8.

- [ ] **Step 4: Commit the Red tests**

```bash
git add tests/test_base_v93_operating_contract.py tests/test_active_document_references.py
git commit -m "test: require Base v9.3 project binding"
```

### Task 3: Upgrade the Canonical Adapter

**Files:**
- Modify: `skills/PROJECT_BASE_ADAPTER.json`
- Preserve: `skills/PROJECT_LOCAL_SKILL_REGISTRY.json`
- Preserve: `skills/disciplines/**`
- Preserve: `.agents/skills/urban-legend-investigation-case-authoring/**`

**Interfaces:**
- Consumes: Base v9.3 lock and current project route/protection policy
- Produces: canonical v9.3 machine authority

- [ ] **Step 1: Prepare exact repositories and baseline values**

```bash
export PROJECT_ROOT="$(git rev-parse --show-toplevel)"
export BASE_ROOT="$(dirname "$PROJECT_ROOT")/Base-v9.3"
export PR_BASE_SHA="$(git merge-base HEAD origin/main)"

if [ ! -d "$BASE_ROOT/.git" ]; then
  git clone https://github.com/alsdmlals4-eng/Base.git "$BASE_ROOT"
fi

git -C "$BASE_ROOT" fetch origin
git -C "$BASE_ROOT" checkout --detach 30ca6c7b5f93521f0eb0eed42d01437cd43c50ae
test "$(git -C "$BASE_ROOT" rev-parse HEAD)" = "30ca6c7b5f93521f0eb0eed42d01437cd43c50ae"
test "$PR_BASE_SHA" = "656846865eb88871d00842a0da527ce1b0722b77"
```

If `origin/main` has moved, stop and update Issue #119, the Baseline Recovery Record and expected PR base before editing.

- [ ] **Step 2: Update only canonical Adapter fields**

Set:

```json
{
  "base_release": {
    "repository": "alsdmlals4-eng/Base",
    "version": "9.3.0",
    "release_commit": "30ca6c7b5f93521f0eb0eed42d01437cd43c50ae",
    "release_evidence_commit": "462a86db192d23d0f386281a1eb54b0a8cbad62e"
  },
  "project": {
    "repository": "alsdmlals4-eng/urban-legend",
    "engine": "Godot 4.7",
    "root": ".",
    "name": "괴이기록국(urban-legend)",
    "platform_current": ["PC"],
    "platform_future_consideration": ["MOBILE"],
    "mobile_status": "FUTURE_CONSIDERATION_NOT_IMPLEMENTED",
    "display_contract": {
      "aspect_ratio": "16:9",
      "verification_resolutions": ["1280x720", "1920x1080"],
      "primary_input": ["MOUSE", "KEYBOARD"]
    }
  }
}
```

Also set:

```text
skill_registry.base.sha256 = 9847bb2b225c776ad7916930f0f48c490bc2a898bea8e02ea1fdd0e6caac60c1
protected_baseline.commit = 656846865eb88871d00842a0da527ce1b0722b77
protected_baseline.authority_kind = GITHUB_PR_BASE
protected_baseline.authority_ref = github.event.pull_request.base.sha
```

Keep `policy_source_type`, `policy_source_path`, `protected_paths_pointer`, `policy_sha256`, project Registry hash, routes, overrides, compatibility mapping and protected paths unchanged unless Base validation reports an exact incompatibility.

Set the pre-merge Sheet state explicitly:

```json
{
  "sync_status": "BLOCKED",
  "declared_sync_status": "SYNCED_AT_BASE_V9_1",
  "reconciliation_state": "BASE_V9_3_MERGE_AND_MAIN_READBACK_REQUIRED",
  "last_verified_project_main": "656846865eb88871d00842a0da527ce1b0722b77",
  "write_policy": "NO_AUTOMATIC_OVERWRITE",
  "sheet_only_change_policy": "PROPOSED_SHEET_CHANGE"
}
```

- [ ] **Step 3: Run the focused Adapter tests**

```bash
python -m unittest tests/test_base_v93_operating_contract.py -v
```

Expected: PASS.

- [ ] **Step 4: Commit the canonical Adapter**

```bash
git add skills/PROJECT_BASE_ADAPTER.json
git commit -m "chore: pin project operating contract to Base v9.3"
```

### Task 4: Regenerate Machine Views

**Files:**
- Regenerate: `skills/PROJECT_SKILL_SNAPSHOT.json`
- Regenerate: `skills/BASE_V9_ADAPTER.json`
- Regenerate: `skills/PROJECT_BASE_SKILL_ADAPTER.json`
- Regenerate: `skills/PROJECT_PATH_ADAPTER.json`
- Regenerate: `.agents/skills/urban-legend-workflow-router/SKILL.md`
- Regenerate: `docs/PROJECT_OPERATING_DASHBOARD.html`
- Verify: `docs/PROJECT_OPERATING_HEALTH.json`

**Interfaces:**
- Consumes: canonical Adapter and Base v9.3 repository
- Produces: byte-reproducible generated consumers

- [ ] **Step 1: Generate all operating artifacts**

```bash
python "$BASE_ROOT/tools/build_project_operating_artifacts.py" \
  --project-root "$PROJECT_ROOT" \
  --base-repository "$BASE_ROOT" \
  --protected-base "$PR_BASE_SHA" \
  --write
```

- [ ] **Step 2: Check generated artifacts immediately**

```bash
python "$BASE_ROOT/tools/build_project_operating_artifacts.py" \
  --project-root "$PROJECT_ROOT" \
  --base-repository "$BASE_ROOT" \
  --protected-base "$PR_BASE_SHA" \
  --check
```

Expected: `Project operating generated artifacts are current`.

- [ ] **Step 3: Validate the full project operating contract**

```bash
python "$BASE_ROOT/tools/check_project_operating_contract.py" \
  --project-root "$PROJECT_ROOT" \
  --base-repository "$BASE_ROOT" \
  --protected-base "$PR_BASE_SHA" \
  --check
```

Expected: `Project operating contract validation passed`.

- [ ] **Step 4: Verify route preservation**

```bash
python -m unittest tests/test_base_v91_local_skill_routes.py tests/test_base_v93_operating_contract.py -v
```

Expected: 10 active project routes and no project Skill loss.

- [ ] **Step 5: Commit generated views**

```bash
git add skills/PROJECT_SKILL_SNAPSHOT.json \
        skills/BASE_V9_ADAPTER.json \
        skills/PROJECT_BASE_SKILL_ADAPTER.json \
        skills/PROJECT_PATH_ADAPTER.json \
        .agents/skills/urban-legend-workflow-router/SKILL.md \
        docs/PROJECT_OPERATING_DASHBOARD.html \
        docs/PROJECT_OPERATING_HEALTH.json
git commit -m "chore: regenerate Base v9.3 operating views"
```

### Task 5: Repair Human-Facing Authority and Consumers

**Files:**
- Modify: `docs/BASE_RULES_VERSION.md`
- Modify: `docs/BASE_V9_ADOPTION_AUDIT.md`
- Modify: `skills/SKILL_REGISTRY.json`
- Modify: `AGENTS.md`
- Modify: `docs/DOCUMENTATION_MAP.md`
- Modify: `docs/CURRENT_STATUS.md`
- Modify: `docs/PROJECT_CORE.md`

**Interfaces:**
- Consumes: validated v9.3 Adapter and generated views
- Produces: one consistent human navigation and status model

- [ ] **Step 1: Replace stale Base authority statements**

Document exact v9.3 release/evidence/Registry pins and make the canonical Adapter the machine authority. Remove active claims that Base v8 or the old 25-Skill index controls execution.

- [ ] **Step 2: Preserve legacy material without active authority**

Keep `VERTICAL_SLICE_INTEGRATED_EXECUTION_PROMPT_v8.md` and old indexes as `SUPERSEDED_COMPATIBILITY` or historical references. Do not delete them.

- [ ] **Step 3: Record platform scope**

Update the human authority to state:

```text
Current: PC 16:9, mouse and keyboard
Future consideration: mobile
Status: not designed, implemented or validated in this Issue
```

- [ ] **Step 4: Reconcile current state documents**

Remove already-merged work from the future gate and record Base v9.3 migration as an operating-system-only change. Keep ANNUAL-MVP-002 human/new-player validation as `NOT_RUN` and do not approve ANNUAL-MVP-003.

- [ ] **Step 5: Run active reference tests**

```bash
python -m unittest tests/test_active_document_references.py tests/test_base_operating_sync.py -v
```

- [ ] **Step 6: Commit human authority repair**

```bash
git add docs/BASE_RULES_VERSION.md \
        docs/BASE_V9_ADOPTION_AUDIT.md \
        skills/SKILL_REGISTRY.json \
        AGENTS.md \
        docs/DOCUMENTATION_MAP.md \
        docs/CURRENT_STATUS.md \
        docs/PROJECT_CORE.md
git commit -m "docs: align project authority with Base v9.3"
```

### Task 6: Run Independent Verification and Open the Implementation PR

**Files:**
- Verify all changed files
- Update: `docs/vertical-slice/VERTICAL_SLICE_RECONCILIATION_PACKET_v9.md`

**Interfaces:**
- Consumes: all migration changes
- Produces: reviewable evidence and explicit remaining gaps

- [ ] **Step 1: Run focused operating tests**

```bash
python -m unittest \
  tests/test_base_v93_operating_contract.py \
  tests/test_base_v91_local_skill_routes.py \
  tests/test_base_operating_sync.py \
  tests/test_skill_package_integrity.py \
  tests/test_active_document_references.py \
  tests/test_archive_retention_governance.py -v
```

- [ ] **Step 2: Run the full Python suite**

```bash
python -m unittest discover -s tests -p 'test_*.py' -v
```

- [ ] **Step 3: Verify formatting and protected boundaries**

```bash
git diff --check origin/main...HEAD

git diff --name-only origin/main...HEAD -- \
  data scripts scenes assets addons project.godot
```

Expected protected-boundary output: empty.

- [ ] **Step 4: Re-run Base generation and contract validation in check mode**

```bash
python "$BASE_ROOT/tools/build_project_operating_artifacts.py" \
  --project-root "$PROJECT_ROOT" \
  --base-repository "$BASE_ROOT" \
  --protected-base "$PR_BASE_SHA" \
  --check

python "$BASE_ROOT/tools/check_project_operating_contract.py" \
  --project-root "$PROJECT_ROOT" \
  --base-repository "$BASE_ROOT" \
  --protected-base "$PR_BASE_SHA" \
  --check
```

- [ ] **Step 5: Perform adversarial review**

Check specifically for:

- duplicated machine authority
- v8/v9.1 active references
- lost local routes
- generated-view hand edits
- protected-path changes
- pre-merge Sheet writes
- unsupported maturity promotion
- accidental mobile implementation scope

- [ ] **Step 6: Update the reconciliation packet with actual evidence**

Every test must be recorded as `PASS`, `FAIL` or `NOT_RUN`; never infer Godot/runtime/device/human results.

- [ ] **Step 7: Push and update the Draft PR**

```bash
git push -u origin chore/base-v9.3-vertical-slice-v9
```

The PR must remain Draft until all P1 findings, generated drift, review threads and required checks are resolved.

### Task 7: Merge-Then-Sync Closeout

**Files:**
- Google Sheet ranges only
- Follow-up GitHub status update when needed

**Interfaces:**
- Consumes: merged migration commit from `main`
- Produces: synchronized Sheet summary and closed Gate

- [ ] **Step 1: Re-read merged main**

```bash
git fetch origin main
export MERGED_MAIN_SHA="$(git rev-parse origin/main)"
git show --stat --oneline "$MERGED_MAIN_SHA"
```

- [ ] **Step 2: Re-read the Sheet before writing**

Read exact current values from:

```text
00_프로젝트_허브
04_누락_충돌_감사
05_GDD_요약
99_변경이력
```

- [ ] **Step 3: Update only contracted fields**

Record Base v9.3 pins, merged main SHA, migration result, `PC_CURRENT`, `MOBILE_FUTURE_CONSIDERATION_NOT_IMPLEMENTED`, and remaining `runtime/device/human NOT_RUN` status.

- [ ] **Step 4: Re-read updated ranges**

The readback must match the intended values exactly. Any mismatch leaves the Sheet state `BLOCKED_UNVERIFIED`.

- [ ] **Step 5: Close Issue #119 only after GitHub and Sheet agree**

Do not close the Issue merely because the PR merged.

## Completion Boundary

This plan completes only the Base v9.3 operating migration and post-merge Sheet reconciliation. It does not complete a new gameplay Vertical Slice, mobile support, Godot runtime validation, device testing, accessibility testing or human/new-player validation.