# 괴이기록국 Validation 현재 인수인계

> 상태: `PACKAGE_1_DESIGN_APPROVED / IMPLEMENTATION_PLAN_REVIEW_READY`
> 갱신일: 2026-08-02
> Package 1 기획 승인: `D-2026-08-02-PACKAGE-1-PLANNING-APPROVAL`
> Persistence 승인: `D-2026-08-02-VALIDATION-PERSISTENCE-BOUNDARY`
> Design 승인: `D-2026-08-02-PACKAGE-1-DESIGN-SPEC-APPROVAL`
> Parent: `D-2026-08-02-BASE-V94-CANON-RECONCILIATION`
> Proposal: `P-2026-08-02-VALIDATION-CHANGE-PROPOSAL`
> 기준 main: `7277b9cececa56532f7b0d11c1a02fd3d5642750`
> 제품 구현 권한: `NOT_AUTHORIZED`

## 현재 읽기 순서

```text
START_HERE.md
→ AGENTS.md
→ docs/CURRENT_CONFIRMED_DECISIONS.md
→ docs/VALIDATION_TARGET_CANON.md
→ docs/decisions/D-2026-08-02-PACKAGE-1-PLANNING-APPROVAL.md
→ docs/decisions/D-2026-08-02-VALIDATION-PERSISTENCE-BOUNDARY.md
→ docs/decisions/D-2026-08-02-PACKAGE-1-DESIGN-SPEC-APPROVAL.md
→ docs/planning/2026-08-02-package-1-planning-adversarial-audit.md
→ docs/superpowers/specs/2026-08-02-validation-session-save-isolation-design.md
→ docs/superpowers/plans/2026-08-02-validation-session-save-isolation-implementation-plan.md
→ docs/superpowers/plans/2026-08-02-validation-change-proposal.md
→ docs/CURRENT_STATUS.md
→ 실제 main 코드·데이터·테스트
```

읽기 전용 기술 Plan은 완료 증거로 보존한다.

- `docs/superpowers/plans/2026-08-02-validation-read-only-technical-plan.md`

## 현재 상태

```yaml
base: 9.4.0
base_adoption_main: 7277b9cececa56532f7b0d11c1a02fd3d5642750
planning: PACKAGE_1_PLANNING_APPROVED
persistence_boundary: APPROVED_FULLY_INDEPENDENT
package_1_design: APPROVED
implementation_plan: REVIEW_READY
planning_authority: SAFE_PLANNING_FIXES
canon: RECONCILED_ON_BRANCH_PENDING_MAIN
technical_readback: COMPLETE
change_proposal: READY
package_1_adversarial_audit: COMPLETE
implementation: CURRENT_IMPLEMENTATION_LEGACY
validation_build: NOT_AUTHORIZED
ci: NOT_RUN_FOR_PACKAGE_1_IMPLEMENTATION
runtime: NOT_RUN
human_qa: NOT_RUN
new_player_validation: NOT_RUN
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
platform: PC_16_9_MOUSE_KEYBOARD
mobile: FUTURE_CONSIDERATION_NOT_IN_CURRENT_SCOPE
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

## 확정된 영속 관계

`D-2026-08-02-VALIDATION-PERSISTENCE-BOUNDARY`에서 권장안 A를 승인했다.

```text
Validation 진행·완료 기록 = Validation 저장에만 유지
Legacy·본편 campaign/economy/relationship/report/reward/unlock = 무변경
본편 자동 공유 = 금지
공용 프로필 = 생성하지 않음
본편 가져오기 = 별도 Decision 전까지 보류
```

Validation 완료는 본편 진행 완료나 보상 획득을 뜻하지 않는다.

## 승인된 Package 1 Design

Design Spec:

- `docs/superpowers/specs/2026-08-02-validation-session-save-isolation-design.md`

승인 Decision:

- `docs/decisions/D-2026-08-02-PACKAGE-1-DESIGN-SPEC-APPROVAL.md`

핵심 계약:

1. Validation Session 활성은 explicit token·version·episode·lifecycle 검증으로만 성립한다.
2. 유효하지 않은 active Session은 Legacy로 fallback하지 않고 양쪽 저장을 모두 금지한다.
3. runtime snapshot은 denylist가 아니라 field-level whitelist로 구성한다.
4. Legacy 파일 bytes와 campaign/economy/relationship/faction/market 메모리를 모두 무변경으로 보호한다.
5. corrupt 저장은 자동 삭제하지 않고 격리 보존한다.
6. exact/migratable/incompatible/corrupt/interrupted/recoverable 판정 Matrix를 사용한다.
7. create·activate·save·load·suspend·resume·abandon·delete·complete·deactivate lifecycle을 분리한다.
8. temp write→검증→replace와 정상 backup 1세대를 권장 기본값으로 둔다.
9. Package 1은 Session·Save 계약까지만 담당하며 메뉴 표시 UX는 Package 2다.

권장 기본값:

```yaml
validation_slot_count: 1
save_version: validation-save-v1
normal_backup_generations: 1
corrupt_save_policy: PRESERVE_AND_QUARANTINE_NO_AUTO_DELETE
incompatible_newer_save_policy: INSPECT_ONLY_NO_DOWNGRADE
activation_policy: EXPLICIT_FAIL_CLOSED
hidden_state_contract: FILE_AND_MEMORY_NO_EFFECT
```

## Package 1 Implementation Plan

계획 원본:

- `docs/superpowers/plans/2026-08-02-validation-session-save-isolation-implementation-plan.md`

계획 상태: `REVIEW_READY`

작업 단위:

1. 별도 Validation repository와 atomic persistence
2. Session lifecycle·completion idempotency
3. GameState field-level whitelist와 hidden-state guard
4. Autoload·active-session fail-closed save routing
5. corrupt/version/interrupted/backup·양방향 no-effect 적대적 Matrix
6. focused 4-entry·CORE·ANNUAL·full 53-entry 검증 배관
7. exact-head evidence·rollback·동일 Decision ID 정본·Sheet 동기화

실행 기본 경로:

```text
PR #125 문서 정본 병합
→ 최신 main exact SHA 확인
→ isolated worktree/branch agent/package-1-session-save-isolation
→ RED→GREEN 구현
→ 별도 Draft implementation PR
```

PR #125 병합 전에 구현을 승인할 경우 exact HEAD 기반 stacked PR만 허용하고, 문서 PR 병합 후 최신 main으로 rebase·retarget한다. PR #125 브랜치에 제품 코드를 혼합하지 않는다.

## 적대적 검토로 차단한 실패

- Validation repository의 Legacy path 접근
- invalid active Session의 Legacy fallback
- denylist 누락으로 campaign·경제·보고서가 저장되는 문제
- 검증 전 부분 restore
- 숨은 메모리 상태 drift
- corrupt/newer 저장의 자동 삭제·덮어쓰기
- Legacy clear의 Validation 파일 삭제
- completion 중복 적용
- Package 2 이상 UI·콘텐츠 범위 혼입
- stale regression entrypoint count

## 다음 Gate

```text
Package 1 Design Spec = APPROVED
Implementation Plan = REVIEW_READY
→ 사용자 Package 1 구현 승인
→ PR #125 병합 또는 stacked 실행 경계 확인
→ isolated worktree/branch
→ TDD 구현
```

현재 금지:

- GDScript·project.godot·tests·workflow 구현
- Codex 실행
- Draft 해제·병합·auto-merge
- Runtime·CI·Human PASS 주장

## GitHub·Sheet 상태

- PR #120: `CLOSED_UNMERGED / SUPERSEDED_BY_BASE_V9_4_MAIN`
- PR #122: `SOURCE_BRANCH / DO_NOT_MERGE_AS_IS`
- Draft PR #125: Canon·Audit·Package 1 Design·Implementation Plan surface
- 브랜치: `agent/v9-4-canon-reconciliation`
- 제품 경로 diff: 0
- PR 병합: `NOT_REQUESTED`
- Google Sheet: Design 승인 Decision과 Implementation Plan 상태를 같은 ID로 동기화 후 exact range 재조회 필요
