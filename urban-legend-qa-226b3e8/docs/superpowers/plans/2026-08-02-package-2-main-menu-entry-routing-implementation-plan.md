# Package 2 Main-Menu Entry and Routing Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** SCREEN-01에서 Legacy 본편과 Validation 기록을 독립적으로 표시하고, Validation 새 시작·이어하기·완료 기록 보기를 Legacy 파일·메모리에 부작용 없이 fail-closed 방식으로 연결한다.

**Architecture:** `ValidationSession`은 repository를 읽기 전용 summary로 노출하고, 순수 `ValidationRouteMapper`가 flow-stage를 허용 Scene으로 변환한다. `ValidationEntryCoordinator`가 create/load/delete/rollback/single-flight를 조정하며, `main_menu.gd`는 두 카드와 dialog를 렌더링하는 UI 책임만 가진다. Validation 초기화는 `validation_game_state.gd`의 whitelist 전용 API를 사용하고 기존 `reset_run_state()`·`restart_afterlife_station_flow()`는 호출하지 않는다.

**Tech Stack:** Godot 4.7.1, GDScript, headless `SceneTree` tests, Bash test runners, Python `unittest`, GitHub Actions.

## Global Constraints

- 기준 플랫폼은 `PC_16_9_MOUSE_KEYBOARD`; 모바일은 이 Package에서 제외한다.
- Legacy 저장은 `user://urban_legend_save.json`, Validation 저장은 `user://urban_legend_validation_save.json`이며 서로 읽기·쓰기·삭제를 공유하지 않는다.
- Validation 메뉴 렌더링은 `ValidationSession.load()`·GameState restore·저장 mutation·Scene 이동을 수행하지 않는다.
- Validation 시작·이어하기·완료 기록 보기 전후 Legacy save bytes와 hidden Legacy memory는 semantic equality를 유지해야 한다.
- Validation 시작에서 `GameState.clear_save_file()`, `reset_run_state()`, `restart_afterlife_station_flow()` 호출을 금지한다.
- corrupt·incompatible·recoverable·interrupted·read-failed 상태는 자동 삭제·덮어쓰기·quarantine·backup 승격을 수행하지 않는다.
- 저장된 `scene_path`를 직접 신뢰하지 않고 flow-stage allowlist mapper만 사용한다.
- 알려진 stage라도 화면이 이 Package에 없으면 `NOT_AVAILABLE`로 메인 메뉴에 남는다.
- mutation command는 single-flight이며 실패·취소 시 반드시 `IDLE`로 복귀한다.
- Package 1 focused suite 4/4와 기존 Legacy 새 캠페인·이어하기 회귀를 유지한다.
- 사람·시각 검증을 실행하지 못하면 성공으로 추정하지 않고 `NOT_RUN`으로 기록한다.
- 구현 branch는 승인된 planning PR #129가 병합된 뒤 최신 `main`에서 분리하며, 실행 시 `superpowers:using-git-worktrees`로 격리한다.

---

## File Structure

### Create

- `scripts/core/validation_persistence_summary.gd` — repository inspection payload를 메뉴용 불변 summary로 변환한다.
- `scripts/core/validation_route_mapper.gd` — flow-stage와 lifecycle을 허용 route로 매핑한다.
- `scripts/ui/validation_entry_coordinator.gd` — Validation 시작·교체·이어하기·완료 보기와 rollback을 조정한다.
- `tests/validation/validation_persistence_summary_test.gd` — persistence/lifecycle/action mapping과 무부작용을 검증한다.
- `tests/validation/validation_route_mapper_test.gd` — allowlist·unknown·not-available을 검증한다.
- `tests/validation/validation_runtime_initializer_test.gd` — whitelist 초기화와 hidden Legacy 무부작용을 검증한다.
- `tests/validation/validation_entry_coordinator_test.gd` — single-flight·시작·교체·이어하기·rollback·Legacy bytes equality를 검증한다.
- `tests/validation/validation_main_menu_contract_test.gd` — 두 카드·버튼 이름·상태 dialog·포커스 계약을 headless로 검증한다.
- `tests/run_validation_package_2_tests.sh` — Package 2 focused 5-entry suite를 실행한다.
- `docs/implementation/2026-08-02-package-2-main-menu-entry-routing-evidence.md` — RED/GREEN, CI, 범위, 미검증 항목을 기록한다.

### Modify

- `scripts/core/validation_session.gd:1-170` — read-only `inspect_persistence()` facade와 summary script 연결.
- `scripts/core/validation_game_state.gd:1-150` — `initialize_validation_runtime()` whitelist initializer 추가.
- `scripts/ui/main_menu.gd:1-360` — 독립 카드, coordinator 연결, dialog, single-flight UI, focus 순서.
- `tests/run_godot_regression.sh:1-120` — Package 2 테스트 5개 등록, 총 `58/58`로 갱신.
- `tests/test_annual_mvp_001_static_contract.py:30-65` — 신규 테스트 등록과 `58/58` 계약 확인.
- `.github/workflows/validate-core-mvp-001.yml:1-90` — Package 2 focused suite와 신규 경로 감시.
- `.github/workflows/validate-annual-mvp-001.yml` — Package 2 focused suite와 신규 경로 감시.
- `docs/CURRENT_CONFIRMED_DECISIONS.md` — 구현 완료 뒤 실제 상태와 증거만 반영.
- `docs/CURRENT_HANDOFF_VALIDATION.md` — 구현 branch/PR/검증/다음 Gate 갱신.

---

### Task 1: Read-Only Validation Persistence Summary

**Files:**
- Create: `scripts/core/validation_persistence_summary.gd`
- Create: `tests/validation/validation_persistence_summary_test.gd`
- Modify: `scripts/core/validation_session.gd:1-170`

**Interfaces:**
- Consumes: `ValidationSaveRepository.inspect() -> Dictionary` with `code` and optional `payload`.
- Produces: `ValidationSession.inspect_persistence() -> Dictionary` with the exact fields below.

```gdscript
{
    "ok": bool,
    "repository_code": String,
    "lifecycle": String,
    "episode_id": String,
    "episode_title": String,
    "flow_stage": String,
    "checkpoint_id": String,
    "updated_at_utc": String,
    "completed_at_utc": String,
    "can_start": bool,
    "can_continue": bool,
    "can_view_completed": bool,
    "requires_replace_confirmation": bool,
    "status_label": String,
    "status_message": String
}
```

- [ ] **Step 1: Write the failing persistence-summary test**

Create `tests/validation/validation_persistence_summary_test.gd` with table-driven cases for `EMPTY`, `EXACT active`, `EXACT suspended`, `EXACT completed`, `RECOVERABLE_BACKUP`, `INTERRUPTED_WRITE`, both incompatible codes, both corrupt codes, `READ_FAILED`, and unknown.

```gdscript
extends SceneTree

const SummaryScript = preload("res://scripts/core/validation_persistence_summary.gd")

var _failures: Array[String] = []

func _init() -> void:
    var active := SummaryScript.build({
        "ok": true,
        "code": "EXACT",
        "payload": _payload("active", "SIT-004")
    })
    _expect(active.get("can_continue") == true, "active EXACT must continue")
    _expect(active.get("requires_replace_confirmation") == true, "active EXACT must require replace confirmation")
    _expect(active.get("flow_stage") == "SIT-004", "summary must expose allowlisted flow-stage data")

    var completed := SummaryScript.build({
        "ok": true,
        "code": "EXACT",
        "payload": _payload("completed", "SIT-008")
    })
    _expect(completed.get("can_view_completed") == true, "completed EXACT must expose read-only record action")
    _expect(completed.get("can_continue") == false, "completed EXACT must not continue")

    for blocked_code in [
        "RECOVERABLE_BACKUP", "INTERRUPTED_WRITE",
        "INCOMPATIBLE_OLDER", "INCOMPATIBLE_NEWER",
        "CORRUPT_JSON", "CORRUPT_SCHEMA", "READ_FAILED", "UNEXPECTED"
    ]:
        var blocked := SummaryScript.build({"ok": false, "code": blocked_code})
        _expect(not blocked.get("can_start", true), "%s must not start" % blocked_code)
        _expect(not blocked.get("can_continue", true), "%s must not continue" % blocked_code)
        _expect(not blocked.get("requires_replace_confirmation", true), "%s must not replace" % blocked_code)

    var empty := SummaryScript.build({"ok": false, "code": "EMPTY"})
    _expect(empty.get("can_start") == true, "EMPTY must start")
    _finish()

func _payload(lifecycle: String, flow_stage: String) -> Dictionary:
    return {
        "session": {
            "lifecycle": lifecycle,
            "episode_id": "episode_001_afterlife_station",
            "flow_stage": flow_stage,
            "checkpoint_id": "checkpoint-1"
        },
        "timestamps": {
            "updated_at_utc": "2026-08-02T07:00:00Z",
            "completed_at_utc": "2026-08-02T07:10:00Z"
        },
        "result": {"axes": {"rule": 1}}
    }
```

Add a second part that instantiates `ValidationSession`, writes an isolated EXACT payload through the existing repository fixture, captures session mode/revision before `inspect_persistence()`, calls it twice, and asserts mode, revision, file bytes, and fake GameState remain unchanged.

- [ ] **Step 2: Run the new test and verify RED**

Run:

```bash
GODOT_TEST_TMP="$(mktemp -d)" godot --headless --path . \
  --script res://tests/validation/validation_persistence_summary_test.gd
```

Expected: FAIL because `scripts/core/validation_persistence_summary.gd` and `ValidationSession.inspect_persistence()` do not exist.

- [ ] **Step 3: Implement the pure summary mapper**

Create `scripts/core/validation_persistence_summary.gd`:

```gdscript
class_name ValidationPersistenceSummary
extends RefCounted

const EPISODE_TITLES := {
    "episode_001_afterlife_station": "저승역"
}

static func build(inspected: Dictionary) -> Dictionary:
    var code := String(inspected.get("code", "UNKNOWN"))
    var summary := _base(code)
    if code == "EMPTY":
        summary["ok"] = true
        summary["can_start"] = true
        summary["status_label"] = "기록 없음"
        summary["status_message"] = "새 Validation 기록을 시작할 수 있습니다."
        return summary
    if code != "EXACT":
        _apply_blocked_copy(summary, code)
        return summary

    var payload_value: Variant = inspected.get("payload")
    if typeof(payload_value) != TYPE_DICTIONARY:
        return _schema_failure()
    var payload := payload_value as Dictionary
    var session_value: Variant = payload.get("session")
    var timestamps_value: Variant = payload.get("timestamps")
    if typeof(session_value) != TYPE_DICTIONARY or typeof(timestamps_value) != TYPE_DICTIONARY:
        return _schema_failure()

    var session := session_value as Dictionary
    var timestamps := timestamps_value as Dictionary
    var lifecycle := String(session.get("lifecycle", ""))
    var episode_id := String(session.get("episode_id", ""))
    if lifecycle not in ["active", "suspended", "completed"]:
        return _schema_failure()
    if not EPISODE_TITLES.has(episode_id):
        return _schema_failure()

    summary["ok"] = true
    summary["lifecycle"] = lifecycle
    summary["episode_id"] = episode_id
    summary["episode_title"] = String(EPISODE_TITLES[episode_id])
    summary["flow_stage"] = String(session.get("flow_stage", ""))
    summary["checkpoint_id"] = String(session.get("checkpoint_id", ""))
    summary["updated_at_utc"] = String(timestamps.get("updated_at_utc", ""))
    summary["completed_at_utc"] = String(timestamps.get("completed_at_utc", ""))
    summary["requires_replace_confirmation"] = true
    if lifecycle in ["active", "suspended"]:
        summary["can_continue"] = true
        summary["status_label"] = "진행 중"
        summary["status_message"] = "%s · %s" % [summary["episode_title"], summary["flow_stage"]]
    else:
        summary["can_view_completed"] = true
        summary["status_label"] = "완료 기록"
        summary["status_message"] = "%s · 완료" % summary["episode_title"]
    return summary

static func _base(code: String) -> Dictionary:
    return {
        "ok": false,
        "repository_code": code,
        "lifecycle": "",
        "episode_id": "",
        "episode_title": "",
        "flow_stage": "",
        "checkpoint_id": "",
        "updated_at_utc": "",
        "completed_at_utc": "",
        "can_start": false,
        "can_continue": false,
        "can_view_completed": false,
        "requires_replace_confirmation": false,
        "status_label": "상태 확인 필요",
        "status_message": "Validation 기록 상태를 확인할 수 없습니다."
    }
```

Implement `_apply_blocked_copy()` with the exact user messages from the approved Spec and `_schema_failure()` returning `repository_code = "CORRUPT_SCHEMA"` with all mutation flags false.

- [ ] **Step 4: Add the read-only Session facade**

At the top of `scripts/core/validation_session.gd` add:

```gdscript
const PersistenceSummaryScript := preload("res://scripts/core/validation_persistence_summary.gd")
```

After `get_repository_paths()` add:

```gdscript
func inspect_persistence() -> Dictionary:
    var inspected: Dictionary = _repository.inspect()
    return PersistenceSummaryScript.build(inspected)
```

Do not call `_apply_payload()`, `load()`, `_reset_memory()`, or any mutating repository method.

- [ ] **Step 5: Run focused tests and verify GREEN**

Run:

```bash
godot --headless --path . --script res://tests/validation/validation_persistence_summary_test.gd
godot --headless --path . --script res://tests/validation/validation_session_test.gd
godot --headless --path . --script res://tests/validation/validation_save_repository_test.gd
```

Expected: all three exit 0; repeated inspection leaves session revision/mode and persistence bytes unchanged.

- [ ] **Step 6: Commit Task 1**

```bash
git add scripts/core/validation_persistence_summary.gd \
  scripts/core/validation_session.gd \
  tests/validation/validation_persistence_summary_test.gd
git commit -m "feat: expose read-only Validation persistence summary"
```

---

### Task 2: Flow-Stage Allowlist Route Mapper

**Files:**
- Create: `scripts/core/validation_route_mapper.gd`
- Create: `tests/validation/validation_route_mapper_test.gd`

**Interfaces:**
- Consumes: `flow_stage: String`, `lifecycle: String`.
- Produces: `resolve(flow_stage: String, lifecycle: String) -> Dictionary` with `ok`, `code`, `route_id`, `scene_path`.

- [ ] **Step 1: Write the failing route-mapper test**

Create `tests/validation/validation_route_mapper_test.gd`:

```gdscript
extends SceneTree

const MapperScript = preload("res://scripts/core/validation_route_mapper.gd")
var _failures: Array[String] = []

func _init() -> void:
    var sit1 := MapperScript.new().resolve("SIT-001", "active")
    _expect(sit1.get("code") == "OK", "SIT-001 must route")
    _expect(sit1.get("scene_path") == "res://scenes/dialogue_scene.tscn", "SIT-001 must use dialogue")

    var sit2 := MapperScript.new().resolve("SIT-002", "suspended")
    _expect(sit2.get("code") == "OK", "SIT-002 must route")

    var sit4 := MapperScript.new().resolve("SIT-004", "active")
    _expect(sit4.get("scene_path") == "res://scenes/investigation_scene.tscn", "SIT-004 must use investigation")

    for unavailable in ["SIT-003", "SIT-005", "SIT-006", "SIT-007", "SIT-008"]:
        _expect(MapperScript.new().resolve(unavailable, "active").get("code") == "NOT_AVAILABLE", "%s must stay closed" % unavailable)

    _expect(MapperScript.new().resolve("SIT-999", "active").get("code") == "UNKNOWN_FLOW_STAGE", "unknown stage must fail closed")
    _expect(MapperScript.new().resolve("SIT-001", "completed").get("code") == "INVALID_LIFECYCLE", "completed must use read-only viewer")
    _finish()
```

- [ ] **Step 2: Run the mapper test and verify RED**

```bash
godot --headless --path . --script res://tests/validation/validation_route_mapper_test.gd
```

Expected: FAIL because the mapper file does not exist.

- [ ] **Step 3: Implement the mapper**

Create `scripts/core/validation_route_mapper.gd`:

```gdscript
class_name ValidationRouteMapper
extends RefCounted

const AVAILABLE := {
    "SIT-001": {"route_id": "dialogue", "scene_path": "res://scenes/dialogue_scene.tscn"},
    "SIT-002": {"route_id": "dialogue", "scene_path": "res://scenes/dialogue_scene.tscn"},
    "SIT-004": {"route_id": "investigation", "scene_path": "res://scenes/investigation_scene.tscn"}
}
const KNOWN_UNAVAILABLE := ["SIT-003", "SIT-005", "SIT-006", "SIT-007", "SIT-008"]

func resolve(flow_stage: String, lifecycle: String) -> Dictionary:
    if lifecycle not in ["active", "suspended"]:
        return _result(false, "INVALID_LIFECYCLE")
    if AVAILABLE.has(flow_stage):
        var route := AVAILABLE[flow_stage] as Dictionary
        return _result(true, "OK", {
            "route_id": String(route.get("route_id", "")),
            "scene_path": String(route.get("scene_path", ""))
        })
    if KNOWN_UNAVAILABLE.has(flow_stage):
        return _result(false, "NOT_AVAILABLE", {"route_id": flow_stage, "scene_path": ""})
    return _result(false, "UNKNOWN_FLOW_STAGE", {"route_id": "", "scene_path": ""})

func _result(ok: bool, code: String, details: Dictionary = {}) -> Dictionary:
    var value := {"ok": ok, "code": code, "route_id": "", "scene_path": ""}
    for key in details.keys():
        value[key] = details[key]
    return value
```

- [ ] **Step 4: Run the mapper and import checks**

```bash
godot --headless --path . --import
godot --headless --path . --script res://tests/validation/validation_route_mapper_test.gd
```

Expected: import and test exit 0.

- [ ] **Step 5: Commit Task 2**

```bash
git add scripts/core/validation_route_mapper.gd \
  tests/validation/validation_route_mapper_test.gd
git commit -m "feat: add fail-closed Validation route mapper"
```

---

### Task 3: Whitelist-Only Validation Runtime Initializer

**Files:**
- Modify: `scripts/core/validation_game_state.gd:1-150`
- Create: `tests/validation/validation_runtime_initializer_test.gd`

**Interfaces:**
- Consumes: `episode_id: String`, `agent_ids: Array`.
- Produces: `initialize_validation_runtime(episode_id: String, agent_ids: Array) -> Dictionary`.
- Preserves: `snapshot_hidden_legacy_state_for_test()` semantic equality.

- [ ] **Step 1: Write the failing initializer test**

Create `tests/validation/validation_runtime_initializer_test.gd`. Instantiate `validation_game_state.gd`, seed every hidden field with non-default sentinel values, create a Legacy save file with known bytes, call the initializer, then compare hidden snapshot and file bytes.

```gdscript
extends SceneTree

const GameStateScript = preload("res://scripts/core/validation_game_state.gd")
const Support = preload("res://tests/validation/validation_test_support.gd")
const LEGACY_PATH := "user://urban_legend_save.json"
var _failures: Array[String] = []

func _init() -> void:
    Support.write_text(LEGACY_PATH, "PACKAGE-2-LEGACY-SENTINEL")
    var legacy_before := Support.read_bytes(LEGACY_PATH)
    var state = GameStateScript.new()
    root.add_child(state)
    await process_frame

    state.echo_fragments = 777
    state.agent_trust = {"agent_kwon_narae": 3}
    state.unlocked_records = ["legacy-record"]
    state.faction_relations = {"rumor_market": 9}
    state.consumable_inventory = {"legacy-item": 4}
    var hidden_before := state.snapshot_hidden_legacy_state_for_test()

    _expect(state.has_method("initialize_validation_runtime"), "initializer API must exist")
    var result: Dictionary = state.initialize_validation_runtime(
        "episode_001_afterlife_station",
        ["agent_oh_hyun", "agent_kwon_narae", "agent_kang_ijun"]
    )
    _expect(result.get("code") == "OK", "valid initializer must succeed")
    _expect(state.snapshot_hidden_legacy_state_for_test() == hidden_before, "hidden Legacy state must not change")
    _expect(Support.read_bytes(LEGACY_PATH) == legacy_before, "Legacy bytes must not change")
    _expect(state.get_current_episode_id() == "episode_001_afterlife_station", "episode must initialize")
    _expect(state.get_current_scene_path() == state.SCENE_DIALOGUE, "Validation must begin at dialogue")
    _expect(state.selected_agent_ids.size() == 3, "approved tutorial team must initialize")

    _expect(state.initialize_validation_runtime("episode_unknown", []).get("code") == "INVALID_EPISODE", "unknown episode must fail")
    state.queue_free()
    Support.remove_path(LEGACY_PATH)
    _finish()
```

Add assertions that flags, clues, hints, method/minigame results, resolution, recovery, agent case states, and victim state are reset to their approved Validation initial values.

- [ ] **Step 2: Run the initializer test and verify RED**

```bash
godot --headless --path . --script res://tests/validation/validation_runtime_initializer_test.gd
```

Expected: FAIL because `initialize_validation_runtime()` does not exist.

- [ ] **Step 3: Implement the whitelist initializer**

Add to `scripts/core/validation_game_state.gd` before `export_validation_runtime_snapshot()`:

```gdscript
func initialize_validation_runtime(episode_id: String, agent_ids: Array) -> Dictionary:
    if episode_id != VALIDATION_EPISODE_ID:
        return {"ok": false, "code": "INVALID_EPISODE"}
    if agent_ids.is_empty() or agent_ids.size() > MAX_SELECTED_AGENTS:
        return {"ok": false, "code": "INVALID_AGENT_SELECTION"}

    var hidden_before := snapshot_hidden_legacy_state_for_test()
    if not load_episode(DEFAULT_EPISODE_PATH):
        return {"ok": false, "code": "INCOMPATIBLE_CONTENT"}

    current_scene_path = SCENE_DIALOGUE
    current_dialogue_node_id = DEFAULT_DIALOGUE_NODE_ID
    current_field_node_id = DEFAULT_FIELD_NODE_ID
    current_minigame_id = DEFAULT_MINIGAME_ID
    selected_agent_ids = agent_ids.duplicate(true)
    flags.clear()
    _apply_collected_clue_ids([])
    seen_hint_ids.clear()
    method_results.clear()
    minigame_results.clear()
    selected_resolution_grade = ""
    selected_resolution_label = ""
    selected_resolution_rate = 0.0
    recovery_successful = false
    recovery_result_status = ""
    recovery_result_stability = 100
    current_recovery_pattern_id = ""
    last_recovery_pattern_id = ""
    confirmed_recovery_pattern_id = ""
    seen_recovery_pattern_ids.clear()
    recovery_pattern_learning.clear()
    agent_case_states.clear()
    victim_state.clear()

    if not _semantic_equal(hidden_before, snapshot_hidden_legacy_state_for_test()):
        return {"ok": false, "code": "HIDDEN_STATE_GUARD_VIOLATION"}
    return {"ok": true, "code": "OK"}
```

Do not call any base reset or Legacy persistence method.

- [ ] **Step 4: Run initializer, adapter, and isolation tests**

```bash
godot --headless --path . --script res://tests/validation/validation_runtime_initializer_test.gd
godot --headless --path . --script res://tests/validation/validation_game_state_adapter_test.gd
godot --headless --path . --script res://tests/validation/validation_save_isolation_test.gd
```

Expected: all exit 0 and Legacy sentinels remain unchanged.

- [ ] **Step 5: Commit Task 3**

```bash
git add scripts/core/validation_game_state.gd \
  tests/validation/validation_runtime_initializer_test.gd
git commit -m "feat: initialize Validation runtime through whitelist only"
```

---

### Task 4: Entry Coordinator — Start, Replace, and Atomic Failure Cleanup

**Files:**
- Create: `scripts/ui/validation_entry_coordinator.gd`
- Create: `tests/validation/validation_entry_coordinator_test.gd`

**Interfaces:**
- Consumes:
  - `session.inspect_persistence()`
  - `session.create(episode_id)`
  - `session.activate(token)`
  - `session.capture_legacy_guard(game_state)`
  - `session.save(game_state)`
  - `session.delete_persistence()`
  - `session.abandon_runtime()`
  - `game_state.initialize_validation_runtime(episode_id, agent_ids)`
  - `game_state.export_validation_runtime_snapshot()`
  - `game_state.restore_validation_runtime_snapshot(snapshot)`
  - `game_state.snapshot_hidden_legacy_state_for_test()`
  - `route_mapper.resolve(flow_stage, lifecycle)`
- Produces:

```gdscript
func start_new_validation() -> Dictionary
func confirm_replace_and_start() -> Dictionary
func cancel_replace() -> Dictionary
func is_busy() -> bool
func get_pending_replace_summary() -> Dictionary
```

- [ ] **Step 1: Write coordinator RED tests for start and replace**

Create `tests/validation/validation_entry_coordinator_test.gd` with fakes injected through the constructor.

```gdscript
const CoordinatorScript = preload("res://scripts/ui/validation_entry_coordinator.gd")
const MapperScript = preload("res://scripts/core/validation_route_mapper.gd")

class FakeSceneChanger:
    extends RefCounted
    var calls: Array[String] = []
    var next_error := OK
    func change(scene_path: String) -> int:
        calls.append(scene_path)
        return next_error
```

Use an isolated Legacy path and assert:

1. `EMPTY` start calls create → activate → guard → initialize → save → scene change exactly once.
2. Legacy bytes and hidden snapshot are unchanged.
3. second command while `_state == LOADING` returns `BUSY` and makes no calls.
4. EXACT active/suspended/completed returns `REPLACE_CONFIRMATION_REQUIRED` without mutation.
5. `cancel_replace()` clears pending state without mutation.
6. `confirm_replace_and_start()` re-inspects, deletes Validation persistence only, confirms EMPTY, then starts.
7. blocked repository codes never call delete/create.
8. any failure before scene change restores the pre-command runtime snapshot, abandons Session runtime, removes only the newly-created Validation persistence, releases lock, and leaves Legacy bytes unchanged.

Expose a test-only fake command hook rather than changing production state directly:

```gdscript
func force_busy_for_test(value: bool) -> void:
    _state = STATE_LOADING if value else STATE_IDLE
```

- [ ] **Step 2: Run coordinator test and verify RED**

```bash
godot --headless --path . --script res://tests/validation/validation_entry_coordinator_test.gd
```

Expected: FAIL because the coordinator file does not exist.

- [ ] **Step 3: Implement coordinator construction and state**

Create `scripts/ui/validation_entry_coordinator.gd`:

```gdscript
class_name ValidationEntryCoordinator
extends RefCounted

const MapperScript := preload("res://scripts/core/validation_route_mapper.gd")
const EPISODE_ID := "episode_001_afterlife_station"
const DEFAULT_AGENTS := ["agent_oh_hyun", "agent_kwon_narae", "agent_kang_ijun"]
const STATE_IDLE := "IDLE"
const STATE_LOADING := "LOADING"
const STATE_RESULT := "RESULT"

var _session: Object
var _game_state: Object
var _route_mapper: Object
var _scene_changer: Callable
var _legacy_save_path: String
var _state := STATE_IDLE
var _pending_replace_summary: Dictionary = {}

func _init(
    session: Object,
    game_state: Object,
    scene_changer: Callable,
    route_mapper: Object = null,
    legacy_save_path: String = "user://urban_legend_save.json"
) -> void:
    _session = session
    _game_state = game_state
    _scene_changer = scene_changer
    _route_mapper = route_mapper if route_mapper != null else MapperScript.new()
    _legacy_save_path = legacy_save_path
```

Implement `_begin_command()`, `_finish_idle()`, `_result()`, `_capture_file_state()`, `_file_state_matches()`, and `_restore_runtime_after_failure()`.

File state shape:

```gdscript
{"exists": bool, "bytes": PackedByteArray}
```

- [ ] **Step 4: Implement new-start preflight and atomic command**

```gdscript
func start_new_validation() -> Dictionary:
    var lock := _begin_command()
    if String(lock.get("code", "")) != "OK":
        return lock
    var summary: Dictionary = _session.inspect_persistence()
    if bool(summary.get("can_start", false)):
        return _start_from_empty(summary)
    if bool(summary.get("requires_replace_confirmation", false)):
        _pending_replace_summary = summary.duplicate(true)
        _finish_idle()
        return _result(false, "REPLACE_CONFIRMATION_REQUIRED", {"summary": summary})
    _finish_idle()
    return _result(false, String(summary.get("repository_code", "UNKNOWN")), {"summary": summary})
```

`_start_from_empty()` must preflight `SIT-001` before mutation, capture Legacy file/hidden/runtime snapshots, execute the approved call order, verify both guards, save, call the injected scene changer, and return `OK` only when the scene changer returns `OK`.

On failure, call one cleanup method that:

```text
restore_validation_runtime_snapshot(runtime_before)
→ abandon_runtime()
→ delete_persistence() only when this command created it
→ verify Legacy file and hidden snapshots
→ state IDLE
```

If cleanup itself fails, return `START_FAILED_CLEANUP_INCOMPLETE` with `cause_code` and `cleanup_code`.

- [ ] **Step 5: Implement replace confirmation with stale-state protection**

```gdscript
func confirm_replace_and_start() -> Dictionary:
    var lock := _begin_command()
    if String(lock.get("code", "")) != "OK":
        return lock
    if _pending_replace_summary.is_empty():
        _finish_idle()
        return _result(false, "NO_REPLACE_CONFIRMATION")

    var current: Dictionary = _session.inspect_persistence()
    if not _same_record_identity(_pending_replace_summary, current):
        _pending_replace_summary.clear()
        _finish_idle()
        return _result(false, "RECORD_CHANGED")
    if not bool(current.get("requires_replace_confirmation", false)):
        _pending_replace_summary.clear()
        _finish_idle()
        return _result(false, "REPLACE_NOT_ALLOWED")

    var deleted: Dictionary = _session.delete_persistence()
    if String(deleted.get("code", "")) != "OK":
        _finish_idle()
        return deleted
    var empty: Dictionary = _session.inspect_persistence()
    if String(empty.get("repository_code", "")) != "EMPTY":
        _finish_idle()
        return _result(false, "DELETE_VERIFY_FAILED")
    _pending_replace_summary.clear()
    return _start_from_empty(empty)
```

Record identity compares `episode_id`, `lifecycle`, `flow_stage`, `checkpoint_id`, and `updated_at_utc`.

- [ ] **Step 6: Run start/replace tests and Package 1 isolation tests**

```bash
godot --headless --path . --script res://tests/validation/validation_entry_coordinator_test.gd
godot --headless --path . --script res://tests/validation/validation_save_isolation_test.gd
godot --headless --path . --script res://tests/validation/validation_session_test.gd
```

Expected: all exit 0; blocked states and failed commands leave Legacy bytes unchanged.

- [ ] **Step 7: Commit Task 4**

```bash
git add scripts/ui/validation_entry_coordinator.gd \
  tests/validation/validation_entry_coordinator_test.gd
git commit -m "feat: coordinate atomic Validation start and replacement"
```

---

### Task 5: Entry Coordinator — Continue, Completed Record, and Route Rollback

**Files:**
- Modify: `scripts/ui/validation_entry_coordinator.gd`
- Modify: `tests/validation/validation_entry_coordinator_test.gd`

**Interfaces:**
- Produces:

```gdscript
func continue_validation() -> Dictionary
func view_completed_validation() -> Dictionary
```

- [ ] **Step 1: Extend tests with continue and completed RED cases**

Add cases:

1. EXACT active with available route loads once and changes Scene once.
2. EXACT suspended loads, then calls `resume(game_state)`, then routes.
3. completed returns summary with no load, restore, or Scene change.
4. `NOT_AVAILABLE` and `UNKNOWN_FLOW_STAGE` are detected before `load()`.
5. load failure restores runtime and releases lock.
6. resume failure restores runtime and abandons Session runtime.
7. scene-change failure restores runtime and abandons Session runtime while preserving persistence.
8. Legacy bytes and hidden state remain equal for every path.

Expected failure before implementation: `continue_validation()` and `view_completed_validation()` are missing.

- [ ] **Step 2: Implement continue preflight**

```gdscript
func continue_validation() -> Dictionary:
    var lock := _begin_command()
    if String(lock.get("code", "")) != "OK":
        return lock
    var summary: Dictionary = _session.inspect_persistence()
    if not bool(summary.get("can_continue", false)):
        _finish_idle()
        return _result(false, "CONTINUE_NOT_ALLOWED", {"summary": summary})

    var route: Dictionary = _route_mapper.resolve(
        String(summary.get("flow_stage", "")),
        String(summary.get("lifecycle", ""))
    )
    if String(route.get("code", "")) != "OK":
        _finish_idle()
        return route

    return _load_and_route(summary, route)
```

Preflight before `load()` is mandatory so known unavailable routes cannot mutate GameState.

- [ ] **Step 3: Implement guarded load and rollback**

`_load_and_route()` must:

```text
capture Legacy file state
→ capture hidden state
→ capture current Validation runtime snapshot
→ session.load(game_state)
→ if summary lifecycle suspended: session.resume(game_state)
→ verify hidden state
→ verify Legacy file state
→ scene changer
```

If any step after load fails:

```text
restore_validation_runtime_snapshot(runtime_before)
→ abandon_runtime()
→ preserve existing Validation persistence
→ verify Legacy guards
→ state IDLE
```

Return `CONTINUE_FAILED_CLEANUP_INCOMPLETE` only when rollback or guard verification fails.

- [ ] **Step 4: Implement completed read-only view**

```gdscript
func view_completed_validation() -> Dictionary:
    if _state != STATE_IDLE:
        return _result(false, "BUSY")
    var summary: Dictionary = _session.inspect_persistence()
    if not bool(summary.get("can_view_completed", false)):
        return _result(false, "COMPLETED_RECORD_NOT_AVAILABLE", {"summary": summary})
    return _result(true, "OK", {"summary": summary.duplicate(true)})
```

This method does not acquire mutation lock, load Session, restore GameState, or change Scene.

- [ ] **Step 5: Run coordinator test and route mapper test**

```bash
godot --headless --path . --script res://tests/validation/validation_entry_coordinator_test.gd
godot --headless --path . --script res://tests/validation/validation_route_mapper_test.gd
```

Expected: all continue, completed, not-available, unknown, rollback, and guard cases pass.

- [ ] **Step 6: Commit Task 5**

```bash
git add scripts/ui/validation_entry_coordinator.gd \
  tests/validation/validation_entry_coordinator_test.gd
git commit -m "feat: continue and inspect Validation records safely"
```

---

### Task 6: SCREEN-01 Independent Cards, Dialogs, Focus, and UI Contract

**Files:**
- Modify: `scripts/ui/main_menu.gd:1-360`
- Create: `tests/validation/validation_main_menu_contract_test.gd`

**Interfaces:**
- Consumes: `ValidationSession.inspect_persistence()` and `ValidationEntryCoordinator` commands.
- Produces named controls for headless contract tests:
  - `LegacyContinueButton`
  - `LegacyNewCampaignButton`
  - `ValidationPrimaryButton`
  - `ValidationSecondaryButton`
  - `DatabaseButton`
  - `LegacyStatusLabel`
  - `ValidationStatusLabel`
  - `ValidationBadgeLabel`
  - `ValidationStatusDialog`
  - `ValidationReplaceDialog`
  - `ValidationCompletedDialog`

- [ ] **Step 1: Write the failing main-menu contract test**

Create `tests/validation/validation_main_menu_contract_test.gd` and instantiate `res://scripts/ui/main_menu.gd` in an isolated headless tree.

```gdscript
extends SceneTree

const MainMenuScript = preload("res://scripts/ui/main_menu.gd")
var _failures: Array[String] = []

func _init() -> void:
    root.size = Vector2i(1280, 720)
    var menu = MainMenuScript.new()
    root.add_child(menu)
    await process_frame
    await process_frame

    for node_name in [
        "LegacyContinueButton", "LegacyNewCampaignButton",
        "ValidationPrimaryButton", "ValidationSecondaryButton",
        "DatabaseButton", "LegacyStatusLabel", "ValidationStatusLabel",
        "ValidationBadgeLabel", "ValidationStatusDialog",
        "ValidationReplaceDialog", "ValidationCompletedDialog"
    ]:
        _expect(menu.find_child(node_name, true, false) != null, "%s must exist" % node_name)

    var badge := menu.find_child("ValidationBadgeLabel", true, false) as Label
    _expect("별도 기록" in badge.text, "Validation badge must explain persistence separation")

    var legacy_button := menu.find_child("LegacyContinueButton", true, false) as Button
    var validation_button := menu.find_child("ValidationPrimaryButton", true, false) as Button
    _expect(legacy_button.focus_mode == Control.FOCUS_ALL, "Legacy primary must accept keyboard focus")
    _expect(validation_button.focus_mode == Control.FOCUS_ALL, "Validation primary must accept keyboard focus")

    menu.queue_free()
    _finish()
```

Extend with isolated persistence fixtures for EMPTY, active, completed, and corrupt states; call a public test facade `refresh_entry_cards_for_test()` and assert button text, disabled state, status label, and Legacy button independence.

- [ ] **Step 2: Run the UI test and verify RED**

```bash
godot --headless --path . --script res://tests/validation/validation_main_menu_contract_test.gd
```

Expected: FAIL because the independent card controls and dialogs are absent.

- [ ] **Step 3: Refactor main-menu fields and coordinator setup**

At the top of `main_menu.gd` add:

```gdscript
const ValidationEntryCoordinatorScript = preload("res://scripts/ui/validation_entry_coordinator.gd")

var _legacy_continue_button: Button
var _legacy_new_button: Button
var _legacy_status_label: Label
var _validation_primary_button: Button
var _validation_secondary_button: Button
var _validation_status_label: Label
var _validation_badge_label: Label
var _validation_status_dialog: AcceptDialog
var _validation_replace_dialog: ConfirmationDialog
var _validation_completed_dialog: AcceptDialog
var _validation_entry_coordinator
var _last_validation_focus: Control
```

In `_ready()` construct:

```gdscript
_validation_entry_coordinator = ValidationEntryCoordinatorScript.new(
    ValidationSession,
    GameState,
    Callable(self, "_change_scene_from_validation")
)
```

The callback returns `get_tree().change_scene_to_file(scene_path)`.

- [ ] **Step 4: Build two equal-priority cards**

Replace the single `주요 행동` section with an `HBoxContainer` named `EntryCards` containing two `PanelContainer` cards. At narrow width, use a resize handler to switch to vertical stacking while preserving Legacy-first focus order.

Legacy card:

```text
기존 진행
[Legacy status]
[이어하기]
[새 캠페인]
```

Validation card:

```text
Validation 기록
본편과 별도 기록
[episode / stage / status]
[primary action]
[secondary action]
```

Keep `기록국 DB`, accessibility, and debug controls below the cards. Reduce the case image minimum height from `360` to a value that keeps both card titles and primary actions within the 1280×720 scroll contract; use `220` as the initial implementation value and validate at runtime.

- [ ] **Step 5: Implement card refresh from read-only summary**

Replace `_refresh_save_controls()` with `_refresh_entry_cards()`:

```gdscript
func _refresh_entry_cards() -> void:
    var has_legacy := GameState.has_save_file()
    _legacy_continue_button.disabled = not has_legacy
    _legacy_status_label.text = "이어하기 가능" if has_legacy else "저장된 기존 진행 없음"

    var summary: Dictionary = ValidationSession.inspect_persistence()
    _validation_status_label.text = String(summary.get("status_message", "상태 확인 필요"))
    if bool(summary.get("can_continue", false)):
        _set_validation_actions("이어하기", true, "새 기록 시작", true)
    elif bool(summary.get("can_view_completed", false)):
        _set_validation_actions("완료 기록 보기", true, "새 기록 시작", true)
    elif bool(summary.get("can_start", false)):
        _set_validation_actions("새 기록 시작", true, "", false)
    else:
        _set_validation_actions("상태 상세", true, "", false)
```

`_set_validation_actions()` sets text, visibility, disabled state, and callbacks without reconnecting duplicate signals. Use one `_on_validation_primary_pressed()` dispatcher that re-reads the summary before command execution.

- [ ] **Step 6: Implement status, replace, and completed dialogs**

- Status dialog shows `status_label`, `status_message`, repository code, and that Legacy remains available.
- Replace dialog uses the exact approved copy:

```text
현재 Validation 기록을 새 기록으로 교체합니다.
삭제되는 것은 Validation 기록뿐입니다.
기존 캠페인 기록은 변경되지 않습니다.
```

Set cancel as the initial focus. Connect confirmation to `confirm_replace_and_start()` and cancellation/Esc to `cancel_replace()`.

- Completed dialog displays episode title, flow-stage, completion timestamp, and `완료 기록은 읽기 전용입니다.` It calls only `view_completed_validation()`.

- [ ] **Step 7: Apply single-flight UI and focus order**

Before a coordinator mutation, call `_set_mutation_controls_enabled(false)`. After non-scene success, cancellation, or failure, call it with `true` and refresh both cards. Do not disable DB/accessibility for read-only status dialogs.

Set focus chain:

```text
LegacyContinueButton
→ LegacyNewCampaignButton
→ ValidationPrimaryButton
→ ValidationSecondaryButton when visible
→ DatabaseButton
```

On dialog close, restore focus to `_last_validation_focus` when it is still visible and enabled; otherwise focus `ValidationPrimaryButton`.

- [ ] **Step 8: Preserve Legacy behavior inside the Legacy card**

Keep `_start_afterlife_station()` and `_continue_saved_game()` semantics unchanged, including Legacy clear/restart/save behavior. Rename fields only; do not route these buttons through the Validation coordinator.

- [ ] **Step 9: Run UI, coordinator, Legacy flow, and import tests**

```bash
godot --headless --path . --import
godot --headless --path . --script res://tests/validation/validation_main_menu_contract_test.gd
godot --headless --path . --script res://tests/validation/validation_entry_coordinator_test.gd
godot --headless --path . --script res://tests/mvp043_opening_flow_test.gd
```

Expected: all exit 0; Legacy and Validation buttons are independently enabled.

- [ ] **Step 10: Commit Task 6**

```bash
git add scripts/ui/main_menu.gd \
  tests/validation/validation_main_menu_contract_test.gd
git commit -m "feat: add independent Legacy and Validation entry cards"
```

---

### Task 7: Focused Suite, Full Regression, CI, Evidence, and Merge Gate

**Files:**
- Create: `tests/run_validation_package_2_tests.sh`
- Modify: `tests/run_godot_regression.sh:1-120`
- Modify: `tests/test_annual_mvp_001_static_contract.py:30-65`
- Modify: `.github/workflows/validate-core-mvp-001.yml:1-100`
- Modify: `.github/workflows/validate-annual-mvp-001.yml`
- Create: `docs/implementation/2026-08-02-package-2-main-menu-entry-routing-evidence.md`
- Modify after successful implementation: `docs/CURRENT_CONFIRMED_DECISIONS.md`, `docs/CURRENT_HANDOFF_VALIDATION.md`

**Interfaces:**
- Produces: Package 2 focused suite `5/5`, full regression `58/58`, CI evidence bound to one exact implementation HEAD.

- [ ] **Step 1: Create the Package 2 focused runner**

Create `tests/run_validation_package_2_tests.sh` using the same isolated HOME/XDG pattern as Package 1:

```bash
#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
GODOT_BIN="${GODOT_BIN:-godot}"
GODOT_TEST_TIMEOUT="${GODOT_TEST_TIMEOUT:-300}"
RUN_ROOT="${GODOT_TEST_TMP:-$(mktemp -d)}"
LOG_ROOT="$RUN_ROOT/focused-logs"
mkdir -p "$LOG_ROOT"

script_tests=(
  validation/validation_persistence_summary_test
  validation/validation_route_mapper_test
  validation/validation_runtime_initializer_test
  validation/validation_entry_coordinator_test
  validation/validation_main_menu_contract_test
)

for test_path in "${script_tests[@]}"; do
  test_name="${test_path//\//_}"
  home_dir="$RUN_ROOT/home/$test_name"
  log_file="$LOG_ROOT/$test_name.log"
  rm -rf "$home_dir"
  mkdir -p "$home_dir"
  echo "::group::Godot Validation Package 2 test: $test_path"
  if ! HOME="$home_dir" \
      XDG_DATA_HOME="$home_dir/.local/share" \
      XDG_CONFIG_HOME="$home_dir/.config" \
      GODOT_SILENCE_ROOT_WARNING=1 \
      timeout "$GODOT_TEST_TIMEOUT" "$GODOT_BIN" \
      --headless --path "$PROJECT_ROOT" \
      --script "res://tests/$test_path.gd" >"$log_file" 2>&1; then
    cat "$log_file"
    echo "::endgroup::"
    exit 1
  fi
  tail -n 12 "$log_file"
  echo "::endgroup::"
done

echo "Validation Package 2 focused suite: 5/5 test entrypoints passed"
echo "Logs: $LOG_ROOT"
```

Make it executable.

- [ ] **Step 2: Register all five tests in full regression**

Append the five Package 2 test paths immediately after the existing four Package 1 validation tests in `tests/run_godot_regression.sh`. Change the final line to:

```bash
echo "Godot regression suite: 58/58 test entrypoints passed"
```

- [ ] **Step 3: Update static contract assertions**

In `tests/test_annual_mvp_001_static_contract.py`, add all five new test names to `test_regression_runner_registers_annual_and_validation_tests()` and change the count assertion to:

```python
self.assertIn("58/58", runner)
```

Also assert `tests/run_validation_package_2_tests.sh` contains `5/5` and all five test names.

- [ ] **Step 4: Update both workflows**

Add path filters for:

```yaml
- "scripts/ui/validation_entry_coordinator.gd"
- "tests/run_validation_package_2_tests.sh"
```

After Package 1 focused tests add:

```yaml
- name: Run focused Validation Package 2 tests
  env:
    GODOT_BIN: godot
    GODOT_TEST_TMP: ${{ runner.temp }}/validation-package-2-focused
  run: bash tests/run_validation_package_2_tests.sh
```

Add the Package 2 focused log directory to failure artifacts in both workflows.

- [ ] **Step 5: Run the complete local verification matrix**

```bash
python -m unittest \
  tests/test_core_mvp_001_data_contract.py \
  tests/test_core_mvp_001_static_contract.py \
  tests/test_annual_mvp_001_static_contract.py

godot --headless --path . --import
bash tests/run_validation_package_1_tests.sh
bash tests/run_validation_package_2_tests.sh
bash tests/run_core_mvp_001_tests.sh
bash tests/run_godot_regression.sh
git diff --check
```

Expected:

```text
Validation Package 1 focused suite: 4/4 test entrypoints passed
Validation Package 2 focused suite: 5/5 test entrypoints passed
Godot regression suite: 58/58 test entrypoints passed
```

- [ ] **Step 6: Perform the adversarial code review before opening implementation PR**

Inspect the exact diff and answer each item with evidence:

```text
1. Can any Validation path call clear_save_file/reset_run_state/restart_afterlife_station_flow?
2. Can any blocked persistence code reach delete/create/load?
3. Can scene_path from payload reach change_scene_to_file directly?
4. Can a route failure leave Session active or GameState runtime changed?
5. Can a failed command leave the mutation lock engaged?
6. Can Validation error disable Legacy actions?
7. Can replace confirmation delete a record that changed after the modal opened?
8. Does completed record view call load or restore?
9. Are Package 1 4/4 and full regression preserved?
10. Are unexecuted human/visual checks reported as NOT_RUN?
```

Fix every Critical or Important finding with a new failing test before changing production code.

- [ ] **Step 7: Commit CI and runner changes**

```bash
git add tests/run_validation_package_2_tests.sh \
  tests/run_godot_regression.sh \
  tests/test_annual_mvp_001_static_contract.py \
  .github/workflows/validate-core-mvp-001.yml \
  .github/workflows/validate-annual-mvp-001.yml
git commit -m "test: validate Package 2 entry and routing"
```

- [ ] **Step 8: Open a stacked implementation PR without merging planning PR automatically**

Create branch from the approved planning head only after explicit product implementation approval. Open a Draft implementation PR with base `agent/package-2-entry-routing-planning`, record the exact planning head, implementation head, RED runs, GREEN runs, changed files, and `merge NOT_REQUESTED`.

Do not merge PR #129 or the implementation PR at this step.

- [ ] **Step 9: Verify GitHub Actions on the exact implementation HEAD**

Required successful workflows:

```text
Validate documentation contracts
Validate Urban Legend BCA Adoption
Validate CORE-MVP-001
Validate ANNUAL-MVP-001
```

Read job logs and record:

- Python contract counts
- Godot import result
- Package 1 focused 4/4
- Package 2 focused 5/5
- CORE focused result
- full regression 58/58

A prior commit's successful run is not evidence for the final HEAD.

- [ ] **Step 10: Execute or explicitly mark human and visual checks**

When a graphical Godot runtime is available, run at 1280×720 and 1920×1080 and check:

```text
- both card titles and primary actions visible within first viewport or one natural scroll
- keyboard focus follows Legacy primary → Legacy secondary → Validation primary → Validation secondary → DB
- Esc cancels replace dialog
- Enter cannot confirm replacement from default cancel focus
- long Korean error copy does not overlap or clip
- Validation corrupt state leaves Legacy continue enabled
- completed viewer is read-only and returns focus
```

If the environment cannot run these checks, record each as `NOT_RUN`; do not infer PASS from headless tests.

- [ ] **Step 11: Write implementation evidence**

Create `docs/implementation/2026-08-02-package-2-main-menu-entry-routing-evidence.md` with:

```markdown
# Package 2 Main-Menu Entry and Routing Evidence

- planning Decision IDs
- approved Spec path
- planning head
- validated implementation code head
- final PR head
- changed production/test/workflow files
- RED evidence per task
- GREEN commands and outputs
- exact Actions run/job IDs
- Legacy bytes equality evidence
- hidden Legacy semantic equality evidence
- adversarial review findings by severity
- human/visual status
- known limits: unavailable SIT-003/SIT-005..008 routes
- merge status
```

- [ ] **Step 12: Sync GitHub canon and Google Sheet before any merge request**

Using the same approval Decision IDs, update:

```text
00_프로젝트_허브!E2:K2
01_작업순서
02_현재_확정결정
04_누락_충돌_감사
99_변경이력
```

Record exact branch/head, focused/full results, human/visual statuses, blockers, and next gate. Re-read the exact ranges after writing.

- [ ] **Step 13: Final pre-merge adversarial gate**

Immediately before a requested merge:

```text
fetch latest main
fetch planning PR and implementation PR exact heads
list changed files and review threads
verify both PR mergeability
verify latest-head CI
re-read Sheet exact ranges
confirm no product code on planning PR
confirm implementation diff contains only approved Package 2 scope
confirm Grill Me counter remains 1/10 unless a new distinct Grill Me Decision was approved
```

If planning and implementation PRs are stacked, merge planning first with history-preserving merge, retarget/rebase implementation onto latest main, rerun all required checks on the new exact head, then require separate implementation merge approval.

---

## Self-Review

### Spec coverage

| Spec requirement | Plan task |
|---|---|
| independent Legacy/Validation cards | Task 6 |
| read-only persistence summary | Task 1 |
| active/suspended/completed actions | Tasks 1, 5, 6 |
| blocked-state no mutation | Tasks 1, 4, 5 |
| explicit replace confirmation | Tasks 4, 6 |
| flow-stage allowlist | Task 2 |
| unavailable and unknown fail-closed | Tasks 2, 5 |
| whitelist runtime initialization | Task 3 |
| Legacy file and memory no-effect | Tasks 3, 4, 5, 7 |
| single-flight and lock release | Tasks 4, 5, 6 |
| completed read-only view | Tasks 5, 6 |
| keyboard and resolution contracts | Tasks 6, 7 |
| Package 1 regression preservation | Tasks 1, 3, 4, 7 |
| CI and evidence | Task 7 |

Coverage gaps: none.

### Placeholder scan

The plan contains concrete paths, signatures, commands, expected failure reasons, expected success outputs, and merge conditions. No unresolved implementation marker remains.

### Type and name consistency

- `inspect_persistence()` always returns a `Dictionary` summary.
- `resolve(flow_stage: String, lifecycle: String)` always returns `ok/code/route_id/scene_path`.
- `initialize_validation_runtime(episode_id: String, agent_ids: Array)` always returns `ok/code`.
- Coordinator public commands always return `Dictionary` and use the same result code shape.
- UI named nodes match the headless contract test.
- Focused suite count is 5 and full regression count is 58.

### Scope check

The plan changes SCREEN-01 entry/status/routing, Session read-only inspection, whitelist initialization, coordinator orchestration, tests, workflows, and evidence only. It does not design or implement the dedicated preparation, reasoning, safe-route, recovery, or result gameplay screens, and it does not change either save schema.

## Execution Handoff

Plan complete and saved to `docs/superpowers/plans/2026-08-02-package-2-main-menu-entry-routing-implementation-plan.md`.

Recommended execution after explicit product implementation approval: `superpowers:subagent-driven-development`, one task at a time with RED/GREEN evidence and review between tasks. Inline execution is also possible through `superpowers:executing-plans` with checkpoints.