# Episode Action Minigames Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the sequence-button prototype with a shrinking-circle rhythm game for Afterlife Station and an arrow-key rain-dodging game for Red Umbrella Alley while preserving the existing result pipeline.

**Architecture:** Keep `minigame_scene.gd` as a host and split gameplay into two focused `Control` scripts. Put deterministic timing and collision decisions in a pure `RefCounted` rules class exercised by a headless Godot test script before UI implementation.

**Tech Stack:** Godot 4.7 stable, GDScript, code-drawn `Control` visuals, JSON episode configuration.

## Global Constraints

- PC baseline is `1280x720`, mouse/keyboard, Steam release target.
- Preserve `res://scenes/minigame_scene.tscn` and the existing `GameState.save_minigame_result()` pipeline.
- Failure must never block investigation or recovery.
- No new episode, save migration, HTML dashboard, complex rhythm chart, physics engine, or large art pipeline.
- Refactor only the minigame responsibilities and directly duplicated formatting.

---

### Task 1: Deterministic Minigame Rules

**Files:**
- Create: `tests/minigame_rules_test.gd`
- Create: `scripts/minigames/minigame_rules.gd`

**Interfaces:**
- Produces: `is_rhythm_hit(radius, target, tolerance)`, `clamp_player_position(position, bounds, player_size)`, `rects_overlap(a, b)`, `is_rain_success(elapsed, duration, hits, max_hits)`.

- [ ] Write a headless test covering hit-window boundaries, player clamping, overlap, survival success and hit-limit failure.
- [ ] Run `Godot_v4.7-stable_win64_console.exe --headless --path . --script res://tests/minigame_rules_test.gd` and verify RED because the rules script is missing.
- [ ] Implement the four pure rules with no scene dependency.
- [ ] Run the same command and verify all assertions pass.

### Task 2: Afterlife Station Rhythm Control

**Files:**
- Create: `scripts/minigames/rhythm_timing_game.gd`
- Modify: `data/episodes/episode_001_afterlife_station.json`

**Interfaces:**
- Consumes: `MinigameRules.is_rhythm_hit()`.
- Produces: signals `completed(successful: bool, details: Dictionary)` and `status_changed(text: String, progress: float)`.

- [ ] Change episode type to `rhythm_timing` and add `round_count=5`, `required_hits=3`, `beat_duration=1.4`, and radius/tolerance values.
- [ ] Draw a stable target circle, shrinking ring, hit feedback and compact score.
- [ ] Accept `Space`/`Enter`; count late/no input as misses; widen tolerance when equipment assist is true.
- [ ] Emit completion details with hit/miss counts and accuracy.
- [ ] Run the rules test and direct minigame scene headless check.

### Task 3: Red Umbrella Rain-Dodge Control

**Files:**
- Create: `scripts/minigames/rain_dodge_game.gd`
- Modify: `data/episodes/episode_002_red_umbrella_alley.json`

**Interfaces:**
- Consumes: `MinigameRules.clamp_player_position()`, `rects_overlap()`, and `is_rain_success()`.
- Produces: the same `completed` and `status_changed` signals as the rhythm control.

- [ ] Change episode type to `rain_dodge` and add `duration=12`, `max_hits=3`, movement speed and spawn interval values.
- [ ] Draw a rainy alley playfield, umbrella marker, falling rain and hit feedback.
- [ ] Move with arrow keys, clamp to the playfield, remove collided/offscreen drops, and grant one shield when equipment assist is true.
- [ ] Emit completion details with elapsed time, hits, dodged drops and shield use.
- [ ] Run the rules test and direct minigame scene headless check.

### Task 4: Host Refactor and Existing Pipeline

**Files:**
- Modify: `scripts/scenes/minigame_scene.gd`
- Modify: `scripts/ui/main_menu.gd`
- Modify: `scripts/scenes/result_scene.gd` only if summary wording requires it.
- Modify: `scripts/ui/database_view.gd` only if summary wording requires it.

**Interfaces:**
- Consumes: both game controls' common signals.
- Produces: the unchanged call `GameState.save_minigame_result(minigame_id, successful, details)`.

- [ ] Remove sequence-button state and dispatch the child game by JSON `type`.
- [ ] Make the center playfield dominant and keep rules/results in compact side panels.
- [ ] On completion, merge gameplay details with the existing effect summary, disable gameplay, show a clear return button and save once.
- [ ] Update the Ver 3.0 notice to describe rhythm and rain-dodge controls.
- [ ] Verify recovery, report and DB code still read the stored result without migration.

### Task 5: Documentation and Verification

**Files:**
- Modify: `README.md`
- Modify: `TEST_CHECKLIST.md`

- [ ] Replace sequence-button instructions with exact rhythm and rain-dodge controls and success/failure conditions.
- [ ] Run JSON parsing, the pure rules test, full project headless load, and all changed scenes.
- [ ] Visually verify both games at PC 16:9, including successful and failed outcomes without overlap.
- [ ] Inspect `git diff --check`, changed-file scope, stale sequence wording and save/result contract references.
