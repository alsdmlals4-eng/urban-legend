# 괴이기록국 기획 진행 상태 — 2026-07-31

> 상태: `PLANNING_IN_PROGRESS`
> 추적: Issue #121 / Draft PR #122
> 구현 권한: `NONE`
> 정본·Sheet 동기화: `D-2026-07-31-CANON-SHEET-SYNC`

## 승인됨

- Validation Cut 35~50분 우선 검증
- Validation 통과 뒤 Showcase Cut 70~90분 별도 승인
- 신규 시스템·핵심 규칙·콘텐츠 구조·UX 흐름의 Benchmark-first 원칙
- 기존 근거 재사용 우선, 기본 3~5개 목적형 비교
- 주요 변경·승인 결정은 동일 Decision ID로 GitHub 책임 원본과 연결 Google Sheet에 즉시 동기화
- `D-2026-07-31-AFTERLIFE-TIMELINE-EVIDENCE` 시간순 증거 기준선
- `D-2026-07-31-TEXT-NOVEL-CORE-PRESENTATION` 조사·일반 플레이 텍스트 노벨 화면 권위
- `D-2026-07-31-VISUAL-ART-DIRECTION` 다크 현대 오컬트·세미리얼 애니 비주얼 기준
- `D-2026-07-31-VALIDATION-SCREEN-AUTHORITY` Validation 시작·준비·추리·회수·결과 화면 책임
- `D-2026-07-31-EXTENDED-MANAGEMENT-SCREENS` 일정·연구·상점/보급 조달 화면 추가
- `D-2026-07-31-MAIN-DAILY-SCHEDULE-PRESENTATION` 메인 무인 화면·하루 단위 일정 입력·다일 활동 연속 날짜 자동 점유
- Codex는 기획·검수 최종 완료 뒤 마지막 단계

## 작성·검수 완료

- 프로젝트 기획 정본 감사
- 통합 Vertical Slice 경험 v3
- 전체 기획 적대적 검토
- Benchmark-first 프로젝트 정책
- 저승역 가설 보드 목적형 Benchmark
- 저승역 가설 보드 v2와 적대적 검토
- 저승역 시간순 증거 대사·획득 위치 승인
- 기획 중간점검과 화면 권위 충돌 감사
- 조사·일반 플레이 텍스트 노벨 표현 승인
- 프로젝트 비주얼 아트 방향 승인
- Validation 화면 권위 A~D 패키지 승인
- 일정·연구·상점/보급 조달을 기준 화면 세트에 추가
- 메인 화면 캐릭터 비노출과 하루 단위 일정 편성 승인
- 2~3일 활동의 연속 날짜 자동 점유 승인
- 결과·해결 등급·연구 환류 초안
- 플레이테스트 계획 초안

## 승인된 Validation 화면 권위

### D-2026-07-31-VALIDATION-SCREEN-AUTHORITY

```text
메인
→ 저승역 콜드 오픈
→ 기록국 브리핑
→ 축약 준비
→ 텍스트 노벨 조사
→ 가설 보드
→ 시간순 증거 비교
→ 안전 노선 복원
→ 회수 패턴 대응
→ 결과·보고서
→ preparation_scene 사후 정산
```

- `preparation_scene`을 Validation 제품 준비 화면으로 유지한다.
- Validation에서는 요원·장비/지원·조사 우선순위만 다루는 축약 준비 모드를 사용한다.
- 가설 보드는 사건 전체 원인, 회수 화면은 현재 패턴·관련 기록·중립 행동을 담당한다.
- 결과 이후 보고서·괴이 매뉴얼을 갱신하고 사후 정산 모드로 복귀한다.
- ANNUAL-MVP-002 전체 제품 통합은 Showcase Cut에서 별도 승인한다.
- 상태: `APPROVED_PLANNING_BASELINE`
- Benchmark Gate: `REUSED`
- 구현 권한: `NONE`
- 사람 검증: `NOT_RUN`

책임 원본:

- `docs/decisions/D-2026-07-31-VALIDATION-SCREEN-AUTHORITY.md`

## 승인된 확장 관리 화면

### D-2026-07-31-EXTENDED-MANAGEMENT-SCREENS

기준 화면 세트를 다음 7종으로 확장한다.

1. SCREEN-01 메인
2. SCREEN-02 텍스트 노벨 조사·핵심 플레이
3. SCREEN-03 준비·자원 관리
4. SCREEN-04 결과·보고서·사후 정산
5. SCREEN-05 일정·운영
6. SCREEN-06 연구
7. SCREEN-07 상점·보급 조달

핵심 경계:

- SCREEN-05는 4주×7일 운영과 사건 징후·출동 시점 판단을 담당한다.
- SCREEN-06은 사건 기록·잔향 자료가 질문·장비·모듈·지원으로 환류되는 과정을 담당한다.
- SCREEN-07은 일반 소매 상점이 아니라 기록국 내부 조달·보급 화면이다.
- 개인 돈·생활비·무한 구매/판매·내구도 경제는 별도 승인 전 제외한다.
- 상점/보급 화면의 정확한 명칭과 정보 구조는 목적형 Benchmark 뒤 확정한다.
- 상태: `APPROVED_PLANNING_BASELINE`
- 구현 권한: `NONE`
- 사람 검증: `NOT_RUN`

책임 원본:

- `docs/decisions/D-2026-07-31-EXTENDED-MANAGEMENT-SCREENS.md`

## 승인된 화면 표현 보정

### D-2026-07-31-MAIN-DAILY-SCHEDULE-PRESENTATION

#### SCREEN-01

- 메인 화면에는 주인공·동료·캐릭터 실루엣을 포함한 인물을 표시하지 않는다.
- 빈 기록국 공간·도시 야경·역사·관제 장비·간접 괴이 흔적으로 장르와 긴장을 전달한다.

#### SCREEN-05

```text
날짜 선택
→ 해당 날짜 활동 선택
→ 비용·피로·예상 변화 확인
→ 하루 일정 확정
→ 다음 날짜
```

- 일정 입력과 확인의 기본 단위는 `1일`이다.
- 4주×7일 달력은 전체 기간과 마감을 보여주는 개요다.
- 주간 활동 묶음 선택을 기본값으로 두지 않는다.
- 2~3일 활동은 시작 날짜에서 선택하면 필요한 연속 날짜를 자동 점유한다.
- 자동 점유 범위·완료 예정일·충돌을 확정 전에 미리 보여준다.
- 다일 활동은 주차 경계를 넘지 않으며, 이동·취소·복사는 전체 일정 블록 단위로 처리한다.
- 직전 7종 비주얼 보드는 메인 캐릭터 노출과 주간 묶음 일정 표현 때문에 `SUPERSEDED_PLACEHOLDER`다.
- 상태: `APPROVED_PLANNING_BASELINE`
- 구현 권한: `NONE`

책임 원본:

- `docs/decisions/D-2026-07-31-MAIN-DAILY-SCHEDULE-PRESENTATION.md`

## 승인된 시간순 증거

### D-2026-07-31-AFTERLIFE-TIMELINE-EVIDENCE

```text
23:57:42 피해자의 개인 목적지 청취 기록
<
23:59:08 검은 승차권 최초 접촉 기록
```

- 공백 투사설: `SUPPORTED`
- 승차권 최초 원인 주장: `CONTRADICTED`
- 승차권의 인식 고정·물리화 매개 역할: `UNRESOLVED`
- 상태: `APPROVED_PLANNING_BASELINE`
- 구현 권한: `NONE`
- 사람 검증: `NOT_RUN`

## 현재 검수 대상

### 기준 화면 7종 목적형 Benchmark

대상:

1. SCREEN-01 메인 화면
2. SCREEN-02 텍스트 노벨 조사·핵심 플레이 화면
3. SCREEN-03 축약 준비·자원 관리 화면
4. SCREEN-04 결과·보고서·사후 정산 화면
5. SCREEN-05 일정·운영 화면
6. SCREEN-06 연구 화면
7. SCREEN-07 상점·보급 조달 화면

목적:

- 현재 구현·승인 기획·신규 제안을 분리한다.
- 각 화면의 정보 위계·상태 변형·전환·가독성을 검증한다.
- 같은 대규모 조사를 반복하지 않고 기존 장르·가설 보드·ANNUAL Benchmark를 재사용한다.
- SCREEN-01은 무인 환경 중심 메인 화면으로 비교한다.
- SCREEN-05는 하루 단위 입력과 다일 활동 연속 날짜 자동 점유를 전제로 비교한다.
- 일정과 연구는 기존 근거를 `REUSED`하고, 상점·보급 조달은 정확한 UX를 위한 목적형 비교를 추가한다.
- 최종 비주얼 보드는 핵심 플레이 4종과 운영·성장 3종을 두 장으로 분리해 판독성을 유지한다.

### D-2026-07-31-AFTERLIFE-RECOVERY-PATTERNS

상태: `DRAFT_REQUIRES_USER_REVIEW / HOLD_UNTIL_SCREEN_SPEC`

화면 권위는 승인됐으나, 행동 문구의 정답 편향과 실제 화면 상태를 SCREEN/SIT 명세에서 확인한 뒤 최종 승인한다.

## 남은 P0 기획

1. 하루 한 활동 또는 오전·오후 분할 규칙 확정
2. 미래 일정 수정 가능 시점 확정
3. 돌발 출동과 다일 활동 충돌 처리 확정
4. SCREEN-01 무인 메인 화면과 SCREEN-05 하루 일정 화면 상세 명세
5. 기준 화면 7종 목적형 Benchmark
6. SCREEN-01~07 CURRENT / INFERRED / PROPOSED 명세와 상태 변형
7. 핵심 플레이 보드 A와 운영·성장 보드 B의 비주얼 콘셉트 재작성
8. Validation SIT-001~008 화면 시퀀스와 전체 전환도
9. 회수 패턴 분류 후보·중립 행동 최종 검수
10. 원인 미검증 상태의 해결 등급 상한 검수
11. 결과→연구·장비·조달·다음 준비 환류 세부값 검수
12. 플레이테스트 패키지 적대적 검토
13. 사용자 최종 승인
14. 승인 결정의 GitHub 정본·Sheet 상태 승격

## 보류

- Codex Goal
- GDScript·Scene·JSON·에셋 변경
- Base v9.3 이관 구현
- ANNUAL-MVP-003/004
- Showcase Cut 구현
- ANNUAL-MVP-002 전체 제품 통합
- 개인 화폐·반복 구매 판매·장비 내구도 경제
- 사람 검증 전 제작 확대

Google Sheet 쓰기는 승인·주요 변경 동기화 목적으로만 허용하며, 제품 데이터 구현을 의미하지 않는다.

## 현재 Gate

```yaml
canon_sheet_sync_policy: APPROVED_AND_BRANCH_SYNCED
benchmark_first_policy: APPROVED
validation_cut_direction: APPROVED
text_novel_core_presentation: APPROVED_PLANNING_BASELINE
visual_art_direction: APPROVED_PLANNING_BASELINE
validation_screen_authority: APPROVED_PLANNING_BASELINE
extended_management_screens: APPROVED_PLANNING_BASELINE
main_no_character: APPROVED_PLANNING_BASELINE
daily_schedule_input: APPROVED_PLANNING_BASELINE
multi_day_consecutive_reservation: APPROVED_PLANNING_BASELINE
schedule_day_partition: USER_DECISION_REQUIRED
schedule_future_edit_window: NOT_DECIDED
schedule_interruption_rule: NOT_DECIDED
screen_benchmark: NEXT_GATE_FOR_SCREEN_01_TO_07
screen_05_schedule_benchmark: REUSED_WITH_DETAIL_REVIEW
screen_06_research_benchmark: REUSED_WITH_TARGETED_LAYOUT_REVIEW
screen_07_procurement_benchmark: TARGETED_REQUIRED
screen_situation_canon: NOT_STARTED
hypothesis_benchmark: PASSED
hypothesis_design_v2: DRAFT_REQUIRES_USER_REVIEW
timeline_evidence: APPROVED_PLANNING_BASELINE
recovery_patterns: HOLD_UNTIL_SCREEN_SPEC
result_and_reward: DRAFT_REQUIRES_REVIEW
playtest_plan: DRAFT_REQUIRES_REVIEW
showcase_cut: HOLD_UNTIL_VALIDATION
codex: HOLD
human_validation: NOT_RUN
production_expansion: NOT_APPROVED
```
