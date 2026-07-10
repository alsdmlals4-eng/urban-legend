# Documentation Map

이 문서는 `urban-legend`에서 Base 공용 규칙과 도시괴담 기록국 프로젝트 전용 문서의 책임을 구분한다.

**Base는 공용 규칙의 원본 저장소이고, urban-legend는 프로젝트 전용 저장소다.** 작업자는 Base 링크만 읽지 않는다. 먼저 이 저장소 안에 동기화된 공용 문서의 로컬 사본을 읽고, Base 원격은 동기화와 기준 확인에 사용한다.

## 문서 역할표

| 구분 | 파일 | 역할 |
|---|---|---|
| Base 원본 | [`alsdmlals4-eng/Base`](https://github.com/alsdmlals4-eng/Base) | 공용 규칙의 원본 저장소 |
| 공용 로컬 사본 | `docs/AI_SHARED_WORK_RULES.md` | 공용 AI 작업 원칙 |
| 공용 로컬 사본 | `docs/AI_WORKFLOW_RULES.md` | ChatGPT 작업 순서, 로컬 HTML, Goal 작성 규칙 |
| 공용 로컬 사본 | `docs/BENCHMARKING_REFERENCE_GUIDE.md` | 벤치마킹 표 형식과 사례 목록 |
| 공용 로컬 사본 | `docs/MVP_WORKFLOW_CHECKLIST.md` | 실제 작업 시작/종료 체크리스트 |
| 공용 로컬 사본 | `docs/DOCUMENTATION_MAP.md` | 문서 역할표와 공용/전용 구분 |
| Base 동기화 기록 | `docs/BASE_RULES_VERSION.md` | Base 기준 커밋 SHA, 동기화 날짜, 로컬 확장 이력 |
| 프로젝트 전용 | `AGENTS.md` | 도시괴담 기록국 최상위 규칙 |
| 프로젝트 전용 | `docs/CODEX_SHARED_WORK_RULES.md` | 도시괴담 기록국 Codex 구현 규칙 |
| 프로젝트 전용 | `README.md` | 프로젝트 소개, 실행 방법, 현재 MVP 상태 |
| 프로젝트 전용 | `PROJECT_BRIEF.md` | 한 줄 설명, 장르, 플레이어 역할, 핵심 경험, 차별점 |
| 프로젝트 전용 | `DESIGN_INTENT.md` | 기획 의도, 핵심 루프, 플레이어 감정, 선택지 설계 원칙 |
| 프로젝트 전용 | `MVP_ROADMAP.md` | MVP 목록, Issue 번호, 상태, 완료 기준, 다음 작업 |
| 프로젝트 전용 | `TEST_CHECKLIST.md` | Godot 테스트 순서, MVP별 체크리스트, 오류 기록 방식 |
| 프로젝트 전용 | `docs/MVP_STATUS_AUDIT.md` | 현재 MVP 상태, 문서 충돌, 개선점, 남은 위험 기록 |
| 프로젝트 전용 | `docs/CODEX_GOAL_MVP_017.md` | MVP-017 Codex 실행 Goal |
| 프로젝트 전용 | `docs/CODEX_GOAL_MVP_018.md` | MVP-018 Codex 실행 Goal |
| 프로젝트 전용 | `docs/CODEX_GOAL_MVP_020.md` | MVP-020 Codex 실행 Goal. 실제 GitHub Issue는 #27 |
| 프로젝트 전용 | `docs/CODEX_GOAL_MVP_021.md` | MVP-021 Codex 실행 Goal. 실제 GitHub Issue는 #28 |
| 프로젝트 전용 | `.serena/project.yml` | Serena 프로젝트 설정 |
| 프로젝트 전용 | `data/` | 게임 데이터 |
| 프로젝트 전용 | `scripts/` | Godot 구현 코드 |
| 프로젝트 전용 | `scenes/` | Godot 씬 파일 |

## HTML 대시보드 기준

현재 HTML 대시보드는 GitHub 소스 관리가 아니라 로컬 파일 제공 방식이다.

```text
파일명: urban-legend-database-dashboard.html
사용자 확인 경로: file:///C:/Users/user/Downloads/urban-legend-database-dashboard.html
```

GitHub에 남아 있는 `docs/urban_legend_flow_dashboard.html`은 과거 기록으로 취급하며, 사용자가 명시적으로 GitHub 보관을 요청하지 않는 한 최신 대시보드 기준 파일로 삼지 않는다.

## 새 채팅 또는 새 작업자의 읽기 순서

```text
1. 최신 사용자 지시
2. GitHub Base 원본 규칙
3. AGENTS.md
4. docs/BASE_RULES_VERSION.md
5. docs/DOCUMENTATION_MAP.md
6. docs/AI_SHARED_WORK_RULES.md
7. docs/AI_WORKFLOW_RULES.md
8. docs/MVP_WORKFLOW_CHECKLIST.md
9. docs/BENCHMARKING_REFERENCE_GUIDE.md
10. docs/CODEX_SHARED_WORK_RULES.md
11. README.md
12. PROJECT_BRIEF.md
13. DESIGN_INTENT.md
14. MVP_ROADMAP.md
15. TEST_CHECKLIST.md
16. 현재 GitHub Issue
17. 현재 Codex Goal
18. 실제 수정 대상 파일
```

MVP-021 기준으로 현재 MVP 상태는 `MVP_ROADMAP.md`, `docs/MVP_STATUS_AUDIT.md`, GitHub Issue #28, `docs/CODEX_GOAL_MVP_021.md`를 함께 확인한다.

## 동기화와 확장 원칙

1. Base에서 재사용 가능한 규칙을 먼저 관리한다.
2. urban-legend는 필요한 Base 문서를 로컬 사본으로 유지한다.
3. 현재 동기화 기준은 `docs/BASE_RULES_VERSION.md`에 기록한다.
4. 이 저장소의 `AI_WORKFLOW_RULES.md`, `MVP_WORKFLOW_CHECKLIST.md`, `BENCHMARKING_REFERENCE_GUIDE.md`는 Base 기반 문서에 도시괴담 기록국의 작업 사례를 덧붙인 로컬 확장본이다.
5. 프로젝트 전용 규칙은 공용 규칙을 보완하며, 더 구체적인 규칙이 우선한다.
6. Base 변경은 자동 반영하지 않는다. 영향과 프로젝트 확장 내용을 검토한 뒤 의도적으로 동기화한다.

## 관리 원칙

- 반복 가능한 작업 원칙은 Base와 공용 로컬 사본에 둔다.
- 엔진, 폴더 구조, 세계관, 데이터, 현재 MVP 상태는 프로젝트 전용 문서에 둔다.
- Issue는 현재 작업 기준서이고, Goal은 구현 실행 지시서다.
- HTML 대시보드는 관련 Issue 또는 사용자 최신 지시가 명시할 때 로컬 파일로 갱신한다.
- 도시괴담 기록국 세계관·Godot 경로·현재 MVP 번호는 프로젝트 전용으로 유지한다.
