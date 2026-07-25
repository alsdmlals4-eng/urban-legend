# MVP_ROADMAP

> 상태 원본: `docs/CURRENT_STATUS.md`  
> 프로젝트 코어: `docs/PROJECT_CORE.md`  
> 최신 시간 설계: `docs/superpowers/specs/2026-07-25-annual-mvp-001-seven-day-scheduling-design.md`  
> 최신 구현 계획: `docs/superpowers/plans/2026-07-25-annual-mvp-001-seven-day-scheduling-implementation-plan.md`

## 현재 기준

| 항목 | 값 |
|---|---|
| 구현 기준선 | MVP-043 + CORE-VALIDATION-001 + UX-PD-001 2A |
| 화면 버전 | Ver 4.2 |
| 저장 Schema | `mvp-039` (`mvp-038` 이관 지원) |
| 연도제 설계 | `APPROVED_DESIGN_BASELINE` |
| CORE-MVP-001 | `POC_BUILD_READY` |
| ANNUAL-MVP-001 원 구현 | `BUILD_READY` — PR #62 |
| 4주 보정 | `MERGED / AUTOMATED_QA_PASSED` — PR #70 |
| 7일 주간 계약 | `APPROVED / COMPLETE` — Issue #75 |
| 7일 주간 구현 | `MERGED / AUTOMATED_QA_PASSED` — PR #76 / commit `57c1f3d92e0fdae658826a23e5c2326fe9efe478` |
| 사람 사용성 QA | `NOT_RUN` |
| 신규 플레이어 검증 | `NOT_RUN` |
| POC_PASSED | `NOT_DECLARED` |
| 제작 확대 | `NOT_APPROVED` |

## 공통 원칙

- CORE-MVP-001의 조사→가설→검증→전조→회수→매뉴얼 인과를 보존한다.
- ANNUAL 트랙은 기존 `GameState`, `mvp-039`, 기존 사건을 직접 개조하지 않는 격리 경로에서 검증한다.
- 성장과 동료 지원은 핵심 정답·가설·이해도·포획 조건을 변경하지 않는다.
- 자동 회귀 통과만으로 `POC_PASSED`나 제작 확대를 선언하지 않는다.
- 기획·구현·병합 상태 변경은 `docs/PROJECT_UPDATE_PROTOCOL.md`의 동기화 매트릭스를 따른다.
- 충돌 시 최신 사용자 승인 7일 설계 → 승인 계획 → 활성 정본 → PR #70의 4주×3슬롯 → 기존 3주 구현 순서로 해석한다.

## 완료·보존 자산

### CORE-MVP-001

- 사건 코어 독립 PoC `POC_BUILD_READY`
- main 통합 PR #55
- 기존 독립 실행·F1 진입 유지
- 신규 플레이어 증거 `NOT_RUN`

### ANNUAL-MVP-001 역사적 기준

- PR #62 원 수직절편
- PR #65 렌더링·한글·키보드 보정
- PR #67 포인터·모듈 toggle 수정
- PR #70 4주×3슬롯 보정
- PR #73 PROJECT_CORE·GDD 정밀 동기화
- visual run #28/#34, ANNUAL run #94/#101/#103, 문서 run #253/#255는 `HISTORICAL_REGRESSION_EVIDENCE`

## 통합 완료 — 7일 주간·가변 일정 일수

```text
1개월 = 4주 × 주당 7일 = 28일
→ 일정마다 1~3일 소비
→ 주차 경계 초과 금지
→ 첫 미달 확정: 자동 휴식 경고와 편성 유지
→ 같은 편성 재확정: 남은 일수 자동 휴식
→ 직접 휴식은 자동 휴식보다 강함
→ 2주차 위험 0 / 3주차 위험 15 / 4주차 강제 위험 30
→ 사건 → 연구 → 결산
```

### 구현 범위

- JSON `annual-mvp-001-v3`
- 활동별 `day_cost`
- `days_per_week=7`, 월 28일
- `AnnualMvp001StateV2`의 일수 합계·경고·자동 휴식 처리
- 직접 휴식 1일·피로 -25·상태 회복 가능
- 자동 휴식 하루당 피로 5, 관계·특수 회복·추가 보상 없음
- 주간 결과의 `planned_days`, `used_days`, `auto_rest_days`, `activity_results`
- UI의 활동 비용과 사용/남은 일수
- 남은 일수보다 긴 일정 비활성화
- save `annual-mvp-001-save-v1` 유지
- 기존 ID·CORE·렌더링·포인터 계약 보존

### 통합 게이트

- [x] 사용자 승인 설계 기록
- [x] Issue #75 생성
- [x] 데이터·StateV2·Scene·테스트 변경
- [x] PROJECT_CORE·GDD·상태·인수인계·로드맵 정렬
- [x] Python 계약 — run #121 PASS
- [x] Godot 4.7.1 import — run #121 PASS
- [x] CORE focused — run #121 PASS
- [x] ANNUAL focused — run #121 PASS
- [x] 전체 Godot 회귀 — run #121 PASS
- [x] 7일 편성·자동 휴식 경고 렌더링 — run #51 PASS
- [x] 키보드·그래픽 포인터 경로 — run #51 PASS
- [x] PR #76 changed-file·review thread 감사 — thread 0
- [x] PR #76 squash merge — commit `57c1f3d92e0fdae658826a23e5c2326fe9efe478`
- [x] PR #77 상태 원본 병합 — commit `229c74a80b8aefd71d16befb95758f4dcc7f591f`
- [x] Issue #75 completed

## 다음 플레이 게이트

- 2주차 조기 출동: 위험 0
- 3주차 자율 출동: 위험 15
- 4주차 긴급 강제 출동: 위험 30
- 7일 안에서 일정 비용 조합이 의미 있는 고민을 만드는가
- 남은 일수 자동 휴식 경고가 이해되고 실수를 방지하는가
- 직접 휴식과 자동 휴식의 차이를 이해하는가
- 육성 선택이 사건 정보·위험·피해 관리로 연결되는가
- 사건 결과가 연구·스킬·결산으로 환류하는가
- 동료 지원 조건·확률·준비도가 공정한가
- 반복 일정 조작 피로가 허용 가능한가

판정은 `KEEP / AMPLIFY / CHANGE / RETEST / HOLD`를 사용한다.

## 후속 트랙 — 현재 시작 금지

### ANNUAL-MVP-002

진입 조건:

- Issue #75 통합 완료 — PR #76 / commit `57c1f3d92e0fdae658826a23e5c2326fe9efe478`
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
annual_mvp_001_seven_day_contract: APPROVED
annual_mvp_001_seven_day_implementation: MERGED
automated_verification: PASSED
human_usability_qa: NOT_RUN
player_validation: NOT_RUN
annual_loop_passed: NOT_DECLARED
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
```
