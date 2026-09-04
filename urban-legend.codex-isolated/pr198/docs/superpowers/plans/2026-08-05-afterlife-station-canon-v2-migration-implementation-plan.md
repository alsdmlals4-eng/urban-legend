# Afterlife Station Canon v2 Migration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 기존 `episode_001_afterlife_station`·`victim_afterlife_station_001` 정체성과 과거 기록을 유지하면서 `afterlife-station-canon-v2` 콘텐츠, ID 이관, `mvp-040`, `validation-save-v2`를 원자적이고 멱등적인 방식으로 도입한다.

**Architecture:** 콘텐츠 로딩, ID 의미 변환, 저장 단계 판정, 본편 메모리 변환, Validation 메모리 변환, 파일 transaction을 서로 분리한다. `EpisodeLoader`와 `GameState`는 얇은 통합 경계만 제공하고, 의미 변환은 순수한 migrator가, 파일 교체는 `AfterlifeMigrationTransaction`만 소유한다. `source_checksum`과 `migration_history`는 Flyway식 이력 검증을, temp/readback/backup/replace는 기존 Validation repository의 검증된 atomic replace 패턴을 따른다.

**Tech Stack:** Godot 4.7.1, GDScript, JSON, SceneTree headless tests, Python documentation contracts, Bash, GitHub Actions.

## Global Constraints

- 승인 Decision: `D-2026-08-05-AFTERLIFE-STATION-CANON-V2-MIGRATION-DESIGN`.
- 운영 Decision: `D-2026-08-05-WORKFLOW-BENCHMARK-TDD-AND-CHECKPOINT-POLICY`.
- 승인 Spec: `docs/superpowers/specs/2026-08-05-afterlife-station-canon-v2-migration-design.md`.
- ID 권위표: `docs/planning/2026-08-05-afterlife-station-id-migration-matrix.md`.
- Episode ID: `episode_001_afterlife_station`.
- victim stable ID: `victim_afterlife_station_001`.
- 콘텐츠 계약: `afterlife-station-canon-v2`, `content_schema: 2`.
- 본편 readable: `mvp-038`, `mvp-039`; new write: `mvp-040`.
- Validation readable: `validation-save-v1`; new write: `validation-save-v2`.
- 구형 `correct_response_id`를 새 정답으로 사용하지 않는다.
- SPLIT target은 `migrated_unverified`; 매뉴얼 정답 슬롯 자동 채움 금지.
- 진행 중 구형 구출·회수는 `LEGACY_CASE_RESTART_REQUIRED`.
- 완료 결과는 `legacy_resolution_snapshot`; 과거 보상을 다시 지급하지 않는다.
- 미매핑 ID는 `orphan_legacy_ids`에 보존하고 런타임 미적용.
- 실패 시 Legacy 저장으로 fallback하지 않는다.
- 각 작업은 RED → 최소 구현 → GREEN → focused 검증 → 전체 회귀 → 커밋 순서다.
- 승인 배치는 최대 10건이며 고위험 충돌·세션 종료·정본 영향이 큰 경우 조기 체크포인트를 연다.
- 이 문서는 `IMPLEMENTATION_NOT_AUTHORIZED`; 별도 implementation approval checkpoint 전에는 제품 파일을 변경하지 않는다.
- PR 병합은 별도 merge approval checkpoint 뒤에만 가능하다.
- Human QA: NOT_RUN.
- Runtime implementation: NOT_RUN.

---

## 현업 벤치마크와 채택 결론

### Godot

Godot 공식 문서는 저장 시스템을 프로젝트별 요구에 맞게 설계해야 하며, 복잡한 복원은 부모·전역 상태를 먼저 복원한 뒤 종속 객체를 단계적으로 복원하는 방식을 설명한다.

- 참고: `https://docs.godotengine.org/en/latest/tutorials/io/saving_games.html`
- 채택: Inspector → memory migrator → validation → transaction 순서의 단계적 복원.
- 기각: 모든 노드가 자신의 파일 I/O와 이관 의미를 동시에 소유하는 분산 저장.

### Unreal Engine

Unreal Engine 공식 문서는 서로 다른 책임의 데이터를 여러 SaveGame 클래스와 저장 슬롯으로 분리할 수 있다고 설명한다.

- 참고: `https://dev.epicgames.com/documentation/unreal-engine/saving-and-loading-your-game-in-unreal-engine`
- 채택: 본편 `mvp-040`과 Validation `validation-save-v2`의 물리·의미 경계 유지.
- 기각: 본편과 Validation을 한 payload로 병합해 격리를 약화하는 방식.

### Unity Cloud Save

Unity Cloud Save의 write lock은 읽은 버전 이후 다른 쓰기가 있었는지 확인해 조용한 덮어쓰기를 막는다.

- 참고: `https://docs.unity.com/en-us/cloud-save/concepts/write-locks`
- 채택: migration 시작 시 읽은 원본의 `source_checksum`을 교체 직전 다시 비교한다.
- 기각: checksum 불일치에도 최신 primary를 강제 덮어쓰는 방식.

### Flyway

Flyway versioned migration은 적용 순서와 checksum을 schema history에 기록하고 같은 migration을 정확히 한 번 적용한다.

- 참고: `https://documentation.red-gate.com/flyway/flyway-concepts/migrations/versioned-migrations`
- 채택: `migration_history`, `effect_id`, registry checksum, source/target version을 저장한다.
- 기각: 이미 적용된 migration 의미를 같은 ID로 조용히 수정하는 방식. 변경이 필요하면 새 migration ID로 roll-forward한다.

### 프로젝트 권장안

현재 승인된 `mvp-040 / validation-save-v2 / effect_id / backup-first`를 유지한다. 여기에 다음 세 가지를 구현 계약으로 추가한다.

1. `source_checksum`: inspect 시점과 replace 시점 사이의 외부 변경 감지.
2. `migration_history`: migration ID·registry checksum·source version·target version·applied_at 기록.
3. `atomic replace`: temp 작성·재읽기·checksum 검증·backup·primary 교체·최종 재읽기·실패 rollback.

---

## Execution Preconditions

구현 승인 후 최신 `main`에서 격리 worktree를 만든다. PR #145의 문서가 아직 병합되지 않았다면 구현 PR은 PR #145 브랜치를 base로 하는 stacked PR로 시작하고, 문서 병합 후 최신 `main`으로 rebase한다.

```bash
git fetch origin
git status --short
BASE_REF="origin/main"
# PR #145가 미병합이고 구현 승인이 명시적으로 주어진 경우에만:
# BASE_REF="origin/agent/afterlife-station-canon-v2-migration-design"

# REQUIRED SUB-SKILL: superpowers:using-git-worktrees
git worktree add .worktrees/afterlife-canon-v2-migration \
  -b agent/afterlife-canon-v2-migration "$BASE_REF"
cd .worktrees/afterlife-canon-v2-migration
```

Baseline:

```bash
godot --headless --path . --import
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_core_mvp_001_tests.sh
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_annual_mvp_001_tests.sh
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_annual_mvp_002_tests.sh
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_godot_regression.sh
```

Expected: 모든 baseline exit 0. 기존 실패가 있으면 구현을 시작하지 않고 exact SHA·실패 entrypoint·로그로 조기 체크포인트를 연다.

---

## File Responsibility Map

### Create

- `data/episodes/episode_001_afterlife_station_canon_v2.json` — Canon v2 identity, manual/rescue/recovery/result 구조의 정본 sidecar.
- `data/migrations/afterlife_station_canon_v2_id_migration.json` — 런타임이 읽는 ID disposition registry.
- `scripts/data/afterlife_canon_v2_loader.gd` — sidecar parse, schema validation, layer allowlist merge, provenance.
- `scripts/data/afterlife_id_migration_registry.gd` — registry validation, lookup, SPLIT/MERGE provenance, orphan 처리.
- `scripts/core/afterlife_legacy_save_inspector.gd` — source bytes·version·stage·checksum의 읽기 전용 판정.
- `scripts/core/afterlife_main_save_migrator.gd` — mvp-038/039 Dictionary를 mvp-040 메모리 payload로 변환.
- `scripts/core/afterlife_validation_save_migrator.gd` — validation-save-v1 Dictionary를 v2 메모리 payload로 변환.
- `scripts/core/afterlife_migration_transaction.gd` — backup, temp/readback, checksum compare, atomic replace, rollback.
- `tests/afterlife_migration/afterlife_migration_test_support.gd` — fixture·bytes·semantic snapshot·cleanup helper.
- `tests/afterlife_migration/afterlife_canon_v2_loader_test.gd`
- `tests/afterlife_migration/afterlife_id_migration_registry_test.gd`
- `tests/afterlife_migration/afterlife_legacy_save_inspector_test.gd`
- `tests/afterlife_migration/afterlife_main_save_migrator_test.gd`
- `tests/afterlife_migration/afterlife_validation_save_migrator_test.gd`
- `tests/afterlife_migration/afterlife_migration_transaction_test.gd`
- `tests/afterlife_migration/afterlife_migration_integration_test.gd`
- `tests/run_afterlife_canon_v2_migration_tests.sh`

### Modify

- `scripts/data/episode_loader.gd` — 명시적 content contract 요청과 Canon v2 loader 위임.
- `scripts/core/game_state.gd` — `mvp-040` write, inspect/migrate/load transaction 통합.
- `scripts/core/validation_save_repository.gd` — v1 inspect 허용, v2 write/read, migration transaction hook.
- `scripts/core/validation_session.gd` — v1 payload migration과 v2 lifecycle restore.
- `tests/run_godot_regression.sh` — 신규 focused entrypoints 등록.
- `.github/workflows/validate-afterlife-station-canon-v2-migration-design.yml` — 구현 경로와 focused runner 추가.
- `.github/workflows/validate-annual-mvp-001.yml` — 저장·Godot 회귀 경로 추가.
- `TEST_CHECKLIST.md`, `docs/CURRENT_STATUS.md`, `docs/CURRENT_HANDOFF_VALIDATION.md` — 실제 실행 증거만 기록.

---

### Task 1: Canon v2 Data and Schema Contract

**Files:**
- Create: `data/episodes/episode_001_afterlife_station_canon_v2.json`
- Create: `tests/afterlife_migration/afterlife_migration_test_support.gd`
- Create: `tests/afterlife_migration/afterlife_canon_v2_loader_test.gd`

**Interfaces:**
- Produces: sidecar root keys `target_episode_id`, `content_contract_id`, `content_schema`, `loaded_layers`, `canonical_v2`.
- Produces: canonical blocks `investigation_manual`, `rescue_protocol`, `recovery_encounters`, `result_contract`.
- Consumes: stable IDs and semantic IDs from the approved Spec.

- [ ] **Step 1 — RED fixture contract 작성**

```gdscript
extends SceneTree

const SIDECAR := "res://data/episodes/episode_001_afterlife_station_canon_v2.json"
var failures: Array[String] = []

func _init() -> void:
	_expect(FileAccess.file_exists(SIDECAR), "Canon v2 sidecar missing")
	if FileAccess.file_exists(SIDECAR):
		var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(SIDECAR))
		_expect(typeof(parsed) == TYPE_DICTIONARY, "sidecar root must be Dictionary")
		if typeof(parsed) == TYPE_DICTIONARY:
			var data := parsed as Dictionary
			_expect(data.get("target_episode_id") == "episode_001_afterlife_station", "episode identity changed")
			_expect(data.get("content_contract_id") == "afterlife-station-canon-v2", "contract mismatch")
			_expect(int(data.get("content_schema", 0)) == 2, "schema mismatch")
			for key in ["investigation_manual", "rescue_protocol", "recovery_encounters", "result_contract"]:
				_expect(typeof(data.get("canonical_v2", {}).get(key)) == TYPE_DICTIONARY, "missing %s" % key)
	_finish()
```

- [ ] **Step 2 — RED 실행**

```bash
TEST_HOME="$(mktemp -d)"
HOME="$TEST_HOME" XDG_DATA_HOME="$TEST_HOME/.local/share" \
  godot --headless --path . --script res://tests/afterlife_migration/afterlife_canon_v2_loader_test.gd
```

Expected: FAIL — sidecar 파일이 없어 `Canon v2 sidecar missing`.

- [ ] **Step 3 — 최소 구현**

sidecar에 identity와 네 canonical block, 승인된 page·record·pattern·response ID를 작성한다. 수치·UI 위치·피해량은 넣지 않는다. `legacy_core_validation` 데이터는 `legacy_content_snapshot` 참조만 허용하고 `recovery_encounters.patterns`에 복사하지 않는다.

- [ ] **Step 4 — GREEN 및 focused 검증**

위 RED 명령을 다시 실행한다.

Expected: PASS — identity, schema, bounded blocks, semantic IDs 검증.

- [ ] **Step 5 — 회귀**

```bash
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_core_mvp_001_tests.sh
```

Expected: 기존 Episode 기본 로드는 변화 없이 PASS.

- [ ] **Step 6 — 커밋**

```bash
git add data/episodes/episode_001_afterlife_station_canon_v2.json tests/afterlife_migration/
git commit -m "feat: add Afterlife Station canon v2 data contract"
```

---

### Task 2: Explicit Canon v2 Loader and Layer Ownership

**Files:**
- Create: `scripts/data/afterlife_canon_v2_loader.gd`
- Modify: `scripts/data/episode_loader.gd:1-55`
- Modify: `tests/afterlife_migration/afterlife_canon_v2_loader_test.gd`

**Interfaces:**
- Produces: `AfterlifeCanonV2Loader.load_contract(base_path: String, contract_id: String) -> Dictionary`.
- Produces result: `{"ok": bool, "code": String, "episode": Dictionary, "loaded_layers": Array}`.
- Modifies: `EpisodeLoader.load_episode(file_path: String, content_contract_id: String = "") -> Dictionary`.

- [ ] **Step 1 — RED loader behavior 작성**

검증 항목:

```gdscript
var legacy := EpisodeLoader.new().load_episode(BASE_PATH)
_expect(not legacy.is_empty(), "legacy default load failed")
_expect(not legacy.has("content_contract_id"), "implicit v2 activation occurred")

var v2 := EpisodeLoader.new().load_episode(BASE_PATH, "afterlife-station-canon-v2")
_expect(v2.get("content_contract_id") == "afterlife-station-canon-v2", "explicit v2 load failed")
_expect(v2.get("loaded_layers") == ["base_episode", "legacy_core_validation", "canonical_v2"], "provenance mismatch")
_expect(v2.get("recovery_patterns", []).is_empty(), "legacy and v2 patterns mixed")
```

허용되지 않은 `canonical_v2` key가 base identity를 덮으려 하면 `DISALLOWED_LAYER_OVERRIDE`; episode ID가 다르면 `CONTENT_EPISODE_MISMATCH`를 요구한다.

- [ ] **Step 2 — RED 실행**

```bash
godot --headless --path . --script res://tests/afterlife_migration/afterlife_canon_v2_loader_test.gd
```

Expected: FAIL — `load_episode`가 두 번째 인자를 받지 못하거나 Canon v2 loader가 없음.

- [ ] **Step 3 — 최소 구현**

```gdscript
class_name AfterlifeCanonV2Loader
extends RefCounted

const CONTRACT_ID := "afterlife-station-canon-v2"
const SIDECAR_PATH := "res://data/episodes/episode_001_afterlife_station_canon_v2.json"
const OWNED_BLOCKS := ["investigation_manual", "rescue_protocol", "recovery_encounters", "result_contract", "victim_profile"]

func load_contract(base_path: String, contract_id: String) -> Dictionary:
	if contract_id != CONTRACT_ID:
		return {"ok": false, "code": "INCOMPATIBLE_CONTENT_CONTRACT"}
	# parse → identity validation → allowlist merge → provenance
	return {"ok": true, "code": "EXACT_V2", "episode": merged, "loaded_layers": loaded_layers}
```

`EpisodeLoader`는 빈 contract ID에서는 기존 `_core_validation.json` 동작을 유지한다. 명시적으로 v2가 요청된 경우에만 새 loader에 위임한다. 구형 recovery_patterns와 Canon v2 patterns를 혼합하지 않는다.

- [ ] **Step 4 — GREEN 및 focused 검증**

```bash
godot --headless --path . --script res://tests/afterlife_migration/afterlife_canon_v2_loader_test.gd
```

Expected: PASS — explicit activation, allowlist, provenance, no pattern mixture.

- [ ] **Step 5 — 회귀**

```bash
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_core_mvp_001_tests.sh
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_godot_regression.sh
```

Expected: legacy call sites가 기본 인자를 통해 동일 동작을 유지.

- [ ] **Step 6 — 커밋**

```bash
git add scripts/data/afterlife_canon_v2_loader.gd scripts/data/episode_loader.gd tests/afterlife_migration/afterlife_canon_v2_loader_test.gd
git commit -m "feat: load Afterlife canon v2 with explicit layer ownership"
```

---

### Task 3: ID Migration Registry, Checksum, and Apply-Once History

**Files:**
- Create: `data/migrations/afterlife_station_canon_v2_id_migration.json`
- Create: `scripts/data/afterlife_id_migration_registry.gd`
- Create: `tests/afterlife_migration/afterlife_id_migration_registry_test.gd`

**Interfaces:**
- Produces: `AfterlifeIdMigrationRegistry.load_registry(path: String) -> Dictionary`.
- Produces: `lookup(legacy_id: String) -> Dictionary`.
- Produces: `map_value(legacy_id: String, source_location: String, raw_value: Variant) -> Dictionary`.
- Produces metadata: `registry_checksum`, `effect_id`, `migration_history` entry.

- [ ] **Step 1 — RED registry test 작성**

```gdscript
var registry := Registry.new()
var loaded := registry.load_registry(REGISTRY_PATH)
_expect(loaded.get("code") == "EXACT", "registry must validate")
_expect(not String(loaded.get("registry_checksum", "")).is_empty(), "checksum missing")

var split := registry.map_value("clue_repeating_announcement", "unlocked_records", true)
_expect(split.get("disposition") == "SPLIT", "split disposition missing")
for target in split.get("targets", []):
	_expect(target.get("state") == "migrated_unverified", "split leaked correctness")

var unknown := registry.map_value("unknown_legacy_id", "flags", true)
_expect(unknown.get("code") == "UNMAPPED_LEGACY_ID", "unknown must be preserved")
_expect(unknown.get("runtime_apply") == false, "unknown executed")
```

동일 `effect_id`가 이미 `migration_history`에 있으면 새 효과를 생성하지 않는 검증도 포함한다.

- [ ] **Step 2 — RED 실행**

```bash
godot --headless --path . --script res://tests/afterlife_migration/afterlife_id_migration_registry_test.gd
```

Expected: FAIL — registry script와 JSON 부재.

- [ ] **Step 3 — 최소 구현**

Migration Matrix의 각 구형 ID를 JSON 행으로 옮기고 `KEEP_ID|ALIAS|SPLIT|MERGE|HISTORICAL_ONLY|DISCARD_SEMANTICS` 외 값은 거부한다. `source_checksum`은 source save용이며 registry 자체에는 `registry_checksum`을 SHA-256으로 계산한다.

```gdscript
func make_history_entry(source_version: String, target_version: String) -> Dictionary:
	return {
		"migration_id": "afterlife-station-canon-v2-001",
		"registry_checksum": _registry_checksum,
		"source_version": source_version,
		"target_version": target_version,
		"effect_ids": _applied_effect_ids.duplicate(),
		"applied_at_utc": Time.get_datetime_string_from_system(true, true)
	}
```

- [ ] **Step 4 — GREEN 및 focused 검증**

```bash
godot --headless --path . --script res://tests/afterlife_migration/afterlife_id_migration_registry_test.gd
```

Expected: PASS — dispositions, provenance, orphan, checksum, apply-once.

- [ ] **Step 5 — 회귀**

```bash
python -m unittest tests/test_afterlife_station_canon_v2_migration_design.py
```

Expected: Matrix와 런타임 registry의 핵심 ID가 일치.

- [ ] **Step 6 — 커밋**

```bash
git add data/migrations/afterlife_station_canon_v2_id_migration.json scripts/data/afterlife_id_migration_registry.gd tests/afterlife_migration/afterlife_id_migration_registry_test.gd
git commit -m "feat: add idempotent Afterlife ID migration registry"
```

---

### Task 4: Read-Only Legacy Save Inspector and Stage Classifier

**Files:**
- Create: `scripts/core/afterlife_legacy_save_inspector.gd`
- Create: `tests/afterlife_migration/afterlife_legacy_save_inspector_test.gd`
- Modify: `tests/afterlife_migration/afterlife_migration_test_support.gd`

**Interfaces:**
- Produces: `inspect_main_bytes(bytes: PackedByteArray) -> Dictionary`.
- Produces: `inspect_validation_bytes(bytes: PackedByteArray) -> Dictionary`.
- Result fields: `code`, `source_version`, `source_checksum`, `episode_id`, `content_contract_id`, `run_stage`, `payload`.
- Inspector never writes files and never mutates GameState.

- [ ] **Step 1 — RED stage matrix 작성**

Fixtures:

```text
mvp-038 preparation             -> PRE_RUN
mvp-039 investigation           -> INVESTIGATION_ACTIVE
mvp-039 resolution_phase_started -> LEGACY_RESCUE_OR_RECOVERY_ACTIVE
mvp-039 completed report        -> LEGACY_COMPLETED
validation-save-v1 active       -> VALIDATION_ACTIVE
validation-save-v1 suspended    -> VALIDATION_SUSPENDED
validation-save-v1 completed    -> VALIDATION_COMPLETED
```

각 fixture에서 `source_checksum`이 동일 bytes에는 동일하고 한 byte 변경 시 달라야 한다.

- [ ] **Step 2 — RED 실행**

```bash
godot --headless --path . --script res://tests/afterlife_migration/afterlife_legacy_save_inspector_test.gd
```

Expected: FAIL — inspector preload 실패.

- [ ] **Step 3 — 최소 구현**

```gdscript
class_name AfterlifeLegacySaveInspector
extends RefCounted

const MAIN_READABLE := ["mvp-038", "mvp-039"]
const VALIDATION_READABLE := ["validation-save-v1"]

func inspect_main_bytes(bytes: PackedByteArray) -> Dictionary:
	return _inspect(bytes, MAIN_READABLE, false)

func inspect_validation_bytes(bytes: PackedByteArray) -> Dictionary:
	return _inspect(bytes, VALIDATION_READABLE, true)
```

stage는 승인된 명시적 flags·scene·lifecycle만 사용한다. 알 수 없는 조합은 추정하지 않고 `CORRUPT_MIGRATION_SOURCE` 또는 `AMBIGUOUS_LEGACY_STAGE`로 닫는다.

- [ ] **Step 4 — GREEN 및 focused 검증**

```bash
godot --headless --path . --script res://tests/afterlife_migration/afterlife_legacy_save_inspector_test.gd
```

Expected: PASS — 버전·checksum·stage 판정, no write.

- [ ] **Step 5 — 회귀**

```bash
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_validation_package_1_tests.sh
```

Expected: 기존 Validation inspect 의미 유지.

- [ ] **Step 6 — 커밋**

```bash
git add scripts/core/afterlife_legacy_save_inspector.gd tests/afterlife_migration/
git commit -m "feat: inspect legacy Afterlife saves without mutation"
```

---

### Task 5: Main Save Memory Migration to mvp-040

**Files:**
- Create: `scripts/core/afterlife_main_save_migrator.gd`
- Create: `tests/afterlife_migration/afterlife_main_save_migrator_test.gd`

**Interfaces:**
- Consumes: inspector result and `AfterlifeIdMigrationRegistry`.
- Produces: `migrate(inspected: Dictionary, registry: Object) -> Dictionary`.
- Result: `{"ok": bool, "code": String, "payload": Dictionary, "migration_history": Array}`.
- No file I/O.

- [ ] **Step 1 — RED stage-specific expectations 작성**

```gdscript
var investigation := migrator.migrate(inspected_investigation, registry)
_expect(investigation.get("code") == "MIGRATED_FROM_MVP_039", "wrong code")
var manual := investigation.get("payload", {}).get("afterlife_canon_v2", {}).get("manual", {})
_expect(manual.get("state") == "draft_active", "manual state changed")
_expect(manual.get("filled_slots", {}).is_empty(), "answer slots auto-filled")
_expect(_all_records_are_unverified(manual.get("evidence_records", [])), "migrated evidence leaked correctness")

var combat := migrator.migrate(inspected_combat, registry)
_expect(combat.get("code") == "LEGACY_CASE_RESTART_REQUIRED", "combat should restart")
_expect(combat.get("payload", {}).get("restart_penalty", 1) == 0, "restart penalty added")

var completed := migrator.migrate(inspected_completed, registry)
_expect(completed.get("payload", {}).has("legacy_resolution_snapshot"), "history lost")
_expect(_reward_ids_unchanged(before, completed), "reward regranted")
```

- [ ] **Step 2 — RED 실행**

```bash
godot --headless --path . --script res://tests/afterlife_migration/afterlife_main_save_migrator_test.gd
```

Expected: FAIL — main migrator 부재.

- [ ] **Step 3 — 최소 구현**

```gdscript
class_name AfterlifeMainSaveMigrator
extends RefCounted

const TARGET_VERSION := "mvp-040"

func migrate(inspected: Dictionary, registry: Object) -> Dictionary:
	var payload: Dictionary = (inspected.get("payload", {}) as Dictionary).duplicate(true)
	match String(inspected.get("run_stage", "")):
		"PRE_RUN": _prepare_new_v2_run(payload)
		"INVESTIGATION_ACTIVE": _migrate_investigation(payload, registry)
		"LEGACY_RESCUE_OR_RECOVERY_ACTIVE": _mark_safe_restart(payload)
		"LEGACY_COMPLETED": _preserve_completed_snapshot(payload)
		_: return {"ok": false, "code": "CORRUPT_MIGRATION_SOURCE"}
	payload["save_version"] = TARGET_VERSION
	return {"ok": true, "code": _result_code(inspected), "payload": payload}
```

보호 필드는 campaign·economy·inventory·equipment·faction·relationship·unlock·reports·reward claims다. 허용 target 이외 차이는 test support의 semantic diff로 실패시킨다.

- [ ] **Step 4 — GREEN 및 focused 검증**

```bash
godot --headless --path . --script res://tests/afterlife_migration/afterlife_main_save_migrator_test.gd
```

Expected: PASS — four stage policies, no answer leak, no reward duplication.

- [ ] **Step 5 — 회귀**

```bash
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_annual_mvp_001_tests.sh
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_annual_mvp_002_tests.sh
```

Expected: campaign·economy·ANNUAL state behavior unchanged.

- [ ] **Step 6 — 커밋**

```bash
git add scripts/core/afterlife_main_save_migrator.gd tests/afterlife_migration/afterlife_main_save_migrator_test.gd
git commit -m "feat: migrate legacy main saves to mvp-040 in memory"
```

---

### Task 6: Validation Save Memory Migration to validation-save-v2

**Files:**
- Create: `scripts/core/afterlife_validation_save_migrator.gd`
- Create: `tests/afterlife_migration/afterlife_validation_save_migrator_test.gd`

**Interfaces:**
- Consumes: validation inspector result and registry.
- Produces: `migrate(inspected: Dictionary, registry: Object) -> Dictionary`.
- Produces v2 payload with `payload_schema: 2`, `content_contract_id`, `migration_history`, `legacy_validation_snapshot`.
- No Legacy file access and no GameState hidden-state mutation.

- [ ] **Step 1 — RED Validation lifecycle matrix 작성**

```gdscript
var active := migrator.migrate(active_v1, registry)
_expect(active.get("code") == "MIGRATED_FROM_VALIDATION_V1", "active migration failed")
_expect(active.get("payload", {}).get("session", {}).get("checkpoint_id") == "afterlife:v2:safe-investigation-entry", "unsafe resume")
_expect(active.get("payload", {}).get("snapshots", {}).get("recovery", {}).is_empty(), "legacy recovery remained active")

var completed := migrator.migrate(completed_v1, registry)
_expect(completed.get("payload", {}).get("legacy_validation_snapshot", {}).get("read_only") == true, "completed history mutable")
_expect(not completed.get("payload", {}).get("result", {}).get("applied_effect_ids", {}).has("validation:afterlife:completion:v2"), "v2 reward inferred")
```

Legacy file bytes와 hidden snapshot을 전후 비교하는 assertion을 포함한다.

- [ ] **Step 2 — RED 실행**

```bash
godot --headless --path . --script res://tests/afterlife_migration/afterlife_validation_save_migrator_test.gd
```

Expected: FAIL — Validation migrator 부재.

- [ ] **Step 3 — 최소 구현**

```gdscript
class_name AfterlifeValidationSaveMigrator
extends RefCounted

const TARGET_VERSION := "validation-save-v2"
const TARGET_SCHEMA := 2

func migrate(inspected: Dictionary, registry: Object) -> Dictionary:
	# completed -> read-only historical snapshot
	# active/suspended -> safe investigation checkpoint + unverified notes
	# no legacy response or reward promotion
	return result
```

`reasoning_state`의 구형 clue는 migration note와 `migrated_unverified` record로만 변환한다. `route_state.correct_response_id`는 기록 문자열로 보존하되 새 response로 적용하지 않는다.

- [ ] **Step 4 — GREEN 및 focused 검증**

```bash
godot --headless --path . --script res://tests/afterlife_migration/afterlife_validation_save_migrator_test.gd
```

Expected: PASS — active/suspended safe checkpoint, completed read-only, isolation intact.

- [ ] **Step 5 — 회귀**

```bash
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_validation_package_1_tests.sh
```

Expected: v1 기존 저장 격리 계약 PASS.

- [ ] **Step 6 — 커밋**

```bash
git add scripts/core/afterlife_validation_save_migrator.gd tests/afterlife_migration/afterlife_validation_save_migrator_test.gd
git commit -m "feat: migrate Validation v1 sessions to v2 in memory"
```

---

### Task 7: Backup-First Atomic Migration Transaction

**Files:**
- Create: `scripts/core/afterlife_migration_transaction.gd`
- Create: `tests/afterlife_migration/afterlife_migration_transaction_test.gd`
- Modify: `tests/afterlife_migration/afterlife_migration_test_support.gd`

**Interfaces:**
- Produces: `migrate_file(primary_path: String, inspected: Dictionary, target_payload: Dictionary, validator: Callable) -> Dictionary`.
- Result codes: `OK`, `SOURCE_CHANGED`, `WRITE_FAILED`, `VERIFY_FAILED`, `REPLACE_FAILED`, `MIGRATION_VALIDATION_FAILED`, `ROLLBACK_RESTORED`.
- Transaction owns file replacement; migrators never open files.

- [ ] **Step 1 — RED failure injection matrix 작성**

검증 시나리오:

```text
success                    -> backup + new primary + final readback
source checksum changed    -> SOURCE_CHANGED, no file mutation
invalid target             -> MIGRATION_VALIDATION_FAILED, original bytes intact
temp write failure         -> WRITE_FAILED, original bytes intact
promote failure            -> ROLLBACK_RESTORED
final readback mismatch    -> ROLLBACK_RESTORED
second identical migration -> no duplicate migration_history/effect_id
```

- [ ] **Step 2 — RED 실행**

```bash
godot --headless --path . --script res://tests/afterlife_migration/afterlife_migration_transaction_test.gd
```

Expected: FAIL — transaction preload 실패.

- [ ] **Step 3 — 최소 구현**

```gdscript
class_name AfterlifeMigrationTransaction
extends RefCounted

func migrate_file(primary_path: String, inspected: Dictionary, target_payload: Dictionary, validator: Callable) -> Dictionary:
	var source_bytes := FileAccess.get_file_as_bytes(primary_path)
	if _sha256(source_bytes) != String(inspected.get("source_checksum", "")):
		return _result(false, "SOURCE_CHANGED")
	# write temp -> readback -> validate -> backup primary -> atomic replace
	# final readback failure restores backup
	return _result(true, "OK")
```

기존 `ValidationSaveRepository.write_payload()`의 temp·backup·rename·final inspect 순서를 공통 transaction으로 추출하거나 동일 계약을 재사용한다. 플랫폼 rename 실패를 주입할 test seam을 생성한다.

- [ ] **Step 4 — GREEN 및 focused 검증**

```bash
godot --headless --path . --script res://tests/afterlife_migration/afterlife_migration_transaction_test.gd
```

Expected: PASS — checksum lock, atomic replace, rollback, idempotency.

- [ ] **Step 5 — 회귀**

```bash
godot --headless --path . --script res://tests/validation/validation_save_repository_test.gd
```

Expected: 기존 repository atomic persistence PASS.

- [ ] **Step 6 — 커밋**

```bash
git add scripts/core/afterlife_migration_transaction.gd tests/afterlife_migration/
git commit -m "feat: add backup-first atomic migration transaction"
```

---

### Task 8: GameState and Validation Runtime Integration

**Files:**
- Modify: `scripts/core/game_state.gd:1-20, 2750-3050`
- Modify: `scripts/core/validation_save_repository.gd:1-220`
- Modify: `scripts/core/validation_session.gd:1-330`
- Create: `tests/afterlife_migration/afterlife_migration_integration_test.gd`

**Interfaces:**
- `GameState.load_game() -> bool` inspects and migrates mvp-038/039 before mutating live memory.
- `GameState.save_game() -> bool` writes only `mvp-040` through transaction-safe repository behavior.
- `ValidationSaveRepository.inspect()` recognizes v1 as migratable and v2 as exact.
- `ValidationSession.load(game_state)` migrates v1 in memory, restores only after validation, then writes v2 through its own file boundary.

- [ ] **Step 1 — RED end-to-end fixtures 작성**

```gdscript
_expect(_load_main_fixture("mvp039_investigation.json").get("save_version") == "mvp-040", "main not upgraded")
_expect(GameState.get_current_episode_id() == "episode_001_afterlife_station", "episode identity split")
_expect(GameState.get_afterlife_content_contract_id() == "afterlife-station-canon-v2", "contract not active")
_expect(GameState.get_afterlife_manual_state().get("filled_slots", {}).is_empty(), "answer auto-filled")

var combat_result := GameState.inspect_last_migration_result()
_expect(combat_result.get("code") == "LEGACY_CASE_RESTART_REQUIRED", "unsafe combat resume")

var validation_before := Support.read_bytes(LEGACY_PATH)
var validation_result := ValidationSession.load(GameState)
_expect(validation_result.get("code") == "OK", "validation v1 load failed")
_expect(Support.read_bytes(LEGACY_PATH) == validation_before, "validation touched legacy bytes")
```

corrupt source, source checksum race, unknown ID, completed reward claims, double-load를 포함한다.

- [ ] **Step 2 — RED 실행**

```bash
godot --headless --path . --script res://tests/afterlife_migration/afterlife_migration_integration_test.gd
```

Expected: FAIL — GameState는 아직 `mvp-039`, Validation은 v1만 exact 처리.

- [ ] **Step 3 — 최소 구현**

`GameState`는 live state를 바로 채우지 않고 다음 순서를 사용한다.

```text
read bytes
→ inspector
→ memory migrator
→ semantic guard
→ transaction write/readback
→ validated payload로 live state restore
```

`SAVE_VERSION := "mvp-040"`로 변경하고 `_make_save_data()`에 `content_contract_id`, `migration_history`, `orphan_legacy_ids`, `afterlife_canon_v2`를 포함한다. Validation repository/session은 v1을 직접 mutate하지 않고 `AfterlifeValidationSaveMigrator`를 거친다. 어떤 실패도 Legacy 저장으로 fallback하지 않는다.

- [ ] **Step 4 — GREEN 및 focused 검증**

```bash
godot --headless --path . --script res://tests/afterlife_migration/afterlife_migration_integration_test.gd
```

Expected: PASS — main/Validation upgrade, isolation, safe restart, no reward duplication.

- [ ] **Step 5 — 회귀**

```bash
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_validation_package_1_tests.sh
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_core_mvp_001_tests.sh
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_annual_mvp_001_tests.sh
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_annual_mvp_002_tests.sh
```

Expected: 모든 focused 패키지 PASS.

- [ ] **Step 6 — 커밋**

```bash
git add scripts/core/game_state.gd scripts/core/validation_save_repository.gd scripts/core/validation_session.gd tests/afterlife_migration/afterlife_migration_integration_test.gd
git commit -m "feat: integrate canon v2 migration with main and validation saves"
```

---

### Task 9: Focused Runner, Full Regression, Evidence, and Approval Checkpoints

**Files:**
- Create: `tests/run_afterlife_canon_v2_migration_tests.sh`
- Modify: `tests/run_godot_regression.sh`
- Modify: `.github/workflows/validate-afterlife-station-canon-v2-migration-design.yml`
- Modify: `.github/workflows/validate-annual-mvp-001.yml`
- Modify: `TEST_CHECKLIST.md`
- Modify: `docs/CURRENT_STATUS.md`
- Modify: `docs/CURRENT_HANDOFF_VALIDATION.md`

**Interfaces:**
- Produces deterministic focused runner with seven entrypoints.
- Produces CI evidence for exact implementation HEAD.
- Does not mark Human QA complete and does not merge PR.

- [ ] **Step 1 — RED runner contract 작성**

```bash
#!/usr/bin/env bash
set -euo pipefail
: "${GODOT_BIN:=godot}"

TESTS=(
  res://tests/afterlife_migration/afterlife_canon_v2_loader_test.gd
  res://tests/afterlife_migration/afterlife_id_migration_registry_test.gd
  res://tests/afterlife_migration/afterlife_legacy_save_inspector_test.gd
  res://tests/afterlife_migration/afterlife_main_save_migrator_test.gd
  res://tests/afterlife_migration/afterlife_validation_save_migrator_test.gd
  res://tests/afterlife_migration/afterlife_migration_transaction_test.gd
  res://tests/afterlife_migration/afterlife_migration_integration_test.gd
)
```

CI는 이 runner가 없거나 한 entrypoint라도 실패하면 실패해야 한다.

- [ ] **Step 2 — RED 실행**

```bash
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_afterlife_canon_v2_migration_tests.sh
```

Expected: FAIL — runner 또는 미완성 entrypoint 부재.

- [ ] **Step 3 — 최소 구현**

runner가 각 test에 독립 HOME/XDG 경로를 제공하고 실패 로그를 보존하도록 작성한다. 두 workflow에 제품 경로 trigger, import, focused runner, full regression, failure artifact 수집을 연결한다.

- [ ] **Step 4 — GREEN 및 focused 검증**

```bash
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_afterlife_canon_v2_migration_tests.sh
```

Expected: `Afterlife canon v2 migration: 7/7 entrypoints passed`.

- [ ] **Step 5 — 전체 회귀**

```bash
godot --headless --path . --import
python -m unittest tests/test_afterlife_station_canon_v2_migration_design.py
python -m unittest tests/test_afterlife_station_canon_v2_implementation_plan.py
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_validation_package_1_tests.sh
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_core_mvp_001_tests.sh
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_annual_mvp_001_tests.sh
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_annual_mvp_002_tests.sh
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" bash tests/run_godot_regression.sh
```

Expected: 전부 exit 0. Runtime implementation evidence만 기록하며 Human QA: NOT_RUN을 유지한다.

- [ ] **Step 6 — 적대적 검토**

다음 실패 시 즉시 조기 체크포인트를 연다.

- episode/victim ID가 바뀜
- v1·v2 pattern이 한 runtime list에 존재
- SPLIT target이 confirmed/correct 상태
- legacy correct_response가 새 response로 활성화
- source_checksum mismatch가 무시됨
- reward claim이 증가함
- Validation 전후 Legacy bytes 또는 hidden state가 달라짐
- rollback 뒤 primary가 원본 bytes와 다름

- [ ] **Step 7 — 문서와 PR 증거 갱신**

`TEST_CHECKLIST.md`와 handoff 문서에는 exact HEAD, 명령, focused·회귀 결과, 변경 파일 수, 미실행 항목을 기록한다. Google Sheet에는 동일 Decision ID로 실제 증거만 동기화한다.

- [ ] **Step 8 — 커밋**

```bash
git add tests/run_afterlife_canon_v2_migration_tests.sh tests/run_godot_regression.sh .github/workflows/ TEST_CHECKLIST.md docs/CURRENT_STATUS.md docs/CURRENT_HANDOFF_VALIDATION.md
git commit -m "test: validate Afterlife canon v2 migration end to end"
```

- [ ] **Step 9 — implementation approval checkpoint**

모든 구현 작업이 GREEN이어도 PR은 Draft를 유지한다. 사용자에게 exact HEAD·CI·적대적 검토·미실행 Human QA를 보고하고 구현 결과 승인 여부를 묻는다.

- [ ] **Step 10 — merge approval checkpoint**

구현 결과 승인과 별개로 사용자가 명시적으로 `병합 승인`하기 전에는 ready 전환·auto-merge·merge를 수행하지 않는다.

---

## Plan Self-Review

### Spec coverage

- Identity·contract·layer ownership: Task 1–2.
- ID disposition·orphan·effect_id: Task 3.
- source version·stage·checksum: Task 4.
- mvp-038/039 → mvp-040: Task 5.
- validation-save-v1 → v2: Task 6.
- backup-first·atomic replace·rollback: Task 7.
- GameState·Validation integration: Task 8.
- focused/full regression·evidence·approval gates: Task 9.

### Type consistency

- 모든 component public result는 `{"ok": bool, "code": String, ...}` 형태다.
- Inspector만 `source_checksum`을 만든다.
- Registry만 ID disposition과 registry checksum을 소유한다.
- Migrator는 Dictionary 변환만 수행한다.
- Transaction만 파일 교체를 수행한다.
- GameState·ValidationSession은 orchestration만 수행한다.

### Scope guard

이 계획은 migration infrastructure와 최소 Canon v2 데이터 계약까지 다룬다. 매뉴얼 화면, 구출 미니게임, 회수 전투 UI·수치, 이미지·자산, Human QA는 별도 Package와 승인 대상이다.

## Current Gate

- Spec: `APPROVED_SPEC`.
- Plan: `IMPLEMENTATION_PLAN_READY`.
- Implementation: `IMPLEMENTATION_NOT_AUTHORIZED`.
- Human QA: `NOT_RUN`.
- Runtime implementation: `NOT_RUN`.
- PR #145: Draft·미병합 유지.

다음 단계는 사용자의 별도 구현 계획 검토와 구현 승인이다. 승인 전에는 Task 1의 제품 RED test도 작성하지 않는다.
