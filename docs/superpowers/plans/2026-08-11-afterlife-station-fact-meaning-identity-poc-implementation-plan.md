# Afterlife Station Fact → Meaning → Identity PoC Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Prove one bounded `FACT → MEANING → IDENTITY` vertical slice in Afterlife Station by observing chapter-1 deduction, preserving one staff-room investigation choice as incident memory, and surfacing the already-authored Oh Hyun callback without adding a new relationship/identity/save system.

**Architecture:** Reuse the existing Afterlife Canon v2 evidence/manual contract, `GameState` investigation method results, existing one-time agent-event persistence, and the existing result/report presentation. The only planned product-code gap is that `agent_event_oh_breakthrough_warning_01` currently requires trust ≥2 even though its authored text is causally about opening a route; Package 1 adds an explicit incident-context trigger for that same stable event ID while leaving all existing trust-gated events unchanged. Human Thought-Path validation remains evidence-separate and follows the preregistered planning contract in `docs/planning/AFTERLIFE_FACT_MEANING_IDENTITY_POC_HUMAN_PLAYTEST_CONTRACT_2026-08-11.md`.

**Tech Stack:** Godot 4.7.1, GDScript, JSON-backed episode/Canon v2 data, existing Canon v2 runtime test runner, GitHub Actions, Markdown preregistration and Human evidence.

## Global Constraints

- Current planning baseline at Phase B review: project `main` `aee356a140c32c820a1c8832965b62ac3a5a6d58`; Base remote current `315c66eea9614c284b9c11c4d522141065dfa4b0`.
- User declaration `기획 완료` was received on 2026-08-11 KST; this plan is the locked Package 1 implementation package after final planning review.
- Decision ID remains `D-2026-08-11-HYBRID-NARRATIVE-DEDUCTION-GROWTH-INTEGRATION`.
- Package 1 only: Afterlife chapter-1 Thought Path + one staff-room Scene Contract + one post-case Oh Hyun callback.
- Oh Hyun is the only Package 1 companion callback. Han Serin is `PARTIAL_DISABLED` in the current Sheet and is excluded from this package.
- Preserve stable episode ID `episode_001_afterlife_station`, victim ID `victim_afterlife_station_001`, Canon v2 contract `afterlife-station-canon-v2`, and event ID `agent_event_oh_breakthrough_warning_01`.
- Do not introduce a relationship database, identity schema, affection/morality meter, new save version, new episode ID, new Scene/Resource, or new broad dialogue engine.
- Do not gate required truth, required records, normal clear, or accessibility behind trust, identity, stats, tags, RNG, or the callback.
- Do not reactivate legacy `clue_*` / `pattern_station_*` authority. Canon v2 `record_afterlife_*`, `pattern_afterlife_*`, and `response_afterlife_*` remain authoritative.
- `data/episodes/episode_001_afterlife_station_canon_v2.json`, `data/episodes/episode_001_afterlife_station.json`, `scripts/scenes/result_scene.gd`, Scene files, Resources, and `project.godot` are **NO-CHANGE for the initial Package 1 implementation**. The page-1/manual/intro priming risk is characterized by Human observation first; it is not silently rewritten in this slice.
- Persistent Godot product authoring follows the project authority contract: HiGodot is the sole persistent authoring authority for Godot product code/Scene/Resource/Project Settings. Test-authoring agents may author the test contract under the adopted test authority, but product mutation must be applied through the authorized HiGodot path.
- Automated tests prove deterministic contract behavior only. `HUMAN_USABILITY_EVIDENCE` and `PLAYER_EXPERIENCE_EVIDENCE` remain `NOT_RUN` until actual sessions are collected.
- Active design/planning documents reference the preregistered planning contract, not completed Human-QA evidence paths; completed evidence follows the repository evidence lifecycle after sessions occur.

---

## File Structure and Ownership

### Product code modified in Package 1

- `scripts/core/game_state.gd`
  - Preserve the existing `AGENT_TRUST_EVENTS` array and stable event IDs.
  - Add incident-context metadata only to `agent_event_oh_breakthrough_warning_01`.
  - Add one requirement evaluator and pass the just-resolved method context into one-time event evaluation.

### Automated verification

- Create `tests/canon_v2_runtime/canon_v2_fact_meaning_identity_poc_test.gd`
  - Locks legacy trust-gated compatibility and the new Oh Hyun incident-context matrix.
- Modify `tests/run_canon_v2_runtime_ux_tests.sh`
  - Adds the new focused test to the maintained Canon v2 runtime suite.

### Human evidence planning authority

- Existing planning contract: `docs/planning/AFTERLIFE_FACT_MEANING_IDENTITY_POC_HUMAN_PLAYTEST_CONTRACT_2026-08-11.md`
  - Preregisters Thought-Path, Scene Contract, callback-causality, priming, and evidence-ceiling rules.
  - Actual completed evidence is written only after real sessions and follows repository QA/evidence lifecycle rules.

### Protected no-change surfaces for initial Package 1

- `data/episodes/episode_001_afterlife_station.json`
- `data/episodes/episode_001_afterlife_station_canon_v2.json`
- `data/episodes/episode_001_afterlife_station_canon_v2_runtime_projection.json`
- `scripts/data/afterlife_canon_v2_loader.gd`
- `scripts/core/afterlife_migrating_game_state.gd`
- `scripts/core/protection_follow_up_policy.gd`
- `scripts/ui/canon_v2_runtime_bridge.gd`
- `scripts/ui/canon_v2_operation_overlay.gd`
- `scripts/scenes/result_scene.gd`
- `scenes/**`
- `project.godot`

A Human priming failure may authorize a **separate follow-up CHANGE package** for wording/presentation. It does not expand this initial implementation package automatically.

---

### Task 1: Lock the RED contract for the existing event system

**Files:**
- Create: `tests/canon_v2_runtime/canon_v2_fact_meaning_identity_poc_test.gd`
- Modify: `tests/run_canon_v2_runtime_ux_tests.sh`

**Interfaces:**
- Consumes: `GameState.get_triggered_agent_event_ids() -> Array`, `GameState.get_agent_trust_support_texts() -> Array`, existing `AGENT_TRUST_EVENTS` behavior.
- Produces: a failing contract that requires `_try_trigger_agent_trust_events(context: Dictionary = {}) -> Array` while preserving legacy trust-threshold behavior.

- [ ] **Step 1: Create the focused failing test**

Create `tests/canon_v2_runtime/canon_v2_fact_meaning_identity_poc_test.gd` with:

```gdscript
extends SceneTree

const GameStateScript := preload("res://scripts/core/game_state.gd")
const OH_EVENT_ID := "agent_event_oh_breakthrough_warning_01"
const KANG_EVENT_ID := "agent_event_kang_pattern_note_01"
const MATCHING_CONTEXT := {
    "point_id": "point_staff_room_door",
    "method_type": "destruction",
    "successful": true
}

var _failures: Array[String] = []


func _init() -> void:
    _test_existing_trust_event_stays_trust_gated()
    _test_oh_event_rejects_nonmatching_contexts()
    _test_oh_event_requires_selected_agent()
    _test_oh_event_triggers_without_numeric_trust_on_matching_incident()
    _test_oh_event_is_one_time_and_preserves_authored_copy()
    _finish()


func _new_state(agent_ids: Array) -> Node:
    var state := GameStateScript.new()
    state.set_selected_agent_ids(agent_ids)
    return state


func _test_existing_trust_event_stays_trust_gated() -> void:
    var state := _new_state(["agent_kang_ijun"])
    var before: Array = state._try_trigger_agent_trust_events({})
    _expect(before.is_empty(), "legacy trust event triggered below threshold")
    state.agent_trust["agent_kang_ijun"] = 2
    var after: Array = state._try_trigger_agent_trust_events({})
    _expect(after.size() == 1, "legacy trust event no longer triggers at threshold")
    _expect(state.get_triggered_agent_event_ids().has(KANG_EVENT_ID), "legacy trust event id missing")


func _test_oh_event_rejects_nonmatching_contexts() -> void:
    var contexts := [
        {"point_id": "point_platform_sign", "method_type": "destruction", "successful": true},
        {"point_id": "point_staff_room_door", "method_type": "observation", "successful": true},
        {"point_id": "point_staff_room_door", "method_type": "analysis", "successful": true},
        {"point_id": "point_staff_room_door", "method_type": "destruction", "successful": false}
    ]
    for context_value in contexts:
        var state := _new_state(["agent_oh_hyun"])
        var triggered: Array = state._try_trigger_agent_trust_events(context_value as Dictionary)
        _expect(triggered.is_empty(), "Oh Hyun callback triggered for nonmatching context: %s" % context_value)
        _expect(not state.get_triggered_agent_event_ids().has(OH_EVENT_ID), "Oh Hyun event persisted from nonmatching context")


func _test_oh_event_requires_selected_agent() -> void:
    var state := _new_state(["agent_kwon_narae"])
    var triggered: Array = state._try_trigger_agent_trust_events(MATCHING_CONTEXT)
    _expect(triggered.is_empty(), "Oh Hyun callback triggered when Oh Hyun was not selected")


func _test_oh_event_triggers_without_numeric_trust_on_matching_incident() -> void:
    var state := _new_state(["agent_oh_hyun"])
    _expect(state.get_agent_trust("agent_oh_hyun") == 0, "test precondition requires zero Oh Hyun trust")
    var triggered: Array = state._try_trigger_agent_trust_events(MATCHING_CONTEXT)
    _expect(triggered.size() == 1, "matching staff-room incident did not trigger Oh Hyun callback")
    _expect(state.get_triggered_agent_event_ids().has(OH_EVENT_ID), "matching incident did not persist stable Oh Hyun event id")
    _expect(state.get_agent_trust("agent_oh_hyun") == 0, "incident callback must not invent trust delta")


func _test_oh_event_is_one_time_and_preserves_authored_copy() -> void:
    var state := _new_state(["agent_oh_hyun"])
    state._try_trigger_agent_trust_events(MATCHING_CONTEXT)
    var repeated: Array = state._try_trigger_agent_trust_events(MATCHING_CONTEXT)
    _expect(repeated.is_empty(), "Oh Hyun incident callback triggered more than once")
    _expect(state.get_agent_trust_support_texts().has("오현의 돌파 경고: 다음 조사 또는 회수 판단에서 진입 경로를 참고할 수 있습니다."), "existing Oh Hyun support copy changed")
    var entries: Array = state._get_triggered_agent_event_entries()
    _expect(entries.size() == 1, "expected one triggered Oh Hyun event entry")
    if entries.size() == 1:
        var event := entries[0] as Dictionary
        _expect(String(event.get("title", "")) == "오현의 돌파 경고", "existing Oh Hyun event title changed")
        _expect(String(event.get("text", "")) == "오현: 길을 열었으면 바로 빠져나갈 경로도 확보해야 합니다. 다음 회수 판단 때는 제가 앞을 보겠습니다.", "existing Oh Hyun event text changed")


func _expect(condition: bool, message: String) -> void:
    if not condition:
        _failures.append(message)


func _finish() -> void:
    if _failures.is_empty():
        print("FACT MEANING IDENTITY POC: PASS")
        quit(0)
        return
    for failure in _failures:
        push_error(failure)
    quit(1)
```

- [ ] **Step 2: Add the focused test to the maintained runner**

Add to `TESTS=(...)` in `tests/run_canon_v2_runtime_ux_tests.sh`:

```bash
  "tests/canon_v2_runtime/canon_v2_fact_meaning_identity_poc_test.gd"
```

Keep every existing test entry unchanged.

- [ ] **Step 3: Run the focused test to verify RED**

Run:

```bash
godot --headless --path . --script res://tests/canon_v2_runtime/canon_v2_fact_meaning_identity_poc_test.gd
```

Expected before Task 2: **FAIL** because current `_try_trigger_agent_trust_events()` accepts no context argument and the Oh Hyun event remains trust-threshold-only.

- [ ] **Step 4: Commit the RED test**

```bash
git add tests/canon_v2_runtime/canon_v2_fact_meaning_identity_poc_test.gd tests/run_canon_v2_runtime_ux_tests.sh
git commit -m "test: lock fact meaning identity PoC event contract"
```

---

### Task 2: Make the minimum incident-memory change in `GameState`

**Files:**
- Modify: `scripts/core/game_state.gd` at `AGENT_TRUST_EVENTS`, `resolve_investigation_method`, and `_try_trigger_agent_trust_events`.
- Test: `tests/canon_v2_runtime/canon_v2_fact_meaning_identity_poc_test.gd`

**Interfaces:**
- Consumes: stable `triggered_agent_event_ids`, selected-agent membership, current `point_id`, `method_type`, and `successful` result.
- Produces: `_agent_event_requirements_met(event: Dictionary, context: Dictionary) -> bool`; `_try_trigger_agent_trust_events(context: Dictionary = {}) -> Array`.
- Compatibility: events without `trigger_mode` continue using existing `required_trust`; the Oh event uses `trigger_mode = "incident_context"` and does not change numeric trust.

- [ ] **Step 1: Add incident-context metadata to the existing Oh Hyun event**

Change only `agent_event_oh_breakthrough_warning_01` to add:

```gdscript
"trigger_mode": "incident_context",
"trigger_context": {
    "point_id": "point_staff_room_door",
    "method_type": "destruction",
    "successful": true
},
```

Preserve its current ID, `required_trust`, title, text, and support text. Do not add new dialogue strings.

- [ ] **Step 2: Add the requirement evaluator**

Add immediately above `_try_trigger_agent_trust_events`:

```gdscript
func _agent_event_requirements_met(event: Dictionary, context: Dictionary) -> bool:
    var trigger_mode := String(event.get("trigger_mode", "trust_threshold"))
    if trigger_mode == "incident_context":
        var required_value: Variant = event.get("trigger_context", {})
        if typeof(required_value) != TYPE_DICTIONARY:
            return false
        var required := required_value as Dictionary
        if required.is_empty():
            return false
        for key in required.keys():
            if not context.has(key) or context.get(key) != required.get(key):
                return false
        return true
    if trigger_mode != "trust_threshold":
        return false
    var agent_id := String(event.get("agent_id", ""))
    return get_agent_trust(agent_id) >= int(event.get("required_trust", 2))
```

- [ ] **Step 3: Make one-time event evaluation consume explicit current context**

Replace the current signature/body with:

```gdscript
func _try_trigger_agent_trust_events(context: Dictionary = {}) -> Array:
    var triggered_events: Array = []
    for event in AGENT_TRUST_EVENTS:
        var event_id := String(event.get("id", ""))
        var agent_id := String(event.get("agent_id", ""))
        if event_id.is_empty() or not selected_agent_ids.has(agent_id):
            continue
        if triggered_agent_event_ids.has(event_id):
            continue
        if not _agent_event_requirements_met(event, context):
            continue
        triggered_agent_event_ids.append(event_id)
        triggered_events.append(event.duplicate(true))
    return triggered_events
```

Do not reorder `method_results` persistence and do not read the just-resolved method back from `method_results`.

- [ ] **Step 4: Pass the just-resolved investigation context directly**

Inside `resolve_investigation_method`, replace:

```gdscript
var triggered_agent_events := _try_trigger_agent_trust_events()
```

with:

```gdscript
var triggered_agent_events := _try_trigger_agent_trust_events({
    "point_id": point_id,
    "method_type": String(method.get("method_type", stat_key)),
    "successful": successful
})
```

Keep surrounding story effects, trust-rule application, random event, method-result construction, persistence, and `save_game()` order unchanged.

- [ ] **Step 5: Run the focused test to verify GREEN**

```bash
godot --headless --path . --script res://tests/canon_v2_runtime/canon_v2_fact_meaning_identity_poc_test.gd
```

Expected: `FACT MEANING IDENTITY POC: PASS` and exit code 0.

- [ ] **Step 6: Run the complete maintained Canon v2 runtime suite**

```bash
bash tests/run_canon_v2_runtime_ux_tests.sh
```

Expected: every existing Canon v2 runtime test plus the new focused test exits 0.

- [ ] **Step 7: Commit the minimum product change**

```bash
git add scripts/core/game_state.gd
git commit -m "feat: remember afterlife staff-room choice for Oh Hyun callback"
```

---

### Task 3: Preserve the preregistered Human contract and execute no synthetic evidence

**Files:**
- Read/execute against: `docs/planning/AFTERLIFE_FACT_MEANING_IDENTITY_POC_HUMAN_PLAYTEST_CONTRACT_2026-08-11.md`
- Product files: no additional modification in this task.

**Interfaces:**
- Consumes: executable Package 1 build and preregistered Human decision rules.
- Produces: future actual-session evidence only after real fresh/unexposed sessions; no evidence is fabricated during code implementation.

- [ ] **Step 1: Verify preregistration before Human execution**

Run:

```bash
grep -nE 'SESSIONS_NOT_RUN|HUMAN_USABILITY_EVIDENCE=NOT_RUN|PLAYER_EXPERIENCE_EVIDENCE=NOT_RUN|RECOMMENDED_STARTING_SAMPLE|THOUGHT_PATH_KEEP|PRIMING_CHANGE|CALLBACK_CAUSALITY_KEEP|HIDDEN_METER_CHANGE' docs/planning/AFTERLIFE_FACT_MEANING_IDENTITY_POC_HUMAN_PLAYTEST_CONTRACT_2026-08-11.md
```

Expected: all preregistered gates are present and evidence remains `NOT_RUN` before sessions.

- [ ] **Step 2: Keep the fixed Human route unchanged during implementation**

The route is:

```text
blind Afterlife first-run
→ chapter-1 evidence review without author hints
→ participant states destination hypothesis
→ point_staff_room_door choice/reason observed
→ successful destruction with Oh Hyun selected for callback route
→ normal result/report
→ existing 오현의 돌파 경고 observed
```

Do not rewrite the page title or intro wording in the initial Package 1 implementation merely to improve the Human result.

- [ ] **Step 3: Do not create completed Human evidence before sessions exist**

At code-completion time, report exactly:

```text
HUMAN_USABILITY_EVIDENCE=NOT_RUN
PLAYER_EXPERIENCE_EVIDENCE=NOT_RUN
```

Actual completed evidence is created only after real sessions, under the repository QA/evidence lifecycle; the active plan does not directly depend on that completed evidence file.

---

### Task 4: Verify Package 1 without expanding scope

**Files:**
- Verify: `scripts/core/game_state.gd`
- Verify: `tests/canon_v2_runtime/canon_v2_fact_meaning_identity_poc_test.gd`
- Verify: `tests/run_canon_v2_runtime_ux_tests.sh`
- Read: `docs/planning/AFTERLIFE_FACT_MEANING_IDENTITY_POC_HUMAN_PLAYTEST_CONTRACT_2026-08-11.md`

**Interfaces:**
- Consumes: exact implementation HEAD after Tasks 1–2.
- Produces: automated evidence plus a clean handoff to Human observation; it does not produce Human/player-experience PASS.

- [ ] **Step 1: Confirm exact implementation scope**

Run:

```bash
git diff --name-only origin/main...HEAD
```

The product/test implementation diff is limited to:

```text
scripts/core/game_state.gd
tests/canon_v2_runtime/canon_v2_fact_meaning_identity_poc_test.gd
tests/run_canon_v2_runtime_ux_tests.sh
```

Planning/governance files may be present if execution is performed on a branch that includes the approved planning package; they are reviewed separately and do not authorize extra product paths.

- [ ] **Step 2: Verify protected semantics were not changed**

```bash
git diff --exit-code origin/main...HEAD -- data/episodes/episode_001_afterlife_station.json data/episodes/episode_001_afterlife_station_canon_v2.json data/episodes/episode_001_afterlife_station_canon_v2_runtime_projection.json scripts/data/afterlife_canon_v2_loader.gd scripts/core/afterlife_migrating_game_state.gd scripts/core/protection_follow_up_policy.gd scripts/ui/canon_v2_runtime_bridge.gd scripts/ui/canon_v2_operation_overlay.gd scripts/scenes/result_scene.gd project.godot
```

Expected: exit code 0.

- [ ] **Step 3: Run maintained automated validation**

```bash
bash tests/run_canon_v2_runtime_ux_tests.sh
```

Then run the repository's maintained full Godot regression command used by current main/CI at the exact implementation HEAD. Expected: all maintained automated checks PASS; do not convert this into Human evidence.

- [ ] **Step 4: Open the implementation PR and require exact-head CI**

The implementation PR must state:

```text
exact implementation head SHA
current main SHA used as base
focused RED-before evidence
focused GREEN-after evidence
Canon v2 runtime suite result
maintained full regression result
changed-file list
HUMAN_USABILITY_EVIDENCE=NOT_RUN
PLAYER_EXPERIENCE_EVIDENCE=NOT_RUN
```

Do not merge using historical CI from any previous head.

- [ ] **Step 5: After executable validation, run the real Human sessions against the preregistered planning contract**

Recommended starting sample is five fresh/unexposed sessions. Record actual observations without filling missing evidence by inference.

- [ ] **Step 6: Classify PoC survival**

For each component write exactly one:

```text
KEEP
CHANGE
RETEST
REMOVE
```

Only `KEEP` components may become candidates for separate Investigator Identity / Core Relationship / Year-One L2 Specs. A `CHANGE` result produces a new bounded plan instead of broadening this implementation PR.

---

## Rollback Contract

If the incident-context trigger regresses or fails Human causal interpretation:

1. Revert `trigger_mode` / `trigger_context` metadata on `agent_event_oh_breakthrough_warning_01`.
2. Revert `_agent_event_requirements_met(...)` and the context argument passed into `_try_trigger_agent_trust_events(...)`.
3. Remove the focused test runner entry only when reverting the feature contract itself.
4. Preserve the stable event ID, event strings, `triggered_agent_event_ids` save field, trust values, episode IDs, Canon v2 IDs, and all existing saves.
5. Preserve actual Human observations as historical evidence; do not delete failed evidence.

This restores the previous trust-threshold-only Oh Hyun event behavior without save migration.

## Phase C Definition of Ready

Package 1 is implementation-ready because all of the following are locked:

- exact `기획 완료` declaration received;
- Phase B final review completed;
- current project main/Base/Sheet re-read and conflicts classified;
- Oh Hyun current eligibility confirmed and Han Serin excluded from Package 1 while `PARTIAL_DISABLED`;
- Existing Solution First ownership: Canon v2 evidence/manual, `GameState` method/event persistence, result/report event display, and Canon v2 follow-up/evaluation;
- only authorized product-code gap is incident-context triggering in `scripts/core/game_state.gd` plus focused tests;
- Human priming risk is preregistered and not represented as resolved;
- persistent product authoring must be handed to the HiGodot-authorized execution path.

Locked state:

```text
PHASE_B_FINAL_REVIEW_COMPLETE
PACKAGE_1_DOR_LOCKED
PHASE_C_READY
HUMAN_USABILITY_EVIDENCE=NOT_RUN
PLAYER_EXPERIENCE_EVIDENCE=NOT_RUN
```
