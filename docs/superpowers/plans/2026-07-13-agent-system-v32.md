# Ver 3.2 Agent System Implementation Plan

> **For agentic workers:** Implement test-first and preserve existing two-case flow, save compatibility, and anomaly stabilization language.

**Goal:** Add five agent abilities, per-case health/mental state, contextual investigation checks, tactical recovery actions, preparation roster/details, and Ver 3.2 migration.

**Architecture:** Episode JSON remains the source for agent profiles and contextual choices. `GameState` owns saved case state and all modifier/effect calculations. Scene scripts only render state and dispatch actions.

**Tech Stack:** Godot 4.7 stable, GDScript, JSON, PC 16:9.

## Global Constraints

- Abilities are `suppression/analysis/protection/treatment/rapport`, displayed as `제압/분석/방호/치료/교감`, range 1..5.
- Agent max HP/mental: Kang 120/80, Kwon 85/120, Oh 100/100.
- No death, permanent injury, progression, swappable personal loadout, third episode, or generic RPG kill/damage framing.
- Existing saves default current HP/mental to profile maxima. New display/save version is Ver 3.2 / MVP-032 / `mvp-032`.
- Main menu contains start, continue, settings, and DB only; start routes to preparation.
- Preparation owns 2..3 agent selection and profile details.
- Investigation uses the approved scene-first A layout and shows abilities only on contextual choices.
- Recovery exposes all five tactical actions and shares state with investigation.

## Task 1: Tests and data contract

- Add a headless test covering profile schema, ability bounds, default/migrated state, health/mental clamping, incapacitated/panic rules, protection consumption, best-agent modifier, and save round trip.
- Add the approved profile fields to both episode JSON files, keeping identical shared profiles.
- Add contextual `approach_type` and tags to existing investigation methods; map destruction→suppression, analysis→analysis, observation→analysis/protection/rapport by scene meaning.

## Task 2: GameState state and resolution

- Add saved dictionaries for agent case states and victim state.
- Provide initialization, lookup, clamped change/heal, protection, action availability, best-agent, aspect modifier, contextual option label, and recovery-action resolution APIs.
- Basic effects: suppression `4 + ability*2`; analysis `3 + ability*2`; protection `5 + ability*3`; treatment HP `6 + ability*4`; rapport mental `6 + ability*4`.
- HP 0 means injured/inactive; mental 0 means panic/inactive. If all selected agents are inactive, return to investigation without losing clues or state.

## Task 3: Main menu and preparation

- Remove agent controls and selection gating from main menu. New game initializes the default episode and routes to preparation; continue preserves saved scene.
- Add roster cards and a detail pane to preparation: portrait, HP/mental, five bars, equipment, skills, aspects, backstory, and select/deselect action.
- Preserve team equipment as a separate section.

## Task 4: Investigation scene

- Replace the three-column dashboard with scene-first overlays: team left, scene center, clues right, contextual choices/results bottom.
- Show responsible agent, ability, ability value, aspect modifier and reason only when method choices appear.
- Preserve clue, hint, minigame, resolution, trust, result, runtime editor and navigation behavior.

## Task 5: Recovery scene

- Replace existing generic actions with five actions using GameState resolution.
- Show representative agent HP/mental and allow representative/target selection.
- Apply protection before hostile reaction; treatment/rapport recover valid targets; preserve recovery threshold and result transition.

## Task 6: Version, documentation, Base proposal and verification

- Update Ver 3.2, MVP-032, save version and migration notes.
- Update benchmark packet and implementation report with Lobotomy Corporation plus four existing references and explicit exclusions.
- Verify JSON, test scripts, project parse, all primary scenes, two resolutions, 1280x720 and 1920x1080 visual QA, save/continue and corrupt/missing new fields.
