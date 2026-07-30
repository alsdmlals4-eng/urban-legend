# Vertical Slice v9 Project Application — 괴이기록국(urban-legend)

## Role

이 문서는 Base `VERTICAL_SLICE_INTEGRATED_EXECUTION_PROMPT_v9.md`를 괴이기록국 저장소에 연결하는 얇은 프로젝트 바인딩이다. 공용 실행 계약을 복제하지 않으며 프로젝트 경로, 보호 경계, 플랫폼, 로컬 Skill, Sheet와 현재 Gate만 정의한다.

## Application Binding

| Item | Binding |
|---|---|
| Project | `괴이기록국(urban-legend)` |
| Repository | `alsdmlals4-eng/urban-legend` |
| Main baseline | `656846865eb88871d00842a0da527ce1b0722b77` |
| Base version | `9.3.0` target |
| Base release | `30ca6c7b5f93521f0eb0eed42d01437cd43c50ae` |
| Base evidence | `462a86db192d23d0f386281a1eb54b0a8cbad62e` |
| Base Registry hash | `9847bb2b225c776ad7916930f0f48c490bc2a898bea8e02ea1fdd0e6caac60c1` |
| Vertical Slice contract | `templates/prompts/VERTICAL_SLICE_INTEGRATED_EXECUTION_PROMPT_v9.md` |
| Contract version | `9.1` |
| GitHub Issue | `#119` |
| GDD Sheet | `14xtlvd90iQTKjDLcZR_b-WS5fHnBwNf-OfBruPBS6ck` |

## Authority Order

```text
latest user decision
→ current project canon and actual main implementation
→ skills/PROJECT_BASE_ADAPTER.json
→ skills/PROJECT_SKILL_SNAPSHOT.json
→ .agents/skills/urban-legend-workflow-router/SKILL.md
→ pinned Base v9.3 release
→ Vertical Slice v9 shared contract
→ legacy prompts and historical documents
```

## Project Read Order

```text
latest user instruction
→ START_HERE.md
→ AGENTS.md
→ docs/OPERATING_MODEL.md
→ docs/WORK_MODE_AND_SKILL_ROUTING.md
→ docs/CURRENT_STATUS.md
→ docs/DOCUMENTATION_MAP.md
→ Issue #119 and its Goal/plan
→ skills/PROJECT_BASE_ADAPTER.json
→ skills/PROJECT_SKILL_SNAPSHOT.json
→ selected project and Base Skill bodies
→ actual affected files
```

## Current Request Classification

- Request: Base v9.3 and Vertical Slice v9 operating migration
- Classification: `IMPLEMENTATION_REQUESTED`
- Initial profile: `RECONCILIATION_PLANNING_PROFILE`
- Transition condition: Base binding and all P1 authority conflicts resolved in the implementation branch
- Delivery profile after transition: `INTEGRATED_DELIVERY_PROFILE`

## Project Core Boundary

Preserve:

- fixed protagonist Kwon Narae
- investigation, record, hypothesis, risk verification, omen, response, recovery and manual loop
- anomaly stabilization rather than HP-zero extermination
- fair-play observable evidence
- player-authored rule hypothesis
- failure-forward dangerous-case records
- allies, equipment and Aca never provide the correct answer
- existing save Schema and IDs

## Platform Binding

### Current

- `PC_CURRENT`
- 16:9
- mouse and keyboard primary
- verification resolutions: `1280x720`, `1920x1080`

### Future Consideration

- `MOBILE_FUTURE_CONSIDERATION_NOT_IMPLEMENTED`
- no touch contract
- no mobile layout
- no mobile build or performance evidence
- requires a separate Decision, Issue, Goal and validation package

## Protected Paths

```text
data/
scripts/
scenes/
assets/
addons/
project.godot
```

High-risk paths and contracts:

```text
scripts/core/game_state.gd
data/episodes/**
knowledge/base-pack/**
save Schema
existing IDs
```

The operating migration must produce no diff in these paths.

## Skill Binding

### Base Shared Routes

Select the minimum current routes from the pinned Base Registry. This migration uses:

- `managing-game-project-operating-system`
- `managing-project-intake-and-work-contract`
- `reviewing-and-validating-project-changes`
- `running-adversarial-review-and-refinement`

### Project-Owned Routes

Preserve all ten discipline routes:

- `urban-legend-analytics-user-research`
- `urban-legend-art`
- `urban-legend-audio`
- `urban-legend-engineering`
- `urban-legend-game-design`
- `urban-legend-narrative`
- `urban-legend-production-pm`
- `urban-legend-qa`
- `urban-legend-technical-art-pipeline`
- `urban-legend-ux-ui-accessibility`

Preserve the project-local specialist:

- `urban-legend-investigation-case-authoring`

No shared Base Skill body is copied into this repository.

## Google Sheet Binding

- Role: `USER_FACING_GDD_WORKSPACE`
- Sheet-only edits: `PROPOSED_SHEET_CHANGE`
- Pre-merge write state: `BLOCKED`
- Write policy: `NO_AUTOMATIC_OVERWRITE`

Permitted post-merge synchronization surfaces:

- `00_프로젝트_허브`
- `04_누락_충돌_감사`
- `05_GDD_요약`
- `99_변경이력`

Before writing, re-read merged main and exact target ranges. After writing, re-read the same ranges. A branch SHA cannot be recorded as CURRENT.

## Visual Checkpoint

No new visual checkpoint is required for this operating-only migration. The HTML operating dashboard is a generated diagnostic compatibility artifact, not the project's primary planning dashboard. Any future UI-affecting Vertical Slice work must use a separate Screen Brief and actual Godot evidence.

## Completion Boundary

This application is complete when:

- Adapter, Snapshot and router bind to Base v9.3;
- generated views are current;
- human authority no longer treats v8/v9.1 as active;
- project Skills and protected paths are preserved;
- migration PR passes contract and adversarial review;
- merged main and contracted Sheet ranges are synchronized;
- runtime, device, accessibility and human evidence remain explicitly `NOT_RUN` unless executed.