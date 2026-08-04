# Afterlife Station Canon v2 Migration Plan — Adversarial Review Addendum

> 상태: `PLAN_GUARDRAIL_ACTIVE / IMPLEMENTATION_NOT_AUTHORIZED`
> 작성일: `2026-08-05`
> 기준 Plan: `docs/superpowers/plans/2026-08-05-afterlife-station-canon-v2-migration-implementation-plan.md`
> 검토 결과: `2 HIGH-RISK FINDINGS FIXED IN CONTRACT`
> Human QA: NOT_RUN
> Runtime implementation: NOT_RUN

이 문서는 implementation plan Task 1·2·7·8을 이 문서가 보정한다. 본문과 충돌하면 이 Addendum의 computed provenance와 two-phase rollback 계약이 우선한다. 구현 권한이나 병합 권한을 부여하지 않는다.

## 1. 발견 1 — Sidecar가 provenance를 스스로 주장할 위험

### 문제

원 계획 Task 1은 sidecar root key에 `loaded_layers`를 포함하는 것처럼 읽힐 수 있다. 그러나 `loaded_layers`는 실제 loader가 어떤 입력을 읽고 어떤 소유권 규칙을 적용했는지 나타내는 실행 provenance다.

sidecar가 자신의 `loaded_layers`를 선언하고 loader가 이를 신뢰하면 다음 오류가 생긴다.

- 실제로 읽지 않은 `legacy_core_validation`을 읽었다고 표시
- allowlist 검증 전에 `canonical_v2` 소유권을 주장
- fixture나 변조 파일이 provenance를 위조
- base-only 또는 partial load가 full v2 load처럼 보임

### 보정 결정

`loaded_layers는 loader가 계산`한다.

- sidecar의 self-declared loaded_layers를 신뢰하지 않는다.
- sidecar에 `loaded_layers`가 존재하면 schema validator는 `DISALLOWED_SELF_DECLARED_PROVENANCE`로 거부한다.
- sidecar는 `content_contract_id`, `content_schema`, `target_episode_id`, canonical blocks만 선언한다.
- loader는 성공적으로 parse·identity validate·allowlist merge한 layer만 순서대로 기록한다.
- 결과의 `loaded_layers`와 `layer_checksums`는 runtime output이며 원본 JSON에서 복사하지 않는다.

권위 결과 예시:

```gdscript
{
	"ok": true,
	"code": "EXACT_V2",
	"episode": merged_episode,
	"loaded_layers": ["base_episode", "legacy_core_validation", "canonical_v2"],
	"layer_checksums": {
		"base_episode": base_checksum,
		"legacy_core_validation": legacy_checksum,
		"canonical_v2": canon_checksum
	}
}
```

### Task 보정

- Task 1 RED에서 sidecar root `loaded_layers` 요구를 제거한다.
- 대신 sidecar에 self-declared `loaded_layers`가 있으면 실패하는 test fixture를 둔다.
- Task 2 RED에서 loader가 계산한 `loaded_layers`와 `layer_checksums`를 검증한다.

## 2. 발견 2 — Primary 교체 뒤 Runtime apply 실패 시 반쪽 migration 위험

### 문제

원 계획 Task 8의 단순 순서:

```text
transaction write/readback
→ validated payload로 live state restore
```

이 순서에서 primary가 v2로 교체된 뒤 GameState 또는 ValidationSession의 runtime apply가 실패하면 파일은 v2, 메모리는 legacy 또는 부분 적용 상태가 될 수 있다. 이는 승인 Spec의 “실패 시 기존 파일과 메모리 모두 변경하지 않는다”와 충돌한다.

### 보정 결정 — Two-phase transaction handle

`AfterlifeMigrationTransaction`은 단일 `migrate_file()` 성공 반환으로 끝내지 않는다. 다음 상태기를 제공한다.

```text
NEW
→ PREPARED
→ COMMITTED_PENDING_RUNTIME_APPLY
→ FINALIZED
```

실패 경로:

```text
PREPARED
→ ABORTED

COMMITTED_PENDING_RUNTIME_APPLY
→ ROLLBACK_RESTORED
```

#### PREPARED

- 원본 bytes 읽기
- inspect 시 `source_checksum`과 현재 bytes checksum 비교
- target temp 작성
- temp 재읽기·schema·semantic validator 실행
- primary와 같은 디렉터리에 immutable backup 생성
- 아직 primary와 runtime memory를 최종 확정하지 않음

#### COMMITTED_PENDING_RUNTIME_APPLY

- temp를 primary로 promote
- 최종 primary 재읽기 검증
- backup과 transaction journal 유지
- `migration_history`는 pending 상태
- runtime apply 결과 전에는 성공으로 외부 보고하지 않음

#### FINALIZED

- runtime apply 성공 확인
- `migration_history` 상태를 finalized로 기록
- transaction journal 정리
- backup 보존 정책에 따라 이전 세대 backup 정리

### 필수 API

```gdscript
class_name AfterlifeMigrationTransaction
extends RefCounted

func prepare(
	primary_path: String,
	inspected: Dictionary,
	target_payload: Dictionary,
	validator: Callable
) -> Dictionary

func commit_prepared(handle: Dictionary) -> Dictionary

func finalize(handle: Dictionary) -> Dictionary

func rollback_last_commit(handle: Dictionary) -> Dictionary

func abort_prepared(handle: Dictionary) -> Dictionary
```

handle 최소 필드:

```yaml
transaction_id: string
state: NEW | PREPARED | COMMITTED_PENDING_RUNTIME_APPLY | FINALIZED | ABORTED | ROLLBACK_RESTORED
primary_path: string
temp_path: string
backup_path: string
source_checksum: string
target_checksum: string
migration_id: afterlife-station-canon-v2-001
```

## 3. Runtime coordinator 계약

GameState와 ValidationSession은 다음 순서를 따른다.

```text
1. source bytes inspect
2. original memory semantic snapshot
3. pure memory migration
4. target schema·semantic validation
5. transaction.prepare
6. transaction.commit_prepared
7. validated target를 live runtime에 apply
8-A. apply 성공 → transaction.finalize
8-B. apply 실패 → original memory restore + rollback_last_commit
```

`runtime apply 실패 시 파일과 메모리 모두 복원`한다.

복원 성공 조건:

- primary bytes == original source bytes
- runtime semantic snapshot == original snapshot
- reward claims·campaign·economy·relationship unchanged
- journal state == `ROLLBACK_RESTORED`
- v2 effect_id가 finalized history에 없음

복원 중 하나라도 실패하면 정상 게임 진행을 허용하지 않고 `MIGRATION_FATAL_RECOVERY_REQUIRED` 조기 체크포인트를 연다. 이 상태에서는 Legacy 저장으로 fallback하지 않는다.

## 4. Crash recovery

프로세스가 `COMMITTED_PENDING_RUNTIME_APPLY`에서 종료될 수 있다. 다음 시작 시 transaction journal을 먼저 검사한다.

- journal 없음: 정상 inspect 진행
- `PREPARED`: temp를 폐기하고 original primary 유지, `ABORTED`
- `COMMITTED_PENDING_RUNTIME_APPLY`: backup checksum과 primary checksum을 검증한 후 original primary로 rollback, `ROLLBACK_RESTORED`
- `FINALIZED`: migration history와 primary target checksum을 검증하고 정상 진행
- journal·backup 불일치: `MIGRATION_FATAL_RECOVERY_REQUIRED`

게임은 pending commit을 성공 migration으로 추정하지 않는다.

## 5. TDD 보정

### Loader RED

```gdscript
var malicious := _load_fixture("canon_v2_self_declared_layers.json")
_expect(malicious.get("code") == "DISALLOWED_SELF_DECLARED_PROVENANCE", "sidecar forged provenance")
```

### Loader GREEN

loader output의 `loaded_layers`는 실제 parse 성공 layer와 checksum으로만 생성한다.

### Transaction RED

```gdscript
var prepared := transaction.prepare(primary, inspected, target, validator)
_expect(prepared.get("state") == "PREPARED", "prepare failed")

var committed := transaction.commit_prepared(prepared)
_expect(committed.get("state") == "COMMITTED_PENDING_RUNTIME_APPLY", "commit state wrong")

var runtime_result := runtime_adapter.apply_payload(target)
_expect(runtime_result.get("code") == "INJECTED_RUNTIME_APPLY_FAILURE", "failure seam missing")

var memory_restored := runtime_adapter.restore_snapshot(original_memory)
var rolled_back := transaction.rollback_last_commit(committed)
_expect(memory_restored.get("code") == "OK", "memory rollback failed")
_expect(rolled_back.get("state") == "ROLLBACK_RESTORED", "file rollback failed")
_expect(Support.read_bytes(primary) == original_bytes, "primary bytes changed")
```

Expected: FAIL before two-phase API exists.

### Transaction GREEN

- success: PREPARED → COMMITTED_PENDING_RUNTIME_APPLY → FINALIZED
- validator failure: PREPARED 이전에 file mutation 없음
- source checksum race: `SOURCE_CHANGED`
- runtime apply failure: memory restore + `rollback_last_commit`
- crash journal recovery: pending state rolls back
- repeated finalized migration: no duplicate effect or history

### focused 및 회귀

Task 7 focused test와 Task 8 integration test 모두 이 Addendum을 검증한다. 전체 Godot 회귀 전에는 두 test가 독립적으로 GREEN이어야 한다.

## 6. 책임 경계 유지

Two-phase API가 추가돼도 다음 분리는 유지한다.

- Inspector: bytes·version·stage·source_checksum 판정만
- Registry: ID disposition·registry checksum·effect_id만
- Migrator: pure Dictionary 변환만
- Transaction: temp·backup·promote·journal·file rollback만
- GameState/ValidationSession: original memory snapshot·runtime apply·memory rollback orchestration

Transaction이 GameState 필드를 직접 수정하지 않고, GameState가 raw file rename을 직접 수행하지 않는다.

## 7. 적대적 검토 결론

보정 후 다음 고위험 실패가 차단된다.

- sidecar provenance 위조
- 실제 layer와 표시 layer 불일치
- primary v2·memory legacy 반쪽 상태
- runtime apply 실패 뒤 보상·campaign 일부 반영
- pending commit을 다음 시작에서 성공으로 오인

현재 상태:

- Spec: `APPROVED_SPEC`
- Plan + Addendum: `IMPLEMENTATION_PLAN_READY`
- Implementation: `IMPLEMENTATION_NOT_AUTHORIZED`
- Human QA: NOT_RUN
- Runtime implementation: NOT_RUN
- PR merge: 별도 승인

이 Addendum 작성은 구현이 아니다. 별도 implementation approval checkpoint 전에는 제품 코드·JSON·Schema를 변경하지 않는다.
