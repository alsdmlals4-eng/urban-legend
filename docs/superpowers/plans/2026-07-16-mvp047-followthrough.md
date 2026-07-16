# MVP-047 Follow-through Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:executing-plans` to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Verify the new HQ research and Raymond contract flow in real scenes, surface its outcomes, then add only the approved Day 9/fourth-case and MVP-044 source-package work.

**Architecture:** Each stage is a separately verifiable slice. Scene presentation reads state through existing `GameState` APIs; protected campaign state and migration stay in Codex-owned files. Source packages are read before content changes and no missing fourth-case or dialogue detail is invented.

**Tech Stack:** Godot 4.7, GDScript, JSON catalogues, headless scene tests, temporary `APPDATA`, PNG viewport captures.

## Global Constraints

- Keep existing IDs, save records, campaign state, reports, and protected episode JSON compatible.
- Do not stage or alter the user's existing `assets/**.import` and `docs/qa/captures/**.import` changes.
- Use 1280×720 and 1920×1080 captures for changed presentation; do not treat a headless node-existence test as visual approval.
- Preserve the existing non-combat recovery loop and the one-event safety-line contract semantics.
- No new save field or migration without an approved source requirement and a red/green save test.

---

### Task 1: Research/contract route visual verification

**Files:**
- Inspect: `tests/ui_visual_capture.gd`, `scripts/scenes/preparation_scene.gd`, `scripts/scenes/battle_scene.gd`, `scripts/scenes/result_scene.gd`
- Create/modify only if required: an MVP-047 capture fixture under `tests/`
- Test: existing `mvp047_*` tests plus capture script

- [x] Capture HQ research, project craft, Raymond reservation, recovery safety-line result, and HQ return in isolated saves at both target resolutions.
- [x] Inspect each PNG for Korean wrapping, hidden controls, overlap, and whether the route can be followed without a debug-only action.
- [x] Add a narrow regression test only for a reproduced runtime or presentation failure, then rerun the affected capture and test.

### Task 2: Result and database outcome visibility

**Files:**
- Modify: `scripts/scenes/result_scene.gd`, `scripts/scenes/database_view.gd`
- Modify only if a read-only query is absent: `scripts/core/game_state.gd`
- Test: `tests/mvp047_*_test.gd` and new result/database UI tests

- [ ] Write failing UI tests proving a completed project and the resolved Raymond contract appear in their intended read-only sections.
- [ ] Implement presentation that derives from existing completed-project and contract state; do not alter completion, payment, or acknowledgement behaviour.
- [ ] Verify result and DB screens at 1280×720 and 1920×1080.

### Task 3: Day 9 and fourth-case approved vertical slice

**Files:**
- Inspect first: MVP-045/046 source package README and implementation prompt, existing episode catalogues, campaign unlock tests.
- Modify only source-approved case data, catalogue/scene wiring, DB/report presentation, and associated tests.

- [ ] Extract the approved case ID, unlock condition, text, choices, and result records from the source package before changing project files.
- [ ] Write failing tests for Day 9 unlock, the new case entry, save/load, report/DB visibility, and existing-case regression.
- [ ] Implement the smallest end-to-end approved case. If the package has no complete fourth-case specification, record the blocker and stop this task rather than inventing content.

### Task 4: MVP-044 source-package fidelity

**Files:**
- Inspect: `MVP-044-046_Codex_PlanMode_Handoff_Package_v1.0.zip` and `MVP-044_Codex_구현패키지_v0.1.zip`
- Modify: only approved AFTER/DAILY/FACTION data and rendering/test files indicated by the package
- Test: narrative content, daily/faction completion, save migration, database and report regressions

- [ ] Compare every implemented AFTER 7, DAILY 9, and FACTION 9 entry against package text and conditions.
- [ ] Write failing tests for each discovered, source-defined mismatch; leave source-absent content unchanged.
- [ ] Integrate faithful text/condition corrections, run sequential campaign and visual regression, then update only factual status documentation.

## Execution Handoff

Run Task 1 through Task 4 in order. Commit only a completed coherent slice after its tests and captures; push only verified commits.
