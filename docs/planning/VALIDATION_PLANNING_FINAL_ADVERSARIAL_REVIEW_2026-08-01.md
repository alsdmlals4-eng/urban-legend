# 괴이기록국 Validation 기획 최종 적대적 검토 — 2026-08-01

> Review ID: `R-2026-08-01-VALIDATION-PLANNING-FINAL-ADVERSARIAL`
> 상태: `PASS_FOR_PLANNING_FINAL_APPROVAL / NOT_BUILD_READY`
> 기준 main: `656846865eb88871d00842a0da527ce1b0722b77`
> 계획 branch: `plan/urban-legend-planning-audit`
> 추적: Issue #121 / Draft PR #122
> 제품 구현 권한: `NONE`
> Runtime / Human QA: `NOT_RUN`
> Codex: `HOLD`

## 1. 검토 입력

### 승인 Decision

- `D-2026-07-31-TEXT-NOVEL-CORE-PRESENTATION`
- `D-2026-07-31-VISUAL-ART-DIRECTION`
- `D-2026-07-31-VALIDATION-SCREEN-AUTHORITY`
- `D-2026-08-01-SCHEDULE-REST-SEMANTICS`
- `D-2026-08-01-PROVISIONING-AUTHORITY`
- `D-2026-08-01-VALIDATION-SCOPE-FILTER`
- `D-2026-08-01-VALIDATION-SCREEN-SIT-PACKAGE`
- `D-2026-07-31-AFTERLIFE-RECOVERY-PATTERNS`
- `D-2026-08-01-VALIDATION-RESULT-AXES`
- `D-2026-08-01-VALIDATION-SAVE-TEST-MIGRATION`
- `D-2026-08-01-RECOMMENDED-BATCH-APPROVAL`

### 상세 설계·감사·검증

- `docs/superpowers/specs/2026-08-01-validation-screen-situation-design.md`
- `docs/planning/FULL_PROJECT_ADVERSARIAL_AUDIT_2026-08-01.md`
- `docs/planning/CANON_MIGRATION_BUNDLE_2026-08-01.md`
- `docs/planning/VALIDATION_SCREEN_SITUATION_ADVERSARIAL_REVIEW_2026-08-01.md`
- `docs/planning/BASE_PROJECT_SHEET_OPERATING_AUDIT_2026-08-01.md`
- `docs/planning/BASE_PROJECT_SHEET_OPERATING_VERIFY_2026-08-01.md`

### 시각·테스트

- `docs/visual/UL_IMG_007_VISUAL_REVIEW_2026-08-01.md`
- `docs/validation/VALIDATION_SCREEN_SIT_PLAYTEST_PACKAGE_2026-08-01.md`

## 2. 최종 공격 질문

### A. 화면 수가 다시 팽창했는가

공격:

- 가설·시간순·노선·회수를 별도 기준 화면으로 세면 실제 제품이 11개 이상으로 팽창한다.

판정:

- 기준 화면은 SCREEN-01~07로 고정했다.
- 네 절차는 SCREEN-02 아래의 전문 흐름이다.
- 구현상 Scene 분리는 허용하되 제품 화면 수와 책임은 분리한다.

결과: `PASS`

### B. 텍스트 노벨이 자유 이동·다중 HUD로 퇴행하는가

공격:

- 기존 조사 Scene의 팀 상태·수집률·매뉴얼·회수 버튼·조사 포인트가 다시 한 화면에 합쳐질 수 있다.

판정:

- 일반 화면은 배경·서술/대사·반신·2~4 선택지·결과 문장으로 고정했다.
- 상단 HUD는 사건명·장소·기록·설정만 사용한다.
- 팀 상태는 Popover다.
- 수집률·예측률·회수율·조기 회수 버튼은 제외한다.

결과: `PASS`

### C. 준비·연구·보급이 정답을 대신하는가

공격:

- 추천 편성·장비·연구·보급이 정답 가설이나 올바른 회수 행동을 암시할 수 있다.

판정:

허용:

- 피해 완화
- 기록 비교 편의
- 입력 허용 오차
- 재시도 조건
- 이미 확보한 기록의 정리

금지:

- 신규 핵심 단서
- 정답 가설
- 미관측 패턴
- 잘못된 규칙의 성공 처리
- 동료 정답 예측

결과: `PASS`

### D. 시간순 증거가 형식적 순서 맞히기로 축소되는가

공격:

- `23:57:42 < 23:59:08`만 맞추고 최초 원인과 현장 매개 역할을 이해하지 못할 수 있다.

판정:

- 원시 시간 순서와 해석을 분리했다.
- 승차권 최초 원인 주장은 반박하지만 현장 매개 역할은 미해결로 남긴다.
- 플레이테스트 T5가 원인/매개 설명을 별도로 측정한다.

결과: `PASS_WITH_HUMAN_GATE`

### E. 회수 행동이 안전해 보이는 버튼 찾기로 바뀌는가

공격:

- 스피커 전원 차단과 투명 격리 용기가 기록 없이도 정답처럼 보일 수 있다.

판정:

- 첫 Validation에 능력치·확률·동료 예측을 노출하지 않는다.
- 분류·기록·행동·현장 성공·추론 검증을 별도 저장한다.
- 플레이테스트 T7을 라벨 우선 3명 / 기록 우선 3명으로 분리했다.
- 라벨 우선 2/3 초과 정답 + 기록 이유 부재면 CHANGE다.

결과: `OPEN_P2_CAPTURED_BY_TEST`

### F. 결과가 다시 단일 총점이 되는가

공격:

- 요약 등급이 네 원시 축을 덮어써 우연한 행동 성공을 완전 해결로 만들 수 있다.

판정:

- 원시 4축이 권위다.
- 요약 등급은 재계산 가능한 표시값이다.
- 규칙 미검증·반박이면 임시 안정화 상한이다.
- 결과 첫 화면은 축 상태명과 한 문장 이유만 표시한다.
- 상세 보고서·해금은 접는다.

결과: `PASS`

### G. 실패 복구가 사실상 정답 공개인가

공격:

- 가설 재제출·노선 재시도·회수 복구가 정답을 자동 공개할 수 있다.

판정:

- 가설 오답은 반박 근거·미해결 관계만 보여준다.
- 노선 실패는 재시도 또는 미해결 철수다.
- 회수 첫 오대응 뒤 복구 1회, 두 번째 실패는 위험 사례 후 진행한다.
- 사건 전체 초기화와 소프트락을 금지한다.

결과: `PASS`

### H. 숨긴 기능이 백그라운드에서 영향을 주는가

공격:

- 화면에서 숨겼지만 랜덤·시장·의뢰·관계·패턴 3/4가 난수·로그·보상에 관여할 수 있다.

판정:

- 비노출 기능은 판정·난수·로그·자원·관계·위험·저장을 변경하지 않는다.
- 플레이테스트·자동 회귀에서 0건을 요구한다.

결과: `PASS_AS_CONTRACT / IMPLEMENTATION_TEST_REQUIRED`

### I. Legacy 저장이 새 Target에 의해 파괴되는가

공격:

- 새 flow_stage 도입이 `mvp-039`를 강제 변환하거나 Scene 경로 저장을 무효화할 수 있다.

판정:

- Legacy 저장은 병렬 보존한다.
- Validation은 flow_stage 우선, scene fallback을 유지한다.
- return target과 안정 ID를 저장한다.
- 로드 시 효과 중복을 금지한다.
- 플레이테스트 T10과 추후 자동 회귀를 정의했다.

결과: `PASS_AS_MIGRATION_CONTRACT / BUILD_TEST_REQUIRED`

### J. 일정 제품 목표가 ANNUAL PoC를 삭제하는가

공격:

- 하루 주요 활동 1개 Target이 기존 4주×7일 PoC와 반일 준비 증거를 폐기할 수 있다.

판정:

- 기존 구현은 `CURRENT_IMPLEMENTATION_LEGACY`로 보존한다.
- Target은 `APPROVED_TARGET_NOT_IMPLEMENTED`다.
- 다일 활동 완료 일수와 강제 출동 중단 규칙을 명시한다.
- 같은 날 반일 분할은 만들지 않는다.

결과: `PASS`

### K. 그림체 승인과 Wireframe을 혼동하는가

공격:

- UL-IMG-007이 최종 캐릭터·배경·제품 UI 자산처럼 사용될 수 있다.

판정:

- UL-IMG-007은 `PLANNING_VISUALIZATION / NOT_PRODUCT_ASSET`다.
- 초상은 Placeholder다.
- 1280×720·Runtime·실제 폰트·최종 아트는 NOT_RUN이다.
- 오생성 감사 대시보드 2개는 폐기 기록을 남겼다.

결과: `PASS`

### L. 테스트가 자기보고만 측정하는가

공격:

- “이해했다” 설문만으로 공정성과 흐름을 통과시킬 수 있다.

판정:

- 첫 선택·탐색 시간·기록 회수·이유 문장·오답 수정·복구·회상·저장 중복을 행동 지표로 정의했다.
- 자기보고는 행동 증거를 대체하지 않는다.

결과: `PASS`

## 3. Finding 상태

### P0

- 0건

### P1

- 기획 계약 내부: 0건
- 구현 시 검증 필요:
  - 숨긴 기능 무부작용
  - 저장 복귀·중복 방지
  - 최소 안전 노선 Gate
  - 1280×720 핵심 입력 접근

위 항목은 기획 승인 차단이 아니라 Build·Runtime Gate다.

### P2

| Finding | 상태 | 포획 위치 |
|---|---|---|
| V-007-01 Legacy/Validation 이어하기 구분 | OPEN_TESTABLE | T0 |
| V-007-02 기록 HUD 발견성 | OPEN_TESTABLE | T4 |
| V-007-03 회수 행동 정답 모양 | OPEN_HUMAN_GATE | T7 |
| V-007-04 1280×720 한국어 축소 | OPEN_RUNTIME_GATE | 해상도 검증 |
| V-007-05 최종 아트 부재 | EXPECTED_DEFERRED | Asset Gate |
| 원인/매개 역할 설명 난이도 | OPEN_HUMAN_GATE | T5 |
| 결과 4축 회상·등급 상한 | OPEN_HUMAN_GATE | T8 |
| 다일 활동 중단 이해 | OPEN_HUMAN_GATE | T9 |

모든 P2는 측정 과제·통과/실패 기준·수정 분기를 가진다.

## 4. 누락 감사

| 영역 | 상태 |
|---|---|
| 제품 흐름 | COMPLETE |
| 화면 책임 | COMPLETE |
| 상태 변형 | COMPLETE |
| 전문 절차 | COMPLETE |
| 저승역 시간순 증거 | COMPLETE |
| 회수 2패턴 | COMPLETE |
| 실패 복구 | COMPLETE |
| 결과 4축 | COMPLETE |
| 최소 연구·보급 환류 | COMPLETE |
| 일정·휴식·강제 출동 | COMPLETE |
| Legacy/Validation 저장 경계 | COMPLETE |
| 접근성·해상도·입력 검증 계약 | COMPLETE |
| 정적 시각화 | COMPLETE |
| 사람 플레이테스트 설계 | COMPLETE |
| 실제 Runtime | NOT_RUN |
| 실제 사람 세션 | NOT_RUN |
| 최종 제품 에셋 | NOT_STARTED |
| 제품 구현 계획 | HOLD_UNTIL_CANON_PASS |

## 5. 정본 이관 준비도

상위 정본 Canon Pass에 필요한 조건:

- 승인 Decision 존재: PASS
- 화면·상황 Spec 존재: PASS
- 적대적 검토 P1 0건: PASS
- 시각 보드와 검수: PASS_WITH_OPEN_P2
- P2 측정 패키지: PASS
- Legacy 보존·대체 관계: PASS
- Google Sheet 동기화: PASS
- 제품 파일 변경 없음: PASS

판정:

`READY_FOR_PLANNING_FINAL_APPROVAL_AND_CANON_PASS`

## 6. 제품 Build 준비도

필요하지만 아직 없는 것:

- 상위 정본 Canon Pass
- 기술 읽기 전용 Codex Plan
- Save Schema·상태 소유자 구현 계획
- 패키지별 TDD 계획
- 실제 Godot Runtime
- 1280×720·1920×1080 렌더
- Legacy·Validation 자동 회귀
- 신규 플레이어 사람 검증

판정:

`NOT_BUILD_READY`

## 7. 권장 최종 결정

현재 기획 패키지를 다음 상태로 승인한다.

```yaml
planning_design: APPROVED_FINAL_BASELINE
visual_planning: APPROVED_WITH_TESTABLE_P2
playtest_design: APPROVED
canon_pass: AUTHORIZED
product_implementation: NOT_AUTHORIZED
runtime_validation: NOT_RUN
human_validation: NOT_RUN
codex: HOLD_UNTIL_CANON_AND_WRITING_PLANS
```

## 8. 다음 Gate

```text
D-2026-08-01-VALIDATION-PLANNING-FINAL-APPROVAL 기록
→ GitHub·Sheet 동기화
→ 상위 정본 Canon Pass
→ Canon reference·상태·Sheet 재검증
→ writing-plans
→ 기술 읽기 전용 Codex Plan
→ 제품 변경 제안 검수
→ 마지막에 Codex Build Goal
```
