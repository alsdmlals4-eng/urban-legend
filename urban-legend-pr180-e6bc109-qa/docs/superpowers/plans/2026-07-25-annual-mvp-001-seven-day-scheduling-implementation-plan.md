# ANNUAL-MVP-001 Seven-Day Scheduling Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the fixed three-activity week with a seven-day budget, per-activity day costs, two-step underfilled-week confirmation, and weaker automatic rest.

**Architecture:** Keep the legacy base state intact and implement the new contract in `AnnualMvp001StateV2`. Data owns day costs and automatic-rest policy, state owns validation and deterministic application, and the Scene owns only the ephemeral second-confirmation flag and button presentation. Save schema and CORE integration remain unchanged.

**Tech Stack:** Godot 4.7.1, GDScript, JSON, Python `unittest`, GitHub Actions.

## Global Constraints

- 1 week is exactly 7 days; 1 month remains 4 weeks.
- Activities may not cross a week boundary.
- Existing activity, companion, skill, equipment, module, and research IDs remain unchanged.
- Automatic rest changes fatigue only and restores 5 fatigue per unused day.
- Direct rest keeps authored fatigue `-25` and is status-recovery eligible.
- `annual-mvp-001-save-v1`, `mvp-039`, `mvp-038`, and CORE-MVP-001 remain unchanged.
- No `POC_PASSED` or production-expansion declaration.

---

### Task 1: Lock the data contract

**Files:**
- Modify: `data/poc/annual_mvp_001/spring_vertical_slice.json`
- Modify: `scripts/poc/annual_mvp_001/annual_mvp_001_data.gd`
- Test: `tests/test_annual_mvp_001_data_contract.py`
- Test: `tests/annual_mvp_001_data_test.gd`

**Interfaces:**
- Produces: campaign keys `days_per_week`, `auto_rest_fatigue_recovery_per_day`; activity key `day_cost`; direct-rest key `status_recovery_eligible`.

- [ ] **Step 1: Write failing data-contract assertions**

Assert contract `annual-mvp-001-v3`, 4 weeks, 7 days per week, 28 monthly days, auto-rest recovery 5, exact day-cost map, and absence of `slots_per_week`.

- [ ] **Step 2: Verify the tests fail on the v2 data**

Run `python -m unittest tests.test_annual_mvp_001_data_contract -v` and the focused Godot data test. Expected: failures mentioning `annual-mvp-001-v2` or missing `days_per_week`.

- [ ] **Step 3: Update JSON and GDScript validation**

Set the exact approved values and reject missing/out-of-range day costs. Require direct rest to be one day and status-recovery eligible.

- [ ] **Step 4: Re-run data tests**

Expected: PASS.

### Task 2: Implement deterministic seven-day week commits

**Files:**
- Modify: `scripts/poc/annual_mvp_001/annual_mvp_001_state_v2.gd`
- Test: `tests/annual_mvp_001_state_test.gd`

**Interfaces:**
- Produces: `commit_week(activity_ids)` for exact-seven-day commits or confirmation requests.
- Produces: `commit_week_with_auto_rest(activity_ids)` for confirmed underfilled commits.
- Produces in `last_week_result`: `used_days`, `auto_rest_days`, `activity_results`, and legacy `slot_results` alias.

- [ ] **Step 1: Add failing state tests**

Cover exact seven-day commit, over-budget immutability, first underfilled warning with unchanged snapshot, second confirmed commit, fatigue-only automatic rest, and direct-rest strength.

- [ ] **Step 2: Verify state tests fail**

Run the focused state test. Expected: missing methods/fields or legacy three-slot validation.

- [ ] **Step 3: Implement state validation and application**

Calculate day totals from indexed activities. Reject unknown activities and totals over 7. Return `requires_auto_rest_confirmation=true` without mutation for underfilled `commit_week`. Apply activity deltas through focused helpers and append one aggregated automatic-rest result on confirmed commit.

- [ ] **Step 4: Re-run focused state tests**

Expected: PASS, including existing 0/15/30 deployment paths.

### Task 3: Implement Scene warning and calendar presentation

**Files:**
- Modify: `scripts/poc/annual_mvp_001/annual_mvp_001_scene.gd`
- Modify: `scripts/poc/annual_mvp_001/annual_mvp_001_themed_scene.gd`
- Test: `tests/annual_mvp_001_scene_test.gd`
- Test: `tests/test_annual_mvp_001_static_contract.py`

**Interfaces:**
- Consumes: state confirmation response and `commit_week_with_auto_rest`.
- Produces: activity labels with day costs, `사용 X/7일 · 남은 Y일`, disabled over-budget buttons, and second-confirmation behavior.

- [ ] **Step 1: Add failing Scene/static tests**

Assert day-cost labels, exact remaining-day display, first warning, preserved selection, second-confirmed result, and no stale `활동 3개` copy.

- [ ] **Step 2: Verify tests fail**

Run Python static contract and focused Scene test. Expected: stale three-activity strings and missing warning behavior.

- [ ] **Step 3: Implement UI behavior**

Store activity buttons by ID, compute selected days, disable buttons that exceed the remainder, reset confirmation on selection/back/load, and call the confirmed state method only on the unchanged second confirmation.

- [ ] **Step 4: Re-run Scene/static tests**

Expected: PASS at 1280×720 and 1920×1080.

### Task 4: Synchronize active design documentation

**Files:**
- Modify: `docs/PROJECT_CORE.md`
- Modify: `docs/GAME_DESIGN_DOCUMENT.md`
- Modify: `docs/CURRENT_STATUS.md`
- Modify: `docs/CURRENT_HANDOFF.md`
- Modify: `MVP_ROADMAP.md`
- Modify: `TEST_CHECKLIST.md`
- Modify: `tools/docs/build_game_design_doc.py` only if its visible version metadata must change
- Test: `tests/test_annual_mvp_001_document_contract.py`
- Test: `tests/test_active_document_references.py`

**Interfaces:**
- Produces: one canonical description of 4 weeks × 7 days, variable day costs, warning/automatic rest, and unchanged human-validation gate.

- [ ] **Step 1: Add failing document assertions**

Require `annual-mvp-001-v3`, `1주 = 7일`, `1개월 = 28일`, automatic-rest policy, and historical treatment of the previous three-slot contract.

- [ ] **Step 2: Update active documents with minimal diffs**

Replace current-tense `3슬롯` statements while preserving previous implementation evidence as `HISTORICAL_REGRESSION_EVIDENCE`.

- [ ] **Step 3: Build and check deterministic DOCX**

Run `python tools/docs/build_game_design_doc.py --build` and `--check`. Do not track the generated DOCX binary.

- [ ] **Step 4: Run document contracts**

Expected: PASS with no stale current-tense three-slot reference.

### Task 5: Full verification and integration

**Files:**
- Review all changed files.

- [ ] **Step 1: Run Python contracts**

Run `python -m unittest discover -s tests -p 'test_*.py' -v`.

- [ ] **Step 2: Run Godot import and regressions**

Run Godot 4.7.1 import, focused CORE tests, focused ANNUAL tests, and `tests/run_godot_regression.sh`.

- [ ] **Step 3: Run rendered keyboard/pointer QA**

Verify the planning screen, warning loop, automatic-rest result, and four-week forced route.

- [ ] **Step 4: Audit the diff**

Confirm protected paths, IDs, save versions, and CORE contracts are unchanged.

- [ ] **Step 5: Open and merge PR**

Record test runs, review threads, changed-file audit, and state boundaries; squash merge only after all required checks succeed.
