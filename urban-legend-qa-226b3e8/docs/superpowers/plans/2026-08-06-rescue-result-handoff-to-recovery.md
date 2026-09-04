# Rescue Result Handoff to Recovery Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Preserve the immutable rescue result, derive recovery initial conditions and traceable protection obligations once, preview responsibility consequences before actions, and report rescue facts separately from recovery changes.

**Architecture:** Add a pure `RescueRecoveryHandoffPolicy` that validates `rescue_outcome_snapshot` and derives `recovery_handoff_state` plus stable protection obligations. `GameState` owns persistence and save migration; rescue, recovery, and result scenes consume the policy through narrow methods without changing anomaly pattern truth.

**Tech Stack:** Godot 4.x, GDScript, JSON save data, Python planning-contract tests, existing headless Godot test runners and GitHub Actions.

## Global Constraints

- Decision authority: `DEC-20260806-121-CANON-V2-RESCUE-RESULT-HANDOFF-TO-RECOVERY-INITIAL-CONDITIONS-AND-ACTION-CONSTRAINTS`.
- Current gate: `IMPLEMENTATION_NOT_AUTHORIZED`; this document is a future execution plan only.
- `rescue_outcome_snapshot` is immutable after rescue finalization.
- `recovery_handoff_state` is derived once and is not reapplied on load.
- `active_protection_obligations` use stable `obligation_id` values and never duplicate on save/load.
- `protection_history` is append-only causal history.
- The handoff must not modify `pattern_id`, `correct_response_id`, or telegraph objective meaning.
- Do not repeat the rescue puzzle inside recovery.
- Default to action forewarning; hard lock only for physical impossibility or confirmed anomaly-rule violation.
- Accessibility alternatives, manual access, pause, and time-pressure relief never reduce outcome, reward, or rank.
- save migration must be atomic, rollback-safe, idempotent, and must preserve legacy provenance.
- PR #149 and PR #151 remain unmerged until separate authorization.

---

## File Map

### Create

- `scripts/core/rescue_recovery_handoff_policy.gd` — pure validation, derivation, obligation and action-preview policy.
- `tests/rescue_recovery_handoff_policy_test.gd` — policy behavior and invariants.
- `tests/rescue_recovery_handoff_save_migration_test.gd` — save/load, legacy migration, rollback and idempotency.
- `tests/rescue_recovery_handoff_scene_flow_test.gd` — rescue → recovery → result integration.

### Modify

- `scripts/core/game_state.gd` — store snapshots, handoff state, obligations and history; expose narrow accessors; perform save migration.
- `scripts/scenes/minigame_scene.gd` — finalize a structured rescue snapshot instead of only a boolean result.
- `scripts/scenes/battle_scene.gd` — derive/load handoff once, preview obligation consequences and record obligation transitions.
- `scripts/scenes/result_scene.gd` — show rescue-at-finalization facts and recovery-time changes separately.
- `scripts/data/case_data.gd` — validate case-authored handoff adapters and responsibility definitions.
- `tests/minigame_pipeline_test.gd` — preserve legacy compatibility while asserting structured handoff creation.
- `tests/recovery_battle_scene_test.gd` or the repository’s current recovery scene test — assert action preview and pattern-truth isolation.
- `tests/result_scene_test.gd` or the repository’s current result scene test — assert independent headlines and causal history.

---

### Task 1: Pure Rescue-to-Recovery Handoff Policy

**Files:**
- Create: `scripts/core/rescue_recovery_handoff_policy.gd`
- Create: `tests/rescue_recovery_handoff_policy_test.gd`

**Interfaces:**
- Consumes: finalized rescue snapshot `Dictionary`, optional case adapter `Dictionary`.
- Produces: `validate_snapshot(snapshot: Dictionary) -> Dictionary`, `derive_handoff(snapshot: Dictionary, adapter: Dictionary = {}) -> Dictionary`, `preview_action(action_id: String, handoff: Dictionary, obligations: Array) -> Dictionary`, `apply_obligation_event(obligations: Array, event: Dictionary) -> Dictionary`.

- [ ] **Step 1: Write the failing test**

Create tests that exercise real policy behavior:

```gdscript
extends SceneTree

const Policy = preload("res://scripts/core/rescue_recovery_handoff_policy.gd")

func _init() -> void:
    var snapshot := {
        "snapshot_id": "rescue_episode_001_attempt_01",
        "survival_state": "alive_critical",
        "separation_state": "partial",
        "aftereffects": ["injury", "residual_role_link"],
        "observed_failure_reasons": ["carrier_not_fully_isolated"],
        "irreversible_results": [],
        "provenance": {"source": "minigame_route_restore", "finalized_at": "2026-08-06T07:23:00+09:00"}
    }
    var policy := Policy.new()
    var result := policy.derive_handoff(snapshot)
    assert(result.get("ok", false))
    assert(result["recovery_handoff_state"]["active_protected_subjects"].size() == 1)
    assert(_has_obligation(result["active_protection_obligations"], "treatment"))
    assert(_has_obligation(result["active_protection_obligations"], "connection_monitoring"))
    assert(result["active_protection_obligations"][0].has("source_reason"))
    quit(0)

func _has_obligation(obligations: Array, responsibility_type: String) -> bool:
    for obligation in obligations:
        if String(obligation.get("responsibility_type", "")) == responsibility_type:
            return true
    return false
```

Add separate assertions that:

- `dead` creates record/body/contamination responsibilities rather than a difficulty reward.
- `missing_unknown` creates search/accounting responsibility without becoming a universal recovery-win condition.
- `complete`, `partial`, `failed`, and `irreversible` separation states remain distinct.
- duplicate source facts produce one stable `obligation_id`.
- `preview_action()` defaults to allowed with visible consequences.
- hard lock occurs only for `physically_impossible` or `confirmed_rule_violation`.
- the returned structure never contains replacements for `pattern_id` or `correct_response_id`.

- [ ] **Step 2: Run test to verify it fails**

Run:

```bash
godot --headless --path . --script tests/rescue_recovery_handoff_policy_test.gd
```

Expected: FAIL because `scripts/core/rescue_recovery_handoff_policy.gd` does not exist.

- [ ] **Step 3: Write minimal implementation**

Create a focused policy:

```gdscript
class_name RescueRecoveryHandoffPolicy
extends RefCounted

const REQUIRED_SNAPSHOT_KEYS := [
    "snapshot_id",
    "survival_state",
    "separation_state",
    "aftereffects",
    "observed_failure_reasons",
    "irreversible_results",
    "provenance"
]

func validate_snapshot(snapshot: Dictionary) -> Dictionary:
    for key in REQUIRED_SNAPSHOT_KEYS:
        if not snapshot.has(key):
            return {"ok": false, "error": "handoff_validation_failed", "missing_key": key}
    if String(snapshot.get("snapshot_id", "")).is_empty():
        return {"ok": false, "error": "handoff_validation_failed", "reason": "empty_snapshot_id"}
    return {"ok": true}

func derive_handoff(snapshot: Dictionary, adapter: Dictionary = {}) -> Dictionary:
    var validation := validate_snapshot(snapshot)
    if not validation.get("ok", false):
        return validation
    var obligations: Array = []
    _append_survival_obligations(snapshot, obligations)
    _append_separation_obligations(snapshot, obligations)
    _append_aftereffect_obligations(snapshot, obligations)
    obligations = _deduplicate_obligations(obligations)
    return {
        "ok": true,
        "recovery_handoff_state": _build_handoff_state(snapshot, adapter),
        "active_protection_obligations": obligations,
        "protection_history": []
    }
```

Implement each helper only for approved meanings. Generate `obligation_id` deterministically from snapshot id, target, responsibility type and source reason.

- [ ] **Step 4: Run test to verify it passes**

Run the same command. Expected: PASS with exit code 0.

- [ ] **Step 5: Commit**

```bash
git add scripts/core/rescue_recovery_handoff_policy.gd tests/rescue_recovery_handoff_policy_test.gd
git commit -m "feat: add rescue recovery handoff policy"
```

---

### Task 2: Finalize an Immutable Rescue Outcome Snapshot

**Files:**
- Modify: `scripts/scenes/minigame_scene.gd`
- Modify: `scripts/core/game_state.gd`
- Modify: `tests/minigame_pipeline_test.gd`

**Interfaces:**
- Produces: `GameState.finalize_rescue_outcome_snapshot(snapshot: Dictionary) -> Dictionary`.
- Consumes later: `GameState.get_rescue_outcome_snapshot() -> Dictionary`.

- [ ] **Step 1: Write the failing test**

Extend the real minigame pipeline test:

```gdscript
func test_successful_rescue_finalizes_structured_snapshot_once() -> void:
    GameState.clear_rescue_recovery_handoff()
    var details := {
        "survival_state": "alive_stable",
        "separation_state": "complete",
        "aftereffects": [],
        "observed_failure_reasons": [],
        "irreversible_results": [],
        "provenance": {"source": "minigame_route_restore"}
    }
    GameState.save_minigame_result("minigame_frequency_sync", true, details)
    var first := GameState.finalize_rescue_outcome_snapshot(details)
    var second := GameState.finalize_rescue_outcome_snapshot(details)
    assert(first.get("ok", false))
    assert(not second.get("ok", true))
    assert(second.get("reason", "") == "snapshot_already_finalized")
```

Also assert the existing `successful` legacy field remains available during migration.

- [ ] **Step 2: Run test to verify it fails**

Run the repository’s minigame pipeline command. Expected: FAIL because the snapshot API is absent.

- [ ] **Step 3: Write minimal implementation**

Add storage and defensive copies:

```gdscript
var rescue_outcome_snapshot: Dictionary = {}

func finalize_rescue_outcome_snapshot(snapshot: Dictionary) -> Dictionary:
    if not rescue_outcome_snapshot.is_empty():
        return {"ok": false, "reason": "snapshot_already_finalized"}
    var validation := RescueRecoveryHandoffPolicy.new().validate_snapshot(snapshot)
    if not validation.get("ok", false):
        return validation
    rescue_outcome_snapshot = snapshot.duplicate(true)
    save_game()
    return {"ok": true, "snapshot": rescue_outcome_snapshot.duplicate(true)}

func get_rescue_outcome_snapshot() -> Dictionary:
    return rescue_outcome_snapshot.duplicate(true)
```

In `minigame_scene.gd`, construct the snapshot from authored rescue facts. Do not infer `alive_stable`, `complete`, or empty aftereffects from `successful == true` when structured details are absent; retain legacy provenance instead.

- [ ] **Step 4: Run test to verify it passes**

Run the focused minigame test and confirm legacy tests still pass.

- [ ] **Step 5: Commit**

```bash
git add scripts/scenes/minigame_scene.gd scripts/core/game_state.gd tests/minigame_pipeline_test.gd
git commit -m "feat: finalize immutable rescue outcome snapshots"
```

---

### Task 3: Persist Handoff State, Obligations and Safe Save Migration

**Files:**
- Modify: `scripts/core/game_state.gd`
- Create: `tests/rescue_recovery_handoff_save_migration_test.gd`

**Interfaces:**
- Produces: `ensure_recovery_handoff_initialized() -> Dictionary`, `get_recovery_handoff_state() -> Dictionary`, `get_active_protection_obligations() -> Array`, `append_protection_history(event: Dictionary) -> bool`.

- [ ] **Step 1: Write the failing test**

```gdscript
func test_save_load_does_not_reapply_handoff_or_duplicate_obligations() -> void:
    var state := GameStateScript.new()
    state.finalize_rescue_outcome_snapshot(_partial_separation_snapshot())
    var first := state.ensure_recovery_handoff_initialized()
    var first_ids := _obligation_ids(first["active_protection_obligations"])
    var payload := state.make_save_payload()

    var loaded := GameStateScript.new()
    assert(loaded.apply_save_payload(payload))
    var second := loaded.ensure_recovery_handoff_initialized()
    assert(_obligation_ids(second["active_protection_obligations"]) == first_ids)
    assert(second.get("reused_existing_handoff", false))
```

Add tests for:

- legacy bool is preserved as provenance and does not imply full rescue.
- a migration rerun is idempotent.
- contradictory data yields `handoff_validation_failed`.
- a simulated write failure rolls back snapshot, handoff, obligations and history together.

- [ ] **Step 2: Run test to verify it fails**

Run:

```bash
godot --headless --path . --script tests/rescue_recovery_handoff_save_migration_test.gd
```

Expected: FAIL because persistence and migration APIs are absent.

- [ ] **Step 3: Write minimal implementation**

Add the four fields to save payloads:

```gdscript
"rescue_outcome_snapshot": rescue_outcome_snapshot,
"recovery_handoff_state": recovery_handoff_state,
"active_protection_obligations": active_protection_obligations,
"protection_history": protection_history
```

Use a migration marker such as `rescue_recovery_handoff_schema_version`. Build the migrated structures in temporary dictionaries, validate them, and only then replace live state. On failure, retain the original payload and return `handoff_validation_failed`. Keep the legacy bool and existing numeric deltas under provenance classified as `LEGACY_NUMERIC_HANDOFF`.

- [ ] **Step 4: Run test to verify it passes**

Run the focused migration test, existing save migration suites, and rollback tests. Expected: all PASS.

- [ ] **Step 5: Commit**

```bash
git add scripts/core/game_state.gd tests/rescue_recovery_handoff_save_migration_test.gd
git commit -m "feat: persist rescue recovery handoff safely"
```

---

### Task 4: Apply Handoff Once and Preview Action Consequences in Recovery

**Files:**
- Modify: `scripts/scenes/battle_scene.gd`
- Modify: the existing recovery scene test
- Create: `tests/rescue_recovery_handoff_scene_flow_test.gd`

**Interfaces:**
- Consumes: GameState handoff getters and policy `preview_action()`.
- Produces: visible action preview; obligation transition events; no changes to pattern truth.

- [ ] **Step 1: Write the failing test**

```gdscript
func test_attack_preview_warns_about_partial_connection_without_changing_pattern_answer() -> void:
    var battle := BattleSceneScript.new()
    battle.configure_for_test(_handoff_with_partial_connection(), _pattern_fixture())
    var before_pattern := battle.get_current_pattern_for_test()
    var preview := battle.preview_recovery_action_for_test("suppression")
    var after_pattern := battle.get_current_pattern_for_test()

    assert(preview.get("allowed", false))
    assert(preview.get("requires_confirmation", false))
    assert(preview.get("expected_consequences", []).size() > 0)
    assert(preview.get("alternatives", []).size() > 0)
    assert(before_pattern.get("pattern_id") == after_pattern.get("pattern_id"))
    assert(before_pattern.get("correct_response_id") == after_pattern.get("correct_response_id"))
```

Add tests that observation and manual access are never blocked, accessibility alternatives do not alter the preview, and hard lock occurs only for the two approved conditions.

- [ ] **Step 2: Run test to verify it fails**

Run the focused recovery scene test. Expected: FAIL because action preview and handoff initialization are absent.

- [ ] **Step 3: Write minimal implementation**

At recovery start:

```gdscript
var initialization := GameState.ensure_recovery_handoff_initialized()
if not initialization.get("ok", false):
    _show_handoff_validation_failure(initialization)
    return
```

Before action execution:

```gdscript
var preview := _handoff_policy.preview_action(
    action_id,
    GameState.get_recovery_handoff_state(),
    GameState.get_active_protection_obligations()
)
if not preview.get("allowed", true):
    _show_action_block(preview)
    return
if preview.get("requires_confirmation", false):
    _show_responsibility_confirmation(preview)
    return
_execute_recovery_action(action_id)
```

After execution, append explicit obligation events with source action, affected target, previous status, next status, reason and consequence. Do not route obligation logic through pattern correctness.

- [ ] **Step 4: Run test to verify it passes**

Run focused recovery tests and the Canon v2 pattern selection/judgment suites. Expected: all PASS and pattern IDs/answers unchanged.

- [ ] **Step 5: Commit**

```bash
git add scripts/scenes/battle_scene.gd tests/rescue_recovery_handoff_scene_flow_test.gd tests
git commit -m "feat: preview recovery protection consequences"
```

---

### Task 5: Report Rescue Facts and Recovery-Time Changes Separately

**Files:**
- Modify: `scripts/scenes/result_scene.gd`
- Modify: the existing result scene test

**Interfaces:**
- Consumes: immutable snapshot, current victim state, obligations, history and representative recovery outcome.
- Produces: equal rescue and recovery headlines plus causal detail.

- [ ] **Step 1: Write the failing test**

```gdscript
func test_result_keeps_partial_rescue_fact_when_recovery_finishes_separation() -> void:
    var report := ResultSceneScript.build_result_view_model_for_test({
        "rescue_outcome_snapshot": {"separation_state": "partial"},
        "current_victim_state": {"separation_state": "complete"},
        "protection_history": [{"event": "connection_severed_during_recovery"}],
        "recovery_result_status": "containment_complete"
    })
    assert(report["rescue_headline"].contains("부분 분리"))
    assert(report["recovery_change_headline"].contains("회수 중 분리 완료"))
    assert(report["recovery_headline"].contains("봉쇄 완료"))
    assert(not report.has("global_mission_success"))
```

- [ ] **Step 2: Run test to verify it fails**

Run the focused result scene test. Expected: FAIL because the independent view model is absent.

- [ ] **Step 3: Write minimal implementation**

Build three visible sections:

1. 구출 종료 당시 사실
2. 회수 중 보호 상태 변화
3. 대표 회수 결과와 통제 근거

Include unfulfilled and breached obligations, `protection_history`, legacy provenance and follow-up responsibility. Do not collapse them into one score or one mission-success banner.

- [ ] **Step 4: Run test to verify it passes**

Run focused result tests and Decision 120 result-packet tests. Expected: all PASS.

- [ ] **Step 5: Commit**

```bash
git add scripts/scenes/result_scene.gd tests
git commit -m "feat: report rescue and recovery changes independently"
```

---

### Task 6: Case Adapter Validation, Accessibility, Full Regression and Human QA Handoff

**Files:**
- Modify: `scripts/data/case_data.gd`
- Modify: relevant Episode/Canon v2 validation tests
- Modify: `TEST_CHECKLIST.md` only when implementation is separately authorized

**Interfaces:**
- Consumes: case-authored responsibility definitions.
- Produces: validated adapters and QA evidence; no automatic merge.

- [ ] **Step 1: Write the failing test**

Add case-data validation tests requiring:

- every responsibility definition has a stable type and source mapping.
- no adapter can replace `pattern_id` or `correct_response_id`.
- every high-risk state has at least one authored tool, support, alternative path, meaningful recovery action or approved-withdrawal evaluation path.
- no accessibility setting changes obligation severity, result, reward or rank.

- [ ] **Step 2: Run test to verify it fails**

Run the focused data validation suite. Expected: FAIL until adapter validation exists.

- [ ] **Step 3: Write minimal implementation**

Reject invalid adapters with explicit validation records. Do not infer missing alternatives or repair contradictory source mappings silently.

- [ ] **Step 4: Run focused and full automated verification**

Run, at minimum:

```bash
python -m unittest tests/test_rescue_result_handoff_to_recovery_planning_contract.py
godot --headless --path . --script tests/rescue_recovery_handoff_policy_test.gd
godot --headless --path . --script tests/rescue_recovery_handoff_save_migration_test.gd
godot --headless --path . --script tests/rescue_recovery_handoff_scene_flow_test.gd
```

Then run the repository’s full ANNUAL, Canon v2 migration, focused scene, save/load and Godot regression commands. Record exact commands, exit codes and run IDs.

- [ ] **Step 5: Perform Human QA only after separate authorization**

Verify:

- responsibility warnings are understandable before confirmation.
- warnings do not create repetitive confirmation fatigue.
- bad rescue states retain meaningful choices without erasing irreversible consequences.
- manual access, pause, alternative input and time relief remain neutral.
- color/audio-only cues are not required.

Record `HUMAN_QA_NOT_RUN` until this is actually performed. Record `UI_ACCESSIBILITY_NOT_RUN` until accessibility verification is actually performed.

- [ ] **Step 6: Commit implementation evidence without merging**

```bash
git add scripts tests TEST_CHECKLIST.md
git commit -m "test: verify rescue recovery handoff flow"
```

Keep PR #151 draft/open/unmerged. `MERGE_NOT_AUTHORIZED` remains in force until the user separately authorizes batch merge.

---

## Plan Self-Review

- Decision 121 requirements are covered by Tasks 1–6.
- The policy, persistence, scene integration and reporting boundaries use consistent field names.
- No runtime execution is authorized by this planning artifact.
- No exact balance values, final UI layout, images, animation, HX or audio are invented.
- The plan preserves Decision 119 pattern truth and Decision 120 independent result outcomes.
- The plan includes RED, GREEN, regression, save migration, Human QA and accessibility gates.

Current status: `IMPLEMENTATION_NOT_AUTHORIZED / HUMAN_QA_NOT_RUN / UI_ACCESSIBILITY_NOT_RUN / BATCH_MERGE_NOT_STARTED / MERGE_NOT_AUTHORIZED`.
