# Base 동기화 및 PR 감사 — 2026-07-21

## 감사 기준

- Base: `alsdmlals4-eng/Base@ee265576da7f67d3278f8099dd97d4e714ef0651`
- 대상: `alsdmlals4-eng/urban-legend`
- 프로젝트 기준선: `main@dd3c9a8776eb938eeeeb2f1319af6bfc4a135202`
- 적용 방식: 기존 프로젝트 `audit → reconcile-legacy → 승인 범위 BUILD → verify`
- 변경 정책: 현행 책임 원본과 게임 파일을 제자리에 유지하는 비파괴 동기화

## 사용자 요청 해석

`Base를 전부 자세하게 읽는다`는 Base의 최상위 라우터, 운영 모델, Work Mode·Skill 라우팅, Documentation Map, Registry, 적용 Skill과 검증 계약을 통해 누락 없이 책임을 추적한다는 뜻이다. 모든 Base 파일과 Skill을 프로젝트에 복사하거나 기존 프로젝트 구조를 신규 설치형으로 덮는 뜻이 아니다.

## Base에서 반영한 핵심

- `PLAN / BUILD / REVIEW` Work Mode
- trigger 기반 최소 Skill·Skill Mode 자동 선택
- L1 이상 Skill 실행 이유·수행·결과·미검증 보고
- 최신 활성 Base Skill 13개와 통합 전 ID 별칭
- 기존 프로젝트의 `audit / reconcile-legacy / migrate / verify`
- 구형 파일 판정 7종
- 정본·경로·ID·Schema 변경의 reference-freshness 감사
- 실행하지 않은 검사·권한·사람 QA를 통과로 보고하지 않는 증거 계약

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
| `docs/DOCUMENTATION_MAP.md` | `UPDATE_IN_PLACE` | 운영 모델·라우팅·Registry 조건부 경로 추가 |
| `docs/BASE_RULES_VERSION.md` | `UPDATE_IN_PLACE` | 기준을 `ee265576...`로 갱신하고 비파괴 정책 기록 |
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
| 구형 Skill ID 비활성화 | `PASS` | Registry·alias 대조 |
| 기존 책임 원본 경로 보존 | `PASS` | canonical path 존재 검사 |
| 프로젝트 불변 용어·보호 경로 보존 | `PASS` | `AGENTS.md` 계약 검사 |
| 변경 파일 범위 | `PASS` | PR #46 changed files 18개, 게임 코드·데이터·Scene·자산 0건 |
| 삭제·rename | `PASS` | 삭제 0건, rename 0건 |
| GitHub Actions | `PASS` | `Validate Base operating sync` run `29836276846`, job `88653320745` |
| Godot headless | `NOT_RUN` | 게임 런타임 파일 미변경 |
| 수동 플레이·화면 QA | `NOT_RUN` | 플레이어 화면 변경 없음 |

## 병합 전 PR 체크

- [x] PR #41~#43에 `DO_NOT_MERGE` 근거를 게시하고 비파괴 대체 PR #46을 생성했다.
- [x] 변경 파일에 `project.godot`, `scripts/**`, `data/**`, `scenes/**`, `assets/**`가 없다.
- [x] 삭제·rename이 없다.
- [x] 자동 검증이 통과한다.
- [x] Base commit이 모든 진입점·Registry에서 일치한다.
- [x] 최신 Base Skill 13개가 정확히 등록되고 구형 Foundation ID가 활성 목록에 없다.
- [x] `AGENTS.md`의 프로젝트 불변 조건과 보호 경로가 유지된다.
- [x] 기존 책임 원본 8개 경로가 그대로 존재한다.
- [x] 미실행 Godot·수동 QA를 `NOT_RUN`으로 남겼다.

## 최종 판정

PR #46의 비파괴 동기화 범위는 `PASS`. 게임 런타임과 플레이어 화면은 변경하지 않았으므로 Godot·수동 QA는 범위 외 `NOT_RUN`이며, 이를 통과로 간주하지 않는다. PR #41~#43은 차단 상태를 유지한다.
