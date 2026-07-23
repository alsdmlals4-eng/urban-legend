# Current Project Status

> 문서 위치: `docs/CURRENT_STATUS.md` | 프로젝트 코어: `docs/PROJECT_CORE.md` | 통합 명세: `docs/superpowers/specs/2026-07-23-project-core-integrated-spec.md` | 실행 계획: `docs/superpowers/plans/2026-07-23-core-mvp-001-implementation-plan.md`

이 문서는 현재 브랜치의 구현 사실, 사용자 승인 설계, 검증 상태를 분리한다. 코드를 작성했다는 사실은 자동 검증 또는 병합 준비가 끝났다는 뜻이 아니다.

## 현재 구현 기준

| 항목 | 현재 값 |
|---|---|
| 기존 구현 기준선 | MVP-043 + CORE-VALIDATION-001 + UX-PD-001 2A |
| 신규 브랜치 작업 | CORE-MVP-001 독립 PoC 구현 |
| 화면 버전 | Ver 4.2 |
| 저장 스키마 | `mvp-039` (`mvp-038` 이관 지원) |
| 엔진 | Godot 4.7 / GDScript |
| 플랫폼 | PC / Steam, 16:9, 마우스·키보드 |
| 구현 사건 | 기존 3사건 + 독립 저승역 CORE-MVP-001 PoC |
| 주인공 | 권나래 고정 |
| 구현 PR | Draft PR #57 |
| 실행 추적 | Issue #56 |

## 프로젝트 코어와 구현 상태

| 항목 | 상태 |
|---|---|
| 사용자 승인 | 2026-07-23 |
| 코어 상태 | `CORE_RECORDED` |
| 적대적 설계 검토 | `CORE_STRESS_TESTED` |
| 구현 상태 | `IMPLEMENTATION_IN_PROGRESS` |
| 자동 검증 | `ACTION_REQUIRED / AUTOMATED_VERIFICATION_PENDING` |
| POC_BUILD_READY | 선언 금지 — Python·Godot·보호 경로 검증 대기 |
| POC_PASSED | 선언 금지 — 플레이 지표를 필수 게이트에서는 제외했지만 통과 증거도 없음 |
| 병합 상태 | Draft 유지 |
| CI 비용 게이트 | `CI_ENABLED == true`일 때만 runner 할당 |

사용자는 전체 원문 메시지, 신규 플레이어 행동 증거, 사전 지표를 진행 차단 조건에서 제외했다. 따라서 Actions 재개 뒤 자동 계약·Godot 전체 회귀·보호 경로 검증이 통과하면 `POC_BUILD_READY`까지 판정할 수 있다. 플레이 증거 없이 `POC_PASSED`를 선언하지 않는다.

## CORE-MVP-001 현재 구현

### 독립 데이터

- `data/poc/core_mvp_001/afterlife_station_poc.json`
- 조사 장면 3개, 단서 6개, 관련 매뉴얼 3개
- 선택지 4개, 가설 2개, 현장 검증 2개
- 회수 패턴 3개, 고정 5턴 순서, 행동 8개
- 정상·비용·긴급 포획 결과 3개
- 모든 전용 ID는 통합 명세의 `poc001_` 고정 ID와 일치

### 독립 런타임

- `CoreMvp001CaseData`: JSON 로드, 고정 ID·수량·참조·미관측 패턴·포획 규칙 검증
- `CoreMvp001State`: 조사 배제, 가설 카드, 현장 검증, 이해도, 전조, 회수 대응, 포획, 매뉴얼 delta
- `CoreMvp001PlaytestLog`: 연속 sequence, deep copy, JSONL 내보내기, 중복 세션 시작 방지
- `CoreMvp001Scene`: 조사·가설·현장 검증·회수·결과의 단계별 단일 패널 UI

### 플레이 계약

1. 관련 매뉴얼을 선택지에 연결해 정확히 두 선택지를 배제한다.
2. 남은 가설에 지지·반박·미해결 근거를 직접 연결한다.
3. 무관한 근거는 제출 단계에서 거부하며 체력·위험 비용이 없다.
4. 현장 검증 성공은 핵심 미해결 질문을 해소하고 이해도를 `understood`로 올린다.
5. 실패는 반응 단서·피해·위험·누적 위험 사례를 남기며 정답을 자동 공개하지 않는다.
6. 회수에서는 실제 패턴을 먼저 잠그고 현재 이해도로 전조를 해석한다.
7. 미관측 패턴 첫 발동은 행동명·대상·범위·조건을 숨기고 범용 대응과 피해 상한 18을 제공한다.
8. 포획 표식 3개를 5턴 이상에서 모으면 포획 창이 열린다.
9. 결과는 회수 품질·피해 관리·지식 품질로 분리한다.
10. 결과 비교 뒤 매뉴얼 반영 검토와 기록 확정을 별도 단계로 수행한다.

### UI·접근성

- 한 장면에서 현재 단계 패널만 표시
- 단계별 `ScrollContainer`
- 고정 Footer: 이전 단계·확인·로그 내보내기
- 이전 단계는 읽기 전용 검토이며 선택한 근거와 가설을 보존
- 단계 전환·뒤로가기 뒤 첫 유효 버튼으로 포커스 복구
- 텍스트로 전조·성공·위험을 전달하며 시간 제한 없음
- F1 개발 패널에서 `CORE-MVP-001 조사→전조→포획 PoC`로 진입

## 보호 경계

다음은 PR #57에서 수정하지 않는다.

- `scripts/core/game_state.gd`
- 기존 `data/episodes/**`
- 기존 `scripts/scenes/investigation_scene.gd`
- 기존 `scripts/scenes/battle_scene.gd`
- `project.godot`
- `knowledge/base-pack/**`
- 저장 Schema `mvp-039`

PoC는 기존 저장을 읽거나 쓰지 않는다. 테스트는 `TestSaveGuard`로 기존 사용자 저장을 보호한다.

## TDD와 현재 검증 증거

| 단계 | 증거 | 상태 |
|---|---|---|
| 데이터 계약 Red | run #1, fixture 부재로 실패 | 확인 |
| 데이터 계약 Green | fixture 추가 후 Python 계약 | 과거 PASS |
| Godot 로더 Red | run #8, 신규 로더 부재로 실패 | 확인 |
| 집중 테스트 run #16 | 로더 PASS, 로그 PASS, 상태 타입 경고 실패 | 확인 |
| 타입 수정 이후 | 상태·장면·고정 ID·미해결 질문 계약 추가 | 실행 보류 |
| 최신 Python 계약 | 데이터 + 정적 통합 계약 | `ACTION_REQUIRED` |
| 최신 집중 Godot | 4개 | `ACTION_REQUIRED` |
| 전체 Godot 회귀 | 기존 포함 43개 | `ACTION_REQUIRED` |
| 1280×720·1920×1080 수동 QA | 화면 잘림·포커스·Esc·저장 비침범 | `ACTION_REQUIRED` |

GitHub Actions 비용 문제로 현재 모든 PR job은 `CI_ENABLED == true`가 아니면 즉시 `skipped`된다. 상세 재개 절차는 `docs/CI_COST_OPTIMIZATION_AND_REENABLEMENT.md`가 소유한다.

## Actions 재개 뒤 필수 순서

1. `CI_ENABLED=true` 설정 또는 비용 게이트 제거
2. main/nightly full matrix workflow 추가
3. 문서 계약 validator 실행
4. CORE-MVP-001 Python 계약 실행
5. Godot 4.7.1 import
6. 집중 테스트 `4/4`
7. 전체 Godot 회귀 `43/43`
8. 1280×720·1920×1080 수동 UI·접근성 확인
9. 보호 경로 diff 재확인
10. `POC_BUILD_READY` 판정

## CI 비용 최적화

- 문서 PR: Ubuntu + Python 3.12 + 문서 validator만 실행
- 코드 PR: Ubuntu 1개 job에서 Python → Godot import → 집중 테스트 → 전체 회귀 순차 실행
- main/nightly: Ubuntu·Windows Python matrix, Godot 전체 회귀는 Ubuntu 한 번
- 모든 workflow에 ref별 `concurrency`와 `cancel-in-progress: true`
- 실패 artifact만 7일 보존
- Actions 비활성 기간에는 runner를 할당하지 않음

## 다음 우선순위

| 순서 | 단계 | 상태 | 목적 |
|---:|---|---|---|
| 1 | CORE-MVP-001 최신 자동 검증 | `ACTION_REQUIRED` | 작성된 구현의 파서·계약·회귀 판정 |
| 2 | 정적 검토 보완 | 진행 중 | 실행 전 확인 가능한 ID·상태·참조·보호 경계 정렬 |
| 3 | CORE-MVP-001 수동 UI QA | Actions 재개 뒤 | 화면·포커스·Esc·저장 비침범 확인 |
| 4 | CORE-MVP-002 | 대기 | 포획·연구·괴이별 영구 지식 재사용 |
| 5 | UX-PD-001 2B·2C / MVP-044~046 | 재매핑 대기 | CORE-MVP-001 결과 뒤 우선순위 재판정 |

## 책임 문서

- 최소 코어: `docs/PROJECT_CORE.md`
- 프로젝트 전체 상세 설계: `docs/GAME_DESIGN_DOCUMENT.md`
- CORE-MVP-001 계약: `docs/superpowers/specs/2026-07-23-project-core-integrated-spec.md`
- TDD 구현 계획: `docs/superpowers/plans/2026-07-23-core-mvp-001-implementation-plan.md`
- CI 재개 절차: `docs/CI_COST_OPTIMIZATION_AND_REENABLEMENT.md`
- 구현 PR: #57
- 실행 Issue: #56
