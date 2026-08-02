# 괴이기록국 Validation 현재 인수인계

> 상태: `PACKAGE_2_DESIGN_APPROVED / SPEC_WRITTEN_SELF_REVIEWED / USER_SPEC_REVIEW_PENDING`
> 갱신일: 2026-08-02
> 작업 branch: `agent/package-2-entry-routing-planning`
> Package 2 planning PR: #129
> Grill Me future counter: `1 / 10`
> 구현 권한: `NOT_AUTHORIZED`

실제 최신 main SHA는 GitHub `main` ref에서 읽는다. Package 1 병합 증거 SHA는 역할이 고정된 기록으로만 사용한다.

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
→ docs/superpowers/specs/2026-08-02-package-2-main-menu-entry-routing-design.md
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
package_2_spec: WRITTEN_SELF_REVIEWED_USER_REVIEW_PENDING
package_2_implementation_plan: NOT_WRITTEN
package_2_implementation: NOT_AUTHORIZED
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

## Package 2 승인 Design

### SCREEN-01 위계

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

### 핵심 구성 요소

1. `ValidationPersistenceSummary` — 저장 무변경 read-only summary
2. Legacy 카드 presenter
3. Validation 카드 presenter
4. `ValidationEntryCoordinator` — 시작·이어하기·완료 기록 command
5. `ValidationRouteMapper` — flow-stage allowlist·fail-closed
6. 명시적 Validation 기록 교체 dialog
7. single-flight loading·오류·접근성 상태
8. `initialize_validation_runtime()` — Package 1 whitelist 필드만 초기화

### 필수 안전 계약

- Validation 시작에서 Legacy 저장 삭제 금지
- `ValidationSession.load()`를 메뉴 표시용 조회로 사용 금지
- active·suspended는 이어하기, completed는 완료 기록 보기
- corrupt·incompatible·recoverable 자동 삭제·덮어쓰기·승격 금지
- 기존 Validation 교체는 사건·단계·저장 시각을 표시하고 명시적으로 확인
- 저장된 `scene_path` 직접 이동 금지
- 한쪽 저장 오류가 다른 쪽 행동을 막지 않음
- 시작·이어하기 전후 Legacy file bytes와 hidden memory 동일성 검증

### P2-011 보정

기존 `restart_afterlife_station_flow()`는 `reset_run_state()`를 통해 campaign·관계·보상·경제 등 숨은 Legacy 상태를 초기화하므로 Validation 경로에서 재사용하지 않는다.

Validation 전용 초기화 adapter는 다음 런타임 필드만 변경한다.

- episode·scene·dialogue·field·minigame 위치
- selected agents
- flags·clues·hints
- method·minigame 결과
- resolution·recovery
- agent case state·victim state

## Spec self-review 결과

```yaml
placeholder_scan: PASS
internal_consistency: PASS
scope_check: PASS
ambiguity_check: PASS
implementation: NOT_STARTED
```

- `TBD`·`TODO` 없음
- 구현하지 않은 route는 `NOT_AVAILABLE`로 명시
- completed viewer는 read-only summary로 제한
- 전용 준비·추론·결과 Scene과 전체 게임 기획은 범위에서 제외
- 하나의 implementation plan으로 분해 가능한 범위

## GitHub 상태

```yaml
pr_125: MERGED
pr_126: MERGED
pr_127: MERGED
pr_129: DRAFT_SPEC_REVIEW_PENDING
pr_122: CLOSED_SOURCE_DO_NOT_MERGE_AS_IS
issue_121: CLOSED_COMPLETED
```

## Grill Me 운영

- 역사 batch: `HISTORICAL_BATCH_0` 완료
- 현재 미래 카운터: `1 / 10`
- 현재 카운트 Decision: `D-2026-08-02-PACKAGE-2-MAIN-MENU-MODE-HIERARCHY`
- Design 승인은 기존 질문의 후속 Gate이므로 추가 카운트하지 않음
- 10개 도달 시 병합 직전 GitHub·Sheet·PR·CI 적대적 검토

## 다음 Gate

```text
사용자 Spec 승인
→ superpowers:writing-plans
→ implementation plan 작성·검토
→ 별도 구현 승인
→ 구현·검증
→ 이번 작업 종료
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
