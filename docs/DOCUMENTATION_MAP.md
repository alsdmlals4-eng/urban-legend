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
→ Notion Project Home
→ CURRENT_PLANNING_CANON.md
→ current-planning-canon.json
→ CURRENT_DECISION_OVERLAY.md
→ CURRENT_HANDOFF.md
→ 구현 작업이면 current Reality Gate / Design / Plan
→ DOCUMENTATION_MAP.md
→ ../skills/SKILL_REGISTRY.json
→ 실제 대상 code/data/Scene/test
→ 필요한 조건부 문서
```

### 콘텐츠·아트·Validation·인수인계

```text
최신 사용자 지시
→ START_HERE.md
→ AGENTS.md
→ GitHub latest main + open PR/Issue
→ Notion Project Home
→ CURRENT_PLANNING_CANON.md
→ current-planning-canon.json
→ CURRENT_DECISION_OVERLAY.md
→ CURRENT_HANDOFF.md
→ VALIDATION_TARGET_CANON.md       # Validation·제품 Target일 때
→ 분야별 current 책임 문서
→ ../skills/SKILL_REGISTRY.json
→ 실제 대상 파일
```

`CURRENT_STATUS.md`, `CURRENT_CONFIRMED_DECISIONS.md`, `CURRENT_HANDOFF_VALIDATION.md`, 과거 spec/plan은 역사·migration·evidence lineage가 필요할 때만 조건부로 읽는다.

## Current authority 순서

```text
최신 사용자 승인
→ GitHub latest main ref
→ Notion current planning
→ CURRENT_PLANNING_CANON.md / current-planning-canon.json
→ CURRENT_DECISION_OVERLAY.md
→ CURRENT_HANDOFF.md
→ current Reality Gate / implementation design / implementation plan
→ 분야별 current canon
→ 실제 code/data/Scene/test
→ 자동·Human evidence
→ 조건부 history ledger
```

현재 기획은 `PLANNING_COMPLETE / USER_FINAL_PLANNING_DECLARATION_APPROVED`다. 과거 annual spec/plan이나 predecessor Issue state는 current 실행 권한이 아니다.

## 운영 책임 원본

| 책임 | 현행 원본 | 읽기 조건 |
|---|---|---|
| 강제 규칙·불변 용어 | `../AGENTS.md` | 항상 |
| 콜드 스타트 | `../START_HERE.md` | 새 채팅·새 작업자 |
| 사람용 전체 그림·Flow·비교표 | Notion Project Home | 기획·상태·검토 |
| 최종 월간 기획·Gate | `CURRENT_PLANNING_CANON.md`, `current-planning-canon.json` | 항상 |
| current mutable decision·successor | `CURRENT_DECISION_OVERLAY.md` | 항상 |
| current continuation | `CURRENT_HANDOFF.md` | 구현·재개·교대 |
| current Reality Gate | `audits/2026-08-22-final-planning-implementation-reality-gate.md` | 구현 진입 |
| current implementation design | `superpowers/specs/2026-08-22-post-planning-runtime-reconciliation-design.md` | 구현 진입 |
| current implementation plan | `superpowers/plans/2026-08-22-post-planning-runtime-reconciliation-implementation-plan.md` | 구현 실행 |
| 장기 구현·검증 history/evidence ceiling | `CURRENT_STATUS.md` | 역사·회귀 계보 |
| Validation Router | `VALIDATION_TARGET_CANON.md` | Validation·제품 Target |
| 상세 승인·대체 역사 | `CURRENT_CONFIRMED_DECISIONS.md` | 역사·근거 추적 |
| 저승역 상세 정본 | `CURRENT_AFTERLIFE_STATION_CANON.md` | M01 규칙·runtime 정합화 |
| 현재 시각 계약 | `CURRENT_VISUAL_WORK_ORDER.md`, `VISUAL_ANCHOR_SPEC.md` | UI/아트/asset 작업 |
| 상세 게임 설계 | `GAME_DESIGN_DOCUMENT.md` | 시스템·콘텐츠 상세 |
| 운영 생명주기 | `OPERATING_MODEL.md` | L1 이상 |
| Work Mode·Skill 라우팅 | `WORK_MODE_AND_SKILL_ROUTING.md` | Skill 선택·보고 |
| 프로젝트 Skill Registry | `../skills/SKILL_REGISTRY.json` | trigger 선택 |
| 검증 계약 | `../TEST_CHECKLIST.md` | 변경 시 |
| 문서 보존·archive | `DOCUMENT_LIFECYCLE.md`, `archive/README.md` | 문서 이동·정리 |

## 프로젝트 기획·구현 원본

| 주제 | 현행 원본 | 읽기 조건 |
|---|---|---|
| 제품 약속·cadence·M01/M04·Gate | `CURRENT_PLANNING_CANON.md` | 모든 제품 변경 |
| current mutable 결정 | `CURRENT_DECISION_OVERLAY.md` | 다음 행동·successor |
| machine contract | `current-planning-canon.json` | 자동 검증·consumer |
| M01/M04 역할 | `M01_M04_VERTICAL_SLICE_FLOW.md` | First Session·release-near Slice |
| M01 조사/추리/구출/회수 | `M01_*_SCENE_PACKET.md` | M01 implementation |
| 저승역 current canon | `CURRENT_AFTERLIFE_STATION_CANON.md` | M01 content/runtime |
| current Validation | `VALIDATION_TARGET_CANON.md` | M01/M04 검증 |
| current visual | `CURRENT_VISUAL_WORK_ORDER.md` | 화면·시각·asset |
| reusable UI grammar | `UI_COMPONENT_REUSE_CONTRACT.md` | 공용 UI implementation |
| 장기 방향·서사·아트 history | `planning/**` current owner files | 해당 분야 의미 변경 |
| 구현 순서 | `../MVP_ROADMAP.md` + current implementation plan | 범위·우선순위 |
| 검증 계약 | `../TEST_CHECKLIST.md` | 구현·문서 변경 |

## 현재 Validation 라우팅

```text
M01_FIRST_SESSION
→ First Session·온보딩·핵심 인과 이해·회귀

M04_RELEASE_NEAR_VERTICAL_SLICE
→ 30~45분 release-near 제품 경험·판매 포인트·통합 품질
```

Human QA는 계속 `NOT_RUN`이며 자동 테스트로 대체하지 않는다.

## Current Issue·PR 라우팅

- open PR은 작업 시작 때 다시 조회하고 소유 경로를 침범하지 않는다.
- Issue open 상태만으로 현재 구현 권한을 부여하지 않는다.
- current canon·overlay·actual main을 기준으로 disposition한다.
- 병합 뒤 open Issue뿐 아니라 merge-linked auto-close Issue도 successor freshness로 재검사한다.
- #181은 final planning handoff 기준 `CURRENT_VALID / IMPLEMENTATION_GATE`; 실제 구현 완료 전 닫지 않는다.

## Skill 조건부 라우팅

| 작업 조건 | 프로젝트 Skill | 추가 책임 원본 |
|---|---|---|
| 새 괴이 사건·전조·가설·근거·대응·매뉴얼 | `urban-legend-investigation-case-authoring` | current canon, GDD, 실제 사건 데이터 |
| 대사·일상·관계·월간 결과 | `urban-legend-narrative` | narrative/current context |
| 육성·일정·조사·회수·밸런스 | `urban-legend-game-design` | GDD, current plan |
| UI·입력·접근성 | `urban-legend-ux-ui-accessibility` | current visual/UI contracts |
| Godot·저장·Scene·데이터 계약 | `urban-legend-engineering` | actual code/test + current plan |
| 에셋 import·Manifest | `urban-legend-technical-art-pipeline` | `IMAGE_ASSET_WORKFLOW.md` |
| 캐릭터 아트·컷인 | `urban-legend-art` | current visual contract |
| 오디오 | `urban-legend-audio` | GDD/current Slice contract |
| 테스트·release gate | `urban-legend-qa` | `../TEST_CHECKLIST.md` |
| Roadmap·Issue·PR·Handoff | `urban-legend-production-pm` | current handoff |
| 플레이테스트·텔레메트리 | `urban-legend-analytics-user-research` | `VALIDATION_TARGET_CANON.md` |

## 현재 Gate 라우팅

```text
PLANNING_COMPLETE
→ USER_FINAL_PLANNING_DECLARATION_APPROVED
→ Reality Gate: HANDOFF_READY_WITH_KNOWN_REALIGNMENT
→ implementation contract: READY
→ runtime implementation authorization: NOT_AUTHORIZED
→ COMPOSITE_RESULT semantic realignment
→ legacy grade/save compatibility
→ additive monthly_state
→ M01 First Session orchestration
→ #181 main menu / Ver 4.3 기존 plan
→ M04 shared-system preparation
→ PRODUCT_REFERENCE_ASSET_PENDING 해소 뒤 release-near visual/audio/VFX
→ runtime/Human evidence
```

현재 mutation blocker는 planning lock이 아니라 **runtime implementation authorization**이다.

## 기본 읽기 제외

- `archive/**`
- 완료된 `qa/**`
- 완료된 `CODEX_GOAL_*`
- `benchmarks/**`
- current handoff가 가리키지 않는 과거 `superpowers/**`
- 과거 보고서·HTML·일회성 감사
- Base 전체 Skill 폴더

Historical evidence나 migration debt가 필요한 경우에만 필요한 문서를 선택해 읽는다.

## Base 운영 계약

Base 릴리스·payload·trusted evidence·registry hash의 단일 owner는 `BASE_RULES_VERSION.md`와 `../skills/PROJECT_BASE_ADAPTER.json`이다. 이 Map은 버전 숫자나 채택 commit을 복제하지 않는다.
