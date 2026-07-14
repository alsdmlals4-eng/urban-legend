# Documentation Map

멀티모델 작업 분류·공통 산출물 계약은 `docs/AI_DELEGATION_WORKFLOW.md`, 래스터 콘셉트·변형·manifest 검수는 `docs/IMAGE_ASSET_WORKFLOW.md`, 대사 세부 규칙은 `docs/DIALOGUE_AUTHORING_WORKFLOW.md`를 따른다.

대사·튜토리얼·상황별 반응문 작업은 `docs/DIALOGUE_AUTHORING_WORKFLOW.md`를 기준으로 외부 GPT 작성, DeepSeek 읽기 전용 검수, Codex 적용·검증 순서로 진행한다.

이 문서는 `urban-legend`에서 Base 공용 규칙과 도시괴담 기록국 프로젝트 전용 문서의 책임을 구분한다.

**Base는 공용 규칙의 원본 저장소이고, urban-legend는 프로젝트 전용 저장소다.** 작업자는 Base 링크만 읽지 않는다. 먼저 이 저장소 안에 동기화된 공용 문서의 로컬 사본을 읽고, Base 원격은 동기화와 기준 확인에 사용한다.

## 프로젝트 기준

- 1차 출시 목표: **PC 기준 Steam 출시**
- UI/UX 기본 기준: PC 16:9, 마우스/키보드, Steam 데모 첫인상
- 모바일 세로 최적화: 별도 요청이 있을 때만 범위에 포함
- 플레이어 관점: 별도 고정 주인공이 아니라 괴담기록국 요원 팀을 운용한다.

## 고정 벤치마킹 링크

매 작업에서 아래 링크를 확인하고, 게임성/디자인/아이디어/UX 개선점과 수정할 점을 압축해 반영한다.

1. Unity Asset Store
   - `https://assetstore.unity.com/ko-KR?srsltid=AfmBOoqVvQhMXSGdC4kGuQE4OgvNyuvG7CaIQqlUdoY1qXryac39ZLi0`
2. Tales of Tuscany Demo
   - `https://athenian-rhapsody.itch.io/tales-of-tuscany-demo`

## 문서 역할표

| 구분 | 파일 | 역할 |
|---|---|---|
| Base 원본 | [`alsdmlals4-eng/Base`](https://github.com/alsdmlals4-eng/Base) | 공용 규칙의 원본 저장소 |
| 공용 로컬 사본 | `docs/AI_SHARED_WORK_RULES.md` | 공용 AI 작업 원칙 |
| 공용 로컬 사본 | `docs/AI_WORKFLOW_RULES.md` | ChatGPT 작업 순서와 Goal 작성 규칙 |
| 공용 로컬 사본 + 프로젝트 적용 | `docs/AI_SKILL_ADOPTION_GUIDE.md` | 외부 스킬 비교, 최소 라우팅, 권한 점검, Godot용 context compact 기준 |
| 공용 로컬 사본 | `docs/BENCHMARKING_REFERENCE_GUIDE.md` | 벤치마킹 표 형식과 사례 목록 |
| 공용 로컬 사본 | `docs/MVP_WORKFLOW_CHECKLIST.md` | 실제 작업 시작/종료 체크리스트 |
| 공용 로컬 사본 | `docs/DOCUMENTATION_MAP.md` | 문서 역할표와 공용/전용 구분 |
| Base 동기화 기록 | `docs/BASE_RULES_VERSION.md` | Base 기준 커밋 SHA, 동기화 날짜, 로컬 확장 이력 |
| 프로젝트 전용 | `AGENTS.md` | 도시괴담 기록국 최상위 규칙 |
| 프로젝트 전용 | `docs/DIALOGUE_AUTHORING_WORKFLOW.md` | 외부 GPT 대사 작성, DeepSeek 검수, Codex 적용·검증 계약 |
| 프로젝트 전용 | `docs/AI_DELEGATION_WORKFLOW.md` | DeepSeek·외부 GPT·이미지 모델·Codex 라우팅과 공통 산출물 계약 |
| 프로젝트 전용 | `docs/IMAGE_ASSET_WORKFLOW.md` | 이미지 콘셉트 승인, 변형, manifest, 덮어쓰기·기술 QA 규칙 |
| 프로젝트 전용 | `docs/GODOT_NATIVE_UI_ARCHITECTURE.md` | 기존 테마·런타임 편집기를 유지하는 Godot 네이티브 UI 컴포넌트 원칙과 파일럿 기록 |
| 프로젝트 전용 | `docs/CINEMATIC_FIELD_RECOVERY_UI.md` | 장면 중심 현장 대화·조사 2열 선택·회수 대치 UI 구조와 저장 호환 원칙 |
| 프로젝트 전용 | `docs/MVP037_CAMPAIGN_CORE.md` | 10일 비선형 데모의 일정·위험 순환·일상 이해도·저장 이관 코어 |
| 프로젝트 전용 | `docs/MULTIMODEL_20_TASK_EVALUATION.md` | 실제 DeepSeek 20건의 회수율·첫 통과율·토큰·비용 평가 |
| 프로젝트 전용 | `docs/CODEX_SHARED_WORK_RULES.md` | 도시괴담 기록국 Codex 구현 규칙 |
| 프로젝트 전용 | `README.md` | 프로젝트 소개, 실행 방법, 현재 MVP 상태 |
| 프로젝트 전용 | `PROJECT_BRIEF.md` | 한 줄 설명, 장르, 플레이어 역할, 핵심 경험, 차별점 |
| 프로젝트 전용 | `DESIGN_INTENT.md` | 기획 의도, 핵심 루프, 플레이어 감정, 선택지 설계 원칙 |
| 프로젝트 전용 | `MVP_ROADMAP.md` | MVP 목록, Issue 번호, 상태, 완료 기준, 다음 작업 |
| 프로젝트 전용 | `TEST_CHECKLIST.md` | Godot 테스트 순서, MVP별 체크리스트, 오류 기록 방식 |
| 프로젝트 전용 | `docs/MVP_STATUS_AUDIT.md` | 현재 MVP 상태, 문서 충돌, 개선점, 남은 위험 기록 |
| 프로젝트 전용 | `docs/PROJECT_COMPACT_AUDIT.md` | 스킬 반영 후 GitHub·Godot 개선 우선순위와 compact 후보 |
| 프로젝트 전용 | `docs/CODEX_GOAL_MVP_017.md` | MVP-017 Codex 실행 Goal |
| 프로젝트 전용 | `docs/CODEX_GOAL_MVP_018.md` | MVP-018 Codex 실행 Goal |
| 프로젝트 전용 | `docs/CODEX_GOAL_MVP_020.md` | MVP-020 Codex 실행 Goal. 실제 GitHub Issue는 #27 |
| 프로젝트 전용 | `docs/CODEX_GOAL_MVP_021.md` | MVP-021 Codex 실행 Goal. 실제 GitHub Issue는 #28 |
| 프로젝트 전용 | `docs/CODEX_GOAL_MVP_022.md` | MVP-022 Codex 실행 Goal. 실제 GitHub Issue는 #29 |
| 프로젝트 전용 | `docs/CODEX_GOAL_MVP_023_027.md` | MVP-023~027 통합 Codex 실행 Goal. 실제 GitHub Issue는 #30 |
| 프로젝트 전용 | `docs/CODEX_GOAL_MVP_028.md` | MVP-028 Codex 실행 Goal. 실제 GitHub Issue는 #31 |
| 프로젝트 전용 | `docs/CODEX_GOAL_MVP_029_030.md` | MVP-029~030 통합 UX·현장 판정·데모 후보 실행 Goal |
| 프로젝트 전용 | `.serena/project.yml` | Serena 프로젝트 설정 |
| 프로젝트 전용 | `data/` | 게임 데이터 |
| 프로젝트 전용 | `scripts/` | Godot 구현 코드 |
| 프로젝트 전용 | `scenes/` | Godot 씬 파일 |

## HTML 대시보드 기준

MVP-028부터 HTML 대시보드는 작성하지 않는다. 사용자가 새 HTML 산출물을 명시적으로 요청한 작업에서만 범위에 포함한다. GitHub의 `docs/urban_legend_flow_dashboard.html`과 기존 다운로드 파일은 과거 기록이다.

## 새 채팅 또는 새 작업자의 읽기 순서

```text
1. 최신 사용자 지시
2. GitHub Base 원본 규칙
3. AGENTS.md
4. docs/BASE_RULES_VERSION.md
5. docs/DOCUMENTATION_MAP.md
6. docs/AI_SHARED_WORK_RULES.md
7. docs/AI_WORKFLOW_RULES.md
8. docs/AI_SKILL_ADOPTION_GUIDE.md (외부 스킬/긴 작업일 때)
9. docs/MVP_WORKFLOW_CHECKLIST.md
10. docs/BENCHMARKING_REFERENCE_GUIDE.md
11. docs/CODEX_SHARED_WORK_RULES.md
12. README.md
13. PROJECT_BRIEF.md
14. DESIGN_INTENT.md
15. MVP_ROADMAP.md
16. TEST_CHECKLIST.md
17. 현재 GitHub Issue
18. 현재 Codex Goal
19. 실제 수정 대상 파일
```

MVP-028 기준으로 현재 MVP 상태는 `MVP_ROADMAP.md`, `docs/MVP_STATUS_AUDIT.md`, GitHub Issue #31, `docs/CODEX_GOAL_MVP_028.md`를 함께 확인한다.

Issue #32~#35는 오생성 테스트 이슈로 닫혔으며, 어떤 MVP 기준으로도 사용하지 않는다.

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
- HTML 대시보드는 사용자 최신 지시가 명시할 때만 별도 산출물로 만든다.
- 도시괴담 기록국 세계관·Godot 경로·현재 MVP 번호는 프로젝트 전용으로 유지한다.
