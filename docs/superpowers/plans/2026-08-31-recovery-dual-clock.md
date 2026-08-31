# Recovery Dual Clock Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a saved, recovery-only six-segment danger clock and an eight-segment visual mapping of existing anomaly stability to the shared Godot recovery screen.

**Architecture:** `GameState` owns only the persisted danger-clock snapshot and continues to own existing stability/save data. `BattleScene` resolves feedback and the existing representative-agent consequence. A focused native `RecoveryClock` Control renders radial segments without a new image, data, or UI framework. The current `telegraph → hypothesis → evidence → response` flow stays the only semantic evaluator.

**Tech Stack:** Godot 4.7, GDScript, existing Theme/Control scene composition, JSON save data, headless SceneTree regression tests.

**Spec:** `docs/superpowers/specs/2026-08-31-recovery-dual-clock-design.md`

> **Execution update — 2026-08-31:** Tasks 1–5 are implemented on this worktree. Focused state/scene/overlay/bridge/result/M04-route regressions passed, and the retained M04 GPU captures demonstrate the live cutout and clock composition. The unchecked boxes below preserve the original red→green execution history; they are not remaining implementation work. Human visual/accessibility QA and release-rights review remain separate `NOT_RUN` gates.

## Global Constraints

- Work only in the linked `codex/m04-playable-vertical-slice-20260831` worktree.
- Preserve `case_anomaly_stability`, `stability_schema_version`, episode IDs, manual records, M04 data, preparation `0/1`, and result semantics.
- Do not reuse `investigation_risk` as recovery danger and do not create a semantic-answer UI.
- Advance danger by recovery turns, never real elapsed seconds.
- Persist only `recovery_clock_state: { danger, turn_count, surge_count }`; old saves default safely to zero.
- A 6/6 unresolved danger surge costs 8 representative mental points after existing protection, resets danger to 3, and never ends recovery.
- New production behavior requires a test that failed for the missing behavior first.
- Keep generated Godot cache/import artifacts untracked and clean only this worktree after verification.

---

### Task 1: Persist the recovery danger clock

**Files:**
- Create: `tests/recovery/recovery_clock_state_test.gd`
- Modify: `scripts/core/game_state.gd`

**Interfaces:**
- Produces: `get_recovery_clock_state() -> Dictionary`, `begin_recovery_clock_turn() -> Dictionary`, `resolve_recovery_clock_outcome(correct: bool, verified: bool) -> Dictionary`, `reset_recovery_clock_state() -> void`.

- [ ] **Step 1: Write the failing test**

```gdscript
game_state.reset_run_state()
_expect(int(game_state.get_recovery_clock_state().get("danger", -1)) == 0, "new runs start danger at 0")
game_state.begin_recovery_clock_turn()
_expect(int(game_state.get_recovery_clock_state().get("danger", -1)) == 0, "first telegraph does not advance danger")
game_state.begin_recovery_clock_turn()
_expect(int(game_state.get_recovery_clock_state().get("danger", -1)) == 1, "second telegraph advances danger")
var verified := game_state.resolve_recovery_clock_outcome(true, true)
_expect(int(verified.get("danger", -1)) == 0, "verified response relieves one danger segment")
```

- [ ] **Step 2: Run test to verify RED**

```powershell
& 'C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe' --headless --path . --script res://tests/recovery/recovery_clock_state_test.gd
```

Expected: fail because the public clock API does not exist.

- [ ] **Step 3: Implement the smallest state API**

Add a dictionary with default `danger: 0`, `turn_count: 0`, `surge_count: 0`. Advance only when `turn_count` was positive; verified success subtracts one; successful but unverified response is neutral; wrong response adds two, all clamped. Reset it from `reset_recovery_pattern_state()`.

- [ ] **Step 4: Verify GREEN**

Run the same command. Expected: `RECOVERY CLOCK STATE: PASS`.

- [ ] **Step 5: Extend the same test for save compatibility before save code**

```gdscript
game_state.begin_recovery_clock_turn()
game_state.resolve_recovery_clock_outcome(false, false)
game_state.save_game()
game_state.reset_run_state()
_expect(game_state.load_game(), "clock save fixture must load")
_expect(int(game_state.get_recovery_clock_state().get("danger", -1)) == 3, "saved danger survives reload")
```

- [ ] **Step 6: Verify RED, then add additive save/load**

Write `recovery_clock_state` from `_make_save_data()` and load an empty-dictionary fallback in `load_game()`. Clamp all values. Re-run the test and expect PASS.

### Task 2: Implement the recoverable danger surge

**Files:**
- Modify: `tests/recovery/recovery_clock_state_test.gd`
- Modify: `scripts/core/game_state.gd`

**Interfaces:**
- Produces: outcome dictionary keys `danger`, `surge_triggered`, `surge_damage`.

- [ ] **Step 1: Write the failing surge test**

```gdscript
game_state.reset_recovery_clock_state()
for _turn in range(4):
    game_state.begin_recovery_clock_turn()
    game_state.resolve_recovery_clock_outcome(false, false)
var surge := game_state.resolve_recovery_clock_outcome(false, false)
_expect(bool(surge.get("surge_triggered", false)), "unresolved max danger triggers one surge")
_expect(int(surge.get("surge_damage", 0)) == 8, "surge damage is fixed at 8")
_expect(int(surge.get("danger", -1)) == 3, "surge resets danger to 3 instead of ending recovery")
```

- [ ] **Step 2: Verify RED**

Run `tests/recovery/recovery_clock_state_test.gd`. Expected: no surge event exists and danger remains at six.

- [ ] **Step 3: Implement and verify GREEN**

At danger six, return a surge unless the current outcome is both correct and verified. Averted verified success subtracts normally. An unresolved surge increments `surge_count`, returns `surge_damage: 8`, stores danger three, and does not touch stability, recovery results, or agent state.

### Task 3: Connect outcomes to the live recovery scene

**Files:**
- Create: `tests/recovery/recovery_dual_clock_scene_test.gd`
- Modify: `scripts/scenes/battle_scene.gd`

**Interfaces:**
- Consumes: GameState clock API; `_select_pattern_response(response)`; `_begin_recovery_turn(previous_result)`.
- Produces: `StabilityClock`, `DangerClock`, `StabilityClockLabel`, `DangerClockLabel`; post-response clock feedback.

- [ ] **Step 1: Write the failing scene assertions**

```gdscript
_expect(current_scene.find_child("StabilityClock", true, false) != null, "recovery HUD renders an eight-segment stability clock")
_expect(current_scene.find_child("DangerClock", true, false) != null, "recovery HUD renders a six-segment danger clock")
_expect((current_scene.find_child("StabilityClockLabel", true, false) as Label).text.contains("/8"), "stability label exposes segmented progress")
_expect((current_scene.find_child("DangerClockLabel", true, false) as Label).text.contains("/6"), "danger label exposes segmented pressure")
```

- [ ] **Step 2: Verify RED**

```powershell
& 'C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe' --headless --path . --script res://tests/recovery/recovery_dual_clock_scene_test.gd
```

Expected: named controls do not exist while the old linear bars do.

- [ ] **Step 3: Implement state transitions**

Start a clock turn only after selecting a new pattern and before rendering its telegraph. After evaluation, resolve `(correct, verified)`, apply returned surge damage through the existing representative/protection path, append post-resolution explanation only, then use the current save point. Opening the manual, drawer, or decision substeps must not tick danger.

- [ ] **Step 4: Verify GREEN**

Extend the test through one authored verified guided response and assert danger decreases. Force an unresolved max state through the public clock API, resolve a wrong response, and assert `공명 폭주` appears while the recovery scene stays active.

### Task 4: Replace HUD bars with native radial clocks

**Files:**
- Create: `scripts/ui/recovery_clock.gd`
- Modify: `scenes/battle_scene.tscn`
- Modify: `scripts/scenes/battle_scene.gd`
- Modify: `tests/recovery/recovery_dual_clock_scene_test.gd`

**Interfaces:**
- Consumes: `RecoveryClock.set_clock(value: int, total: int, urgent: bool) -> void`.
- Produces: segmented native radial drawing and named HUD nodes refreshed by `_update_battle_view(message)`.

- [ ] **Step 1: Write failing visual-contract assertions**

```gdscript
var stability_clock := current_scene.find_child("StabilityClock", true, false)
var danger_clock := current_scene.find_child("DangerClock", true, false)
_expect(int(stability_clock.get("total_segments")) == 8, "stability clock has eight immutable segments")
_expect(int(danger_clock.get("total_segments")) == 6, "danger clock has six immutable segments")
_expect(not current_scene.has_node("RecoveryHud/StatusRow/StabilityBar"), "legacy stability bar is no longer consumed")
_expect(not current_scene.has_node("RecoveryHud/StatusRow/FearBar"), "legacy danger bar is no longer consumed")
```

- [ ] **Step 2: Verify RED, then implement**

Create `RecoveryClock` as a narrow native `Control` that draws `total_segments` colored ring wedges. Replace the two `ProgressBar` nodes with labelled clock groups. Map stability by `ceil(stability / threshold * 8)` and danger directly from GameState. Preserve representative label and clue drawer at 1280×720.

- [ ] **Step 3: Verify GREEN and focused regressions**

```powershell
& 'C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe' --headless --path . --script res://tests/recovery/recovery_dual_clock_scene_test.gd
& 'C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe' --headless --path . --script res://tests/mvp043_recovery_loop_test.gd
& 'C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe' --headless --path . --script res://tests/m04/m04_playable_investigation_recovery_route_test.gd
```

### Task 5: Reconcile canon, review adversarially, and clean this worktree

**Files:**
- Modify: `docs/design/PROJECT_AI_PRODUCTION_SPEC.md`
- Modify: `docs/CURRENT_PLANNING_CANON.md`
- Modify: `docs/CURRENT_HANDOFF.md`
- Modify: `TEST_CHECKLIST.md`

- [ ] **Step 1: Update canon only after code is green**

Record the clocks, turn-only time, surge, compatibility, and no-answer-reveal rule. Mark executed automation only as machine evidence; retain Human/new-player/accessibility/release as `NOT_RUN`.

- [ ] **Step 2: Verify import and broad regressions**

```powershell
& 'C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe' --headless --path . --import
bash tests/run_godot_regression.sh
python -m unittest tests/test_base_operating_sync.py tests/test_skill_package_integrity.py tests/test_active_document_references.py tests/test_core_validation_contract.py
git diff --check
```

- [ ] **Step 3: Complete five adversarial loops**

For each loop, re-read changed code and results for time ticking during reading, success negation at 6/6, global-risk reuse, duplicate stability state, old-save loss, answer disclosure, HUD occlusion, and generated cache. Fix every real finding with a new failing test first. Stop only when all five loops find no blocker.

- [ ] **Step 4: Clean only generated artifacts after dry-run verification**

```powershell
git restore --worktree -- ':(glob)**/*.import' 'project.godot'
git -c core.longpaths=true clean -n -d -x
git -c core.longpaths=true clean -f -d -x
```

Confirm the dry run lists only generated cache inside this linked worktree before the final clean. Never clean Base or the primary checkout.

- [ ] **Step 5: Commit and exact-head retest**

Commit the code, test, and canonical-document changes on the current branch. Record the exact commit SHA, then rerun the focused state, scene, recovery-loop, and M04 route tests at that SHA.
