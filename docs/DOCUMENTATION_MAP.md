# Documentation Map

> 문서 위치: `docs/DOCUMENTATION_MAP.md` | 최상위 라우터: `START_HERE.md` | 운영 모델: `docs/OPERATING_MODEL.md` | 기획 인수인계: `docs/planning/README.md` | 문서 보존 규칙: `docs/DOCUMENT_LIFECYCLE.md` | 백업 찾기: `docs/archive/README.md`

이 문서는 작업에 필요한 문서만 선택하는 라우터다. 모든 문서와 Skill을 매번 읽지 않는다.

## 기본 읽기 순서

### 일반 구현·버그 수정

```text
최신 사용자 지시
→ START_HERE.md
→ AGENTS.md
→ OPERATING_MODEL.md
→ WORK_MODE_AND_SKILL_ROUTING.md
→ CURRENT_STATUS.md
→ DOCUMENTATION_MAP.md
→ ../skills/SKILL_REGISTRY.json
→ 대상 코드·데이터·문서
```

### 새 기획·콘텐츠·아트·연출·인수인계

```text
최신 사용자 지시
→ START_HERE.md
→ AGENTS.md
→ OPERATING_MODEL.md
→ WORK_MODE_AND_SKILL_ROUTING.md
→ CURRENT_STATUS.md
→ planning/README.md
→ planning/PROJECT_DIRECTION.md
→ 분야별 기획서 1개
→ ../skills/SKILL_REGISTRY.json
→ 대상 코드·데이터·에셋
```

추가 문서와 Base Skill 전문은 실제 작업 trigger가 있을 때만 읽는다.

## 운영 책임 원본

| 주제 | 현행 원본 | 읽기 조건 |
|---|---|---|
| 최상위 콜드 스타트 | `../START_HERE.md` | 새 채팅·새 담당자·Base 적용 |
| 프로젝트 강제 규칙·불변 조건 | `../AGENTS.md` | 항상 |
| 공용 작업 생명주기 | `OPERATING_MODEL.md` | L1 이상 작업·구조·검증 판단 |
| Work Mode·Skill·Skill Mode | `WORK_MODE_AND_SKILL_ROUTING.md` | L1 이상 자동 라우팅·실행 보고 |
| Base·프로젝트 Skill 선택 | `../skills/SKILL_REGISTRY.json` | trigger에 맞는 최소 Skill 선택 |
| 통합 전 Skill ID | `../skills/LEGACY_SKILL_ALIASES.md` | 과거 문서·PR·실행 경로에서 이전 ID 발견 |
| Base 기준 커밋·동기화 | `BASE_RULES_VERSION.md` | Base 동기화·승격 |
| Skill 실행 학습 | `../skills/SKILL_LEARNING_LOG.md` | 반복 가능한 실패·결정·검증 결과 발생 |

## 프로젝트 현행 책임 원본

| 주제 | 현행 원본 | 읽기 조건 |
|---|---|---|
| 현재 구현·승인 계획·미구현 구분 | `CURRENT_STATUS.md` | 항상 |
| 기획 인수인계·분야별 라우팅 | `planning/README.md` | 기획·콘텐츠·아트·연출·새 담당자 인수 |
| 프로젝트 약속·핵심 방향 | `planning/PROJECT_DIRECTION.md` | 방향·범위·캐릭터·미감 판단 |
| 서사·대화·관계 | `planning/NARRATIVE_CONTENT_PLAN.md` | 사건 대사, 일상, 관계 이벤트 |
| 아트·표정·컷인·연출 | `planning/ART_PRESENTATION_PLAN.md` | 캐릭터 아트, 대화 UI, 연출 |
| 단계 의존성·인수인계 | `planning/ROADMAP_AND_HANDOFF.md` | MVP 시작·종료, 역할 교대 |
| 적용 사례 | `planning/REFERENCE_CASES.md` | 기존 근거 재사용, 적용·제외 판단 |
| 상세 게임 설계 | `GAME_DESIGN_DOCUMENT.md` | 시스템·콘텐츠 상세 변경 |
| 프로젝트 용어·표현 원칙 | `PROJECT_CONTEXT.md` | 대사·세계관·캐릭터 작업 |
| 구현 순서 | `../MVP_ROADMAP.md` | 범위·우선순위 결정 |
| 검증 계약 | `../TEST_CHECKLIST.md` | 구현·문서 변경 |
| 실행·프로젝트 소개 | `../README.md` | 실행·외부 안내 |
| 현재 계정 인수 상태 | `CURRENT_HANDOFF.md` | 계정·채팅 교대 |
| 문서 보존·백업 정책 | `DOCUMENT_LIFECYCLE.md` | 문서 이동·정리 |

같은 사실을 다른 문서에 장문으로 복사하지 않고 책임 원본을 링크한다. Base 공용 예시는 프로젝트 구현 상태의 정본이 아니다.

## 조건부 라우팅

| 작업 조건 | 추가로 읽을 문서·Skill |
|---|---|
| 기존 구조 감사·구형 파일·경로 이동 | `BASE_RULES_VERSION.md`, Base `managing-game-project-operating-system`, 필요 시 `auditing-canonical-reference-freshness` |
| 코드·데이터·문서·자산 diff 검수 | Base `reviewing-and-validating-project-changes` |
| 대사·상황지시문·일상·후일담 | `planning/NARRATIVE_CONTENT_PLAN.md`, `DIALOGUE_AUTHORING_WORKFLOW.md`, `PROJECT_CONTEXT.md` |
| 관계 태그·선택 기억·연속 이벤트 | `planning/NARRATIVE_CONTENT_PLAN.md`, 실제 저장·이벤트 데이터 |
| 캐릭터 아트·표정·컷인 | `planning/ART_PRESENTATION_PLAN.md`, `IMAGE_ASSET_WORKFLOW.md` |
| Godot UI·Theme·컴포넌트 | `planning/ART_PRESENTATION_PLAN.md`, `GODOT_NATIVE_UI_ARCHITECTURE.md` |
| 조사·회수 장면 UI | `CINEMATIC_FIELD_RECOVERY_UI.md`, GDD 관련 장 |
| 미니게임 규칙·조작·복구 | `MINIGAME_SYSTEM_SPEC.md` |
| 외부 GPT·DeepSeek·이미지 모델 위임 | `AI_DELEGATION_WORKFLOW.md`, 필요 시 Base `orchestrating-deepseek-worktrees` |
| 기존 사례 재사용 | `planning/REFERENCE_CASES.md` |
| 최신 외부 사례 비교가 필요한 새 판단 | `BENCHMARKING_REFERENCE_GUIDE.md`, 필요한 최신 1차 근거, Base `analyzing-and-refining-game-concepts` |
| 저장·진행·일정·위험·경제 | 관련 코드, `MVP037_CAMPAIGN_CORE.md`, `MVP038_SEQUENTIAL_CAMPAIGN.md` |
| 실제 MVP 시작·종료 절차 | `planning/ROADMAP_AND_HANDOFF.md`, `MVP_WORKFLOW_CHECKLIST.md` |
| Base 공용 규칙·기획 지식 승격 | `BASE_RULES_VERSION.md`, Base `managing-base-change-proposals` |
| 계정 교대·저사용량 checkpoint | `CURRENT_HANDOFF.md`, `CODEX_ACCOUNT_HANDOFF.md` |
| 과거 결정·완료 근거 | `archive/README.md`에서 필요한 파일 하나만 선택 |

## 리디렉션·호환 문서

다음 파일은 기존 링크를 보존하기 위한 위치 안내 또는 호환 라우터이며 현행 설계·운영 원본이 아니다.

- `../DESIGN_INTENT.md`
- `../PROJECT_BRIEF.md`
- `CONTENT_DIRECTION_V09.md`
- `AI_SHARED_WORK_RULES.md` — 최신 `OPERATING_MODEL.md`로 연결하는 `COMPATIBILITY_STUB`
- `AI_WORKFLOW_RULES.md` — 최신 Work Mode·Skill 라우팅과 프로젝트 전용 위임 문서 연결
- `BASE_RULES_VERSION.md` — Base 동기화 작업 외에는 기본 읽기 제외

호환 문서를 본 뒤 연결된 현행 원본으로 이동하며 내용 복제 동기화를 만들지 않는다.

## 기본 읽기 제외

- `archive/**`
- 완료된 `qa/**`
- 완료된 `CODEX_GOAL_*`
- `benchmarks/**`
- `superpowers/**`
- 과거 보고서·HTML·일회성 감사
- Base 전체 `skills/**`

이 자료는 현재 작업의 직접 근거가 필요할 때만 연다. “혹시 필요할 수 있음”은 읽기 조건이 아니다.

## 활성 계획 라우팅

MVP-044~046 전달 패키지는 GitHub `main` 구현 완료 문서가 아니다. ZIP을 받은 작업에서 다음 순서로 읽는다.

```text
ZIP/00_README_코덱스_전달사항.md
→ ZIP의 구현 지시서
→ 필요한 제안서·레지스트리
→ CURRENT_STATUS.md
→ planning/README.md와 분야별 기획서
→ 실제 대상 파일
```

패키지 전체를 저장소 현행 문서로 복사하지 않는다. 구현 완료 후 확정된 결과만 상태·GDD·검증·분야별 기획서에 통합한다.

## Base 승격 라우팅

프로젝트 사례에서 공용 원칙을 추출할 때 다음을 분리한다.

- Base로 보낼 것: 반복 가능한 기획 방법, 조사 방식, 아트·연출 판단 프레임, 품질 체크, 도구·Skill 선택 기준, 익명화된 사례 카드
- 프로젝트에 남길 것: 괴이 기록국의 세계관, 캐릭터명, 사건 규칙, 수치, 에셋 경로, 저장 구조, 실제 QA 결과

Base 제안과 Base 활성 구현은 별도 PR로 관리한다. 반영 뒤 `BASE_RULES_VERSION.md`에 기준 커밋과 동기화 상태를 기록한다.

## 상시 동기화

- 플레이어 노출 설계가 바뀌면 `CURRENT_STATUS.md`, GDD, Roadmap, Test, 해당 분야별 기획서를 함께 심사한다.
- 경로·ID·Schema·정본·생성기가 바뀌면 untouched 활성 소비자와 파생본까지 reference-freshness를 감사한다.
- GDD 수정 후 DOCX를 재생성하고 `--check`를 실행한다.
- 큰 단계·MVP 종료 시 날짜·버전·다음 작업을 갱신한다.
- 완료 상세는 현행 문서에 누적하지 않고 `qa/` 또는 날짜별 백업으로 이동한다.
- 5개 MVP마다 구문서·중복·깨진 참조·기본 읽기 범위를 감사한다.
