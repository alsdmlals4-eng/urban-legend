# 괴이기록국 Validation 현재 인수인계

> 상태: `PACKAGE_2_SPEC_APPROVED / IMPLEMENTATION_PLAN_WRITTEN / PRODUCT_IMPLEMENTATION_APPROVAL_PENDING`
> 갱신일: 2026-08-02
> 작업 branch: `agent/package-2-entry-routing-planning`
> Package 2 planning PR: #129
> Grill Me future counter: `1 / 10`
> 제품 구현 권한: `NOT_AUTHORIZED`

실제 최신 main SHA는 GitHub `main` ref에서 읽는다. Package 1 병합 SHA는 역할이 고정된 증거로만 사용한다.

## 읽기 순서

```text
START_HERE.md
→ AGENTS.md
→ GitHub latest main ref
→ docs/CURRENT_CONFIRMED_DECISIONS.md
→ docs/VALIDATION_TARGET_CANON.md
→ docs/GRILLME_APPROVAL_MERGE_LEDGER.md
→ docs/decisions/D-2026-08-02-PACKAGE-2-MAIN-MENU-MODE-HIERARCHY.md
→ docs/decisions/D-2026-08-02-PACKAGE-2-DESIGN-APPROVAL.md
→ docs/decisions/D-2026-08-02-PACKAGE-2-DESIGN-SPEC-APPROVAL.md
→ docs/superpowers/specs/2026-08-02-package-2-main-menu-entry-routing-design.md
→ docs/superpowers/plans/2026-08-02-package-2-main-menu-entry-routing-implementation-plan.md
→ docs/planning/2026-08-02-package-2-entry-routing-adversarial-audit.md
→ docs/planning/2026-08-02-package-2-validation-initializer-adversarial-finding.md
→ Package 1 Design·Plan·evidence
→ 실제 main 코드·테스트
```

## 현재 상태

```yaml
base: 9.4.0
branch: agent/package-2-entry-routing-planning
package_1: MERGED_AND_AUTOMATED_CI_VERIFIED
package_2_planning_audit: COMPLETE
package_2_menu_hierarchy: APPROVED_PARALLEL_INDEPENDENT_CARDS
package_2_design: APPROVED
package_2_spec: APPROVED
package_2_implementation_plan: WRITTEN_SELF_REVIEWED
package_2_product_implementation: NOT_AUTHORIZED
package_2_planning_merge: NOT_REQUESTED
product_diff_on_pr_129: 0
future_grillme_counter: 1_OF_10
runtime_human_qa: NOT_RUN
new_player_validation: NOT_RUN
visual_1280x720_validation: NOT_RUN
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
platform: PC_16_9_MOUSE_KEYBOARD
mobile: DEFERRED_AFTER_PC_VALIDATION
```

## Package 2 승인 구조

```text
기존 진행 카드
- 새 캠페인
- 이어하기
- Legacy 저장 상태

Validation 기록 카드
- 새 기록 시작
- 이어하기
- 완료 기록 보기
- 오류·호환 상태
```

핵심 구성 요소:

1. `ValidationPersistenceSummary` — repository 결과를 메뉴용 read-only summary로 변환
2. `ValidationRouteMapper` — SIT allowlist·unknown/not-available fail-closed
3. `initialize_validation_runtime()` — Package 1 whitelist 필드만 초기화
4. `ValidationEntryCoordinator` — 시작·교체·이어하기·완료 보기·rollback·single-flight
5. SCREEN-01 독립 카드·status/replace/completed dialog·키보드 focus

## 구현 계획

경로:

`docs/superpowers/plans/2026-08-02-package-2-main-menu-entry-routing-implementation-plan.md`

7개 검토 단위:

1. read-only persistence summary
2. flow-stage route mapper
3. whitelist runtime initializer
4. coordinator start·replace·atomic cleanup
5. coordinator continue·completed·rollback
6. SCREEN-01 cards·dialogs·focus
7. Package 2 focused 5/5·full regression 58/58·CI·evidence·merge gate

실행 원칙:

- `superpowers:using-git-worktrees`로 격리
- `superpowers:subagent-driven-development` 권장
- 각 Task RED → minimal GREEN → 회귀 → 커밋
- planning PR에는 제품 코드 금지
- implementation PR은 planning PR 위에 stacked Draft로 시작
- planning 병합 후 implementation 재정렬·exact-head 재검증
- 별도 구현 병합 승인 필요

## 필수 보호 계약

- Validation 메뉴 조회에서 `load()` 호출 금지
- Validation 시작에서 Legacy 저장 삭제 금지
- `reset_run_state()`·`restart_afterlife_station_flow()` 재사용 금지
- active·suspended·completed 행동 분리
- blocked persistence code는 delete/create/load 금지
- 기존 Validation 교체는 record identity 재검증 후 명시적 확인
- 저장된 `scene_path` 직접 라우팅 금지
- route 실패 시 GameState runtime rollback·Session abandon
- 한쪽 오류가 다른 카드 행동을 막지 않음
- 시작·이어하기 전후 Legacy file bytes와 hidden memory equality

## 테스트 목표

```yaml
package_1_focused: 4_OF_4_PASS_REQUIRED
package_2_focused: 5_OF_5_PASS_REQUIRED
full_godot_regression: 58_OF_58_PASS_REQUIRED
documentation_contracts: PASS_REQUIRED
bca_adoption: PASS_REQUIRED
core_workflow: PASS_REQUIRED
annual_workflow: PASS_REQUIRED
human_qa: PASS_OR_EXPLICIT_NOT_RUN
visual_1280x720: PASS_OR_EXPLICIT_NOT_RUN
```

## GitHub 상태

```yaml
pr_125: MERGED
pr_126: MERGED
pr_127: MERGED
pr_129: DRAFT_IMPLEMENTATION_APPROVAL_PENDING
pr_122: CLOSED_SOURCE_DO_NOT_MERGE_AS_IS
issue_121: CLOSED_COMPLETED
```

## Grill Me 운영

- 역사 batch: `HISTORICAL_BATCH_0` 완료
- 현재 미래 카운터: `1 / 10`
- 현재 카운트 Decision: `D-2026-08-02-PACKAGE-2-MAIN-MENU-MODE-HIERARCHY`
- Design·Spec·계획 승인은 동일 질문의 후속 Gate이므로 추가 카운트하지 않는다.
- 10개 도달 시 병합 직전 GitHub·Sheet·PR·CI 적대적 검토를 다시 수행한다.

## 다음 Gate

```text
사용자 제품 구현 승인
→ latest main·planning head 확인
→ 격리 implementation branch
→ TDD Task 1~7
→ Draft implementation PR
→ exact-head CI·적대적 리뷰
→ 별도 병합 승인
→ Package 2 종료
→ 본격 게임 기획 전환
```

## 미검증 경계

```yaml
local_runtime: NOT_RUN
human_qa: NOT_RUN
new_player_validation: NOT_RUN
visual_1280x720_validation: NOT_RUN
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
```
