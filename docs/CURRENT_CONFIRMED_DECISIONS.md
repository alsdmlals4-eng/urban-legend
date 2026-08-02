# 괴이기록국 현재 확정 결정

> 문서 역할: `CURRENT_CONFIRMED_DECISIONS`
> 상태: `CURRENT_ON_STACKED_IMPLEMENTATION_PR / LATEST_COMPLETED_EXACT_HEAD_PASS`
> 갱신일: 2026-08-02
> Package 1 구현 merge: `80160218d05e79af5442bf27d8fdeb66bcf05723`
> 병합 운영 정본 merge: `e15b9d25127170a530f66d5c3462340b806ad51d`
> Package 2 planning PR: #129
> Package 2 implementation PR: #131
> 상세 Target: `docs/VALIDATION_TARGET_CANON.md`
> 현재 인수인계: `docs/CURRENT_HANDOFF_VALIDATION.md`
> Grill Me ledger: `docs/GRILLME_APPROVAL_MERGE_LEDGER.md`

이 문서는 현재 유효한 사용자 승인 결정과 대체 관계를 소유한다. 실제 최신 main·PR SHA는 GitHub ref에서 읽고, 문서 안의 SHA와 run ID는 역할이 고정된 병합·검증 증거로만 사용한다. 실행하지 않은 사람·시각 검증은 승인으로 간주하지 않는다.

## 1. 권위 순서

```text
최신 사용자 승인
→ GitHub 최신 main ref
→ AGENTS.md 보호 규칙
→ 이 문서
→ docs/VALIDATION_TARGET_CANON.md
→ 분야별 책임 원본
→ 실제 branch 코드·데이터·Scene·테스트
→ 자동 검증 증거
→ Google Sheet 동일 Decision ID
→ 과거 PR·대화·추정
```

source-only·superseded PR은 현재 권위가 아니다. PR #131의 구현은 main 병합 전까지 승인된 구현 후보이며 main 완료 상태가 아니다.

## 2. 현재 상태

```yaml
base_version: 9.4.0
planning_branch: agent/package-2-entry-routing-planning
implementation_branch: agent/package-2-entry-routing-implementation
platform: PC_16_9_MOUSE_KEYBOARD
mobile: DEFERRED_AFTER_PC_VALIDATION
package_1_implementation: MERGED
package_1_automated_ci: PASS
package_1_validation_focused: 4_OF_4_PASS
package_2_menu_hierarchy: APPROVED_PARALLEL_INDEPENDENT_CARDS
package_2_design: APPROVED
package_2_design_spec: APPROVED
package_2_implementation_plan: APPROVED_AND_EXECUTED
package_2_product_implementation: COMPLETE_ON_PR_131
package_2_automated_code_ci: PASS
package_2_validation_focused: 5_OF_5_PASS
full_godot_regression: 58_OF_58_PASS
latest_completed_exact_head_verification: PASS
package_2_planning_pr_merge: NOT_AUTHORIZED
package_2_implementation_pr_merge: NOT_AUTHORIZED
future_grillme_counter: 1_OF_10
human_qa: NOT_RUN
new_player_validation: NOT_RUN
screen_01_visual_1280x720: NOT_RUN
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
```

Package 2의 제품 코드와 자동 테스트는 stacked Draft PR #131에서 완료됐다. 최근 완료 exact-head 검증에서 Documentation Contracts·BCA·CORE·ANNUAL이 모두 통과했고, CORE·ANNUAL은 Package 1 4/4, Package 2 5/5, 전체 58/58을 확인했다. planning·implementation 병합은 별도 사용자 승인 전 금지한다.

## 3. 승인 Validation 흐름

```text
SCREEN-01 무인 메인
→ SIT-001 저승역 콜드 오픈
→ SIT-002 기록국 브리핑
→ SCREEN-03 / SIT-003 축약 준비
→ SCREEN-02 / SIT-004 텍스트 노벨 조사
→ SCREEN-02 전문 절차 / SIT-005 사건 가설·시간순 증거
→ SCREEN-02 전문 절차 / SIT-006 안전 노선 복원
→ SCREEN-02 전문 절차 / SIT-007 회수 2패턴
→ SCREEN-04 / SIT-008 결과 4축·최소 환류
→ SCREEN-01 메인 복귀
```

Package 2는 SCREEN-01에서 SIT-001·SIT-002·SIT-004의 현재 구현 Scene만 allowlist로 연다. SIT-003·SIT-005~008은 전용 Scene 구현 전 `NOT_AVAILABLE`로 fail-closed한다.

## 4. 현재 Decision 목록

| Decision ID | 현재 상태 | 핵심 | 책임 원본 |
|---|---|---|---|
| `D-2026-07-31-CANON-SHEET-SYNC` | CURRENT_APPROVED_GOVERNANCE | 주요 승인을 GitHub·Sheet에 같은 ID로 동기화 | 이 문서·Sheet |
| `D-2026-07-31-TEXT-NOVEL-CORE-PRESENTATION` | APPROVED_PLANNING_BASELINE | 일반 조사·플레이는 텍스트 노벨 화면 | `VALIDATION_TARGET_CANON.md` |
| `D-2026-07-31-VISUAL-ART-DIRECTION` | APPROVED_PLANNING_BASELINE | 다크 현대 오컬트·세미리얼 애니·기관 UI | `VALIDATION_TARGET_CANON.md` |
| `D-2026-07-31-VALIDATION-SCREEN-AUTHORITY` | SUPERSEDED_IN_PART | 화면 책임 분리 | `VALIDATION_TARGET_CANON.md` |
| `D-2026-07-31-EXTENDED-MANAGEMENT-SCREENS` | APPROVED_LONG_TERM_TARGET | 일정·연구·보급 화면 유지 | `VALIDATION_TARGET_CANON.md` |
| `D-2026-07-31-MAIN-DAILY-SCHEDULE-PRESENTATION` | APPROVED_LONG_TERM_TARGET | 하루 주요 활동 1개·자동 기본 휴식 | `VALIDATION_TARGET_CANON.md` |
| `D-2026-07-31-AFTERLIFE-TIMELINE-EVIDENCE` | APPROVED_PLANNING_BASELINE | 저승역 시간순 증거 | `VALIDATION_TARGET_CANON.md` |
| `D-2026-07-31-AFTERLIFE-RECOVERY-PATTERNS` | APPROVED_PLANNING_BASELINE | 회수 2패턴 | `VALIDATION_TARGET_CANON.md` |
| `D-2026-08-01-SCHEDULE-REST-SEMANTICS` | APPROVED_TARGET_NOT_IMPLEMENTED | 기본 휴식 의미 | `VALIDATION_TARGET_CANON.md` |
| `D-2026-08-01-PROVISIONING-AUTHORITY` | APPROVED_TARGET_NOT_IMPLEMENTED | 기록국 보급실 | `VALIDATION_TARGET_CANON.md` |
| `D-2026-08-01-VALIDATION-SCOPE-FILTER` | APPROVED_TARGET_NOT_IMPLEMENTED | 핵심만 노출 | `VALIDATION_TARGET_CANON.md` |
| `D-2026-08-01-VALIDATION-SCREEN-SIT-PACKAGE` | APPROVED_PLANNING_BASELINE | SCREEN-01~07·SIT-001~008 | `VALIDATION_TARGET_CANON.md` |
| `D-2026-08-01-VALIDATION-RESULT-AXES` | APPROVED_PLANNING_BASELINE | 결과 원시 4축 | `VALIDATION_TARGET_CANON.md` |
| `D-2026-08-01-VALIDATION-SAVE-TEST-MIGRATION` | IMPLEMENTED_PACKAGE_1_AND_2_BOUNDARY | Legacy 병렬 저장·복귀·중복 방지 | Canon + Package evidence |
| `D-2026-08-01-RECOMMENDED-BATCH-APPROVAL` | CURRENT_APPROVED_GOVERNANCE | 안전 권장안 일괄 승인 | 역사 reconciliation |
| `D-2026-08-01-VALIDATION-PLANNING-FINAL-APPROVAL` | APPROVED_FINAL_PLANNING_BASELINE | Validation 기획 최종 승인 | `VALIDATION_TARGET_CANON.md` |
| `D-2026-08-01-LEGACY-PR-DISPOSITION` | SUPERSEDED_IN_PART | 구형 PR 직접 병합 금지 | Base v9.4 reconciliation |
| `D-2026-08-02-BASE-V94-CANON-RECONCILIATION` | MERGED_CURRENT_GOVERNANCE | Base v9.4·source PR 격리·정본 복구 | PR #125 |
| `D-2026-08-02-PACKAGE-1-PLANNING-APPROVAL` | MERGED_APPROVED_PLANNING | 기획·명세·검토 우선 | PR #125 |
| `D-2026-08-02-VALIDATION-PERSISTENCE-BOUNDARY` | MERGED_AND_IMPLEMENTED | Validation 기록 완전 독립 | PR #126 |
| `D-2026-08-02-PACKAGE-1-DESIGN-SPEC-APPROVAL` | MERGED_AND_EXECUTED | Session·Save isolation Design | PR #125 |
| `D-2026-08-02-PACKAGE-1-IMPLEMENTATION-APPROVAL` | MERGED_AND_CI_VERIFIED | Package 1 구현·테스트 | PR #126 |
| `D-2026-08-02-PACKAGE-1-SEPARATE-MERGE-AUTHORIZATION` | EXECUTED | 정본→재정렬→구현 별도 병합 | Merge gate·Sheet |
| `D-2026-08-02-GRILLME-10-MERGE-CADENCE` | CURRENT_APPROVED_GOVERNANCE | 승인 10개마다 적대적 병합 batch | Decision·ledger |
| `D-2026-08-02-PACKAGE-2-MAIN-MENU-MODE-HIERARCHY` | APPROVED_PENDING_BATCH_MERGE | Legacy·Validation 독립 병렬 카드 | Decision·PR #129 |
| `D-2026-08-02-PACKAGE-2-DESIGN-APPROVAL` | APPROVED | 상태·초기화·이어하기·라우팅 Design | Decision·Spec |
| `D-2026-08-02-PACKAGE-2-DESIGN-SPEC-APPROVAL` | APPROVED_AND_EXECUTED | Design Spec 승인·계획 작성 | Decision·Plan |
| `D-2026-08-02-PACKAGE-2-IMPLEMENTATION-APPROVAL` | EXECUTED_AUTOMATED_CI_VERIFIED | Package 2 구현·TDD·자동 검증 | Decision·PR #131·evidence |

## 5. Package 2 구현 계약과 결과

```text
Legacy 기존 진행 카드
- 새 캠페인
- 이어하기
- Legacy 저장 상태

Validation 기록 카드
- 새 기록 시작
- 이어하기
- 완료 기록 보기
- 오류·호환 상태
```

구현된 보호:

- 메뉴 조회는 독립 read-only inspector 사용
- Validation 시작에서 Legacy 저장 삭제 금지
- `reset_run_state()`·`restart_afterlife_station_flow()` 재사용 금지
- active·suspended·completed 행동 분리
- 기존 Validation 교체는 record identity 재검증 후 명시적 확인
- corrupt·incompatible·recoverable·interrupted 자동 변경 금지
- flow-stage allowlist·unknown/not-available fail-closed
- whitelist-only runtime initializer
- single-flight mutation lock
- route·저장 실패 시 runtime rollback·Session abandon
- Legacy file bytes·hidden memory equality 검증
- completed viewer는 GameState load 없는 read-only summary

책임 문서:

- `docs/superpowers/specs/2026-08-02-package-2-main-menu-entry-routing-design.md`
- `docs/superpowers/plans/2026-08-02-package-2-main-menu-entry-routing-implementation-plan.md`
- `docs/implementation/2026-08-02-package-2-main-menu-entry-routing-evidence.md`

## 6. GitHub·검증 상태

```yaml
pr_125: MERGED
pr_126: MERGED
pr_127: MERGED
pr_129: DRAFT_PLANNING_APPROVED_NOT_MERGED
pr_131: DRAFT_IMPLEMENTATION_COMPLETE_NOT_MERGED
pr_122: CLOSED_SOURCE_DO_NOT_MERGE_AS_IS
issue_121: CLOSED_COMPLETED
latest_completed_documentation_run_30741361754: PASS
latest_completed_bca_run_30741361726: PASS
latest_completed_core_run_30741361717: PASS
latest_completed_annual_run_30741361720: PASS
package_1_focused: 4_OF_4_PASS
package_2_focused: 5_OF_5_PASS
full_godot_regression: 58_OF_58_PASS
merge_authorization: NOT_GRANTED
```

## 7. Grill Me 운영

- 현재 미래 카운터: `1 / 10`
- 카운트 Decision: `D-2026-08-02-PACKAGE-2-MAIN-MENU-MODE-HIERARCHY`
- Design·Spec·계획·구현 승인은 같은 질문의 후속 Gate이므로 추가 카운트하지 않는다.
- 10개 도달 시 GitHub·Sheet·PR·CI를 다시 적대적으로 검토한 뒤 병합한다.
- 이번 Package 2는 사용자가 별도 병합을 승인하면 10개 도달 전에도 승인 범위만 병합할 수 있다.

## 8. 미검증 경계

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

## 9. 다음 Gate

```text
PR #129/#131 diff·review·Sheet 적대적 감사
→ 사용자 별도 병합 승인
→ PR #129 planning 병합
→ PR #131 main retarget
→ stacked BCA branch 허용 제거
→ fresh exact-head Docs·BCA·CORE·ANNUAL
→ PR #131 구현 병합
→ Package 2 종료
→ 본격 게임 기획 전환
```
