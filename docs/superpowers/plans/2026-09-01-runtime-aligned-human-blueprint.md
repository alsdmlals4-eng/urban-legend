# Runtime-Aligned Human Blueprint Implementation Plan

> **For implementation:** Execute this plan in the isolated worktree
> `codex/blueprint-runtime-alignment-20260901`, then send the resulting exact
> head through the normal protected PR path. Do not mutate the separate active
> M04 worktree while carrying out this documentation scope.

**Goal:** Make the existing human blueprint a trustworthy, editable map of
`괴이기록국: 잔향 보고서`'s current investigation/manual/rescue/recovery loop,
and explicitly separate current-main facts from the approved M04 recovery/menu
target awaiting reconciliation.

**Architecture:** The existing human blueprint remains the one human-facing
flow/wireframe owner. The current master GDD links to it rather than copying its
rules. The benchmark is evidence-only, and the machine test protects a short
set of current-state assertions from regressing to the old draft.

**Tech Stack:** Markdown, Mermaid, Python `unittest`, repository docs and
current Godot source readback. No new runtime image, Scene, save, add-on, or
external paid service is required.

## Scope and decision boundary

Included:

- Reconcile the existing human blueprint with source-backed M01/M04 manual
  input, CASE-01 Lume, M04 text-only Aka, the main-menu action hierarchy, and
  the user-approved dual-clock recovery target.
- Record ten official-source product comparisons as `ADOPT / ADAPT / REJECT`.
- Correct the obsolete current-visual Notion sync wording to repository-first
  authority.
- Add a focused red-to-green documentation contract test and a reuse receipt.

Excluded:

- Absorbing, rebasing, or editing the separate
  `codex/m04-playable-vertical-slice-20260831` branch.
- Claiming that its recovery/menu UI is already in `origin/main`.
- New raster UI diagrams, new texture assets, title art, runtime Scene changes,
  save-schema changes, numeric balance, Human QA, accessibility, or release
  approval.

## Work packages

### 1. Establish a failing current-state contract

**Files:** `tests/test_runtime_aligned_human_blueprint.py`

1. Assert the human blueprint names Lume for CASE-01 and text-only Aka for M04.
2. Assert it says M01/M04 candidate-slot input is implemented, without semantic
   answer recommendation.
3. Assert dual clocks, manual lower-right action, and the absence of target
   representative-switch/recover-execute controls.
4. Assert the benchmark has at least ten comparisons and the visual work order
   remains repository-first.
5. Run the test before the doc update and preserve the expected red result.

### 2. Update the existing human-facing owner

**Files:** `docs/design/URBAN_LEGEND_HUMAN_GAME_BLUEPRINT_20260830.md`,
`docs/design/PROJECT_AI_PRODUCTION_SPEC.md`

1. Update status, title, authority boundary, and evidence ceiling in place.
2. Replace stale manual-not-implemented and Aka-as-CASE-01-guide claims with
   precise M01/M04 implementation facts.
3. Add the dual-clock explanation, action-surface wireframe, and explicit
   `PENDING_MAIN_RECONCILIATION` label for the M04 branch-only target.
4. Add text-native main-menu, manual, recovery, and causal flow wireframes;
   do not make decorative explanatory PNGs.
5. Link the existing blueprint from the current master GDD source registry.

### 3. Preserve evidence and workflow boundaries

**Files:** `docs/research/2026-09-01-runtime-aligned-blueprint-benchmark.md`,
`docs/CURRENT_VISUAL_WORK_ORDER.md`,
`docs/operations/receipts/2026-09-01-runtime-aligned-blueprint.json`

1. Record official-source comparisons and concrete disposition for each.
2. Preserve the `REUSE_ACCEPTED / NO_NEW_IMAGE_REQUIRED` outcome: existing
   Godot Control surfaces are the consumer, so no visual asset is manufactured.
3. Replace stale Notion current-sync wording with repository commit/push/remote
   readback, leaving historical material preserved without writing to Notion.
4. Record current-main versus active-worktree evidence, rollback, and explicit
   evidence ceiling in the receipt.

### 4. Validate and publish safely

**Files:** all above, no generated product asset

1. Run the focused documentation test green, then Markdown/link/reference and
   JSON syntax checks.
2. Inspect the source publication route. If the blueprint has no registered
   PDF generator/policy, retain source-only status rather than inventing a
   second publication pipeline.
3. Run five adversarial review loops: stale state, authority confusion,
   Lume/Aka leakage, false M04-main implementation claim, and artifact creep.
4. Commit only this worktree's files, push the branch, open a PR, and read back
   the exact remote head. Required CI and Human QA stay separate gates.

### 5. Recover a pre-existing Base Adapter baseline only if exact-head CI proves drift

**Files:** `skills/PROJECT_BASE_ADAPTER.json` and its six generated operating views.

1. Treat a CI report of a protected path already present on PR base as a
   baseline-drift incident, not as this documentation task's product mutation.
2. Prove it by comparing `protected_baseline..PR base` with `PR base..HEAD`.
3. Advance only `protected_baseline.commit` to the immutable PR-base SHA;
   preserve the protected-path list and policy hash.
4. Regenerate only the declared operating views with the pinned Base generator,
   then run its `--check` and the exact project operating-contract validator.
5. Do not add a protected-change approval manifest when no protected path is
   changed: that manifest is intentionally valid only for one detected
   protected-path error and would make a clean baseline-reconciliation fail.

## Acceptance criteria

- A reader can trace `조사 → 매뉴얼 → 구출 → 회수 → 복합 결과` without confusing a
  human blueprint image for a product asset.
- The guide contract is exact: **루메 — CASE-01 저승역**, **기록관 아카 — M04 텍스트 보조**.
- The recovery target has a visible 8-segment stability clock, 6-segment danger
  clock, contextual response, manual lower-right entry, and no target
  representative-switch/recover-execute controls.
- The M04 target is labeled `PENDING_MAIN_RECONCILIATION` until a separate
  current-main integration PR supplies exact-head verification.
- No unapproved runtime asset or new product meaning is created.

## Verification and rollback

- Focused static proof: `python -m unittest tests/test_runtime_aligned_human_blueprint.py`.
- Broader documentation proof: selected project contract tests and
  `git diff --check`.
- Publication state: no registered blueprint PDF route found means
  `SOURCE_ONLY / PDF_NOT_PUBLISHED`, not a pass/fail claim about a non-existent
  output.
- Roll back by reverting the dedicated documentation commit. It cannot change
  runtime scenes, saves, or the separate M04 worktree.
