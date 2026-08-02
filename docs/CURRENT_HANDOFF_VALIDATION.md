# 괴이기록국 Validation 현재 인수인계

> 상태: `PACKAGE_1_DESIGN_REVIEW_READY`
> 갱신일: 2026-08-02
> Package 1 승인: `D-2026-08-02-PACKAGE-1-PLANNING-APPROVAL`
> Persistence 승인: `D-2026-08-02-VALIDATION-PERSISTENCE-BOUNDARY`
> Parent: `D-2026-08-02-BASE-V94-CANON-RECONCILIATION`
> Proposal: `P-2026-08-02-VALIDATION-CHANGE-PROPOSAL`
> 기준 main: `7277b9cececa56532f7b0d11c1a02fd3d5642750`
> 제품 구현 권한: `PLANNING_AND_DOCUMENTATION_ONLY`

## 현재 읽기 순서

```text
START_HERE.md
→ AGENTS.md
→ docs/CURRENT_CONFIRMED_DECISIONS.md
→ docs/VALIDATION_TARGET_CANON.md
→ docs/decisions/D-2026-08-02-PACKAGE-1-PLANNING-APPROVAL.md
→ docs/decisions/D-2026-08-02-VALIDATION-PERSISTENCE-BOUNDARY.md
→ docs/planning/2026-08-02-package-1-planning-adversarial-audit.md
→ docs/superpowers/specs/2026-08-02-validation-session-save-isolation-design.md
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
package_1_design: REVIEW_READY
planning_authority: SAFE_PLANNING_FIXES
canon: RECONCILED_ON_BRANCH_PENDING_MAIN
technical_readback: COMPLETE
change_proposal: READY
package_1_adversarial_audit: COMPLETE
implementation: CURRENT_IMPLEMENTATION_LEGACY
validation_build: NOT_AUTHORIZED
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

## Package 1 승인 범위

사용자의 `Package 1 승인`은 “기획 작성부터 진행”에 따라 **설계·명세·적대적 감사 승인**으로 기록했다.

허용:

- Session·Save isolation 기획 작성
- 상태·저장·복귀·손상·버전·롤백 계약 보완
- 상세 수치·기술 기본값의 GPT 권장안 적용
- 중요 제품 결정만 Grill Me
- GitHub 정본·PR·Sheet 동기화

금지:

- GDScript·Scene·JSON·Schema·Workflow 구현
- Codex Build Goal
- Package 2 이상 구현
- PR 병합
- Runtime·Human·POC 통과 선언

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

## 기술 검수 결론

- `project.godot`의 시작 Scene은 `res://scenes/main_menu.tscn`이다.
- `scripts/core/game_bootstrap.gd`는 최신 `main`에 존재하지 않는다.
- `main_menu.gd`가 Legacy 새 시작·이어하기·`current_scene_path` 이동을 직접 소유한다.
- `GameState`의 `mvp-039` 단일 저장은 캠페인·조사·회수·보고서·경제까지 함께 직렬화한다.
- 기존 대화·조사·노선 복원·guided 회수는 재사용 가치와 현재 회귀 테스트가 있다.
- `preparation_scene.gd`는 반일 일정·일상·외부 접점·시장까지 초기화한다.
- `result_scene.gd::_ready()`는 진입 즉시 Legacy 보고서와 캠페인 상태를 갱신한다.
- 실제 전체 회귀 기준은 `tests/run_godot_regression.sh`의 49개 진입점이다.

권장 전체 구조:

```text
별도 ValidationSession Autoload
+ 별도 Validation Save Repository
+ 기존 dialogue/investigation/minigame/battle 전문 절차 재사용
+ 전용 validation_preparation_scene
+ 전용 validation_reasoning_scene
+ 전용 validation_result_scene
+ pure result calculator
+ apply-once effect ledger
```

## Package 1 Design 요약

Design Spec:

- `docs/superpowers/specs/2026-08-02-validation-session-save-isolation-design.md`

핵심 계약:

1. Validation Session 활성은 explicit token·version·episode 검증으로만 성립한다.
2. 유효하지 않은 active Session은 Legacy로 fallback하지 않고 양쪽 저장을 모두 금지한다.
3. runtime snapshot은 denylist가 아니라 field-level whitelist로 구성한다.
4. Legacy 파일 bytes와 campaign/economy/relationship/faction/market 메모리를 모두 무변경으로 보호한다.
5. corrupt 저장은 자동 삭제하지 않고 격리 보존한다.
6. exact/migratable/incompatible/corrupt/interrupted/recoverable 판정 Matrix를 사용한다.
7. create·activate·save·load·abandon·delete·complete·deactivate lifecycle을 분리한다.
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

모두 `RECOMMENDED_DEFAULT` 또는 `TEST_VALUE`이며 실행·플레이테스트 증거에 따라 조정한다.

## Design 자기검수

```yaml
placeholder_scan: PASS
internal_consistency: PASS
scope_single_package: PASS
ambiguity_scan: PASS
approved_persistence_boundary_reflected: PASS
legacy_file_and_memory_protection: PASS
implementation_authority_respected: PASS
product_diff: 0
runtime_evidence: NOT_RUN
human_evidence: NOT_RUN
```

## 다음 Gate

```text
사용자 Package 1 Design Spec 승인
→ superpowers writing-plans
→ 구현 계획 self-review
→ 별도 Package 1 구현 승인
→ 승인 후에만 RED 테스트와 최소 구현
```

## GitHub·Sheet 상태

- PR #120: `CLOSED_UNMERGED / SUPERSEDED_BY_BASE_V9_4_MAIN`
- PR #122: `SOURCE_BRANCH / DO_NOT_MERGE_AS_IS`
- Draft PR #125: Canon·Audit·Package 1 Design surface
- 브랜치: `agent/v9-4-canon-reconciliation`
- 제품 경로 diff: 0
- Google Sheet: `D-2026-08-02-VALIDATION-PERSISTENCE-BOUNDARY`로 exact range 재조회 완료
- PR 병합: `NOT_REQUESTED`
