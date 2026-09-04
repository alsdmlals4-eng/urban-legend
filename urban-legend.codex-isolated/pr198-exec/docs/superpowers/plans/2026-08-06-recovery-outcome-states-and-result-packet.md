# Recovery Outcome States and Result Packet Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.
>
> **Authorization gate:** `IMPLEMENTATION_NOT_AUTHORIZED`. This plan is approved as planning authority by `DEC-20260806-120-CANON-V2-RECOVERY-OUTCOME-STATES-AND-INDEPENDENT-RESULT-PACKET`, but no runtime, Scene, Episode JSON, save schema, asset, Human QA, or merge work may start without a separate explicit user approval.

**Goal:** Replace the `core_recovered`-centered single outcome with six representative recovery outcomes plus an independently persisted result packet that preserves victim, responsibility, loss, evidence, and follow-up state.

**Architecture:** Add a pure recovery outcome policy that evaluates a complete field snapshot and returns one representative outcome with reason codes. Persist that result beside independent packet axes in `GameState`, derive legacy bool fields only through a compatibility adapter, then make battle termination and result reporting consume the status-first packet. Existing pattern selection and judgment remain unchanged.

**Tech Stack:** Godot 4.7.1, GDScript, existing `GameState`, `battle_scene.gd`, `result_scene.gd`, headless Godot test suites, Python documentation contracts.

## Global Constraints

- Decision authority: `DEC-20260806-120-CANON-V2-RECOVERY-OUTCOME-STATES-AND-INDEPENDENT-RESULT-PACKET`.
- Representative outcomes: `residue_recovered`, `containment_complete`, `stabilization_complete`, `emergency_containment`, `approved_withdrawal`, `control_failure`.
- Outcome classes: `FULL_SUCCESS`, `CONTROL_SUCCESS`, `PROVISIONAL_SUCCESS`, `PARTIAL_SUCCESS`, `STRATEGIC_EXIT`, `FAILURE`.
- `core_recovered` is `LEGACY_SINGLE_OUTCOME`.
- `recovery_successful` and `capture_success` are `LEGACY_COMPAT_ONLY`.
- Representative status is authoritative; bool fields never decide approved withdrawal versus control failure.
- Rescue and recovery results never overwrite one another.
- Accessibility-equivalent input and presentation do not alter outcomes, rewards, or rank.
- Every production change follows RED → GREEN → REFACTOR with fresh full regression evidence.
- PR #149 and PR #151 remain unmerged until separate authorization.

---

## File Map

### Create

- `scripts/core/recovery_outcome_policy.gd` — pure outcome evaluation and catalog metadata.
- `tests/test_recovery_outcome_policy.gd` — representative outcome boundary tests.
- `tests/test_recovery_result_packet_persistence.gd` — save/load and legacy migration tests.
- `tests/test_recovery_result_reporting.gd` — report snapshot and result-screen model tests.

### Modify

- `scripts/core/game_state.gd` — packet state, save/load, compatibility derivation, report snapshot.
- `scripts/scenes/battle_scene.gd` — build an evaluation snapshot and request a status-first termination.
- `scripts/scenes/result_scene.gd` — render independent victim/recovery headlines and packet sections.
- `scripts/data/case_data.gd` — normalize optional case-authored outcome labels and follow-up text without deciding global meaning.
- `tests/run_tests.gd` — register new focused suites if the repository runner requires explicit registration.
- `.github/workflows/validate-annual-mvp-001.yml` — add focused outcome and persistence suites only if the current runner does not discover them automatically.

---

### Task 1: Add the Pure Recovery Outcome Policy

**Files:**
- Create: `scripts/core/recovery_outcome_policy.gd`
- Create: `tests/test_recovery_outcome_policy.gd`

**Interfaces:**
- Consumes: `Dictionary field_snapshot` with explicit boolean and evidence fields.
- Produces: `RecoveryOutcomePolicy.evaluate(field_snapshot: Dictionary) -> Dictionary`.
- Produces: `RecoveryOutcomePolicy.get_outcome_definition(outcome_id: String) -> Dictionary`.
- Produces packet fragment:

```gdscript
{
    "id": "containment_complete",
    "label": "봉쇄 완료",
    "class": "CONTROL_SUCCESS",
    "reason_codes": PackedStringArray(),
    "excluded_higher_outcomes": PackedStringArray()
}
```

- [ ] **Step 1: Write the failing test**

Create `tests/test_recovery_outcome_policy.gd` with one test per semantic boundary. The initial test file must include this exact minimum:

```gdscript
extends Node

const Policy = preload("res://scripts/core/recovery_outcome_policy.gd")

func _assert_outcome(snapshot: Dictionary, expected_id: String, expected_class: String) -> void:
    var result := Policy.evaluate(snapshot)
    assert(String(result.get("id", "")) == expected_id)
    assert(String(result.get("class", "")) == expected_class)

func test_residue_requires_control_and_residue() -> void:
    _assert_outcome({
        "immediate_hazard_stopped": true,
        "spread_paths_closed": true,
        "containment_durable": true,
        "residue_secured": true,
        "control_lost": false
    }, "residue_recovered", "FULL_SUCCESS")

func test_residue_without_closed_spread_path_is_not_full_success() -> void:
    _assert_outcome({
        "immediate_hazard_stopped": true,
        "spread_paths_closed": false,
        "containment_durable": false,
        "residue_secured": true,
        "emergency_barrier_active": true,
        "control_lost": false
    }, "emergency_containment", "PARTIAL_SUCCESS")

func test_approved_withdrawal_requires_all_responsibility_gates() -> void:
    _assert_outcome({
        "withdrawal_requested": true,
        "withdrawal_route_safe": true,
        "withdrawal_reason_recorded": true,
        "protected_subjects_accounted": true,
        "critical_records_accounted": true,
        "ended_before_collapse": true,
        "follow_up_recorded": true,
        "control_lost": false
    }, "approved_withdrawal", "STRATEGIC_EXIT")

func test_forced_retreat_is_control_failure() -> void:
    _assert_outcome({
        "withdrawal_requested": true,
        "withdrawal_route_safe": false,
        "ended_before_collapse": false,
        "control_lost": true
    }, "control_failure", "FAILURE")
```

- [ ] **Step 2: Run test to verify it fails**

Run:

```bash
godot --headless --path . --script tests/test_recovery_outcome_policy.gd
```

Expected: FAIL because `scripts/core/recovery_outcome_policy.gd` does not exist.

- [ ] **Step 3: Write the minimal policy implementation**

Create `scripts/core/recovery_outcome_policy.gd` as a stateless `RefCounted` script. Define an immutable catalog and evaluate in this order:

```gdscript
class_name RecoveryOutcomePolicy
extends RefCounted

const OUTCOME_DEFINITIONS := {
    "residue_recovered": {"label": "잔향 회수 완료", "class": "FULL_SUCCESS"},
    "containment_complete": {"label": "봉쇄 완료", "class": "CONTROL_SUCCESS"},
    "stabilization_complete": {"label": "안정화 완료", "class": "PROVISIONAL_SUCCESS"},
    "emergency_containment": {"label": "긴급 봉쇄", "class": "PARTIAL_SUCCESS"},
    "approved_withdrawal": {"label": "승인 철수", "class": "STRATEGIC_EXIT"},
    "control_failure": {"label": "통제 실패", "class": "FAILURE"}
}

static func evaluate(snapshot: Dictionary) -> Dictionary:
    if _qualifies_residue_recovered(snapshot):
        return _make_result("residue_recovered", snapshot)
    if _qualifies_containment_complete(snapshot):
        return _make_result("containment_complete", snapshot)
    if _qualifies_stabilization_complete(snapshot):
        return _make_result("stabilization_complete", snapshot)
    if _qualifies_emergency_containment(snapshot):
        return _make_result("emergency_containment", snapshot)
    if _qualifies_approved_withdrawal(snapshot):
        return _make_result("approved_withdrawal", snapshot)
    return _make_result("control_failure", snapshot)
```

Every qualifier must read explicit fields only. Do not use hidden randomness or a weighted total score.

- [ ] **Step 4: Run test to verify it passes**

Run the focused test and confirm all six outcomes and boundary cases pass with exit code 0.

- [ ] **Step 5: Commit**

```bash
git add scripts/core/recovery_outcome_policy.gd tests/test_recovery_outcome_policy.gd
git commit -m "feat: add recovery outcome policy"
```

---

### Task 2: Persist the Independent Result Packet and Legacy Adapter

**Files:**
- Modify: `scripts/core/game_state.gd`
- Create: `tests/test_recovery_result_packet_persistence.gd`

**Interfaces:**
- Produces: `save_recovery_result_packet(packet: Dictionary) -> void`.
- Produces: `get_recovery_result_packet() -> Dictionary`.
- Produces: `derive_legacy_recovery_success(outcome_id: String) -> bool`.
- Produces: `migrate_legacy_recovery_result(save_data: Dictionary) -> Dictionary`.
- Uses nested `recovery_result_packet_schema_version: 1` without changing the global save version in this isolated task.

- [ ] **Step 1: Write the failing test**

The persistence suite must verify:

```gdscript
func test_round_trip_preserves_independent_axes() -> void:
    var packet := {
        "schema_version": 1,
        "representative_outcome": {"id": "emergency_containment", "class": "PARTIAL_SUCCESS"},
        "victim_outcome": {"survival": "alive", "separation": "partial"},
        "protection_obligations": {"remaining": ["continuous_monitoring"]},
        "personnel_and_equipment": {"injured_agents": ["agent_kang_ijun"]},
        "site_and_public_exposure": {"site_state": "damaged"},
        "evidence_and_records": {"residue_secured": false},
        "follow_up_obligations": {"reentry_required": true},
        "causal_history": [{"reason": "temporary_barrier_only"}]
    }
    GameState.save_recovery_result_packet(packet)
    assert(GameState.get_recovery_result_packet() == packet)
```

Also assert:

- `approved_withdrawal` derives legacy false but is not labeled failure.
- `emergency_containment` derives legacy true but is not labeled full success.
- `capture_success` cannot be the authoritative branch key.
- legacy `core_recovered` migration preserves provenance when evidence is insufficient.

- [ ] **Step 2: Run test to verify it fails**

Run:

```bash
godot --headless --path . --script tests/test_recovery_result_packet_persistence.gd
```

Expected: FAIL because packet APIs do not exist.

- [ ] **Step 3: Add packet state and save migration**

Add to `game_state.gd`:

```gdscript
const RECOVERY_RESULT_PACKET_SCHEMA_VERSION := 1
var recovery_result_packet: Dictionary = {}
```

`save_recovery_result_packet()` must deep-copy and validate required top-level keys. Save data must include `recovery_result_packet`. Loading must prefer the packet and only invoke `migrate_legacy_recovery_result()` when the packet is absent.

The save migration rules are:

```text
core_recovered + sufficient residue/control evidence -> residue_recovered
core_recovered + insufficient evidence -> legacy_core_recovered with provenance
capture_success false + approved withdrawal evidence -> approved_withdrawal
capture_success false without approval evidence -> control_failure or preserved legacy unknown
```

The migration must be atomic, rollback-safe, and idempotent. The phrase `save migration` must remain in test and implementation comments so the audit trail is searchable.

- [ ] **Step 4: Run focused persistence and existing migration tests**

Run the new packet suite and the existing Canon v2 migration suite. Confirm round-trip equality, legacy provenance, rollback, and idempotency.

- [ ] **Step 5: Commit**

```bash
git add scripts/core/game_state.gd tests/test_recovery_result_packet_persistence.gd
git commit -m "feat: persist recovery result packet"
```

---

### Task 3: Route Battle Termination Through the Outcome Policy

**Files:**
- Modify: `scripts/scenes/battle_scene.gd`
- Modify: `scripts/data/case_data.gd`
- Test: `tests/test_recovery_outcome_policy.gd`

**Interfaces:**
- Consumes: `RecoveryOutcomePolicy.evaluate(snapshot)`.
- Produces: `_build_recovery_outcome_snapshot(requested_action: String) -> Dictionary`.
- Produces: `_finalize_recovery_outcome(requested_action: String) -> void`.

- [ ] **Step 1: Write the failing test**

Add integration tests that prove:

- meeting the old stability threshold alone does not always create `residue_recovered`;
- a durable sealed route without residue creates `containment_complete`;
- an active temporary barrier creates `emergency_containment`;
- withdrawal without all gates creates `control_failure`;
- selected outcome and independent packet are saved before scene transition.

- [ ] **Step 2: Run test to verify it fails**

Run the focused battle/outcome test. Expected: FAIL because `_recover_anomaly_core()` still writes `core_recovered` directly.

- [ ] **Step 3: Replace direct core_recovered termination**

Keep the existing button and pattern flow, but route termination through:

```gdscript
func _finalize_recovery_outcome(requested_action: String) -> void:
    var snapshot := _build_recovery_outcome_snapshot(requested_action)
    var representative := RecoveryOutcomePolicy.evaluate(snapshot)
    var packet := _build_recovery_result_packet(representative, snapshot)
    GameState.save_recovery_result_packet(packet)
    GameState.set_current_scene_path("res://scenes/result_scene.tscn")
    GameState.save_game()
```

Do not delete the old compatibility fields; derive them inside `GameState` from the representative outcome.

- [ ] **Step 4: Run focused and battle regression tests**

Confirm pattern selection, immediate judgment, support actions, recovery threshold behavior, and scene transition remain green.

- [ ] **Step 5: Commit**

```bash
git add scripts/scenes/battle_scene.gd scripts/data/case_data.gd tests/test_recovery_outcome_policy.gd
git commit -m "feat: finalize recovery through outcome policy"
```

---

### Task 4: Report Victim and Recovery Outcomes Independently

**Files:**
- Modify: `scripts/scenes/result_scene.gd`
- Modify: `scripts/core/game_state.gd`
- Create: `tests/test_recovery_result_reporting.gd`

**Interfaces:**
- Consumes: `GameState.get_recovery_result_packet()`.
- Produces: `GameState.get_case_report_summary()` with the full packet snapshot.
- Produces display model sections for representative outcome, victim outcome, responsibilities/losses, evidence, causality, and follow-up.

- [ ] **Step 1: Write the failing test**

The reporting test must assert:

```text
피해자 결과와 회수 결과를 동등한 헤드라인
단일 임무 성공/실패 배너 금지
승인 철수 -> 전략적 종료
긴급 봉쇄 -> 부분 성공
통제 실패 -> 통제 실패
```

Also verify that a packet containing `residue_recovered` plus a lost victim preserves both values in the report model.

- [ ] **Step 2: Run test to verify it fails**

Run the focused reporting test. Expected: FAIL because the result scene only consumes the legacy status and stability fields.

- [ ] **Step 3: Build the new result sections**

Refactor `_add_result_panel()` into focused helpers:

```gdscript
_add_headline_outcomes(parent, packet, victim_result)
_add_responsibility_and_loss_section(parent, packet)
_add_evidence_and_causality_section(parent, packet)
_add_follow_up_section(parent, packet)
```

The victim and recovery cards must share the same heading level. Do not add a global success/failure banner. Use text and icons in addition to color.

- [ ] **Step 4: Run reporting, accessibility, and existing result tests**

Confirm keyboard focus order, screen-reader-friendly labels, color-independent text, report persistence, and existing manual/danger-case summaries remain intact.

- [ ] **Step 5: Commit**

```bash
git add scripts/scenes/result_scene.gd scripts/core/game_state.gd tests/test_recovery_result_reporting.gd
git commit -m "feat: report independent recovery outcomes"
```

---

### Task 5: Validate Reward and Follow-Up Consumers

**Files:**
- Modify: `scripts/core/game_state.gd`
- Modify only confirmed consumers returned by repository search for `capture_success`, `recovery_successful`, and `core_recovered`.
- Test: existing campaign, reward, faction, and case-report suites.

**Interfaces:**
- Consumes: representative outcome ID/class plus independent packet.
- Produces: compatibility bool only for legacy callers.

- [ ] **Step 1: Write the failing consumer tests**

Add tests for these required meanings:

- `emergency_containment` cannot receive full residue recovery rewards;
- `approved_withdrawal` preserves collected evidence and victim rescue results without a failure stigma;
- `control_failure` preserves prior rescue/evidence and creates emergency follow-up;
- accessibility settings never lower outcome or reward;
- no new consumer branches only on `capture_success`.

- [ ] **Step 2: Run tests to verify they fail**

Run focused reward/campaign/report tests. Confirm failures identify legacy bool-only branches.

- [ ] **Step 3: Convert consumers to status-first logic**

Use representative outcome ID/class first. Keep bool fallback only when loading a legacy record without a result packet.

- [ ] **Step 4: Run all focused consumers**

Confirm rewards, next-case notes, faction effects, campaign completion, report history, and save summaries match the new meaning.

- [ ] **Step 5: Commit**

Commit only the confirmed consumers and tests changed in this task.

---

### Task 6: Full Verification and Human QA Handoff

**Files:**
- Modify: `TEST_CHECKLIST.md` only after runtime implementation authorization.
- Modify: relevant Human QA runner docs only after runtime implementation authorization.

- [ ] **Step 1: Run documentation and Python contracts**

Run the same command used by `.github/workflows/validate-base-operating-sync.yml`. Expected: all tests pass.

- [ ] **Step 2: Run focused Godot suites**

Run policy, persistence, battle integration, reporting, Canon v2 migration, and result persistence suites. Expected: all pass.

- [ ] **Step 3: Run the full Godot regression**

Run the repository full regression exactly as CI does. Expected: exit code 0 with no failed tests.

- [ ] **Step 4: Execute Human QA only after separate authorization**

Human QA scenarios:

1. Explain the difference between stabilization, containment, and emergency containment.
2. Trigger approved withdrawal and distinguish it from forced retreat.
3. Observe `residue_recovered + victim_lost` and confirm neither result hides the other.
4. Verify remaining protection and follow-up obligations.
5. Repeat with keyboard, gamepad, reduced motion, enlarged text, and time-pressure relief.

Until executed, retain `HUMAN_QA_NOT_RUN / UI_ACCESSIBILITY_NOT_RUN`.

- [ ] **Step 5: Adversarial review and PR gate**

Review for bool-only branches, hidden score aggregation, accidental result overwrites, migration data loss, and inaccessible result cues. Keep PR #151 Draft and unmerged until explicit batch/merge authorization.

---

## Plan Self-Review

- Spec coverage: all six outcomes, approval gates, independent packet axes, legacy compatibility, result reporting, rewards, save migration, and QA are assigned to tasks.
- Placeholder scan: no `TODO`, `TBD`, or unspecified implementation step remains.
- Type consistency: every task uses `RecoveryOutcomePolicy.evaluate(Dictionary) -> Dictionary`, `save_recovery_result_packet(Dictionary)`, and `get_recovery_result_packet() -> Dictionary`.
- Scope: the plan changes recovery termination and reporting only; pattern selection and judgment remain Decision 119 authority.

## Execution Gate

This plan is complete as a planning artifact, but execution is blocked by `IMPLEMENTATION_NOT_AUTHORIZED`. A later explicit implementation approval must choose either subagent-driven development or inline executing-plans and must preserve TDD, adversarial review, full regression, Google Sheet synchronization, and no-merge boundaries.
