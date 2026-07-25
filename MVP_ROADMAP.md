# MVP_ROADMAP

> 상태 원본: `docs/CURRENT_STATUS.md`  
> 프로젝트 코어: `docs/PROJECT_CORE.md`  
> 최신 4주 설계: `docs/superpowers/specs/2026-07-25-annual-mvp-001-four-week-month-design.md`  
> 최신 구현 계획: `docs/superpowers/plans/2026-07-25-annual-mvp-001-four-week-month-implementation-plan.md`

## 현재 기준

| 항목 | 값 |
|---|---|
| 구현 기준선 | MVP-043 + CORE-VALIDATION-001 + UX-PD-001 2A |
| 화면 버전 | Ver 4.2 |
| 저장 Schema | `mvp-039` (`mvp-038` 이관 지원) |
| 연도제 설계 | `APPROVED_DESIGN_BASELINE` |
| CORE-MVP-001 | `POC_BUILD_READY` |
| ANNUAL-MVP-001 원 구현 | `BUILD_READY` — PR #62 |
| 4주 월간 계약 | `APPROVED` — Issue #69 |
| 4주 구현 | `MERGED / AUTOMATED_QA_PASSED` — PR #70 / commit `20a0d052e4d48863481af7c3acc53805105d6a01` |
| 문서 계약 | `PASSED` — run #253 |
| ANNUAL 자동 검증 | `PASSED` — run #101 |
| 4주 시각·입력 QA | `PASSED` — run #34 |
| 사람 사용성 QA | `NOT_RUN` |
| 신규 플레이어 검증 | `NOT_RUN` |
| POC_PASSED | `NOT_DECLARED` |
| 제작 확대 | `NOT_APPROVED` |

## 공통 원칙

- CORE-MVP-001의 조사→가설→검증→전조→회수→매뉴얼 인과를 보존한다.
- ANNUAL 트랙은 기존 `GameState`, `mvp-039`, 기존 사건을 직접 개조하지 않는 격리 경로에서 검증한다.
- 성장과 동료 지원은 핵심 정답·가설·이해도·포획 조건을 변경하지 않는다.
- 자동 회귀 통과만으로 `POC_PASSED`나 제작 확대를 선언하지 않는다.
- 충돌 시 최신 사용자 승인 4주 설계 → 승인 계획 → 활성 정본 → 기존 3주 구현 순서로 해석한다.

## 완료·보존

### CORE-MVP-001

- 사건 코어 독립 PoC `POC_BUILD_READY`
- main 통합 PR #55
- focused suite는 4주 통합 run #101에서 재통과
- 기존 독립 실행·F1 진입 유지
- 신규 플레이어 증거 `NOT_RUN`

### ANNUAL-MVP-001 원 수직절편

- PR #62 구현
- PR #65 렌더링·한글·키보드 보정
- PR #67 포인터 경로·모듈 toggle 수정
- 과거 visual run #28, ANNUAL run #94, 전체 49/49는 `HISTORICAL_REGRESSION_EVIDENCE`

## ANNUAL-MVP-001 4주 월간 보정 — 통합 완료

### 활성 루프

```text
1주차 3슬롯
→ 2주차 3슬롯 → 출동 위험 0 / 지연
→ 3주차 3슬롯 → 출동 위험 15 / 지연
→ 4주차 3슬롯 → 결과 확인 → 강제 출동 위험 30
→ 사건 → 연구 → 결산
```

### 구현 범위

- JSON `annual-mvp-001-v2`
- 4주 × 3슬롯 = 12슬롯
- `AnnualMvp001StateV2`
- 3주차 지연 후 4주차 계획
- 4주차 결과 확인 뒤 강제 출동
- 주차 UI `/4`와 지연 비용 안내
- save `annual-mvp-001-save-v1` 유지
- 활성 정본·인수인계·검증 계약 동기화

### 통합 결과

- [x] 사용자 승인 설계 기록
- [x] Issue #69 생성·완료
- [x] 데이터·StateV2·Scene·테스트 반영
- [x] `CURRENT_STATUS`·Handoff·Roadmap·Checklist 동기화
- [x] 문서 run #253 PASS
- [x] Godot 4.7.1 import PASS
- [x] CORE focused PASS
- [x] ANNUAL focused PASS
- [x] 전체 Godot 회귀 PASS
- [x] Visual run #34 PASS
- [x] PR #70 squash merge

## 다음 플레이 게이트

다음 세 경로를 실제 사람이 검증한다.

- 2주차 조기 출동: 위험 0
- 3주차 자율 출동: 위험 15
- 4주차 긴급 강제 출동: 위험 30

판정 항목:

- 육성 선택이 사건 정보·위험·피해 관리로 연결되는가
- 사건 결과가 연구·스킬·결산으로 환류하는가
- 마지막 3슬롯과 강제 출동 위험 사이에 실제 고민이 생기는가
- 동료 지원 조건·확률·준비도가 공정한가
- 반복 일정의 조작 피로가 허용 가능한가

판정은 `KEEP / AMPLIFY / CHANGE / RETEST / HOLD`를 사용한다.

## 후속 트랙 — 현재 시작 금지

### ANNUAL-MVP-002

진입 조건:

- 사람 사용성 QA 완료
- 신규 플레이어가 육성→사건→연구 인과를 설명
- 동료 지원 공정성 확인
- 별도 사용자 승인

후보: 동료 2명, 고유 스킬 차별화, 공용 슬롯 확장, 장비·연구 조합.

### ANNUAL-MVP-003

1분기 전체 일정·핵심/중형/소형 사건·관계 이벤트·기관 요청·실패 전진.

### ANNUAL-MVP-004

1년 4분기, 분기별 핵심 사건, 연간 관계·기관 진행, 연도 결산과 다음 연도 계승.

## 보호 계약

- 권나래 고정 주인공
- 괴이는 처치하지 않고 안정화·잔향 회수
- 플레이어는 권나래만 직접 명령
- 동료는 정답·필수 단서를 독점하지 않음
- 저장 `mvp-039`, `mvp-038`, `annual-mvp-001-save-v1` 유지
- `scripts/core/game_state.gd`, `data/episodes/**`, `project.godot`, `knowledge/base-pack/**` 보호

## 현재 상태

```text
annual_mvp_001_four_week_contract: APPROVED
annual_mvp_001_four_week_implementation: MERGED
automated_verification: PASSED
rendered_visual_review: PASSED
keyboard_input_qa: PASSED
graphical_pointer_event_qa: PASSED
human_usability_qa: NOT_RUN
player_validation: NOT_RUN
annual_loop_passed: NOT_DECLARED
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
```
