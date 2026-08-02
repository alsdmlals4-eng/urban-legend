# 괴이기록국 Validation 현재 인수인계

> 상태: `PACKAGE_2_IMPLEMENTATION_COMPLETE_ON_PR_131 / PLANNING_MERGED / MERGE_AUTHORIZED / FINAL_EXACT_HEAD_CI_PENDING`
> 갱신일: 2026-08-02
> planning branch: `agent/package-2-entry-routing-planning`
> implementation branch: `agent/package-2-entry-routing-implementation`
> Planning PR: #129
> Implementation PR: #131
> Grill Me future counter: `1 / 10`
> 병합 권한: `AUTHORIZED`

실제 최신 main·PR SHA는 GitHub ref에서 읽는다. PR #129 planning 정본은 main에 병합됐고, PR #131 구현은 최신 main과 동기화한 뒤 최종 exact-head 검증을 수행 중이다. 최종 검증·감사·병합이 끝나기 전까지 Package 2를 main 완료 상태로 주장하지 않는다.

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
→ docs/decisions/D-2026-08-02-PACKAGE-2-IMPLEMENTATION-APPROVAL.md
→ docs/superpowers/specs/2026-08-02-package-2-main-menu-entry-routing-design.md
→ docs/superpowers/plans/2026-08-02-package-2-main-menu-entry-routing-implementation-plan.md
→ docs/implementation/2026-08-02-package-2-main-menu-entry-routing-evidence.md
→ docs/planning/2026-08-02-package-2-entry-routing-adversarial-audit.md
→ docs/planning/2026-08-02-package-2-validation-initializer-adversarial-finding.md
→ 실제 implementation branch 코드·테스트
```

## 현재 상태

```yaml
base: 9.4.1
package_1: MERGED_AND_AUTOMATED_CI_VERIFIED
package_2_planning_audit: COMPLETE
package_2_menu_hierarchy: APPROVED_PARALLEL_INDEPENDENT_CARDS
package_2_design: APPROVED
package_2_spec: APPROVED
package_2_implementation_plan: APPROVED_AND_EXECUTED
package_2_product_implementation: COMPLETE_ON_PR_131
package_2_planning_merge: MERGED_PR_129
package_2_implementation_merge: AUTHORIZED_FINAL_CI_PENDING
package_2_latest_completed_exact_head: PASS
package_1_focused: 4_OF_4_PASS
package_2_focused: 5_OF_5_PASS
full_godot_regression: 58_OF_58_PASS
future_grillme_counter: 1_OF_10
local_runtime: NOT_RUN
human_qa: NOT_RUN
new_player_validation: NOT_RUN
screen_01_visual_1280x720: NOT_RUN
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
platform: PC_16_9_MOUSE_KEYBOARD
mobile: DEFERRED_AFTER_PC_VALIDATION
```

## 구현된 SCREEN-01 구조

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

Validation badge는 `본편과 별도 기록`을 명시한다. 한쪽 저장 오류는 다른 카드 행동을 차단하지 않는다.

## 구현 컴포넌트

1. `ValidationPersistenceSummary`
   - repository code와 lifecycle을 UI 행동으로 변환
   - payload 전체를 UI에 노출하지 않음

2. `ValidationPersistenceInspector`
   - menu render용 read-only repository 조회
   - Package 1 `ValidationSession` autoload 경계 유지

3. `ValidationRouteMapper`
   - SIT-001·002 → dialogue
   - SIT-004 → investigation
   - SIT-003·005~008 → `NOT_AVAILABLE`
   - unknown → `UNKNOWN_FLOW_STAGE`

4. `initialize_validation_runtime()`
   - Validation runtime whitelist만 초기화
   - campaign·관계·보상·경제·Legacy file 무변경

5. `ValidationEntryCoordinator`
   - create·activate·guard·initialize·save·route
   - record identity 재확인 후 교체
   - active·suspended 이어하기
   - completed read-only summary
   - single-flight
   - 실패 시 runtime rollback·Session abandon

6. SCREEN-01 UI
   - 독립 카드
   - status·replace·completed dialog
   - 파괴적 교체 기본 포커스 취소
   - keyboard focus neighbor

## 최근 완료 exact-head 자동 검증

```yaml
documentation_run_30741361754: PASS
bca_run_30741361726: PASS
core_run_30741361717: PASS
annual_run_30741361720: PASS
godot_import: PASS
package_1_focused: 4_OF_4_PASS
package_2_focused: 5_OF_5_PASS
core_focused: PASS
annual_001_focused: PASS
annual_002_focused: PASS
full_godot_regression: 58_OF_58_PASS
review_threads: 0
submitted_reviews: 0
```

위 실행은 직전 exact-head 증거다. 현재 main 동기화·BCA 임시 조건 제거·병합 승인 상태를 포함한 최신 PR #131 HEAD에서 Documentation·BCA·CORE·ANNUAL을 다시 실행하고, 그 결과만 최종 병합 근거로 사용한다.

TDD RED·GREEN·적대적 보정 상세:

`docs/implementation/2026-08-02-package-2-main-menu-entry-routing-evidence.md`

## 필수 보호 계약 판정

```yaml
read_only_menu_inspection: PASS
blocked_storage_no_mutation: PASS
legacy_file_bytes_no_effect: PASS
legacy_hidden_memory_no_effect: PASS
whitelist_initializer: PASS
flow_stage_allowlist: PASS
unknown_route_fail_closed: PASS
route_failure_runtime_rollback: PASS
session_abandon_on_failure: PASS
single_flight: PASS
completed_view_read_only: PASS
legacy_validation_independent_cards: PASS
keyboard_focus_structure: PASS
```

## GitHub 상태

```yaml
pr_125: MERGED
pr_126: MERGED
pr_127: MERGED
pr_129: MERGED
pr_131: IMPLEMENTATION_COMPLETE_MERGE_AUTHORIZED_FINAL_CI_PENDING
pr_132: MERGED_MAIN_TO_PLANNING_SYNC
pr_133: MERGED_MAIN_TO_IMPLEMENTATION_SYNC
pr_122: CLOSED_SOURCE_DO_NOT_MERGE_AS_IS
issue_121: CLOSED_COMPLETED
```

PR #131 changed files는 production·tests·CI·current evidence 범위다. 최종 병합 직전 changed files, unresolved review thread, submitted review, exact-head workflow와 Google Sheet를 다시 감사한다.

## Grill Me 운영

- 현재 미래 카운터: `1 / 10`
- 현재 카운트 Decision: `D-2026-08-02-PACKAGE-2-MAIN-MENU-MODE-HIERARCHY`
- Design·Spec·계획·구현·병합 승인은 동일 질문의 후속 Gate이므로 추가 카운트하지 않는다.
- 이번 별도 병합은 사용자 승인에 따라 10개 도달 전 Package 2 범위만 처리한다.

## 다음 Gate

```text
PR #131 최신 HEAD에서 Docs·BCA·CORE·ANNUAL
→ changed files·review·Sheet 적대적 감사
→ expected-head SHA로 PR #131 병합
→ post-merge current docs·Sheet에 merge SHA 동기화
→ Package 2 종료
→ 본격 게임 기획 전환
```

## 미검증 경계

```yaml
local_runtime: NOT_RUN
human_qa: NOT_RUN
new_player_validation: NOT_RUN
screen_01_visual_1280x720: NOT_RUN
screen_01_mouse_manual: NOT_RUN
screen_01_keyboard_manual: NOT_RUN
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
```
