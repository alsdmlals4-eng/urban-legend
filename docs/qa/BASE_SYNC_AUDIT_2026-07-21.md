# Base·Skill 구조 동기화 및 PR 감사 — 2026-07-21

## 감사 기준

- Base: `alsdmlals4-eng/Base@ee265576da7f67d3278f8099dd97d4e714ef0651`
- Base Registry blob: `2291bce0d139905f8b8b6721ffbc9859774dcb06`
- 대상: `alsdmlals4-eng/urban-legend`
- 프로젝트 기준선: `main@dd3c9a8776eb938eeeeb2f1319af6bfc4a135202`
- 적용 방식: `PLAN → BUILD → REVIEW`
- 사용 Skill:
  - `managing-game-project-operating-system: audit/reconcile-legacy/verify`
  - `evolving-project-discipline-skills: inventory/consolidation/health-review`
  - `reviewing-and-validating-project-changes: contract-check/static-validation/regression/evidence-report`
  - `auditing-canonical-reference-freshness: impact-map/reference-scan/content-drift/propagation-gap/closure-report`
- 변경 정책: 현행 책임 원본과 게임 파일을 제자리에 유지하는 비파괴 동기화

## 사용자 요청 해석

`Base를 전부 자세하게 읽는다`는 Base의 활성 운영 책임을 누락 없이 추적하고, 프로젝트에서 실제로 선택·실행·검증 가능한 구조로 연결한다는 뜻이다. 이번 감사에서는 다음을 대조했다.

- Base 최상위 `START_HERE`·`AGENTS`
- 운영 모델, Work Mode·Skill 라우팅, Documentation Map
- Base Skill Registry와 Legacy Alias
- 최신 Active Skill 13개 전문
- Skill 패키지 무결성 테스트
- Design Document Registry 템플릿·Schema
- urban-legend의 Registry·경로 어댑터·책임 원본·실제 Skill 패키지·CI

과거 이력·백업·비활성 후보·바이너리를 무조건 복제하거나 기존 프로젝트 구조를 신규 설치형으로 덮는 뜻은 아니다.

## 전문 대조한 Base Active Skill 13개

1. `managing-project-intake-and-work-contract`
2. `managing-game-project-operating-system`
3. `evolving-project-discipline-skills`
4. `managing-design-documents`
5. `maintaining-project-context-and-handoff`
6. `analyzing-and-refining-game-concepts`
7. `designing-vertical-slices`
8. `orchestrating-deepseek-worktrees`
9. `reviewing-and-validating-project-changes`
10. `auditing-canonical-reference-freshness`
11. `designing-art-prompts-and-technique-cards`
12. `auditing-and-refining-ui-art`
13. `managing-base-change-proposals`

각 Skill의 trigger, use/do-not-use, mode, required input, read-first, Definition of Done, failure condition, review trigger, knowledge state와 legacy mapping을 대조했다.

## 2차 Skill Health Review에서 발견한 결함

### F1. Base trigger 축약 복사 — HIGH

기존 PR #46 Registry는 Base Skill ID 13개는 맞았지만 일부 trigger를 축약했다.

예:

- Intake의 `material-ambiguity`, `acceptance-criteria`, `dependency-map` 등 누락
- Concept 분석의 `competitor-analysis`, `telemetry-events`, `funnel-analysis`, `ab-testing` 등 누락
- Vertical Slice의 `external-playtest`, `accessibility-target`, `performance-budget` 누락
- 통합 검증의 `external-ai-result`, `input-barrier`, `target-platform`, `frame-time`, `memory-budget` 누락
- 참조 감사의 `document-id-change`, `generator-change` 누락

영향: 요청이 해당 의미를 포함해도 자동 라우팅이 Skill을 선택하지 못할 수 있었다.

처리:

- Base Registry blob을 기록했다.
- 13개 Skill의 trigger·비사용 조건·review trigger·last reviewed·knowledge state를 원본과 일치시켰다.
- `tests/test_skill_package_integrity.py`가 trigger exact-set을 검사한다.

판정: `FIXED / PASS`.

### F2. 프로젝트 분야 Skill 실행 파일 누락 — BLOCKER

기존 PR #46의 프로젝트 분야 11개는 Registry 항목과 책임 원본만 있고 실제 `SKILL.md`가 없었다. 따라서 이름은 등록됐지만 다음이 없었다.

- 실제 사용·비사용 조건
- Skill Mode
- Required inputs·read-first
- Workflow
- Definition of Ready·Done
- 검증·실패 조건

영향: 프로젝트 분야 Skill이 실행 단위가 아니라 라우팅 라벨에 불과했다.

처리:

- `skills/disciplines/<skill-id>/SKILL.md` 실행 패키지를 추가했다.
- Registry `path`와 실제 패키지를 1:1로 연결했다.
- 각 Skill에 고유 판단·입력·절차·DoR·DoD·검증·실패 조건을 작성했다.
- Base 공용 검증·라우팅 절차는 복제하지 않고 관련 Base Skill로 연결했다.

판정: `FIXED / PASS`.

### F3. `urban-legend-integration-review` 책임 중복 — MEDIUM

해당 항목은 `CURRENT_STATUS.md`와 `DOCUMENTATION_MAP.md`만 입력으로 사용하며 고유 산출물·Quality Bar·독립 검증이 없었다. 다음 Base 책임과 중복됐다.

- `reviewing-and-validating-project-changes`
- `managing-game-project-operating-system: verify`

처리:

- 활성 프로젝트 Skill에서 제거했다.
- Base 통합검수·운영체계 verify mode로 통합했다.
- `skills/LEGACY_SKILL_ALIASES.md`에 호환 경로를 추가했다.
- 프로젝트 분야 Skill은 11개 라벨에서 10개 실행 패키지로 최적화됐다.

판정: `CONSOLIDATED / PASS`.

### F4. 프로젝트 trigger 과도한 범용성·중복 위험 — MEDIUM

기존 `ui`, `test`, `issue`, `handoff`, `game-design` 같은 넓은 tag는 여러 분야·Base Skill을 동시에 선택할 위험이 있었다.

처리:

- `dialogue-authoring`, `campaign-rule-design`, `ui-information-architecture`, `save-system-change`, `qa-plan`, `production-handoff`처럼 고유 책임을 나타내는 tag로 구체화했다.
- 프로젝트 분야 간 완전 중복 trigger를 금지했다.
- Registry에 대표 routing example 11개를 추가했다.
- 자동검사가 주 프로젝트 Skill 최대 1개·지원 Skill 최대 3개를 검증한다.

판정: `OPTIMIZED / PASS`.

### F5. Skill 패키지 검사가 CI에 미연결 — HIGH

초기 PR #46은 Base commit·ID·경로만 검사했고, 실제 프로젝트 `SKILL.md`의 존재·identity·참조·trigger 중복·routing 결과를 검사하지 않았다.

처리:

- `tests/test_skill_package_integrity.py`를 추가했다.
- `.github/workflows/validate-base-operating-sync.yml`이 두 테스트 파일을 모두 실행하도록 연결했다.
- Workflow path filter에 새 테스트를 포함했다.

판정: `FIXED / PASS`.

### F6. 콜드 스타트가 Registry에서 멈춤 — MEDIUM

초기 진입 문서는 Registry 선택까지 안내했지만, 선택된 실제 `SKILL.md`를 읽는 단계를 명시하지 않았다.

처리:

- `START_HERE.md`, `AGENTS.md`, `README.md`, `OPERATING_MODEL.md`, `WORK_MODE_AND_SKILL_ROUTING.md`, `DOCUMENTATION_MAP.md`에 실제 Skill 전문 로드 단계를 추가했다.
- Registry 항목만 읽고 Skill 실행 완료로 보고하지 못하게 했다.

판정: `FIXED / PASS`.

### F7. 경로 어댑터에 프로젝트 Skill root 누락 — LOW

처리:

- `project_discipline_skill_root: skills/disciplines` 역할 binding을 추가했다.
- 숫자 discipline 폴더 대신 Registry `skill_id`와 동일한 디렉터리명을 사용하도록 override를 기록했다.
- 경로·패키지 1:1 검사를 단순화했다.

판정: `FIXED / PASS`.

## 최종 활성 Skill 구조

### Base

- 활성 13개
- 원격 고정 커밋 전문 참조
- 자동 라우팅 메타데이터는 source blob과 일치하는 로컬 스냅샷
- 전체 기본 로드 금지

### 프로젝트 분야

1. `urban-legend-narrative`
2. `urban-legend-game-design`
3. `urban-legend-ux-ui-accessibility`
4. `urban-legend-engineering`
5. `urban-legend-technical-art-pipeline`
6. `urban-legend-art`
7. `urban-legend-audio`
8. `urban-legend-qa`
9. `urban-legend-production-pm`
10. `urban-legend-analytics-user-research`

각 항목은 Registry와 실제 `SKILL.md`가 1:1이다.

### 통합·호환

```text
urban-legend-integration-review
→ reviewing-and-validating-project-changes
→ managing-game-project-operating-system: verify
```

통합 전 Foundation ID와 위 프로젝트 ID는 Legacy Alias에서만 유지한다.

## 프로젝트 경로·발행 어댑터 판정

| Base 역할·예시 | urban-legend 실제 경로 |
|---|---|
| Project Start Here | `START_HERE.md` |
| Active Context | `docs/CURRENT_STATUS.md` |
| Documentation Map | `docs/DOCUMENTATION_MAP.md` |
| Skill Registry | `skills/SKILL_REGISTRY.json` |
| Project discipline Skill root | `skills/disciplines/` |
| Design Document Registry 상당 책임 | `docs/DOCUMENTATION_MAP.md` + `skills/SKILL_REGISTRY.json` |
| Handoff | `docs/CURRENT_HANDOFF.md` |
| Roadmap | `MVP_ROADMAP.md` |
| Validation Contract | `TEST_CHECKLIST.md` |
| GDD source | `docs/GAME_DESIGN_DOCUMENT.md` |
| GDD derivative | `docs/URBAN_LEGEND_GAME_DESIGN.docx` |
| GDD generator | `tools/docs/build_game_design_doc.py` |

Base Design Document Registry v3의 `milestone_sync/always_sync`는 PDF와 Publication Manifest를 요구한다. 현재 프로젝트의 검증된 DOCX 파이프라인을 이번 운영 동기화에서 교체하면 새 발행 범위와 미생성 산출물이 생기므로 `DEFERRED_REQUIRES_SEPARATE_APPROVAL`로 유지한다.

## 기존 PR 스택 감사

### PR #41 — `FAIL / DO_NOT_MERGE`

- 승인 없는 수백 개 문서·QA·자산 경로 이동
- 루트 `AGENTS.md` 123줄→7줄 축약
- 현행 읽기 경로·보호 계약·불변 용어 유실

단, PR #41에 있던 프로젝트 분야 Skill 아이디어는 대규모 이동과 분리해 현행 경로 기반 실행 패키지로 재작성·승계했다. 이전 `[기획서]/...` 의존과 migration 전용 검증 명령은 승계하지 않았다.

### PR #42 — `FAIL / DO_NOT_MERGE`

- PR #41 위험 상속
- `default_selection: none`
- 구형 Foundation Skill ID 활성화

### PR #43 — `FAIL / DO_NOT_MERGE`

- 차단된 #41·#42 구조를 PDF·Manifest로 발행
- stale 구조를 사람용 정본으로 강화

각 PR에 차단 댓글과 대체 PR #46 경로를 게시했다.

## 비파괴 처리표

| 대상 | 상태 | 처리 |
|---|---|---|
| `AGENTS.md`, `README.md`, 운영 문서 | `UPDATE_IN_PLACE` | 현행 규칙을 유지하며 실제 Skill 실행 경로 추가 |
| `skills/SKILL_REGISTRY.json` | `UPDATE_IN_PLACE` | Base 원본 메타데이터 복원·프로젝트 10개 실행 Skill 등록 |
| `skills/disciplines/*/SKILL.md` | `NEW` | 프로젝트 분야 실행 계약 10개 |
| `urban-legend-integration-review` | `MERGE_TO_CANONICAL` | Base 검수·verify로 통합, Alias 유지 |
| `skills/PROJECT_PATH_ADAPTER.json` | `UPDATE_IN_PLACE` | 프로젝트 Skill root·두 테스트 연결 |
| `tests/test_skill_package_integrity.py` | `NEW` | 패키지·trigger·routing·alias 무결성 검사 |
| `docs/AI_SHARED_WORK_RULES.md` | `COMPATIBILITY_STUB` + 원문 보존 | 최신 운영 모델로 연결하고 고유 절차 유지 |
| `docs/AI_WORKFLOW_RULES.md` | `COMPATIBILITY_STUB` + 프로젝트 확장 보존 | 최신 라우팅과 외부 위임·Goal 절차 연결 |
| 기존 `docs/planning/**`, GDD, Roadmap, Test | `CURRENT` | 경로·내용 유지 |
| 프로젝트 게임 코드·데이터·Scene·자산 | `CURRENT` | 변경 제외 |
| Base Skill 전문 | 원격 `CURRENT` 참조 | 전체 복제 안 함 |

## 자동 검증 범위

`tests/test_base_operating_sync.py`

- Base commit·경로 어댑터·책임 원본·보호 계약
- GDD 발행 호환
- 프로젝트 Skill 수·패키지 존재
- 통합 Alias

`tests/test_skill_package_integrity.py`

- Base Registry blob과 13개 trigger exact-set
- Base 메타데이터 필수 필드
- 프로젝트 Registry와 실제 Skill 패키지 1:1
- front matter name·description·directory identity
- 책임 원본과 로컬 참조 존재
- 프로젝트 trigger 완전 중복 없음
- 대표 routing example의 primary/support 결과
- 통합 Skill의 orphan·Alias 여부
- 선택적 로드 상한과 진입점 연결

## 검증 매트릭스

| 영역 | 상태 | 증거 |
|---|---|---|
| Base 기준 커밋·Registry blob | `PASS` | 두 unittest |
| Base 13개 Skill ID·trigger 완전성 | `PASS` | exact-set 검사 |
| 프로젝트 실행 Skill 10개 | `PASS` | Registry↔패키지 1:1 검사 |
| Skill identity·책임 원본·로컬 참조 | `PASS` | 패키지 무결성 검사 |
| 프로젝트 trigger 중복 | `PASS` | duplicate owner 검사 |
| 대표 자동 라우팅 | `PASS` | routing example 11개 |
| 통합 Skill Alias | `PASS` | consolidation·Alias 검사 |
| Base 역할→프로젝트 경로 binding | `PASS` | adapter role·override 검사 |
| GDD 발행 호환·별도 승인 게이트 | `PASS` | Markdown·DOCX·generator·`--check` 계약 |
| 프로젝트 불변 용어·보호 경로 | `PASS` | `AGENTS.md` 계약 검사 |
| GitHub Actions | `PASS` 조건 | PR 현재 head에서 `Validate Base operating and Skill package contracts` 성공 필수 |
| Godot headless | `NOT_RUN` | 게임 런타임 파일 미변경 |
| 수동 플레이·화면 QA | `NOT_RUN` | 플레이어 화면 변경 없음 |

## 병합 전 체크

- [x] Base 13개 Skill 메타데이터를 원본 Registry와 일치시켰다.
- [x] 프로젝트 분야 Skill은 실제 실행 패키지 10개만 활성화했다.
- [x] 책임 중복 Skill을 통합하고 Alias를 남겼다.
- [x] 프로젝트 trigger 완전 중복이 없다.
- [x] 대표 routing example이 주 Skill 최대 1개·지원 Skill 최대 3개를 만족한다.
- [x] 진입점이 Registry 이후 실제 Skill 전문을 읽는다.
- [x] 두 무결성 테스트가 CI에 연결됐다.
- [x] 기존 책임 원본·보호 경로·게임 파일은 유지된다.
- [x] 기존 GDD 발행 계약을 별도 승인 없이 교체하지 않았다.
- [x] PR #41~#43 차단 상태를 유지한다.
- [x] Godot·수동 QA 미실행을 `NOT_RUN`으로 남긴다.

## 최종 판정

2차 Health Review에서 실질 누락 4건과 구조·검증 최적화 항목 3건을 발견해 수정했다. 현재 구조는 **Base 13개 + 프로젝트 실행 Skill 10개 + 통합 Alias 1개**이며, Registry·실제 패키지·경로 어댑터·진입점·자동 routing·CI가 연결돼 있다.

Skill·운영 구조 범위 판정은 `PASS`. 게임 런타임과 플레이어 화면은 변경하지 않았으므로 Godot·수동 QA는 `NOT_RUN`이며 이를 통과로 간주하지 않는다. PR #41~#43은 차단 상태를 유지한다.
