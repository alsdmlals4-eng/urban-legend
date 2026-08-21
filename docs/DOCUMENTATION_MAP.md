# Documentation Map

> 문서 위치: `docs/DOCUMENTATION_MAP.md`  
> 시작 지점: `../START_HERE.md`  
> 운영 모델: `OPERATING_MODEL.md`  
> 문서 보존 규칙: `DOCUMENT_LIFECYCLE.md`

이 문서는 작업에 필요한 책임 원본을 고르는 라우터다. 모든 문서를 매번 읽지 않는다.

## 기본 읽기 순서

### 일반 구현·버그 수정

```text
최신 사용자 지시
→ START_HERE.md
→ AGENTS.md
→ GitHub latest main + open PR/Issue
→ OPERATING_MODEL.md
→ WORK_MODE_AND_SKILL_ROUTING.md
→ Notion 괴이기록국 프로젝트 홈
→ CURRENT_PLANNING_CANON.md
→ current-planning-canon.json
→ CURRENT_DECISION_OVERLAY.md
→ CURRENT_STATUS.md
→ PROJECT_CORE.md
→ DOCUMENTATION_MAP.md
→ ../skills/SKILL_REGISTRY.json
→ 선택된 Skill·책임 원본
→ 실제 대상 코드·데이터·문서
```

### 기획·콘텐츠·아트·Validation·인수인계

```text
최신 사용자 지시
→ START_HERE.md
→ AGENTS.md
→ GitHub latest main + open PR/Issue
→ Notion 괴이기록국 프로젝트 홈
→ CURRENT_PLANNING_CANON.md
→ current-planning-canon.json
→ CURRENT_DECISION_OVERLAY.md
→ VALIDATION_TARGET_CANON.md       # Validation·제품 Target 관련일 때
→ CURRENT_STATUS.md
→ PROJECT_CORE.md
→ GAME_DESIGN_DOCUMENT.md
→ planning/README.md
→ 분야별 책임 문서
→ ../skills/SKILL_REGISTRY.json
→ 선택된 Skill
→ 실제 대상 코드·데이터·에셋
```

상세 승인·대체 history가 필요한 경우에만 `CURRENT_CONFIRMED_DECISIONS.md`를 추가한다. predecessor Validation 상태 비교가 필요한 경우에만 `CURRENT_HANDOFF_VALIDATION.md`를 추가한다.

## Current authority 순서

```text
최신 사용자 승인
→ GitHub latest main ref
→ Notion 괴이기록국 프로젝트 홈·현재 하위 기획
→ CURRENT_PLANNING_CANON.md / current-planning-canon.json
→ CURRENT_DECISION_OVERLAY.md
→ 분야별 current canon
→ CURRENT_STATUS.md / CURRENT_HANDOFF.md
→ 실제 code/data/Scene/test
→ 자동·Human evidence
→ 상세 history ledger
```

과거 annual spec/plan과 predecessor Issue의 `open` 상태는 현재 실행 권한이 아니다. `ANNUAL-MVP-001/002`는 병합된 runtime/history ID·기술 회귀 근거로 보존한다.

## 운영 책임 원본

| 책임 | 현행 원본 | 읽기 조건 |
|---|---|---|
| 강제 규칙·불변 용어 | `../AGENTS.md` | 항상 |
| 콜드 스타트 | `../START_HERE.md` | 새 채팅·새 작업자 |
| 사람용 전체 그림·Flow·비교표 | Notion 괴이기록국 프로젝트 홈 | 기획·상태·검토 |
| 현재 월간 기획·Gate | `CURRENT_PLANNING_CANON.md`, `current-planning-canon.json` | 항상 |
| current mutable decision·successor | `CURRENT_DECISION_OVERLAY.md` | 항상 |
| 현재 구현·검증 상태 | `CURRENT_STATUS.md` | 항상 |
| Validation current Router | `VALIDATION_TARGET_CANON.md` | Validation·제품 Target |
| 상세 승인·대체·병합 역사 | `CURRENT_CONFIRMED_DECISIONS.md` | 역사·근거 추적 |
| 현재 기획 Handoff | `CURRENT_HANDOFF.md` | 재개·교대 |
| 프로젝트 코어·변경 경계 | `PROJECT_CORE.md` | L1 이상 구조·기획·검수 |
| 상세 게임 설계 | `GAME_DESIGN_DOCUMENT.md` | 시스템·콘텐츠 상세 변경 |
| 운영 생명주기 | `OPERATING_MODEL.md` | L1 이상 |
| Work Mode·Skill 라우팅 | `WORK_MODE_AND_SKILL_ROUTING.md` | Skill 선택·보고 |
| 프로젝트 Skill Registry | `../skills/SKILL_REGISTRY.json` | trigger 선택 |
| Base Skill 인덱스 | `../skills/BASE_SKILL_INDEX.json` | Base trigger 선택 |
| Base 경로 변환 | `../skills/PROJECT_PATH_ADAPTER.json` | Base 경로 해석 |
| 검증 계약 | `../TEST_CHECKLIST.md` | 변경 시 |
| 문서 보존·archive 정책 | `DOCUMENT_LIFECYCLE.md`, `archive/README.md` | 문서 이동·정리 |

## 프로젝트 기획 원본

| 주제 | 현행 원본 | 읽기 조건 |
|---|---|---|
| 프로젝트 약속·최소 코어 | `PROJECT_CORE.md` | 모든 구조·기획 변경 |
| 상세 게임 설계 | `GAME_DESIGN_DOCUMENT.md` | 전체 시스템·콘텐츠 상세 변경 |
| 현재 월간 제품 구조 | `CURRENT_PLANNING_CANON.md` | cadence·Slate·M01/M04·Gate |
| current mutable 결정 | `CURRENT_DECISION_OVERLAY.md` | 다음 행동·successor state |
| 현재 기계 계약 | `current-planning-canon.json` | 자동 검증·consumer |
| M01/M04 역할 | `M01_M04_VERTICAL_SLICE_FLOW.md` | 온보딩·release-near Slice |
| 저승역 상세 정본 | `CURRENT_AFTERLIFE_STATION_CANON.md` | M01 규칙·구형 자료 대체 |
| 현재 Validation | `VALIDATION_TARGET_CANON.md` | M01 First Session·M04 Slice |
| 현재 시각 작업 순서 | `CURRENT_VISUAL_WORK_ORDER.md` | 화면·시각·자산 검토 |
| 기획 인수인계·분야 라우팅 | `planning/README.md` | 기획·콘텐츠·아트·연출 |
| 장기 방향 | `planning/PROJECT_DIRECTION.md` | 범위·캐릭터·미감 판단 |
| 서사·대화·관계 | `planning/NARRATIVE_CONTENT_PLAN.md` | 사건 대사·일상·관계 이벤트 |
| 아트·표정·컷인·연출 | `planning/ART_PRESENTATION_PLAN.md` | 아트·대화 UI·연출 |
| 준비·조사·결과 정보 위계 | `planning/PROGRESSIVE_DISCLOSURE_PLAN.md` | UX 후속 |
| 단계 의존성·인수인계 | `planning/ROADMAP_AND_HANDOFF.md` | MVP 시작·종료·교대 |
| 구현 순서 | `../MVP_ROADMAP.md` | 범위·우선순위 결정 |
| 검증 계약 | `../TEST_CHECKLIST.md` | 구현·문서 변경 |
| 프로젝트 용어·표현 | `PROJECT_CONTEXT.md` | 대사·세계관·캐릭터 |
| 실행·외부 소개 | `../README.md` | 실행·외부 안내 |

## 현재 Validation 라우팅

```text
M01_FIRST_SESSION
→ 첫 세션·온보딩·핵심 인과 이해·회귀

M04_RELEASE_NEAR_VERTICAL_SLICE
→ 30~45분 release-near 실제 제품 경험·판매 포인트·통합 품질
```

과거 저승역 단일 35~50분 Validation Target은 current execution authority가 아니다. 원문은 `archive/history/VALIDATION_TARGET_CANON_PRE_MONTHLY_2026-08-21.md`에 보존한다. predecessor Issue #92·#105를 닫아도 현재 Human QA는 계속 `NOT_RUN`이다.

## Current Issue·PR 라우팅

- open PR은 작업 시작 때 다시 조회하고 소유 경로를 침범하지 않는다.
- Issue의 open 상태만으로 현재 구현 권한을 부여하지 않는다.
- current canon·`CURRENT_DECISION_OVERLAY.md`·실제 main을 기준으로 disposition한다.
- 2026-08-21 전수 교정 receipt: `audits/2026-08-21-open-issue-and-authority-freshness-correction.md`.
- 유효 미완료지만 PLAN_LOCK으로 미루는 작업은 `DEFERRED_VALID`로 유지한다.

## CORE-MVP-001 보존 문서

| 책임 | 문서 |
|---|---|
| CORE-MVP-001 마일스톤 계약 | `superpowers/specs/2026-07-23-project-core-integrated-spec.md` |
| CORE-MVP-001 실행 계획 | `superpowers/plans/2026-07-23-core-mvp-001-implementation-plan.md` |
| 스트레스 테스트·벤치마킹 | `planning/PROJECT_CORE_STRESS_TEST_AND_BENCHMARK.md` |

위 문서는 역사적 마일스톤 계약·기술 회귀 근거를 보존한다. 현재 월간 제품 cadence나 M01/M04 Validation 책임을 소유하지 않는다.

## Skill 조건부 라우팅

| 작업 조건 | 프로젝트 Skill | 추가 책임 원본 |
|---|---|---|
| 새 괴이 사건·전조·가설·근거·대응·매뉴얼 | `urban-legend-investigation-case-authoring` | current canon, GDD, 실제 사건 데이터 |
| 대사·일상·관계·월간 결과 | `urban-legend-narrative` | `planning/NARRATIVE_CONTENT_PLAN.md`, `PROJECT_CONTEXT.md` |
| 육성·일정·조사·미니게임·회수·밸런스 | `urban-legend-game-design` | GDD, `MINIGAME_SYSTEM_SPEC.md` |
| UI·입력·접근성 | `urban-legend-ux-ui-accessibility` | `planning/PROGRESSIVE_DISCLOSURE_PLAN.md`, UI 문서 |
| Godot·저장·Scene·데이터 계약 | `urban-legend-engineering` | 실제 코드·테스트 |
| 에셋 import·Manifest | `urban-legend-technical-art-pipeline` | `IMAGE_ASSET_WORKFLOW.md` |
| 캐릭터 아트·표정·컷인 | `urban-legend-art` | `planning/ART_PRESENTATION_PLAN.md` |
| 오디오 | `urban-legend-audio` | GDD, `planning/PROJECT_DIRECTION.md` |
| 테스트·release gate | `urban-legend-qa` | `../TEST_CHECKLIST.md`, `MVP_WORKFLOW_CHECKLIST.md` |
| Roadmap·Issue·PR·Handoff | `urban-legend-production-pm` | `../MVP_ROADMAP.md`, `planning/ROADMAP_AND_HANDOFF.md` |
| 플레이테스트·텔레메트리 | `urban-legend-analytics-user-research` | `VALIDATION_TARGET_CANON.md`, 플레이 로그 |

활성 운영 문서는 다음 경로로 조사 사건 제작 계약을 찾을 수 있어야 한다.

- `../skills/SKILL_REGISTRY.json`
- `../skills/BASE_SKILL_INDEX.json`
- `../skills/urban-legend-investigation-case-authoring/SKILL.md`

## 현재 Gate 라우팅

```text
Notion current planning
→ CURRENT_PLANNING_CANON.md / current-planning-canon.json
→ CURRENT_DECISION_OVERLAY.md
→ CURRENT_STATUS.md
→ PROJECT_CORE.md
→ M01/M04 책임 문서
→ 사용자 시각 시안 review
→ 사용자 전체 기획 완료 또는 보류 범위
→ fresh main Reality Gate
→ 별도 구현 계약·TDD·HiGodot
```

현재 상태는 `NON_VISUAL_PLANNING_CLOSURE_READY / OVERALL_PLAN_OPEN / PLAN_LOCK`이다. runtime 구현 진입점은 아직 열리지 않았다.

## 기본 읽기 제외

- `archive/**`
- 완료된 `qa/**`
- 완료된 `CODEX_GOAL_*`
- `benchmarks/**`
- 비활성 `superpowers/**`
- 과거 보고서·HTML·일회성 감사
- Base 전체 Skill 폴더

현재 작업이 historical evidence나 migration debt를 요구할 때만 필요한 문서 하나를 선택해 읽는다.

## Base 운영 계약

Base 릴리스·payload·trusted evidence·registry hash의 단일 owner는 `BASE_RULES_VERSION.md`와 `../skills/PROJECT_BASE_ADAPTER.json`이다. 이 Map은 버전 숫자나 채택 commit을 복제하지 않는다.