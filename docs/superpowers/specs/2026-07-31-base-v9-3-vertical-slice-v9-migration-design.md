# Base v9.3 · Vertical Slice v9 Migration Design

## Status

- Issue: #119
- User decision: approved to proceed
- Work Mode: `PLAN → BUILD → REVIEW`
- Initial profile: `RECONCILIATION_PLANNING_PROFILE`
- Target profile after P1 resolution: `INTEGRATED_DELIVERY_PROFILE`
- Project: **괴이기록국(urban-legend)**
- Repository: `alsdmlals4-eng/urban-legend`
- GDD Sheet ID: `14xtlvd90iQTKjDLcZR_b-WS5fHnBwNf-OfBruPBS6ck`

## Goal

Base v9.1에 고정된 프로젝트 운영 계약을 Base v9.3 릴리스와 Vertical Slice v9 실행 계약에 맞게 이관한다. 프로젝트 고유 Skill, 조사·가설·회수 게임 규칙, ANNUAL-MVP-002 구현, 저장 계약과 제품 파일은 변경하지 않는다.

## Player and Project Value

이 작업은 새 기능을 추가하지 않는다. 대신 AI·Codex·리뷰어가 동일한 정본과 검증 절차를 사용하게 하여 이후 기능 작업에서 구형 Prompt, stale 문서, 잘못된 Base 핀 때문에 플레이어 경험이나 저장 계약이 손상되는 위험을 낮춘다.

## Confirmed Baseline

| Item | Value |
|---|---|
| urban-legend main | `656846865eb88871d00842a0da527ce1b0722b77` |
| Current Adapter version | `9.1.0` |
| Base v9.3 release commit | `30ca6c7b5f93521f0eb0eed42d01437cd43c50ae` |
| Base v9.3 evidence commit | `462a86db192d23d0f386281a1eb54b0a8cbad62e` |
| Base Registry raw-byte SHA-256 | `9847bb2b225c776ad7916930f0f48c490bc2a898bea8e02ea1fdd0e6caac60c1` |
| Vertical Slice contract | `templates/prompts/VERTICAL_SLICE_INTEGRATED_EXECUTION_PROMPT_v9.md` |
| Contract version | `9.1` |
| Current platform | `PC_CURRENT` |
| Future platform | `MOBILE_FUTURE_CONSIDERATION_NOT_IMPLEMENTED` |

## Authority Order

```text
latest user decision
→ urban-legend current canon and actual implementation
→ skills/PROJECT_BASE_ADAPTER.json
→ skills/PROJECT_SKILL_SNAPSHOT.json
→ .agents/skills/urban-legend-workflow-router/SKILL.md
→ pinned Base v9.3 release
→ Vertical Slice v9 contract
→ v6~v8 legacy inputs
```

`skills/PROJECT_BASE_ADAPTER.json` remains the canonical machine authority. `skills/BASE_V9_ADAPTER.json`, `skills/PROJECT_BASE_SKILL_ADAPTER.json`, `skills/PROJECT_PATH_ADAPTER.json`, Snapshot, router and operating dashboard are generated views and must not be edited independently.

## Architecture

### 1. Canonical Adapter Upgrade

The project already owns a canonical v9.1 Adapter. This is a version upgrade, not a first legacy migration. Do not run `migrate_project_operating_contract.py` against the same canonical Adapter as input and output.

Update only the canonical values required by the v9.3 release contract:

- `base_release.version = 9.3.0`
- exact release and evidence commits
- Base Registry raw-byte hash
- protected baseline commit and trusted authority for the PR base
- explicit project identity and platform metadata where the schema permits it
- existing project routes, shared overrides, protected paths, Sheet ID and project Registry hash remain unchanged unless the v9.3 validator proves a required change

### 2. Generated Views

Run the Base v9.3 generator after the canonical Adapter is valid. Generated outputs include the Snapshot, compatibility views, workflow router and operating dashboard. The HTML dashboard is a generated diagnostic compatibility artifact, not the project's primary planning surface.

### 3. Human-Facing Authority Repair

Replace stale v8 and pre-canonical descriptions in `docs/BASE_RULES_VERSION.md` and `docs/BASE_V9_ADOPTION_AUDIT.md`. Preserve historical v8 files as `SUPERSEDED_COMPATIBILITY`; do not delete them.

`skills/SKILL_REGISTRY.json` keeps project discipline definitions. Base metadata must point to the canonical Adapter rather than manually duplicating an active Base Skill count or obsolete BCA prompt.

### 4. Sheet Reconciliation

The Sheet reports the v9.1 state as `SYNCED`, while the Adapter records `SHEET_GITHUB_CONFLICT/BLOCKED`. The migration uses a three-way comparison:

```text
merged GitHub main
↔ actual repository implementation and generated operating artifacts
↔ contracted Google Sheet tabs and ranges
```

Before merge the Sheet is read-only. After merge, re-read main and update only approved ranges in:

- `00_프로젝트_허브`
- `04_누락_충돌_감사`
- `05_GDD_요약`
- `99_변경이력`

A branch SHA is never written as CURRENT. Sheet-only edits remain `PROPOSED_SHEET_CHANGE`.

### 5. Platform Contract

Current delivery target:

- PC, 16:9
- primary input: mouse and keyboard
- verification resolutions: `1280x720`, `1920x1080`

Mobile is a future consideration only. This migration does not introduce touch targets, mobile layouts, mobile builds, performance budgets or platform-specific save behavior. Those require a separate Decision, Issue and validation package.

## Protected Boundary

No changes are allowed under:

- `data/`
- `scripts/`
- `scenes/`
- `assets/`
- `addons/`
- `project.godot`

Additional high-risk contracts:

- `scripts/core/game_state.gd`
- `data/episodes/**`
- `knowledge/base-pack/**`
- save Schema and existing IDs

## Required Audit Artifacts

The implementation PR must contain or update:

1. Baseline Recovery Record
2. Legacy Requirement Traceability
3. Source / Consumer / Propagation Map
4. Duplicate·Omission·Conflict Finding Ledger
5. Vertical Slice Readiness + Critical Gate
6. Approval Bundle + Change Plan

These may be grouped in a single reconciliation packet when ownership and status remain explicit.

## Error Handling

Fail closed when any of the following occurs:

- release/evidence commit or Registry hash mismatch
- absent Base or project Skill path
- duplicate or orphan route
- alias cycle
- generated view drift
- protected path diff
- unapproved canon overwrite
- Sheet write before merged-main readback
- runtime, device, accessibility or human evidence promoted without execution

A failed gate is reported as `BLOCKED_UNVERIFIED`; it is not averaged into a passing maturity score.

## Verification Strategy

### Static and Contract Verification

- Base v9.3 lock and Registry hash
- canonical Adapter schema and semantic validation
- generated artifact byte equality
- project discipline route count remains 10
- `urban-legend-investigation-case-authoring` remains project-owned
- active document reference audit
- archive governance
- full Python regression
- `git diff --check`
- protected path diff 0

### Explicitly Not Run

Because product files are out of scope:

- Godot runtime
- device tests
- mobile tests
- accessibility execution
- human/new-player sessions

These remain `NOT_RUN`.

## Rollback

If v9.3 validation fails:

1. do not modify generated views independently;
2. revert the canonical Adapter and human-facing authority changes in the migration branch;
3. keep Issue #119 open with the exact failing gate and evidence;
4. leave the merged main and Sheet unchanged;
5. create a Base change proposal only when the failure is reusable and not project-specific.

## Base Promotion Boundary

### Keep in urban-legend

- project name, world, systems and terminology
- project Skill 10 + investigation authoring Skill
- Godot paths, save contracts and IDs
- Sheet ID and actual project QA
- PC-first and mobile-future platform decision

### Candidate for Base proposal after verification

- stale human Base document detection
- status map disagreement detection
- merged PR left as a future gate detection
- operating-health evidence propagation checks

No Base proposal is created until the project migration proves the issue is reusable.