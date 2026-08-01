# Current Documentation Map

> 문서 역할: `CURRENT_DOCUMENTATION_MAP`
> 상태: `CURRENT`
> 시작 지점: `../START_HERE.md`
> 현재 승인 결정: `CURRENT_CONFIRMED_DECISIONS.md`
> 현재 Validation Target: `VALIDATION_TARGET_CANON.md`
> 현재 구현 상태: `CURRENT_STATUS.md`
> Legacy 호환 Map: `DOCUMENTATION_MAP.md`

이 문서는 현재 승인된 Validation 기획과 이후 구현 준비의 활성 라우터다. 기존 `DOCUMENTATION_MAP.md`는 연도제·CORE·과거 구현 라우팅을 보존하는 호환 자료다.

## 1. 현재 권위 순서

```text
최신 사용자 승인
→ CURRENT_CONFIRMED_DECISIONS.md
→ VALIDATION_TARGET_CANON.md
→ 관련 Decision 상세 문서
→ PROJECT_CORE.md의 충돌하지 않는 장기 제품 정체성
→ GAME_DESIGN_DOCUMENT.md의 충돌하지 않는 상세 설계
→ CURRENT_STATUS.md의 실제 구현·검증 상태
→ 실제 main 코드·데이터·Scene·테스트
→ Legacy 설계·과거 PR·아카이브
```

상태:

- `APPROVED_FINAL_PLANNING_BASELINE`: 현재 승인 기획
- `APPROVED_TARGET_NOT_IMPLEMENTED`: 승인됐지만 제품에 미구현
- `CURRENT_IMPLEMENTATION_LEGACY`: 실제 동작하지만 Target과 다른 과거 계약
- `HISTORICAL_EVIDENCE`: 당시 유효했던 구현·QA 증거
- `NOT_RUN`: 실행하지 않은 검증

## 2. 기본 읽기

### 구현·버그 수정

```text
최신 사용자 지시
→ ../START_HERE.md
→ ../AGENTS.md
→ OPERATING_MODEL.md
→ WORK_MODE_AND_SKILL_ROUTING.md
→ CURRENT_CONFIRMED_DECISIONS.md
→ VALIDATION_TARGET_CANON.md
→ CURRENT_STATUS.md
→ PROJECT_CORE.md
→ DOCUMENTATION_MAP_CURRENT.md
→ ../skills/SKILL_REGISTRY.json
→ 선택된 Skill
→ 대상 코드·데이터·Scene·테스트
```

### 기획·콘텐츠·아트·인수인계

```text
최신 사용자 지시
→ ../START_HERE.md
→ ../AGENTS.md
→ CURRENT_CONFIRMED_DECISIONS.md
→ VALIDATION_TARGET_CANON.md
→ CURRENT_STATUS.md
→ PROJECT_CORE.md
→ planning/README.md
→ 분야별 책임 원본
→ ../skills/SKILL_REGISTRY.json
→ 선택된 Skill
→ 대상 코드·데이터·에셋·테스트
```

### Base 이관

```text
CURRENT_CONFIRMED_DECISIONS
→ BASE_RULES_VERSION
→ skills/PROJECT_BASE_ADAPTER.json
→ PR #120 상태
→ Canon Pass 완료 증거
→ 최신 Base lock·Registry
→ 별도 이관 감사·승인·검증
```

현재 PR #120은 `DRAFT_HOLD`다.

## 3. 현재 활성 트랙

```text
Validation 기획 최종 승인
→ Canon reference·상태·Sheet 검증
→ writing-plans
→ Codex 읽기 전용 기술 Plan
→ CHANGE_PROPOSAL 검수
→ 구현 패키지 승인
→ 마지막에 Codex Build Goal
```

- 기획: `APPROVED_FINAL_PLANNING_BASELINE`
- 정적 시각: `APPROVED_PLANNING_VISUALIZATION`
- 플레이테스트 설계: `APPROVED_TEST_DESIGN`
- 제품 구현: `NOT_AUTHORIZED`
- Runtime·사람 검증: `NOT_RUN`

## 4. 운영 책임 원본

| 책임 | 원본 |
|---|---|
| 강제 규칙 | `../AGENTS.md` |
| 콜드 스타트 | `../START_HERE.md` |
| 현재 승인 Decision | `CURRENT_CONFIRMED_DECISIONS.md` |
| Validation 상세 Target | `VALIDATION_TARGET_CANON.md` |
| 실제 구현·검증 상태 | `CURRENT_STATUS.md` |
| 장기 제품 코어 | `PROJECT_CORE.md` |
| 장기 상세 GDD·Legacy | `GAME_DESIGN_DOCUMENT.md` |
| 현재 문서 라우터 | `DOCUMENTATION_MAP_CURRENT.md` |
| Legacy 문서 라우터 | `DOCUMENTATION_MAP.md` |
| Base 채택 | `BASE_RULES_VERSION.md` |
| Work Mode·Skill | `WORK_MODE_AND_SKILL_ROUTING.md` |
| Skill Registry | `../skills/SKILL_REGISTRY.json` |
| 검증 계약 | `../TEST_CHECKLIST.md` |
| 문서 보존 | `DOCUMENT_LIFECYCLE.md` |

## 5. Validation 책임 원본

| 주제 | 원본 |
|---|---|
| 전체 Target | `VALIDATION_TARGET_CANON.md` |
| 최종 승인 | `decisions/D-2026-08-01-VALIDATION-PLANNING-FINAL-APPROVAL.md` |
| 화면·상황 A~G | `decisions/D-2026-08-01-VALIDATION-SCREEN-SIT-PACKAGE.md` |
| 상세 SCREEN/SIT | `superpowers/specs/2026-08-01-validation-screen-situation-design.md` |
| 텍스트 노벨 | `decisions/D-2026-07-31-TEXT-NOVEL-CORE-PRESENTATION.md` |
| 비주얼 방향 | `visual/VISUAL_ART_DIRECTION.md` |
| 시간순 증거 | `decisions/D-2026-07-31-AFTERLIFE-TIMELINE-EVIDENCE.md` |
| 회수 2패턴 | `decisions/D-2026-07-31-AFTERLIFE-RECOVERY-PATTERNS.md` |
| 결과 4축 | `decisions/D-2026-08-01-VALIDATION-RESULT-AXES.md` |
| 저장·테스트 | `decisions/D-2026-08-01-VALIDATION-SAVE-TEST-MIGRATION.md` |
| 범위 필터 | `decisions/D-2026-08-01-VALIDATION-SCOPE-FILTER.md` |
| 시각 검수 | `visual/UL_IMG_007_VISUAL_REVIEW_2026-08-01.md` |
| 플레이테스트 | `validation/VALIDATION_SCREEN_SIT_PLAYTEST_PACKAGE_2026-08-01.md` |
| 최종 적대적 검토 | `planning/VALIDATION_PLANNING_FINAL_ADVERSARIAL_REVIEW_2026-08-01.md` |
| Canon 이관 | `planning/CANON_MIGRATION_BUNDLE_2026-08-01.md` |

## 6. 장기 제품·Legacy

장기 제품에서 계속 유효:

- 권나래 고정 성장형 주인공
- 1년·4분기 방향
- 조사→가설→검증→회수→매뉴얼 인과
- 관측 가능한 공정 정보
- 동료·장비·연구의 정답 비대체
- 실패 전진·연도 결산

현재 구현·회귀 증거:

- CORE-MVP-001
- ANNUAL-MVP-001/002
- 기존 `mvp-039`
- 기존 preparation/investigation/battle/result/market Scene
- 기존 focused·full regression·visual QA

현재 Validation과 충돌하는 시간·화면·회수·결과·저장 흐름은 `VALIDATION_TARGET_CANON.md`가 우선한다.

Legacy를 삭제하지 않고 구현 baseline·회귀·롤백 근거로 사용한다.

## 7. 프로젝트 분야 라우팅

| 조건 | 프로젝트 Skill | 추가 원본 |
|---|---|---|
| 사건·전조·가설·근거·대응 | `urban-legend-investigation-case-authoring` | Target Canon·사건 데이터 |
| 대사·관계·결산 | `urban-legend-narrative` | 서사 기획·PROJECT_CONTEXT |
| 조사·회수·일정·밸런스 | `urban-legend-game-design` | Target Canon·GDD |
| UI·입력·접근성 | `urban-legend-ux-ui-accessibility` | Target Canon·UI 문서 |
| Godot·저장·Scene·데이터 | `urban-legend-engineering` | Target Canon·실제 코드·테스트 |
| 에셋 import·Manifest | `urban-legend-technical-art-pipeline` | IMAGE_ASSET_WORKFLOW |
| 캐릭터·배경·UI 아트 | `urban-legend-art` | VISUAL_ART_DIRECTION |
| 오디오 | `urban-legend-audio` | Target Canon·GDD |
| QA·release gate | `urban-legend-qa` | Playtest Package·TEST_CHECKLIST |
| Roadmap·Issue·PR·Handoff | `urban-legend-production-pm` | Current Decisions·Target Canon |
| 플레이테스트·텔레메트리 | `urban-legend-analytics-user-research` | Playtest Package·결과 로그 |

## 8. 구현 진입 Gate

```text
Canon Pass 검증
→ writing-plans
→ 최신 main·실제 Godot 파일 읽기 전용 Codex Plan
→ 기술 개선·CHANGE_PROPOSAL 검수
→ 패키지별 승인
→ Codex Build
```

현재 제품 구현 진입은 `BLOCKED`다.

## 9. 조건부 문서

- 서사: `planning/NARRATIVE_CONTENT_PLAN.md`, `DIALOGUE_AUTHORING_WORKFLOW.md`
- 아트: `planning/ART_PRESENTATION_PLAN.md`, `IMAGE_ASSET_WORKFLOW.md`
- UI: `GODOT_NATIVE_UI_ARCHITECTURE.md`
- 기존 회수 UI: `CINEMATIC_FIELD_RECOVERY_UI.md` — Legacy 비교용
- 미니게임: `MINIGAME_SYSTEM_SPEC.md`
- 외부 모델: `AI_DELEGATION_WORKFLOW.md`
- 외부 비교: `BENCHMARKING_REFERENCE_GUIDE.md`
- 교대: `CURRENT_HANDOFF.md`, `CODEX_ACCOUNT_HANDOFF.md`
- 과거 근거: `archive/README.md`에서 필요한 파일만 선택

## 10. 기본 읽기 제외

- `archive/**`
- 완료된 `qa/**`
- 완료된 `CODEX_GOAL_*`
- 과거 `benchmarks/**`
- 비활성 `superpowers/**`
- 과거 일회성 보고서
- Base 전체 Skill 폴더

현재 Target에 직접 연결된 Decision·Spec·Review·Playtest는 예외다.

## 11. 승인 동기화

```text
CURRENT_CONFIRMED_DECISIONS
→ VALIDATION_TARGET_CANON 또는 분야 정본
→ 계획·검증 소비처
→ GitHub 추적 surface
→ Google Sheet 관련 탭
→ 02_현재_확정결정
→ 99_변경이력
→ Commit·범위 재조회
```

실행하지 않은 Runtime·기기·사람 검증은 `NOT_RUN`으로 유지한다.
