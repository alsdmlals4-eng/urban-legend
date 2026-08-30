# CASE-01 Player-Authored Manual Workbench Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: use `superpowers:executing-plans` to execute this plan task by task. Tasks use checkbox (`- [ ]`) tracking.

**Goal:** Let a player compose and revise a source-gated deduction manual for CASE-01, then carry that authored hypothesis into the existing rescue and recovery loop without showing an answer or automating the outcome.

**Architecture:** Keep Canon V2 as the authority for evidence-backed manual pages and candidate metadata. Keep player-authored slot choices only in the pre-existing `GameState.anomaly_manual_records[episode_id].draft_slots` branch. Add a reusable policy boundary for structurally valid placement, a presentation-only full-screen `Control` workbench, and thin `InvestigationScene` integration that forwards UI intent to `GameState` and restores focus on exit.

**Tech Stack:** Godot 4.7, GDScript, Canon V2 JSON, native `Control` UI, the existing game-state save contract, GDScript regression tests, and Godot runtime visual capture.

**Spec:** `docs/superpowers/specs/2026-08-30-case01-player-authored-manual-workbench-design.md`

## Global constraints

- The user approved only the M01 vertical slice on 2026-08-30. Do not change M04, global investigation UI, story IDs, hidden answers, campaign timing, or save format versions.
- `afterlife_canon_v2.manual.filled_slots` remains empty and protected. `normal_clear.reveal_complete_manual` becomes `false`; a clear must never reveal an unwritten full answer.
- Validity means structure and earned source provenance only. The UI and policy must not expose `correct`, `wrong`, `answer`, `mutated`, compatibility/rank/recommendation, or equivalent semantic judgment.
- Reuse only existing Canon evidence record IDs. A candidate's `source_record_id` must resolve to one of those records and must have been earned before it can be placed.
- Promote only approved `HGB-AUX-09` as `M01-LUME-GUIDE-001`. The `HGB-UI-09` screenshot stays a blueprint reference and must not become a runtime texture.
- Lume is a CASE-01 procedural guide only: cute chibi silhouette, Afterlife Station outfit, source-and-sentence guidance only, no unobserved facts or answer help. Do not rename global Aka consumers.
- Run new behavior tests red first and record the expected failure before production code. Preserve the untracked `tmp/` workspace content and do not stage it.

---

### Task 1: Make the manual composition policy observable and source-safe

**Files:**
- Create: `tests/case01_ui/manual_keyword_composition_policy_test.gd`
- Create: `scripts/core/manual_keyword_composition_policy.gd`
- Modify: `data/episodes/episode_001_afterlife_station_canon_v2.json`
- Modify: `tests/shared_system/afterlife_canon_v2_loader_test.gd` (only if the existing Canon loader needs a real consumer-facing contract assertion)

- [ ] **Step 1: Write failing policy tests.** Use hand-authored miniature manual fixtures and earned-record sets to prove: an earned candidate can be placed; a missing source, another page's candidate, a duplicate candidate, and unknown IDs are rejected; a semantically plausible but non-preferred candidate is not judged by the policy.
- [ ] **Step 2: Run the focused test and observe RED.** The test must fail because `ManualKeywordCompositionPolicy` does not exist, not because a fixture or runner is malformed.
- [ ] **Step 3: Add the smallest policy boundary.** Implement `validate_manual`, `available_candidates`, and `validate_draft_slot` returning stable `{ "ok", "code" }` results. Validate only ID/page/source/duplicate invariants; never add semantic answer evaluation.
- [ ] **Step 4: Populate M01 Canon metadata.** Add only evidence-derived page segments, slot references, and a deliberately neutral candidate pool tied to existing `record_afterlife_*` evidence. Add no truth field, answer key, new evidence record, or replacement recovery rule. Set `normal_clear.reveal_complete_manual` to `false`.
- [ ] **Step 5: Run focused tests and Canon loader regression.** Confirm policy tests turn green and the Canon loader accepts the changed M01 data.

### Task 2: Persist authored drafts without changing migration state or save versions

**Files:**
- Create: `tests/case01_ui/manual_draft_persistence_test.gd`
- Modify: `scripts/core/game_state.gd`
- Modify: `tests/shared_system/afterlife_migration_integration_test.gd` (only if a real migration regression requires expansion)

- [ ] **Step 1: Write failing persistence tests.** Exercise real `GameState` serialization/loading to prove an old record defaults to empty drafts; a policy-approved placement survives a save/load round-trip; rejected placements do not write; and the Afterlife migration state still has empty `filled_slots`.
- [ ] **Step 2: Run the focused test and observe RED.** It must fail because draft API/state is absent, rather than because of a save-fixture setup error.
- [ ] **Step 3: Add minimal `GameState` APIs.** Add read/set/clear methods that ensure the existing manual record, call the policy for writes, persist only `draft_slots`, and quietly filter stale IDs on reads. Do not add a root save key, schema version, or fields in `AfterlifeMigratingGameState`.
- [ ] **Step 4: Run focused persistence and migration regressions.** Verify the real serialized state and compatibility guard remain green.

### Task 3: Promote the approved CASE-01 Lume portrait with a traceable receipt

**Files:**
- Create: `assets/ui/guides/lume_afterlife_station.png`
- Modify: `ASSET_MANIFEST.yml`
- Create: `tests/case01_ui/lume_guide_asset_receipt_test.gd` or extend the repository's real asset-manifest validator if it already owns this boundary

- [ ] **Step 1: Write an asset-receipt test first.** Verify the runtime asset ID, canonical source path, SHA-256, non-alpha 1024×1536 dimension, CASE-01-only approval scope, and declared workbench consumer. The test must operate on the manifest/parser boundary rather than grepping prose.
- [ ] **Step 2: Run it and observe RED.** It should fail because the receipt and runtime file do not yet exist.
- [ ] **Step 3: Copy the approved source unchanged and add receipt metadata.** Promote only `HGB-AUX-09` to `M01-LUME-GUIDE-001`; retain source/provenance, user approval, dimensions, SHA-256, consumer, and rollback path. Do not touch the full-screen UI reference image.
- [ ] **Step 4: Run receipt/import verification.** Confirm the file hash/dimensions, manifest consumer path, and Godot import readability.

### Task 4: Build the presentation-only full-screen dossier workbench

**Files:**
- Create: `scenes/ui/manual_deduction_workbench.tscn`
- Create: `scripts/ui/manual_deduction_workbench.gd`
- Create: `tests/case01_ui/manual_deduction_workbench_test.gd`

- [ ] **Step 1: Write failing UI-component tests.** Instantiate the real scene to prove it renders a native left index, central blank-slot buttons, equal-treatment candidate buttons, a right/lower Lume panel, and emits placement/clear/dismiss intent without owning `GameState`. Cover first focus, button focus mode, and Esc signal behavior.
- [ ] **Step 2: Run the test and observe RED.** The expected failure is missing scene/script behavior.
- [ ] **Step 3: Implement native containers only.** Build the 16:9 dossier in `Control`/`ScrollContainer`/`VBoxContainer`/`GridContainer`; draw deduction segments and selectable blank buttons from a supplied view model. Use the approved Lume texture at `LumeGuidePanel/LumePortrait`. Keep internal candidate provenance hidden from visual ordering/badges/colour.
- [ ] **Step 4: Add input and accessibility behavior.** Defer first focus to a writable slot, otherwise first candidate; make focus visible and followed by the `ScrollContainer`; emit `dismiss_requested` for Esc/close; preserve selected page and slot context in the presentation model only.
- [ ] **Step 5: Run focused scene tests.** Confirm component behavior is green without a mock-only assertion.

### Task 5: Wire M01 interaction into the current investigation scene

**Files:**
- Modify: `scenes/investigation_scene.tscn`
- Modify: `scripts/scenes/investigation_scene.gd`
- Create: `tests/case01_ui/manual_workbench_integration_test.gd`
- Modify: `tests/mvp043_investigation_ui_test.gd` only for a true affected invariant

- [ ] **Step 1: Write failing scene-integration tests.** Start the existing M01 investigation path and prove the manual action opens the workbench, its available candidates are gated by actually collected record IDs, accepted intent writes `GameState.draft_slots`, Esc closes it before broader return input, and focus returns to the invoking manual action.
- [ ] **Step 2: Run the integration test and observe RED.** It must fail for the missing workbench integration rather than test timing/setup.
- [ ] **Step 3: Add bounded M01 wiring.** Instantiate/connect `ManualDeductionWorkbench` in the investigation scene. Build its model from the current episode's Canon manual, existing local evidence records, `GameState` drafts, and the policy. Keep the legacy drawer intact for non-M01 surfaces; use the workbench only for CASE-01.
- [ ] **Step 4: Preserve existing recovery semantics.** Feed player-authored drafts into the existing evaluation context only as an authored hypothesis record if a current consumer supports it. Do not invent a response ID, shortcut candidate/verified/danger-case records, or solve recovery automatically.
- [ ] **Step 5: Run M01/UI/recovery focused regressions.** Confirm the existing recovery record writer still reports candidate/verified/danger observations and no auto-complete manual is produced.

### Task 6: Run live Godot visual/input checks and close the evidence loop

**Files:**
- Modify: `docs/CURRENT_DECISION_OVERLAY.md`
- Modify: `docs/CURRENT_STATUS.md` only if it is the actual implementation status owner
- Modify: this plan's checklist status

- [ ] **Step 1: Load the actual running Godot editor through Hera.** Read UI guidance, inspect diagnostics, and reload the changed scene safely. If no compatible live editor exists, record `RUNTIME_NOT_RUN` instead of inferring a visual PASS.
- [ ] **Step 2: Perform automated scene and data regressions.** Run the focused new tests and relevant existing M01, Canon/migration, save, and UI suites. Run the project check/import gate identified from the fresh project tooling.
- [ ] **Step 3: Capture both target resolutions.** In the running game, open the manual workbench at 1280×720 and 1920×1080; inspect Korean wrapping, candidate density, Lume frame, first focus, Esc restore, and no clipped critical controls. Preserve captures as verification evidence, not product assets.
- [ ] **Step 4: Update exact evidence status.** Mark only verified state as `IMPLEMENTED`/`AUTOMATED_*`/`RUNTIME_*`; retain `HUMAN_QA_NOT_RUN` and no claim of player comprehension. Record test commands/results, asset receipt, and rollback boundary.
- [ ] **Step 5: Run final protected-path and regression checks.** Inspect Godot diagnostics, git diff/check, focused/full available suites, and a diff review. Do not stage `tmp/`, generated `.godot/`, or unrelated user changes.

## Acceptance matrix

| Requirement | Owner | Evidence required |
|---|---|---|
| Existing-evidence source gate | composition policy + Canon | focused policy test and Canon loader regression |
| Player can author/revise without answer feedback | workbench + `GameState` | component and integration tests |
| Draft survives save/load with old-save fallback | `GameState` | persistence regression and migration guard |
| No automatic completed manual on clear | Canon result contract | regression test of normal-clear behavior |
| Dossier hierarchy and Lume accuracy | native workbench + approved asset | asset receipt + two runtime resolution captures |
| Escape/focus/input restore | workbench + investigation scene | integration test and runtime interaction check |
| Existing rescue/recovery still owns outcomes | investigation/recovery owner | targeted M01 recovery regression |

## Rollback

The feature can be removed as one bounded unit by reverting the workbench scene/script and M01 investigation wiring, then removing only `M01-LUME-GUIDE-001` and its manifest record. Do not alter `filled_slots`, save versions, or M04 to roll back this M01 slice.
