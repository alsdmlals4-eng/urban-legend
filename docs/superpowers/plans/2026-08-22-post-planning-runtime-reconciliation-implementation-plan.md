# Post-Planning Runtime Reconciliation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Reuse the existing Canon v2 runtime and reconcile it with the final monthly planning canon by making `COMPOSITE_RESULT` authoritative, adding optional `monthly_state`, wiring the M01 First Session, resuming the existing #181 main-menu plan, and preparing M04 without overclaiming pending product-reference assets.

**Architecture:** Do not rebuild migration/runtime infrastructure already present on `main`. Make bounded semantic changes around the existing Canon v2 loader/migrators/result policies, introduce focused monthly-state and first-session orchestration owners, and reuse the existing main-menu/Vertical Slice contracts. Keep save/ID compatibility, transaction rollback, Validation isolation, and Human evidence ceilings intact.

**Tech Stack:** Godot 4.7.1, GDScript, JSON, SceneTree/GUT regressions, Python contract tests, GitHub Actions.

**Spec:** `docs/superpowers/specs/2026-08-22-post-planning-runtime-reconciliation-design.md`

## Global constraints

- Start from latest completed `main`; handoff baseline is `7f9e714e5aac65a826b4fd66d5219df8ed2dfb3e`.
- Read open PRs before execution; unrelated active PRs remain read-only.
- `REUSE_EXISTING_CANON_V2_RUNTIME`; do not replay the 2026-08-05 migration implementation plan from Task 1.
- Preserve `episode_001_afterlife_station`, `victim_afterlife_station_001`, existing report IDs and ANNUAL runtime/history IDs.
- Preserve bounded `mvp-038/039 → mvp-040` Afterlife migration and `validation-save-v1 → validation-save-v2` behavior.
- Do not globally bump base `scripts/core/game_state.gd` save version without cross-case evidence.
- Current result authority is `COMPOSITE_RESULT`; legacy S/A/B/S-rank is compatibility/history/mastery only.
- `monthly_state` is optional orchestration state and cannot contain case truth.
- `SERIAL_EXAM_FATIGUE_GUARD` applies to M01.
- `PRODUCT_REFERENCE_ASSET_PENDING` blocks release-near visual asset promotion, not code/data plumbing.
- Automation cannot create Human PASS.
- Each task uses RED → minimal GREEN → focused regression → relevant full regression → commit.

## File responsibility map

Existing owners:
- `data/episodes/episode_001_afterlife_station_canon_v2.json` — Canon v2 content/result semantics.
- `scripts/core/afterlife_main_save_migrator.gd` — legacy save compatibility/history.
- `scripts/core/afterlife_migrating_game_state.gd` — active runtime integration boundary.
- `scripts/core/recovery_outcome_policy.gd` — independent result axes.
- `scripts/ui/canon_v2_result_axes_bridge.gd` — result presentation.
- #181 existing design/plan owns main-menu/version work.

New bounded owners:
- `scripts/core/monthly_state_policy.gd` — monthly default/validation/transition semantics.
- `scripts/core/m01_first_session_orchestrator.gd` — first-session phase routing only; no duplicate truth/save ownership.

Primary tests:
- `tests/test_final_planning_handoff.py`
- `tests/afterlife_migration/afterlife_canon_v2_loader_test.gd`
- `tests/afterlife_migration/afterlife_main_save_migrator_test.gd`
- `tests/canon_v2_runtime/canon_v2_result_termination_test.gd`
- `tests/monthly_state/monthly_state_policy_test.gd`
- `tests/monthly_state/monthly_state_save_compatibility_test.gd`
- `tests/first_session/m01_first_session_orchestration_test.gd`

---

### Task 1: Make COMPOSITE_RESULT the Canon v2 authority

**Files**
- Modify: `data/episodes/episode_001_afterlife_station_canon_v2.json`
- Modify: `tests/afterlife_migration/afterlife_canon_v2_loader_test.gd`
- Modify if the current result test needs the explicit semantic assertion: `tests/canon_v2_runtime/canon_v2_result_termination_test.gd`

**Interfaces**
- Consume existing `result_contract` and `RecoveryOutcomePolicy.build_independent_result_packet()`.
- Produce `result_contract.authority = "composite_result"`; legacy mastery cannot overwrite axes.

- [ ] Add RED assertions before product data changes:

```gdscript
var result_contract: Dictionary = canonical.get("result_contract", {})
_expect(String(result_contract.get("authority", "")) == "composite_result", "composite result authority missing")
_expect(not _contains_key_recursive(result_contract, "owns_first_s_rank"), "legacy S-rank still owns current result")
var legacy_mastery: Dictionary = result_contract.get("legacy_mastery", {})
_expect(bool(legacy_mastery.get("grade_history_preserved", false)), "legacy grade history lost")
_expect(not bool(legacy_mastery.get("may_overwrite_composite_result", true)), "legacy grade can overwrite composite result")
```

- [ ] Run RED:

```bash
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_afterlife_canon_v2_migration_tests.sh
```

Expected: failure because the current sidecar still owns S-rank semantics.

- [ ] Correct only `canonical_v2.result_contract`. Preserve Episode/victim/record/pattern/response IDs.
- [ ] Run GREEN:

```bash
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_afterlife_canon_v2_migration_tests.sh
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_canon_v2_runtime_tests.sh
```

- [ ] Commit:

```bash
git add data/episodes/episode_001_afterlife_station_canon_v2.json tests/afterlife_migration/afterlife_canon_v2_loader_test.gd tests/canon_v2_runtime/canon_v2_result_termination_test.gd
git commit -m "fix: align Afterlife result contract with composite outcomes"
```

---

### Task 2: Keep legacy grade/save data historical, not authoritative

**Files**
- Modify only if RED proves necessary: `scripts/core/afterlife_main_save_migrator.gd`
- Modify: `tests/afterlife_migration/afterlife_main_save_migrator_test.gd`
- Verify unchanged fixture: `tests/fixtures/afterlife_migration/main_mvp039_completed.json`

- [ ] Add compatibility assertions:

```gdscript
var snapshot: Dictionary = migrated_payload.get("legacy_resolution_snapshot", {})
_expect(String(snapshot.get("grade", "")) != "", "legacy grade history lost")
var first_v2: Dictionary = migrated_payload.get("first_v2_investigation", {})
_expect(not first_v2.has("s_rank_awarded") or not bool(first_v2.get("s_rank_awarded", false)), "migration granted S-rank authority")
_expect(not migrated_payload.has("composite_result_from_legacy_grade"), "legacy grade synthesized composite result")
```

- [ ] Run focused test:

```bash
TEST_HOME="$(mktemp -d)"
HOME="$TEST_HOME" XDG_DATA_HOME="$TEST_HOME/.local/share" godot --headless --path . --script res://tests/afterlife_migration/afterlife_main_save_migrator_test.gd
```

If already GREEN, do not manufacture a migrator change. If RED, minimally move S-rank state under legacy/mastery compatibility while preserving `legacy_resolution_snapshot.grade`.

- [ ] Re-run all migration fixtures/transaction tests:

```bash
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_afterlife_canon_v2_migration_tests.sh
```

- [ ] Commit only changed paths:

```bash
git add scripts/core/afterlife_main_save_migrator.gd tests/afterlife_migration/afterlife_main_save_migrator_test.gd
git commit -m "fix: keep legacy grades historical during Canon v2 migration"
```

---

### Task 3: Add optional monthly_state orchestration

**Files**
- Create: `scripts/core/monthly_state_policy.gd`
- Create: `tests/monthly_state/monthly_state_policy_test.gd`
- Create: `tests/monthly_state/monthly_state_save_compatibility_test.gd`
- Modify: `scripts/core/afterlife_migrating_game_state.gd`
- Modify: `tests/run_afterlife_canon_v2_migration_tests.sh`
- Modify `scripts/core/game_state.gd` only if the inherited serialization API cannot persist an optional child block without it.

**Interfaces**
- `MonthlyStatePolicy.default_state() -> Dictionary`
- `MonthlyStatePolicy.validate(state) -> {ok, code}`
- `MonthlyStatePolicy.transition(state, event, payload={}) -> Dictionary`
- active GameState: `get_monthly_state()` plus bounded transition/persistence hooks.

- [ ] Create RED expecting the exact default:

```gdscript
{
  "schema_version": 1,
  "month_index": 1,
  "week_index": 1,
  "active_main_case_id": "",
  "main_case_status": "DORMANT",
  "dispatch_risk": 0,
  "resolved_this_month": false,
  "aftermath_available": false,
  "last_month_result_ref": ""
}
```

Also assert invalid weeks/status fail, truth-like fields such as `correct_response_id` are rejected, and `RESOLVED` cannot spawn a second main case that month.

- [ ] RED command:

```bash
TEST_HOME="$(mktemp -d)"
HOME="$TEST_HOME" XDG_DATA_HOME="$TEST_HOME/.local/share" godot --headless --path . --script res://tests/monthly_state/monthly_state_policy_test.gd
```

Expected: missing policy/API.

- [ ] Implement pure policy, then integrate it through `afterlife_migrating_game_state.gd`.
- [ ] Old-save compatibility test must prove a missing block becomes the deterministic default and completed reports do not imply current-month completion.
- [ ] GREEN/regression:

```bash
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_afterlife_canon_v2_migration_tests.sh
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_annual_mvp_001_tests.sh
```

- [ ] Commit:

```bash
git add scripts/core/monthly_state_policy.gd scripts/core/afterlife_migrating_game_state.gd tests/monthly_state tests/run_afterlife_canon_v2_migration_tests.sh
git commit -m "feat: add additive monthly case orchestration state"
```

---

### Task 4: Wire M01_FIRST_SESSION using one orchestration owner

**Files**
- Create: `scripts/core/m01_first_session_orchestrator.gd`
- Create: `tests/first_session/m01_first_session_orchestration_test.gd`
- Modify: `scripts/core/afterlife_migrating_game_state.gd`
- Modify: `tests/run_afterlife_canon_v2_migration_tests.sh`

**Interface**

```gdscript
class_name M01FirstSessionOrchestrator
extends RefCounted

func default_state() -> Dictionary
func available_actions(state: Dictionary, runtime_snapshot: Dictionary) -> Array
func apply_event(state: Dictionary, event: String, runtime_snapshot: Dictionary = {}) -> Dictionary
```

The orchestrator owns phase routing only. It references existing Canon v2 evidence/manual/result state; it does not own duplicate hypotheses, save files, rewards or case truth.

- [ ] RED must require:

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

- [ ] Add `SERIAL_EXAM_FATIGUE_GUARD` assertions: rescue/recovery must reference already-earned record/manual IDs and cannot require a new hidden `correct_response_id` truth source.
- [ ] RED command:

```bash
TEST_HOME="$(mktemp -d)"
HOME="$TEST_HOME" XDG_DATA_HOME="$TEST_HOME/.local/share" godot --headless --path . --script res://tests/first_session/m01_first_session_orchestration_test.gd
```

- [ ] Implement the orchestrator and the smallest active-GameState integration. Use existing scene/runtime routes returned by the GameState; do not create another state singleton.
- [ ] GREEN/full M01 regression:

```bash
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_afterlife_canon_v2_migration_tests.sh
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_canon_v2_runtime_tests.sh
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_godot_regression.sh
```

- [ ] Commit:

```bash
git add scripts/core/m01_first_session_orchestrator.gd scripts/core/afterlife_migrating_game_state.gd tests/first_session tests/run_afterlife_canon_v2_migration_tests.sh
git commit -m "feat: connect M01 first-session causal flow"
```

---

### Task 5: Resume #181 main menu / Ver 4.3 from the existing plan

**Existing owners**
- Spec: `docs/superpowers/specs/2026-08-09-main-menu-control-room-versioning-design.md`
- Plan: `docs/superpowers/plans/2026-08-09-main-menu-control-room-versioning-implementation-plan.md`
- Issue: #181, current classification after planning handoff = `CURRENT_VALID / IMPLEMENTATION_GATE`.

- [ ] Fresh-read the existing plan plus current `scripts/ui/main_menu.gd` and `scenes/main_menu.tscn`.
- [ ] If exact paths/API in the old plan are stale, correct that plan in a bounded docs-only commit before product edits; do not create another main-menu plan.
- [ ] Execute its existing TDD RED proving `Ver 4.2` hardcode/current layout behavior.
- [ ] Implement central product version `Ver 4.3` and approved control-room layout while preserving `LegacyContinueButton`, `LegacyNewCampaignButton`, `ValidationPrimaryButton`, `ValidationSecondaryButton`, `DatabaseButton`, save isolation and keyboard focus.
- [ ] Right-side intelligence may consume only canonical runtime snapshots; mockup placeholder values are forbidden.
- [ ] Run focused main-menu tests, Validation/Legacy route tests, save-isolation tests and available 1280×720/1920×1080 automated layout checks.
- [ ] Commit main-menu/versioning separately from monthly/M01 work.

---

### Task 6: Prepare M04 shared systems and close exact-head automation

**Files**
- Reuse current M04 screen/validation/baseline contracts.
- Modify only shared runtime/data contracts required to start M04 from a deterministic validation baseline.
- Add/update M04 shared-grammar/baseline tests discovered on fresh main.
- Do not add/promote final product assets while `PRODUCT_REFERENCE_ASSET_PENDING`.

- [ ] RED must prove M04 uses the common phase grammar with M04-specific rule IDs and never consumes M01 truth IDs.
- [ ] RED must also prove missing approved product-reference assets blocks any `RELEASE_NEAR_VISUAL_READY` promotion without breaking code/data tests.
- [ ] Implement shared plumbing/baseline only.
- [ ] Run full automation:

```bash
python -m unittest discover -s tests -p "test_*.py" -v
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_godot_regression.sh
```

- [ ] Run all repository-required workflows on the exact final head.
- [ ] Execute at least five whole-scope adversarial loops over: authority, save/ID compatibility, M01 causal flow/fatigue, M04 asset/evidence ceiling, #181/workspace/postmerge state. Fix any P0/P1 and reattack the whole state.
- [ ] Record only evidence actually executed. Human comprehension/fun/readability remain `NOT_RUN` until performed by a person.
- [ ] Merge with expected-head protection, then perform GitHub+Notion destination readback plus Issue successor freshness and merge-linked Issue readback.

## Plan self-review

- No migration/runtime subsystem is duplicated.
- All six units have explicit file owners and acceptance boundaries.
- `COMPOSITE_RESULT`, `monthly_state`, M01/M04 roles and asset Gate match the final design.
- No task globally upgrades base save version or renames stable IDs.
- No task creates Human PASS from automation.
- #181 reuses its existing spec/plan instead of creating a second owner.
- All paths and APIs required to begin execution are explicit; there are no TODO/TBD or execution-time file placeholders.

## Execution handoff

This plan is ready for Codex/agent execution **only when runtime implementation is explicitly authorized in the execution environment**. Current planning handoff sets `implementation_contract: READY` while preserving `runtime_implementation: NOT_AUTHORIZED`.
