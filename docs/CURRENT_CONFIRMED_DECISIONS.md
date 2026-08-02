# 괴이기록국 현재 확정 결정

> 문서 역할: `CURRENT_CONFIRMED_DECISIONS`
> 상태: `MAIN_PACKAGE_2_MERGED / YEAR_ONE_PLANNING_SECTION_3_APPROVED_ON_DRAFT_PR_135`
> 갱신일: 2026-08-02
> Package 1 구현 merge: `80160218d05e79af5442bf27d8fdeb66bcf05723`
> 병합 운영 정본 merge: `e15b9d25127170a530f66d5c3462340b806ad51d`
> Package 2 planning merge: `b4d7bd0fb82968325bcf230f3e81b8d96e142402`
> Package 2 implementation merge: `f8751e7fa7890f402c7377ea6aee64f79ef59911`
> 1년차 캠페인 Draft PR: #135
> 1년차 Design: `docs/planning/2026-08-02-year-one-campaign-master-structure-design.md`
> 상세 Validation Target: `docs/VALIDATION_TARGET_CANON.md`
> 현재 인수인계: `docs/CURRENT_HANDOFF_VALIDATION.md`
> Grill Me ledger: `docs/GRILLME_APPROVAL_MERGE_LEDGER.md`

이 문서는 현재 유효한 사용자 승인 결정과 대체 관계를 소유한다. 실제 최신 main SHA는 GitHub `main` ref에서 읽고, 문서 안의 SHA와 run ID는 역할이 고정된 병합·검증 증거로만 사용한다. 실행하지 않은 사람·시각 검증은 승인으로 간주하지 않는다.

## 1. 권위 순서

```text
최신 사용자 승인
→ GitHub 최신 main ref
→ AGENTS.md 보호 규칙
→ docs/PROJECT_CORE.md
→ 이 문서
→ 분야별 책임 원본과 승인 Decision
→ 실제 main 코드·데이터·Scene·테스트
→ 자동·사람 검증 증거
→ Google Sheet 동일 Decision ID
→ 과거 PR·대화·추정
```

Package 2 planning과 implementation은 main에 병합됐다. 1년차 캠페인 기획은 Draft PR #135에서 진행 중이며, 승인된 Design 결정은 구현 권한이나 Production 확대를 의미하지 않는다.

## 2. 현재 상태

```yaml
base_version: 9.4.1
platform: PC_16_9_MOUSE_KEYBOARD
mobile: DEFERRED_AFTER_PC_VALIDATION
package_1_implementation: MERGED
package_1_automated_ci: PASS
package_1_validation_focused: 4_OF_4_PASS
package_2_menu_hierarchy: MERGED_PARALLEL_INDEPENDENT_CARDS
package_2_product_implementation: MERGED_ON_MAIN
package_2_automated_code_ci: PASS
package_2_validation_focused: 5_OF_5_PASS
full_godot_regression: 58_OF_58_PASS
year_one_planning_priority: APPROVED
year_one_design_section_1: APPROVED
year_one_design_section_2: APPROVED
year_one_design_section_3: APPROVED_SIMPLE_DISTINCT_MINIGAMES
main_content_authority: INVESTIGATION_AND_RECOVERY
schedule_role: SUPPORT_PREPARATION_FEEDBACK_LAYER
year_one_design_section_4: IN_REVIEW
grillme_counter: 6_OF_10
human_qa: NOT_RUN
new_player_validation: NOT_RUN
screen_01_visual_1280x720: NOT_RUN
year_one_minigame_human_validation: NOT_RUN
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
```

## 3. 현재 제품 코어 권위

괴이기록국의 메인 콘텐츠는 괴이 사건에 진입해 조사와 회수를 수행하는 경험이다.

```text
괴이 사건 진입
→ 조사
→ 기록 비교·가설
→ 위험 검증
→ 회수
→ 안정화·사건 종결
→ 결과·기록·환류
```

- 조사는 관측·기록 비교·가설·위험 검증을 포함한다.
- 회수는 전조 해석·대응·안정화·봉쇄·포획 창·잔향 회수를 포함한다.
- 일정·육성·동료·장비·연구·기관은 메인 콘텐츠를 준비하고 결과를 환류하는 지원 계층이다.
- 일정이 사건을 자동 해결하거나 조사·회수의 정답을 대신해서는 안 된다.
- 각 분기의 핵심 괴담 1개는 완전한 조사·회수·안정화·종결 경험을 제공한다.

책임 Decision:

- `D-2026-08-02-MAIN-CONTENT-INVESTIGATION-RECOVERY-AUTHORITY`

## 4. 1년차 캠페인 승인 구조

### 캠페인 목적

> 권나래가 한 해 동안 무엇을 이해하고, 누구의 책임을 선택하며, 어떤 방식으로 괴이를 기록하는 요원이 되었는가?

### 성장 축

```text
봄 — 배우고 소속된다
→ 여름 — 전문화하고 약속한다
→ 가을 — 가치 충돌의 대가를 치른다
→ 겨울 — 축적한 판단으로 책임을 완수한다
```

### 핵심 사건 구조

- 분기마다 핵심 괴담 1개
- 1년 총 4개
- 각 사건은 독립적으로 안정화·종결
- 완전 소멸은 기본 성공 조건이 아님
- 독립 사건 4개 + 강한 결과 환류 + 약한 공통 미스터리
- 지식·관계/기관·현장 3축 환류
- 다음 분기는 이전 결과 최소 2축 사용
- 겨울은 3축 모두 사용
- 실패 전진 사용

### 분기 역할

| 분기 | 역할 | 핵심 |
|---|---|---|
| 봄 | 기준 사건 | 관측·가설·검증·회수·기록의 기준 문법 |
| 여름 | 선택 사건 | 전문성·협업·준비 방식과 빈틈 선택 |
| 가을 | 충돌 사건 | 규칙을 이해한 상태에서 책임의 대가 선택 |
| 겨울 | 종합 사건 | 축적된 기록·관계·연구·실패 조합 |

### 분기별 전용 미니게임

각 분기는 서로 다른 전용 미니게임을 사용한다. 미니게임은 조사 또는 회수 내부의 짧은 규칙 적용 절차다.

```text
봄: 순서·경로 복원
여름: 대상·역할 배치
가을: 보호·공개 범위 조절
겨울: 과거 기록 비교·적용
```

초간단 조작 목표:

- 설명 30초 이내 이해
- 입력 종류 1~2개
- 별도 튜토리얼 스테이지 불필요
- 기본 1~3분
- 즉시 실패 이유
- 빠른 복구
- 조사 지식 우선
- 접근성 대체 입력

이 수치는 사람 검증 전에는 달성으로 선언하지 않는다.

## 5. 승인 Validation 흐름

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

## 6. 현재 Decision 목록

| Decision ID | 현재 상태 | 핵심 | 책임 원본 |
|---|---|---|---|
| `D-2026-07-31-CANON-SHEET-SYNC` | CURRENT_APPROVED_GOVERNANCE | 주요 승인을 GitHub·Sheet에 같은 ID로 동기화 | 이 문서·Sheet |
| `D-2026-07-31-TEXT-NOVEL-CORE-PRESENTATION` | APPROVED_PLANNING_BASELINE | 일반 조사·플레이는 텍스트 노벨 화면 | `VALIDATION_TARGET_CANON.md` |
| `D-2026-07-31-VISUAL-ART-DIRECTION` | APPROVED_PLANNING_BASELINE | 다크 현대 오컬트·세미리얼 애니·기관 UI | `VALIDATION_TARGET_CANON.md` |
| `D-2026-07-31-VALIDATION-SCREEN-AUTHORITY` | SUPERSEDED_IN_PART | 화면 책임 분리 | `VALIDATION_TARGET_CANON.md` |
| `D-2026-07-31-EXTENDED-MANAGEMENT-SCREENS` | APPROVED_LONG_TERM_TARGET | 일정·연구·보급 지원 화면 유지 | `VALIDATION_TARGET_CANON.md` |
| `D-2026-07-31-MAIN-DAILY-SCHEDULE-PRESENTATION` | APPROVED_SUPPORT_LAYER_TARGET | 하루 주요 활동 1개·자동 기본 휴식 | `VALIDATION_TARGET_CANON.md` |
| `D-2026-07-31-AFTERLIFE-TIMELINE-EVIDENCE` | APPROVED_PLANNING_BASELINE | 저승역 시간순 증거 | `VALIDATION_TARGET_CANON.md` |
| `D-2026-07-31-AFTERLIFE-RECOVERY-PATTERNS` | APPROVED_PLANNING_BASELINE | 회수 2패턴 | `VALIDATION_TARGET_CANON.md` |
| `D-2026-08-01-SCHEDULE-REST-SEMANTICS` | APPROVED_SUPPORT_LAYER_NOT_IMPLEMENTED | 기본 휴식 의미 | `VALIDATION_TARGET_CANON.md` |
| `D-2026-08-01-PROVISIONING-AUTHORITY` | APPROVED_SUPPORT_LAYER_NOT_IMPLEMENTED | 기록국 보급실 | `VALIDATION_TARGET_CANON.md` |
| `D-2026-08-01-VALIDATION-SCOPE-FILTER` | APPROVED_TARGET_NOT_IMPLEMENTED | 핵심만 노출 | `VALIDATION_TARGET_CANON.md` |
| `D-2026-08-01-VALIDATION-SCREEN-SIT-PACKAGE` | APPROVED_PLANNING_BASELINE | SCREEN-01~07·SIT-001~008 | `VALIDATION_TARGET_CANON.md` |
| `D-2026-08-01-VALIDATION-RESULT-AXES` | APPROVED_PLANNING_BASELINE | 결과 원시 4축 | `VALIDATION_TARGET_CANON.md` |
| `D-2026-08-01-VALIDATION-SAVE-TEST-MIGRATION` | IMPLEMENTED_PACKAGE_1_AND_2_BOUNDARY | Legacy 병렬 저장·복귀·중복 방지 | Canon + Package evidence |
| `D-2026-08-02-PACKAGE-2-MAIN-MENU-MODE-HIERARCHY` | MERGED_AND_IMPLEMENTED | Legacy·Validation 독립 병렬 카드 | PR #129/#131 |
| `D-2026-08-02-PACKAGE-2-IMPLEMENTATION-APPROVAL` | MERGED_AND_CI_VERIFIED | Package 2 구현·TDD·자동 검증·병합 | PR #131·evidence |
| `D-2026-08-02-YEAR-ONE-CAMPAIGN-MASTER-STRUCTURE-FIRST` | APPROVED_PLANNING_PRIORITY | 개별 콘텐츠보다 4분기 마스터 구조 우선 | Decision·PR #135 |
| `D-2026-08-02-YEAR-ONE-CAMPAIGN-PURPOSE-AND-QUARTERLY-CASE` | APPROVED_DESIGN_SECTION_1 | 4분기 성장 축·분기당 핵심 괴담 1개 | Decision·Design |
| `D-2026-08-02-YEAR-ONE-QUARTERLY-CASE-ROLE-AND-FEEDBACK` | APPROVED_DESIGN_SECTION_2 | 독립 4사건·3축 환류·실패 전진 | Decision·Design |
| `D-2026-08-02-YEAR-ONE-QUARTERLY-SIMPLE-MINIGAME-VARIATION` | APPROVED_DESIGN_SECTION_3 | 분기별 서로 다른 초간단 미니게임 | Decision·Design |
| `D-2026-08-02-MAIN-CONTENT-INVESTIGATION-RECOVERY-AUTHORITY` | CURRENT_APPROVED_PRODUCT_AUTHORITY | 메인 콘텐츠=괴이 사건 조사·회수 | Decision·Design·Sheet |

## 7. Package 2 구현 계약과 결과

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
- active·suspended·completed 행동 분리
- corrupt·incompatible·recoverable·interrupted 자동 변경 금지
- flow-stage allowlist·unknown/not-available fail-closed
- whitelist-only runtime initializer
- single-flight mutation lock
- route·저장 실패 시 runtime rollback·Session abandon
- Legacy file bytes·hidden memory equality 검증
- completed viewer는 GameState load 없는 read-only summary

## 8. GitHub·검증 상태

```yaml
pr_125: MERGED
pr_126: MERGED
pr_127: MERGED
pr_129: MERGED
pr_131: MERGED
pr_135: DRAFT_DESIGN_IN_PROGRESS
package_2_planning_merge: b4d7bd0fb82968325bcf230f3e81b8d96e142402
package_2_implementation_merge: f8751e7fa7890f402c7377ea6aee64f79ef59911
final_documentation_run_30742092953: PASS
final_bca_run_30742092954: PASS
final_core_run_30742092974: PASS
final_annual_run_30742092951: PASS
package_1_focused: 4_OF_4_PASS
package_2_focused: 5_OF_5_PASS
full_godot_regression: 58_OF_58_PASS
year_one_design_automated_validation: NOT_RUN_CURRENT_HEAD
year_one_human_validation: NOT_RUN
```

## 9. Grill Me 운영

- 현재 카운터: `6 / 10`
- 카운트 Decision:
  1. `D-2026-08-02-PACKAGE-2-MAIN-MENU-MODE-HIERARCHY`
  2. `D-2026-08-02-YEAR-ONE-CAMPAIGN-MASTER-STRUCTURE-FIRST`
  3. `D-2026-08-02-YEAR-ONE-CAMPAIGN-PURPOSE-AND-QUARTERLY-CASE`
  4. `D-2026-08-02-YEAR-ONE-QUARTERLY-CASE-ROLE-AND-FEEDBACK`
  5. `D-2026-08-02-YEAR-ONE-QUARTERLY-SIMPLE-MINIGAME-VARIATION`
  6. `D-2026-08-02-MAIN-CONTENT-INVESTIGATION-RECOVERY-AUTHORITY`
- Design·Spec·계획·구현·병합처럼 동일 질문의 후속 Gate는 새 질문이 아니면 추가 카운트하지 않는다.
- 10개 도달 시 GitHub·Sheet·PR·CI를 다시 적대적으로 검토한 뒤 batch merge gate를 실행한다.

## 10. 미검증 경계

```yaml
local_runtime: NOT_RUN
human_qa: NOT_RUN
new_player_validation: NOT_RUN
screen_01_visual_1280x720: NOT_RUN
year_one_minigame_first_30_seconds: NOT_RUN
year_one_minigame_accessibility: NOT_RUN
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
```

## 11. 다음 Gate

```text
Design Section 1·2·3 승인
→ 메인 콘텐츠 조사·회수 권위 재확인
→ Design Section 4: 봄 저승역 채택 여부와 여름·가을·겨울 핵심 괴담 컨셉 방향
→ 전체 Design 승인 후 Design Spec 작성 여부 결정
```
