# 괴이기록국 현재 확정 결정

> 문서 역할: `CURRENT_CONFIRMED_DECISIONS`
> 상태: `CURRENT_ON_MAIN / PACKAGE_2_MERGED`
> 갱신일: 2026-08-02
> Package 1 구현 merge: `80160218d05e79af5442bf27d8fdeb66bcf05723`
> 병합 운영 정본 merge: `e15b9d25127170a530f66d5c3462340b806ad51d`
> Package 2 planning merge: `b4d7bd0fb82968325bcf230f3e81b8d96e142402`
> Package 2 implementation merge: `f8751e7fa7890f402c7377ea6aee64f79ef59911`
> 상세 Target: `docs/VALIDATION_TARGET_CANON.md`
> 현재 인수인계: `docs/CURRENT_HANDOFF_VALIDATION.md`
> Grill Me ledger: `docs/GRILLME_APPROVAL_MERGE_LEDGER.md`

이 문서는 현재 유효한 사용자 승인 결정과 대체 관계를 소유한다. 실제 최신 main SHA는 GitHub `main` ref에서 읽고, 문서 안의 SHA와 run ID는 역할이 고정된 병합·검증 증거로만 사용한다. 실행하지 않은 사람·시각 검증은 승인으로 간주하지 않는다.

## 1. 권위 순서

```text
최신 사용자 승인
→ GitHub 최신 main ref
→ AGENTS.md 보호 규칙
→ 이 문서
→ docs/VALIDATION_TARGET_CANON.md
→ 분야별 책임 원본
→ 실제 main 코드·데이터·Scene·테스트
→ 자동 검증 증거
→ Google Sheet 동일 Decision ID
→ 과거 PR·대화·추정
```

source-only·superseded PR은 현재 권위가 아니다. Package 2 planning과 implementation은 main에 병합됐으며, 이후 변경은 새 Decision과 별도 Gate를 요구한다.

## 2. 현재 상태

```yaml
base_version: 9.4.1
platform: PC_16_9_MOUSE_KEYBOARD
mobile: DEFERRED_AFTER_PC_VALIDATION
package_1_implementation: MERGED
package_1_automated_ci: PASS
package_1_validation_focused: 4_OF_4_PASS
package_2_menu_hierarchy: MERGED_PARALLEL_INDEPENDENT_CARDS
package_2_design: MERGED
package_2_design_spec: MERGED
package_2_implementation_plan: MERGED_AND_EXECUTED
package_2_product_implementation: MERGED_ON_MAIN
package_2_automated_code_ci: PASS
package_2_validation_focused: 5_OF_5_PASS
full_godot_regression: 58_OF_58_PASS
package_2_planning_pr_merge: MERGED
package_2_implementation_pr_merge: MERGED
future_grillme_counter: 1_OF_10
human_qa: NOT_RUN
new_player_validation: NOT_RUN
screen_01_visual_1280x720: NOT_RUN
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
```

Package 2는 SCREEN-01 Legacy·Validation 독립 진입, read-only 저장 상태 조회, allowlist 라우팅, whitelist 초기화, 시작·교체·이어하기·완료 보기 coordinator와 rollback 보호를 main에 반영했다. 최종 exact-head 검증에서 Documentation Contracts·BCA·CORE·ANNUAL이 모두 통과했고, CORE·ANNUAL은 Package 1 4/4, Package 2 5/5, 전체 58/58을 확인했다.

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
| `D-2026-08-02-BASE-V94-CANON-RECONCILIATION` | MERGED_CURRENT_GOVERNANCE | Base v9.4 계열·source PR 격리·정본 복구 | PR #125 |
| `D-2026-08-02-PACKAGE-1-PLANNING-APPROVAL` | MERGED_APPROVED_PLANNING | 기획·명세·검토 우선 | PR #125 |
| `D-2026-08-02-VALIDATION-PERSISTENCE-BOUNDARY` | MERGED_AND_IMPLEMENTED | Validation 기록 완전 독립 | PR #126 |
| `D-2026-08-02-PACKAGE-1-DESIGN-SPEC-APPROVAL` | MERGED_AND_EXECUTED | Session·Save isolation Design | PR #125 |
| `D-2026-08-02-PACKAGE-1-IMPLEMENTATION-APPROVAL` | MERGED_AND_CI_VERIFIED | Package 1 구현·테스트 | PR #126 |
| `D-2026-08-02-PACKAGE-1-SEPARATE-MERGE-AUTHORIZATION` | EXECUTED | 정본→재정렬→구현 별도 병합 | Merge gate·Sheet |
| `D-2026-08-02-GRILLME-10-MERGE-CADENCE` | CURRENT_APPROVED_GOVERNANCE | 승인 10개마다 적대적 병합 batch | Decision·ledger |
| `D-2026-08-02-PACKAGE-2-MAIN-MENU-MODE-HIERARCHY` | MERGED_AND_IMPLEMENTED | Legacy·Validation 독립 병렬 카드 | Decision·PR #129/#131 |
| `D-2026-08-02-PACKAGE-2-DESIGN-APPROVAL` | MERGED_AND_EXECUTED | 상태·초기화·이어하기·라우팅 Design | Decision·Spec |
| `D-2026-08-02-PACKAGE-2-DESIGN-SPEC-APPROVAL` | MERGED_AND_EXECUTED | Design Spec 승인·계획 작성 | Decision·Plan |
| `D-2026-08-02-PACKAGE-2-IMPLEMENTATION-APPROVAL` | MERGED_AND_CI_VERIFIED | Package 2 구현·TDD·자동 검증·병합 | Decision·PR #131·evidence |

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
pr_129: MERGED
pr_131: MERGED
pr_132: MERGED_MAIN_TO_PLANNING_SYNC
pr_133: MERGED_MAIN_TO_IMPLEMENTATION_SYNC
pr_122: CLOSED_SOURCE_DO_NOT_MERGE_AS_IS
issue_121: CLOSED_COMPLETED
package_2_planning_merge: b4d7bd0fb82968325bcf230f3e81b8d96e142402
package_2_implementation_merge: f8751e7fa7890f402c7377ea6aee64f79ef59911
final_documentation_run_30742092953: PASS
final_bca_run_30742092954: PASS
final_core_run_30742092974: PASS
final_annual_run_30742092951: PASS
package_1_focused: 4_OF_4_PASS
package_2_focused: 5_OF_5_PASS
full_godot_regression: 58_OF_58_PASS
merge_authorization: EXECUTED
```

## 7. Grill Me 운영

- 현재 미래 카운터: `1 / 10`
- 카운트 Decision: `D-2026-08-02-PACKAGE-2-MAIN-MENU-MODE-HIERARCHY`
- Design·Spec·계획·구현·병합 승인은 같은 질문의 후속 Gate이므로 추가 카운트하지 않는다.
- 10개 도달 시 GitHub·Sheet·PR·CI를 다시 적대적으로 검토한 뒤 다음 batch를 병합한다.

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
post-merge current docs·Sheet 동기화 완료
→ Package 2 종료
→ 본격 게임 기획 전환
→ 새 중요 결정은 Grill Me ledger 2/10부터 누적
```
