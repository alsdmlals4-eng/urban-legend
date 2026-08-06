# Protection Obligation Cost, Priority, and Termination Eligibility Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement Decision `DEC-20260806-122-CANON-V2-PROTECTION-OBLIGATION-COST-PRIORITY-AND-RECOVERY-TERMINATION-ELIGIBILITY` so protection obligations can transparently affect related action costs, display priority, and recovery termination eligibility without changing pattern truth or collapsing control and protection outcomes.

**Architecture:** Add a focused `protection_obligation_policy.gd` pure policy module. It consumes obligations produced by `rescue_recovery_handoff_policy.gd`, returns deterministic action previews and priority ordering, and supplies obligation status evidence to `recovery_outcome_policy.gd`. `GameState` persists source records and applied IDs; battle and result scenes only render and commit policy outputs.

**Tech Stack:** Godot 4.7.1, GDScript, existing headless Godot test harness, Python documentation contracts, JSON save migration.

## Global Constraints

- Decision authority: `DEC-20260806-122-CANON-V2-PROTECTION-OBLIGATION-COST-PRIORITY-AND-RECOVERY-TERMINATION-ELIGIBILITY`.
- `IMPLEMENTATION_NOT_AUTHORIZED`: this plan is not execution authorization.
- Keep `HUMAN_QA_NOT_RUN`, `UI_ACCESSIBILITY_NOT_RUN`, `BATCH_MERGE_NOT_STARTED`, and `MERGE_NOT_AUTHORIZED` until separate evidence and approval exist.
- Do not merge PR #149 or PR #151.
- Cost, display priority, and termination eligibility remain separate channels.
- No global responsibility currency or global action tax.
- Costs apply to related actions only and show `base cost`, `additional cost`, and `source_reason` before confirmation.
- Observation, anomaly manual access, result preview, accessibility alternative input, and time-pressure accommodation are free and outcome-neutral.
- `priority_class` is information ordering, never automatic action, forced target selection, or hidden success-rate modification.
- `pattern_id`, `correct_response_id`, clue meaning, and authored valid-candidate calculation never change.
- Incomplete protection obligations do not automatically downgrade `residue_recovered`, `containment_complete`, `stabilization_complete`, or `emergency_containment`.
- `approved_withdrawal` requires accountable protection handling; retreat remains selectable when it is ineligible.
- Save migration is atomic, rollback-safe, and idempotent.
- Existing start-stability modifiers remain `LEGACY_NUMERIC_HANDOFF`; do not reinterpret them as protection-obligation costs.

---

## File Structure

### Create

- `scripts/core/protection_obligation_policy.gd` — pure cost, priority, alternative, transfer, and obligation-state evaluation.
- `tests/protection_obligation_policy_test.gd` — policy behavior and deterministic ordering.
- `tests/protection_obligation_save_resume_test.gd` — atomic persistence and idempotence.
- `tests/recovery_termination_obligation_eligibility_test.gd` — control outcome independence and approved-withdrawal gates.
- `tests/battle_protection_obligation_preview_test.gd` — action and termination preview integration.
- `tests/result_protection_obligation_reporting_test.gd` — equal control/protection reporting.

### Modify after their earlier approved plans create them

- `scripts/core/rescue_recovery_handoff_policy.gd` — emit normalized obligation priority and cost-source metadata.
- `scripts/core/recovery_outcome_policy.gd` — consume termination eligibility evidence without collapsing result axes.

### Modify existing runtime

- `scripts/core/game_state.gd` — persist obligations, cost adjustments, applied IDs, transfers, and termination evaluations.
- `scripts/scenes/minigame_scene.gd` — finalize the handoff once without inventing new obligation costs.
- `scripts/scenes/battle_scene.gd` — request previews, render alternatives, and commit one atomic action result.
- `scripts/scenes/result_scene.gd` — report control result, protection status, cost history, and follow-up responsibility.
- relevant save/migration tests and CI registration files already used by the repository.

---

### Task 1: Pure protection obligation policy

**Files:**
- Create: `scripts/core/protection_obligation_policy.gd`
- Create: `tests/protection_obligation_policy_test.gd`

**Interfaces:**
- Consumes: `Array[Dictionary] obligations`, action dictionary, current context dictionary.
- Produces:
  - `evaluate_action(obligations: Array, action: Dictionary, context: Dictionary) -> Dictionary`
  - `sort_obligations(obligations: Array) -> Array`
  - `validate_transfer(obligation: Dictionary, transfer: Dictionary) -> Dictionary`
  - `normalize_cost_adjustments(adjustments: Array) -> Array`

- [ ] **Step 1: Write the failing test**

```gdscript
func test_cost_applies_only_to_related_action_and_information_actions_are_free() -> void:
    var policy = ProtectionObligationPolicy.new()
    var obligations := [{
        "obligation_id": "ob_victim_guard",
        "target": "victim_001",
        "responsibility_type": "protection",
        "source_reason": "partial_separation",
        "priority_class": "critical",
        "priority_reason": "damage_transfer_risk",
        "affected_actions": ["attack"],
        "status": "unresolved",
        "created_order": 1
    }]

    var attack_preview := policy.evaluate_action(
        obligations,
        {"action_id": "attack", "base_cost": 1},
        {"available_supports": ["shield"]}
    )
    var observe_preview := policy.evaluate_action(
        obligations,
        {"action_id": "observe", "base_cost": 0},
        {}
    )

    assert_eq(attack_preview.get("base_cost"), 1)
    assert_true(int(attack_preview.get("additional_cost", 0)) > 0 or not attack_preview.get("risk_changes", []).is_empty())
    assert_eq(observe_preview.get("additional_cost"), 0)
    assert_true(observe_preview.get("allowed", false))
```

- [ ] **Step 2: Run test to verify it fails**

Run:

```bash
godot --headless --path . --script res://tests/protection_obligation_policy_test.gd
```

Expected: FAIL because `res://scripts/core/protection_obligation_policy.gd` does not exist.

- [ ] **Step 3: Write the minimal policy shell**

```gdscript
class_name ProtectionObligationPolicy
extends RefCounted

const PRIORITY_ORDER := {
    "critical": 0,
    "urgent": 1,
    "watch": 2
}

func evaluate_action(obligations: Array, action: Dictionary, context: Dictionary) -> Dictionary:
    var action_id := String(action.get("action_id", ""))
    var related: Array = []
    for obligation_value in obligations:
        var obligation: Dictionary = obligation_value
        if action_id in _to_string_array(obligation.get("affected_actions", [])):
            related.append(obligation)
    return {
        "action_id": action_id,
        "allowed": true,
        "base_cost": int(action.get("base_cost", 0)),
        "additional_cost": 0 if action_id in ["observe", "open_manual", "preview_result"] else related.size(),
        "cost_adjustments": _make_adjustments(related, action_id),
        "risk_changes": _make_risk_changes(related),
        "alternatives": _make_alternatives(related, context)
    }
```

Implement helpers with exact stable IDs:

```gdscript
func _make_adjustment_id(obligation_id: String, action_id: String, cost_channel: String) -> String:
    return "%s:%s:%s" % [obligation_id, action_id, cost_channel]
```

- [ ] **Step 4: Add deterministic priority tests**

```gdscript
func test_priority_sort_is_deterministic() -> void:
    var sorted := ProtectionObligationPolicy.new().sort_obligations([
        {"obligation_id": "b", "priority_class": "urgent", "created_order": 2},
        {"obligation_id": "a", "priority_class": "critical", "created_order": 3},
        {"obligation_id": "c", "priority_class": "urgent", "created_order": 1}
    ])
    assert_eq(sorted.map(func(v): return v["obligation_id"]), ["a", "c", "b"])
```

Sorting key:

```gdscript
func _priority_key(obligation: Dictionary) -> Array:
    return [
        int(PRIORITY_ORDER.get(String(obligation.get("priority_class", "watch")), 2)),
        int(obligation.get("created_order", 0)),
        String(obligation.get("obligation_id", ""))
    ]
```

- [ ] **Step 5: Add duplicate-cost normalization tests**

Assert that two adjustments with the same `cost_adjustment_id` and same payload collapse to one, while conflicting payloads return `validation_errors` and apply neither.

- [ ] **Step 6: Run focused tests**

```bash
godot --headless --path . --script res://tests/protection_obligation_policy_test.gd
```

Expected: PASS with zero errors and warnings from the new policy tests.

- [ ] **Step 7: Commit**

```bash
git add scripts/core/protection_obligation_policy.gd tests/protection_obligation_policy_test.gd
git commit -m "feat: add protection obligation policy"
```

---

### Task 2: Normalize obligation metadata at handoff

**Files:**
- Modify: `scripts/core/rescue_recovery_handoff_policy.gd`
- Modify: `tests/rescue_recovery_handoff_policy_test.gd`

**Interfaces:**
- Consumes: immutable rescue snapshot and authored case adapter.
- Produces obligations containing:
  - `obligation_id`
  - `priority_class`
  - `priority_reason`
  - `created_order`
  - `affected_actions`
  - authored `cost_rules`
  - `completion_condition`
  - `breach_consequence`

- [ ] **Step 1: Write the failing test**

```gdscript
func test_handoff_obligation_has_cost_and_priority_provenance() -> void:
    var result := RescueRecoveryHandoffPolicy.new().derive_handoff(
        {"survival_state": "alive_critical", "separation_state": "partial"},
        {"case_id": "afterlife_station"}
    )
    var obligation: Dictionary = result["active_protection_obligations"][0]
    assert_false(String(obligation.get("obligation_id", "")).is_empty())
    assert_eq(obligation.get("priority_class"), "critical")
    assert_false(String(obligation.get("priority_reason", "")).is_empty())
    assert_true(int(obligation.get("created_order", -1)) >= 0)
    assert_false(obligation.get("affected_actions", []).is_empty())
```

- [ ] **Step 2: Run test to verify it fails**

Expected: FAIL because Decision 121's future policy does not yet emit Decision 122 metadata.

- [ ] **Step 3: Add validation**

Reject obligations where:

```gdscript
if obligation_id.is_empty(): errors.append("missing_obligation_id")
if not priority_class in ["critical", "urgent", "watch"]: errors.append("invalid_priority_class")
if source_reason.is_empty(): errors.append("missing_source_reason")
```

Do not infer `critical` from a legacy success/failure bool.

- [ ] **Step 4: Verify focused handoff tests pass**

Run the handoff policy test suite and the Decision 121 migration suite.

- [ ] **Step 5: Commit**

```bash
git add scripts/core/rescue_recovery_handoff_policy.gd tests/rescue_recovery_handoff_policy_test.gd
git commit -m "feat: add obligation priority and cost provenance"
```

---

### Task 3: Recovery termination eligibility policy

**Files:**
- Modify: `scripts/core/recovery_outcome_policy.gd`
- Create: `tests/recovery_termination_obligation_eligibility_test.gd`

**Interfaces:**
- Consumes: control-state evidence, active obligations, safe-route evidence, transfer records.
- Produces:
  - `evaluate_termination_candidate(candidate: String, context: Dictionary) -> Dictionary`
  - fields `termination_candidate`, `eligible`, `blocking_reasons`, `non_blocking_consequences`, `accountable_transfer`.

- [ ] **Step 1: Write the failing independence test**

```gdscript
func test_residue_recovered_is_not_downgraded_by_unresolved_nonblocking_obligation() -> void:
    var result := RecoveryOutcomePolicy.new().evaluate_termination_candidate(
        "residue_recovered",
        {
            "control_evidence": {"residue_secured": true, "spread_controlled": true},
            "obligations": [{"obligation_id": "ob_records", "status": "unresolved", "priority_class": "watch"}]
        }
    )
    assert_true(result["eligible"])
    assert_true(result["blocking_reasons"].is_empty())
    assert_false(result["non_blocking_consequences"].is_empty())
```

- [ ] **Step 2: Run test to verify it fails**

Expected: FAIL because obligation-aware termination evaluation does not exist.

- [ ] **Step 3: Write approved-withdrawal gate tests**

```gdscript
func test_approved_withdrawal_rejects_unaccounted_critical_obligation_but_retreat_remains_selectable() -> void:
    var result := RecoveryOutcomePolicy.new().evaluate_termination_candidate(
        "approved_withdrawal",
        {
            "safe_route": true,
            "withdrawal_reason_recorded": true,
            "before_control_collapse": true,
            "obligations": [{
                "obligation_id": "ob_evacuation",
                "priority_class": "critical",
                "status": "unresolved"
            }]
        }
    )
    assert_false(result["eligible"])
    assert_true(result["retreat_selectable"])
    assert_eq(result["fallback_outcome"], "control_failure")
    assert_false(result["blocking_reasons"].is_empty())
```

Also test:

- valid `completed`
- valid `transferred` with `accountable_owner`
- valid `deferred_with_owner` with `follow_up_condition`
- invalid nominal transfer
- `breached` with accountable follow-up

- [ ] **Step 4: Implement minimal candidate evaluation**

```gdscript
func evaluate_termination_candidate(candidate: String, context: Dictionary) -> Dictionary:
    var blocking: Array = _control_blockers(candidate, context)
    var non_blocking: Array = _protection_consequences(context.get("obligations", []))
    if candidate == "approved_withdrawal":
        blocking.append_array(_withdrawal_obligation_blockers(context))
    return {
        "termination_candidate": candidate,
        "eligible": blocking.is_empty(),
        "blocking_reasons": blocking,
        "non_blocking_consequences": non_blocking,
        "accountable_transfer": _valid_transfers(context),
        "retreat_selectable": true,
        "fallback_outcome": "control_failure" if candidate == "approved_withdrawal" and not blocking.is_empty() else ""
    }
```

- [ ] **Step 5: Run tests**

Run the new suite plus existing recovery outcome policy tests. Expected: PASS.

- [ ] **Step 6: Commit**

```bash
git add scripts/core/recovery_outcome_policy.gd tests/recovery_termination_obligation_eligibility_test.gd
git commit -m "feat: evaluate protection-aware termination eligibility"
```

---

### Task 4: GameState persistence and save migration

**Files:**
- Modify: `scripts/core/game_state.gd`
- Create: `tests/protection_obligation_save_resume_test.gd`
- Modify: existing save migration test registration files.

**Interfaces:**
- Produces getters and atomic mutation methods:
  - `get_active_protection_obligations() -> Array`
  - `get_protection_history() -> Array`
  - `preview_recovery_action(action: Dictionary) -> Dictionary`
  - `commit_recovery_action(preview_id: String) -> Dictionary`
  - `evaluate_recovery_termination(candidate: String) -> Dictionary`

- [ ] **Step 1: Write the failing save/resume test**

```gdscript
func test_applied_cost_adjustment_is_not_reapplied_after_load() -> void:
    var state = GameState.new()
    state.set_test_protection_obligations([_critical_guard_obligation()])
    var preview := state.preview_recovery_action({"action_id": "attack", "base_cost": 1})
    var first := state.commit_recovery_action(preview["preview_id"])
    var saved := state.make_save_data()

    var loaded = GameState.new()
    loaded.restore_save_data(saved)
    var second := loaded.commit_recovery_action(preview["preview_id"])

    assert_true(first["committed"])
    assert_false(second["committed"])
    assert_eq(second["error"], "cost_adjustment_already_applied")
```

- [ ] **Step 2: Run test to verify it fails**

Expected: FAIL because GameState does not persist obligation policy state.

- [ ] **Step 3: Add separate save fields**

```gdscript
var active_protection_obligations: Array = []
var protection_history: Array = []
var applied_cost_adjustment_ids: Array = []
var recovery_termination_evaluations: Array = []
```

Persist them separately from `minigame_results`, `victim_state`, `recovery_successful`, and legacy numeric handoff values.

- [ ] **Step 4: Add atomic commit logic**

Compute a deep-copy candidate state. Validate all adjustments and obligation transitions. Replace live state only after all validations succeed. On failure, return the error and preserve the previous state.

- [ ] **Step 5: Add conservative migration tests**

Legacy save input:

```json
{
  "minigame_results": {"minigame_frequency_sync": {"successful": false}},
  "recovery_result_stability": 80
}
```

Expected:

- preserve original values and provenance
- label as `LEGACY_NUMERIC_HANDOFF`
- do not invent obligations, priority classes, cost adjustments, transfer owners, or withdrawal blockers

- [ ] **Step 6: Run save migration and full GameState focused tests**

Expected: PASS and no duplicate application after repeated save/load cycles.

- [ ] **Step 7: Commit**

```bash
git add scripts/core/game_state.gd tests/protection_obligation_save_resume_test.gd tests
git commit -m "feat: persist protection obligation policy state"
```

---

### Task 5: Battle action and termination previews

**Files:**
- Modify: `scripts/scenes/battle_scene.gd`
- Create: `tests/battle_protection_obligation_preview_test.gd`

**Interfaces:**
- Consumes GameState preview dictionaries.
- Does not recalculate policy in the scene.
- Commits only the exact `preview_id` currently displayed.

- [ ] **Step 1: Write the failing action-preview test**

Assert that selecting an affected attack shows:

- base cost
- additional cost
- source reason
- risk target
- alternatives
- confirm and cancel actions

Assert that observation and anomaly manual access remain enabled and free.

- [ ] **Step 2: Run test to verify it fails**

Expected: FAIL because battle scene has no protection-obligation preview panel.

- [ ] **Step 3: Add preview-only scene binding**

Scene logic:

```gdscript
func _on_recovery_action_selected(action: Dictionary) -> void:
    var preview := GameState.preview_recovery_action(action)
    _render_action_preview(preview)
    pending_preview_id = String(preview.get("preview_id", ""))
```

Do not mutate resources or obligations until confirmation.

- [ ] **Step 4: Add termination preview**

```gdscript
func _on_termination_candidate_selected(candidate: String) -> void:
    var preview := GameState.evaluate_recovery_termination(candidate)
    _render_termination_preview(preview)
```

Show blocking reasons, non-blocking consequences, accountable transfer, and fallback outcome. Retreat remains selectable even when approved withdrawal is ineligible.

- [ ] **Step 5: Add focus and accessibility tests**

- keyboard, pointer, gamepad, and screen-reader labels expose the same information
- color and audio are not the sole priority signals
- cancel returns focus to the selected action
- time-pressure accommodation does not alter cost or eligibility

- [ ] **Step 6: Run focused battle tests**

Expected: PASS with no scene errors.

- [ ] **Step 7: Commit**

```bash
git add scripts/scenes/battle_scene.gd tests/battle_protection_obligation_preview_test.gd
git commit -m "feat: preview protection costs and termination eligibility"
```

---

### Task 6: Result reporting and independent axes

**Files:**
- Modify: `scripts/scenes/result_scene.gd`
- Create: `tests/result_protection_obligation_reporting_test.gd`

**Interfaces:**
- Consumes finalized independent result packet.
- Renders control and protection axes as equal headlines.

- [ ] **Step 1: Write the failing result test**

Scenario:

- representative control result: `residue_recovered`
- one `breached` protection obligation
- one valid `deferred_with_owner`

Expected:

- `residue_recovered` remains visible
- protection breach remains visible
- follow-up owner and condition remain visible
- no single global mission success/failure banner

- [ ] **Step 2: Run test to verify it fails**

Expected: FAIL because result scene does not yet render obligation policy fields.

- [ ] **Step 3: Add reporting groups**

```text
피해자 결과
회수 결과
보호 의무 결과
비용·손실·위반 인과
책임 이관·후속 조건
```

Show `blocking_reasons` and `non_blocking_consequences` separately.

- [ ] **Step 4: Add accessibility tests**

Ensure screen-reader order matches visual hierarchy and does not omit owner, follow-up, or breach reason.

- [ ] **Step 5: Run focused result tests**

Expected: PASS.

- [ ] **Step 6: Commit**

```bash
git add scripts/scenes/result_scene.gd tests/result_protection_obligation_reporting_test.gd
git commit -m "feat: report protection obligations independently"
```

---

### Task 7: End-to-end regression and migration safety

**Files:**
- Modify: CI/test registration only as required by repository conventions.
- Test: all new suites and existing Canon v2 migration/full regression suites.

- [ ] **Step 1: Run Python documentation contracts**

```bash
python -m unittest tests/test_protection_obligation_cost_priority_and_termination_eligibility_planning_contract.py
```

Expected: PASS.

- [ ] **Step 2: Run focused Godot suites**

```bash
godot --headless --path . --script res://tests/protection_obligation_policy_test.gd
godot --headless --path . --script res://tests/protection_obligation_save_resume_test.gd
godot --headless --path . --script res://tests/recovery_termination_obligation_eligibility_test.gd
godot --headless --path . --script res://tests/battle_protection_obligation_preview_test.gd
godot --headless --path . --script res://tests/result_protection_obligation_reporting_test.gd
```

Expected: all PASS.

- [ ] **Step 3: Run existing Decision 119–121 and Canon v2 migration suites**

Verify:

- pattern selection truth unchanged
- rescue snapshot immutable
- outcome states independent
- legacy saves preserved conservatively

- [ ] **Step 4: Run full Godot regression**

Use the same command executed by `Validate ANNUAL-MVP-001`. Expected: zero failures.

- [ ] **Step 5: Inspect changed-file scope**

Confirm no unapproved Episode JSON, Canon v2 sidecar, image, animation, HX, audio, or unrelated asset changes.

- [ ] **Step 6: Commit verification wiring**

```bash
git add .github tests docs
git commit -m "test: verify protection obligation integration"
```

---

### Task 8: Human QA and UI/accessibility handoff

**Files:**
- Modify future Human QA checklist and evidence records only after runtime implementation approval.

- [ ] **Step 1: Prepare scenario matrix**

Include:

1. critical obligation affecting one action only
2. duplicate obligations with one source reason
3. observation/manual access under critical warning
4. valid transferred responsibility
5. invalid nominal transfer
6. valid deferred_with_owner
7. residue recovery with protection breach
8. approved withdrawal blocked but retreat selectable
9. repeated save/load after applied cost
10. keyboard, gamepad, screen reader, and time-pressure accommodation

- [ ] **Step 2: Record comprehension questions**

Ask players to identify:

- base cost versus additional cost
- why an obligation is critical/urgent/watch
- which actions remain available
- why a termination candidate is eligible or blocked
- which consequences do not block the result
- who owns follow-up responsibility

- [ ] **Step 3: Keep QA gates closed until evidence exists**

Do not change these statuses based on automated tests alone:

- `HUMAN_QA_NOT_RUN`
- `UI_ACCESSIBILITY_NOT_RUN`
- `MERGE_NOT_AUTHORIZED`

- [ ] **Step 4: Request separate implementation and merge approval**

Only after all automated and Human QA evidence is attached may the user separately authorize implementation completion, PR readiness, or merge.

---

## Plan Self-Review

### Spec coverage

- Three-channel separation: Tasks 1 and 3.
- Causal visible costs and free information access: Tasks 1 and 5.
- Deterministic non-forcing priority: Task 1.
- Fail-forward alternatives: Tasks 1 and 5.
- Independent control/protection outcomes: Tasks 3 and 6.
- Approved withdrawal responsibility gates: Task 3.
- Atomic idempotent save migration: Task 4.
- Pattern and accessibility neutrality: Tasks 1, 5, and 6.
- Full regression and Human QA: Tasks 7 and 8.

### Placeholder scan

The plan contains no `TODO`, `TBD`, or unspecified implementation steps. Exact numeric balance values remain intentionally outside the approved design and are not required to implement the semantic policy contract.

### Type consistency

- Obligations are `Array[Dictionary]` throughout.
- Policy previews and termination evaluations are `Dictionary` values.
- Stable IDs are strings.
- `priority_class` values are `critical`, `urgent`, and `watch`.
- Obligation statuses are `completed`, `transferred`, `deferred_with_owner`, `breached`, and `unresolved`.

## Execution Boundary

Plan saved for future execution. Current status remains:

- `IMPLEMENTATION_NOT_AUTHORIZED`
- `HUMAN_QA_NOT_RUN`
- `UI_ACCESSIBILITY_NOT_RUN`
- `BATCH_MERGE_NOT_STARTED`
- `MERGE_NOT_AUTHORIZED`
