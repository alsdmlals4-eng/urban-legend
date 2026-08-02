# D-2026-08-02-PACKAGE-2-DESIGN-SPEC-APPROVAL

> 상태: `APPROVED / IMPLEMENTATION_PLAN_WRITTEN`
> 승인 시각: 2026-08-02 16:17 KST
> 승인 방식: 사용자 `승인`
> 추적 PR: #129
> 상위 Decision: `D-2026-08-02-PACKAGE-2-DESIGN-APPROVAL`
> 승인 Spec: `docs/superpowers/specs/2026-08-02-package-2-main-menu-entry-routing-design.md`
> 구현 계획: `docs/superpowers/plans/2026-08-02-package-2-main-menu-entry-routing-implementation-plan.md`

## 결정

Package 2 메인 메뉴 진입·이어하기·라우팅 Design Spec을 승인한다.

승인 범위:

- Legacy·Validation 독립 병렬 카드
- Validation persistence read-only summary
- active·suspended·completed 행동 구분
- 명시적 Validation 기록 교체 확인
- corrupt·incompatible·recoverable 무덮어쓰기
- flow-stage allowlist 기반 fail-closed routing
- single-flight mutation lock
- whitelist-only Validation runtime initializer
- 시작·이어하기 전후 Legacy save bytes와 hidden memory 무부작용 검증
- 1280×720·키보드·마우스 검증 계약

## 구현 경계

이 승인은 구현 계획 작성을 허가했다. 제품 코드 구현과 병합은 허가하지 않는다.

```yaml
implementation_plan: WRITTEN_SELF_REVIEWED
product_implementation: NOT_AUTHORIZED
planning_pr_merge: NOT_REQUESTED
grillme_counter_change: NONE
current_grillme_counter: 1 / 10
```

같은 제품 결정의 후속 승인 Gate이므로 새 Grill Me Decision으로 중복 집계하지 않는다.

## 구현 계획 결과

계획은 7개 독립 TDD 단위로 분해됐다.

1. read-only persistence summary
2. flow-stage route mapper
3. whitelist runtime initializer
4. coordinator start·replace·atomic cleanup
5. coordinator continue·completed·rollback
6. SCREEN-01 cards·dialogs·focus
7. focused 5/5·full 58/58·CI·evidence·merge gate

Self-review:

```yaml
spec_coverage: PASS
placeholder_scan: PASS
type_consistency: PASS
scope_check: PASS
```

## 다음 Gate

사용자 제품 구현 승인 → 격리 implementation branch → TDD 실행 → Draft implementation PR → exact-head 재검증 → 별도 병합 승인.