# Post-Planning Runtime Reconciliation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Reuse the existing Canon v2 runtime and reconcile it with the final monthly planning canon by making `COMPOSITE_RESULT` authoritative, adding optional `monthly_state`, wiring the M01 First Session, resuming the existing #181 main-menu plan, and preparing M04 without overclaiming pending product-reference assets.

**Architecture:** Do not rebuild migration/runtime infrastructure already present on `main`. Make bounded semantic changes around the existing Canon v2 loader/migrators/result policies, introduce one focused monthly-state policy, and use existing First Session/main-menu/Vertical Slice contracts as consumers. Keep current save/ID compatibility, transaction rollback, Validation isolation, and Human evidence ceilings intact.

**Tech Stack:** Godot 4.7.1, GDScript, JSON, SceneTree/GUT regressions, Python contract tests, GitHub Actions.

**Spec:** `docs/superpowers/specs/2026-08-22-post-planning-runtime-reconciliation-design.md`

## Global Constraints

- Fresh implementation base must be latest completed `main`; at planning handoff it is `7f9e714e5aac65a826b4fd66d5219df8ed2dfb3e`.
- Read open PRs before execution and do not modify unrelated active PR branches.
- `REUSE_EXISTING_CANON_V2_RUNTIME`; do not replay the 2026-08-05 migration plan from Task 1.
- Preserve `episode_001_afterlife_station`, `victim_afterlife_station_001`, existing report IDs and ANNUAL runtime/history IDs.
- Preserve bounded `mvp-038/039 → mvp-040` Afterlife migration and `validation-save-v1 → validation-save-v2` behavior.
- Do not globally bump base `scripts/core/game_state.gd` save version without separate cross-case evidence.
- Current result authority is `COMPOSITE_RESULT`; legacy S/A/B/S-rank is compatibility/history/mastery only.
- `monthly_state` is additive optional orchestration state and cannot contain case truth.
- `SERIAL_EXAM_FATIGUE_GUARD` applies to M01.
- `PRODUCT_REFERENCE_ASSET_PENDING` blocks release-near visual asset promotion, not code/data plumbing.
- Human/runtime/device evidence remains explicit; automation cannot create Human PASS.
- Every implementation task uses RED → minimal GREEN → focused regression → full relevant regression → commit.

---

## File Responsibility Map

### Existing owners to modify only where necessary

- `data/episodes/episode_001_afterlife_station_canon_v2.json` — Canon v2 semantic content/result contract.
- `scripts/core/afterlife_main_save_migrator.gd` — legacy main-save compatibility/history migration.
- `scripts/core/afterlife_migrating_game_state.gd` — active Canon v2 runtime integration boundary.
- `scripts/core/recovery_outcome_policy.gd` — independent result axes.
- `scripts/ui/canon_v2_result_axes_bridge.gd` — result-axis presentation.
- `scripts/ui/main_menu.gd`, `scenes/main_menu.tscn` and existing #181-owned files — main menu/version implementation.

### New bounded owner

- `scripts/core/monthly_state_policy.gd` — default, validate, transition and serialize monthly orchestration semantics only.

### Tests

- `tests/test_final_planning_handoff.py` — planning/handoff contract; already RED→GREEN before runtime work.
- `tests/afterlife_migration/afterlife_canon_v2_loader_test.gd`
- `tests/afterlife_migration/afterlife_main_save_migrator_test.gd`
- `tests/canon_v2_runtime/canon_v2_result_termination_test.gd`
- create `tests/monthly_state/monthly_state_policy_test.gd`
- create `tests/monthly_state/monthly_state_save_compatibility_test.gd`
- create `tests/first_session/m01_first_session_orchestration_test.gd`
- reuse/add focused #181 main-menu tests defined by `docs/superpowers/plans/2026-08-09-main-menu-control-room-versioning-implementation-plan.md`.

---

### Task 1: Make COMPOSITE_RESULT the Canon v2 semantic authority

**Files:**
- Modify: `data/episodes/episode_001_afterlife_station_canon_v2.json`
- Modify: `tests/afterlife_migration/afterlife_canon_v2_loader_test.gd`
- Modify: `tests/canon_v2_runtime/canon_v2_result_termination_test.gd` if needed for the current axis contract

**Interfaces:**
- Consumes: existing Canon v2 `result_contract`, `RecoveryOutcomePolicy.build_independent_result_packet()`.
- Produces: `result_contract.authority = "composite_result"` semantics and legacy mastery metadata that cannot overwrite independent axes.

- [ ] **Step 1 — Write RED assertions before production data changes**

Add to the existing Canon v2 loader test:

```gdscript
var result_contract: Dictionary = canonical.get("result_contract", {})
_expect(String(result_contract.get("authority", "")) == "composite_result", "composite result authority missing")
_expect(not _contains_key_recursive(result_contract, "owns_first_s_rank"), "legacy S-rank still owns current result")
var legacy_mastery: Dictionary = result_contract.get("legacy_mastery", {})
_expect(bool(legacy_mastery.get("grade_history_preserved", false)), "legacy grade history preservation missing")
_expect(not bool(legacy_mastery.get("may_overwrite_composite_result", true)), "legacy grade may overwrite composite result")
```

Add a recursive key helper locally in the test. Do not weaken existing loader/provenance assertions.

- [ ] **Step 2 — Run RED**

```bash
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_afterlife_canon_v2_migration_tests.sh
```

Expected: FAIL specifically because `authority`/`legacy_mastery` are absent and/or `owns_first_s_rank` exists.

- [ ] **Step 3 — Minimal semantic data correction**

Change only `canonical_v2.result_contract` in the sidecar. Keep historical/mastery compatibility explicit, but remove current ownership language for S-rank. Do not change Episode/victim/record/pattern IDs.

- [ ] **Step 4 — GREEN focused result tests**

```bash
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_afterlife_canon_v2_migration_tests.sh
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_canon_v2_runtime_tests.sh
```

Expected: PASS; independent result axes still work.

- [ ] **Step 5 — Commit**

```bash
git add data/episodes/episode_001_afterlife_station_canon_v2.json tests/afterlife_migration/afterlife_canon_v2_loader_test.gd tests/canon_v2_runtime/canon_v2_result_termination_test.gd
git commit -m "fix: align Afterlife result contract with composite outcomes"
```

---

### Task 2: Preserve legacy grade/save compatibility without current authority

**Files:**
- Modify: `scripts/core/afterlife_main_save_migrator.gd`
- Modify: `tests/afterlife_migration/afterlife_main_save_migrator_test.gd`
- Verify: `tests/fixtures/afterlife_migration/main_mvp039_completed.json`

**Interfaces:**
- Consumes: legacy `selected_resolution_grade`/completed reports.
- Produces: historical `legacy_resolution_snapshot` and compatibility/mastery metadata only; never a current composite-result override.

- [ ] **Step 1 — Add RED compatibility assertions**

For a completed legacy fixture, assert:

```gdscript
var snapshot: Dictionary = migrated_payload.get("legacy_resolution_snapshot", {})
_expect(String(snapshot.get("grade", "")) != "", "legacy grade history lost")
var first_v2: Dictionary = migrated_payload.get("first_v2_investigation", {})
_expect(not first_v2.has("s_rank_awarded") or not bool(first_v2.get("s_rank_awarded", false)), "migration granted current S-rank authority")
_expect(not migrated_payload.has("composite_result_from_legacy_grade"), "legacy grade synthesized composite result")
```

- [ ] **Step 2 — Run RED only if current implementation violates the new compatibility shape**

```bash
TEST_HOME="$(mktemp -d)"
HOME="$TEST_HOME" XDG_DATA_HOME="$TEST_HOME/.local/share" godot --headless --path . --script res://tests/afterlife_migration/afterlife_main_save_migrator_test.gd
```

Expected: either a genuine RED showing stale field semantics, or PASS if current behavior already satisfies the exact new contract. Record which occurred; do not manufacture a code change for an already-correct path.

- [ ] **Step 3 — Minimal migrator change only if RED proved necessary**

If `s_rank_awarded` is retained, rename/restructure it only when compatibility readers permit, e.g. under legacy/mastery metadata. Never delete the source legacy grade from `legacy_resolution_snapshot`.

- [ ] **Step 4 — Verify idempotence and all real fixtures**

```bash
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_afterlife_canon_v2_migration_tests.sh
```

Expected: mvp-038/039 fixtures, restart-required path, completed legacy path, orphan behavior and transaction tests PASS.

- [ ] **Step 5 — Commit only if code/tests changed**

```bash
git add scripts/core/afterlife_main_save_migrator.gd tests/afterlife_migration/afterlife_main_save_migrator_test.gd
git commit -m "fix: keep legacy grades historical during Canon v2 migration"
```

---

### Task 3: Add optional monthly_state orchestration

**Files:**
- Create: `scripts/core/monthly_state_policy.gd`
- Create: `tests/monthly_state/monthly_state_policy_test.gd`
- Create: `tests/monthly_state/monthly_state_save_compatibility_test.gd`
- Modify: `scripts/core/afterlife_migrating_game_state.gd`
- Modify only if required by existing serialization interface: `scripts/core/game_state.gd`
- Modify relevant focused regression runner to register monthly-state tests.

**Interfaces:**
- Produces: `MonthlyStatePolicy.default_state() -> Dictionary`.
- Produces: `validate(state: Dictionary) -> Dictionary` with `{ok: bool, code: String}`.
- Produces: `transition(state: Dictionary, event: String, payload: Dictionary = {}) -> Dictionary` without case-truth fields.
- Active GameState exposes `get_monthly_state() -> Dictionary` and bounded transition/write hooks.

- [ ] **Step 1 — RED policy test**

Create a headless test that expects:

```gdscript
var policy = load("res://scripts/core/monthly_state_policy.gd").new()
var initial: Dictionary = policy.default_state()
_expect(initial == {
    "schema_version": 1,
    "month_index": 1,
    "week_index": 1,
    "active_main_case_id": "",
    "main_case_status": "DORMANT",
    "dispatch_risk": 0,
    "resolved_this_month": false,
    "aftermath_available": false,
    "last_month_result_ref": ""
}, "monthly default mismatch")
```

Also assert invalid week/status fails; `RESOLVED` followed by a `SPAWN_MAIN_CASE` event cannot create a second case in the same month.

- [ ] **Step 2 — RED save compatibility test**

Load representative old payloads with no `monthly_state`; assert the runtime creates the deterministic default and does **not** inspect completed reports to mark the current month resolved.

- [ ] **Step 3 — Run RED**

```bash
TEST_HOME="$(mktemp -d)"
HOME="$TEST_HOME" XDG_DATA_HOME="$TEST_HOME/.local/share" godot --headless --path . --script res://tests/monthly_state/monthly_state_policy_test.gd
```

Expected: FAIL because the policy file/API does not exist.

- [ ] **Step 4 — Implement pure policy then integrate minimally**

The policy must reject unknown fields that encode hypothesis/answer truth such as `correct_response_id`, `true_hypothesis_id`, or equivalent. Integrate through active `afterlife_migrating_game_state.gd`; avoid making base `game_state.gd` the semantic owner.

- [ ] **Step 5 — GREEN + save regression**

```bash
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_afterlife_canon_v2_migration_tests.sh
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_annual_mvp_001_tests.sh
```

Expected: old saves remain readable; no ID rename; monthly state is additive.

- [ ] **Step 6 — Commit**

```bash
git add scripts/core/monthly_state_policy.gd scripts/core/afterlife_migrating_game_state.gd tests/monthly_state tests/run_afterlife_canon_v2_migration_tests.sh
git commit -m "feat: add additive monthly case orchestration state"
```

---

### Task 4: Wire M01 First Session onto existing runtime

**Files:**
- Create: `tests/first_session/m01_first_session_orchestration_test.gd`
- Modify the smallest existing orchestration/UI routing files identified from fresh main; do not create a parallel GameState.
- Reuse: `docs/M01_INVESTIGATION_SCENE_PACKET.md`, `docs/M01_DEDUCTION_SCENE_PACKET.md`, `docs/M01_RESCUE_SCENE_PACKET.md`, `docs/M01_RECOVERY_SCENE_PACKET.md`.

**Interfaces:**
- Consumes: monthly-state dispatch state and existing Canon v2 contract activation.
- Produces: one route from Opening Record/first bureau/schedule into M01 Canon v2 and back to aftermath.

- [ ] **Step 1 — RED First Session route contract**

Test these externally visible transitions:

```text
OPENING_RECORD
→ BUREAU_FIRST_TASK
→ RESTRICTED_SCHEDULE
→ M01_DISPATCHABLE
→ M01_INVESTIGATION
→ M01_DEDUCTION
→ M01_RESCUE
→ M01_RECOVERY
→ M01_COMPOSITE_RESULT
→ MONTHLY_AFTERMATH
```

Assert first-session schedule exposes only the approved restricted activity subset and no route can skip investigation evidence to resolve deduction.

- [ ] **Step 2 — Add SERIAL_EXAM_FATIGUE_GUARD assertions**

The test must prove:
- rescue references previously earned manual/evidence IDs;
- recovery references previously learned rule/evidence IDs;
- no new hidden `correct_response_id` becomes a required truth source at a phase boundary.

- [ ] **Step 3 — Run RED**

```bash
TEST_HOME="$(mktemp -d)"
HOME="$TEST_HOME" XDG_DATA_HOME="$TEST_HOME/.local/share" godot --headless --path . --script res://tests/first_session/m01_first_session_orchestration_test.gd
```

Expected: FAIL at the first missing orchestration transition, not a parse/setup error.

- [ ] **Step 4 — Implement minimal routing using current runtime owners**

Reuse current Canon v2 loader, active GameState wrapper, current investigation/recovery UI and existing schedule systems. Do not duplicate hypothesis truth or save state.

- [ ] **Step 5 — GREEN and full M01 regressions**

```bash
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_afterlife_canon_v2_migration_tests.sh
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_canon_v2_runtime_tests.sh
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_godot_regression.sh
```

- [ ] **Step 6 — Commit**

```bash
git add tests/first_session <exact-modified-routing-files>
git commit -m "feat: connect M01 first-session causal flow"
```

At execution time replace `<exact-modified-routing-files>` with the actual fresh-main files selected before editing; never stage unrelated paths.

---

### Task 5: Resume #181 Main Menu / Ver 4.3 from the existing approved plan

**Files:**
- Spec: `docs/superpowers/specs/2026-08-09-main-menu-control-room-versioning-design.md`
- Plan: `docs/superpowers/plans/2026-08-09-main-menu-control-room-versioning-implementation-plan.md`
- Current issue: #181 (`CURRENT_VALID / IMPLEMENTATION_GATE` after planning handoff merge)

**Interfaces:**
- Produces one canonical product version owner at `Ver 4.3`.
- Preserves Legacy/Validation route separation, save isolation, keyboard focus/accessibility.

- [ ] **Step 1 — Fresh-read the 2026-08-09 plan and current main files**

Do not copy the old plan into a new document. Compare its exact file paths/contracts with latest main and update only stale line/path references in a separate bounded planning correction if necessary.

- [ ] **Step 2 — Execute its existing TDD RED first**

The RED must prove current `GAME_VERSION := "Ver 4.2"` ownership and current menu layout behavior before implementation.

- [ ] **Step 3 — Implement through the existing plan**

Do not mix Canon v2/monthly-state internals into main-menu display except through canonical public snapshots. Never copy illustrative mockup values into product truth.

- [ ] **Step 4 — Focused + route/save regression**

Run the exact tests named by the 2026-08-09 plan plus Validation/Legacy save-isolation regressions and 1280×720/1920×1080 automated layout checks where available.

- [ ] **Step 5 — Commit as its own reviewable unit**

Use a commit message scoped to main menu/versioning, separate from M01/monthly-state commits.

---

### Task 6: Prepare M04 shared systems, enforce product-reference asset gate, and close automation

**Files:**
- Reuse: current M04 case/validation contracts and shared Investigation/Manual/Rescue/Recovery components.
- Modify only current shared runtime/data contracts necessary for M04 baseline use.
- Tests: add/update M04 baseline/shared-grammar tests selected from fresh main.
- Do not add final product assets while `PRODUCT_REFERENCE_ASSET_PENDING`.

**Interfaces:**
- Produces a deterministic M04 validation start state and shared screen/state grammar.
- Does not produce release-near visual/audio Human evidence.

- [ ] **Step 1 — RED asset-gate and shared-grammar contract**

Assert:
- M04 uses the shared phase grammar but case-specific rule IDs.
- no M01 answer IDs are treated as M04 truth.
- missing approved product-reference assets does not break code/data tests, but blocks any `RELEASE_NEAR_VISUAL_READY` or equivalent promotion.

- [ ] **Step 2 — Implement only shared plumbing/baseline**

No final background/cut-in/VFX asset promotion. Keep `PRODUCT_REFERENCE_ASSET_PENDING` visible in the implementation receipt.

- [ ] **Step 3 — Full exact-head automated validation**

```bash
python -m unittest discover -s tests -p "test_*.py" -v
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_godot_regression.sh
```

Also run all repository-required PR workflows on the exact final head.

- [ ] **Step 4 — Five whole-scope adversarial loops**

Each loop reattacks all of:
1. canon/runtime authority,
2. save/ID compatibility,
3. M01 player causal flow and fatigue guard,
4. M04 product/asset evidence ceiling,
5. #181 and workspace/postmerge state.

Any P0/P1 finding is fixed then the whole scope is reattacked.

- [ ] **Step 5 — Runtime evidence, not Human overclaim**

Record `IMPLEMENTED/AUTOMATED_TESTED/RUNTIME_VERIFIED` only for evidence actually executed. Keep Human comprehension/fun/readability `NOT_RUN` until a person performs it.

- [ ] **Step 6 — PR / merge / postmerge**

Use exact-head guard, GitHub+Notion readback, Issue successor freshness, and merge-linked Issue readback. Do not close #181 unless its implementation is actually complete on merged main.

---

## Plan Self-Review Result

- Spec coverage: all fixed requirements map to Tasks 1–6.
- Existing-solution-first: Canon v2 migration/runtime and #181 plan are reused instead of duplicated.
- Type/authority consistency: `COMPOSITE_RESULT`, `monthly_state`, M01/M04 roles and asset Gate use the same names as the current spec.
- Evidence ceiling: no task declares Human PASS from automation.
- Save safety: no task globally upgrades base save version or renames stable IDs.
- Scope: six independently reviewable units; no placeholder feature remains. The one `<exact-modified-routing-files>` staging token is an execution-time git staging safety instruction, not an undefined implementation requirement; the implementer must determine those files by fresh-main readback before any edit.

## Execution Handoff

This plan is ready for Codex/agent execution **only when runtime implementation is explicitly authorized in the execution environment**. The current planning handoff intentionally keeps `runtime_implementation: NOT_AUTHORIZED` while making the contract `READY`.
