# 괴이기록국 Validation 현재 인수인계

> 상태: `PACKAGE_2_MENU_HIERARCHY_APPROVED / DESIGN_REVIEW_PENDING`
> 갱신일: 2026-08-02
> 작업 branch: `agent/package-2-entry-routing-planning`
> Canon merge: PR #125 / `595d45454621900e858a903fef0598a03349b794`
> Package 1 implementation merge: PR #126 / `80160218d05e79af5442bf27d8fdeb66bcf05723`
> Governance reconciliation merge: PR #127 / `e15b9d25127170a530f66d5c3462340b806ad51d`
> Package 2 planning PR: #129
> Grill Me future counter: `1 / 10`

실제 최신 main SHA는 작업 시작 시 GitHub `main` ref에서 읽는다. 위 SHA는 역할이 고정된 병합 증거다.

## 읽기 순서

```text
START_HERE.md
→ AGENTS.md
→ GitHub latest main ref
→ docs/CURRENT_CONFIRMED_DECISIONS.md
→ docs/VALIDATION_TARGET_CANON.md
→ docs/GRILLME_APPROVAL_MERGE_LEDGER.md
→ docs/decisions/D-2026-08-02-PACKAGE-2-MAIN-MENU-MODE-HIERARCHY.md
→ docs/planning/2026-08-02-package-2-entry-routing-adversarial-audit.md
→ docs/decisions/D-2026-08-02-VALIDATION-PERSISTENCE-BOUNDARY.md
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
package_2_design: REVIEW_PENDING
package_2_spec: NOT_WRITTEN
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

## 승인 Target

```text
무인 메인
→ 저승역 콜드 오픈
→ 기록국 브리핑
→ 축약 준비
→ 텍스트 노벨 조사
→ 가설·시간순 증거
→ 안전 노선 복원
→ 회수 2패턴
→ 결과 4축·최소 환류
→ 메인 복귀
```

상세는 `docs/VALIDATION_TARGET_CANON.md`가 소유한다.

## Package 1에서 구현된 기반

- 독립 Validation save repository
- atomic 저장·backup·corrupt/version/interrupted 판정
- ValidationSession lifecycle와 completion apply-once
- hidden Legacy memory guard
- GameState field-level whitelist wrapper
- invalid active Session fail-closed
- Validation focused 4/4·full regression 53/53

## Package 2에서 승인된 것

Decision: `D-2026-08-02-PACKAGE-2-MAIN-MENU-MODE-HIERARCHY`

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

필수 의미:

- 두 저장은 독립적으로 존재·표시·동작한다.
- Validation 시작은 Legacy 저장을 삭제하지 않는다.
- 한쪽 오류는 다른 쪽 행동을 막지 않는다.
- 상태 조회는 read-only다.
- 기존 Validation 기록 교체는 명시적 확인이 필요하다.
- corrupt/incompatible/recoverable 기록은 자동 삭제·덮어쓰기·승격하지 않는다.
- 라우팅은 flow-stage allowlist와 fail-closed를 사용한다.

## Package 2 Design 입력

### 예상 구성 요소

1. Validation read-only persistence summary
2. Legacy 카드 presenter
3. Validation 카드 presenter
4. start/continue/completed action coordinator
5. flow-stage route mapper
6. explicit replace confirmation
7. loading/error/accessibility state

### 상태 표시

```text
EMPTY → 새 기록 시작
EXACT active/suspended → 이어하기
EXACT completed → 완료 기록 보기
RECOVERABLE/INTERRUPTED → 복구 가능 기록 안내, 이어하기 비활성
INCOMPATIBLE → 호환 불가 안내, 보존
CORRUPT → 손상 기록 보존 안내
UNKNOWN/READ_FAILED → 메인 유지, 오류 표시
```

### 아직 미승인

- Package 2 전체 Design
- Design Spec
- 구현 계획
- 제품 코드·Scene·Save Schema·workflow 변경
- 전용 준비·추론·결과 Scene 상세
- 전체 게임 기획

## GitHub 상태

```yaml
pr_125: MERGED
pr_126: MERGED
pr_127: MERGED
pr_129: DRAFT_PLANNING
pr_122: CLOSED_SOURCE_DO_NOT_MERGE_AS_IS
issue_121: CLOSED_COMPLETED
```

## Grill Me 운영

- 역사 batch: `HISTORICAL_BATCH_0` 완료
- 현재 미래 카운터: `1 / 10`
- 현재 Decision: `D-2026-08-02-PACKAGE-2-MAIN-MENU-MODE-HIERARCHY`
- 10개 도달 시 병합 전 GitHub·Sheet·PR·CI 적대적 검토
- source-only·superseded·blocked PR 제외

## 다음 Gate

```text
Package 2 Design 사용자 검토
→ Design 승인
→ Design Spec 작성·self-review
→ Spec 승인
→ writing-plans
→ 별도 구현 승인
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
