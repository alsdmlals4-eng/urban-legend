# Base 동기화 및 PR 감사 — 2026-07-21

## 감사 기준

- Base: `alsdmlals4-eng/Base@ee265576da7f67d3278f8099dd97d4e714ef0651`
- 대상: `alsdmlals4-eng/urban-legend`
- 프로젝트 기준선: `main@dd3c9a8776eb938eeeeb2f1319af6bfc4a135202`
- 적용 방식: 기존 프로젝트 `audit → reconcile-legacy → 승인 범위 BUILD → verify`
- 변경 정책: 현행 책임 원본과 게임 파일을 제자리에 유지하는 비파괴 동기화

## 사용자 요청 해석

`Base를 전부 자세하게 읽는다`는 Base의 활성 운영 책임을 누락 없이 추적한다는 뜻이다. 이번 감사에서는 최상위 `START_HERE`·`AGENTS`, 운영 모델, Work Mode·Skill 라우팅, Documentation Map, Skill Registry, Legacy Alias, 최신 Active Skill 13개 전문과 적용에 필요한 Design Document Registry 템플릿·Schema까지 대조했다. 과거 이력·백업·비활성 후보·바이너리를 무조건 복제하거나 기존 프로젝트 구조를 신규 설치형으로 덮는 뜻은 아니다.

## 전문 대조한 Active Skill 13개

1. `managing-project-intake-and-work-contract`
2. `managing-game-project-operating-system`
3. `managing-design-documents`
4. `evolving-project-discipline-skills`
5. `maintaining-project-context-and-handoff`
6. `analyzing-and-refining-game-concepts`
7. `designing-vertical-slices`
8. `orchestrating-deepseek-worktrees`
9. `reviewing-and-validating-project-changes`
10. `auditing-canonical-reference-freshness`
11. `designing-art-prompts-and-technique-cards`
12. `auditing-and-refining-ui-art`
13. `managing-base-change-proposals`

각 Skill의 trigger, mode, required input, read-first, Definition of Done, failure condition, legacy mapping을 Registry와 프로젝트 운영 문서에 교차 대조했다.

## Base에서 반영한 핵심

- `PLAN / BUILD / REVIEW` Work Mode
- trigger 기반 최소 Skill·Skill Mode 자동 선택
- L1 이상 Skill 실행 이유·수행·결과·미검증 보고
- 최신 활성 Base Skill 13개와 통합 전 ID 별칭
- 기존 프로젝트의 `audit / reconcile-legacy / migrate / verify`
- 구형 파일 판정 7종
- 정본·경로·ID·Schema 변경의 reference-freshness 감사
- 실행하지 않은 검사·권한·사람 QA를 통과로 보고하지 않는 증거 계약
- Base 예시 경로를 프로젝트 실제 경로로 변환하는 `skills/PROJECT_PATH_ADAPTER.json`
- 기존 Markdown GDD→검증된 DOCX 파생본 계약을 별도 승인 없이 PDF·Manifest 체계로 교체하지 않는 발행 호환 계약

## 프로젝트 경로·발행 어댑터 판정

Base 일부 Skill의 `[기획서]/00_프로젝트_허브/...` 경로는 설치 예시이며 `urban-legend`의 현행 정본이 아니다.

| Base 역할·예시 | urban-legend 실제 경로 |
|---|---|
| Project Start Here | `START_HERE.md` |
| Active Context | `docs/CURRENT_STATUS.md` |
| Documentation Map | `docs/DOCUMENTATION_MAP.md` |
| Design Document Registry 상당 책임 | `docs/DOCUMENTATION_MAP.md` + `skills/SKILL_REGISTRY.json` |
| Handoff | `docs/CURRENT_HANDOFF.md` |
| Roadmap | `MVP_ROADMAP.md` |
| Validation Contract | `TEST_CHECKLIST.md` |
| GDD source | `docs/GAME_DESIGN_DOCUMENT.md` |
| GDD derivative | `docs/URBAN_LEGEND_GAME_DESIGN.docx` |
| GDD generator | `tools/docs/build_game_design_doc.py` |

Base Design Document Registry v3의 `milestone_sync/always_sync`는 PDF와 Publication Manifest를 요구한다. 현재 프로젝트의 검증된 DOCX 파이프라인을 이번 운영 동기화에서 교체하면 새 발행 범위와 미생성 산출물이 생기므로 `DEFERRED_REQUIRES_SEPARATE_APPROVAL`로 판정했다.

## 기존 PR 스택 감사

### PR #41 — BLOCKER

- 승인 인터뷰는 현행 책임 원본 보호와 승인 없는 대규모 이동 제외를 명시한다.
- 실제 diff는 수백 개 문서·QA·자산 경로를 `[기획서]` 아래로 이동하고 루트 `AGENTS.md`를 123줄에서 7줄로 축약한다.
- 프로젝트의 현재 읽기 경로, 보호 계약, 조건부 문서, 불변 용어가 기본 진입점에서 사라진다.
- 최신 Base는 기존 프로젝트에 신규 설치형 구조를 강제하거나 승인 전 대량 이동·통합하는 것을 실패 조건으로 둔다.
- 판정: `FAIL / DO_NOT_MERGE`. 차단 댓글 게시 완료.

### PR #42 — BLOCKER

- PR #41에 종속되어 동일한 경로 이동 위험을 상속한다.
- 활성 Registry가 `default_selection: none`이며 자동 Skill 선택·Work Mode·실행 보고 계약이 없다.
- `routing-project-work-by-discipline`, `conducting-deep-requirement-interviews`, `migrating-existing-game-project-structure`, `publishing-discipline-bibles`, `verifying-game-project-operating-system` 등 최신 Base에서 통합된 구형 Foundation ID를 활성 등록한다.
- 판정: `FAIL / REPLACE_WITH_CURRENT_SKILL_IDS`. 차단 댓글 게시 완료.

### PR #43 — BLOCKER

- PR #41과 #42를 base로 하므로 두 차단 사유가 해결되지 않은 상태에서 발행본·Health Review를 생성한다.
- stale 구조를 PDF·Manifest로 발행하면 잘못된 정본을 강화한다.
- 판정: `FAIL / REBUILD_AFTER_NON_DESTRUCTIVE_SYNC`. 차단 댓글 게시 완료.

## 이번 비파괴 처리표

| 대상 | 상태 | 처리 |
|---|---|---|
| `AGENTS.md` | `UPDATE_IN_PLACE` | 프로젝트 규칙 전문을 유지하고 Base 라우팅만 추가 |
| `README.md` | `UPDATE_IN_PLACE` | 새 `START_HERE.md`와 운영 문서 연결 |
| `docs/CURRENT_STATUS.md` | `UPDATE_IN_PLACE` | Base 동기화 상태를 구현 상태와 분리해 기록 |
| `docs/DOCUMENTATION_MAP.md` | `UPDATE_IN_PLACE` | 운영 모델·라우팅·Registry·경로 어댑터 추가 |
| `docs/BASE_RULES_VERSION.md` | `UPDATE_IN_PLACE` | 기준 커밋·전문 대조 범위·발행 호환 기록 |
| `skills/PROJECT_PATH_ADAPTER.json` | `NEW` | Base 역할·예시 경로를 프로젝트 실제 경로에 binding |
| `docs/AI_SHARED_WORK_RULES.md` | `COMPATIBILITY_STUB` + 원문 보존 | 최신 운영 모델로 연결하고 기존 고유 절차 전문 유지 |
| `docs/AI_WORKFLOW_RULES.md` | `COMPATIBILITY_STUB` + 프로젝트 확장 보존 | 최신 라우팅을 연결하고 외부 위임·Goal·벤치마킹 절차 유지 |
| 기존 `docs/planning/**`, GDD, Roadmap, Test | `CURRENT` | 경로·내용 유지 |
| 프로젝트 게임 코드·데이터·Scene·자산 | `CURRENT` | 변경 제외 |
| 통합 전 Foundation ID | `MERGE_TO_CANONICAL` | 활성 Registry 제외, `LEGACY_SKILL_ALIASES.md`로 변환 |
| Base Skill 전문 | 원격 `CURRENT` 참조 | 고정 커밋으로 참조, 전체 복제 안 함 |

## 검증 매트릭스

| 영역 | 상태 | 증거 |
|---|---|---|
| Base 기준 커밋 일치 | `PASS` | `tests/test_base_operating_sync.py` |
| 최신 13개 Skill 완전성 | `PASS` | Registry exact-set 검사 |
| 13개 Active Skill 전문 대조 | `PASS` | trigger·mode·input·DoD·failure·alias 수동 교차감사 |
| 구형 Skill ID 비활성화 | `PASS` | Registry·alias 대조 |
| Base 역할→프로젝트 경로 binding | `PASS` | `PROJECT_PATH_ADAPTER.json` role·override 경로 존재 검사 |
| GDD 발행 호환·별도 승인 게이트 | `PASS` | Markdown·DOCX·generator 존재와 `--check` 계약 검사 |
| 기존 책임 원본 경로 보존 | `PASS` | canonical path 존재 검사 |
| 프로젝트 불변 용어·보호 경로 보존 | `PASS` | `AGENTS.md` 계약 검사 |
| 변경 파일 범위 | `PASS` | PR #46 changed files 19개, 게임 코드·데이터·Scene·자산 0건 |
| 삭제·rename | `PASS` | 삭제 0건, rename 0건 |
| GitHub Actions | `PASS` | PR의 현재 head에서 `Validate Base operating sync`와 `Validate pinned Base operating contract` 성공 필수 |
| Godot headless | `NOT_RUN` | 게임 런타임 파일 미변경 |
| 수동 플레이·화면 QA | `NOT_RUN` | 플레이어 화면 변경 없음 |

## 병합 전 PR 체크

- [x] PR #41~#43에 `DO_NOT_MERGE` 근거를 게시하고 비파괴 대체 PR #46을 생성했다.
- [x] 변경 파일에 `project.godot`, `scripts/**`, `data/**`, `scenes/**`, `assets/**`가 없다.
- [x] 삭제·rename이 없다.
- [x] 자동 검증이 통과한다.
- [x] Base commit이 모든 진입점·Registry·경로 어댑터에서 일치한다.
- [x] 최신 Base Skill 13개가 정확히 등록되고 구형 Foundation ID가 활성 목록에 없다.
- [x] Base 예시 경로가 프로젝트 현행 경로보다 우선하지 않는다.
- [x] 기존 GDD 발행 계약이 별도 승인 없이 교체되지 않는다.
- [x] `AGENTS.md`의 프로젝트 불변 조건과 보호 경로가 유지된다.
- [x] 기존 책임 원본 경로가 그대로 존재한다.
- [x] 미실행 Godot·수동 QA를 `NOT_RUN`으로 남겼다.

## 최종 판정

PR #46의 비파괴 동기화 범위는 `PASS`. Base 활성 운영 정본과 Active Skill 13개 전문의 실행 계약을 프로젝트 현행 경로에 연결했고, 자동 회귀가 통과했다. 게임 런타임과 플레이어 화면은 변경하지 않았으므로 Godot·수동 QA는 범위 외 `NOT_RUN`이며 이를 통과로 간주하지 않는다. PR #41~#43은 차단 상태를 유지한다.
