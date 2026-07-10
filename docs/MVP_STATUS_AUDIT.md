# MVP Status Audit

## 점검 일자

2026-07-10

## 점검 목적

현재까지 작성된 MVP 문서와 구현 파일이 서로 충돌하지 않는지 확인하고, MVP-018 작업 전 필요한 기준선을 보강한다.

## 결론 요약

현재 큰 방향의 충돌은 없다.

MVP-017은 사용자 확인 완료 기준으로 보고, MVP-018은 `사건 보고서 기반 기록국 DB 탭 강화`로 진입한다.

핵심 확인 사항:

1. `docs/CODEX_SHARED_WORK_RULES.md`는 프로젝트 전용 Codex 규칙 기준 문서로 유지한다.
2. `AGENTS.md`의 Current MVP Baseline은 MVP-017 기준으로 갱신되어 있다.
3. `PROJECT_BRIEF.md`, `DESIGN_INTENT.md`, `MVP_ROADMAP.md`, `TEST_CHECKLIST.md`와 전체 흐름 HTML 대시보드가 존재한다.
4. MVP-018에서는 완료 사건 보고서 저장을 추가할 수 있으므로 기존 저장 파일 기본값 처리가 중요하다.
5. HTML 대시보드는 ChatGPT 관리 문서이며 Codex Goal 구현 범위에는 넣지 않는다.

## 확인한 기준 문서

| 파일 | 확인 결과 |
|---|---|
| `AGENTS.md` | 작업 순서와 Godot/GDScript 규칙이 유효하며, MVP-017 기준선까지 반영됨 |
| `docs/BASE_RULES_VERSION.md` | Base 원격 대신 로컬 사본 우선 원칙 확인 |
| `docs/DOCUMENTATION_MAP.md` | MVP-018 Goal 파일 등록 완료 |
| `docs/AI_SHARED_WORK_RULES.md` | 사용자 최신 지시와 프로젝트 규칙 우선 원칙 확인 |
| `docs/AI_WORKFLOW_RULES.md` | HTML 대시보드와 Codex Goal 분리 규칙 확인 |
| `docs/MVP_WORKFLOW_CHECKLIST.md` | 표준 작업 순서, HTML 체크리스트, DoD 확인 |
| `docs/BENCHMARKING_REFERENCE_GUIDE.md` | 벤치마킹 표 형식 확인 |
| `docs/CODEX_SHARED_WORK_RULES.md` | Codex 구현 규칙 확인 |
| `README.md` | MVP-018 구현 후 섹션 추가 필요 |
| `MVP_ROADMAP.md` | MVP-018 기준선으로 갱신 완료 |
| `TEST_CHECKLIST.md` | MVP-018 확인 항목 추가 완료 |
| `docs/urban_legend_flow_dashboard.html` | MVP-018 기준으로 갱신 완료 |

## 현재 MVP 상태

| 범위 | 상태 | 판단 |
|---|---|---|
| MVP-001~009 | 완료 기준 | 기본 씬, 데이터 기반 대화/조사, 저장, 미니게임, 회수 흐름 존재 |
| MVP-010~012 | 완료 기준 | 요원 편성, 조사 방법, 괴이 상태, 랜덤 이벤트 흐름 존재 |
| MVP-013~015 | 완료 기준 | 장비, 기록물, 준비 화면, 두 번째 사건 준비 연결 존재 |
| MVP-016 | 완료 기준 | `agent_trust`, 요원 이벤트, 조사 결과 UI 표시, 저장 구조 존재 |
| MVP-017 | 완료 / 사용자 확인 기준 | 결과 화면 사건 보고서와 요원 신뢰도 결산 구현 완료 기준 |
| MVP-018 | Issue 생성 / 문서·HTML·Goal 준비 | 완료 사건 보고서를 기록국 DB에서 재확인하는 작업 |

## 발견한 충돌과 조치

| 문제 | 위험 | 조치 |
|---|---|---|
| MVP-017 완료 후 로드맵 기준선이 이전 상태 | 다음 작업자가 MVP-017을 진행 중으로 오해할 수 있음 | `MVP_ROADMAP.md`를 MVP-018 기준으로 갱신 |
| 전체 흐름 HTML이 MVP-017 기준 | 현재 MVP 위치 오해 가능 | `docs/urban_legend_flow_dashboard.html`을 MVP-018 기준으로 갱신 |
| `docs/CODEX_GOAL_MVP_018.md` 부재 | Codex 전달용 실행 지시서 없음 | 생성 완료 |
| `docs/DOCUMENTATION_MAP.md`에 MVP-018 Goal 미등록 | 새 작업자 문서 탐색 누락 가능 | 등록 완료 |
| `completed_case_reports` 추가 가능성 | 기존 저장 파일 로드 오류 가능 | MVP-018 Goal과 체크리스트에 기본값 처리 명시 |

## MVP-018 개선 방향

MVP-018은 새 사건을 늘리기보다 MVP-017 사건 보고서를 `기록국 DB에서 다시 볼 수 있는 완료 사건 기록`으로 연결하는 단계다.

우선순위:

1. 완료 사건 보고서 저장 스냅샷
2. 기존 저장 파일 기본값 처리
3. 기록국 DB 또는 기록 표시 UI에 완료 사건 목록 표시
4. 선택한 완료 사건 보고서 상세 표시
5. 해금 기록물/장비와 보고서 연결 문구 표시
6. 기존 결과 화면과 두 번째 사건 준비 흐름 보존

## Base 승격 여부

### Base로 승격할 수 있는 내용

- MVP 완료 후 다음 MVP 진입 시 로드맵/HTML/Goal을 함께 갱신하는 원칙
- 저장 구조가 바뀌는 MVP는 기존 저장 파일 기본값 처리를 완료 기준에 넣는 원칙

### 프로젝트 전용으로 유지할 내용

- 괴담 회수/봉인 표현
- 요원 신뢰도와 성향 3종
- 사건 보고서와 기록국 DB 톤
- 저승역/빨간 우산 사건 구조
- Godot 씬과 GDScript 파일명

## 남은 위험

- 실제 Godot 실행 검증은 Codex 구현 후 사용자가 로컬에서 확인해야 한다.
- 기록국 DB UI의 현재 구조에 따라 MVP-018 구현 범위가 `database_view.gd` 또는 다른 기록 표시 UI로 달라질 수 있다.
- 저장 구조를 추가할 경우 기존 저장 파일 기본값 처리가 누락되면 이어하기 오류가 날 수 있다.
