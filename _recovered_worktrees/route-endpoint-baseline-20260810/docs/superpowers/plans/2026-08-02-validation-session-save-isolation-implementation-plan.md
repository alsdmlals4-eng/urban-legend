# Validation Session·Save Isolation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Validation 진행·완료 기록을 독립 저장하면서 기존 `mvp-039` Legacy 저장과 campaign·economy·relationship·faction·market 상태를 변경하지 않는 Package 1 기반을 구현한다.

**Architecture:** `ValidationSession` Autoload가 mode·lifecycle·token·stage·checkpoint·snapshot·ledger를 소유하고, `ValidationSaveRepository`가 별도 파일 검사·원자적 교체·정상 백업 1세대·손상 격리를 소유한다. `GameState`는 Legacy 권위를 유지하며 field-level whitelist export/restore와 active-session save routing만 제공한다. Validation 경계가 유효하지 않으면 양쪽 저장을 모두 금지하는 fail-closed를 적용한다.

**Tech Stack:** Godot 4.7.1, GDScript, SceneTree headless tests, Bash, GitHub Actions, JSON.

## Global Constraints

- 승인 Spec: `docs/superpowers/specs/2026-08-02-validation-session-save-isolation-design.md`.
- 승인 Decision: `D-2026-08-02-PACKAGE-1-DESIGN-SPEC-APPROVAL`.
- Persistence Decision: `D-2026-08-02-VALIDATION-PERSISTENCE-BOUNDARY`.
- Validation primary: `user://urban_legend_validation_save.json`.
- Legacy primary: `user://urban_legend_save.json`.
- Validation slot: 1개.
- Validation version: `validation-save-v1`.
- 정상 backup: 1세대.
- corrupt·incompatible 저장은 자동 삭제·자동 downgrade·자동 primary 승격하지 않는다.
- active invalid Session은 Validation과 Legacy 어느 쪽에도 쓰지 않는다.
- inactive Session은 기존 `GameState.save_game()`, `load_game()`, `clear_save_file()` 의미를 유지한다.
- Legacy file bytes와 campaign·economy·relationship·faction·market 메모리를 모두 보호한다.
- main menu UI, 준비·Reasoning·결과 Scene, episode JSON, route/recovery adapter는 Package 1에서 변경하지 않는다.
- `ValidationSession`은 `GameState`보다 먼저 Autoload한다.
- `scripts/core/validation_session.gd`에는 Autoload 이름과 충돌하는 전역 `class_name`을 선언하지 않는다.
- 각 Task는 RED 확인→최소 GREEN→focused 검증→커밋으로 닫는다.
- 실행하지 않은 Runtime·CI·Human 결과는 `NOT_RUN`이다.

---

## Execution Precondition

기본 실행은 PR #125 문서 정본이 `main`에 병합된 뒤 시작한다.

```bash
git fetch origin
git switch main
git pull --ff-only origin main
BASE_SHA="$(git rev-parse HEAD)"
test -z "$(git status --porcelain)"

# REQUIRED SUB-SKILL: superpowers:using-git-worktrees
mkdir -p .worktrees
git worktree add .worktrees/package-1-session-save-isolation \
  -b agent/package-1-session-save-isolation \
  "$BASE_SHA"
cd .worktrees/package-1-session-save-isolation
```

PR #125 병합 전에 구현을 별도 승인받은 경우에만 stacked branch를 사용한다.

```bash
git fetch origin agent/v9-4-canon-reconciliation
git worktree add .worktrees/package-1-session-save-isolation \
  -b agent/package-1-session-save-isolation \
  origin/agent/v9-4-canon-reconciliation
```

stacked 구현 PR의 base는 `agent/v9-4-canon-reconciliation`이다. 문서 PR 병합 뒤 최신 `main`으로 rebase하고 base를 `main`으로 retarget한다. PR #125 브랜치에 제품 코드를 직접 추가하지 않는다.

## Baseline Verification

- [ ] **Step 1: baseline SHA와 diff가 깨끗한지 확인**

```bash
git status --short
git rev-parse HEAD
git merge-base HEAD origin/main
git diff --name-only origin/main...HEAD
```

Expected: clean worktree, 승인된 문서 정본 또는 최신 `main`에서 시작, 제품 diff 없음.

- [ ] **Step 2: 기존 import·focused·49-entry 회귀 실행**

```bash
godot --headless --path . --import
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_core_mvp_001_tests.sh
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_annual_mvp_001_tests.sh
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_annual_mvp_002_tests.sh
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_godot_regression.sh
```

Expected: import exit 0, focused suites exit 0, `Godot regression suite: 49/49 test entrypoints passed`.

기존 baseline이 실패하면 구현을 시작하지 않고 exact SHA·실패 entrypoint·로그를 기록한다.

---

## File Responsibility Map

### Create

- `scripts/core/validation_save_repository.gd` — Validation 파일 검사·version matrix·temp/readback/replace·backup·quarantine·삭제.
- `scripts/core/validation_session.gd` — Session lifecycle·token·snapshot·guard·completion ledger.
- `tests/validation/validation_test_support.gd` — bytes·JSON fixture·semantic equality·격리 경로 정리.
- `tests/validation/validation_save_repository_test.gd` — repository 경계와 손상/호환 matrix.
- `tests/validation/validation_session_test.gd` — lifecycle와 completion idempotency.
- `tests/validation/validation_game_state_adapter_test.gd` — whitelist와 hidden-state guard.
- `tests/validation/validation_save_isolation_test.gd` — 실제 Autoload·routing·양방향 byte isolation.
- `tests/run_validation_package_1_tests.sh` — focused 4-entry runner.

### Modify

- `project.godot:17-23` — `ValidationSession`을 `GameState` 앞에 Autoload.
- `scripts/core/game_state.gd:2750-2990` — whitelist adapter, hidden snapshot, Legacy save 분리, routing.
- `tests/run_godot_regression.sh:11-58,91-92` — 네 test 등록, 총 53-entry.
- `.github/workflows/validate-core-mvp-001.yml` — Package 1 trigger·focused step·failure logs.
- `.github/workflows/validate-annual-mvp-001.yml` — core trigger·focused step·failure logs.
- `TEST_CHECKLIST.md`, `docs/CURRENT_STATUS.md`, `docs/CURRENT_HANDOFF_VALIDATION.md` — 실제 evidence만 기록.

---

### Task 1: Repository Contract and Atomic Persistence

**Files:**
- Create: `scripts/core/validation_save_repository.gd`
- Create: `tests/validation/validation_test_support.gd`
- Create: `tests/validation/validation_save_repository_test.gd`

**Interfaces:**
- Produces: `ValidationSaveRepository.new(primary_path)`, `get_paths()`, `inspect()`, `read_payload()`, `write_payload()`, `delete_persistence()`, `quarantine_primary()`.
- Result shape: `{"ok": bool, "code": String, ...}`.

- [ ] **Step 1: test support helper 작성**

```gdscript
class_name ValidationTestSupport
extends RefCounted

static func read_bytes(path: String) -> PackedByteArray:
	return FileAccess.get_file_as_bytes(path) if FileAccess.file_exists(path) else PackedByteArray()

static func write_text(path: String, text: String) -> Error:
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		return FileAccess.get_open_error()
	file.store_string(text)
	file.flush()
	file.close()
	return OK

static func remove_path(path: String) -> void:
	if not path.is_empty() and FileAccess.file_exists(path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(path))

static func remove_repository_paths(paths: Dictionary) -> void:
	for key in ["primary", "backup", "temp"]:
		remove_path(String(paths.get(key, "")))

static func semantic_equal(left: Variant, right: Variant) -> bool:
	if typeof(left) in [TYPE_INT, TYPE_FLOAT] and typeof(right) in [TYPE_INT, TYPE_FLOAT]:
		return is_equal_approx(float(left), float(right))
	if typeof(left) == TYPE_DICTIONARY and typeof(right) == TYPE_DICTIONARY:
		var a := left as Dictionary
		var b := right as Dictionary
		if a.size() != b.size():
			return false
		for key in a:
			if not b.has(key) or not semantic_equal(a[key], b[key]):
				return false
		return true
	if typeof(left) == TYPE_ARRAY and typeof(right) == TYPE_ARRAY:
		var a := left as Array
		var b := right as Array
		if a.size() != b.size():
			return false
		for index in range(a.size()):
			if not semantic_equal(a[index], b[index]):
				return false
		return true
	return left == right
```

- [ ] **Step 2: failing repository test 작성**

`tests/validation/validation_save_repository_test.gd`는 `SceneTree` test 형식을 사용하고 다음을 검증한다.

```gdscript
extends SceneTree

const Repository = preload("res://scripts/core/validation_save_repository.gd")
const Support = preload("res://tests/validation/validation_test_support.gd")
const TEST_PRIMARY := "user://validation_package_1_repository_test.json"
const LEGACY_PATH := "user://urban_legend_save.json"

var _failures: Array[String] = []

func _payload(revision: int = 1, version: String = "validation-save-v1") -> Dictionary:
	return {
		"format": "urban-legend-validation-save",
		"version": version,
		"payload_schema": 1,
		"revision": revision,
		"session": {
			"token": "repository-test-token",
			"lifecycle": "active",
			"episode_id": "episode_001_afterlife_station",
			"flow_stage": "SIT-004",
			"checkpoint_id": "investigation:platform:observation-02",
			"return_target": "investigation:platform",
			"focus_token": ""
		},
		"snapshots": {"runtime": {}, "preparation": {}, "reasoning": {}, "route": {}, "recovery": {}},
		"result": {"axes": {}, "candidate_records": {}, "applied_effect_ids": {}},
		"timestamps": {"created_at_utc": "2026-08-02T02:20:00Z", "updated_at_utc": "2026-08-02T02:20:00Z", "completed_at_utc": ""},
		"integrity": {"content_episode_id": "episode_001_afterlife_station"}
	}

func _init() -> void:
	var repository = Repository.new(TEST_PRIMARY)
	var paths: Dictionary = repository.get_paths()
	Support.remove_repository_paths(paths)
	_expect(String(paths["primary"]) != LEGACY_PATH, "Validation primary must differ from Legacy")
	_expect(repository.inspect().get("code") == "EMPTY", "missing primary should inspect EMPTY")
	_expect(repository.write_payload(_payload(1)).get("code") == "OK", "first write should succeed")
	_expect(repository.inspect().get("code") == "EXACT", "written primary should inspect EXACT")
	_expect(Support.semantic_equal(repository.read_payload().get("payload", {}), _payload(1)), "readback should equal written payload")
	_expect(repository.write_payload(_payload(2)).get("code") == "OK", "second write should succeed")
	_expect(FileAccess.file_exists(String(paths["backup"])), "second write should preserve one backup")
	Support.write_text(String(paths["primary"]), "{broken-json")
	_expect(repository.inspect().get("code") == "CORRUPT_JSON", "broken JSON should remain inspectable")
	_expect(FileAccess.file_exists(String(paths["primary"])), "corrupt primary must not be auto deleted")
	var quarantine: Dictionary = repository.quarantine_primary("parse-failure")
	_expect(quarantine.get("code") == "OK", "explicit quarantine should succeed")
	_expect(FileAccess.file_exists(String(quarantine.get("quarantine_path", ""))), "quarantine should preserve bytes")
	Support.write_text(String(paths["primary"]), JSON.stringify(_payload(3, "validation-save-v2")))
	_expect(repository.inspect().get("code") == "INCOMPATIBLE_NEWER", "v2 should be inspect-only")
	_expect(repository.write_payload(_payload(4)).get("code") == "INCOMPATIBLE_NEWER", "newer primary must not be overwritten")
	Support.remove_path(String(paths["primary"]))
	Support.write_text(String(paths["temp"]), JSON.stringify(_payload(5)))
	_expect(repository.inspect().get("code") == "INTERRUPTED_WRITE", "temp-only state must not auto promote")
	Support.remove_repository_paths(paths)
	_finish()

func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)

func _finish() -> void:
	if _failures.is_empty():
		print("VALIDATION SAVE REPOSITORY: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
```

- [ ] **Step 3: RED 확인**

```bash
TEST_HOME="$(mktemp -d)"
HOME="$TEST_HOME" XDG_DATA_HOME="$TEST_HOME/.local/share" XDG_CONFIG_HOME="$TEST_HOME/.config" \
  godot --headless --path . --script res://tests/validation/validation_save_repository_test.gd
```

Expected: repository script preload 실패.

- [ ] **Step 4: repository 최소 구현 작성**

`scripts/core/validation_save_repository.gd`의 public·private method는 아래 목록과 정확히 일치시킨다.

```gdscript
class_name ValidationSaveRepository
extends RefCounted

const PRIMARY_PATH := "user://urban_legend_validation_save.json"
const LEGACY_FORBIDDEN_PATH := "user://urban_legend_save.json"
const FORMAT_ID := "urban-legend-validation-save"
const SAVE_VERSION := "validation-save-v1"
const PAYLOAD_SCHEMA := 1

var _primary_path: String
var _backup_path: String
var _temp_path: String
var _quarantine_prefix: String

func _init(primary_path: String = PRIMARY_PATH) -> void:
	_primary_path = primary_path
	var stem := primary_path.substr(0, primary_path.length() - 5) if primary_path.ends_with(".json") else primary_path
	_backup_path = "%s.bak.json" % stem
	_temp_path = "%s.tmp.json" % stem
	_quarantine_prefix = "%s.corrupt." % stem

func get_paths() -> Dictionary:
	return {"primary": _primary_path, "backup": _backup_path, "temp": _temp_path, "quarantine_prefix": _quarantine_prefix, "legacy_forbidden": LEGACY_FORBIDDEN_PATH}

func inspect() -> Dictionary:
	if _primary_path == LEGACY_FORBIDDEN_PATH:
		return _result(false, "LEGACY_GUARD_VIOLATION")
	if not FileAccess.file_exists(_primary_path):
		if FileAccess.file_exists(_temp_path):
			return _result(false, "INTERRUPTED_WRITE")
		if FileAccess.file_exists(_backup_path):
			var backup := _inspect_path(_backup_path)
			return _result(false, "RECOVERABLE_BACKUP", {"backup_code": backup.get("code", "READ_FAILED")})
		return _result(false, "EMPTY")
	return _inspect_path(_primary_path)

func read_payload() -> Dictionary:
	return inspect()

func write_payload(payload: Dictionary) -> Dictionary:
	if _primary_path == LEGACY_FORBIDDEN_PATH:
		return _result(false, "LEGACY_GUARD_VIOLATION")
	var requested := _validate_payload(payload)
	if requested.get("code") != "EXACT":
		return requested
	if FileAccess.file_exists(_primary_path):
		var current := _inspect_path(_primary_path)
		if current.get("code") != "EXACT":
			return current
	var temp_file := FileAccess.open(_temp_path, FileAccess.WRITE)
	if temp_file == null:
		return _result(false, "WRITE_FAILED", {"error": FileAccess.get_open_error()})
	temp_file.store_string(JSON.stringify(payload, "\t", false))
	temp_file.flush()
	temp_file.close()
	if _inspect_path(_temp_path).get("code") != "EXACT":
		return _result(false, "VERIFY_FAILED")
	var primary_abs := ProjectSettings.globalize_path(_primary_path)
	var backup_abs := ProjectSettings.globalize_path(_backup_path)
	var temp_abs := ProjectSettings.globalize_path(_temp_path)
	if FileAccess.file_exists(_primary_path):
		if FileAccess.file_exists(_backup_path):
			var remove_backup := DirAccess.remove_absolute(backup_abs)
			if remove_backup != OK:
				return _result(false, "REPLACE_FAILED", {"error": remove_backup})
		var backup_error := DirAccess.rename_absolute(primary_abs, backup_abs)
		if backup_error != OK:
			return _result(false, "REPLACE_FAILED", {"error": backup_error})
	var replace_error := DirAccess.rename_absolute(temp_abs, primary_abs)
	if replace_error != OK:
		if FileAccess.file_exists(_backup_path) and not FileAccess.file_exists(_primary_path):
			DirAccess.rename_absolute(backup_abs, primary_abs)
		return _result(false, "REPLACE_FAILED", {"error": replace_error})
	if _inspect_path(_primary_path).get("code") != "EXACT":
		if FileAccess.file_exists(_primary_path):
			DirAccess.remove_absolute(primary_abs)
		if FileAccess.file_exists(_backup_path):
			DirAccess.rename_absolute(backup_abs, primary_abs)
		return _result(false, "VERIFY_FAILED")
	return _result(true, "OK", {"revision": int(payload.get("revision", 0))})

func delete_persistence() -> Dictionary:
	if _primary_path == LEGACY_FORBIDDEN_PATH:
		return _result(false, "LEGACY_GUARD_VIOLATION")
	for path in [_primary_path, _backup_path, _temp_path]:
		if FileAccess.file_exists(path):
			var error := DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
			if error != OK:
				return _result(false, "DELETE_FAILED", {"path": path, "error": error})
	return _result(true, "OK")

func quarantine_primary(reason: String) -> Dictionary:
	var state := inspect()
	if state.get("code") not in ["CORRUPT_JSON", "CORRUPT_SCHEMA"]:
		return _result(false, "INVALID_LIFECYCLE")
	var stamp := Time.get_datetime_string_from_system(true, true).replace(":", "-")
	var path := "%s%s.%s.json" % [_quarantine_prefix, stamp, reason.validate_filename()]
	var error := DirAccess.rename_absolute(ProjectSettings.globalize_path(_primary_path), ProjectSettings.globalize_path(path))
	return _result(error == OK, "OK" if error == OK else "REPLACE_FAILED", {"quarantine_path": path, "error": error})

func _inspect_path(path: String) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return _result(false, "READ_FAILED", {"error": FileAccess.get_open_error()})
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	file.close()
	if typeof(parsed) != TYPE_DICTIONARY:
		return _result(false, "CORRUPT_JSON")
	return _validate_payload(parsed as Dictionary)

func _validate_payload(payload: Dictionary) -> Dictionary:
	if String(payload.get("format", "")) != FORMAT_ID:
		return _result(false, "CORRUPT_SCHEMA")
	var version_code := _classify_version(String(payload.get("version", "")))
	if version_code != "EXACT":
		return _result(false, version_code, {"payload": payload.duplicate(true)})
	if int(payload.get("payload_schema", 0)) != PAYLOAD_SCHEMA or int(payload.get("revision", -1)) < 0:
		return _result(false, "CORRUPT_SCHEMA")
	for key in ["session", "snapshots", "result", "timestamps", "integrity"]:
		if typeof(payload.get(key)) != TYPE_DICTIONARY:
			return _result(false, "CORRUPT_SCHEMA", {"field": key})
	return _result(true, "EXACT", {"payload": payload.duplicate(true)})

func _classify_version(version: String) -> String:
	if version == SAVE_VERSION:
		return "EXACT"
	const PREFIX := "validation-save-v"
	if not version.begins_with(PREFIX):
		return "CORRUPT_SCHEMA"
	var number_text := version.substr(PREFIX.length())
	if not number_text.is_valid_int():
		return "CORRUPT_SCHEMA"
	return "INCOMPATIBLE_OLDER" if int(number_text) < 1 else "INCOMPATIBLE_NEWER"

func _result(ok: bool, code: String, details: Dictionary = {}) -> Dictionary:
	var result := {"ok": ok, "code": code}
	for key in details:
		result[key] = details[key]
	return result
```

- [ ] **Step 5: GREEN 확인**

Expected: `VALIDATION SAVE REPOSITORY: PASS`, exit 0.

- [ ] **Step 6: commit**

```bash
git add scripts/core/validation_save_repository.gd tests/validation/validation_test_support.gd tests/validation/validation_save_repository_test.gd
git commit -m "feat: add isolated validation save repository"
```

---

### Task 2: Session Lifecycle and Idempotency

**Files:**
- Create: `scripts/core/validation_session.gd`
- Create: `tests/validation/validation_session_test.gd`

**Interfaces:**
- Consumes: Task 1 repository.
- Produces: `create`, `activate`, `capture_legacy_guard`, `save`, `load`, `suspend`, `resume`, `complete`, `abandon_runtime`, `delete_persistence`, `deactivate`, `requires_save_routing`, `is_active_and_valid`.

- [ ] **Step 1: FakeGameState 기반 RED test 작성**

Test Fake는 아래 세 method를 제공한다.

```gdscript
class FakeGameState:
	extends RefCounted
	var runtime := {"episode_id": "episode_001_afterlife_station", "episode_path": "res://data/episodes/episode_001_afterlife_station.json", "selected_agent_ids": ["agent_kwon_narae"], "flags": [], "collected_clue_ids": [], "seen_hint_ids": [], "method_results": {}, "minigame_results": {}, "resolution": {}, "recovery": {}, "agent_case_states": {}, "victim_state": {}}
	var hidden := {"echo_fragments": 30, "campaign_state": {"week": 1}}
	func export_validation_runtime_snapshot() -> Dictionary: return runtime.duplicate(true)
	func restore_validation_runtime_snapshot(snapshot: Dictionary) -> Dictionary:
		runtime = snapshot.duplicate(true)
		return {"ok": true, "code": "OK"}
	func snapshot_hidden_legacy_state_for_test() -> Dictionary: return hidden.duplicate(true)
```

Test sequence:

```gdscript
var session = SessionScript.new()
session.configure_repository_path_for_test(TEST_PRIMARY)
var created: Dictionary = session.create("episode_001_afterlife_station")
var token := String(created.get("session_token", ""))
_expect(created.get("code") == "OK" and not token.is_empty(), "create should generate token")
_expect(session.activate("wrong-token").get("code") == "SESSION_TOKEN_MISMATCH", "wrong token should fail")
_expect(session.activate(token).get("code") == "OK", "correct token should activate")
_expect(session.capture_legacy_guard(game_state).get("code") == "OK", "guard should capture")
_expect(session.save(game_state).get("code") == "OK", "active session should save")
_expect(session.suspend(game_state).get("code") == "OK", "active session should suspend")
_expect(session.resume(game_state).get("code") == "OK", "suspended session should resume")
_expect(session.complete({"effect_id": "validation:afterlife:completion:v1"}, game_state).get("code") == "OK", "completion should persist")
_expect(session.complete({"effect_id": "validation:afterlife:completion:v1"}, game_state).get("code") == "ALREADY_COMPLETED", "completion should be idempotent")
_expect(session.abandon_runtime().get("code") == "OK", "abandon should clear memory only")
_expect(FileAccess.file_exists(TEST_PRIMARY), "abandon should retain persistence")
_expect(session.load(game_state).get("code") == "OK", "completed save should load for inspection")
_expect(session.delete_persistence().get("code") == "OK", "inactive completed save should delete")
```

- [ ] **Step 2: RED 실행**

```bash
TEST_HOME="$(mktemp -d)"
HOME="$TEST_HOME" XDG_DATA_HOME="$TEST_HOME/.local/share" XDG_CONFIG_HOME="$TEST_HOME/.config" \
  godot --headless --path . --script res://tests/validation/validation_session_test.gd
```

Expected: session script preload 실패.

- [ ] **Step 3: Session full state contract 구현**

`scripts/core/validation_session.gd`는 다음 exact state와 helpers를 포함한다.

```gdscript
extends Node

const RepositoryScript = preload("res://scripts/core/validation_save_repository.gd")
const MODE_INACTIVE := "inactive"
const MODE_VALIDATION := "validation"
const LIFECYCLE_EMPTY := "empty"
const LIFECYCLE_ACTIVE := "active"
const LIFECYCLE_SUSPENDED := "suspended"
const LIFECYCLE_COMPLETED := "completed"
const SAVE_VERSION := "validation-save-v1"
const ALLOWED_EPISODES := ["episode_001_afterlife_station"]
const COMPLETION_EFFECT_ID := "validation:afterlife:completion:v1"

var _repository = RepositoryScript.new()
var _mode := MODE_INACTIVE
var _lifecycle := LIFECYCLE_EMPTY
var _session_token := ""
var _episode_id := ""
var _flow_stage := "SIT-001"
var _checkpoint_id := ""
var _return_target := ""
var _focus_token := ""
var _runtime_snapshot: Dictionary = {}
var _preparation_snapshot: Dictionary = {}
var _reasoning_state: Dictionary = {}
var _route_state: Dictionary = {}
var _recovery_progress: Dictionary = {}
var _result_axes: Dictionary = {}
var _candidate_records: Dictionary = {}
var _applied_effect_ids: Dictionary = {}
var _legacy_guard_snapshot: Dictionary = {}
var _created_at_utc := ""
var _updated_at_utc := ""
var _completed_at_utc := ""
var _revision := 0

func configure_repository_path_for_test(path: String) -> void:
	if _mode == MODE_INACTIVE:
		_repository = RepositoryScript.new(path)

func get_repository_paths() -> Dictionary: return _repository.get_paths()
func get_revision() -> int: return _revision
func requires_save_routing() -> bool: return _mode == MODE_VALIDATION
func is_active_and_valid() -> bool:
	return _mode == MODE_VALIDATION and _lifecycle == LIFECYCLE_ACTIVE and not _session_token.is_empty() and ALLOWED_EPISODES.has(_episode_id)

func create(episode_id: String) -> Dictionary:
	if not ALLOWED_EPISODES.has(episode_id): return _result(false, "INVALID_EPISODE")
	if _repository.inspect().get("code") != "EMPTY": return _result(false, "ALREADY_EXISTS")
	_reset_memory()
	_episode_id = episode_id
	_lifecycle = LIFECYCLE_ACTIVE
	_session_token = Crypto.new().generate_random_bytes(16).hex_encode()
	_created_at_utc = Time.get_datetime_string_from_system(true, true)
	_updated_at_utc = _created_at_utc
	return _result(true, "OK", {"session_token": _session_token})

func activate(token: String) -> Dictionary:
	if _mode == MODE_VALIDATION: return _result(false, "SESSION_ALREADY_ACTIVE")
	if _lifecycle != LIFECYCLE_ACTIVE: return _result(false, "INVALID_LIFECYCLE")
	if token != _session_token: return _result(false, "SESSION_TOKEN_MISMATCH")
	if not ALLOWED_EPISODES.has(_episode_id): return _result(false, "INVALID_EPISODE")
	_mode = MODE_VALIDATION
	return _result(true, "OK")

func capture_legacy_guard(game_state: Object) -> Dictionary:
	_legacy_guard_snapshot = game_state.snapshot_hidden_legacy_state_for_test()
	return _result(true, "OK")

func save(game_state: Object) -> Dictionary:
	if not is_active_and_valid(): return _result(false, "SESSION_NOT_ACTIVE")
	var guard := _verify_hidden_guard(game_state)
	if guard.get("code") != "OK": return guard
	_runtime_snapshot = game_state.export_validation_runtime_snapshot()
	_revision += 1
	_updated_at_utc = Time.get_datetime_string_from_system(true, true)
	return _repository.write_payload(_build_payload())

func load(game_state: Object) -> Dictionary:
	var read_result := _repository.read_payload()
	if read_result.get("code") != "EXACT": return read_result
	var applied := _apply_payload(read_result.get("payload", {}) as Dictionary)
	if applied.get("code") != "OK": return applied
	var hidden_before: Dictionary = game_state.snapshot_hidden_legacy_state_for_test()
	var restored: Dictionary = game_state.restore_validation_runtime_snapshot(_runtime_snapshot)
	if restored.get("code") != "OK": return _result(false, "RESTORE_FAILED")
	var hidden_after: Dictionary = game_state.snapshot_hidden_legacy_state_for_test()
	if hidden_before != hidden_after: return _result(false, "HIDDEN_STATE_GUARD_VIOLATION")
	_legacy_guard_snapshot = hidden_after.duplicate(true)
	_mode = MODE_VALIDATION if _lifecycle == LIFECYCLE_ACTIVE else MODE_INACTIVE
	return _result(true, "OK")

func suspend(game_state: Object) -> Dictionary:
	if not is_active_and_valid(): return _result(false, "SESSION_NOT_ACTIVE")
	var guard := _verify_hidden_guard(game_state)
	if guard.get("code") != "OK": return guard
	_runtime_snapshot = game_state.export_validation_runtime_snapshot()
	_lifecycle = LIFECYCLE_SUSPENDED
	_revision += 1
	_updated_at_utc = Time.get_datetime_string_from_system(true, true)
	var written := _repository.write_payload(_build_payload())
	if written.get("code") == "OK": _mode = MODE_INACTIVE
	return written

func resume(game_state: Object) -> Dictionary:
	if _lifecycle != LIFECYCLE_SUSPENDED: return _result(false, "INVALID_LIFECYCLE")
	_lifecycle = LIFECYCLE_ACTIVE
	_mode = MODE_VALIDATION
	_legacy_guard_snapshot = game_state.snapshot_hidden_legacy_state_for_test()
	return _result(true, "OK")

func complete(payload: Dictionary, game_state: Object) -> Dictionary:
	if _lifecycle == LIFECYCLE_COMPLETED: return _result(false, "ALREADY_COMPLETED")
	if not is_active_and_valid(): return _result(false, "SESSION_NOT_ACTIVE")
	if String(payload.get("effect_id", "")) != COMPLETION_EFFECT_ID: return _result(false, "INVALID_PAYLOAD")
	var guard := _verify_hidden_guard(game_state)
	if guard.get("code") != "OK": return guard
	_applied_effect_ids[COMPLETION_EFFECT_ID] = true
	_lifecycle = LIFECYCLE_COMPLETED
	_completed_at_utc = Time.get_datetime_string_from_system(true, true)
	_updated_at_utc = _completed_at_utc
	_runtime_snapshot = game_state.export_validation_runtime_snapshot()
	_revision += 1
	var written := _repository.write_payload(_build_payload())
	if written.get("code") == "OK": _mode = MODE_INACTIVE
	return written

func abandon_runtime() -> Dictionary:
	_mode = MODE_INACTIVE
	_reset_memory(false)
	return _result(true, "OK")

func delete_persistence() -> Dictionary:
	if _mode == MODE_VALIDATION: return _result(false, "INVALID_LIFECYCLE")
	var result := _repository.delete_persistence()
	if result.get("code") == "OK": _reset_memory()
	return result

func deactivate() -> Dictionary:
	_mode = MODE_INACTIVE
	_legacy_guard_snapshot.clear()
	return _result(true, "OK")

func invalidate_token_for_test() -> void:
	if OS.is_debug_build(): _session_token = ""

func _build_payload() -> Dictionary:
	return {
		"format": "urban-legend-validation-save", "version": SAVE_VERSION, "payload_schema": 1, "revision": _revision,
		"session": {"token": _session_token, "lifecycle": _lifecycle, "episode_id": _episode_id, "flow_stage": _flow_stage, "checkpoint_id": _checkpoint_id, "return_target": _return_target, "focus_token": _focus_token},
		"snapshots": {"runtime": _runtime_snapshot.duplicate(true), "preparation": _preparation_snapshot.duplicate(true), "reasoning": _reasoning_state.duplicate(true), "route": _route_state.duplicate(true), "recovery": _recovery_progress.duplicate(true)},
		"result": {"axes": _result_axes.duplicate(true), "candidate_records": _candidate_records.duplicate(true), "applied_effect_ids": _applied_effect_ids.duplicate(true)},
		"timestamps": {"created_at_utc": _created_at_utc, "updated_at_utc": _updated_at_utc, "completed_at_utc": _completed_at_utc},
		"integrity": {"content_episode_id": _episode_id}
	}

func _apply_payload(payload: Dictionary) -> Dictionary:
	var session_value: Variant = payload.get("session")
	var snapshots_value: Variant = payload.get("snapshots")
	var result_value: Variant = payload.get("result")
	var timestamps_value: Variant = payload.get("timestamps")
	if typeof(session_value) != TYPE_DICTIONARY or typeof(snapshots_value) != TYPE_DICTIONARY or typeof(result_value) != TYPE_DICTIONARY or typeof(timestamps_value) != TYPE_DICTIONARY:
		return _result(false, "CORRUPT_SCHEMA")
	var session := session_value as Dictionary
	var snapshots := snapshots_value as Dictionary
	var result := result_value as Dictionary
	var timestamps := timestamps_value as Dictionary
	var episode_id := String(session.get("episode_id", ""))
	var lifecycle := String(session.get("lifecycle", ""))
	if not ALLOWED_EPISODES.has(episode_id): return _result(false, "INVALID_EPISODE")
	if lifecycle not in [LIFECYCLE_ACTIVE, LIFECYCLE_SUSPENDED, LIFECYCLE_COMPLETED]: return _result(false, "INVALID_LIFECYCLE")
	if typeof(snapshots.get("runtime")) != TYPE_DICTIONARY: return _result(false, "CORRUPT_SCHEMA")
	_session_token = String(session.get("token", ""))
	_episode_id = episode_id
	_lifecycle = lifecycle
	_flow_stage = String(session.get("flow_stage", ""))
	_checkpoint_id = String(session.get("checkpoint_id", ""))
	_return_target = String(session.get("return_target", ""))
	_focus_token = String(session.get("focus_token", ""))
	_runtime_snapshot = (snapshots.get("runtime", {}) as Dictionary).duplicate(true)
	_preparation_snapshot = (snapshots.get("preparation", {}) as Dictionary).duplicate(true)
	_reasoning_state = (snapshots.get("reasoning", {}) as Dictionary).duplicate(true)
	_route_state = (snapshots.get("route", {}) as Dictionary).duplicate(true)
	_recovery_progress = (snapshots.get("recovery", {}) as Dictionary).duplicate(true)
	_result_axes = (result.get("axes", {}) as Dictionary).duplicate(true)
	_candidate_records = (result.get("candidate_records", {}) as Dictionary).duplicate(true)
	_applied_effect_ids = (result.get("applied_effect_ids", {}) as Dictionary).duplicate(true)
	_created_at_utc = String(timestamps.get("created_at_utc", ""))
	_updated_at_utc = String(timestamps.get("updated_at_utc", ""))
	_completed_at_utc = String(timestamps.get("completed_at_utc", ""))
	_revision = int(payload.get("revision", 0))
	return _result(true, "OK")

func _verify_hidden_guard(game_state: Object) -> Dictionary:
	var current: Dictionary = game_state.snapshot_hidden_legacy_state_for_test()
	if _legacy_guard_snapshot.is_empty():
		_legacy_guard_snapshot = current.duplicate(true)
		return _result(true, "OK")
	return _result(current == _legacy_guard_snapshot, "OK" if current == _legacy_guard_snapshot else "HIDDEN_STATE_GUARD_VIOLATION")

func _reset_memory(reset_repository_state: bool = true) -> void:
	_mode = MODE_INACTIVE
	_lifecycle = LIFECYCLE_EMPTY
	_session_token = ""
	_episode_id = ""
	_flow_stage = "SIT-001"
	_checkpoint_id = ""
	_return_target = ""
	_focus_token = ""
	_runtime_snapshot.clear(); _preparation_snapshot.clear(); _reasoning_state.clear(); _route_state.clear(); _recovery_progress.clear(); _result_axes.clear(); _candidate_records.clear(); _applied_effect_ids.clear(); _legacy_guard_snapshot.clear()
	_created_at_utc = ""; _updated_at_utc = ""; _completed_at_utc = ""; _revision = 0
	if not reset_repository_state: pass

func _result(ok: bool, code: String, details: Dictionary = {}) -> Dictionary:
	var result := {"ok": ok, "code": code}
	for key in details: result[key] = details[key]
	return result
```

- [ ] **Step 4: GREEN 실행**

Expected: `VALIDATION SESSION: PASS`, exit 0.

- [ ] **Step 5: commit**

```bash
git add scripts/core/validation_session.gd tests/validation/validation_session_test.gd
git commit -m "feat: add validation session lifecycle"
```

---

### Task 3: GameState Whitelist Adapter

**Files:**
- Modify: `scripts/core/game_state.gd`
- Create: `tests/validation/validation_game_state_adapter_test.gd`

**Interfaces:**
- Produces: `export_validation_runtime_snapshot()`, `restore_validation_runtime_snapshot()`, `snapshot_hidden_legacy_state_for_test()`.

- [ ] **Step 1: RED test 작성**

Test는 다음을 검증한다.

```gdscript
var hidden_before := state.snapshot_hidden_legacy_state_for_test()
var snapshot := state.export_validation_runtime_snapshot()
for forbidden in ["campaign_state", "echo_fragments", "faction_relations", "completed_case_reports", "anomaly_manual_records", "agent_trust"]:
	_expect(not snapshot.has(forbidden), "snapshot must exclude %s" % forbidden)
var restored := clone.restore_validation_runtime_snapshot(snapshot)
_expect(restored.get("code") == "OK", "valid snapshot should restore")
_expect(Support.semantic_equal(clone.export_validation_runtime_snapshot(), snapshot), "restored snapshot should match")
_expect(Support.semantic_equal(clone.snapshot_hidden_legacy_state_for_test(), clone_hidden_before), "restore must preserve hidden state")
var invalid := snapshot.duplicate(true)
invalid["episode_id"] = "unknown_episode"
_expect(clone.restore_validation_runtime_snapshot(invalid).get("code") == "INVALID_EPISODE", "unknown episode should fail")
_expect(Support.semantic_equal(clone.export_validation_runtime_snapshot(), before_invalid), "failed restore must not partially apply")
_expect(Support.semantic_equal(state.snapshot_hidden_legacy_state_for_test(), hidden_before), "export must not mutate hidden state")
```

- [ ] **Step 2: RED 실행**

```bash
TEST_HOME="$(mktemp -d)"
HOME="$TEST_HOME" XDG_DATA_HOME="$TEST_HOME/.local/share" XDG_CONFIG_HOME="$TEST_HOME/.config" \
  godot --headless --path . --script res://tests/validation/validation_game_state_adapter_test.gd
```

Expected: adapter method 없음으로 실패.

- [ ] **Step 3: whitelist export 구현**

```gdscript
func export_validation_runtime_snapshot() -> Dictionary:
	return {
		"episode_id": get_current_episode_id(), "episode_path": current_episode_path, "scene_path": current_scene_path,
		"dialogue_node_id": current_dialogue_node_id, "field_node_id": current_field_node_id, "minigame_id": current_minigame_id,
		"selected_agent_ids": selected_agent_ids.duplicate(), "flags": flags.duplicate(), "collected_clue_ids": get_collected_clue_ids(), "seen_hint_ids": seen_hint_ids.duplicate(),
		"method_results": method_results.duplicate(true), "minigame_results": minigame_results.duplicate(true),
		"resolution": {"grade": selected_resolution_grade, "label": selected_resolution_label, "rate": selected_resolution_rate},
		"recovery": {"successful": recovery_successful, "result_status": recovery_result_status, "stability": recovery_result_stability, "current_pattern_id": current_recovery_pattern_id, "last_pattern_id": last_recovery_pattern_id, "confirmed_pattern_id": confirmed_recovery_pattern_id, "seen_pattern_ids": seen_recovery_pattern_ids.duplicate(), "pattern_learning": recovery_pattern_learning.duplicate(true)},
		"agent_case_states": agent_case_states.duplicate(true), "victim_state": victim_state.duplicate(true)
	}
```

- [ ] **Step 4: validate-before-apply restore 구현**

`restore_validation_runtime_snapshot()`은 모든 필수 key와 type을 local 변수로 검증한 뒤 `load_episode(DEFAULT_EPISODE_PATH)`를 호출하고 whitelist field만 적용한다. invalid episode·missing key·wrong type에서는 어떤 field도 변경하지 않는다. `load_episode()`가 resolution/recovery를 초기화하므로 관련 field 적용은 그 호출 뒤에 둔다.

Required result codes:

```text
OK
INVALID_EPISODE
INVALID_PAYLOAD
INCOMPATIBLE_CONTENT
```

- [ ] **Step 5: hidden-state guard snapshot 구현**

```gdscript
func snapshot_hidden_legacy_state_for_test() -> Dictionary:
	return {
		"campaign_state": campaign_state.to_save_data(), "seen_log_tutorial_ids": seen_log_tutorial_ids.duplicate(),
		"agent_trust": agent_trust.duplicate(true), "triggered_agent_event_ids": triggered_agent_event_ids.duplicate(), "used_agent_supports": used_agent_supports.duplicate(),
		"unlocked_records": unlocked_records.duplicate(), "unlocked_equipment": unlocked_equipment.duplicate(), "unlocked_research_rewards": unlocked_research_rewards.duplicate(),
		"equipped_items": equipped_items.duplicate(), "used_equipment_effects": used_equipment_effects.duplicate(),
		"completed_case_reports": completed_case_reports.duplicate(true), "anomaly_manual_records": anomaly_manual_records.duplicate(true),
		"completed_daily_episode_records": completed_daily_episode_records.duplicate(true), "active_daily_episode": active_daily_episode.duplicate(true),
		"echo_fragments": echo_fragments, "granted_reward_ids": granted_reward_ids.duplicate(),
		"faction_relations": faction_relations.duplicate(true), "triggered_faction_event_ids": triggered_faction_event_ids.duplicate(), "completed_faction_request_ids": completed_faction_request_ids.duplicate(),
		"purchased_market_item_ids": purchased_market_item_ids.duplicate(), "consumable_inventory": consumable_inventory.duplicate(true), "consumable_loadout": consumable_loadout.duplicate(true),
		"active_consumable_effects": active_consumable_effects.duplicate(true), "rewarded_resolution_grades": rewarded_resolution_grades.duplicate(true)
	}
```

이 snapshot은 guard·test evidence 전용이며 Validation payload에 넣지 않는다.

- [ ] **Step 6: GREEN 실행 후 commit**

Expected: `VALIDATION GAME STATE ADAPTER: PASS`, exit 0.

```bash
git add scripts/core/game_state.gd tests/validation/validation_game_state_adapter_test.gd
git commit -m "feat: add validation runtime whitelist adapter"
```

---

### Task 4: Autoload and Save Routing

**Files:**
- Modify: `project.godot`
- Modify: `scripts/core/game_state.gd`
- Create: `tests/validation/validation_save_isolation_test.gd`

- [ ] **Step 1: actual Autoload integration RED test 작성**

Test sequence:

```gdscript
GameState.reset_run_state()
_expect(GameState.save_game(), "inactive Legacy save should succeed")
var legacy_before := Support.read_bytes(GameState.get_save_file_path())
var hidden_before := GameState.snapshot_hidden_legacy_state_for_test()
var created := ValidationSession.create("episode_001_afterlife_station")
var token := String(created.get("session_token", ""))
_expect(ValidationSession.activate(token).get("code") == "OK", "session should activate")
ValidationSession.capture_legacy_guard(GameState)
GameState.add_flag("validation:integration-save")
_expect(GameState.save_game(), "active save should route to Validation")
_expect(Support.read_bytes(GameState.get_save_file_path()) == legacy_before, "Legacy bytes must not change")
_expect(Support.semantic_equal(GameState.snapshot_hidden_legacy_state_for_test(), hidden_before), "hidden state must not change")
_expect(FileAccess.file_exists(String(ValidationSession.get_repository_paths()["primary"])), "Validation primary should exist")
```

Fail-closed case:

```gdscript
var latest_legacy := Support.read_bytes(GameState.get_save_file_path())
ValidationSession.invalidate_token_for_test()
_expect(not GameState.save_game(), "invalid active session must fail")
_expect(Support.read_bytes(GameState.get_save_file_path()) == latest_legacy, "invalid active session must not fallback to Legacy")
```

Bidirectional case:

```gdscript
var validation_before := Support.read_bytes(String(ValidationSession.get_repository_paths()["primary"]))
ValidationSession.deactivate()
GameState.load_game()
GameState.clear_save_file()
_expect(Support.read_bytes(String(ValidationSession.get_repository_paths()["primary"])) == validation_before, "Legacy load/clear must preserve Validation bytes")
```

- [ ] **Step 2: RED 실행**

Expected: `ValidationSession` identifier 없음으로 실패.

- [ ] **Step 3: Autoload 순서 변경**

```ini
[autoload]

UrbanLegendState="*res://scripts/core/urban_legend_state.gd"
ValidationSession="*res://scripts/core/validation_session.gd"
GameState="*res://scripts/core/game_state.gd"
_mcp_game_helper="*res://addons/godot_ai/runtime/game_helper.gd"
```

Run `godot --headless --path . --import`; expected exit 0 and global-name conflict 없음.

- [ ] **Step 4: 기존 Legacy 저장 body를 private method로 이동하고 routing 추가**

```gdscript
func save_game() -> bool:
	if ValidationSession.requires_save_routing():
		var result := save_active_session()
		if not bool(result.get("ok", false)):
			push_error("Validation save failed: %s" % String(result.get("code", "UNKNOWN")))
		return bool(result.get("ok", false))
	return _save_legacy_game()

func save_active_session() -> Dictionary:
	if not ValidationSession.is_active_and_valid():
		return {"ok": false, "code": "SESSION_NOT_ACTIVE"}
	return ValidationSession.save(self)

func _save_legacy_game() -> bool:
	if current_episode_data.is_empty() and not load_episode(DEFAULT_EPISODE_PATH):
		return false
	var file := FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("Save file cannot be opened: %s" % SAVE_FILE_PATH)
		return false
	file.store_string(JSON.stringify(_make_save_data(), "\t"))
	return true
```

`load_game()`와 `clear_save_file()`은 Legacy-only 의미를 유지한다.

- [ ] **Step 5: GREEN 실행과 기존 Legacy regression 확인**

```bash
TEST_HOME="$(mktemp -d)"
HOME="$TEST_HOME" XDG_DATA_HOME="$TEST_HOME/.local/share" XDG_CONFIG_HOME="$TEST_HOME/.config" \
  godot --headless --path . --script res://tests/validation/validation_save_isolation_test.gd
TEST_HOME="$(mktemp -d)"
HOME="$TEST_HOME" XDG_DATA_HOME="$TEST_HOME/.local/share" XDG_CONFIG_HOME="$TEST_HOME/.config" \
  godot --headless --path . --scene res://tests/test_mvp037_campaign_state.tscn
```

Expected: `VALIDATION SAVE ISOLATION: PASS`, Legacy scene test exit 0.

- [ ] **Step 6: commit**

```bash
git add project.godot scripts/core/game_state.gd tests/validation/validation_save_isolation_test.gd
git commit -m "feat: route active validation saves safely"
```

---

### Task 5: Adversarial Matrix Completion

**Files:**
- Modify: four `tests/validation/*.gd`
- Modify: repository/session only when RED evidence requires.

- [ ] **Step 1: matrix cases 추가**

Required assertions:

```text
primary absent + temp present -> INTERRUPTED_WRITE, no auto promotion
primary absent + exact backup present -> RECOVERABLE_BACKUP, no auto promotion
corrupt primary -> preserved until explicit quarantine
newer primary -> inspect-only, no overwrite
hidden guard drift -> HIDDEN_STATE_GUARD_VIOLATION, neither file written
completed Session repeat -> ALREADY_COMPLETED, revision unchanged
abandon -> memory inactive, persistence retained
delete -> Validation primary/backup/temp only
Legacy clear -> Validation bytes unchanged
Validation delete -> Legacy bytes unchanged
```

- [ ] **Step 2: RED 실행**

각 test를 isolated HOME에서 직접 실행한다. 최소 한 assertion이 실패하지 않으면 새 case가 실제로 실패 조건을 공격하는지 검토한다.

- [ ] **Step 3: 최소 수정**

자동 복구 UI, overwrite dialog, main menu card, 본편 import를 추가하지 않는다. matrix를 통과시키는 repository/session/adapter 수정만 허용한다.

- [ ] **Step 4: 네 focused test 모두 GREEN 확인**

Expected:

```text
VALIDATION SAVE REPOSITORY: PASS
VALIDATION SESSION: PASS
VALIDATION GAME STATE ADAPTER: PASS
VALIDATION SAVE ISOLATION: PASS
```

- [ ] **Step 5: commit**

```bash
git add scripts/core/validation_save_repository.gd scripts/core/validation_session.gd scripts/core/game_state.gd tests/validation
git commit -m "test: close Package 1 isolation matrix"
```

---

### Task 6: Focused Runner, Full Regression and CI

**Files:**
- Create: `tests/run_validation_package_1_tests.sh`
- Modify: `tests/run_godot_regression.sh`
- Modify: `.github/workflows/validate-core-mvp-001.yml`
- Modify: `.github/workflows/validate-annual-mvp-001.yml`

- [ ] **Step 1: focused runner 작성**

```bash
#!/usr/bin/env bash
set -euo pipefail
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
GODOT_BIN="${GODOT_BIN:-godot}"
GODOT_TEST_TIMEOUT="${GODOT_TEST_TIMEOUT:-300}"
RUN_ROOT="${GODOT_TEST_TMP:-$(mktemp -d)}"
LOG_ROOT="$RUN_ROOT/validation-package-1-logs"
mkdir -p "$LOG_ROOT"
tests=(
  validation/validation_save_repository_test
  validation/validation_session_test
  validation/validation_game_state_adapter_test
  validation/validation_save_isolation_test
)
for test_name in "${tests[@]}"; do
  safe_name="${test_name//\//_}"
  home_dir="$RUN_ROOT/home/$safe_name"
  log_file="$LOG_ROOT/$safe_name.log"
  rm -rf "$home_dir"; mkdir -p "$home_dir"
  if ! HOME="$home_dir" XDG_DATA_HOME="$home_dir/.local/share" XDG_CONFIG_HOME="$home_dir/.config" GODOT_SILENCE_ROOT_WARNING=1 \
    timeout "$GODOT_TEST_TIMEOUT" "$GODOT_BIN" --headless --path "$PROJECT_ROOT" --script "res://tests/$test_name.gd" >"$log_file" 2>&1; then
    cat "$log_file"; echo "FAILED: $test_name" >&2; exit 1
  fi
  tail -n 12 "$log_file"
done
echo "Validation Package 1: 4/4 test entrypoints passed"
echo "Logs: $LOG_ROOT"
```

- [ ] **Step 2: full regression에 nested test 등록**

`script_tests`에 네 path를 추가한다. `run_test()`의 HOME/log 이름은 `safe_name="${name//\//_}"`를 사용한다. 최종 summary를 `Godot regression suite: 53/53 test entrypoints passed`로 변경한다.

- [ ] **Step 3: CORE workflow 연결**

Trigger paths:

```yaml
      - "project.godot"
      - "scripts/core/game_state.gd"
      - "scripts/core/validation_session.gd"
      - "scripts/core/validation_save_repository.gd"
      - "tests/validation/**"
      - "tests/run_validation_package_1_tests.sh"
```

Import 다음 step:

```yaml
      - name: Run focused Validation Package 1 tests
        env:
          GODOT_BIN: godot
          GODOT_TEST_TMP: ${{ runner.temp }}/validation-package-1-tests
        run: bash tests/run_validation_package_1_tests.sh
```

Failure artifact에 `${{ runner.temp }}/validation-package-1-tests/validation-package-1-logs`를 추가한다.

- [ ] **Step 4: ANNUAL workflow 연결**

Trigger에 `project.godot`, 세 core script path를 추가하고 같은 focused step·failure log path를 추가한다.

- [ ] **Step 5: shell·YAML parse와 전체 검증**

```bash
bash -n tests/run_validation_package_1_tests.sh
bash -n tests/run_godot_regression.sh
ruby -e 'require "yaml"; ARGV.each { |p| YAML.load_file(p); puts "YAML OK: #{p}" }' \
  .github/workflows/validate-core-mvp-001.yml \
  .github/workflows/validate-annual-mvp-001.yml
godot --headless --path . --import
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_validation_package_1_tests.sh
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_core_mvp_001_tests.sh
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_annual_mvp_001_tests.sh
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_annual_mvp_002_tests.sh
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_godot_regression.sh
```

Expected only after actual execution: focused 4/4, CORE exit 0, ANNUAL-001 exit 0, ANNUAL-002 exit 0, full 53/53.

- [ ] **Step 6: commit**

```bash
git add tests/run_validation_package_1_tests.sh tests/run_godot_regression.sh .github/workflows/validate-core-mvp-001.yml .github/workflows/validate-annual-mvp-001.yml
git commit -m "ci: validate Package 1 save isolation"
```

---

### Task 7: Evidence, Exact HEAD and Canon Sync

**Files:**
- Modify: `TEST_CHECKLIST.md`, `docs/CURRENT_STATUS.md`, `docs/CURRENT_HANDOFF_VALIDATION.md`.
- Modify: implementation PR, Issue #121, Google Sheet `00/01/02/04/99`.

- [ ] **Step 1: checklist에 실제 evidence field 추가**

```markdown
## Validation Package 1 — Session·Save Isolation
- [ ] Validation focused 4/4
- [ ] Legacy bytes unchanged during Validation create/save/load/delete/complete/corrupt inspection
- [ ] Hidden campaign/economy/relationship/faction/market snapshot unchanged
- [ ] Active invalid Session fails closed without Legacy fallback
- [ ] Inactive Legacy save/load/clear preserves existing behavior
- [ ] Corrupt/newer/interrupted/backup states remain non-destructive
- [ ] CORE focused
- [ ] ANNUAL-MVP-001 focused
- [ ] ANNUAL-MVP-002 focused
- [ ] Full Godot regression 53/53
- [ ] Runtime manual verification — NOT_RUN until separately authorized
- [ ] Human QA — NOT_RUN until separately authorized
```

실제 출력이 없는 row는 체크하지 않는다.

- [ ] **Step 2: forbidden surface audit**

```bash
git diff --name-status origin/main...HEAD
git diff --name-only origin/main...HEAD | grep -E '^(scripts/ui/main_menu.gd|scenes/main_menu.tscn|scripts/scenes/(preparation|result|dialogue|investigation|minigame|battle)_scene.gd|data/episodes/)' \
  && { echo "Package 2+ surface changed"; exit 1; } || true
```

- [ ] **Step 3: unresolved marker scan**

```bash
python - <<'PY'
import pathlib, subprocess, sys
markers = ["TO"+"DO", "T"+"BD", "FIX"+"ME", "implement "+"later", "fill in "+"details"]
paths = subprocess.check_output(["git", "diff", "--name-only", "origin/main...HEAD"], text=True).splitlines()
failed = False
for raw in paths:
    path = pathlib.Path(raw)
    if not path.is_file() or path.suffix in {".png", ".jpg", ".webp"}:
        continue
    text = path.read_text(encoding="utf-8", errors="ignore")
    for marker in markers:
        if marker in text:
            print(f"unresolved marker: {path}: {marker}")
            failed = True
sys.exit(1 if failed else 0)
PY
```

Expected: exit 0.

- [ ] **Step 4: status docs에 실제 결과 기록**

```yaml
package_1_implementation_head: <git rev-parse HEAD output>
validation_focused: PASS | FAIL | NOT_RUN
core_focused: PASS | FAIL | NOT_RUN
annual_001_focused: PASS | FAIL | NOT_RUN
annual_002_focused: PASS | FAIL | NOT_RUN
full_godot_regression: PASS_53_OF_53 | FAIL | NOT_RUN
legacy_file_guard: PASS | FAIL | NOT_RUN
legacy_memory_guard: PASS | FAIL | NOT_RUN
runtime: NOT_RUN
human_qa: NOT_RUN
```

Expected 결과를 실제 결과로 복사하지 않는다.

- [ ] **Step 5: docs commit·push·Draft PR**

```bash
git add TEST_CHECKLIST.md docs/CURRENT_STATUS.md docs/CURRENT_HANDOFF_VALIDATION.md
git commit -m "docs: record Package 1 isolation evidence"
git push -u origin agent/package-1-session-save-isolation
```

Implementation PR title: `feat: isolate Validation session and save state`.

PR body에는 parent Decision, persistence Decision, base SHA, exact head, file inventory, RED evidence, actual test results, guard evidence, Package 2+ exclusions, rollback, Runtime/Human 상태를 포함한다.

- [ ] **Step 6: exact-head CI 판정**

```bash
HEAD_SHA="$(git rev-parse HEAD)"
gh pr checks --watch
printf 'exact-head=%s\n' "$HEAD_SHA"
```

Required: CORE workflow success, ANNUAL workflow success, unresolved review thread 0, reviewed head와 current head 일치. 빈 combined status는 PASS로 해석하지 않는다.

- [ ] **Step 7: final adversarial re-review**

다음 공격을 exact diff에 적용한다.

```text
Validation repository가 Legacy path에 접근한다.
active invalid Session이 Legacy로 fallback한다.
whitelist에 campaign/economy/report/manual collection이 포함된다.
restore가 검증 전에 일부 runtime을 변경한다.
hidden state drift가 탐지되지 않는다.
corrupt/newer save가 삭제·덮어쓰기 된다.
Legacy clear가 Validation 파일을 삭제한다.
completion이 두 번 적용된다.
Package 2+ UI/content가 섞인다.
runner의 entrypoint count가 실제 배열과 다르다.
```

`MUST_FIX`는 수정 후 affected focused tests와 full 53-entry를 다시 실행하고 exact head를 갱신한다.

- [ ] **Step 8: 동일 Decision ID로 GitHub·Sheet 동기화**

Implementation Decision ID:

```text
D-2026-08-02-PACKAGE-1-SESSION-SAVE-ISOLATION-IMPLEMENTATION
```

반영 위치:

```text
docs/CURRENT_CONFIRMED_DECISIONS.md
docs/CURRENT_HANDOFF_VALIDATION.md
implementation PR body/comment
Issue #121
00_프로젝트_허브!E2:K2
01_작업순서 next empty row
02_현재_확정결정 next empty row
04_누락_충돌_감사 next empty row
99_변경이력 next empty row
```

각 Sheet range를 재조회한다. implementation PR 병합 전 상태는 `PENDING_MAIN`이다. sync commit 뒤 모든 exact-head 검증을 다시 실행한다.

---

## Rollback

```bash
git revert <sync-doc-commit>
git revert <ci-commit>
git revert <routing-commit>
git revert <adapter-commit>
git revert <session-commit>
git revert <repository-commit>
```

Rollback 후 import, CORE, ANNUAL-001, ANNUAL-002, full regression을 다시 실행한다. Validation primary/backup/temp만 명시적으로 정리할 수 있고 `user://urban_legend_save.json`은 삭제하지 않는다.

---

## Plan Self-Review

### Spec Coverage

| Requirement | Task |
|---|---|
| 별도 namespace·single slot·v1 | 1 |
| atomic write·backup·corrupt/version matrix | 1, 5 |
| explicit activation·lifecycle·completion idempotency | 2, 5 |
| field-level whitelist | 3 |
| Legacy file+memory no-effect | 3-5 |
| fail-closed save routing | 4-5 |
| CORE·ANNUAL·53-entry regression | 6 |
| rollback·exact-head·Decision sync | 7 |

### Signature Consistency

- Repository와 Session result는 `ok: bool`, `code: String` Dictionary다.
- 기존 caller 호환을 위해 `GameState.save_game()`은 bool을 유지한다.
- detailed error는 `save_active_session()`과 Session API가 소유한다.
- export/restore/test에서 runtime snapshot key 이름을 동일하게 사용한다.
- Autoload `ValidationSession`과 script 전역 class 이름은 충돌하지 않는다.
- runner의 test path와 생성 파일 path가 일치한다.
- 기존 49 + 신규 4 = full 53-entry다.

### Scope Check

main menu, preparation/result, episode JSON, minigame, battle, result calculator, mobile, Legacy migration schema, ANNUAL product state를 변경하지 않는다. workflow 변경은 승인된 Package 1 test와 기존 regression 실행에만 사용한다.

### Current Gate

```text
Implementation Plan = REVIEW_READY
Product implementation = NOT_AUTHORIZED
PR #125 merge = NOT_REQUESTED
Runtime/CI/Human = NOT_RUN
```

실행은 사용자의 `Package 1 구현 승인` 뒤에만 시작한다.