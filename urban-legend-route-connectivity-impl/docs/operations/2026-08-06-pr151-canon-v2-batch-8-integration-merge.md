# PR #151 Canon v2 Batch 3 8/10 Integration Merge Record

> Record ID: `MERGE-20260806-PR151-CANON-V2-BATCH-8`
> User authorization: 2026-08-06 11:31 KST — `좋아 일단 지금까지 작업을 병합하고`
> Repository: `alsdmlals4-eng/urban-legend`
> Source PR: #151
> Source head: `8ffe2247e82d846a0afab8bb31e80cdce2e0e24c`
> Merge commit: `b86ff83b7acaaeeccb3fb238506cf1eb0d3befe5`
> Target branch: `agent/afterlife-canon-v2-local-human-qa-runner`
> Target stacked PR: #149
> Main branch merge: `NOT_AUTHORIZED`
> Runtime implementation: `IMPLEMENTATION_NOT_AUTHORIZED`
> Human QA: `HUMAN_QA_NOT_RUN`
> UI/accessibility QA: `UI_ACCESSIBILITY_NOT_RUN`

## 1. Integrated scope

PR #151 was merged into the Godot integration branch with the approved Canon v2 planning scope through GrillMe Batch 3 `8_OF_10`.

Included authority decisions:

- `DEC-20260805-115-CANON-V2-RULE-STRIP-CONTINUITY`
- `DEC-20260805-116-CANON-V2-RESCUE-RETRIEVAL-ROLE-BOUNDARY`
- `DEC-20260805-117-CANON-V2-RESCUE-MINIGAME-AND-RETRIEVAL-RULE-COVERAGE`
- `DEC-20260806-119-CANON-V2-RECOVERY-PATTERN-POOL-SELECTION-AND-JUDGMENT`
- `DEC-20260806-120-CANON-V2-RECOVERY-OUTCOME-STATES-AND-INDEPENDENT-RESULT-PACKET`
- `DEC-20260806-121-CANON-V2-RESCUE-RESULT-HANDOFF-TO-RECOVERY-INITIAL-CONDITIONS-AND-ACTION-CONSTRAINTS`
- `DEC-20260806-122-CANON-V2-PROTECTION-OBLIGATION-COST-PRIORITY-AND-RECOVERY-TERMINATION-ELIGIBILITY`
- `DEC-20260806-123-CANON-V2-PROTECTION-OBLIGATION-FOLLOW-UP-REENTRY-REWARD-AND-EVALUATION-LINKAGE`

Decision 118 remains `RETRACTED / NON_COUNTING`.

The merge includes authority documents, planning designs, adversarial reviews, TDD implementation plans, documentation contract tests, CI wiring, and the synchronized Google Sheet references. It does not authorize or claim the corresponding runtime implementation.

## 2. Godot project connection

The target branch is part of the same repository that contains the active Godot project root.

Verified project entry:

- `project.godot`
- project name: `urban-legend`
- Godot feature version: `4.7`
- main scene: `res://scenes/main_menu.tscn`
- autoloads: `UrbanLegendState`, `ValidationSession`, `GameState`, `_mcp_game_helper`
- enabled editor plugin: `res://addons/godot_ai/plugin.cfg`

Therefore the approved planning authority is now stored in the same repository and integration branch as the Godot project. This is repository-level connection and authority integration, not completed runtime implementation of Decisions 115–123.

## 3. Verification before merge

Source head `8ffe2247e82d846a0afab8bb31e80cdce2e0e24c` was verified before merge:

- Documentation workflow `31065050026`: PASS
- ANNUAL / focused packages / Canon v2 migration / full Godot regression `31065050029`: PASS
- unresolved inline review threads: 0
- PR was mergeable

## 4. Remaining stacked boundaries

This merge only integrated PR #151 into PR #149's head branch.

Still open and unmerged:

- PR #149 and its lower stacked PR chain
- merge from the integration stack into `main`
- actual user-save Human QA
- Windows 10/11 device QA
- UI and accessibility Human QA
- runtime implementation for the newly approved planning contracts

Historical documents that contain `MERGE_NOT_AUTHORIZED` record the state at the time those design contracts were approved. This operational record is the later authority for the specific PR #151 → integration-branch merge. It does not supersede the remaining `main` and stacked-PR gates.
