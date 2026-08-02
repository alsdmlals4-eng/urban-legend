# Package 2 메인 메뉴 진입·이어하기 라우팅 적대적 감사

> Audit ID: `R-2026-08-02-PACKAGE-2-ENTRY-ROUTING`
> 상태: `AUDIT_COMPLETE / 1 USER_DECISION_REQUIRED`
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

## 3. 적대적 Findings

### P2-001 — Legacy 삭제 위험

기존 `새 캠페인 시작`을 Validation 시작 버튼으로 재사용하면 Legacy 저장 삭제가 발생한다.

**판정:** MUST_FIX

**계약:** Validation 시작은 `GameState.clear_save_file()`을 호출하지 않는다.

### P2-002 — 단일 이어하기의 모호성

Legacy와 Validation 저장이 함께 존재할 수 있는데 `이어하기` 버튼 하나만 두면 어떤 기록이 열리는지 예측할 수 없다.

**판정:** USER_DECISION_REQUIRED

**질문:** Legacy와 Validation을 메인 메뉴에서 어떤 위계·정보 구조로 보여줄 것인가.

### P2-003 — 읽기 동작과 불러오기 동작 혼합

`ValidationSession.load()`는 상태 조회가 아니라 restore다. 메뉴 렌더링 중 호출하면 GameState가 변한다.

**판정:** AUTO_FIX_ELIGIBLE

**권장 계약:** `ValidationSession.inspect_persistence()` 또는 동등한 read-only facade를 추가해 repository 상태와 안전한 summary만 반환한다.

### P2-004 — EXACT만으로 이어하기 가능 여부를 판단할 수 없음

EXACT payload도 lifecycle이 `active`, `suspended`, `completed`일 수 있다.

**판정:** AUTO_FIX_ELIGIBLE

**권장 표시:**

- active/suspended → `Validation 이어하기`
- completed → `완료 기록 보기` + `새 Validation 시작`은 명시적 교체 확인 필요
- empty → `Validation 시작`

### P2-005 — 복구 가능 상태를 자동 승격하면 안 됨

Package 1 계약은 backup/temp를 자동 승격하지 않는다.

**판정:** AUTO_FIX_ELIGIBLE

**권장 표시:** `복구 가능한 기록이 있음`을 표시하고 이어하기는 비활성화한다. 실제 backup 승격은 별도 명시적 명령과 테스트 없이는 수행하지 않는다.

### P2-006 — 호환 불가·손상 상태에서 삭제 유도 위험

newer/corrupt 저장은 자동 삭제·덮어쓰기하면 안 된다.

**판정:** AUTO_FIX_ELIGIBLE

**권장 표시:**

- newer → `더 최신 버전에서 만든 기록` / inspect-only
- older → `이 버전에서 직접 열 수 없음`
- corrupt → `손상 기록 보존됨`
- 모든 상태에서 Legacy 이어하기는 독립적으로 유지

### P2-007 — 새 Validation 시작의 교체 의미

기존 Validation 저장이 active/suspended/completed이면 `create()`가 거부한다. 새 시작은 기존 기록 삭제와 같으므로 확인 없는 단일 클릭이 될 수 없다.

**판정:** AUTO_FIX_ELIGIBLE

**권장 계약:**

- 진행 중 기록 존재 → 기본 행동은 이어하기
- 새 시작은 보조 행동 + 사건명/단계 표시 + 명시적 교체 확인
- completed 기록 존재 → 완료 기록 보기를 기본 행동으로 두고 새 시작은 보조 행동
- corrupt/incompatible 기록 존재 → 새 시작으로 덮어쓰지 않음

### P2-008 — 라우팅 대상 검증 부족

Validation save의 `scene_path`를 그대로 열면 허용하지 않은 Scene으로 이동할 수 있다.

**판정:** AUTO_FIX_ELIGIBLE

**권장 계약:** Validation 전용 route allowlist/flow-stage mapper를 사용하고, 알 수 없는 경로는 메인에 남아 오류를 표시한다.

### P2-009 — 메뉴 로딩 중 중복 입력

create/load/scene change 중 버튼을 재입력하면 lifecycle 중복 호출 가능성이 있다.

**판정:** AUTO_FIX_ELIGIBLE

**권장 계약:** `LOADING` 상태에서 모든 start/continue mutation action을 잠그고 단일 결과만 처리한다.

### P2-010 — UI 범위 팽창

기존 메인 메뉴에는 소개, 대형 이미지, DB, 접근성, 숨은 개발 패널이 한 화면에 있다. Legacy·Validation 카드와 오류 상태까지 단순 추가하면 1280×720에서 핵심 행동이 밀릴 수 있다.

**판정:** RESEARCH_OR_TEST_REQUIRED

**권장 계약:** Package 2는 정보 위계를 먼저 정하고, 시각 스타일 세부는 1280×720 wireframe·런타임 검증에서 확정한다.

## 4. 안전 기본값

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
```

## 5. Grill Me — 메인 메뉴 위계

Decision 예정 ID: `D-2026-08-02-PACKAGE-2-MAIN-MENU-MODE-HIERARCHY`

### A — Legacy·Validation 독립 카드 병렬 표시 — 권장

- `기존 진행` 카드: 새 캠페인 / 이어하기 / 저장 상태
- `Validation 기록` 카드: 시작 / 이어하기 / 완료 기록 / 오류 상태
- 두 저장이 동시에 존재해도 행동이 명확하다.
- 1280×720에서 카드 밀도 조정이 필요하다.

### B — 시작·이어하기 한 버튼 뒤 모드 선택

- 메인 행동은 단순해 보인다.
- 클릭 후 한 단계가 추가되고 저장 오류를 버튼 뒤에 숨기기 쉽다.
- 두 기록이 있을 때 즉시 비교하기 어렵다.

### C — Validation을 주 행동으로, Legacy는 보조 메뉴로 이동

- 현재 검증 Cut을 가장 강하게 전면화한다.
- 플레이어가 Validation을 본편으로 오인할 위험이 있다.
- 기존 캠페인 접근성이 낮아지고 현재 장기 제품 구조와 충돌할 수 있다.

**권장:** A. 현재 승인된 완전 독립 저장 의미를 화면 구조에서도 그대로 유지하고, 한쪽 기록의 오류가 다른 쪽 행동을 막지 않게 하기 때문이다.

## 6. 작업 이력 주의

기획 브랜치 생성 전에 잘못된 contents 호출로 `main`에 임시 파일 `x`가 1회 추가되었고, 즉시 다음 커밋에서 삭제했다.

- accidental add: `66d2fac2d8ac6ef18f620862a662c8b59cac47a9`
- immediate revert: `0303cbadad8488ffcc02b31ca23c851b90c29bbc`
- 제품·정본 내용 변화: 없음

향후 이 Package는 planning branch와 PR을 통해서만 갱신한다.

## 7. 다음 순서

```text
메인 메뉴 위계 Grill Me 승인
→ 승인 Decision·Grill Me ledger 1/10·Sheet 동기화
→ 2~3 접근안 최종 비교와 Package 2 Design 제시
→ 사용자 Design 승인
→ Design Spec 작성·self-review
→ 사용자 Spec 승인
→ writing-plans
```

제품 코드·Scene·Save Schema·workflow는 Design과 별도 구현 승인 전 변경하지 않는다.
