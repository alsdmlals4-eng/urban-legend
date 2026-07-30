# Codex Goal — Base v9.3 · Vertical Slice v9 운영체계 이관

/goal Implement GitHub Issue #119 exactly as specified.

## Goal

괴이기록국(urban-legend)의 Base v9.1 운영 바인딩을 Base v9.3 릴리스와 Vertical Slice v9 실행 계약으로 이관한다. canonical Adapter를 갱신하고 생성 뷰·사람용 권한 문서·검증 계약을 정렬하되 제품 코드·Scene·데이터·에셋·저장 계약은 변경하지 않는다.

## Project Value

- AI·Codex·리뷰어가 동일한 Base 핀과 실행 계약을 사용한다.
- v8/v9.1 stale 참조가 이후 기획·구현 범위를 오염시키는 위험을 제거한다.
- 프로젝트 고유 Skill 10개와 사건 작성 Skill 1개를 보존한다.
- PC 우선 플랫폼을 현재 계약으로 유지하고 모바일은 후속 고려 상태로 분리한다.

## Required Reading Order

1. 최신 사용자 지시
2. `START_HERE.md`
3. `AGENTS.md`
4. `docs/OPERATING_MODEL.md`
5. `docs/WORK_MODE_AND_SKILL_ROUTING.md`
6. `docs/CURRENT_STATUS.md`
7. `docs/DOCUMENTATION_MAP.md`
8. GitHub Issue `#119`
9. `docs/superpowers/specs/2026-07-31-base-v9-3-vertical-slice-v9-migration-design.md`
10. `docs/superpowers/plans/2026-07-31-base-v9-3-vertical-slice-v9-migration.md`
11. `docs/vertical-slice/VERTICAL_SLICE_PROJECT_APPLICATION_v9.md`
12. `docs/vertical-slice/VERTICAL_SLICE_RECONCILIATION_PACKET_v9.md`
13. `skills/PROJECT_BASE_ADAPTER.json`
14. `skills/PROJECT_SKILL_SNAPSHOT.json`
15. `.agents/skills/urban-legend-workflow-router/SKILL.md`
16. Base `base-v9.3.lock.json` at `30ca6c7b5f93521f0eb0eed42d01437cd43c50ae`
17. Base `templates/prompts/VERTICAL_SLICE_INTEGRATED_EXECUTION_PROMPT_v9.md` at the same release commit
18. actual affected files and tests

## Work Mode and Skill Contract

- Work Mode: `PLAN → BUILD → REVIEW`
- Start: `RECONCILIATION_PLANNING_PROFILE`
- Build transition: only after Adapter binding and P1 canon conflicts are resolved
- Primary Base route: `managing-game-project-operating-system`
- Supporting Base routes:
  - `managing-project-intake-and-work-contract`
  - `reviewing-and-validating-project-changes`
  - `running-adversarial-review-and-refinement`
- Project discipline Skill: none unless an actual project-specific discipline decision is required

## Scope

- Base v9.3 canonical Adapter pin
- generated Snapshot, compatibility views, workflow router and operating dashboard
- Base version and adoption audit documents
- Base metadata in the project Skill Registry without altering project discipline definitions
- platform boundary: PC current, mobile future consideration
- Vertical Slice v9 project application and reconciliation packet
- focused and full Python contract verification
- protected-path audit
- Draft PR and review evidence
- merge-then-sync Google Sheet closeout

## Out of Scope

- gameplay feature implementation
- `scripts/**`, `data/**`, `scenes/**`, `assets/**`, `addons/**`, `project.godot`
- save Schema, IDs, economy, endings, episode rules or character canon
- ANNUAL-MVP-003 or production expansion
- mobile UI, touch controls, mobile build or performance work
- Godot runtime, device, accessibility or human validation completion claims
- pre-merge Sheet writes

## Fixed Pins

```text
Base version: 9.3.0
release: 30ca6c7b5f93521f0eb0eed42d01437cd43c50ae
evidence: 462a86db192d23d0f386281a1eb54b0a8cbad62e
Registry raw-byte SHA-256: 9847bb2b225c776ad7916930f0f48c490bc2a898bea8e02ea1fdd0e6caac60c1
project baseline main: 656846865eb88871d00842a0da527ce1b0722b77
Sheet ID: 14xtlvd90iQTKjDLcZR_b-WS5fHnBwNf-OfBruPBS6ck
```

## Protected Paths

- `data/`
- `scripts/`
- `scenes/`
- `assets/`
- `addons/`
- `project.godot`
- `scripts/core/game_state.gd`
- `data/episodes/**`
- `knowledge/base-pack/**`

## Implementation Rules

1. Treat `skills/PROJECT_BASE_ADAPTER.json` as the only manually edited machine authority.
2. Do not run the first-migration script against the existing canonical Adapter.
3. Update v9.3 pins, exact Base Registry hash, PR baseline authority and explicit platform metadata.
4. Preserve project routes, shared overrides, project Registry hash, protected paths and compatibility archives unless the v9.3 validator reports a precise required change.
5. Generate all derived views with Base v9.3 tools; never patch them independently.
6. Keep v8 material as `SUPERSEDED_COMPATIBILITY` and remove it only from active authority claims.
7. Keep Sheet read-only until the migration PR is merged and main is re-read.
8. Record runtime, device, accessibility and human evidence as `NOT_RUN` unless actually executed.
9. Stop on any P0/P1, protected-path diff, generated drift, unresolved review thread or authority conflict.

## TDD Contract

1. Add `tests/test_base_v93_operating_contract.py` before changing the Adapter.
2. Verify the focused test fails on v9.1 pins.
3. Update the canonical Adapter minimally.
4. Verify the focused test passes.
5. Regenerate views and validate byte equality.
6. Repair active human authority and active-document tests.
7. Run focused operating tests, full Python regression, `git diff --check` and protected-path diff.
8. Perform independent and adversarial review.

## Acceptance Criteria

- Adapter declares Base `9.3.0` and exact release/evidence/Registry pins.
- Adapter project metadata declares `괴이기록국(urban-legend)`, `PC_CURRENT`, and mobile as future consideration only.
- exactly 10 active project discipline routes remain.
- `urban-legend-investigation-case-authoring` remains project-owned and discoverable.
- generated artifacts are current according to Base v9.3 generator and validator.
- v8 is not active authority and is preserved as compatibility history.
- human authority documents, Adapter, Snapshot and router agree on v9.3.
- protected product paths have no diff.
- full Python regression passes.
- Godot/runtime/device/accessibility/human evidence remains `NOT_RUN`.
- Sheet is not written before merge.
- after merge, contracted Sheet ranges contain the merged main SHA and v9.3 state and pass readback.

## Final Report

Report:

- Work Mode, Skills and modes actually used
- changed files and reasons
- Base pin and Registry verification
- Red and Green test evidence
- generated artifact check evidence
- project Skill preservation
- protected-path diff
- independent/adversarial review findings
- PR number, merge status and merged main SHA
- exact Sheet ranges changed and readback
- all `NOT_RUN` evidence
- Base promotion candidates versus project-only decisions