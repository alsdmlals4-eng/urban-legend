# Recovery active-time implementation plan

**Goal:** Execute approved §11.6: danger advances once per 12 active seconds, reading pauses the field, closing never resumes automatically.
**Architecture:** GameState owns persisted fractional elapsed time inside existing recovery_clock_state. Battle owns active/paused/resume-pending lifecycle and calls the time owner only while playable. Existing overlay exposes read-only blocking visibility; existing audio and cut-in consume the same paused state. No global SceneTree pause affecting unrelated autoloads.
**Tech stack:** Godot 4.7 GDScript, existing battle/overlay and save dictionary.
**Spec:** `docs/superpowers/specs/2026-09-10-daily-case-structure-design.md` §11.6. Current user approved continuation; no repeated approval ceremony.

## Preflight and alternatives

Current owner: GameState.begin_recovery_clock_turn adds danger after the first turn; actual battle calls it. Current manual/operation panes leave actions and audio live. Existing minigame explicit resume is REUSE evidence. Schema is additive `active_seconds` remainder, default 0 for older saves; no world/rule/reward ID changes. Old no-argument turn API remains compatibility, actual battle uses `begin_recovery_clock_turn(false)` to avoid double charging.

1. Keep turn pressure REJECT: contradicts approved active-time requirement.
2. Globally pause tree ADAPT_NOT_SELECTED: can pause UI/autoloads/transition behavior outside this scene.
3. Scene-owned gate + explicit GameState time ADAPT: bounded changes, preserves fractional time, action signals explicitly guarded. Selected.

Benchmark VERIFIED 2026-09-13: [FTL developer Steam description](https://store.steampowered.com/app/212680/FTL_Faster_Than_Light/) allows tactical mid-combat pause; ADAPT thinking without time loss, REJECT ship/permadeath systems. [Godot pause documentation](https://docs.godotengine.org/en/stable/tutorials/scripting/pausing_games.html) states signals still execute on non-processing nodes; ADOPT explicit action guards and audio pause, rather than timer-only blocking.

## Tasks

- [ ] State test first: `tests/recovery/recovery_active_time_test.gd`. Assert 11.5+0.5 => danger1; no free elapsed reset on response; active remainder save/load; missing/NaN default; max-danger escalation uses existing 8 damage/3 fallback. Add `advance_recovery_clock_time(delta)` and compatibility argument to begin turn. Invalid/non-finite delta is ignored.
- [ ] Scene test first: `tests/recovery/recovery_active_scene_test.gd`. Actual M04 battle, manual/operation panes, pause button and focus out/in. Same active time yields same clock; underlying response/support/consumable inputs cannot mutate while paused. Resume waits for Enter/Space/mouse/navigation release. Audio paused and cut-in lifetime preserved. Danger warning visible, result objective never erased by escalation.
- [ ] Wire `battle_scene.gd` and `canon_v2_operation_overlay.gd`. Add 12-second countdown/pause/resume control to existing footer. On max danger reuse existing surge damage path, no new damage on ordinary tick; no turn-based extra pressure. Pause during confirmation/terminal state; preserve selected response/draft.
- [ ] Run new tests, legacy clock/state/direct/guided/withdrawal/save flows, GUT, Python discovery. Render 1280×720 and requested1920×1080, inspect actual dimensions. Review twice and repair regressions. Update current handoff, commit only owned paths, push/readback work branch. Other PRs/main/Base pin/user imports untouched.

Rollback: revert coherent commit, old readers ignore optional elapsed field. Full game/human/art/release completion not implied. Reset occurs only at existing case clock reset, not menu open, action, or scene re-entry.

## Execution / correction readback

State and scene tests were written first (missing API/control RED1 each), followed by implementation. Legacy turn-only assertion was updated to verify zero turn cost plus active-time charge. 108.5 seconds grouped versus partitioned into nine intervals plus 0.5 produce equal state/two surges. Saved NaN normalizes to zero.

Review1: time/save/input/audio/cut-in and max-danger warning. Review2: actual operation support button revealed a new dead end because read-only pause blocked its only consumer (RED2). ADAPT existing support selection into a pending scene-local command, close drawer, execute once through explicit released-input resume. Same choice toggles cancellation (RED1); another choice replaces it. No outcome while reading or saved pending effects. Existing M04 UI regression's rest-schedule gate contradicted approved design §5/basic support; migrated its assertions and kept real one-use/status readback.

Verification evidence and ceilings are recorded in the current handoff. New state/scene and clock regressions, manual/minigame/withdrawal/save flows, full Python490 and GUT27/144 passed. Some old/headless paths still show ObjectDB2–4 exit warnings; no warning-free whole-suite claim. Actual renderer captures are1280×720 and1920×1061, not true1920×1080. Scene fixture uses injected elapsed/Window signals; physical Alt-Tab and ordinary player full journey NOT_RUN. No final-art or whole-game completion. Source changes and tests are ready for bounded work-branch publication; merge/main remains separate.
