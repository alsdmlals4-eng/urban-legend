# Current Project Status

> 문서 위치: `docs/CURRENT_STATUS.md` | 프로젝트 코어: `docs/PROJECT_CORE.md` | 통합 명세: `docs/superpowers/specs/2026-07-23-project-core-integrated-spec.md` | 실행 계획: `docs/superpowers/plans/2026-07-23-core-mvp-001-implementation-plan.md`

이 문서는 현재 브랜치의 구현 사실, 자동 검증, 플레이 검증을 분리한다. `POC_BUILD_READY`는 구현·계약·회귀·기계적 UI 검증이 통과했다는 뜻이며, 플레이테스트 통과나 제작 확대 승인을 뜻하지 않는다.

## 현재 구현 기준

| 항목 | 현재 값 |
|---|---|
| 기존 구현 기준선 | MVP-043 + CORE-VALIDATION-001 + UX-PD-001 2A |
| 신규 브랜치 작업 | CORE-MVP-001 독립 PoC 구현 |
| 화면 버전 | Ver 4.2 |
| 저장 스키마 | `mvp-039` (`mvp-038` 이관 지원) |
| 엔진 | Godot 4.7.1 / GDScript |
| 플랫폼 | PC / Steam, 16:9, 마우스·키보드 |
| 구현 사건 | 기존 3사건 + 독립 저승역 CORE-MVP-001 PoC |
| 주인공 | 권나래 고정 |
| 구현 PR | PR #57 |
| 실행 추적 | Issue #56 |

## 프로젝트 코어와 구현 상태

| 항목 | 상태 |
|---|---|
| 사용자 승인 | 2026-07-23 |
| 코어 상태 | `CORE_RECORDED` |
| 적대적 설계 검토 | `CORE_STRESS_TESTED` |
| 구현 상태 | `POC_BUILD_READY` |
| 자동 검증 | `PASSED` |
| 문서 계약 | run #195 `success` |
| CORE-MVP-001 검증 | run #69 `success` |
| POC_PASSED | 미선언 — 플레이 증거 없음 |
| 제작 확대 | 미승인 |
| 병합 상태 | 리뷰·병합 결정 대기 |
| CI | 재활성화 완료 |

사용자는 전체 원문 메시지, 신규 플레이어 행동 증거, 사전 지표를 `POC_BUILD_READY` 차단 조건에서 제외했다. 자동 계약·Godot 전체 회귀·UI 상태 계약·보호 경계 검증이 통과했으므로 `POC_BUILD_READY`를 판정한다. 플레이 증거 없이 `POC_PASSED`를 선언하지 않는다.

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
- `CoreMvp001State`: 조사 배제, 가설 카드, 현장 검증, 질문 해소, 이해도, 전조, 회수 대응, 포획, 매뉴얼 delta
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
- 단계 전환·Esc 뒤 첫 유효 버튼으로 포커스 복구
- 1280×720·1920×1080에서 핵심 패널·Footer·버튼이 viewport 안에 유지
- 텍스트로 전조·성공·위험을 전달하며 시간 제한 없음
- F1 개발 패널에서 `CORE-MVP-001 조사→전조→포획 PoC`로 진입

## 보호 경계

PR #57은 다음 경로를 수정하지 않는다.

- `scripts/core/game_state.gd`
- 기존 `data/episodes/**`
- 기존 `scripts/scenes/investigation_scene.gd`
- 기존 `scripts/scenes/battle_scene.gd`
- `project.godot`
- `knowledge/base-pack/**`
- 저장 Schema `mvp-039`

PoC는 기존 저장을 읽거나 쓰지 않는다. 장면 테스트는 `TestSaveGuard`로 기존 사용자 저장을 보호하고 save path 비생성을 검증했다.

## TDD와 최신 검증 증거

| 단계 | 증거 | 상태 |
|---|---|---|
| 데이터 계약 Red | run #1, fixture 부재로 실패 | 확인 |
| 데이터 계약 Green | fixture 추가 후 Python 계약 | PASS |
| Godot 로더 Red | run #8, 신규 로더 부재로 실패 | 확인 |
| 집중 테스트 run #16 | 로더 PASS, 로그 PASS, 상태 타입 경고 실패 | 원인 확인 |
| import 회귀 실패 | run #66, import 조기 종료로 기존 미니게임 자산 미생성 | 원인 확인 |
| import 수정 검증 | run #68, `godot --import` 적용 | PASS |
| 최종 문서 계약 | run #195 | PASS |
| 최종 Python 계약 | run #69 | PASS |
| 최종 Godot import | run #69 | PASS |
| 집중 Godot | run #69, 4/4 | PASS |
| 전체 Godot 회귀 | run #69, 43/43 | PASS |
| UI 상태 계약 | 1280×720·1920×1080, Esc·포커스·읽기 전용·저장 비침범 | PASS |
| 보호 경로 diff | 기반 브랜치 대비 변경 파일 확인 | PASS |
| PR review threads | 미해결 스레드 0 | PASS |

## CI 구조

- 문서 PR: Ubuntu + Python 3.12 + 문서 validator
- 코드 PR: Ubuntu 1개 job에서 Python → Godot `--import` → 집중 테스트 → 전체 회귀
- main/nightly: Ubuntu·Windows Python 3.11·3.12·3.13 matrix, Godot 전체 회귀는 Ubuntu 한 번
- 모든 workflow에 ref별 `concurrency`와 `cancel-in-progress: true`
- 실패 artifact만 7일 보존

## 다음 우선순위

| 순서 | 단계 | 상태 | 목적 |
|---:|---|---|---|
| 1 | PR #57 리뷰·병합 결정 | 대기 | `POC_BUILD_READY` 구현 검토 |
| 2 | 선택적 플레이 검증 | 미실행 | `POC_PASSED` 여부 판단 |
| 3 | CORE-MVP-002 승인 | 대기 | 포획·연구·괴이별 영구 지식 재사용 |
| 4 | UX-PD-001 2B·2C / MVP-044~046 | 재매핑 대기 | CORE-MVP-001 결과 뒤 우선순위 재판정 |

CORE-MVP-002는 PR #57 병합과 별도 사용자 승인 전 시작하지 않는다.

## 책임 문서

- 최소 코어: `docs/PROJECT_CORE.md`
- 프로젝트 전체 상세 설계: `docs/GAME_DESIGN_DOCUMENT.md`
- CORE-MVP-001 계약: `docs/superpowers/specs/2026-07-23-project-core-integrated-spec.md`
- TDD 구현 계획: `docs/superpowers/plans/2026-07-23-core-mvp-001-implementation-plan.md`
- CI 운영: `docs/CI_COST_OPTIMIZATION_AND_REENABLEMENT.md`
- 구현 PR: #57
- 실행 Issue: #56
