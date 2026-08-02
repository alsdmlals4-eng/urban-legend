# Package 2 메인 메뉴 진입·이어하기 라우팅 적대적 감사

> Audit ID: `R-2026-08-02-PACKAGE-2-ENTRY-ROUTING`
> 상태: `AUDIT_COMPLETE / USER_DECISION_RESOLVED`
> 승인 Decision: `D-2026-08-02-PACKAGE-2-MAIN-MENU-MODE-HIERARCHY`
> 기준: GitHub latest `main` ref
> 범위: SCREEN-01의 Legacy·Validation 시작/이어하기, 저장 상태 표시, 안전한 라우팅
> 구현 권한: `NOT_AUTHORIZED`

## 1. 목표

Package 1에서 병합된 독립 `ValidationSession`·Validation 저장소를 SCREEN-01에 안전하게 연결한다.

이번 Package 2는 다음까지만 다룬다.

- Legacy와 Validation의 시작·이어하기를 명확히 구분
- Validation 저장 상태를 읽기 전용으로 분류
- 시작·이어하기·완료 기록·오류 상태의 라우팅 계약
- Legacy 저장 비파괴
- 잘못된 Session·저장 상태에서 fail-closed
- 1280×720에서 주요 행동 접근 가능한 정보 구조

전용 준비·추론·결과 Scene의 상세 제품 설계와 전체 게임 기획은 후속 단계다.

## 2. 현재 구현 사실

### 기존 메인 메뉴

- `새 캠페인 시작`은 `GameState.clear_save_file()`을 즉시 호출한다.
- `이어하기`는 `GameState.has_save_file()`과 `GameState.load_game()`만 사용한다.
- 저장 상태 문구는 Legacy 저장의 있음/없음만 표시한다.
- Validation 저장·상태·오류를 표시하거나 라우팅하지 않는다.

### Package 1 기반

- Validation 저장은 `user://urban_legend_validation_save.json`에 독립한다.
- repository `inspect()`는 `EMPTY`, `EXACT`, `RECOVERABLE_BACKUP`, `INTERRUPTED_WRITE`, `INCOMPATIBLE_OLDER`, `INCOMPATIBLE_NEWER`, `CORRUPT_JSON`, `CORRUPT_SCHEMA` 등을 구분한다.
- `ValidationSession.load()`는 실제 GameState restore와 mode 변경을 수행하므로 메인 메뉴 표시용 조회 API로 사용하면 안 된다.
- `create()`는 저장이 `EMPTY`가 아니면 `ALREADY_EXISTS`로 거부한다.
- `load()`한 payload가 active이면 Validation mode가 활성화되지만 suspended/completed이면 inactive로 남는다.
- Legacy 저장과 Validation 저장은 동시에 존재할 수 있다.

## 3. 적대적 Findings와 처리

### P2-001 — Legacy 삭제 위험

기존 `새 캠페인 시작`을 Validation 시작 버튼으로 재사용하면 Legacy 저장 삭제가 발생한다.

**판정:** MUST_FIX  
**처리:** Validation 시작에서 `GameState.clear_save_file()` 호출 금지.

### P2-002 — 단일 이어하기의 모호성

Legacy와 Validation 저장이 함께 존재할 수 있는데 `이어하기` 버튼 하나만 두면 어느 기록이 열리는지 예측할 수 없다.

**판정:** RESOLVED_BY_USER_DECISION  
**처리:** Legacy·Validation을 독립된 병렬 카드로 표시한다.

### P2-003 — 읽기와 불러오기 혼합

`ValidationSession.load()`는 상태 조회가 아니라 restore다. 메뉴 렌더링 중 호출하면 GameState가 변한다.

**판정:** AUTO_FIX_REQUIRED  
**처리:** `inspect_persistence()` 또는 동등한 read-only facade를 Design 계약에 포함한다.

### P2-004 — EXACT lifecycle 구분

EXACT payload도 `active`, `suspended`, `completed`로 나뉜다.

**판정:** AUTO_FIX_REQUIRED  
**처리:** active/suspended는 이어하기, completed는 완료 기록 보기, empty는 새 기록 시작으로 표시한다.

### P2-005 — 복구 가능 상태 자동 승격

Package 1 계약은 backup/temp를 자동 승격하지 않는다.

**판정:** AUTO_FIX_REQUIRED  
**처리:** 복구 가능 상태를 표시하되 이어하기를 비활성화하고 자동 승격하지 않는다.

### P2-006 — 손상·호환 불가 덮어쓰기

newer/corrupt 저장은 자동 삭제·덮어쓰기하면 안 된다.

**판정:** AUTO_FIX_REQUIRED  
**처리:** inspect-only 상태로 보존하고 Legacy 행동은 독립 유지한다.

### P2-007 — 기존 Validation 기록 교체

새 시작은 기존 기록 삭제와 같으므로 확인 없는 단일 클릭이 될 수 없다.

**판정:** AUTO_FIX_REQUIRED  
**처리:** 사건명·단계·기록 상태를 표시한 명시적 교체 확인을 요구한다. corrupt/incompatible 기록은 교체 대상으로 처리하지 않는다.

### P2-008 — 저장된 scene_path 직접 라우팅

허용하지 않은 Scene으로 이동할 수 있다.

**판정:** AUTO_FIX_REQUIRED  
**처리:** flow-stage allowlist mapper를 사용하고 알 수 없는 값은 메인에 남겨 오류를 표시한다.

### P2-009 — 중복 입력

create/load/scene change 중 재입력하면 lifecycle 호출이 중복될 수 있다.

**판정:** AUTO_FIX_REQUIRED  
**처리:** mutation action에 single-flight lock을 적용한다.

### P2-010 — 1280×720 밀도

기존 메뉴에 두 저장 카드와 오류 상태를 단순 추가하면 핵심 행동이 밀릴 수 있다.

**판정:** DESIGN_AND_RUNTIME_VALIDATION_REQUIRED  
**처리:** 상단 소개를 축약하고 행동 카드 우선 레이아웃을 설계한다. 세부 치수는 wireframe·런타임 검증에서 확정한다.

## 4. 승인된 메뉴 위계

Decision: `D-2026-08-02-PACKAGE-2-MAIN-MENU-MODE-HIERARCHY`

```text
기존 진행
- 새 캠페인
- 이어하기
- Legacy 저장 상태

Validation 기록
- 새 기록 시작
- 이어하기
- 완료 기록 보기
- 오류·호환 상태
```

승인 이유:

- 독립 저장 의미를 UI 구조에서도 보존한다.
- 한쪽 저장 오류가 다른 쪽 행동을 막지 않는다.
- Validation을 본편으로 오인시키지 않는다.
- 두 저장이 동시에 있을 때 행동 결과를 예측할 수 있다.

## 5. 안전 기본값

```yaml
legacy_save_mutation_from_validation_entry: FORBIDDEN
validation_status_read: READ_ONLY
validation_continue_lifecycle: [active, suspended]
completed_primary_action: VIEW_COMPLETED_RECORD
new_validation_with_existing_record: EXPLICIT_REPLACE_CONFIRMATION
corrupt_or_incompatible_overwrite: FORBIDDEN
automatic_backup_promotion: FORBIDDEN
route_policy: FLOW_STAGE_MAPPER_ALLOWLIST_FAIL_CLOSED
loading_input_policy: SINGLE_FLIGHT_LOCK
menu_hierarchy: PARALLEL_INDEPENDENT_CARDS
```

## 6. Package 2 Design 입력

### 구성 요소

1. `ValidationPersistenceSummary` read-only 상태 모델
2. Legacy 카드 presenter
3. Validation 카드 presenter
4. 시작·이어하기·완료 기록 action coordinator
5. flow-stage route mapper
6. 명시적 교체 확인 dialog
7. 로딩·오류·접근성 상태

### 상태 우선순위

```text
EMPTY
→ EXACT(active/suspended/completed)
→ RECOVERABLE_BACKUP / INTERRUPTED_WRITE
→ INCOMPATIBLE_OLDER / INCOMPATIBLE_NEWER
→ CORRUPT_JSON / CORRUPT_SCHEMA
→ READ_FAILED / UNKNOWN
```

오류 상태는 자동 복구·삭제·덮어쓰기를 수행하지 않는다.

### 라우팅 기본값

- 새 Validation: Session create·activate → 안전 초기 stage → 허용 Scene
- 이어하기: read-only summary 확인 → load/restore → flow-stage mapper → 허용 Scene
- completed: restore 없이 완료 summary 화면 또는 read-only record view
- unknown/mismatch: SCREEN-01 유지 + 오류 문구

## 7. 작업 이력 주의

기획 브랜치 생성 전에 잘못된 contents 호출로 `main`에 임시 파일 `x`가 1회 추가되었고 즉시 삭제했다.

- accidental add: `66d2fac2d8ac6ef18f620862a662c8b59cac47a9`
- immediate revert: `0303cbadad8488ffcc02b31ca23c851b90c29bbc`
- 순 파일 변화: 없음
- 제품·정본 의미 변화: 없음

이후 변경은 PR #129에서만 진행한다.

## 8. 검증 상태

```yaml
planning_audit: COMPLETE
user_menu_hierarchy_decision: APPROVED
product_diff: 0
implementation: NOT_AUTHORIZED
runtime: NOT_RUN
human_qa: NOT_RUN
visual_1280x720: NOT_RUN
poc_passed: NOT_DECLARED
```

## 9. 다음 순서

```text
Package 2 Design 제시
→ 사용자 Design 승인
→ Design Spec 작성·self-review
→ 사용자 Spec 승인
→ writing-plans
→ 별도 구현 승인
```

제품 코드·Scene·Save Schema·workflow는 Design과 별도 구현 승인 전 변경하지 않는다.
