# Current Handoff — 2026-08-12

> 상태: `PHASE_C_IMPLEMENTATION_PAUSED_FOR_HANDOFF / PR198_TDD_RED_VERIFIED / LOCAL_EXECUTOR_BOOTSTRAP_IN_PROGRESS / CODEX_NOT_STARTED / PRODUCT_RUNTIME_UNCHANGED`
> 현재 대상: `alsdmlals4-eng/urban-legend + alsdmlals4-eng/Base`
> 역할: 다음 세션이 과거 대화나 과거 PID/session을 신뢰하지 않고 live GitHub + Sheet + exact local receipt를 다시 읽어 안전하게 재개하기 위한 continuation router.

## 1. Live Authority

```yaml
last_updated_kst: 2026-08-12T01:37+09:00
continuation_checkpoint:
  state_observed_at_main: 6f84b68ee2c9e34c207f44d56aa251d0287e78a7
  self_merge_sha_required_in_file: false
  resume_rule: FETCH_LATEST_MAIN_BEFORE_USE
project:
  repo: alsdmlals4-eng/urban-legend
  default_branch: main
  current_main_source: READ_GITHUB_MAIN_REF_ON_RESUME
  primary_active_pr: 198
  primary_active_pr_head: 2830c8978de46bc2801bd12a63a490b26b803ee9
base:
  repo: alsdmlals4-eng/Base
  default_branch: main
  last_observed_main: 1d6cc79ae95ffb67ba4de618f010a6540fc6e02c
  dedicated_execution_owner_commit: 6d2feba2bc49fda2d8d273248b55087853615d5d
sheet:
  decision_row: "02_현재_확정결정!116"
  decision_id: D-2026-08-11-CASE01-UI-I18N-RESPONSIVE-LOCAL-ISOLATION
  freshness_note: "row K still says Base latest 6d2feba; live Base main is newer and must be re-read"
continuous_work:
  exact_base_trigger_present: false
  note: "current user explicitly authorized uninterrupted handoff/merge work, but this is not labeled CONTINUOUS_WORK_ACTIVE because the exact [연속작업] 진행해 trigger was not used"
```

GitHub, Google Sheet, exact worktree/receipt가 이 파일과 충돌하면 live authority가 우선한다. 이 파일 안의 SHA/PID/session 값은 locator 또는 관찰시점 증거이며 현재 실행 권한 자체가 아니다.

## 2. Active CASE-01 Decisions

- `D-2026-08-11-LUME-INTEGRATED-COMPANION-NO-LOG-TAB`
- `D-2026-08-11-CASE01-RECORDS-TAB-ARCHIVE-IA`
- `D-2026-08-11-CASE01-MANUAL-FIVE-SECTION-THREE-CHAPTER-MAPPING`
- `D-2026-08-11-CASE01-UI-RUNTIME-PROJECTION-MAPPING`
- `D-2026-08-11-CASE01-MANUAL-KEYWORD-INPUT-CONTRACT`
- `D-2026-08-11-CASE01-LANDSCAPE-SAME-COMPOSITION-UI`
- `D-2026-08-11-CASE01-SHARED-LOCATION-TRAVEL-CONTRACT`
- `D-2026-08-11-CASE01-FIELD-INVESTIGATION-SURFACE-CONTRACT`
- `D-2026-08-11-CASE01-UI-SEPARATION-SPEC-APPROVED`
- `D-2026-08-11-CASE01-UI-I18N-RESPONSIVE-LOCAL-ISOLATION`

Planning contract is v4.5/r2. Exact `기획 완료` was received on 2026-08-11 KST, so Phase C implementation is authorized subject to TDD + HiGodot authority and the protected-scope constraints below.

## 3. PR #198 — Current Implementation Frontier

```yaml
pr: 198
state: OPEN_DRAFT
remote_branch: agent/case01-investigation-device-ui-implementation-20260811
current_pr_head: 2830c8978de46bc2801bd12a63a490b26b803ee9
red_evidence_head: 076974644c38f059448a3afdd04279c6e942d171
base_main: 6f84b68ee2c9e34c207f44d56aa251d0287e78a7
product_runtime: UNCHANGED
human_ui_qa: NOT_RUN
android: NOT_RUN
```

`red_evidence_head`와 `current_pr_head`를 혼동하지 않는다. RED evidence head에서 기존 4개 baseline은 PASS했고 신규 4개 계약은 의도한 기능 부재로 RED였다.

Current intended REDs:

1. `case01_device_model_test.gd` → `scripts/ui/case01_device_data_adapter.gd` 부재
2. `case01_device_shell_contract_test.gd` → `scenes/ui/case01_investigative_device_shell.tscn` 부재
3. `case01_manual_draft_state_test.gd` → `apply_afterlife_manual_draft` 부재
4. `case01_shared_travel_test.gd` → `scripts/ui/case01_travel_session.gd` 부재

Focused summary: `CASE-01 UI contracts RED: 4/4 failing`.

Protected by default:

- `scripts/core/game_state.gd`
- `project.godot`
- `data/episodes/**`
- Lume product image before `PROJECT_ASSET_APPROVED`
- player-facing `[로그]` / `AI 로그`
- pre-reveal correctness/proximity/slot-fitness/mutation leakage

## 4. PR Influence Map

| PR | Current disposition | Handoff relevance |
|---|---|---|
| #198 | `IN_PROGRESS / DRAFT / TDD_RED_VERIFIED` | CASE-01 Phase C owner. Do not merge while intentionally RED. |
| #196 | `OPEN_DRAFT / OVERLAP_RISK` | Changes protected `scripts/core/game_state.gd`; recheck before any PR198 persistent mutation. |
| #193 | `OPEN_DRAFT / ROUTER_FRESHNESS` | Changes `START_HERE.md` + `docs/DOCUMENTATION_MAP.md`; separate from this handoff owner. |
| #192 | `OPEN_DRAFT / REFERENCE_AUDIT` | Canon freshness evidence; no product mutation. |
| #191 | `STALE_HANDOFF / SUPERSEDE` | Changes this same `docs/CURRENT_HANDOFF.md` from older base/state. Do not merge after this handoff lands. |
| #190 | `OPEN_DRAFT / SAFE_RETURN_PLAN` | Gameplay→Main Menu plan owner; separate Decision scope. |
| #189 | `OPEN_DRAFT / RED_OVERLAP_RISK` | Changes Canon v2 overlay test used by PR198 baseline; fresh baseline required if it moves/merges. |
| #186 | `OPEN_DRAFT / HELD` | Route endpoint implementation; separate blocker/QA frontier. |
| #183 | `OPEN_DRAFT / HELD` | Main Menu Ver 4.3; separate Human/input/Android gates. |

Do not rewrite, merge, close, or absorb unrelated open PRs merely to simplify PR198. The only stale PR intentionally superseded by this handoff is #191 because it owns the same continuation file with older facts.

## 5. Local Executor State at Pause

```yaml
execution_worktree: C:\Users\user\Documents\GitHub\Ninza\urban-legend.codex-isolated\pr198-exec
local_execution_branch: local/case01-pr198-exec-20260812
expected_head: 2830c8978de46bc2801bd12a63a490b26b803ee9
old_contaminated_worktree: C:\Users\user\Documents\GitHub\Ninza\urban-legend.codex-isolated\pr198
dedicated_godot: C:\Users\user\Tools\Godot-URBAN-LEGEND-4.7.1\Godot-URBAN-LEGEND-4.7.1.exe
godot_version: 4.7.1.stable.official.a13da4feb
self_contained_marker: _sc_
editor_settings: editor_data/editor_settings-4.7.tres
higodot_http: 8004
higodot_ws: 9504
godot_ai_expected: 3.1.2
godot_ai_mode: dev
hera: LOCAL_LIVE_QA_TOOLING_EXPECTED
codex: NOT_STARTED
local_executor_ready: NOT_CLAIMED
```

The old `pr198` worktree was contaminated by a failed Godot AI self-update attempt and must be preserved for diagnosis; do not `reset`, `restore`, `clean`, or copy its changed addon state into `pr198-exec`.

Latest Git diagnosis before handoff used representative tracked file `addons/gut/fonts/AnonymousPro-Bold.ttf.import` and observed:

```text
INDEX    = 23867ed44fa29a70a38d9a9dc8128d28059c437a
RAW      = 23867ed44fa29a70a38d9a9dc8128d28059c437a
FILTERED = 23867ed44fa29a70a38d9a9dc8128d28059c437a
git diff --quiet       = 0
git diff-files --quiet = 1
porcelain v2            = .M
```

This proves the representative file is content-identical while low-level/index stat state still reports dirty. Earlier observation counted 111 tracked `.import` entries, but **the all-111 index/raw/filtered hash gate has NOT_RUN**. Do not promote the representative proof to a full-worktree clean claim.

## 6. Troubleshooting Lessons — Current Applicable Set

### LESSON-UL-EXEC-001 — Godot editor settings filename is major.minor scoped

- symptom: bootstrap searched `editor_settings-4.tres` and failed even though self-contained initialization succeeded.
- root cause: Godot 4.7.1 generated `editor_settings-4.7.tres`.
- fast recovery: derive settings filename from the running Godot major.minor; inspect `editor_data` before declaring absence.
- prevention/action: handoff/bootstrap must not hardcode `editor_settings-4.tres`.
- knowledge state: `VALIDATED_PATTERN` for this project/toolchain.

### LESSON-UL-EXEC-002 — One pasted bootstrap must be one terminating ScriptBlock

- symptom: a `throw` occurred but later pasted commands still ran and printed a false READY state.
- root cause: sequential interactive PowerShell input, not one atomic `& { ... }` block.
- fast recovery: new PowerShell → one whole `& { ... }` block → any failure aborts before READY/Codex launch.
- knowledge state: `VALIDATED_PATTERN`.

### LESSON-UL-EXEC-003 — `$Pid` collides with PowerShell `$PID`

- symptom: helper function failed before HiGodot receipt validation.
- root cause: PowerShell variable names are case-insensitive and `$PID` is a read-only automatic variable.
- fast recovery: use `$ProcessId` or another explicit parameter name.
- knowledge state: `VALIDATED_PATTERN`.

### LESSON-UL-EXEC-004 — HiGodot self-update/local runtime state must be isolated

- symptom: old worktree Godot AI 3.1.2 self-updated to 3.1.4, dirtying `addons/godot_ai/**`, `.import`, and local `project.godot` tooling state.
- resolution: dedicated self-contained Godot + isolated APPDATA/LOCALAPPDATA/TEMP + `godot_ai/mode_override = "dev"` + reserved 8004/9504.
- fast recovery: preserve contaminated worktree, create exact-head execution worktree, never clean unknown user/tool state destructively.
- knowledge state: `VALIDATED_PATTERN`.

### LESSON-UL-EXEC-005 — Separate content identity from stat-only Git dirtiness

- symptom: `git status` / `git diff-files` report `.M`/modified while representative index/raw/path-filtered blob hashes are identical and porcelain `git diff` is empty.
- root cause class: `STAT_ONLY_OR_INDEX_METADATA_DIRTINESS`; exact all-file classification still requires per-file hash verification.
- failed approaches: treating `status` alone as semantic dirtiness; trying EOL overrides and `--really-refresh` as if they proved content change.
- fast recovery: staged diff → index blob → raw working blob → path-filtered blob → porcelain content diff → attributes/filter context. Never destructively clean before classification.
- owner: current handoff + project execution workflow; reusable Base principle may be proposed separately.
- knowledge state: `PATTERN` pending all-relevant-file verification.

## 7. Project Learning Closure

```yaml
LRN-UL-2026-08-12-001:
  classification: SPLIT
  project_application: APPLIED_TO_CURRENT_HANDOFF_AND_RESUME_GATES
  project_verification: HANDOFF_PR_EXACT_HEAD_REQUIRED
  common_principle: CONTENT_IDENTITY_MUST_BE_SEPARATED_FROM_LOW_LEVEL_STAT_DIRTINESS
  base_proposal: PENDING_CONCURRENT_SAFE_EXISTING_SOLUTION_CHECK
  closure: OPEN_UNTIL_PROJECT_HANDOFF_AND_BASE_PROPOSAL_LIFECYCLE_COMPLETE

LRN-UL-2026-08-12-002:
  classification: PROJECT_ONLY
  project_application: DEDICATED_GODOT_4_7_1_HIGODOT_8004_9504_HERA_CODEX_HOME_RESUME_CONTRACT
  project_verification: LOCAL_EXECUTOR_READY_NOT_YET_PROVEN
  base_proposal: N/A
  closure: OPEN_UNTIL_RESUME_RECEIPT
```

Existing Solution First for project handoff/workflow: `REUSE`. Existing owners are `docs/CURRENT_HANDOFF.md`, the project Production/PM handoff route, and the adopted Base handoff/validation support skills. No new project Skill is justified for this pause.

## 8. Base State / Proposal Boundary

```yaml
base_main_observed: 1d6cc79ae95ffb67ba4de618f010a6540fc6e02c
bcp_014:
  proposal_id: BCP-2026-014-handoff-machine-consumer-compatibility-closeout
  status: IMPLEMENTED
  implementation_pr: 260
new_base_candidate:
  topic: local executor content-identity vs stat-only dirty classification
  existing_solution_verdict: ABSORB_CANDIDATE
  proposal_identity: NOT_ALLOCATED_YET
  concurrency_rule: RECHECK_LATEST_BASE_MAIN_REGISTRY_AND_OPEN_PROPOSAL_PRS_BEFORE_ANY_BASE_WRITE
base_active_implementation_in_this_handoff: FORBIDDEN
```

The old handoff statement `BCP-2026-014 = SUBMITTED / implementation NOT_STARTED` is stale. Base proposal-only work for the new lesson, if still non-duplicate after the final race check, must modify only `[수정제안서]/**`; Base active Skill/Docs/Template/Test/Tool/Workflow implementation is a separate future stage.

## 9. Verification Boundary

```yaml
pr198_red_evidence: PASS_AS_INTENDED_RED
pr198_current_product_green: NOT_RUN
local_executor_exact_identity: PARTIALLY_VERIFIED_BEFORE_HANDOFF
all_111_import_content_identity_gate: NOT_RUN
codex_launch: NOT_RUN
codex_internal_fresh_higodot_receipt: NOT_RUN
codex_internal_fresh_hera_receipt: NOT_RUN
human_ui_accessibility: NOT_RUN
android: NOT_RUN
lume_product_asset: BLOCKED_BY_ASSET_GATE
```

No automation/reference/runtime-tool evidence may be promoted to Human/Player PASS.

## 10. Resume Read Order

```text
1. Base repository root + latest Base main + open Base PRs
2. urban-legend latest main + all open PRs + latest commits
3. Google Sheet current rows, especially Decision row 116
4. docs/CURRENT_HANDOFF.md
5. PR #198 metadata, changed files, latest comments/checks
6. PR #196 and #189 overlap state
7. PR #198 approved spec and implementation plan
8. exact local pr198-exec worktree identity/status
9. dedicated Godot / HiGodot / Hera / CODEX_HOME fresh receipts
10. only after all gates pass, launch/continue Codex Phase C
```

## 11. Next Executable Step

1. Assume previous PowerShell/process/session is stale; fresh-read everything.
2. Recheck PR #198 remote head before local mutation.
3. Revalidate `pr198-exec` exact worktree/branch/HEAD.
4. Revalidate dedicated Godot 4.7.1, self-contained editor settings, Godot AI 3.1.2 dev mode, HiGodot 8004/9504 ownership, Hera exact worktree, and dedicated CODEX_HOME.
5. Finish the all-relevant-file content-identity gate for the 111 `.import` stat-only candidates without reset/restore/clean/staging.
6. Only after a complete receipt, launch Codex in the exact worktree and require fresh HiGodot/Hera receipts from inside Codex.
7. Continue approved Phase C TDD: adapter → manual draft state/API → shared travel → DeviceShell → Records → Manual → Map → Lume → investigation integration → responsive/i18n/regression QA.
8. Recheck #196/#189 overlap before protected/baseline-adjacent changes.
9. Explicit-path staging only; never `git add -A` or `git add .` while local tooling/stat-only noise exists.

## 12. Stop / Fail-Closed Conditions

Stop persistent product mutation and report current evidence if any of the following is unresolved:

- PR #198 remote head moved unexpectedly;
- wrong worktree/branch/HEAD;
- HiGodot port owner/worktree/session ambiguous;
- Godot AI version self-updated or addon tracked files changed;
- Hera does not report exact worktree;
- CODEX_HOME points at the wrong project;
- candidate `.import` files fail content-identity checks;
- protected path overlap with another open PR is not reconciled;
- Sheet/GitHub authority conflict changes product semantics;
- new material product Decision is required.

Do not `reset`, `restore`, `clean`, kill unrelated processes, or rewrite another worktree to force readiness.

## 13. Historical Compatibility Anchors

```yaml
historical_compatibility_only: true
annual_design: APPROVED_DESIGN_BASELINE
ANNUAL-MVP-001: HISTORICAL_COMPATIBILITY_ANCHOR
POC_PASSED: NOT_DECLARED
legacy_baseline_tokens:
  - CORE-VALIDATION-001
  - UX-PD-001 2A
  - Ver 4.2
  - mvp-039
```

These tokens are historical/machine-consumer anchors, not current product-state claims.
