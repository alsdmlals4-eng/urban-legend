# Validation Session·Save Isolation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Validation 진행·완료 기록을 `user://urban_legend_validation_save.json`에 독립 저장하면서 기존 `mvp-039` Legacy 파일과 campaign·economy·relationship·faction·market 메모리를 변경하지 않는 Package 1 기반을 구현한다.

**Architecture:** `ValidationSession` Autoload가 mode·lifecycle·stage·checkpoint·runtime snapshot·apply-once ledger를 소유하고, `ValidationSaveRepository`가 별도 파일의 검사·원자적 저장·정상 백업 1세대·손상 격리를 소유한다. `GameState`는 기존 Legacy 권위를 유지하며 field-level whitelist export/restore와 active-session save routing만 제공한다. Validation 경로가 유효하지 않으면 어느 저장에도 쓰지 않는 fail-closed를 적용한다.

**Tech Stack:** Godot 4.7.1, GDScript, SceneTree headless tests, Bash test runners, GitHub Actions, JSON save files.

## Global Constraints

- 기준 제품 main: `7277b9cececa56532f7b0d11c1a02fd3d5642750`.
- 승인 Spec: `docs/superpowers/specs/2026-08-02-validation-session-save-isolation-design.md`.
- 승인 Decision: `D-2026-08-02-PACKAGE-1-DESIGN-SPEC-APPROVAL`.
- Persistence Decision: `D-2026-08-02-VALIDATION-PERSISTENCE-BOUNDARY`.
- Validation save: `user://urban_legend_validation_save.json`.
- Legacy save: `user://urban_legend_save.json`; Validation repository에서 read/write/delete 금지.
- Validation slot: 1개.
- Validation version: `validation-save-v1`.
- 정상 backup: 1세대.
- corrupt·incompatible 저장: 자동 삭제·자동 downgrade·자동 primary 승격 금지.
- active invalid Session: Validation과 Legacy 양쪽 저장 금지.
- inactive Session: 기존 `GameState.save_game()`, `load_game()`, `clear_save_file()` 의미 유지.
- Legacy file bytes와 campaign·economy·relationship·faction·market 메모리 모두 무변경.
- Package 1은 main menu UI, 준비·Reasoning·결과 Scene, episode JSON, route/recovery adapter를 변경하지 않는다.
- `ValidationSession` Autoload는 `GameState`보다 먼저 등록한다.
- Autoload 이름 충돌을 피하기 위해 `scripts/core/validation_session.gd`에는 `class_name ValidationSession`을 선언하지 않는다.
- 각 Task는 RED 확인, 최소 GREEN, focused test, 커밋으로 닫는다.
- 구현과 무관한 리팩터링은 이 계획에 포함하지 않는다.
- Runtime·CI·Human 결과는 실제 실행 전까지 `NOT_RUN`이다.

---

## Execution Precondition

기본 실행 경로:

```bash
# PR #125가 병합된 뒤 실행한다.
git fetch origin
git switch main
git pull --ff-only origin main
BASE_SHA="$(git rev-parse HEAD)"
test "$BASE_SHA" != "7277b9cececa56532f7b0d11c1a02fd3d5642750" || true

# REQUIRED SUB-SKILL: superpowers:using-git-worktrees
mkdir -p .worktrees
git worktree add .worktrees/package-1-session-save-isolation -b agent/package-1-session-save-isolation main
cd .worktrees/package-1-session-save-isolation
```

PR #125 병합 전에 별도 구현 승인이 내려진 경우에만 stacked 경로를 사용한다.

```bash
git fetch origin agent/v9-4-canon-reconciliation
git worktree add .worktrees/package-1-session-save-isolation \
  -b agent/package-1-session-save-isolation \
  origin/agent/v9-4-canon-reconciliation
```

이 경우 구현 PR base는 `agent/v9-4-canon-reconciliation`이며, PR #125 병합 뒤 최신 `main`으로 rebase하고 base를 `main`으로 retarget한다. PR #125 브랜치에 제품 코드를 직접 추가하지 않는다.

## Baseline Verification

- [ ] **Step 1: 기록할 baseline SHA와 작업 상태 확인**

Run:

```bash
git status --short
git rev-parse HEAD
git merge-base HEAD origin/main
git diff --name-only origin/main...HEAD
```

Expected:

```text
작업 트리 clean
실행 branch의 parent가 승인된 문서 정본 HEAD 또는 최신 main
제품 변경 없음
```

- [ ] **Step 2: 기존 Godot import와 회귀 기준 확인**

Run:

```bash
godot --headless --path . --import
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_core_mvp_001_tests.sh
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_annual_mvp_001_tests.sh
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_annual_mvp_002_tests.sh
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_godot_regression.sh
```

Expected:

```text
Godot import exit 0
기존 focused suites exit 0
Godot regression suite: 49/49 test entrypoints passed
```

기존 baseline이 실패하면 Package 1 코드를 작성하지 않고 실패 로그와 exact SHA를 기록한다.

---

## File Responsibility Map

### Create

- `scripts/core/validation_save_repository.gd` — Validation 파일 경로, 검사, 버전 판정, temp/readback/replace, backup, quarantine, 삭제.
- `scripts/core/validation_session.gd` — Session mode·lifecycle·token·snapshot·ledger, repository 조정, fail-closed 활성화.
- `tests/validation/validation_test_support.gd` — 격리 경로 정리, raw bytes, semantic equality, JSON fixture 작성.
- `tests/validation/validation_save_repository_test.gd` — 경로 분리, inspect, atomic write, backup, corrupt/incompatible/interrupted matrix.
- `tests/validation/validation_session_test.gd` — create/activate/save/load/suspend/resume/complete/abandon/delete lifecycle.
- `tests/validation/validation_game_state_adapter_test.gd` — whitelist export/restore, excluded fields, hidden-state snapshot 무변경.
- `tests/validation/validation_save_isolation_test.gd` — 실제 Autoload와 `GameState.save_game()` routing, Legacy bytes·memory no-effect, fail-closed.
- `tests/run_validation_package_1_tests.sh` — 네 focused test를 각각 격리 HOME에서 실행.

### Modify

- `project.godot:17-23` — `ValidationSession`을 `GameState`보다 앞에 Autoload 등록.
- `scripts/core/game_state.gd:1-170` — Validation 허용 episode·flag helper 상수/함수 추가 위치.
- `scripts/core/game_state.gd:2750-2990` — Legacy save 구현 분리, active-session routing, whitelist export/restore, hidden guard snapshot.
- `tests/run_godot_regression.sh:11-58,91-92` — 네 Package 1 test 등록, 총 진입점 53개로 갱신.
- `.github/workflows/validate-core-mvp-001.yml:3-61` — Package 1 경로 trigger·focused step·failure logs 추가.
- `.github/workflows/validate-annual-mvp-001.yml:3-81` — core 변경 trigger·focused step·failure logs 추가.
- `TEST_CHECKLIST.md` — Package 1 save isolation 자동 검증과 미실행 Human 항목 기록.
- `docs/CURRENT_STATUS.md` — 실제 구현·테스트 결과만 증거와 함께 갱신.
- `docs/CURRENT_HANDOFF_VALIDATION.md` — exact implementation HEAD, test evidence, 다음 Package gate.

---

### Task 1: Validation Test Support and Repository Inspection

**Files:**
- Create: `tests/validation/validation_test_support.gd`
- Create: `tests/validation/validation_save_repository_test.gd`
- Create: `scripts/core/validation_save_repository.gd`

**Interfaces:**
- Consumes: Godot `FileAccess`, `DirAccess`, `JSON`, `ProjectSettings.globalize_path`.
- Produces: `ValidationSaveRepository.new(primary_path)`, `inspect()`, `read_payload()`, `get_paths()`, result dictionaries with `ok` and `code`.

- [ ] **Step 1: Create test support helper**

Create `tests/validation/validation_test_support.gd`:

```gdscript
class_name ValidationTestSupport
extends RefCounted

static func read_bytes(path: String) -> PackedByteArray:
	if not FileAccess.file_exists(path):
		return PackedByteArray()
	return FileAccess.get_file_as_bytes(path)

static func write_text(path: String, text: String) -> Error:
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		return FileAccess.get_open_error()
	file.store_string(text)
	file.flush()
	file.close()
	return OK

static func remove_path(path: String) -> void:
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(path))

static func remove_repository_paths(paths: Dictionary) -> void:
	for key in ["primary", "backup", "temp"]:
		remove_path(String(paths.get(key, "")))

static func semantic_equal(left: Variant, right: Variant) -> bool:
	var left_type := typeof(left)
	var right_type := typeof(right)
	if left_type in [TYPE_INT, TYPE_FLOAT] and right_type in [TYPE_INT, TYPE_FLOAT]:
		return is_equal_approx(float(left), float(right))
	if left_type == TYPE_DICTIONARY and right_type == TYPE_DICTIONARY:
		var left_dict := left as Dictionary
		var right_dict := right as Dictionary
		if left_dict.size() != right_dict.size():
			return false
		for key in left_dict.keys():
			if not right_dict.has(key) or not semantic_equal(left_dict[key], right_dict[key]):
				return false
		return true
	if left_type == TYPE_ARRAY and right_type == TYPE_ARRAY:
		var left_array := left as Array
		var right_array := right as Array
		if left_array.size() != right_array.size():
			return false
		for index in range(left_array.size()):
			if not semantic_equal(left_array[index], right_array[index]):
				return false
		return true
	return left == right
```

- [ ] **Step 2: Write failing repository inspection test**

Create `tests/validation/validation_save_repository_test.gd` with the first RED cases:

```gdscript
extends SceneTree

const Repository = preload("res://scripts/core/validation_save_repository.gd")
const Support = preload("res://tests/validation/validation_test_support.gd")

const TEST_PRIMARY := "user://validation_package_1_repository_test.json"
const LEGACY_PATH := "user://urban_legend_save.json"

var _failures: Array[String] = []

func _init() -> void:
	var repository = Repository.new(TEST_PRIMARY)
	var paths: Dictionary = repository.get_paths()
	Support.remove_repository_paths(paths)

	_expect(String(paths["primary"]) == TEST_PRIMARY, "primary path should use injected test path")
	_expect(String(paths["primary"]) != LEGACY_PATH, "validation primary must differ from Legacy path")
	_expect(String(paths["backup"]).ends_with(".bak.json"), "backup path should use .bak.json")
	_expect(String(paths["temp"]).ends_with(".tmp.json"), "temp path should use .tmp.json")
	_expect(String(paths["quarantine_prefix"]).contains(".corrupt."), "quarantine prefix should be explicit")

	var inspection: Dictionary = repository.inspect()
	_expect(inspection.get("code") == "EMPTY", "missing repository should inspect as EMPTY")
	_expect(not bool(inspection.get("ok", true)), "EMPTY should not be loadable")

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

- [ ] **Step 3: Run RED test**

Run:

```bash
TEST_HOME="$(mktemp -d)"
HOME="$TEST_HOME" XDG_DATA_HOME="$TEST_HOME/.local/share" XDG_CONFIG_HOME="$TEST_HOME/.config" \
  godot --headless --path . --script res://tests/validation/validation_save_repository_test.gd
```

Expected:

```text
FAIL: preload cannot resolve res://scripts/core/validation_save_repository.gd
```

- [ ] **Step 4: Implement minimal repository identity and inspection**

Create `scripts/core/validation_save_repository.gd`:

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
	var stem := primary_path
	if stem.ends_with(".json"):
		stem = stem.substr(0, stem.length() - 5)
	_backup_path = "%s.bak.json" % stem
	_temp_path = "%s.tmp.json" % stem
	_quarantine_prefix = "%s.corrupt." % stem

func get_paths() -> Dictionary:
	return {
		"primary": _primary_path,
		"backup": _backup_path,
		"temp": _temp_path,
		"quarantine_prefix": _quarantine_prefix,
		"legacy_forbidden": LEGACY_FORBIDDEN_PATH
	}

func inspect() -> Dictionary:
	if _primary_path == LEGACY_FORBIDDEN_PATH:
		return _result(false, "LEGACY_GUARD_VIOLATION")
	if not FileAccess.file_exists(_primary_path):
		if FileAccess.file_exists(_temp_path):
			return _result(false, "INTERRUPTED_WRITE")
		if FileAccess.file_exists(_backup_path):
			return _result(false, "RECOVERABLE_BACKUP")
		return _result(false, "EMPTY")
	return _inspect_path(_primary_path)

func read_payload() -> Dictionary:
	var inspection := inspect()
	if inspection.get("code") != "EXACT":
		return inspection
	return inspection

func _inspect_path(path: String) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return _result(false, "READ_FAILED", {"error": FileAccess.get_open_error()})
	var raw := file.get_as_text()
	file.close()
	var parsed: Variant = JSON.parse_string(raw)
	if typeof(parsed) != TYPE_DICTIONARY:
		return _result(false, "CORRUPT_JSON")
	var payload := parsed as Dictionary
	if String(payload.get("format", "")) != FORMAT_ID:
		return _result(false, "CORRUPT_SCHEMA")
	var version_result := _classify_version(String(payload.get("version", "")))
	if version_result != "EXACT":
		return _result(false, version_result, {"payload": payload.duplicate(true)})
	if int(payload.get("payload_schema", 0)) != PAYLOAD_SCHEMA:
		return _result(false, "CORRUPT_SCHEMA")
	if typeof(payload.get("session")) != TYPE_DICTIONARY:
		return _result(false, "CORRUPT_SCHEMA")
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
	var number := int(number_text)
	if number < 1:
		return "INCOMPATIBLE_OLDER"
	return "INCOMPATIBLE_NEWER"

func _result(ok: bool, code: String, details: Dictionary = {}) -> Dictionary:
	var result := {"ok": ok, "code": code}
	for key in details.keys():
		result[key] = details[key]
	return result
```

- [ ] **Step 5: Run GREEN test**

Run the same direct Godot command.

Expected:

```text
VALIDATION SAVE REPOSITORY: PASS
exit 0
```

- [ ] **Step 6: Commit Task 1**

```bash
git add scripts/core/validation_save_repository.gd \
  tests/validation/validation_test_support.gd \
  tests/validation/validation_save_repository_test.gd
git commit -m "test: define validation save repository boundary"
```

---

### Task 2: Atomic Write, Backup, Corrupt and Version Matrix

**Files:**
- Modify: `scripts/core/validation_save_repository.gd`
- Modify: `tests/validation/validation_save_repository_test.gd`

**Interfaces:**
- Consumes: Task 1 repository paths and inspection result shape.
- Produces: `write_payload(payload)`, `delete_persistence()`, `quarantine_primary(reason)`, exact readback, backup recovery inspection.

- [ ] **Step 1: Add RED fixtures and assertions**

Add this payload helper to the repository test:

```gdscript
func _make_payload(revision: int = 1, version: String = "validation-save-v1") -> Dictionary:
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
		"snapshots": {
			"runtime": {},
			"preparation": {},
			"reasoning": {},
			"route": {},
			"recovery": {}
		},
		"result": {
			"axes": {},
			"candidate_records": {},
			"applied_effect_ids": {}
		},
		"timestamps": {
			"created_at_utc": "2026-08-02T02:20:00Z",
			"updated_at_utc": "2026-08-02T02:20:00Z",
			"completed_at_utc": ""
		},
		"integrity": {
			"content_episode_id": "episode_001_afterlife_station"
		}
	}
```

Add these assertions before cleanup:

```gdscript
var first_payload := _make_payload(1)
var first_write: Dictionary = repository.write_payload(first_payload)
_expect(first_write.get("code") == "OK", "first payload should write")
_expect(repository.inspect().get("code") == "EXACT", "written primary should inspect exact")
_expect(Support.semantic_equal(repository.read_payload().get("payload", {}), first_payload), "readback should equal first payload")

var second_payload := _make_payload(2)
var second_write: Dictionary = repository.write_payload(second_payload)
_expect(second_write.get("code") == "OK", "second payload should replace primary")
_expect(FileAccess.file_exists(String(paths["backup"])), "second write should preserve one normal backup")

var backup_repository = Repository.new(String(paths["backup"]))
_expect(backup_repository.inspect().get("code") == "EXACT", "backup should contain previous exact payload")
_expect(int(backup_repository.read_payload().get("payload", {}).get("revision", -1)) == 1, "backup should preserve revision one")

Support.write_text(String(paths["primary"]), "{broken-json")
var corrupt: Dictionary = repository.inspect()
_expect(corrupt.get("code") == "CORRUPT_JSON", "parse failure should classify CORRUPT_JSON")
_expect(FileAccess.file_exists(String(paths["primary"])), "corrupt primary must not be auto deleted")

var quarantine: Dictionary = repository.quarantine_primary("parse-failure")
_expect(quarantine.get("code") == "OK", "explicit quarantine should succeed")
_expect(not FileAccess.file_exists(String(paths["primary"])), "quarantine should move the primary")
_expect(FileAccess.file_exists(String(quarantine.get("quarantine_path", ""))), "quarantine path should preserve original bytes")

Support.write_text(String(paths["primary"]), JSON.stringify(_make_payload(3, "validation-save-v2")))
_expect(repository.inspect().get("code") == "INCOMPATIBLE_NEWER", "v2 should be inspect-only newer save")
_expect(repository.write_payload(_make_payload(4)).get("code") == "INCOMPATIBLE_NEWER", "newer primary must not be overwritten")

Support.remove_path(String(paths["primary"]))
Support.write_text(String(paths["temp"]), JSON.stringify(_make_payload(5)))
_expect(repository.inspect().get("code") == "INTERRUPTED_WRITE", "temp-only state should not auto promote")
```

- [ ] **Step 2: Run RED test**

Run the Task 1 direct Godot command.

Expected:

```text
FAIL: write_payload, quarantine_primary, or delete_persistence is missing
```

- [ ] **Step 3: Implement exact payload validation and atomic-ish replacement**

Add to `validation_save_repository.gd`:

```gdscript
func write_payload(payload: Dictionary) -> Dictionary:
	if _primary_path == LEGACY_FORBIDDEN_PATH:
		return _result(false, "LEGACY_GUARD_VIOLATION")
	var validation := _validate_payload(payload)
	if validation.get("code") != "EXACT":
		return validation

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

	var temp_validation := _inspect_path(_temp_path)
	if temp_validation.get("code") != "EXACT":
		return _result(false, "VERIFY_FAILED")

	var absolute_primary := ProjectSettings.globalize_path(_primary_path)
	var absolute_backup := ProjectSettings.globalize_path(_backup_path)
	var absolute_temp := ProjectSettings.globalize_path(_temp_path)
	if FileAccess.file_exists(_primary_path):
		if FileAccess.file_exists(_backup_path):
			var remove_backup := DirAccess.remove_absolute(absolute_backup)
			if remove_backup != OK:
				return _result(false, "REPLACE_FAILED", {"error": remove_backup})
		var backup_error := DirAccess.rename_absolute(absolute_primary, absolute_backup)
		if backup_error != OK:
			return _result(false, "REPLACE_FAILED", {"error": backup_error})

	var replace_error := DirAccess.rename_absolute(absolute_temp, absolute_primary)
	if replace_error != OK:
		if FileAccess.file_exists(_backup_path) and not FileAccess.file_exists(_primary_path):
			DirAccess.rename_absolute(absolute_backup, absolute_primary)
		return _result(false, "REPLACE_FAILED", {"error": replace_error})

	var primary_validation := _inspect_path(_primary_path)
	if primary_validation.get("code") != "EXACT":
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
	var inspection := inspect()
	if inspection.get("code") not in ["CORRUPT_JSON", "CORRUPT_SCHEMA"]:
		return _result(false, "INVALID_LIFECYCLE")
	var stamp := Time.get_datetime_string_from_system(true, true).replace(":", "-")
	var quarantine_path := "%s%s.%s.json" % [_quarantine_prefix, stamp, reason.validate_filename()]
	var error := DirAccess.rename_absolute(
		ProjectSettings.globalize_path(_primary_path),
		ProjectSettings.globalize_path(quarantine_path)
	)
	if error != OK:
		return _result(false, "REPLACE_FAILED", {"error": error})
	return _result(true, "OK", {"quarantine_path": quarantine_path})

func _validate_payload(payload: Dictionary) -> Dictionary:
	if String(payload.get("format", "")) != FORMAT_ID:
		return _result(false, "CORRUPT_SCHEMA")
	var version_result := _classify_version(String(payload.get("version", "")))
	if version_result != "EXACT":
		return _result(false, version_result)
	if int(payload.get("payload_schema", 0)) != PAYLOAD_SCHEMA:
		return _result(false, "CORRUPT_SCHEMA")
	if int(payload.get("revision", -1)) < 0:
		return _result(false, "CORRUPT_SCHEMA")
	for required_key in ["session", "snapshots", "result", "timestamps", "integrity"]:
		if typeof(payload.get(required_key)) != TYPE_DICTIONARY:
			return _result(false, "CORRUPT_SCHEMA", {"field": required_key})
	return _result(true, "EXACT", {"payload": payload.duplicate(true)})
```

Change `_inspect_path()` to call `_validate_payload(payload)` and attach the parsed payload only when the validation code is `EXACT`.

- [ ] **Step 4: Run GREEN repository test**

Expected:

```text
VALIDATION SAVE REPOSITORY: PASS
exit 0
```

- [ ] **Step 5: Commit Task 2**

```bash
git add scripts/core/validation_save_repository.gd tests/validation/validation_save_repository_test.gd
git commit -m "feat: add atomic validation save repository"
```

---

### Task 3: Validation Session Lifecycle

**Files:**
- Create: `scripts/core/validation_session.gd`
- Create: `tests/validation/validation_session_test.gd`

**Interfaces:**
- Consumes: `ValidationSaveRepository` from Task 2.
- Produces: Session `create`, `activate`, `save`, `load`, `suspend`, `resume`, `complete`, `abandon_runtime`, `delete_persistence`, `deactivate`, `requires_save_routing`, `is_active_and_valid`.

- [ ] **Step 1: Write failing lifecycle test with a fake GameState**

Create `tests/validation/validation_session_test.gd`:

```gdscript
extends SceneTree

const SessionScript = preload("res://scripts/core/validation_session.gd")
const Support = preload("res://tests/validation/validation_test_support.gd")

const TEST_PRIMARY := "user://validation_package_1_session_test.json"

var _failures: Array[String] = []

class FakeGameState:
	extends RefCounted
	var runtime := {
		"episode_id": "episode_001_afterlife_station",
		"episode_path": "res://data/episodes/episode_001_afterlife_station.json",
		"dialogue_node_id": "dialogue_intro",
		"field_node_id": "dialogue_intro",
		"minigame_id": "minigame_frequency_sync",
		"selected_agent_ids": ["agent_kwon_narae"],
		"flags": [],
		"collected_clue_ids": [],
		"seen_hint_ids": [],
		"method_results": {},
		"minigame_results": {},
		"resolution": {},
		"recovery": {},
		"agent_case_states": {},
		"victim_state": {}
	}
	var hidden := {"echo_fragments": 30, "campaign_state": {"week": 1}}

	func export_validation_runtime_snapshot() -> Dictionary:
		return runtime.duplicate(true)

	func restore_validation_runtime_snapshot(snapshot: Dictionary) -> Dictionary:
		runtime = snapshot.duplicate(true)
		return {"ok": true, "code": "OK"}

	func snapshot_hidden_legacy_state_for_test() -> Dictionary:
		return hidden.duplicate(true)

func _init() -> void:
	var session = SessionScript.new()
	session.configure_repository_path_for_test(TEST_PRIMARY)
	Support.remove_repository_paths(session.get_repository_paths())
	var game_state := FakeGameState.new()

	var created: Dictionary = session.create("episode_001_afterlife_station")
	_expect(created.get("code") == "OK", "create should succeed")
	var token := String(created.get("session_token", ""))
	_expect(not token.is_empty(), "create should generate token")
	_expect(not session.requires_save_routing(), "created but inactive session should not route")

	_expect(session.activate("wrong-token").get("code") == "SESSION_TOKEN_MISMATCH", "wrong token should fail closed")
	_expect(session.activate(token).get("code") == "OK", "correct token should activate")
	_expect(session.requires_save_routing(), "active session should require routing")
	_expect(session.is_active_and_valid(), "active session should validate")

	var saved: Dictionary = session.save(game_state)
	_expect(saved.get("code") == "OK", "active session should save")
	_expect(int(session.get_revision()) == 1, "first save should increment revision")

	_expect(session.suspend().get("code") == "OK", "active session should suspend")
	_expect(not session.is_active_and_valid(), "suspended session should not be active")
	_expect(session.resume(game_state).get("code") == "OK", "suspended session should resume")

	var completed: Dictionary = session.complete({"effect_id": "validation:afterlife:completion:v1"}, game_state)
	_expect(completed.get("code") == "OK", "completion should persist once")
	_expect(session.complete({"effect_id": "validation:afterlife:completion:v1"}, game_state).get("code") == "ALREADY_COMPLETED", "repeat completion should be idempotent")

	_expect(session.abandon_runtime().get("code") == "OK", "abandon should clear memory mode")
	_expect(FileAccess.file_exists(TEST_PRIMARY), "abandon should retain persistence")
	_expect(session.load(game_state).get("code") == "OK", "completed save should load")
	_expect(session.deactivate().get("code") == "OK", "deactivate should leave persistence")
	_expect(session.delete_persistence().get("code") == "OK", "inactive session should delete Validation persistence")
	_expect(not FileAccess.file_exists(TEST_PRIMARY), "delete should remove Validation primary")

	Support.remove_repository_paths(session.get_repository_paths())
	_finish()

func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)

func _finish() -> void:
	if _failures.is_empty():
		print("VALIDATION SESSION: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
```

- [ ] **Step 2: Run RED session test**

Run:

```bash
TEST_HOME="$(mktemp -d)"
HOME="$TEST_HOME" XDG_DATA_HOME="$TEST_HOME/.local/share" XDG_CONFIG_HOME="$TEST_HOME/.config" \
  godot --headless --path . --script res://tests/validation/validation_session_test.gd
```

Expected:

```text
FAIL: preload cannot resolve res://scripts/core/validation_session.gd
```

- [ ] **Step 3: Implement Session state and lifecycle**

Create `scripts/core/validation_session.gd` without a `class_name` declaration:

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
	if _mode != MODE_INACTIVE:
		return
	_repository = RepositoryScript.new(path)

func get_repository_paths() -> Dictionary:
	return _repository.get_paths()

func get_revision() -> int:
	return _revision

func requires_save_routing() -> bool:
	return _mode == MODE_VALIDATION

func is_active_and_valid() -> bool:
	return (
		_mode == MODE_VALIDATION
		and _lifecycle == LIFECYCLE_ACTIVE
		and not _session_token.is_empty()
		and ALLOWED_EPISODES.has(_episode_id)
	)

func create(episode_id: String) -> Dictionary:
	if not ALLOWED_EPISODES.has(episode_id):
		return _result(false, "INVALID_EPISODE")
	if _repository.inspect().get("code") != "EMPTY":
		return _result(false, "ALREADY_EXISTS")
	_reset_state()
	_episode_id = episode_id
	_lifecycle = LIFECYCLE_ACTIVE
	_session_token = Crypto.new().generate_random_bytes(16).hex_encode()
	_created_at_utc = Time.get_datetime_string_from_system(true, true)
	_updated_at_utc = _created_at_utc
	return _result(true, "OK", {"session_token": _session_token})

func activate(session_token: String) -> Dictionary:
	if _mode == MODE_VALIDATION:
		return _result(false, "SESSION_ALREADY_ACTIVE")
	if _lifecycle not in [LIFECYCLE_ACTIVE, LIFECYCLE_SUSPENDED, LIFECYCLE_COMPLETED]:
		return _result(false, "INVALID_LIFECYCLE")
	if session_token != _session_token:
		return _result(false, "SESSION_TOKEN_MISMATCH")
	if not ALLOWED_EPISODES.has(_episode_id):
		return _result(false, "INVALID_EPISODE")
	_mode = MODE_VALIDATION
	return _result(true, "OK")

func save(game_state: Object) -> Dictionary:
	if not is_active_and_valid():
		return _result(false, "SESSION_NOT_ACTIVE")
	var guard := _verify_hidden_guard(game_state)
	if guard.get("code") != "OK":
		return guard
	_runtime_snapshot = game_state.export_validation_runtime_snapshot()
	_revision += 1
	_updated_at_utc = Time.get_datetime_string_from_system(true, true)
	return _repository.write_payload(_build_payload())

func load(game_state: Object) -> Dictionary:
	var read_result := _repository.read_payload()
	if read_result.get("code") != "EXACT":
		return read_result
	var payload := read_result.get("payload", {}) as Dictionary
	var apply_result := _apply_payload(payload)
	if apply_result.get("code") != "OK":
		return apply_result
	var hidden_before: Dictionary = game_state.snapshot_hidden_legacy_state_for_test()
	var restore_result: Dictionary = game_state.restore_validation_runtime_snapshot(_runtime_snapshot)
	if restore_result.get("code") != "OK":
		return _result(false, "RESTORE_FAILED")
	var hidden_after: Dictionary = game_state.snapshot_hidden_legacy_state_for_test()
	if hidden_before != hidden_after:
		return _result(false, "HIDDEN_STATE_GUARD_VIOLATION")
	_legacy_guard_snapshot = hidden_after.duplicate(true)
	_mode = MODE_VALIDATION
	return _result(true, "OK")

func suspend() -> Dictionary:
	if not is_active_and_valid():
		return _result(false, "SESSION_NOT_ACTIVE")
	_lifecycle = LIFECYCLE_SUSPENDED
	_mode = MODE_INACTIVE
	return _result(true, "OK")

func resume(game_state: Object) -> Dictionary:
	if _lifecycle != LIFECYCLE_SUSPENDED:
		return _result(false, "INVALID_LIFECYCLE")
	_lifecycle = LIFECYCLE_ACTIVE
	_mode = MODE_VALIDATION
	_legacy_guard_snapshot = game_state.snapshot_hidden_legacy_state_for_test()
	return _result(true, "OK")

func complete(completion_payload: Dictionary, game_state: Object) -> Dictionary:
	if _lifecycle == LIFECYCLE_COMPLETED:
		return _result(false, "ALREADY_COMPLETED")
	if not is_active_and_valid():
		return _result(false, "SESSION_NOT_ACTIVE")
	if String(completion_payload.get("effect_id", "")) != COMPLETION_EFFECT_ID:
		return _result(false, "INVALID_PAYLOAD")
	_applied_effect_ids[COMPLETION_EFFECT_ID] = true
	_lifecycle = LIFECYCLE_COMPLETED
	_completed_at_utc = Time.get_datetime_string_from_system(true, true)
	_runtime_snapshot = game_state.export_validation_runtime_snapshot()
	_revision += 1
	_updated_at_utc = _completed_at_utc
	return _repository.write_payload(_build_payload())

func abandon_runtime() -> Dictionary:
	_mode = MODE_INACTIVE
	_reset_state(false)
	return _result(true, "OK")

func delete_persistence() -> Dictionary:
	if _mode == MODE_VALIDATION:
		return _result(false, "INVALID_LIFECYCLE")
	var deleted := _repository.delete_persistence()
	if deleted.get("code") == "OK":
		_reset_state()
	return deleted

func deactivate() -> Dictionary:
	_mode = MODE_INACTIVE
	_legacy_guard_snapshot.clear()
	return _result(true, "OK")
```

Continue the file with exact `_build_payload`, `_apply_payload`, `_verify_hidden_guard`, `_reset_state`, and `_result` helpers. `_build_payload()` must emit the Spec’s top-level keys exactly. `_apply_payload()` must validate all required keys and assign to temporary local values before mutating Session fields.

Use this hidden guard implementation:

```gdscript
func capture_legacy_guard(game_state: Object) -> Dictionary:
	_legacy_guard_snapshot = game_state.snapshot_hidden_legacy_state_for_test()
	return _result(true, "OK")

func _verify_hidden_guard(game_state: Object) -> Dictionary:
	var current: Dictionary = game_state.snapshot_hidden_legacy_state_for_test()
	if _legacy_guard_snapshot.is_empty():
		_legacy_guard_snapshot = current.duplicate(true)
		return _result(true, "OK")
	if current != _legacy_guard_snapshot:
		return _result(false, "HIDDEN_STATE_GUARD_VIOLATION")
	return _result(true, "OK")
```

- [ ] **Step 4: Run GREEN session test**

Expected:

```text
VALIDATION SESSION: PASS
exit 0
```

- [ ] **Step 5: Commit Task 3**

```bash
git add scripts/core/validation_session.gd tests/validation/validation_session_test.gd
git commit -m "feat: add validation session lifecycle"
```

---

### Task 4: GameState Whitelist Adapter and Hidden-State Guard Snapshot

**Files:**
- Create: `tests/validation/validation_game_state_adapter_test.gd`
- Modify: `scripts/core/game_state.gd`

**Interfaces:**
- Consumes: current `GameState` fields and getters.
- Produces: `export_validation_runtime_snapshot()`, `restore_validation_runtime_snapshot(snapshot)`, `snapshot_hidden_legacy_state_for_test()`.

- [ ] **Step 1: Write RED adapter test**

Create `tests/validation/validation_game_state_adapter_test.gd`:

```gdscript
extends SceneTree

const GameStateScript = preload("res://scripts/core/game_state.gd")
const Support = preload("res://tests/validation/validation_test_support.gd")

var _failures: Array[String] = []

func _init() -> void:
	var state = GameStateScript.new()
	root.add_child(state)
	state.reset_run_state()
	state.set_current_scene_path(state.SCENE_INVESTIGATION)
	state.set_current_dialogue_node_id("dialogue_intro")
	state.set_current_field_node_id("dialogue_intro")
	state.set_selected_agent_ids(["agent_kwon_narae", "agent_oh_hyun"])
	state.add_flag("validation:test-flag")

	var hidden_before: Dictionary = state.snapshot_hidden_legacy_state_for_test()
	var snapshot: Dictionary = state.export_validation_runtime_snapshot()

	_expect(snapshot.get("episode_id") == "episode_001_afterlife_station", "snapshot should include episode id")
	_expect(snapshot.has("selected_agent_ids"), "snapshot should include selected agents")
	_expect(snapshot.has("flags"), "snapshot should include case flags")
	_expect(snapshot.has("agent_case_states"), "snapshot should include case-limited agent state")
	for forbidden in ["campaign_state", "echo_fragments", "faction_relations", "completed_case_reports", "anomaly_manual_records", "agent_trust"]:
		_expect(not snapshot.has(forbidden), "snapshot must exclude %s" % forbidden)

	var clone = GameStateScript.new()
	root.add_child(clone)
	clone.reset_run_state()
	var clone_hidden_before: Dictionary = clone.snapshot_hidden_legacy_state_for_test()
	var restored: Dictionary = clone.restore_validation_runtime_snapshot(snapshot)
	_expect(restored.get("code") == "OK", "valid whitelist snapshot should restore")
	_expect(Support.semantic_equal(clone.export_validation_runtime_snapshot(), snapshot), "restored whitelist snapshot should match")
	_expect(Support.semantic_equal(clone.snapshot_hidden_legacy_state_for_test(), clone_hidden_before), "restore must not mutate hidden Legacy state")

	var invalid := snapshot.duplicate(true)
	invalid["episode_id"] = "unknown_episode"
	var before_invalid: Dictionary = clone.export_validation_runtime_snapshot()
	_expect(clone.restore_validation_runtime_snapshot(invalid).get("code") == "INVALID_EPISODE", "unknown episode should fail")
	_expect(Support.semantic_equal(clone.export_validation_runtime_snapshot(), before_invalid), "failed restore must not partially apply")
	_expect(Support.semantic_equal(state.snapshot_hidden_legacy_state_for_test(), hidden_before), "export must not mutate source hidden state")

	state.queue_free()
	clone.queue_free()
	_finish()

func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)

func _finish() -> void:
	if _failures.is_empty():
		print("VALIDATION GAME STATE ADAPTER: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
```

- [ ] **Step 2: Run RED adapter test**

Expected:

```text
FAIL: snapshot_hidden_legacy_state_for_test or export_validation_runtime_snapshot is missing
```

- [ ] **Step 3: Add exact whitelist export**

Add to `scripts/core/game_state.gd` near the save functions:

```gdscript
func export_validation_runtime_snapshot() -> Dictionary:
	return {
		"episode_id": get_current_episode_id(),
		"episode_path": current_episode_path,
		"scene_path": current_scene_path,
		"dialogue_node_id": current_dialogue_node_id,
		"field_node_id": current_field_node_id,
		"minigame_id": current_minigame_id,
		"selected_agent_ids": selected_agent_ids.duplicate(),
		"flags": flags.duplicate(),
		"collected_clue_ids": get_collected_clue_ids(),
		"seen_hint_ids": seen_hint_ids.duplicate(),
		"method_results": method_results.duplicate(true),
		"minigame_results": minigame_results.duplicate(true),
		"resolution": {
			"grade": selected_resolution_grade,
			"label": selected_resolution_label,
			"rate": selected_resolution_rate
		},
		"recovery": {
			"successful": recovery_successful,
			"result_status": recovery_result_status,
			"stability": recovery_result_stability,
			"current_pattern_id": current_recovery_pattern_id,
			"last_pattern_id": last_recovery_pattern_id,
			"confirmed_pattern_id": confirmed_recovery_pattern_id,
			"seen_pattern_ids": seen_recovery_pattern_ids.duplicate(),
			"pattern_learning": recovery_pattern_learning.duplicate(true)
		},
		"agent_case_states": agent_case_states.duplicate(true),
		"victim_state": victim_state.duplicate(true)
	}
```

- [ ] **Step 4: Add validate-before-apply restore**

Add:

```gdscript
func restore_validation_runtime_snapshot(snapshot: Dictionary) -> Dictionary:
	var episode_id := String(snapshot.get("episode_id", ""))
	var episode_path := String(snapshot.get("episode_path", ""))
	if episode_id != "episode_001_afterlife_station" or episode_path != DEFAULT_EPISODE_PATH:
		return {"ok": false, "code": "INVALID_EPISODE"}
	for required in ["selected_agent_ids", "flags", "collected_clue_ids", "seen_hint_ids", "method_results", "minigame_results", "resolution", "recovery", "agent_case_states", "victim_state"]:
		if not snapshot.has(required):
			return {"ok": false, "code": "INVALID_PAYLOAD", "field": required}
	if typeof(snapshot.get("resolution")) != TYPE_DICTIONARY or typeof(snapshot.get("recovery")) != TYPE_DICTIONARY:
		return {"ok": false, "code": "INVALID_PAYLOAD"}

	var next_selected_agents := _to_unique_string_array(snapshot.get("selected_agent_ids", []))
	if next_selected_agents.is_empty():
		return {"ok": false, "code": "INVALID_PAYLOAD", "field": "selected_agent_ids"}
	var next_flags := _to_unique_string_array(snapshot.get("flags", []))
	var next_clues := _to_unique_string_array(snapshot.get("collected_clue_ids", []))
	var next_hints := _to_unique_string_array(snapshot.get("seen_hint_ids", []))
	var next_methods := _to_dictionary(snapshot.get("method_results", {}))
	var next_minigames := _to_dictionary(snapshot.get("minigame_results", {}))
	var next_resolution := _to_dictionary(snapshot.get("resolution", {}))
	var next_recovery := _to_dictionary(snapshot.get("recovery", {}))
	var next_agent_states := _to_dictionary(snapshot.get("agent_case_states", {}))
	var next_victim_state := _to_dictionary(snapshot.get("victim_state", {}))

	if not load_episode(episode_path):
		return {"ok": false, "code": "INCOMPATIBLE_CONTENT"}
	set_selected_agent_ids(next_selected_agents)
	flags = next_flags
	seen_hint_ids = next_hints
	method_results = next_methods
	minigame_results = next_minigames
	_apply_collected_clue_ids(next_clues)
	current_scene_path = String(snapshot.get("scene_path", SCENE_DIALOGUE))
	current_dialogue_node_id = String(snapshot.get("dialogue_node_id", DEFAULT_DIALOGUE_NODE_ID))
	current_field_node_id = String(snapshot.get("field_node_id", DEFAULT_FIELD_NODE_ID))
	current_minigame_id = String(snapshot.get("minigame_id", DEFAULT_MINIGAME_ID))
	selected_resolution_grade = String(next_resolution.get("grade", ""))
	selected_resolution_label = String(next_resolution.get("label", ""))
	selected_resolution_rate = float(next_resolution.get("rate", 0.0))
	recovery_successful = bool(next_recovery.get("successful", false))
	recovery_result_status = String(next_recovery.get("result_status", ""))
	recovery_result_stability = int(next_recovery.get("stability", 100))
	current_recovery_pattern_id = String(next_recovery.get("current_pattern_id", ""))
	last_recovery_pattern_id = String(next_recovery.get("last_pattern_id", ""))
	confirmed_recovery_pattern_id = String(next_recovery.get("confirmed_pattern_id", ""))
	seen_recovery_pattern_ids = _to_unique_string_array(next_recovery.get("seen_pattern_ids", []))
	recovery_pattern_learning = _to_dictionary(next_recovery.get("pattern_learning", {}))
	agent_case_states = next_agent_states
	victim_state = next_victim_state
	return {"ok": true, "code": "OK"}
```

The `load_episode()` call currently clears resolution and recovery fields, so the assignment order above must remain after `load_episode()`.

- [ ] **Step 5: Add hidden Legacy state snapshot**

Add:

```gdscript
func snapshot_hidden_legacy_state_for_test() -> Dictionary:
	return {
		"campaign_state": campaign_state.to_save_data(),
		"seen_log_tutorial_ids": seen_log_tutorial_ids.duplicate(),
		"agent_trust": agent_trust.duplicate(true),
		"triggered_agent_event_ids": triggered_agent_event_ids.duplicate(),
		"used_agent_supports": used_agent_supports.duplicate(),
		"unlocked_records": unlocked_records.duplicate(),
		"unlocked_equipment": unlocked_equipment.duplicate(),
		"unlocked_research_rewards": unlocked_research_rewards.duplicate(),
		"equipped_items": equipped_items.duplicate(),
		"used_equipment_effects": used_equipment_effects.duplicate(),
		"completed_case_reports": completed_case_reports.duplicate(true),
		"anomaly_manual_records": anomaly_manual_records.duplicate(true),
		"completed_daily_episode_records": completed_daily_episode_records.duplicate(true),
		"active_daily_episode": active_daily_episode.duplicate(true),
		"echo_fragments": echo_fragments,
		"granted_reward_ids": granted_reward_ids.duplicate(),
		"faction_relations": faction_relations.duplicate(true),
		"triggered_faction_event_ids": triggered_faction_event_ids.duplicate(),
		"completed_faction_request_ids": completed_faction_request_ids.duplicate(),
		"purchased_market_item_ids": purchased_market_item_ids.duplicate(),
		"consumable_inventory": consumable_inventory.duplicate(true),
		"consumable_loadout": consumable_loadout.duplicate(true),
		"active_consumable_effects": active_consumable_effects.duplicate(true),
		"rewarded_resolution_grades": rewarded_resolution_grades.duplicate(true)
	}
```

This method is a guard/evidence snapshot, not a second persistence format. Do not serialize it into the Validation payload.

- [ ] **Step 6: Run GREEN adapter test**

Expected:

```text
VALIDATION GAME STATE ADAPTER: PASS
exit 0
```

- [ ] **Step 7: Commit Task 4**

```bash
git add scripts/core/game_state.gd tests/validation/validation_game_state_adapter_test.gd
git commit -m "feat: add validation runtime whitelist adapter"
```

---

### Task 5: Autoload and Fail-Closed Save Routing

**Files:**
- Create: `tests/validation/validation_save_isolation_test.gd`
- Modify: `project.godot`
- Modify: `scripts/core/game_state.gd`
- Modify: `scripts/core/validation_session.gd`

**Interfaces:**
- Consumes: Session and GameState adapter.
- Produces: active Validation save routing through existing `GameState.save_game()` callers without Legacy fallback.

- [ ] **Step 1: Write RED integration test using actual Autoloads**

Create `tests/validation/validation_save_isolation_test.gd`:

```gdscript
extends SceneTree

const Support = preload("res://tests/validation/validation_test_support.gd")

var _failures: Array[String] = []

func _init() -> void:
	var legacy_path := GameState.get_save_file_path()
	var validation_paths: Dictionary = ValidationSession.get_repository_paths()
	Support.remove_path(legacy_path)
	Support.remove_repository_paths(validation_paths)
	GameState.reset_run_state()

	_expect(GameState.save_game(), "inactive Legacy save should succeed")
	var legacy_before := Support.read_bytes(legacy_path)
	var hidden_before: Dictionary = GameState.snapshot_hidden_legacy_state_for_test()
	_expect(not legacy_before.is_empty(), "Legacy fixture bytes should exist")

	var created: Dictionary = ValidationSession.create("episode_001_afterlife_station")
	_expect(created.get("code") == "OK", "Validation session should create")
	var token := String(created.get("session_token", ""))
	_expect(ValidationSession.activate(token).get("code") == "OK", "Validation session should activate")
	_expect(ValidationSession.capture_legacy_guard(GameState).get("code") == "OK", "activation should capture hidden guard")

	GameState.add_flag("validation:integration-save")
	_expect(GameState.save_game(), "active GameState.save_game should route to Validation repository")
	_expect(Support.read_bytes(legacy_path) == legacy_before, "Validation save must preserve Legacy bytes")
	_expect(Support.semantic_equal(GameState.snapshot_hidden_legacy_state_for_test(), hidden_before), "Validation save must preserve hidden Legacy memory")
	_expect(FileAccess.file_exists(String(validation_paths["primary"])), "Validation primary should exist")

	ValidationSession.deactivate()
	GameState.change_faction_relation("rumor_market", 5, "validation-routing-inactive-check")
	_expect(GameState.save_game(), "inactive save should preserve Legacy behavior")
	_expect(Support.read_bytes(legacy_path) != legacy_before, "inactive Legacy save should update Legacy bytes")

	var latest_legacy := Support.read_bytes(legacy_path)
	Support.remove_repository_paths(validation_paths)
	var second_created: Dictionary = ValidationSession.create("episode_001_afterlife_station")
	_expect(second_created.get("code") == "OK", "second Validation session should create")
	var second_token := String(second_created.get("session_token", ""))
	_expect(ValidationSession.activate(second_token).get("code") == "OK", "second Validation session should activate")
	ValidationSession.invalidate_token_for_test()
	_expect(not GameState.save_game(), "invalid active session should fail closed")
	_expect(Support.read_bytes(legacy_path) == latest_legacy, "fail-closed route must not fallback to Legacy")

	ValidationSession.deactivate()
	Support.remove_path(legacy_path)
	Support.remove_repository_paths(validation_paths)
	_finish()

func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)

func _finish() -> void:
	if _failures.is_empty():
		print("VALIDATION SAVE ISOLATION: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
```

- [ ] **Step 2: Run RED integration test**

Expected:

```text
FAIL: identifier ValidationSession is not declared or Autoload is missing
```

- [ ] **Step 3: Register Autoload before GameState**

Modify `project.godot`:

```ini
[autoload]

UrbanLegendState="*res://scripts/core/urban_legend_state.gd"
ValidationSession="*res://scripts/core/validation_session.gd"
GameState="*res://scripts/core/game_state.gd"
_mcp_game_helper="*res://addons/godot_ai/runtime/game_helper.gd"
```

Run import immediately:

```bash
godot --headless --path . --import
```

Expected:

```text
exit 0
no autoload/global-class naming conflict
```

- [ ] **Step 4: Preserve Legacy save implementation behind a private function**

Refactor the existing `save_game()` without changing its old body:

```gdscript
func save_game() -> bool:
	if ValidationSession.requires_save_routing():
		var validation_result := save_active_session()
		if not bool(validation_result.get("ok", false)):
			push_error("Validation save failed: %s" % String(validation_result.get("code", "UNKNOWN")))
		return bool(validation_result.get("ok", false))
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

Do not route `load_game()` or `clear_save_file()`. They remain Legacy-only APIs.

- [ ] **Step 5: Add a deterministic invalid-session test hook**

Add to `validation_session.gd`:

```gdscript
func invalidate_token_for_test() -> void:
	if OS.is_debug_build():
		_session_token = ""
```

This hook is allowed only to prove fail-closed behavior. Production code must not call it.

- [ ] **Step 6: Run GREEN integration test**

Run:

```bash
TEST_HOME="$(mktemp -d)"
HOME="$TEST_HOME" XDG_DATA_HOME="$TEST_HOME/.local/share" XDG_CONFIG_HOME="$TEST_HOME/.config" \
  godot --headless --path . --script res://tests/validation/validation_save_isolation_test.gd
```

Expected:

```text
VALIDATION SAVE ISOLATION: PASS
exit 0
```

- [ ] **Step 7: Re-run existing direct Legacy save test**

Run:

```bash
TEST_HOME="$(mktemp -d)"
HOME="$TEST_HOME" XDG_DATA_HOME="$TEST_HOME/.local/share" XDG_CONFIG_HOME="$TEST_HOME/.config" \
  godot --headless --path . --script res://tests/test_mvp037_campaign_state.gd
```

Expected:

```text
exit 0
```

- [ ] **Step 8: Commit Task 5**

```bash
git add project.godot scripts/core/game_state.gd scripts/core/validation_session.gd \
  tests/validation/validation_save_isolation_test.gd
git commit -m "feat: route active validation saves safely"
```

---

### Task 6: Compatibility, Interruption and No-Effect Regression Expansion

**Files:**
- Modify: `tests/validation/validation_save_repository_test.gd`
- Modify: `tests/validation/validation_session_test.gd`
- Modify: `tests/validation/validation_save_isolation_test.gd`
- Modify: `scripts/core/validation_save_repository.gd`
- Modify: `scripts/core/validation_session.gd`

**Interfaces:**
- Consumes: integrated repository/session/routing.
- Produces: complete Spec matrix evidence for corrupt, newer, backup-only, temp-only, repeat completion, Legacy↔Validation bidirectional byte isolation.

- [ ] **Step 1: Add bidirectional byte-isolation RED assertions**

In `validation_save_isolation_test.gd`, after the first successful Validation save:

```gdscript
var validation_before_legacy_operation := Support.read_bytes(String(validation_paths["primary"]))
ValidationSession.deactivate()
GameState.load_game()
GameState.clear_save_file()
_expect(
	Support.read_bytes(String(validation_paths["primary"])) == validation_before_legacy_operation,
	"Legacy load and clear must preserve Validation bytes"
)
```

Recreate the Legacy fixture after this assertion for subsequent cases.

- [ ] **Step 2: Add hidden guard violation RED assertion**

```gdscript
Support.remove_repository_paths(validation_paths)
var guard_created: Dictionary = ValidationSession.create("episode_001_afterlife_station")
var guard_token := String(guard_created.get("session_token", ""))
ValidationSession.activate(guard_token)
ValidationSession.capture_legacy_guard(GameState)
GameState.change_faction_relation("rumor_market", 1, "intentional-hidden-drift")
var legacy_before_guard_failure := Support.read_bytes(legacy_path)
_expect(not GameState.save_game(), "hidden state drift should fail closed")
_expect(Support.read_bytes(legacy_path) == legacy_before_guard_failure, "hidden guard failure must not write Legacy")
_expect(not FileAccess.file_exists(String(validation_paths["primary"])), "hidden guard failure must not write Validation")
```

- [ ] **Step 3: Add backup-only and temp-only Session load assertions**

In `validation_session_test.gd`, create explicit fixtures:

```gdscript
var paths := session.get_repository_paths()
Support.remove_repository_paths(paths)
Support.write_text(String(paths["temp"]), JSON.stringify(_make_valid_session_payload()))
_expect(session.load(game_state).get("code") == "INTERRUPTED_WRITE", "temp-only save must not auto promote")
_expect(not FileAccess.file_exists(String(paths["primary"])), "temp-only load must not create primary")

Support.remove_path(String(paths["temp"]))
Support.write_text(String(paths["backup"]), JSON.stringify(_make_valid_session_payload()))
_expect(session.load(game_state).get("code") == "RECOVERABLE_BACKUP", "backup-only save requires explicit recovery")
_expect(not FileAccess.file_exists(String(paths["primary"])), "backup preview must not auto create primary")
```

- [ ] **Step 4: Run expanded tests and observe failures**

Run the four direct test commands.

Expected:

```text
At least one assertion fails until guard and backup/temp handling exactly match the Spec.
```

- [ ] **Step 5: Apply minimum fixes**

Required behavior:

```text
Repository.inspect:
  primary absent + temp present -> INTERRUPTED_WRITE
  primary absent + exact backup present -> RECOVERABLE_BACKUP
  no automatic rename

Session.save:
  hidden guard mismatch -> HIDDEN_STATE_GUARD_VIOLATION
  no repository write

Session.complete:
  first call writes completion effect once
  repeat call -> ALREADY_COMPLETED
  no revision increase on repeat

Legacy APIs:
  never access Validation primary/backup/temp
```

Do not add automatic backup restore UI or overwrite confirmation; those belong to Package 2.

- [ ] **Step 6: Run all four direct tests**

Expected:

```text
VALIDATION SAVE REPOSITORY: PASS
VALIDATION SESSION: PASS
VALIDATION GAME STATE ADAPTER: PASS
VALIDATION SAVE ISOLATION: PASS
```

- [ ] **Step 7: Commit Task 6**

```bash
git add scripts/core/validation_save_repository.gd scripts/core/validation_session.gd \
  tests/validation/validation_save_repository_test.gd \
  tests/validation/validation_session_test.gd \
  tests/validation/validation_save_isolation_test.gd
git commit -m "test: close validation save isolation matrix"
```

---

### Task 7: Focused Runner, Full Regression and CI Wiring

**Files:**
- Create: `tests/run_validation_package_1_tests.sh`
- Modify: `tests/run_godot_regression.sh`
- Modify: `.github/workflows/validate-core-mvp-001.yml`
- Modify: `.github/workflows/validate-annual-mvp-001.yml`

**Interfaces:**
- Consumes: four Package 1 test entrypoints.
- Produces: local focused command, 53-entry full regression, CORE and ANNUAL PR checks with failure logs.

- [ ] **Step 1: Create focused runner**

Create `tests/run_validation_package_1_tests.sh`:

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
  rm -rf "$home_dir"
  mkdir -p "$home_dir"
  echo "::group::Validation Package 1: $test_name"
  if ! HOME="$home_dir" \
      XDG_DATA_HOME="$home_dir/.local/share" \
      XDG_CONFIG_HOME="$home_dir/.config" \
      GODOT_SILENCE_ROOT_WARNING=1 \
      timeout "$GODOT_TEST_TIMEOUT" "$GODOT_BIN" \
      --headless --path "$PROJECT_ROOT" \
      --script "res://tests/$test_name.gd" >"$log_file" 2>&1; then
    cat "$log_file"
    echo "::endgroup::"
    echo "FAILED: $test_name" >&2
    exit 1
  fi
  tail -n 12 "$log_file"
  echo "::endgroup::"
done

echo "Validation Package 1: 4/4 test entrypoints passed"
echo "Logs: $LOG_ROOT"
```

Run:

```bash
chmod +x tests/run_validation_package_1_tests.sh
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_validation_package_1_tests.sh
```

Expected:

```text
Validation Package 1: 4/4 test entrypoints passed
```

- [ ] **Step 2: Register tests in full regression**

Add to `script_tests` in `tests/run_godot_regression.sh`:

```bash
  validation/validation_save_repository_test
  validation/validation_session_test
  validation/validation_game_state_adapter_test
  validation/validation_save_isolation_test
```

Change the final summary to:

```bash
echo "Godot regression suite: 53/53 test entrypoints passed"
```

The existing runner currently assumes names without `/` when constructing HOME and log paths. Before adding nested test names, change `run_test()`:

```bash
local safe_name="${name//\//_}"
local home_dir="$RUN_ROOT/home/$safe_name"
local log_file="$LOG_ROOT/$safe_name.log"
```

Keep the actual target as `res://tests/$name.gd`.

- [ ] **Step 3: Add CORE workflow trigger and focused step**

Add these paths to `.github/workflows/validate-core-mvp-001.yml`:

```yaml
      - "project.godot"
      - "scripts/core/game_state.gd"
      - "scripts/core/validation_session.gd"
      - "scripts/core/validation_save_repository.gd"
      - "tests/validation/**"
      - "tests/run_validation_package_1_tests.sh"
```

After project import, add:

```yaml
      - name: Run focused Validation Package 1 tests
        env:
          GODOT_BIN: godot
          GODOT_TEST_TMP: ${{ runner.temp }}/validation-package-1-tests
        run: bash tests/run_validation_package_1_tests.sh
```

Add the focused log directory to failure artifacts:

```yaml
            ${{ runner.temp }}/validation-package-1-tests/validation-package-1-logs
```

- [ ] **Step 4: Add ANNUAL workflow core trigger and focused step**

Add these trigger paths to `.github/workflows/validate-annual-mvp-001.yml`:

```yaml
      - "project.godot"
      - "scripts/core/game_state.gd"
      - "scripts/core/validation_session.gd"
      - "scripts/core/validation_save_repository.gd"
```

After project import, add the same focused Validation step with a distinct temp directory:

```yaml
      - name: Run focused Validation Package 1 tests
        env:
          GODOT_BIN: godot
          GODOT_TEST_TMP: ${{ runner.temp }}/validation-package-1-tests
        run: bash tests/run_validation_package_1_tests.sh
```

Add its logs to failure artifacts.

- [ ] **Step 5: Run YAML and shell static checks**

Run:

```bash
bash -n tests/run_validation_package_1_tests.sh
bash -n tests/run_godot_regression.sh
python - <<'PY'
from pathlib import Path
import yaml
for path in [
    Path('.github/workflows/validate-core-mvp-001.yml'),
    Path('.github/workflows/validate-annual-mvp-001.yml'),
]:
    yaml.safe_load(path.read_text(encoding='utf-8'))
    print(f'YAML OK: {path}')
PY
```

If PyYAML is unavailable, use Ruby’s standard YAML parser:

```bash
ruby -e 'require "yaml"; ARGV.each { |p| YAML.load_file(p); puts "YAML OK: #{p}" }' \
  .github/workflows/validate-core-mvp-001.yml \
  .github/workflows/validate-annual-mvp-001.yml
```

Expected:

```text
shell syntax exit 0
both workflow files parse
```

- [ ] **Step 6: Run focused and full regression locally**

```bash
godot --headless --path . --import
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_validation_package_1_tests.sh
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_core_mvp_001_tests.sh
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_annual_mvp_001_tests.sh
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_annual_mvp_002_tests.sh
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_godot_regression.sh
```

Expected only after actual execution:

```text
Validation Package 1: 4/4 test entrypoints passed
CORE focused exit 0
ANNUAL-001 focused exit 0
ANNUAL-002 focused exit 0
Godot regression suite: 53/53 test entrypoints passed
```

- [ ] **Step 7: Commit Task 7**

```bash
git add tests/run_validation_package_1_tests.sh tests/run_godot_regression.sh \
  .github/workflows/validate-core-mvp-001.yml \
  .github/workflows/validate-annual-mvp-001.yml
git commit -m "ci: validate Package 1 save isolation"
```

---

### Task 8: Documentation, Exact-HEAD Verification and Decision Sync

**Files:**
- Modify: `TEST_CHECKLIST.md`
- Modify: `docs/CURRENT_STATUS.md`
- Modify: `docs/CURRENT_HANDOFF_VALIDATION.md`
- Modify: the Package 1 implementation PR body
- Modify: Google Sheet `00`, `01`, `02`, `04`, `99` tabs

**Interfaces:**
- Consumes: fresh local/CI evidence from Tasks 1-7.
- Produces: exact implementation HEAD verdict, rollback notes, next Package gate, same Decision ID in GitHub and Sheet.

- [ ] **Step 1: Add test checklist evidence fields**

Add a Package 1 section to `TEST_CHECKLIST.md` with these exact rows:

```markdown
## Validation Package 1 — Session·Save Isolation

- [ ] Validation focused 4/4 entrypoints
- [ ] Legacy save bytes unchanged during Validation create/save/load/delete/complete/corrupt inspection
- [ ] Hidden campaign/economy/relationship/faction/market snapshot unchanged
- [ ] Active invalid Session fails closed without Legacy fallback
- [ ] Inactive Legacy save/load/clear preserves existing behavior
- [ ] Corrupt and newer Validation saves are preserved and not auto-promoted
- [ ] CORE focused suite
- [ ] ANNUAL-MVP-001 focused suite
- [ ] ANNUAL-MVP-002 focused suite
- [ ] Full Godot regression 53/53
- [ ] Runtime manual verification — NOT_RUN until separately authorized
- [ ] Human QA — NOT_RUN until separately authorized
```

Mark only rows supported by fresh command or CI output.

- [ ] **Step 2: Run changed-file and forbidden-surface audit**

```bash
git diff --name-status origin/main...HEAD
git diff --stat origin/main...HEAD

git diff --name-only origin/main...HEAD | grep -E \
  '^(scripts/ui/main_menu.gd|scenes/main_menu.tscn|scripts/scenes/(preparation|result)_scene.gd|data/episodes/|scripts/scenes/(dialogue|investigation|minigame|battle)_scene.gd)$' \
  && { echo "Forbidden Package 1 surface changed"; exit 1; } || true
```

Expected:

```text
Only Package 1 core scripts, tests, runners, workflows and status docs
No forbidden Package 2+ product surface
```

- [ ] **Step 3: Verify repository contains no unresolved implementation markers**

Run against changed files only:

```bash
git diff --name-only origin/main...HEAD \
  | xargs grep -nE '(^|[^A-Za-z])(TODO|TBD|FIXME|implement later|fill in details)([^A-Za-z]|$)' \
  && exit 1 || true
```

Expected:

```text
no matches
```

- [ ] **Step 4: Record actual test evidence in status docs**

Update `docs/CURRENT_STATUS.md` and `docs/CURRENT_HANDOFF_VALIDATION.md` with:

```yaml
package_1_implementation_head: <exact git rev-parse HEAD>
validation_focused: PASS | FAIL | NOT_RUN
core_focused: PASS | FAIL | NOT_RUN
annual_001_focused: PASS | FAIL | NOT_RUN
annual_002_focused: PASS | FAIL | NOT_RUN
full_godot_regression: PASS_53_OF_53 | FAIL | NOT_RUN
runtime: NOT_RUN
human_qa: NOT_RUN
product_scope: PACKAGE_1_FOUNDATION_ONLY
legacy_file_guard: PASS | FAIL | NOT_RUN
legacy_memory_guard: PASS | FAIL | NOT_RUN
```

Do not copy expected results into these fields unless the commands actually ran.

- [ ] **Step 5: Commit evidence documentation**

```bash
git add TEST_CHECKLIST.md docs/CURRENT_STATUS.md docs/CURRENT_HANDOFF_VALIDATION.md
git commit -m "docs: record Package 1 isolation evidence"
```

- [ ] **Step 6: Push and open Draft implementation PR**

```bash
git push -u origin agent/package-1-session-save-isolation
```

PR title:

```text
feat: isolate Validation session and save state
```

PR body must include:

```markdown
- Parent Decision: D-2026-08-02-PACKAGE-1-DESIGN-SPEC-APPROVAL
- Persistence Decision: D-2026-08-02-VALIDATION-PERSISTENCE-BOUNDARY
- Base SHA
- Exact head SHA
- Created/modified file inventory
- RED evidence per Task
- Focused and full test commands with actual results
- Legacy file and memory guard evidence
- Explicit Package 2+ exclusions
- Rollback steps
- Runtime/Human status
```

Keep the implementation PR Draft until exact-head review and all required checks are complete.

- [ ] **Step 7: Inspect GitHub checks at exact HEAD**

```bash
HEAD_SHA="$(git rev-parse HEAD)"
gh pr checks --watch
printf 'exact-head=%s\n' "$HEAD_SHA"
```

Required evidence:

```text
Validate CORE-MVP-001 success
Validate ANNUAL-MVP-001 success
No unresolved review threads
Current PR head equals reviewed head
```

An empty combined status is not a PASS. Fetch workflow runs and job logs when a check is absent or failed.

- [ ] **Step 8: Run final adversarial re-review**

Attack these claims against the exact diff:

```text
1. Validation path can reach user://urban_legend_save.json.
2. Active invalid Session falls back to Legacy.
3. Whitelist accidentally includes campaign/economy/report/manual collections.
4. Restore partially mutates runtime before validation succeeds.
5. Hidden state changes without being detected.
6. Corrupt or newer save is deleted or overwritten.
7. Legacy clear deletes Validation files.
8. Completion applies more than once.
9. Package 2+ UI or content leaked into Package 1.
10. Test runner reports a stale entrypoint count.
```

For every surviving issue, classify `MUST_FIX`, `SHOULD_FIX`, `REJECTED_CRITIQUE`, or `BLOCKED_UNVERIFIED`. Fix `MUST_FIX`, rerun affected focused tests and the 53-entry full regression, then create a new exact-head evidence record.

- [ ] **Step 9: Synchronize GitHub authority and Google Sheet**

Use one implementation Decision ID, recommended:

```text
D-2026-08-02-PACKAGE-1-SESSION-SAVE-ISOLATION-IMPLEMENTATION
```

Write the same ID and exact commit SHA to:

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

Re-read each exact Sheet range after writing. Status remains `PENDING_MAIN` until the implementation PR is merged.

- [ ] **Step 10: Final implementation commit if sync docs changed**

```bash
git add docs/CURRENT_CONFIRMED_DECISIONS.md docs/CURRENT_HANDOFF_VALIDATION.md
git commit -m "docs: sync Package 1 implementation decision"
git push
```

After this commit, rerun exact-head changed-file inventory and required checks. Do not reuse evidence from the previous head.

---

## Rollback Procedure

Use the implementation PR commits as independent rollback checkpoints.

```bash
# Revert documentation sync first if needed.
git revert <sync-doc-commit>

# Revert CI wiring.
git revert <ci-commit>

# Revert save routing/autoload.
git revert <routing-commit>

# Revert GameState adapter.
git revert <adapter-commit>

# Revert Session and repository.
git revert <session-commit> <repository-commit>
```

After rollback:

```bash
godot --headless --path . --import
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_core_mvp_001_tests.sh
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_annual_mvp_001_tests.sh
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_annual_mvp_002_tests.sh
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_godot_regression.sh
```

Expected rollback state:

```text
Validation Autoload absent
Validation scripts/tests absent
Legacy mvp-039 save behavior restored
mvp-038 migration and ANNUAL paths unchanged
full regression returns to the pre-Package-1 entrypoint count
```

Validation primary/backup/temp files may be deleted only through explicit Validation cleanup. Never delete `user://urban_legend_save.json` as part of rollback.

---

## Plan Self-Review

### Spec Coverage

| Spec requirement | Plan task |
|---|---|
| Separate Validation namespace | Tasks 1-2 |
| Single slot and v1 version | Tasks 1-3 |
| Explicit Session activation | Task 3 |
| Field-level whitelist | Task 4 |
| Legacy file and memory no-effect | Tasks 4-6 |
| Fail-closed save routing | Task 5 |
| Corrupt/newer/interrupted/backup matrix | Tasks 2 and 6 |
| Lifecycle separation | Task 3 |
| Completion idempotency | Tasks 3 and 6 |
| Existing Legacy semantics | Tasks 4-7 |
| CORE/ANNUAL/full regression | Task 7 |
| Rollback and exact-head evidence | Task 8 |
| Same Decision ID in GitHub and Sheet | Task 8 |

### Type and Signature Consistency

- Repository result shape is always `Dictionary` with `ok: bool` and `code: String`.
- Session public methods return the same result shape.
- `GameState.save_game()` remains `bool` for existing callers; detailed Validation errors are returned by `save_active_session()`.
- Runtime snapshot field names are identical in export, restore, Session payload, and tests.
- `ValidationSession` is an Autoload identifier, not a global `class_name`.
- Focused runner paths match actual created test files.
- Full regression total is 49 existing + 4 new = 53.

### Scope Review

The plan does not modify main menu UI, preparation/result scenes, episode JSON, route minigame, battle flow, result calculator, mobile behavior, Legacy migration schema, or ANNUAL product state. Workflow edits exist only to execute the approved Package 1 tests and existing regressions.

### Remaining Gate

```text
Implementation Plan = REVIEW_READY
Product implementation = NOT_AUTHORIZED
PR #125 merge = NOT_REQUESTED
Runtime/Human = NOT_RUN
```

Execution starts only after the user explicitly approves Package 1 implementation.