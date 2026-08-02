# Package 2 메인 메뉴 진입·이어하기 라우팅 적대적 감사

> Audit ID: `R-2026-08-02-PACKAGE-2-ENTRY-ROUTING`
> 상태: `AUDIT_COMPLETE / DESIGN_SPEC_APPROVED / IMPLEMENTATION_PLAN_WRITTEN`
> 위계 Decision: `D-2026-08-02-PACKAGE-2-MAIN-MENU-MODE-HIERARCHY`
> Design Decision: `D-2026-08-02-PACKAGE-2-DESIGN-APPROVAL`
> Spec Decision: `D-2026-08-02-PACKAGE-2-DESIGN-SPEC-APPROVAL`
> 기준: GitHub latest `main` ref
> 범위: SCREEN-01의 Legacy·Validation 시작/이어하기, 저장 상태 표시, 안전한 라우팅
> 제품 구현 권한: `NOT_AUTHORIZED`

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

- 기존 `새 캠페인 시작`은 `GameState.clear_save_file()`을 호출한다.
- 기존 `이어하기`는 Legacy 저장만 판단한다.
- Validation 저장은 `user://urban_legend_validation_save.json`에 독립한다.
- repository는 EMPTY·EXACT·recoverable·interrupted·version·corrupt 상태를 구분한다.
- `ValidationSession.load()`는 실제 restore이므로 메뉴 표시용 조회로 사용할 수 없다.
- Legacy와 Validation 저장은 동시에 존재할 수 있다.

## 3. 적대적 Findings와 처리

| ID | 위험 | 판정 | 승인 처리 |
|---|---|---|---|
| P2-001 | Validation 시작이 Legacy 삭제 경로 재사용 | MUST_FIX | Validation에서 `clear_save_file()` 금지 |
| P2-002 | 단일 이어하기 대상 모호 | RESOLVED | Legacy·Validation 독립 병렬 카드 |
| P2-003 | 메뉴 조회와 load/restore 혼합 | MUST_FIX | read-only `inspect_persistence()` |
| P2-004 | EXACT lifecycle 미구분 | MUST_FIX | active/suspended 이어하기, completed 기록 보기 |
| P2-005 | backup/temp 자동 승격 | MUST_FIX | 상태만 표시, mutation 금지 |
| P2-006 | corrupt/version 저장 덮어쓰기 | MUST_FIX | 보존·inspect-only |
| P2-007 | 기존 기록 무확인 교체 | MUST_FIX | record identity 재검증 + 명시적 확인 |
| P2-008 | 저장된 scene_path 직접 이동 | MUST_FIX | flow-stage allowlist mapper |
| P2-009 | 중복 입력 | MUST_FIX | single-flight lock |
| P2-010 | 1280×720 행동 밀림 | TEST_REQUIRED | 카드 우선 레이아웃·runtime 검증 |
| P2-011 | `reset_run_state()`가 hidden Legacy 초기화 | MUST_FIX | whitelist-only initializer |

## 4. 승인된 메뉴 위계

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

## 5. 확정 안전 기본값

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
runtime_initialization: PACKAGE_1_WHITELIST_ONLY
```

## 6. 승인 Spec·계획

Spec:

`docs/superpowers/specs/2026-08-02-package-2-main-menu-entry-routing-design.md`

Implementation plan:

`docs/superpowers/plans/2026-08-02-package-2-main-menu-entry-routing-implementation-plan.md`

계획은 다음 7개 독립 TDD 작업으로 분해됐다.

1. read-only persistence summary
2. flow-stage route mapper
3. whitelist runtime initializer
4. coordinator start·replace·atomic cleanup
5. coordinator continue·completed·rollback
6. SCREEN-01 cards·dialogs·focus
7. Package 2 focused 5/5·full regression 58/58·CI·evidence·merge gate

## 7. Plan self-review

```yaml
spec_coverage: PASS
placeholder_scan: PASS
type_consistency: PASS
scope_check: PASS
product_diff: 0
implementation: NOT_AUTHORIZED
```

누락된 Spec 요구사항은 없다. 전용 SIT-003·005·006·007·008 화면은 이번 구현에서 `NOT_AVAILABLE`로 유지하며 완료된 기능으로 가장하지 않는다.

## 8. 작업 이력 주의

기획 브랜치 생성 전에 잘못된 contents 호출로 `main`에 임시 파일 `x`가 1회 추가되었고 즉시 삭제했다.

- accidental add: `66d2fac2d8ac6ef18f620862a662c8b59cac47a9`
- immediate revert: `0303cbadad8488ffcc02b31ca23c851b90c29bbc`
- 순 파일 변화: 없음
- 제품·정본 의미 변화: 없음

이후 변경은 PR #129에서만 진행한다.

## 9. 다음 Gate

```text
사용자 제품 구현 승인
→ 최신 main·planning head 재확인
→ 격리 implementation branch
→ TDD RED/GREEN Task 1~7
→ Draft implementation PR
→ exact-head CI·적대적 리뷰
→ 별도 병합 승인
```

제품 코드·Scene·Save Schema·workflow는 별도 제품 구현 승인 전 변경하지 않는다.