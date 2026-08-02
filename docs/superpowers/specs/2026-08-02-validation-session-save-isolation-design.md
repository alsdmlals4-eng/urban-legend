# Package 1 Design — Validation Session·Save Isolation

> Spec 상태: `REVIEW_READY`
> 작성일: 2026-08-02
> 기준 main: `7277b9cececa56532f7b0d11c1a02fd3d5642750`
> 작업 Branch: `agent/v9-4-canon-reconciliation`
> 승인 Decision:
> - `D-2026-08-02-PACKAGE-1-PLANNING-APPROVAL`
> - `D-2026-08-02-VALIDATION-PERSISTENCE-BOUNDARY`
> 상위 Proposal: `P-2026-08-02-VALIDATION-CHANGE-PROPOSAL`
> 구현 권한: `NOT_AUTHORIZED`

## 1. 목적

Package 1은 Validation 버티컬 슬라이스를 위한 **독립 Session과 독립 저장 경계**를 설계한다.

플레이어가 관찰할 최종 결과는 후속 Package까지 포함해야 나타나지만, Package 1이 보장해야 하는 기반은 다음과 같다.

```text
Validation 진행을 저장·복원·삭제·완료해도
기존 Legacy 진행과 숨은 캠페인 상태는 변하지 않는다.
```

이 Spec은 코드 구현 계약을 만들기 위한 설계 문서이며 제품 코드·Scene·JSON·Schema를 변경하지 않는다.

## 2. 보호할 기존 강점

1. `GameState`의 기존 `mvp-039` Legacy 저장·불러오기·초기화 의미
2. `mvp-038` migration 지원
3. ANNUAL PoC 저장과 Scene
4. 기존 dialogue/investigation/minigame/battle 전문 절차
5. `core_validation_*`, `mvp043_*` 회귀가 보호하는 정상 경로
6. 승인된 저승역 SCREEN/SIT Target
7. 사용자의 명시적 승인 없이는 제품 구현하지 않는 Gate

## 3. 확정 범위

### 3.1 In Scope

- `ValidationSession` 책임·상태·활성화 계약
- `ValidationSaveRepository` 파일 형식·검증·원자적 저장·손상 격리
- `GameState`와의 최소 runtime snapshot adapter 계약
- Validation 활성 시 자동 저장 라우팅 계약
- Legacy file·memory no-effect 계약
- Session lifecycle: create, activate, capture, save, load, abandon, delete, complete, deactivate
- 버전·손상·호환성 판정 Matrix
- Package 1용 자동 테스트 설계
- 롤백 경계

### 3.2 Out of Scope

- 메인 메뉴의 실제 저장 선택 UI
- Validation 이어하기 카드·삭제 확인·덮어쓰기 UX
- 축약 준비·Reasoning·결과 Scene
- episode JSON의 `validation_case`
- 노선·회수 adapter
- 결과 4축 calculator의 실제 구현
- 본편 가져오기·공용 프로필
- 제품 코드·Scene·JSON·workflow 구현
- 모바일 대응
- PR 병합

## 4. 핵심 설계 원칙

### 4.1 완전 독립 영속성

```text
Validation repository owns Validation persistence.
GameState owns Legacy persistence.
Neither repository imports or mutates the other in Package 1.
```

Validation 완료 기록은 Validation 저장에만 남는다. 본편 보고서·보상·해금·일정·관계에 반영하지 않는다.

### 4.2 명시적 활성화

Validation mode를 다음으로 추정하지 않는다.

- 현재 Scene 경로
- 현재 episode ID 하나만의 일치
- Legacy flag
- 저장 파일 존재 여부
- 전역 Dictionary의 임의 값

활성화는 `ValidationSession.activate()`의 성공으로만 성립한다.

### 4.3 Fail Closed

Session token, schema version, episode ID, lifecycle state 가운데 하나라도 유효하지 않으면:

- Validation 저장 금지
- Legacy 저장으로 fallback 금지
- Legacy 파일·메모리 변경 금지
- 호출자에게 명시적 오류 반환
- 손상 원본은 자동 삭제 금지

### 4.4 Field-Level Whitelist

`GameState._make_save_data()` 전체를 복사하거나 denylist로 제거하지 않는다. Validation에 필요한 필드만 명시적으로 선택한다.

### 4.5 파일과 메모리 모두 무부작용

Legacy 파일 bytes만 보호하면 충분하지 않다. Validation 작업 전후 아래 숨은 상태 Snapshot도 동일해야 한다.

- campaign schedule·operation·resolved cases
- economy·echo·inventory·consumables
- faction·request·market
- relationship·long-term unlock
- daily episode
- ANNUAL PoC state

## 5. 구성요소

## 5.1 ValidationSession

예상 위치: `scripts/core/validation_session.gd`

책임:

- Validation 활성 여부와 lifecycle
- Session token
- episode·flow stage·checkpoint·return target·focus token
- specialist 완료 요약
- runtime snapshot
- recovery-use ledger
- result axes와 apply-once IDs를 담을 영속 컨테이너
- repository 호출 조정

소유하지 않음:

- Legacy 파일 I/O
- 캠페인·경제·관계 상태
- battle의 프레임별 선택·현재 UI 단계
- route board의 프레임별 조작
- Scene 이동 구현
- 결과 등급 계산 규칙
- 본편 import

### 상태

```yaml
mode: inactive | validation
lifecycle: empty | active | suspended | completed | corrupt | incompatible
session_token: string
save_version: validation-save-v1
episode_id: episode_001_afterlife_station
flow_stage: string
checkpoint_id: string
return_target: string
focus_token: string
runtime_snapshot: dictionary
preparation_snapshot: dictionary
reasoning_state: dictionary
route_state: dictionary
recovery_progress: dictionary
result_axes: dictionary
candidate_records: dictionary
applied_effect_ids: dictionary
created_at_utc: string
updated_at_utc: string
completed_at_utc: string | empty
revision: integer
```

### 권장 기본값

```yaml
validation_slot_count: 1
initial_revision: 0
mode_default: inactive
lifecycle_default: empty
session_token_bytes: 16
save_version: validation-save-v1
normal_backup_generations: 1
```

`session_token_bytes`는 보안 토큰이 아니라 잘못된 Session 결합을 방지하는 실행 식별자다. 구현 환경에서 안정적인 UUID가 이미 제공되면 UUID 사용을 우선한다.

### 필수 API 계약

```text
inspect() -> SessionInspection
create(episode_id) -> Result
activate(session_token) -> Result
capture_runtime(game_state) -> Result
save() -> Result
load() -> Result
suspend() -> Result
resume() -> Result
complete(completion_payload) -> Result
abandon_runtime() -> Result
delete_persistence() -> Result
deactivate() -> Result
reset_in_memory() -> void
```

API는 `bool`만 반환하지 않고 오류 코드와 안전한 사용자 표시용 분류를 함께 반환한다.

## 5.2 ValidationSaveRepository

예상 위치: `scripts/core/validation_save_repository.gd`

파일:

```yaml
primary: user://urban_legend_validation_save.json
backup: user://urban_legend_validation_save.bak.json
temp: user://urban_legend_validation_save.tmp.json
quarantine_prefix: user://urban_legend_validation_save.corrupt.
legacy_forbidden: user://urban_legend_save.json
```

책임:

- 파일 존재·metadata inspection
- JSON parsing
- schema version 판정
- payload validation
- temp write → flush → readback validate → replace
- 정상 primary 교체 전 backup 1세대 유지
- corrupt 원본 격리
- Validation 파일 삭제

금지:

- Legacy 파일 read/write/delete
- Legacy 저장을 backup으로 사용
- newer incompatible 저장 downgrade
- corrupt 저장 자동 삭제
- validation payload의 unknown effect 실행
- 불완전한 temp 파일을 primary로 승격

### 저장 순서

```text
1. Session payload 생성
2. 구조·필수 키·ID·revision 검증
3. temp에 UTF-8 JSON 작성
4. flush·close
5. temp 재읽기·재검증
6. 기존 primary가 정상일 때 backup으로 교체
7. temp를 primary로 원자적 교체
8. primary 재검증
9. 성공 결과 반환
```

플랫폼에서 진정한 atomic rename이 보장되지 않으면 가장 가까운 replace 절차를 사용하고, 중간 실패 상태를 테스트 Fixture로 명시한다.

## 5.3 GameState Validation Adapter

예상 수정 위치: `scripts/core/game_state.gd`

새 책임을 GameState에 흡수하지 않는다. 다음의 좁은 adapter만 허용한다.

```text
export_validation_runtime_snapshot() -> Dictionary
restore_validation_runtime_snapshot(snapshot) -> Result
snapshot_hidden_legacy_state_for_test() -> Dictionary
save_active_session() -> Result
```

### Whitelist

허용 후보:

- current episode ID·path
- current dialogue node ID
- current investigation field/node ID
- current minigame ID·Validation 결과 요약
- Validation에 선택된 agent stable IDs
- Validation 사건에 필요한 flag stable IDs
- collected clue stable IDs
- seen hint stable IDs
- selected method stable ID
- recovery pattern learning·manual record 중 Validation 사건 범위
- agent/victim의 사건 한정 상태

제외:

- 전체 campaign object
- schedule·operation·resolved case
- daily episode
- echo·currency·inventory·purchase
- faction·request·market
- relationship·장기 unlock
- 전체 report/manual collections
- ANNUAL state
- Legacy save version·migration metadata

### Restore 원칙

- whitelist 외 필드는 읽지 않는다.
- unknown stable ID는 orphan metadata로 보존하되 runtime 적용하지 않는다.
- 필요한 episode data가 없으면 `INCOMPATIBLE_CONTENT`로 중단한다.
- 부분 복원 실패 시 적용 전 Snapshot으로 되돌리거나 적용을 시작하지 않는다.
- restore 과정에서 자동 Legacy save를 호출하지 않는다.

## 5.4 Save Routing

기존 Scene은 `GameState.save_game()`을 직접 호출한다. Package 1 구현 계획에서는 다음 호환 경계를 설계한다.

```text
save_game request
├─ ValidationSession is explicitly active and valid
│  ├─ export whitelist snapshot
│  ├─ ValidationSession.capture
│  ├─ Validation repository save
│  └─ Legacy write prohibited
└─ Validation inactive
   └─ existing Legacy save behavior unchanged
```

중요:

- 활성 Session이 유효하지 않으면 Legacy로 fallback하지 않는다.
- Validation 저장 실패 뒤 Legacy 저장으로 대신 성공 처리하지 않는다.
- inactive 경로의 Legacy 직렬화 형식·파일 경로·migration 의미를 바꾸지 않는다.

## 6. 저장 문서 구조

```json
{
  "format": "urban-legend-validation-save",
  "version": "validation-save-v1",
  "revision": 1,
  "session": {
    "token": "opaque-id",
    "lifecycle": "active",
    "episode_id": "episode_001_afterlife_station",
    "flow_stage": "SIT-004",
    "checkpoint_id": "investigation:platform:observation-02",
    "return_target": "investigation:platform",
    "focus_token": "record-drawer:last-row"
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
    "created_at_utc": "ISO-8601",
    "updated_at_utc": "ISO-8601",
    "completed_at_utc": ""
  },
  "integrity": {
    "payload_schema": 1,
    "content_episode_id": "episode_001_afterlife_station"
  }
}
```

JSON key 순서는 권위가 아니다. 의미·필수 키·타입·stable ID만 계약이다.

## 7. 버전·손상 판정 Matrix

| 상태 | 판정 | 읽기 | 쓰기 | 자동 삭제 | Legacy 영향 |
|---|---|---:|---:|---:|---:|
| 파일 없음 | `EMPTY` | 가능 | 새 작성 가능 | 해당 없음 | 0 |
| v1 정상 | `EXACT` | 가능 | 가능 | 금지 | 0 |
| 구버전 + 등록 migration | `MIGRATABLE` | preview 가능 | 명시 migration 뒤 가능 | 금지 | 0 |
| 구버전 + migration 없음 | `INCOMPATIBLE_OLDER` | inspect만 | 금지 | 금지 | 0 |
| 신버전 | `INCOMPATIBLE_NEWER` | inspect만 | 금지 | 금지 | 0 |
| JSON parse 실패 | `CORRUPT` | metadata만 | primary 덮어쓰기 금지 | 금지 | 0 |
| 필수 키·타입 실패 | `CORRUPT_SCHEMA` | metadata만 | primary 덮어쓰기 금지 | 금지 | 0 |
| content ID 없음 | `INCOMPATIBLE_CONTENT` | metadata만 | 금지 | 금지 | 0 |
| temp만 존재 | `INTERRUPTED_WRITE` | 검증 뒤 복구 후보 | primary 자동 교체 금지 | 금지 | 0 |
| 정상 backup만 존재 | `RECOVERABLE_BACKUP` | preview 가능 | 명시 복구 뒤 가능 | 금지 | 0 |

Package 1은 migration framework의 경계만 설계한다. 실제 v0 migration은 실제 과거 Validation 저장이 없으므로 만들지 않는다.

## 8. Lifecycle

### 8.1 Create

- 기존 Validation 저장 존재 여부 inspect
- Package 2 UX 전에는 자동 덮어쓰기 금지
- 새 token과 revision 0 생성
- 메모리에 active Session 준비
- Legacy 상태 변경 금지

### 8.2 Activate

조건:

- mode가 inactive
- Session token 유효
- episode ID 허용
- version exact
- lifecycle active 또는 suspended

실패 시 fail-closed.

### 8.3 Save

- whitelist runtime capture
- revision +1
- updated timestamp 갱신
- repository atomic write
- Legacy bytes와 hidden Snapshot 비교는 테스트가 담당

### 8.4 Load/Resume

- inspect → exact validation → Session restore
- GameState whitelist restore
- flow_stage → checkpoint → return_target → scene fallback 우선순위 유지
- 실제 Scene 이동은 Package 3 이후 책임

### 8.5 Abandon Runtime

- 현재 메모리 Session만 종료
- Validation 저장 파일 유지
- Legacy 상태 변경 금지

### 8.6 Delete Persistence

- Validation primary·backup·temp만 대상으로 함
- corrupt quarantine는 별도 명시적 정리 전 보존
- Legacy file 경로 접근 금지

### 8.7 Complete

- lifecycle을 completed로 전환
- completion payload와 apply-once IDs 기록
- completed timestamp 저장
- Legacy report/reward/unlock/campaign 함수 호출 금지
- 완료 저장은 계속 Validation 저장 종류로 inspect 가능

### 8.8 Deactivate

- Validation mode inactive
- 메모리 Session 제거
- 저장 파일 유지 여부는 호출 목적에 따라 별도 명령이 결정
- Legacy 상태를 reset하지 않음

## 9. 오류 계약

권장 오류 코드:

```text
OK
NO_SAVE
ALREADY_EXISTS
SESSION_NOT_ACTIVE
SESSION_ALREADY_ACTIVE
SESSION_TOKEN_MISMATCH
INVALID_LIFECYCLE
INVALID_EPISODE
INVALID_STAGE
INVALID_CHECKPOINT
INVALID_PAYLOAD
CORRUPT_JSON
CORRUPT_SCHEMA
INCOMPATIBLE_OLDER
INCOMPATIBLE_NEWER
INCOMPATIBLE_CONTENT
INTERRUPTED_WRITE
READ_FAILED
WRITE_FAILED
VERIFY_FAILED
REPLACE_FAILED
RESTORE_FAILED
LEGACY_GUARD_VIOLATION
HIDDEN_STATE_GUARD_VIOLATION
ALREADY_COMPLETED
ALREADY_APPLIED
```

오류 메시지와 내부 원인을 분리한다. 제품 UI 문구는 Package 2에서 설계하며, Package 1 테스트는 오류 코드와 no-effect만 검증한다.

## 10. Idempotency

- 같은 revision 저장 재요청은 새 revision을 만들 수 있으나 payload 효과를 재적용하지 않는다.
- 완료 transaction은 `completion` effect ID로 한 번만 기록한다.
- unknown effect ID는 저장 가능 metadata와 실행 가능 ID를 구분한다.
- Session restore는 report/reward/unlock을 실행하지 않는다.
- delete 재호출은 `NO_SAVE` 또는 성공적인 no-op로 일관되게 처리하며 Legacy에는 영향이 없다.

Package 1 권장 completion ID:

```text
validation:afterlife:completion:v1
```

보고서·매뉴얼·연구·보급 후보의 실제 apply-once ID는 Package 8에서 사용하지만 저장 필드는 Package 1부터 예약한다.

## 11. 테스트 설계

### 11.1 Test Fixtures

- 정상 Legacy save bytes Fixture
- Legacy hidden-state Snapshot Fixture
- 정상 Validation v1 Fixture
- corrupt JSON Fixture
- corrupt schema Fixture
- newer incompatible Fixture
- missing content ID Fixture
- interrupted temp Fixture
- recoverable backup Fixture

### 11.2 P0 Save Safety

1. Validation create 후 Legacy bytes 동일
2. Validation save 후 Legacy bytes 동일
3. Validation load/resume 후 Legacy bytes 동일
4. Validation delete 후 Legacy bytes 동일
5. Validation corrupt inspection 후 Legacy bytes 동일
6. Validation complete 후 Legacy bytes 동일
7. 각 과정 전후 hidden campaign/economy/relationship/faction/market Snapshot 동일
8. Legacy save/load/clear 후 Validation bytes 동일

### 11.3 P0 Routing Safety

1. explicit active + valid token일 때 Validation repository만 기록
2. active + token mismatch일 때 양쪽 저장 모두 금지
3. active + invalid version일 때 양쪽 저장 모두 금지
4. inactive일 때 기존 Legacy round-trip 유지
5. Validation write 실패 시 Legacy fallback 금지
6. restore 실패 시 부분 적용 없음

### 11.4 P0 Lifecycle

1. create→activate→save→suspend→resume
2. active 상태 이중 activate 거부
3. completed Session 재완료 시 `ALREADY_COMPLETED`
4. abandon은 파일 유지
5. delete는 Validation 파일만 제거
6. corrupt quarantine 자동 삭제 없음

### 11.5 P1 Compatibility

1. unknown stage 거부
2. unknown effect 실행 거부
3. unknown stable ID orphan 보존·미적용
4. newer save inspect-only
5. backup recovery는 명시적 절차 전 primary로 승격되지 않음

### 11.6 Regression

구현 단계에서 실제 저장소 기준으로 실행할 검증:

- Package 1 focused tests
- CORE focused suite
- ANNUAL-001/002 focused suite
- `tests/run_godot_regression.sh` 전체 49-entry

테스트를 실행하지 않은 현재 상태는 `NOT_RUN`이다.

## 12. 관측 가능한 완료 기준

Package 1 구현 완료를 주장하려면:

- Session과 repository가 존재함
- Validation active save가 Legacy 경로에 쓰지 않음
- inactive Legacy save가 기존 의미를 유지함
- 파일·메모리 no-effect P0 모두 통과함
- corrupt/incompatible matrix가 fail-closed함
- lifecycle 테스트 통과함
- CORE/ANNUAL/49-entry 실제 결과가 있음
- changed-file inventory와 exact HEAD가 기록됨
- 정본·Sheet가 같은 Decision ID와 commit SHA로 동기화됨

문서 완성만으로 구현 완료를 주장하지 않는다.

## 13. 예상 구현 파일

### Create

- `scripts/core/validation_session.gd`
- `scripts/core/validation_save_repository.gd`
- `tests/validation/validation_session_test.gd`
- `tests/validation/validation_save_isolation_test.gd`
- `tests/validation/validation_save_compatibility_test.gd`

### Modify — 최소 범위

- `project.godot`
- `scripts/core/game_state.gd`
- 실제 테스트 실행기에 Package 1 focused entry 등록이 필요한 파일

### 금지

- `scripts/ui/main_menu.gd`
- `scenes/main_menu.tscn`
- `preparation_scene.gd`
- `result_scene.gd`
- episode JSON
- campaign/economy/market/faction/relationship 파일

## 14. 구현 순서 제약

실제 구현 승인이 주어지면 writing-plans에서 다음 순서를 세분화한다.

```text
RED Legacy bytes fixture
→ RED hidden memory fixture
→ RED repository path/inspection
→ RED fail-closed routing
→ 최소 repository
→ 최소 Session
→ GameState whitelist export/restore
→ save routing
→ corrupt/version/lifecycle
→ focused regression
→ CORE/ANNUAL/full regression
→ adversarial re-review
```

구현과 무관한 리팩터링은 분리한다.

## 15. 롤백

- `project.godot`의 ValidationSession Autoload 제거
- Package 1 신규 스크립트·테스트 제거
- `GameState` adapter·routing 변경만 되돌림
- Validation primary/backup/temp 파일만 삭제
- Legacy `mvp-039`, `mvp-038` migration, ANNUAL 경로는 변경 전 상태 유지

롤백 후 Legacy save round-trip과 전체 회귀를 다시 실행한다.

## 16. 적대적 검토

### 공격: 독립 저장인데 메모리는 오염될 수 있다

대응: 파일·메모리 no-effect Snapshot을 P0로 고정한다.

### 공격: Validation 오류가 Legacy 저장으로 fallback된다

대응: active invalid Session은 양쪽 저장을 금지하는 fail-closed 계약을 적용한다.

### 공격: denylist에서 새 Legacy 필드가 누락된다

대응: whitelist export만 허용한다.

### 공격: corrupt 저장을 새 시작으로 덮어써 증거와 복구 가능성을 잃는다

대응: 자동 삭제·덮어쓰기 금지, quarantine 보존.

### 공격: 완료 기록이 보고서·보상을 본편에 적용한다

대응: 독립 persistence Decision과 forbidden-call 수용 기준.

### 공격: 별도 repository가 사실상 두 번째 GameState가 된다

대응: Session은 navigation·checkpoint·snapshot·ledger만 소유하고 도메인 엔진을 복제하지 않는다.

### 공격: Package 1에서 메뉴 UX까지 확장된다

대응: 메뉴 표시·선택·삭제 UX는 Package 2로 명시적 제외.

## 17. 자기검수 결과

```yaml
placeholder_scan: PASS
internal_consistency: PASS
scope_single_package: PASS
ambiguity_scan: PASS
approved_persistence_boundary_reflected: PASS
legacy_file_and_memory_protection: PASS
implementation_authority_respected: PASS
runtime_evidence: NOT_RUN
human_evidence: NOT_RUN
```

남은 사용자 Gate는 이 Spec의 승인 여부다. Spec 승인 뒤 `writing-plans`로 구현 계획을 작성하되, 제품 구현은 다시 별도 승인을 받아야 한다.
