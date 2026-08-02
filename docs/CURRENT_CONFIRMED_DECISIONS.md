# 괴이기록국 현재 확정 결정

> 문서 역할: `CURRENT_CONFIRMED_DECISIONS`
> 상태: `PACKAGE_2_MERGED_ON_MAIN / YEAR_ONE_DESIGN_APPROVED_PENDING_BATCH_AUDIT`
> 갱신일: 2026-08-02
> Base: `9.4.3`
> Package 1 구현 merge: `80160218d05e79af5442bf27d8fdeb66bcf05723`
> 병합 운영 정본 merge: `e15b9d25127170a530f66d5c3462340b806ad51d`
> Package 2 planning merge: `b4d7bd0fb82968325bcf230f3e81b8d96e142402`
> Package 2 implementation merge: `f8751e7fa7890f402c7377ea6aee64f79ef59911`
> 1년차 캠페인 Draft PR: #135
> main→planning sync PR: #138 / merge `cc25991ba6b74b3c3f552c84e90d40987595fa82`
> 1년차 Design: `docs/planning/2026-08-02-year-one-campaign-master-structure-design.md`
> 상세 Validation Target: `docs/VALIDATION_TARGET_CANON.md`
> 현재 인수인계: `docs/CURRENT_HANDOFF_VALIDATION.md`
> Grill Me ledger: `docs/GRILLME_APPROVAL_MERGE_LEDGER.md`

이 문서는 현재 유효한 사용자 승인 결정과 대체 관계를 소유한다. 실제 최신 main과 planning HEAD는 GitHub ref에서 읽고, 문서 안의 SHA와 run ID는 역할이 고정된 병합·검증 증거로 사용한다. 실행하지 않은 사람·시각 검증은 승인으로 간주하지 않는다.

## 1. 권위 순서

```text
최신 사용자 승인
→ GitHub 최신 main ref
→ AGENTS.md 보호 규칙
→ skills/PROJECT_BASE_ADAPTER.json
→ docs/PROJECT_CORE.md
→ 이 문서
→ docs/VALIDATION_TARGET_CANON.md
→ 분야별 책임 원본과 승인 Decision
→ 실제 main 코드·데이터·Scene·테스트
→ 자동·사람 검증 증거
→ Google Sheet 동일 Decision ID
→ 과거 PR·대화·추정
```

source-only·superseded PR은 현재 권위가 아니다. Package 2 planning과 implementation은 main에 병합됐다. 1년차 캠페인 Design은 Draft PR #135에서 승인됐지만 구현·Production 확대·main 병합 권한을 의미하지 않는다.

## 2. 현재 상태

```yaml
base_version: 9.4.3
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
year_one_planning_priority: APPROVED
year_one_design_section_1: APPROVED
year_one_design_section_2: APPROVED
year_one_design_section_3: APPROVED_DISTINCT_VICTIM_RESCUE_MINIGAMES
year_one_design_section_4: APPROVED_FOUR_CORE_CASES_PLACED
year_one_design_section_5: APPROVED_CASE_PLAY_DIFFERENTIATION
year_one_design_section_6: APPROVED_RESULT_FEEDBACK_AND_ANNUAL_REVIEW
main_content_authority: INVESTIGATION_RESCUE_RECOVERY_BATTLE
schedule_role: SUPPORT_PREPARATION_FEEDBACK_LAYER
core_gameplay_screen_presentation: APPROVED_PROVISIONAL_UX_BASELINE
year_one_core_case_spring: AFTERLIFE_STATION
year_one_core_case_summer: RED_UMBRELLA_ALLEY
year_one_core_case_autumn: DEAD_FREQUENCY_STATION
year_one_core_case_winter: UNRECORDED_WARD
year_one_threat_grammar_spring: ORDER_AND_MOVEMENT_TIMING
year_one_threat_grammar_summer: TARGET_ROLE_TRANSFER
year_one_threat_grammar_autumn: RESPONSE_AND_CHANNEL_STATE
year_one_threat_grammar_winter: RECORD_AUTHORITY_AND_EXISTENCE_REPLACEMENT
year_one_feedback_axes: KNOWLEDGE_RELATION_INSTITUTION_FIELD
year_one_annual_review: COMPOSITE_AGENT_RECORD_NO_SINGLE_RANK
grillme_batch_1_counter: 10_OF_10
grillme_batch_1_audit: IN_PROGRESS
pr_135: DRAFT_UNMERGED
human_qa: NOT_RUN
new_player_validation: NOT_RUN
screen_01_visual_1280x720: NOT_RUN
core_gameplay_screen_human_validation: NOT_RUN
year_one_minigame_human_validation: NOT_RUN
four_case_content_validation: NOT_RUN
case_play_differentiation_validation: NOT_RUN
result_feedback_validation: NOT_RUN
annual_review_comprehension: NOT_RUN
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
```

## 3. 현재 제품 코어 권위

괴이기록국의 메인 콘텐츠는 괴이 사건에 진입해 조사·피해자 구출·회수 전투를 수행하는 경험이다.

```text
괴이 사건 진입
→ 텍스트 노벨 조사
→ 상황 설명과 조건 표시 선택지
→ 키워드 획득
→ 괴이 매뉴얼 후보 규칙 구성
→ 피해자 구출 미니게임
→ 턴제 회수 전투
→ 안정화·봉쇄·잔향 회수
→ 공식 규칙·위험 사례·결과 환류
```

- 조사: 상황 설명·조건 선택지·키워드·괴이 매뉴얼 문장 구성
- 피해자 구출: 조사 규칙을 적용해 피해자를 괴이 현상에서 분리
- 회수 전투: 보호·관찰·대응·공격·장비·봉쇄·후퇴
- 일정·육성·동료·장비·연구·기관: 준비·지원·환류 계층
- 능력·태그·판정: 객관적 진실을 바꾸지 않고 비용·위험·우회 경로를 조정
- 공격: 필요한 전술 행동이지만 공격 반복만으로 기본 승리 불가

책임 Decision:

- `D-2026-08-02-MAIN-CONTENT-INVESTIGATION-RECOVERY-AUTHORITY`
- `D-2026-08-02-CORE-GAMEPLAY-SCREEN-PRESENTATION-BASELINE`

## 4. 1년차 캠페인 승인 구조

### 캠페인 목적과 성장 축

> 권나래가 한 해 동안 무엇을 이해하고, 누구의 책임을 선택하며, 어떤 방식으로 괴이를 기록하는 요원이 되었는가?

```text
봄 — 배우고 소속된다
→ 여름 — 전문화하고 약속한다
→ 가을 — 가치 충돌의 대가를 치른다
→ 겨울 — 축적한 판단으로 책임을 완수한다
```

### 구조

- 분기마다 핵심 괴담 1개, 1년 총 4개
- 각 사건은 독립된 규칙과 안정화·현재 사건 종결을 가짐
- 독립 사건 4개 + 강한 결과 환류 + 약한 공통 미스터리
- 다음 분기는 이전 결과 최소 2축 사용, 겨울은 3축 모두 사용
- 실패는 위험 사례·후유증·기관 압박·관계 변화·재출현 조건으로 전진
- 동일 흑막·동일 괴이 분신·겨울 성공으로 과거 피해 삭제 금지

### 분기 배치와 플레이 문법

| 분기 | 핵심 괴담 | 역할 | 대표 위협 문법 | 피해자 구출 문법 |
|---|---|---|---|---|
| 봄 | 저승역 | 기준 사건 | 순서와 이동 시점 | 공식 기준 기반 순서·경로 복원 |
| 여름 | 비 오는 골목의 빨간 우산 | 선택 사건 | 대상과 역할의 전이 | 반사 차단·우산 격리·호위 역할 배치 |
| 가을 | 폐주파수 방송국 | 충돌 사건 | 응답과 송수신 구간 | 보호 범위·무음 구간·반환 대상 조절 |
| 겨울 | 기록되지 않은 병동 | 종합 사건 | 기록 권위와 존재 대체 | 기록 비교·모순 보존·복구 순서 |

### 공통 조사·구출·전투 계약

- 조사: `상황 설명 → 조건 표시 선택지 → 결과 문장 → 키워드`
- 괴이 매뉴얼: 발생 조건·피해 연결·금지 행동·구출 절차·전투 대응
- 키워드 상태: 후보·확인·위험 사례·미해결
- 구출 미니게임: 설명 30초·입력 1~2종·기본 1~3분 목표, 사람 검증 전 달성 선언 금지
- 전투 승리: 피해자 보호 + 규칙 관찰 + 고유 대응 + 현현체 약화 + 봉쇄 조건

### 결과 환류와 연도 결산

각 사건은 `정밀 안정화·안정화·불완전 안정화·기관 강제 봉쇄` 중 하나의 종결 상태와 결과 패킷을 남긴다.

결과 축:

1. 지식 — 공식 규칙·위험 사례·미해결 질문·연구·재출현 대응
2. 관계·기관 — 동료·피해자·기관·외부 세력·책임 주체
3. 현장 — 피해자 상태·잔향·놓친 피해 경로·재출현·오염

모든 세부 결과는 보존하되 다음 분기에 직접 작동하는 주 결과는 축마다 최대 1개로 제한한다. 과거 성공은 현재 괴담 정답을 공개하지 않고, 과거 실패는 필수 진행을 잠그지 않는다.

연말은 단일 점수나 S~D 등급이 아니라 다음 복합 기록으로 표현한다.

```text
조사 성향
+ 피해자 보호 원칙
+ 기관 내 위치
+ 남은 책임
```

2년차 초반 직접 활성화는 지식 1개·관계/기관 1개·현장 1개·요원 성향 기록으로 제한하되 나머지 사건 기록과 책임은 삭제하지 않는다.

책임 Decision:

- `D-2026-08-02-YEAR-ONE-CAMPAIGN-MASTER-STRUCTURE-FIRST`
- `D-2026-08-02-YEAR-ONE-CAMPAIGN-PURPOSE-AND-QUARTERLY-CASE`
- `D-2026-08-02-YEAR-ONE-QUARTERLY-CASE-ROLE-AND-FEEDBACK`
- `D-2026-08-02-YEAR-ONE-QUARTERLY-SIMPLE-MINIGAME-VARIATION`
- `D-2026-08-02-YEAR-ONE-FOUR-CORE-CASES-AND-QUARTER-PLACEMENT`
- `D-2026-08-02-YEAR-ONE-CASE-PLAY-DIFFERENTIATION-CONTRACT`
- `D-2026-08-02-YEAR-ONE-RESULT-FEEDBACK-AND-ANNUAL-REVIEW-CONTRACT`

## 5. 핵심 게임 화면 표현 기준선

상태: `APPROVED_PROVISIONAL_UX_BASELINE`

### 조사 화면

- 정보 위계: 상황 설명 → 조건이 표시된 선택지
- 플레이어 노출 명칭: `괴이 매뉴얼`
- 후보 규칙·확인된 규칙·위험 사례·미해결 항목 구분

### 피해자 구출 화면

- 구출 대상·조건·금지 행동·안전 행동 표시
- 성공·부분 실패·지연을 회수 전투 시작 조건으로 전달

### 회수 전투 화면

- 메인 상단·중앙에는 괴이만 상시 표시
- 아군은 하단 초상·상태·스킬 HUD
- 전신은 스킬 사용 시 짧은 하단 컷인으로만 등장
- 패널·크기·컷인 시간·단축키·애니메이션은 후속 UX와 사람 검증에서 수정 가능

## 6. 승인 Validation 흐름

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

Package 2는 SCREEN-01에서 SIT-001·SIT-002·SIT-004의 현재 구현 Scene만 allowlist로 연다. SIT-003·SIT-005~008은 전용 Scene 구현 전 `NOT_AVAILABLE`로 fail-closed한다. 이번 1년차 Design은 기존 Validation 구현을 자동 변경하지 않는다.

## 7. 현재 Decision 목록

| Decision ID | 현재 상태 | 핵심 | 책임 원본 |
|---|---|---|---|
| `D-2026-07-31-CANON-SHEET-SYNC` | CURRENT_APPROVED_GOVERNANCE | 주요 승인을 GitHub·Sheet에 같은 ID로 동기화 | 이 문서·Sheet |
| `D-2026-07-31-TEXT-NOVEL-CORE-PRESENTATION` | APPROVED_PLANNING_BASELINE | 일반 조사·플레이는 텍스트 노벨 화면 | `VALIDATION_TARGET_CANON.md` |
| `D-2026-07-31-VISUAL-ART-DIRECTION` | APPROVED_PLANNING_BASELINE | 다크 현대 오컬트·세미리얼 애니·기관 UI | `VALIDATION_TARGET_CANON.md` |
| `D-2026-07-31-VALIDATION-SCREEN-AUTHORITY` | SUPERSEDED_IN_PART | 화면 책임 분리 | `VALIDATION_TARGET_CANON.md` |
| `D-2026-07-31-EXTENDED-MANAGEMENT-SCREENS` | APPROVED_LONG_TERM_TARGET | 일정·연구·보급 지원 화면 유지 | `VALIDATION_TARGET_CANON.md` |
| `D-2026-07-31-MAIN-DAILY-SCHEDULE-PRESENTATION` | APPROVED_SUPPORT_LAYER_TARGET | 하루 주요 활동 1개·자동 기본 휴식 | `VALIDATION_TARGET_CANON.md` |
| `D-2026-07-31-AFTERLIFE-TIMELINE-EVIDENCE` | APPROVED_PLANNING_BASELINE | 저승역 시간순 증거 | `VALIDATION_TARGET_CANON.md` |
| `D-2026-07-31-AFTERLIFE-RECOVERY-PATTERNS` | APPROVED_PLANNING_BASELINE | 저승역 회수 2패턴 | `VALIDATION_TARGET_CANON.md` |
| `D-2026-08-01-SCHEDULE-REST-SEMANTICS` | APPROVED_SUPPORT_LAYER_NOT_IMPLEMENTED | 기본 휴식 의미 | `VALIDATION_TARGET_CANON.md` |
| `D-2026-08-01-PROVISIONING-AUTHORITY` | APPROVED_SUPPORT_LAYER_NOT_IMPLEMENTED | 기록국 보급실 | `VALIDATION_TARGET_CANON.md` |
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
| `D-2026-08-02-YEAR-ONE-CAMPAIGN-MASTER-STRUCTURE-FIRST` | APPROVED_PLANNING_PRIORITY | 개별 콘텐츠보다 4분기 마스터 구조 우선 | Decision·PR #135 |
| `D-2026-08-02-YEAR-ONE-CAMPAIGN-PURPOSE-AND-QUARTERLY-CASE` | APPROVED_DESIGN_SECTION_1 | 성장 축·분기당 핵심 괴담 1개 | Decision·Design |
| `D-2026-08-02-YEAR-ONE-QUARTERLY-CASE-ROLE-AND-FEEDBACK` | APPROVED_DESIGN_SECTION_2 | 독립 4사건·3축 환류·실패 전진 | Decision·Design |
| `D-2026-08-02-YEAR-ONE-QUARTERLY-SIMPLE-MINIGAME-VARIATION` | APPROVED_DESIGN_SECTION_3 | 분기별 초간단 피해자 구출 미니게임 | Decision·Design |
| `D-2026-08-02-MAIN-CONTENT-INVESTIGATION-RECOVERY-AUTHORITY` | CURRENT_APPROVED_PRODUCT_AUTHORITY | 메인 콘텐츠=조사·피해자 구출·회수 전투 | Decision·Design·Sheet |
| `D-2026-08-02-CORE-GAMEPLAY-SCREEN-PRESENTATION-BASELINE` | APPROVED_PROVISIONAL_UX_BASELINE | 상황 설명→선택지·괴이 매뉴얼·괴이 중심 전투·스킬 컷인 | Decision·Design·Sheet |
| `D-2026-08-02-YEAR-ONE-FOUR-CORE-CASES-AND-QUARTER-PLACEMENT` | APPROVED_DESIGN_SECTION_4 | 봄 저승역·여름 빨간 우산·가을 폐주파수·겨울 기록되지 않은 병동 | Decision·Design·Sheet |
| `D-2026-08-02-YEAR-ONE-CASE-PLAY-DIFFERENTIATION-CONTRACT` | APPROVED_DESIGN_SECTION_5 | 순서·전이·응답·기록 권위 위협 문법과 공통 전투 승리 계약 | Decision·Design·Sheet |
| `D-2026-08-02-YEAR-ONE-RESULT-FEEDBACK-AND-ANNUAL-REVIEW-CONTRACT` | APPROVED_DESIGN_SECTION_6 | 3축 결과 패킷·기관 강제 봉쇄·복합 연도 기록·2년차 계승 | Decision·Design·Sheet |

## 8. Package 2 구현 계약과 결과

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

## 9. GitHub·검증 상태

```yaml
pr_125: MERGED
pr_126: MERGED
pr_127: MERGED
pr_129: MERGED
pr_131: MERGED
pr_132: MERGED_MAIN_TO_PLANNING_SYNC
pr_133: MERGED_MAIN_TO_IMPLEMENTATION_SYNC
pr_138: MERGED_MAIN_TO_YEAR_ONE_PLANNING_SYNC
pr_122: CLOSED_SOURCE_DO_NOT_MERGE_AS_IS
issue_121: CLOSED_COMPLETED
pr_135: DRAFT_BATCH_AUDIT_IN_PROGRESS
package_2_planning_merge: b4d7bd0fb82968325bcf230f3e81b8d96e142402
package_2_implementation_merge: f8751e7fa7890f402c7377ea6aee64f79ef59911
main_to_year_one_planning_sync_merge: cc25991ba6b74b3c3f552c84e90d40987595fa82
final_documentation_run_30742092953: PASS
final_bca_run_30742092954: PASS
final_core_run_30742092974: PASS
final_annual_run_30742092951: PASS
package_1_focused: 4_OF_4_PASS
package_2_focused: 5_OF_5_PASS
full_godot_regression: 58_OF_58_PASS
year_one_latest_head_workflows: RERUN_REQUIRED_AFTER_FINAL_DOC_FIXES
year_one_human_validation: NOT_RUN
merge_authorization: NOT_GRANTED
```

## 10. Grill Me 운영

- 현재 Batch 1 카운터: `10 / 10`
- 카운트 Decision:
  1. `D-2026-08-02-PACKAGE-2-MAIN-MENU-MODE-HIERARCHY`
  2. `D-2026-08-02-YEAR-ONE-CAMPAIGN-MASTER-STRUCTURE-FIRST`
  3. `D-2026-08-02-YEAR-ONE-CAMPAIGN-PURPOSE-AND-QUARTERLY-CASE`
  4. `D-2026-08-02-YEAR-ONE-QUARTERLY-CASE-ROLE-AND-FEEDBACK`
  5. `D-2026-08-02-YEAR-ONE-QUARTERLY-SIMPLE-MINIGAME-VARIATION`
  6. `D-2026-08-02-MAIN-CONTENT-INVESTIGATION-RECOVERY-AUTHORITY`
  7. `D-2026-08-02-CORE-GAMEPLAY-SCREEN-PRESENTATION-BASELINE`
  8. `D-2026-08-02-YEAR-ONE-FOUR-CORE-CASES-AND-QUARTER-PLACEMENT`
  9. `D-2026-08-02-YEAR-ONE-CASE-PLAY-DIFFERENTIATION-CONTRACT`
  10. `D-2026-08-02-YEAR-ONE-RESULT-FEEDBACK-AND-ANNUAL-REVIEW-CONTRACT`
- 동일 질문의 Design·Spec·구현·병합 후속 Gate는 새 질문이 아니면 추가 카운트하지 않는다.
- 10개 도달로 적대적 batch audit가 실행 중이다.
- audit 통과만으로 병합하지 않으며 별도 사용자 병합 승인이 필요하다.

## 11. 미검증 경계

```yaml
local_runtime: NOT_RUN
human_qa: NOT_RUN
new_player_validation: NOT_RUN
screen_01_visual_1280x720: NOT_RUN
screen_01_mouse_manual: NOT_RUN
screen_01_keyboard_manual: NOT_RUN
core_gameplay_screen_human_validation: NOT_RUN
investigation_choice_readability: NOT_RUN
manual_state_comprehension: NOT_RUN
battle_enemy_focus_readability: NOT_RUN
skill_cut_in_interruption: NOT_RUN
year_one_minigame_first_30_seconds: NOT_RUN
year_one_minigame_accessibility: NOT_RUN
four_case_content_validation: NOT_RUN
case_play_differentiation_validation: NOT_RUN
result_feedback_playability: NOT_RUN
annual_review_comprehension: NOT_RUN
unrecorded_ward_playability: NOT_RUN
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
```

## 12. 다음 Gate

```text
Grill Me Batch 1 10/10
→ final GitHub·Sheet·PR·CI 적대적 감사
→ READY_FOR_SEPARATE_MERGE_APPROVAL / CHANGES_REQUIRED / BLOCKED 판정
→ 사용자 별도 병합 승인
→ PR #135 main 병합
→ post-merge GitHub·Sheet sync
→ 다음 Batch 카운터 0/10 시작
```

전체 Design 승인 뒤에도 Design Spec·개별 사건 Spec·구현 계획·코드는 별도 승인 Gate를 요구한다.