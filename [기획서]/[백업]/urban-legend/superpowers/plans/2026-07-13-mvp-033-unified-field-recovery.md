# Ver 3.3 Unified Field and Recovery Implementation Plan

**Goal:** Merge dialogue and investigation into a continuous field scene, then replace fixed recovery abilities with telegraph-driven response turns while preserving old saves and entry points.

**Architecture:** Episode JSON owns `field_nodes` and `recovery_patterns`. `GameState` owns migration, prediction streaks, pattern selection, learning, auto-action chances, stability, and save persistence. Scene scripts only render state and dispatch choices.

## Guardrails

- Preserve `dialogue_nodes`, `investigation_points`, and `current_dialogue_node_id` as compatibility inputs.
- Stability schema 2 means `0 = unstable`, `100 = fully stabilized`; migrate schema 1 exactly once.
- Apply a field choice's effects once, before its 3–5 line aftermath; dialogue playback never reapplies effects.
- Prediction never returns false information. A miss reveals only the telegraph.
- Failure records a reusable reason and does not block progress.
- Do not touch the user's modified `tests/test_agent_system.tscn` or untracked `.superpowers/` assets.

## Tasks

1. Add headless tests for field/pattern schema, legacy mapping, prediction fairness, pattern order, learning, auto-action chance, stability migration, and save round trip.
2. Add `CaseData` accessors and both episode data sets.
3. Add compatible field, pattern, prediction, auto-action, stability, and persistence APIs to `GameState`.
4. Redirect legacy dialogue entry to the unified investigation scene.
5. Rebuild investigation as a two-column scene with inline dialogue/choices and a closable record drawer.
6. Rebuild recovery as telegraph → prediction → contextual response → consequence, and repair recovery completion routing.
7. Update Ver 3.3 / MVP-033 / mvp-033 documentation and benchmark packet.
8. Run headless data, state, scene, save, and visual smoke checks before integration.
