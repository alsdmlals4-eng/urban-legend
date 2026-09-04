# D-2026-08-02-PACKAGE-2-IMPLEMENTATION-APPROVAL

> 상태: `APPROVED`
> 승인 시각: 2026-08-02 17:18 KST
> 승인 방식: 사용자 `구현승인`
> 추적 planning PR: #129
> 승인 Spec: `docs/superpowers/specs/2026-08-02-package-2-main-menu-entry-routing-design.md`
> 승인 Plan: `docs/superpowers/plans/2026-08-02-package-2-main-menu-entry-routing-implementation-plan.md`

## 결정

Package 2 메인 메뉴 진입·이어하기·라우팅 구현을 승인한다.

승인 범위:

- Validation persistence read-only summary
- flow-stage allowlist route mapper
- whitelist-only Validation runtime initializer
- 새 기록 시작·기존 기록 교체 coordinator
- active·suspended 이어하기와 completed read-only 요약
- 실패 시 GameState runtime rollback·Session abandon
- Legacy·Validation 독립 SCREEN-01 카드와 교체·상태 dialog
- single-flight 입력 잠금과 키보드 포커스
- Package 2 focused suite·Package 1 focused·전체 Godot regression·CI 증거

## 안전 경계

- Validation 경로에서 `GameState.clear_save_file()`, `reset_run_state()`, `restart_afterlife_station_flow()` 호출 금지
- `user://urban_legend_save.json` bytes와 hidden Legacy memory 변경 금지
- corrupt·incompatible·recoverable·interrupted 저장 자동 삭제·덮어쓰기·승격 금지
- payload `scene_path` 직접 이동 금지
- 알려지지 않거나 미구현된 flow-stage는 fail-closed
- planning PR과 implementation PR은 분리
- implementation PR은 planning branch를 base로 시작하고 planning merge 후 main으로 retarget·재검증

## 실행 방식

```yaml
implementation_branch: agent/package-2-entry-routing-implementation
implementation_pr: DRAFT_STACKED_ON_PR_129
method: TDD_RED_GREEN_REFACTOR
plan_tasks: 7
product_implementation: AUTHORIZED
merge: NOT_AUTHORIZED
current_grillme_counter: 1 / 10
```

같은 Grill Me 제품 결정의 후속 Gate이므로 카운터는 증가하지 않는다.

## 완료 Gate

- 각 신규 동작의 RED 실패와 GREEN 성공 증거
- Package 1 focused 4/4 PASS
- Package 2 focused 5/5 PASS
- full Godot regression 목표 58/58 PASS
- Documentation Contracts·BCA Adoption PASS
- unresolved review threads 0
- exact-head CI와 적대적 scope audit
- 사용자 별도 병합 승인
