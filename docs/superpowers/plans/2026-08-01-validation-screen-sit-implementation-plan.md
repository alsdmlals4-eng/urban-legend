# Validation SCREEN·SIT Implementation Plan

> **For Codex:** REQUIRED SUB-SKILL: Use `superpowers:executing-plans` to implement this plan task-by-task in an isolated worktree. Run a read-only technical Plan first and return any `CHANGE_PROPOSAL` before modifying files.

**Goal:** 승인된 저승역 Validation 흐름을 Legacy 구현·저장·테스트를 보존한 채 별도 Validation 경로로 구현한다.

**Architecture:** 기존 `GameState`는 장기 상태·Legacy 호환을 유지하고, 신규 `ValidationFlowState`가 현재 단계·checkpoint·return target·결과 원시 축을 소유한다. `ValidationFlowRouter`가 SCREEN/SIT 전환을 담당하고 각 기존 Scene은 Validation mode에서 최소 책임만 노출한다. Legacy `mvp-039` 저장과 신규 Validation 저장은 파일·버전·UI에서 구분한다.

**Tech Stack:** Godot 4.7.1, GDScript, JSON, PC 16:9, mouse+keyboard, existing ThemeFactory/AfterlifeTheme, existing headless Godot tests and GitHub Actions.

**Authority:**

- `docs/CURRENT_CONFIRMED_DECISIONS.md`
- `docs/VALIDATION_TARGET_CANON.md`
- `docs/decisions/D-2026-08-01-VALIDATION-PLANNING-FINAL-APPROVAL.md`
- `docs/validation/VALIDATION_SCREEN_SIT_PLAYTEST_PACKAGE_2026-08-01.md`

**Implementation status before this plan:** `CURRENT_IMPLEMENTATION_LEGACY`; product build is not yet authorized. This plan is the approved writing-plans output. Codex must first verify all paths and signatures on latest `main`.

---

## Baseline files to inspect before any edit

- `project.godot`
- `scripts/core/game_state.gd`
- `scripts/core/game_bootstrap.gd`
- `scripts/ui/main_menu.gd`
- `scripts/scenes/preparation_scene.gd`
- `scripts/scenes/investigation_scene.gd`
- `scripts/scenes/minigame_scene.gd`
- `scripts/minigames/route_restore_game.gd`
- `scripts/scenes/battle_scene.gd`
- `scripts/scenes/result_scene.gd`
- `scripts/data/episode_loader.gd`
- `scripts/data/case_data.gd`
- `data/episodes/episode_001_afterlife_station.json`
- `scenes/main_menu.tscn`
- `scenes/preparation_scene.tscn`
- `scenes/investigation_scene.tscn`
- `scenes/minigame_scene.tscn`
- `scenes/battle_scene.tscn`
- `scenes/result_scene.tscn`
- `tests/afterlife_main_menu_flow_test.gd`
- `tests/preparation_scene_smoke_test.gd`
- `tests/investigation_scene_smoke_test.gd`
- `tests/minigame_scene_smoke_test.gd`
- `tests/minigame_pipeline_test.gd`
- `tests/battle_scene_smoke_test.gd`
- `tests/result_scene_smoke_test.gd`
- `.github/workflows/validate-core-mvp-001.yml`
- `.github/workflows/validate-annual-mvp-001.yml`
- `.github/workflows/capture-core-mvp-001-visuals.yml`

If any listed path is absent or renamed on latest `main`, stop and report the exact replacement path. Do not invent an alias silently.

---

## Task 1: Add isolated Validation flow state

**Files:**

- Create: `scripts/core/validation_flow_state.gd`
- Create: `tests/validation/validation_flow_state_test.gd`
- Modify: `scripts/core/game_state.gd`

### Step 1: Write the failing state test

```gdscript
extends SceneTree

const ValidationFlowState = preload("res://scripts/core/validation_flow_state.gd")

func _init() -> void:
    var state := ValidationFlowState.new()
    state.start_new("episode_001_afterlife_station")
    assert(state.flow_stage == "sit_001_cold_open")
    assert(state.checkpoint_id == "validation_start")
    assert(state.return_target == "")

    state.enter_specialist("hypothesis", "investigation_after_hypothesis")
    assert(state.flow_stage == "sit_005_hypothesis")
    assert(state.return_target == "investigation_after_hypothesis")

    state.complete_result_axis("rule_validation", "verified")
    var snapshot := state.to_snapshot()
    var restored := ValidationFlowState.new()
    assert(restored.restore_snapshot(snapshot))
    assert(restored.result_axes["rule_validation"] == "verified")
    quit(0)
```

### Step 2: Run the test and verify RED

Run:

```bash
godot --headless --path . --script tests/validation/validation_flow_state_test.gd
```

Expected: failure because `validation_flow_state.gd` does not exist.

### Step 3: Implement the minimal state object

Required fields:

```gdscript
class_name ValidationFlowState
extends RefCounted

const SAVE_VERSION := "validation-save-v1"
const AXIS_IDS := [
    "field_stabilization",
    "victim_rescue",
    "rule_validation",
    "core_residue_recovery",
]

var episode_id := ""
var flow_stage := ""
var checkpoint_id := ""
var return_target := ""
var preparation_snapshot: Dictionary = {}
var hypothesis_state: Dictionary = {}
var timeline_state: Dictionary = {}
var route_state: Dictionary = {}
var recovery_patterns: Dictionary = {}
var result_axes: Dictionary = {}
var applied_effect_ids: Dictionary = {}
```

Implement:

- `start_new(episode_id: String)`
- `set_stage(stage_id: String, checkpoint: String)`
- `enter_specialist(stage_id: String, target: String)`
- `consume_recovery(pattern_id: String) -> bool`
- `complete_result_axis(axis_id: String, status: String)`
- `mark_effect_applied(effect_id: String) -> bool`
- `to_snapshot() -> Dictionary`
- `restore_snapshot(snapshot: Dictionary) -> bool`
- `reset()`

Reject unknown stage IDs and unknown result axis IDs without mutating state.

### Step 4: Integrate into GameState without changing Legacy semantics

Add one optional member:

```gdscript
var validation_flow := ValidationFlowState.new()
```

Add accessors only; do not change existing `reset_game()`, Legacy save payload, episode IDs, scene constants, or ANNUAL state in this task.

### Step 5: Re-run focused and Legacy tests

```bash
godot --headless --path . --script tests/validation/validation_flow_state_test.gd
godot --headless --path . --script tests/afterlife_main_menu_flow_test.gd
```

Expected: PASS; Legacy main-menu test unchanged.

### Step 6: Commit

```bash
git add scripts/core/validation_flow_state.gd scripts/core/game_state.gd tests/validation/validation_flow_state_test.gd
git commit -m "feat: add isolated Validation flow state"
```

---

## Task 2: Add separate Validation save repository

**Files:**

- Create: `scripts/core/validation_save_repository.gd`
- Create: `tests/validation/validation_save_repository_test.gd`
- Modify: `scripts/core/game_state.gd`
- Modify: `scripts/ui/main_menu.gd`

### Step 1: Write RED tests

Test these cases:

1. Save path is distinct from `user://urban_legend_save.json`.
2. Payload version is `validation-save-v1`.
3. Save→restore returns exact `flow_stage`, `checkpoint_id`, and `return_target`.
4. Unknown IDs are retained as orphan metadata but do not apply effects.
5. Duplicate `effect_id` is not applied twice.
6. Corrupt Validation save does not delete or rewrite Legacy save.

Recommended path:

```gdscript
const VALIDATION_SAVE_PATH := "user://urban_legend_validation_save.json"
```

### Step 2: Run RED

```bash
godot --headless --path . --script tests/validation/validation_save_repository_test.gd
```

### Step 3: Implement repository

Public interface:

```gdscript
class_name ValidationSaveRepository
extends RefCounted

func save_state(state: ValidationFlowState, path := VALIDATION_SAVE_PATH) -> Dictionary
func load_state(state: ValidationFlowState, path := VALIDATION_SAVE_PATH) -> Dictionary
func inspect_save(path := VALIDATION_SAVE_PATH) -> Dictionary
func remove_save(path := VALIDATION_SAVE_PATH) -> bool
```

Return structured results:

```gdscript
{
    "ok": true,
    "error": "",
    "version": "validation-save-v1",
    "episode_id": "episode_001_afterlife_station",
    "flow_stage": "sit_004_investigation",
    "checkpoint_id": "after_record_phone_audio",
    "saved_at_unix": 0,
}
```

### Step 4: Add GameState wrappers

- `save_validation_game()`
- `load_validation_game()`
- `inspect_validation_save()`
- `has_validation_save()`
- `clear_validation_session()`

Do not modify existing `save_game()` and `load_game()` behavior.

### Step 5: Add main-menu save metadata only

`main_menu.gd` should inspect both save repositories but not change layout until Task 3.

### Step 6: Run tests

```bash
godot --headless --path . --script tests/validation/validation_save_repository_test.gd
godot --headless --path . --script tests/afterlife_main_menu_flow_test.gd
```

### Step 7: Commit

```bash
git add scripts/core/validation_save_repository.gd scripts/core/game_state.gd scripts/ui/main_menu.gd tests/validation/validation_save_repository_test.gd
git commit -m "feat: isolate Validation save from legacy saves"
```

---

## Task 3: Implement SCREEN-01 save distinction and cold-open entry

**Files:**

- Modify: `scripts/ui/main_menu.gd`
- Modify: `scenes/main_menu.tscn` only if the current programmatic UI cannot express the approved states
- Create: `tests/validation/validation_main_menu_test.gd`
- Modify: `tests/afterlife_main_menu_flow_test.gd`

### Step 1: Write RED tests

Required states:

- no save
- Legacy save only
- Validation save only
- both saves
- recoverable Validation save
- incompatible Validation save

Assertions:

- New Record never silently deletes an existing save.
- Continue cards include `기존 진행` or `Validation 기록`.
- Each card includes episode title, stage label, and save time.
- Validation continue calls `GameState.load_validation_game()`.
- Legacy continue calls existing `GameState.load_game()`.

### Step 2: Run RED

```bash
godot --headless --path . --script tests/validation/validation_main_menu_test.gd
```

### Step 3: Refactor save-card model

Add a pure helper to `main_menu.gd`:

```gdscript
func _build_continue_entries() -> Array[Dictionary]
```

Each entry:

```gdscript
{
    "kind": "legacy" | "validation",
    "title": "저승역",
    "stage_label": "조사 단계",
    "saved_at_unix": 0,
    "recoverable": false,
    "incompatible": false,
}
```

### Step 4: Add approved New Record flow

```text
새 기록 시작
→ 기존 Validation 저장 존재 시 덮어쓰기 확인
→ GameState.clear_validation_session()
→ validation_flow.start_new("episode_001_afterlife_station")
→ save_validation_game()
→ res://scenes/investigation_scene.tscn in cold-open mode
```

Do not route new Validation through the old immediate episode-dialogue path without setting `flow_stage`.

### Step 5: Verify visual and input states

- 1280×720
- 1920×1080
- keyboard focus order
- pointer click
- Esc closes overwrite confirmation

### Step 6: Run focused tests

```bash
godot --headless --path . --script tests/validation/validation_main_menu_test.gd
godot --headless --path . --script tests/afterlife_main_menu_flow_test.gd
```

### Step 7: Commit

```bash
git add scripts/ui/main_menu.gd scenes/main_menu.tscn tests/validation/validation_main_menu_test.gd tests/afterlife_main_menu_flow_test.gd
git commit -m "feat: distinguish Validation and legacy saves on main menu"
```

---

## Task 4: Add Validation flow router and text-novel shell

**Files:**

- Create: `scripts/core/validation_flow_router.gd`
- Create: `scripts/ui/validation_text_novel_shell.gd`
- Create: `scenes/ui/validation_text_novel_shell.tscn`
- Modify: `scripts/scenes/investigation_scene.gd`
- Modify: `scenes/investigation_scene.tscn`
- Create: `tests/validation/validation_flow_router_test.gd`
- Create: `tests/validation/validation_text_novel_shell_test.gd`

### Step 1: Write router RED test

Approved stage map:

```gdscript
const ROUTES := {
    "sit_001_cold_open": "res://scenes/investigation_scene.tscn",
    "sit_002_briefing": "res://scenes/investigation_scene.tscn",
    "sit_003_preparation": "res://scenes/preparation_scene.tscn",
    "sit_004_investigation": "res://scenes/investigation_scene.tscn",
    "sit_005_hypothesis": "res://scenes/investigation_scene.tscn",
    "sit_006_route": "res://scenes/minigame_scene.tscn",
    "sit_007_recovery": "res://scenes/battle_scene.tscn",
    "sit_008_result": "res://scenes/result_scene.tscn",
}
```

Test invalid stage rejection and return-target restoration.

### Step 2: Write shell RED test

Shell must support:

- narration
- dialogue
- 2–4 choices
- locked reason
- inline result
- record badge
- record drawer
- specialist transition
- returned-from-specialist focus restoration

### Step 3: Implement router

Public interface:

```gdscript
func scene_for_stage(stage_id: String) -> String
func advance_to(stage_id: String, checkpoint_id: String) -> Error
func enter_specialist(stage_id: String, return_target: String) -> Error
func return_from_specialist() -> Error
func resume_scene_path() -> String
```

### Step 4: Implement reusable text-novel shell

Signals:

```gdscript
signal choice_selected(choice_id: String)
signal record_requested
signal settings_requested
signal specialist_requested(stage_id: String, return_target: String)
```

Methods:

```gdscript
func show_narration(lines: Array[String])
func show_dialogue(speaker: String, lines: Array[String], portrait: Texture2D = null)
func show_choices(choices: Array[Dictionary])
func show_inline_result(text: String, record_updates: Array[String])
func set_context(case_name: String, location_name: String)
func notify_new_record(record_id: String)
```

No collection percentage, prediction percentage, or recovery success percentage.

### Step 5: Integrate Investigation Scene in Validation mode

Keep the existing Legacy UI path intact behind the existing session mode.

Validation mode uses the shell for SIT-001, SIT-002, SIT-004, and the host transitions for SIT-005.

### Step 6: Run tests

```bash
godot --headless --path . --script tests/validation/validation_flow_router_test.gd
godot --headless --path . --script tests/validation/validation_text_novel_shell_test.gd
godot --headless --path . --script tests/investigation_scene_smoke_test.gd
```

### Step 7: Commit

```bash
git add scripts/core/validation_flow_router.gd scripts/ui/validation_text_novel_shell.gd scenes/ui/validation_text_novel_shell.tscn scripts/scenes/investigation_scene.gd scenes/investigation_scene.tscn tests/validation/validation_flow_router_test.gd tests/validation/validation_text_novel_shell_test.gd
git commit -m "feat: add Validation router and text novel shell"
```

---

## Task 5: Add SCREEN-03 Validation preparation mode

**Files:**

- Modify: `scripts/scenes/preparation_scene.gd`
- Modify: `scenes/preparation_scene.tscn`
- Create: `tests/validation/validation_preparation_mode_test.gd`
- Modify: `tests/preparation_scene_smoke_test.gd`

### Step 1: Write RED tests

Validation mode must expose only:

- Kwon Narae fixed
- two companion slots
- one equipment slot
- one support slot
- one investigation priority
- recommended restore
- deploy confirmation
- impact preview

It must not evaluate or log:

- half-day slot economy
- daily episode trigger
- external request
- market
- random party generation
- full relationship/research probability

### Step 2: Add explicit mode

```gdscript
const MODE_LEGACY := "legacy"
const MODE_VALIDATION := "validation"

func configure_mode(mode: String) -> void
```

Do not infer Validation mode from incidental flags.

### Step 3: Add recommended party

```gdscript
const VALIDATION_RECOMMENDED_AGENTS := ["agent_oh_hyun", "agent_kang_ijun"]
```

Use actual IDs from latest main. If IDs differ, Codex must report them before implementation.

### Step 4: Save preparation snapshot

Store only stable IDs and approved impact categories in `validation_flow.preparation_snapshot`.

### Step 5: Deploy

```text
confirm
→ set sit_004_investigation
→ save_validation_game
→ investigation_scene
```

### Step 6: Run tests and capture

```bash
godot --headless --path . --script tests/validation/validation_preparation_mode_test.gd
godot --headless --path . --script tests/preparation_scene_smoke_test.gd
```

Capture 1280×720 and 1920×1080.

### Step 7: Commit

```bash
git add scripts/scenes/preparation_scene.gd scenes/preparation_scene.tscn tests/validation/validation_preparation_mode_test.gd tests/preparation_scene_smoke_test.gd
git commit -m "feat: add reduced Validation preparation mode"
```

---

## Task 6: Implement hypothesis and timeline specialist flow

**Files:**

- Create: `scripts/ui/validation_hypothesis_board.gd`
- Create: `scenes/ui/validation_hypothesis_board.tscn`
- Create: `scripts/ui/validation_timeline_evidence.gd`
- Create: `scenes/ui/validation_timeline_evidence.tscn`
- Modify: `scripts/scenes/investigation_scene.gd`
- Modify: `data/episodes/episode_001_afterlife_station.json`
- Create: `tests/validation/validation_hypothesis_timeline_test.gd`

### Step 1: Write RED contract test

Required hypothesis IDs must be stable and verified against latest episode data.

Required evidence facts:

```text
23:57:42 victim hears personalized destination
23:59:08 first black-ticket contact
```

Required inference:

- supports blank projection
- refutes ticket as first cause
- leaves ticket carrier role unresolved

### Step 2: Add additive episode fields only

Recommended structure:

```json
"validation_case": {
  "hypotheses": [],
  "timeline_evidence": [],
  "relationship_rules": [],
  "required_eliminations": 2
}
```

Do not rename or delete existing episode fields or IDs.

### Step 3: Implement board

Board states:

- four candidates
- two eliminated
- support/refute/unresolved relations
- original-record link
- failed submission feedback without answer reveal
- resubmission

### Step 4: Implement timeline evidence

Allow ordering, source inspection, and relation submission. Separate chronological correctness from cause/carrier interpretation.

### Step 5: Save and return

Persist board/timeline snapshots and return to the explicit text-novel node.

### Step 6: Run tests

```bash
godot --headless --path . --script tests/validation/validation_hypothesis_timeline_test.gd
godot --headless --path . --script tests/investigation_scene_smoke_test.gd
```

### Step 7: Commit

```bash
git add scripts/ui/validation_hypothesis_board.gd scenes/ui/validation_hypothesis_board.tscn scripts/ui/validation_timeline_evidence.gd scenes/ui/validation_timeline_evidence.tscn scripts/scenes/investigation_scene.gd data/episodes/episode_001_afterlife_station.json tests/validation/validation_hypothesis_timeline_test.gd
git commit -m "feat: add Validation hypothesis and timeline evidence flow"
```

---

## Task 7: Implement safe-route recovery from existing minigame

**Files:**

- Modify: `scripts/scenes/minigame_scene.gd`
- Modify: `scripts/minigames/route_restore_game.gd`
- Modify: `scenes/minigame_scene.tscn`
- Create: `tests/validation/validation_route_restore_test.gd`
- Modify: `tests/minigame_scene_smoke_test.gd`
- Modify: `tests/minigame_pipeline_test.gd`

### Step 1: Write RED tests

- Route stage requires approved timeline evidence.
- Official identifier and personalized destination are distinct data types.
- Failure preserves the board and allows retry or unresolved withdrawal.
- No whole-case reset.
- Recovery entry is blocked until minimum safe route is valid.
- Existing Legacy minigame result remains readable.

### Step 2: Remove runtime-only content override for Validation data

Current `minigame_scene.gd` hard-codes the route-restore title, description, rules, and result text for `minigame_frequency_sync`.

Move Validation-specific strings into the approved episode JSON fields while preserving Legacy fallback.

### Step 3: Add explicit outcomes

```gdscript
const OUTCOME_RETRY := "retry"
const OUTCOME_WITHDRAW_UNRESOLVED := "withdraw_unresolved"
const OUTCOME_SAFE_ROUTE := "safe_route"
```

### Step 4: Save result

Persist route arrangement, failed segments, retry count, and final outcome in `validation_flow.route_state`.

### Step 5: Run tests

```bash
godot --headless --path . --script tests/validation/validation_route_restore_test.gd
godot --headless --path . --script tests/minigame_scene_smoke_test.gd
godot --headless --path . --script tests/minigame_pipeline_test.gd
```

### Step 6: Commit

```bash
git add scripts/scenes/minigame_scene.gd scripts/minigames/route_restore_game.gd scenes/minigame_scene.tscn data/episodes/episode_001_afterlife_station.json tests/validation/validation_route_restore_test.gd tests/minigame_scene_smoke_test.gd tests/minigame_pipeline_test.gd
git commit -m "feat: adapt route restoration for Validation flow"
```

---

## Task 8: Implement two-pattern Validation recovery mode

**Files:**

- Modify: `scripts/scenes/battle_scene.gd`
- Modify: `scenes/battle_scene.tscn`
- Modify: `data/episodes/episode_001_afterlife_station.json`
- Create: `tests/validation/validation_recovery_patterns_test.gd`
- Modify: `tests/battle_scene_smoke_test.gd`

### Step 1: Write RED tests

For each pattern store independently:

- telegraph
- classification
- linked record
- neutral action
- field outcome
- reasoning outcome
- recovery used

Pattern IDs:

- `recovery_nonexistent_terminus`
- `recovery_black_ticket_imprint`

Verify:

- only two patterns in Validation
- no ability names, success percentages, or companion prediction on first choice
- first wrong response offers one recovery
- second failure records danger case and proceeds to result
- Legacy four-pattern mode remains unchanged

### Step 2: Add explicit mode

```gdscript
const MODE_LEGACY := "legacy"
const MODE_VALIDATION := "validation"
```

### Step 3: Add classification and action data to episode JSON

Do not encode answer reasoning in button labels.

### Step 4: Separate outcomes

Never use one boolean for both field success and reasoning validation.

```gdscript
{
    "field_outcome": "stabilized" | "failed",
    "reasoning_outcome": "verified" | "refuted" | "unresolved",
}
```

### Step 5: Run tests and visual capture

```bash
godot --headless --path . --script tests/validation/validation_recovery_patterns_test.gd
godot --headless --path . --script tests/battle_scene_smoke_test.gd
```

### Step 6: Commit

```bash
git add scripts/scenes/battle_scene.gd scenes/battle_scene.tscn data/episodes/episode_001_afterlife_station.json tests/validation/validation_recovery_patterns_test.gd tests/battle_scene_smoke_test.gd
git commit -m "feat: add two-pattern Validation recovery mode"
```

---

## Task 9: Implement result axes and main-menu return

**Files:**

- Modify: `scripts/scenes/result_scene.gd`
- Modify: `scenes/result_scene.tscn`
- Modify: `scripts/core/game_state.gd`
- Create: `tests/validation/validation_result_axes_test.gd`
- Modify: `tests/result_scene_smoke_test.gd`

### Step 1: Write RED tests

- Raw four axes are saved.
- Summary is derived, not authoritative.
- Unverified/refuted rule validation caps summary at temporary stabilization.
- Report/manual/research/provisioning candidates apply once.
- Validation completion returns to main menu, not preparation half-day.
- Legacy result return remains unchanged.

### Step 2: Add pure result calculator

Create inside `validation_flow_state.gd` or a new `scripts/core/validation_result_calculator.gd` if the function exceeds one responsibility.

```gdscript
func calculate_summary(result_axes: Dictionary) -> String
```

### Step 3: Build progressive result UI

First view:

- four axis statuses
- one-line reason each
- summary and one-line conclusion

Collapsed details:

- verified/refuted/unresolved evidence
- report/manual changes
- one research question
- one provisioning candidate
- next-day impact

### Step 4: Complete once

Use stable effect IDs:

- `validation_report_afterlife_station`
- `validation_manual_afterlife_station`
- `validation_research_signal_identity`
- `validation_supply_dead_frequency_filter`

### Step 5: Run tests

```bash
godot --headless --path . --script tests/validation/validation_result_axes_test.gd
godot --headless --path . --script tests/result_scene_smoke_test.gd
```

### Step 6: Commit

```bash
git add scripts/scenes/result_scene.gd scenes/result_scene.tscn scripts/core/game_state.gd scripts/core/validation_flow_state.gd tests/validation/validation_result_axes_test.gd tests/result_scene_smoke_test.gd
git commit -m "feat: add Validation result axes and completion return"
```

---

## Task 10: Add end-to-end regression, accessibility, and playtest build

**Files:**

- Create: `tests/validation/validation_end_to_end_test.gd`
- Create: `tests/validation/validation_save_restart_matrix_test.gd`
- Create: `tests/validation/validation_hidden_feature_no_effect_test.gd`
- Create: `tests/validation/validation_accessibility_test.gd`
- Create: `.github/workflows/validate-validation-cut.yml`
- Create: `.github/workflows/capture-validation-cut-visuals.yml`
- Modify: `TEST_CHECKLIST.md`
- Modify: `docs/CURRENT_STATUS.md` only after implementation evidence exists
- Modify: `docs/CURRENT_HANDOFF_VALIDATION_2026-08-01.md`

### Step 1: Write RED end-to-end test

Run the approved sequence and assert each stage transition.

### Step 2: Write save restart matrix

Save and restore at:

- SIT-001 after cold open
- SIT-003 after preparation
- SIT-004 after required record
- SIT-005 after first hypothesis submission
- SIT-006 after failed route
- SIT-007 after first pattern and after recovery use
- SIT-008 before and after report application

### Step 3: Write hidden-feature no-effect test

Snapshot before and after Validation:

- random event state
- requests
- market state
- daily episode state
- relationship state
- pattern 3/4 state
- full research tree

Expected: no change unless explicitly listed in the approved result payload.

### Step 4: Add accessibility test

Assert:

- keyboard focus reaches all primary controls
- no color-only state
- Esc closes overlays
- 1280×720 critical actions visible or scroll-reachable
- 1920×1080 layout stable
- long Korean text wraps without clipping

### Step 5: Add workflow

`validate-validation-cut.yml` must run:

1. JSON parse and contract tests
2. Godot 4.7.1 import
3. Validation focused tests
4. existing CORE focused tests
5. existing ANNUAL focused tests
6. full Godot regression

`capture-validation-cut-visuals.yml` must capture:

- SCREEN-01 first run / both saves
- SCREEN-02 narration / choices / record drawer
- SCREEN-03 recommended party / changed selection
- SIT-005 hypothesis / timeline
- SIT-006 route failure / retry
- SIT-007 both patterns / recovery
- SCREEN-04 result axes / collapsed details
- 1280×720 and 1920×1080

### Step 6: Run all local validation

```bash
python -m unittest discover -s tests -p "test_*.py"
godot --headless --path . --editor --quit
godot --headless --path . --script tests/validation/validation_end_to_end_test.gd
godot --headless --path . --script tests/validation/validation_save_restart_matrix_test.gd
godot --headless --path . --script tests/validation/validation_hidden_feature_no_effect_test.gd
godot --headless --path . --script tests/validation/validation_accessibility_test.gd
```

Then run the repository's existing full regression command exactly as defined in the current workflow.

### Step 7: Run adversarial review

Attack:

- Target/Legacy mixed branches
- duplicate save effects
- automatic answer leakage
- hidden background systems
- softlocks
- 720p clipping
- stale Canon/Sheet status

### Step 8: Commit

```bash
git add tests/validation .github/workflows/validate-validation-cut.yml .github/workflows/capture-validation-cut-visuals.yml TEST_CHECKLIST.md docs/CURRENT_HANDOFF_VALIDATION_2026-08-01.md
git commit -m "test: add Validation end-to-end and accessibility gates"
```

Do not update `CURRENT_STATUS.md` to implemented until the branch has actual passing evidence.

---

## Task 11: Prepare the human Validation package execution

**Files:**

- Modify: `docs/validation/VALIDATION_SCREEN_SIT_PLAYTEST_PACKAGE_2026-08-01.md`
- Create: `docs/validation/VALIDATION_SCREEN_SIT_PLAYTEST_RESULTS.md`
- Modify: `docs/CURRENT_STATUS.md` only after sessions are actually complete
- Modify: Google Sheet `80_데모_버티컬슬라이스_플레이테스트`

### Step 1: Freeze build evidence

Record:

- commit
- workflow runs
- artifact IDs
- save samples
- resolution captures

### Step 2: Run six new-player sessions

Follow T0–T10 without answer intervention.

### Step 3: Record behavior and self-report separately

Use anonymized P01–P06 IDs.

### Step 4: Apply gate

```text
KEEP / CHANGE / RETEST / HOLD
```

No `POC_PASSED` unless all required behavior, save, accessibility, and P0/P1 gates pass.

### Step 5: Commit results

```bash
git add docs/validation/VALIDATION_SCREEN_SIT_PLAYTEST_PACKAGE_2026-08-01.md docs/validation/VALIDATION_SCREEN_SIT_PLAYTEST_RESULTS.md docs/CURRENT_STATUS.md
git commit -m "docs: record Validation playtest evidence"
```

---

## Cross-package rollback contract

- Every package has an independent commit and PR review checkpoint.
- Never delete Legacy code/tests before the replacement package and full regression pass.
- Save rollback removes only the Validation save file and optional state object; it must not touch `mvp-039`.
- Data rollback removes only additive `validation_case` fields.
- Scene rollback restores mode routing without deleting existing Scene files.
- If a package requires changing project identity, case answer, platform, or save compatibility, return `CHANGE_PROPOSAL` to GPT.

## Completion gate

The implementation is complete only when:

- PACKAGE-01~10 are merged sequentially
- Documentation/Validation/CORE/ANNUAL/full regression pass
- product protected paths changed only by approved packages
- review threads 0
- save restart matrix pass
- 1280×720 and 1920×1080 pass
- hidden feature side effects 0
- human playtest has an explicit KEEP/CHANGE/RETEST/HOLD result

Until then:

```text
POC_PASSED = NOT_DECLARED
production_expansion = NOT_APPROVED
Base v9.3 merge = HOLD
```
