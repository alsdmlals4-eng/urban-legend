# Main Addon and Canon Sync Recovery Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Convert the unreviewed GUT/UID state into an auditable adoption program by preserving HiGodot as the sole authoring authority, adopting GUT 9.7.1 as test-only authority, and blocking work entry when decision, unresolved, image-review, exact-HEAD, or validation evidence is incomplete.

**Architecture:** Keep PR #165 audit-only. Record the approved direction here, create a separate design branch and Draft PR for the GUT/authority/entry-gate specification, correct Google Sheet status overclaims, and leave product-path implementation for a later approval-gated PR. UID validation remains independent from GUT adoption.

**Tech Stack:** Markdown design contracts, JSON machine-readable ledgers, Python 3.12 `unittest`, Godot 4.7.1/GDScript, GUT 9.7.1 CLI/JUnit, GitHub Actions, Google Sheets.

## Global Constraints

- Do not merge without explicit exact-HEAD user approval.
- PR #165 remains audit-only and must not modify `project.godot`, `addons/`, runtime scripts, scenes, episode data, save schema, or assets.
- `UL-DEC-ADDON-001=ADOPT_GUT_9_7_1` is approved.
- GUT adoption phase is `TRIAL_APPROVED` until project tests, CLI, CI, and full regression pass on one exact HEAD.
- HiGodot is the sole authority that may author or mutate Godot scenes, nodes, resources, and project settings.
- GUT may discover, execute, assert, double, and export test results only.
- GUT must not rewrite product scenes, resources, `project.godot`, episode data, or save canon.
- Tests that require writes must use isolated temporary storage or `user://` test-only paths.
- A test run that changes protected tracked files fails the authority gate.
- Generic `READY` and `AWAITING` are invalid entry states without scope and evidence.
- Decision, unresolved, image-planning, image-review, exact-HEAD, CI, and Human QA surfaces must be evaluated together.
- Existing PR #164 evidence applies only to commit `47e4bff7ea66d6f6a3792afe846f8a5d9320e966`.
- UID changes are validated separately from GUT adoption.
- Human QA and UI accessibility remain `NOT_RUN` until actual local evidence exists.

---

## File Structure

### PR #165 audit branch

- Modify: `docs/audits/2026-08-06-main-addon-canon-sync-audit.md`
- Modify: `docs/superpowers/plans/2026-08-06-main-addon-canon-sync-recovery-plan.md`
- No product paths.

### Separate design branch

- Create: `docs/superpowers/specs/2026-08-06-higodot-gut-authority-and-entry-gate-design.md`
- Create: `docs/superpowers/plans/2026-08-06-gut-971-test-framework-and-entry-gate-implementation-plan.md`
- No product paths.

### Later implementation PR, not part of PR #165 or the design PR

- Create: `docs/operations/GODOT_TOOL_AUTHORITY_LEDGER.json`
- Create: `docs/operations/PROJECT_ENTRY_GATE.json`
- Create: `tools/governance/evaluate_project_entry_gate.py`
- Create: `tests/test_project_entry_gate_contract.py`
- Create: `tests/gut/test_validation_route_mapper.gd`
- Create: `.gutconfig.json`
- Create: `.github/workflows/validate-gut-test-authority.yml`
- Modify: `skills/PROJECT_BASE_ADAPTER.json`
- Modify: `docs/BASE_RULES_VERSION.md`
- Modify: entry-point status documents only after exact identity and release evidence are verified.

---

### Task 1: Record the approved direction in PR #165

**Files:**
- Modify: `docs/audits/2026-08-06-main-addon-canon-sync-audit.md`
- Modify: `docs/superpowers/plans/2026-08-06-main-addon-canon-sync-recovery-plan.md`
- Modify: PR #165 body

**Interfaces:**
- Consumes: user approval on 2026-08-06 KST.
- Produces: one audit truth: `ADOPT_GUT_9_7_1 / HIGODOT_AUTHORING / GUT_TEST_ONLY / ENTRY_GATE_DESIGN_APPROVED`.

- [x] **Step 1: Supersede `REMOVE_DEFER`**

Record:

```yaml
superseded_recommendation: REMOVE_DEFER
current_decision: ADOPT_GUT_9_7_1
gut_phase: TRIAL_APPROVED
```

- [x] **Step 2: Add the authority matrix**

Required contract:

```text
HiGodot -> author/edit/save Godot scenes, nodes, resources, project settings
GUT -> discover/run/assert/export tests
CI -> block authority violations and missing evidence
```

- [ ] **Step 3: Update PR #165 description**

The PR body must say the prior removal recommendation is superseded, product paths remain unchanged, and a separate design PR owns the adoption specification.

- [ ] **Step 4: Verify the PR diff**

Run through GitHub readback:

```text
expected changed files =
- docs/audits/2026-08-06-main-addon-canon-sync-audit.md
- docs/superpowers/plans/2026-08-06-main-addon-canon-sync-recovery-plan.md
```

Any product path means FAIL.

---

### Task 2: Verify and record GUT upstream evidence

**Files:**
- Create in design PR: `docs/superpowers/specs/2026-08-06-higodot-gut-authority-and-entry-gate-design.md`

**Interfaces:**
- Consumes: `bitwes/Gut` official repository and installed project files.
- Produces: exact source/version/license/compatibility record with honest verification limits.

- [x] **Step 1: Verify official branch and commit**

Record:

```yaml
upstream_repository: bitwes/Gut
upstream_branch: godot_4_7
upstream_commit: aeb5d4f3f7f0a6c9b5e178876d6c99b791fda605
upstream_commit_message: Version bump, documentation for 9.7.1 release (#847)
```

- [x] **Step 2: Verify version and compatibility**

Record:

```yaml
version: 9.7.1
compatible_godot: 4.7.x
project_target: 4.7.1
```

- [x] **Step 3: Verify bundled license**

Record:

```yaml
license: MIT
license_path: addons/gut/LICENSE.md
copyright: 2018 Tom "Butch" Wesley
```

- [ ] **Step 4: Keep full-tree identity honest**

Until a later implementation branch compares every installed `addons/gut/` file with upstream commit `aeb5d4f3...`, record:

```text
INSTALLED_TREE_MATCH = NOT_RUN
```

Do not infer full identity from `plugin.cfg` and `LICENSE.md` alone.

---

### Task 3: Create the separate design branch and Draft PR

**Files:**
- Create: `docs/superpowers/specs/2026-08-06-higodot-gut-authority-and-entry-gate-design.md`
- Create: `docs/superpowers/plans/2026-08-06-gut-971-test-framework-and-entry-gate-implementation-plan.md`

**Interfaces:**
- Consumes: audit findings, upstream evidence, Sheet actual-state readback.
- Produces: reviewable design-only Draft PR.

- [ ] **Step 1: Branch from current `main`**

```text
branch: agent/gut-971-test-authority-entry-gate-design-20260806
base: 47f1e86ea594c2f349d230b245192bae2de67eb0
```

- [ ] **Step 2: Write the design specification**

The specification must include:

1. authority matrix and forbidden actions;
2. source/version/license/Godot 4.7 compatibility;
3. `TRIAL_APPROVED -> ADOPTED_ACTIVE` lifecycle;
4. representative project consumption path;
5. CLI and JUnit contract;
6. CI protected-diff check;
7. removal/rollback procedure;
8. mandatory entry-gate inputs and blocking rules;
9. exact status vocabulary;
10. claim ceilings and Human QA separation.

- [ ] **Step 3: Write the TDD implementation plan**

The first representative test target is the pure, stable class:

```text
scripts/core/validation_route_mapper.gd
class_name ValidationRouteMapper
```

The planned test file is:

```text
tests/gut/test_validation_route_mapper.gd
```

- [ ] **Step 4: Open a Draft PR**

The Draft PR must state:

```text
DESIGN_ONLY
PRODUCT_PATHS_UNCHANGED
GUT_NOT_YET_ADOPTED_ACTIVE
CI_NOT_IMPLEMENTED
LOCAL_GODOT_NOT_RUN
MERGE_NOT_AUTHORIZED
```

---

### Task 4: Correct Google Sheet overclaims

**Files:**
- Update Sheet: `02_현재_확정결정`
- Update Sheet: `04_누락_충돌_감사`
- Update Sheet: `71_이미지기획_생성목록`
- Update Sheet: `72_이미지검수_승인로그`
- Update Sheet: `00_프로젝트_허브`, `01_작업순서`, `99_변경이력`

**Interfaces:**
- Consumes: actual rows read from all four authority surfaces.
- Produces: no generic current `READY/AWAITING`; explicit scope and blocker states.

- [ ] **Step 1: Correct historical decision READY states**

Use these normalization rules:

```text
old Draft/spec record + no current exact-head evidence
-> HISTORICAL_RECORD / NOT_CURRENT_ENTRY_AUTHORITY

approved canon + implementation not authorized
-> CANON_APPROVED / IMPLEMENTATION_NOT_AUTHORIZED

planning package available + Human QA not run
-> AUTOMATED_PACKAGE_AVAILABLE / HUMAN_QA_NOT_RUN
```

Do not delete historical evidence.

- [ ] **Step 2: Correct audit READY states**

Preserve explicit `NOT_BUILD_READY`. Convert historical generic readiness to scoped states such as:

```text
CHANGE_PROPOSAL_RECORDED / IMPLEMENTATION_NOT_AUTHORIZED
HISTORICAL_PREMERGE_PASS / NOT_CURRENT_MERGE_AUTHORITY
CANON_APPROVED / IMPLEMENTATION_NOT_AUTHORIZED
PLAN_RECORDED / EXECUTION_REQUIRES_CURRENT_GATE
```

- [ ] **Step 3: Normalize image planning states**

Rows with blank status must become explicit `PLANNED` or `BLOCKED` based on their own brief. Do not infer product readiness.

`UL-IMG-007` remains:

```text
PLANNING_WIREFRAME_REVIEWED / OPEN_P2 / NOT_PRODUCT_ASSET
```

- [ ] **Step 4: Normalize image review approval states**

Required corrections:

```text
UL-REV-INIT
-> BLOCKED_NO_IMAGE / REVIEW_NOT_STARTED / RUNTIME_NOT_RUN

UL-REV-STYLE-REF-001
-> REFERENCE_ONLY / PRODUCT_ASSET_APPROVAL_NOT_APPLICABLE

UL-REV-007-PRE
-> BRIEF_APPROVED / IMAGE_NOT_GENERATED / PRODUCT_APPROVAL_NOT_STARTED

R-2026-08-01-UL-IMG-007-VISUAL-REVIEW
-> PLANNING_WIREFRAME_REVIEWED / OPEN_P2 / PRODUCT_ASSET_NOT_APPROVED / RUNTIME_NOT_RUN
```

- [ ] **Step 5: Read back every changed range**

The change log must include exact ranges and the design PR head.

---

### Task 5: Specify the mandatory entry gate

**Files for later implementation:**
- Create: `docs/operations/PROJECT_ENTRY_GATE.json`
- Create: `tools/governance/evaluate_project_entry_gate.py`
- Create: `tests/test_project_entry_gate_contract.py`

**Interfaces:**
- Consumes: decision ledger export, unresolved audit export, image planning/review export, GitHub exact HEAD/PR/check evidence.
- Produces: exit code `0` only for scoped entry authorization; nonzero for blocked or incomplete evidence.

- [ ] **Step 1: Define allowed output states**

```text
ENTRY_ALLOWED_FOR_DOCS_ONLY
ENTRY_ALLOWED_FOR_TEST_IMPLEMENTATION
ENTRY_ALLOWED_FOR_PRODUCT_IMPLEMENTATION
ENTRY_BLOCKED_OPEN_P0_P1
ENTRY_BLOCKED_OPEN_DECISION
ENTRY_BLOCKED_IMAGE_EVIDENCE
ENTRY_BLOCKED_EXACT_HEAD_EVIDENCE
ENTRY_BLOCKED_AUTHORITY_CONFLICT
ENTRY_BLOCKED_HUMAN_QA
```

- [ ] **Step 2: Ban generic states**

The contract test must reject standalone:

```text
READY
AWAITING
CANON_READY
IMPLEMENTATION_PLAN_READY
AUTOMATED_PACKAGE_READY
```

when used as current entry authorization.

- [ ] **Step 3: Require all sources**

Missing decision, unresolved, image planning, image review, or GitHub evidence is a blocking error, not an empty-pass condition.

---

### Task 6: Specify GUT consumption and CI authority gate

**Files for later implementation:**
- Create: `tests/gut/test_validation_route_mapper.gd`
- Create: `.gutconfig.json`
- Create: `.github/workflows/validate-gut-test-authority.yml`
- Create: `docs/operations/GODOT_TOOL_AUTHORITY_LEDGER.json`

**Interfaces:**
- Consumes: GUT 9.7.1 and `ValidationRouteMapper`.
- Produces: repeatable GUT test result, JUnit artifact, protected-diff proof.

- [ ] **Step 1: Use a pure representative contract**

Planned assertions:

```text
SIT-001 + active -> OK / dialogue / dialogue_scene.tscn
SIT-004 + suspended -> OK / investigation / investigation_scene.tscn
SIT-003 + active -> NOT_AVAILABLE
unknown + active -> UNKNOWN_FLOW_STAGE
SIT-001 + completed -> INVALID_LIFECYCLE
```

- [ ] **Step 2: Use the official CLI path**

```bash
godot --headless -d -s --path "$PWD" addons/gut/gut_cmdln.gd \
  -gdir=res://tests/gut \
  -ginclude_subdirs \
  -gexit \
  -gjunit_xml_file=.artifacts/gut/junit.xml
```

- [ ] **Step 3: Enforce no-authoring diff**

Before and after GUT:

```bash
git status --short
git diff --exit-code -- project.godot addons scripts scenes assets data
```

Any tracked protected-path change fails the job.

- [ ] **Step 4: Keep lifecycle at `TRIAL_APPROVED`**

Only after exact-HEAD import, focused GUT, existing Python tests, full Godot regression, JUnit artifact, and no-authoring diff all pass may the ledger change to `ADOPTED_ACTIVE`.

---

### Task 7: Validate UID independently

**Files for later implementation:**
- Create: `docs/validation/GUT_AND_UID_RECOVERY_VALIDATION.md`

**Interfaces:**
- Consumes: Godot 4.7.1 and candidate implementation SHA.
- Produces: import and regression evidence independent of GUT adoption.

- [ ] **Step 1: Record versions and SHA**

```bash
git rev-parse HEAD
godot --version
python --version
```

- [ ] **Step 2: Run Godot import**

```bash
godot --headless --editor --quit --path .
```

- [ ] **Step 3: Run focused GUT and existing full regression**

Do not claim UID validity from GUT tests alone.

- [ ] **Step 4: Record any post-import diff**

Unexpected `.uid`, `.tscn`, `.tres`, `.gd`, or `project.godot` changes are blocking findings.

---

### Task 8: Final verification and handoff

**Files:**
- PR #165 metadata
- separate design PR metadata
- Google Sheet readback

**Interfaces:**
- Consumes: all previous task evidence.
- Produces: honest status report without merge.

- [ ] **Step 1: Verify PR #165 remains audit-only**
- [ ] **Step 2: Verify the design PR contains only two design/plan documents**
- [ ] **Step 3: Verify Sheet corrections by exact range readback**
- [ ] **Step 4: Verify no current standalone READY/AWAITING remains in the corrected current surfaces**
- [ ] **Step 5: Report current claim ceiling**

Expected ceiling:

```text
GUT_ADOPTED_BY_DECISION
GUT_TRIAL_APPROVED
HIGODOT_GUT_AUTHORITY_DESIGN_RECORDED
MANDATORY_ENTRY_GATE_DESIGN_RECORDED
SHEET_STATUS_OVERCLAIMS_CORRECTED
PRODUCT_IMPLEMENTATION_NOT_RUN
GUT_CI_NOT_RUN
INSTALLED_TREE_MATCH_NOT_RUN
UID_VALIDATION_NOT_RUN
HUMAN_QA_NOT_RUN
MERGE_NOT_AUTHORIZED
```
