# MVP Status Audit

## 점검 일자

2026-07-10

## 점검 목적

현재까지 작성된 MVP 문서와 구현 파일이 서로 충돌하지 않는지 확인하고, MVP-017 작업 전 필요한 문서 기준선을 보강한다.

## 결론 요약

현재 큰 방향의 충돌은 없다.

다만 새 AI/Codex가 작업을 시작할 때 혼동할 수 있는 문서 정합성 문제가 있다.

1. `docs/CODEX_SHARED_WORK_RULES.md`는 직전 정상 기준으로 복구되었다.
2. `AGENTS.md`의 `Current MVP Baseline`은 MVP-017 기준으로 갱신했다.
3. `PROJECT_BRIEF.md`, `DESIGN_INTENT.md`, `MVP_ROADMAP.md`, `TEST_CHECKLIST.md`와 전체 흐름 HTML 대시보드를 추가해 현재 흐름을 빠르게 파악할 수 있게 했다.
5. README와 코드 상수의 버전 표기가 실제 MVP 진행 상태보다 뒤처질 가능성이 있다.

## 확인한 기준 문서

| 파일 | 확인 결과 |
|---|---|
| `AGENTS.md` | 작업 순서와 Godot/GDScript 규칙이 유효하며, Current MVP Baseline을 MVP-017로 갱신함 |
| `docs/BASE_RULES_VERSION.md` | Base 원격 대신 로컬 사본 우선 원칙 확인 |
| `docs/DOCUMENTATION_MAP.md` | 계획 문서 4종이 파일 없음으로 기록되어 있었음 |
| `docs/AI_SHARED_WORK_RULES.md` | 사용자 최신 지시와 프로젝트 규칙 우선 원칙 확인 |
| `docs/AI_WORKFLOW_RULES.md` | HTML 대시보드와 Codex Goal 분리 규칙 확인 |
| `docs/MVP_WORKFLOW_CHECKLIST.md` | 표준 작업 순서, HTML 체크리스트, DoD 확인 |
| `docs/BENCHMARKING_REFERENCE_GUIDE.md` | MVP-017 벤치마킹 표 형식 확인 |
| `docs/CODEX_SHARED_WORK_RULES.md` | 직전 정상 버전 복구 후 확인 |
| `README.md` | MVP-016 설명 존재. 버전 표기 갱신 필요 가능성 있음 |

## 현재 MVP 상태

| 범위 | 상태 | 판단 |
|---|---|---|
| MVP-001~009 | 완료 기준 | 기본 씬, 데이터 기반 대화/조사, 저장, 미니게임, 회수 흐름 존재 |
| MVP-010~012 | 완료 기준 | 요원 편성, 조사 방법, 괴이 상태, 랜덤 이벤트 흐름 존재 |
| MVP-013~015 | 완료 기준 | 장비, 기록물, 준비 화면, 두 번째 사건 준비 연결 존재 |
| MVP-016 | 구현 존재 / Godot 검수 필요 | `agent_trust`, 요원 이벤트, 조사 결과 UI 표시, 저장 구조 확인됨 |
| MVP-017 | Issue 생성 / 문서·HTML 준비 | 사건 보고서와 요원 신뢰도 결산을 다음 구현 목표로 정의 |

## 발견한 충돌과 조치

| 문제 | 위험 | 조치 |
|---|---|---|
| `AGENTS.md` 기준선이 MVP-009 | 새 작업자가 MVP-010~016 구현을 없는 것으로 오해할 수 있음 | MVP-017 기준으로 갱신 완료 |
| 계획 문서 4종 부재 | 프로젝트 목적/로드맵/검수 기준 파악이 늦어짐 | `PROJECT_BRIEF.md`, `DESIGN_INTENT.md`, `MVP_ROADMAP.md`, `TEST_CHECKLIST.md` 생성 완료 |
| 전체 흐름 HTML 부재 | MVP 연결 관계와 현재 위치 확인 어려움 | `docs/urban_legend_flow_dashboard.html` 생성 완료 |
| README 버전 `Ver 1.8` | 실제 진행 단계와 표시 버전 불일치 가능성 | MVP-017 구현과 함께 `Ver 1.9`로 갱신 완료 |
| `SAVE_VERSION := "mvp-014"` | 의도된 저장 호환성인지, 갱신 누락인지 불명확 | 코드 수정 전 실제 저장 호환성 확인 필요. 임의 수정 금지 |

## MVP-016 구현 확인 메모

확인된 구조:

- `AGENT_TRUST_MIN`, `AGENT_TRUST_MAX`
- `AGENT_TRUST_EVENTS`
- `agent_trust`
- `triggered_agent_event_ids`
- `get_agent_trust_support_texts()`
- `resolve_investigation_method()`의 `trust_changes`, `triggered_agent_events`
- 조사 결과 UI의 신뢰도 반응/요원 이벤트 표시
- 저장/불러오기 내 `agent_trust`, `triggered_agent_event_ids`

판단:

- MVP-016은 코드상 주요 구조가 들어가 있다.
- Godot 실행 검증은 별도로 필요하다.
- 결과 화면에는 아직 요원 신뢰도 결산이 집중 표시되지 않는 것으로 보이며, 이 부분이 MVP-017의 자연스러운 다음 작업이다.

## MVP-017 개선 방향

MVP-017은 새 시스템을 크게 늘리는 것보다, 기존 시스템을 한 화면에서 정리해 플레이어가 자신의 진행을 이해하게 만드는 것이 우선이다.

우선순위:

1. 사건 보고서 요약 구조
2. 결과 화면에 보고서 표시
3. 요원 신뢰도/요원 이벤트 결산
4. 수집 단서·미니게임·회수 결과·연구 보상 요약
5. 다음 사건 연결 힌트
6. README와 버전/저장 구조 정합성 점검

## Base 승격 여부

### Base로 승격할 수 있는 내용

- MVP 작업마다 `현재 상태 감사 문서`를 작성하는 원칙
- 전체 흐름 HTML을 Codex 구현 범위와 분리하는 원칙

### 프로젝트 전용으로 유지할 내용

- 괴담 회수/봉인 표현
- 요원 신뢰도와 성향 3종
- 저승역/빨간 우산 사건 구조
- Godot 씬과 GDScript 파일명

## 남은 위험

- 실제 Godot 실행 검증은 MVP-017 구현 후 다시 수행해야 한다.
- `SAVE_VERSION`은 저장 구조를 바꾸지 않아 의도적으로 `mvp-014`를 유지한다.
