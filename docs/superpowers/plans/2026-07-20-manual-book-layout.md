# Manual Book Layout Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Apply the approved left-field / centre-play / right-manual-book layout to the dialogue, mini-game, and recovery screens without changing game rules or save data.

**Architecture:** Reuse the existing `manual_book_frame.png` and Afterlife theme in a presentation-only `AnomalyManualDrawer` that supports a persistent right-side book mode. The route restoration and generic mini-game builders place their contextual facts inside that book; the recovery scene moves only visual Controls while retaining `GameState` as the sole rules and save owner.

**Tech Stack:** Godot 4.7, GDScript, existing Control scenes, headless scene tests, `ui_visual_capture.gd`.

## Global Constraints

- Do not modify `project.godot`, `scripts/core/game_state.gd`, `data/episodes/**`, game save schema, or approved content assets.
- Preserve the mini-game child controls, recovery action response grid, keyboard controls, and existing player-facing Korean text semantics.
- The right book is persistent at 1280×720; only its inner page content scrolls.
- Capture one in-game PNG for the mini-game and one for recovery after the layout is implemented.

---

### Task 1: Define the presentation contract with a failing scene test

**Files:**
- Create: `tests/manual_book_layout_test.gd`
- Modify: `scripts/ui/anomaly_manual_drawer.gd`

- [ ] Add assertions for persistent book mode, the book frame, and a scrollable content host.
- [ ] Run the test and confirm it fails before the new public methods exist.
- [ ] Implement the smallest presentation-only book API and rerun the test.

### Task 2: Apply the layout to mini-games

**Files:**
- Modify: `scripts/scenes/minigame_scene.gd`
- Modify: `tests/minigame_scene_smoke_test.gd`

- [ ] Add assertions that both route restoration and rain dodge produce a left field panel, central play host, and persistent manual book.
- [ ] Run the smoke test and confirm the layout assertions fail.
- [ ] Rebuild each mini-game screen around the approved three-column shell, keeping the existing game controls and completion pipeline intact.
- [ ] Rerun the mini-game smoke test for both episode routes.

### Task 3: Apply the layout to recovery

**Files:**
- Modify: `scenes/battle_scene.tscn`
- Modify: `scripts/scenes/battle_scene.gd`
- Modify: `tests/mvp043_recovery_loop_test.gd`

- [ ] Add assertions that the recovery scene has the field visual, central recovery play host, persistent manual book, and the three-card action row.
- [ ] Run the recovery loop test and confirm the new layout assertions fail.
- [ ] Move presentation controls into the three-column shell; bind evidence, prediction, and support records to the persistent book without touching `GameState` logic.
- [ ] Rerun the recovery loop test and the cinematic UI contract test.

### Task 4: Capture and verify the delivered experience

**Files:**
- Create: `docs/qa/captures/manual-book-layout/minigame.png`
- Create: `docs/qa/captures/manual-book-layout/recovery.png`
- Modify: relevant UX/UI and QA source documents found through `DOCUMENTATION_MAP.md`

- [ ] Run the existing capture runner for the mini-game and recovery state.
- [ ] Visually inspect both 1280×720 captures for Korean wrapping, visible book pages, unobscured play area, and accessible choices.
- [ ] Run targeted tests, a headless import check, and `git diff --check`.
