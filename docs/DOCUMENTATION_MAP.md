# Documentation Map

이 문서는 작업에 필요한 문서만 선택하는 라우터다. 모든 문서를 매번 읽지 않는다.

## 기본 읽기 순서

`최신 사용자 지시 → AGENTS.md → BASE_RULES_VERSION.md → DOCUMENTATION_MAP.md → PROJECT_CONTEXT.md → 조건부 문서 → Issue/Goal → 대상 파일`

## Conditional routing

| 관찰 가능한 작업 조건 | 추가로 읽을 문서 |
|---|---|
| DeepSeek·외부 GPT·이미지 모델 위임, patch 수집 | `AI_DELEGATION_WORKFLOW.md` |
| 대사·튜토리얼·상황 반응·일상 에피소드 | `DIALOGUE_AUTHORING_WORKFLOW.md` |
| 이미지 생성·파생 PNG·manifest·Godot import | `IMAGE_ASSET_WORKFLOW.md` |
| 외부 게임·도구·웹 사례 비교 | `BENCHMARKING_REFERENCE_GUIDE.md` |
| 외부 스킬 채택·권한·context compact | `AI_SKILL_ADOPTION_GUIDE.md` |
| Godot UI 구조·컴포넌트·Theme | `GODOT_NATIVE_UI_ARCHITECTURE.md` |
| 조사·회수 장면 중심 UI | `CINEMATIC_FIELD_RECOVERY_UI.md` |
| 저장·진행·일정·위험도·연구·장비 | `MVP037_CAMPAIGN_CORE.md`와 해당 Goal |
| 실제 MVP 시작·종료 점검 | `MVP_WORKFLOW_CHECKLIST.md` |
| Codex 계정 교대·저사용량 checkpoint·새 작업 인수 | `CURRENT_HANDOFF.md`, `CODEX_ACCOUNT_HANDOFF.md` |
| 공용 규칙 동기화·Base 승격 | `AI_SHARED_WORK_RULES.md`, `BASE_RULES_VERSION.md` |
| 과거 Codex 운영 방식 조사 | `CODEX_SHARED_WORK_RULES.md` |

분기 조건이 없으면 해당 문서를 읽지 않는다. 복합 작업은 실제로 영향을 받는 갈래만 추가한다.

## 책임 원본

- 우선순위·보호 경로·완료 보고: `AGENTS.md`
- 프로젝트 용어·플레이어 경험·모델 역할: `PROJECT_CONTEXT.md`
- Base 기준 커밋과 승격 후보: `BASE_RULES_VERSION.md`
- 실행·수동 검증 목록: `TEST_CHECKLIST.md`
- 현재 범위와 상태: 최신 Issue/Goal, `MVP_ROADMAP.md`
- 현재 계정 인수 상태: `CURRENT_HANDOFF.md`
- 프로젝트 소개와 실행: `README.md`

다른 문서가 같은 내용을 반복하면 위 원본을 링크하고 작업별 차이만 기록한다.

## 문서 보존

`docs/CODEX_GOAL_*`, `docs/superpowers/`, `docs/benchmarks/`는 과거 결정과 구현 증거다. 현재 작업의 직접 기준일 때만 읽는다. `docs/urban_legend_flow_dashboard.html`은 과거 기록이며 사용자가 새 HTML 산출물을 요청한 경우에만 갱신한다.

Base 원격 `alsdmlals4-eng/Base`는 공용 규칙의 원본이다. 일상 작업에서는 로컬 사본을 우선하고 Base 동기화·비교·승격 작업에서만 원격을 확인한다.
