# Recovery Operation Surface and Bureau Menu Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make the actual Recovery overlay show the dual clocks and lower-right manual entry, remove obsolete play controls, prevent anomaly-art cropping, and integrate the explicitly user-approved Bureau main-menu background with a native product-title lockup.

**Architecture:** `battle_scene` remains the state/action owner, `CanonV2RuntimeBridge` converts its public recovery presentation into runtime state, and `CanonV2OperationOverlay` renders the only player-visible operational header, clock cluster, manual drawer, and confirmation layer. `LogGuide` becomes a text-only reusable procedure communication component; the exact user-approved background is loaded by `UiAssetCatalog`, while title and controls remain native Godot UI.

**Tech Stack:** Godot 4.7, GDScript, GUT, repository-local asset receipt, user-provided approved PNG.

**Spec:** `docs/superpowers/specs/2026-08-31-recovery-operation-surface-and-bureau-menu-design.md`

> **Execution update — 2026-08-31:** The pre-lock generated-background steps below are historical planning context only. The user chose the supplied archive-research-room image instead; `ULAB-MAIN-MENU-BACKGROUND-001` is the only integrated menu background. The unselected generated candidate is `REJECTED / NOT_SELECTED` and has no repository or runtime consumer. The implemented native display title is `괴이기록국: 잔향 보고서`; the world-internal agency remains `괴이 기록국`.

## Global Constraints

- Preserve `GameState.recovery_clock_state` as the only persisted Recovery danger state.
- Do not alter case truths, clue/response IDs, save version, campaign progression, or the Canon v2 action confirmation contract.
- Kwon Narae is the direct Recovery lead; teammates remain support actors.
- All controls, Korean text, and semantic clock labels remain Godot-native, keyboard reachable UI.
- `ULAB-MAIN-MENU-BACKGROUND-001` is user-approved and runtime-integrated as an environment-only asset; the unselected generated candidate is `REJECTED / NOT_SELECTED` and has no project consumer.
- Tests and runtime capture do not constitute Human QA, accessibility verification, release rights, or release approval.

---

### Task 1: Establish failing visible-owner and presentation regressions

**Files:**
- Modify: `tests/recovery/recovery_dual_clock_scene_test.gd`
- Modify: `tests/canon_v2_runtime/canon_v2_operation_overlay_test.gd`
- Modify: `tests/m04/m04_playable_investigation_recovery_route_test.gd`
- Modify: `tests/test_mvp035_log_companion.gd`
- Modify: `tests/m04/m04_recovery_bc_anomaly_capture_test.gd`

**Interfaces:**
- Consumes: `CanonV2OperationOverlay.configure(runtime_state, mode)`, active `battle_scene.tscn`, `LogGuide` tutorial API.
- Produces: explicit tests for `RecoveryClockCluster`, `ManualQuickButton`, automatic completion, text-only procedure communication, and aspect-contained anomaly art.

- [ ] **Step 1: Write failing runtime-owner assertions**

```gdscript
var overlay := current_scene.get_node_or_null("CanonV2OperationOverlay")
_expect(overlay != null and overlay.visible, "visible Recovery overlay is required")
_expect(overlay.get_node_or_null("SafeArea/RootLayout/RuleStripPanel/RuleStrip/RecoveryClockCluster/StabilityClock") != null, "stability clock must be in actual overlay")
_expect(current_scene.get_node_or_null("ActionDock/Content/Footer/ManualQuickButton") != null, "manual must be reachable from lower-right footer")
_expect(current_scene.find_child("RecoverButton", true, false) == null, "manual completion replaces recover execution button")
```

- [ ] **Step 2: Run the focused tests to prove the old screen fails**

Run: `Godot --headless --path . -s res://addons/gut/gut_cmdln.gd -gtest=res://tests/recovery/recovery_dual_clock_scene_test.gd`

Expected: fail because clocks still live under hidden `RecoveryHud` and old footer controls remain.

- [ ] **Step 3: Add aspect and LogGuide assertions**

```gdscript
_expect(visual.stretch_mode == TextureRect.STRETCH_KEEP_ASPECT_CENTERED, "approved cutout must be contained")
_expect(not guide.has_node("Portrait"), "shared procedure dialogue must not render deprecated portrait art")
_expect(catalog.get_asset_path("log_normal").is_empty(), "removed portrait asset must have no catalog path")
```

- [ ] **Step 4: Run all modified test files and preserve their red output as implementation evidence**

Run: focused GUT command per file, then do not change non-test behavior until the expected missing-node failures are understood.

### Task 2: Move Recovery presentation into the actual overlay

**Files:**
- Modify: `scripts/ui/canon_v2_operation_overlay.gd`
- Modify: `scripts/ui/canon_v2_runtime_bridge.gd`
- Modify: `scripts/scenes/battle_scene.gd`
- Modify: `scenes/battle_scene.tscn`
- Reuse: `scripts/ui/recovery_clock.gd`

**Interfaces:**
- Consumes: `battle_scene.get_recovery_clock_presentation() -> Dictionary` returning `stability_segments`, `stability_total`, `danger_segments`, `danger_total`, `danger_urgent`.
- Produces: visible `CanonV2OperationOverlay/…/RecoveryClockCluster`, `set_recovery_clock_feedback(kind: String)`, and bridge state key `recovery_clock`.

- [ ] **Step 1: Add the minimum clock-cluster test fixture**

```gdscript
overlay.configure_for_test({
    "recovery_clock": {"stability_segments": 5, "stability_total": 8, "danger_segments": 3, "danger_total": 6, "danger_urgent": false}
}, "recovery")
```

- [ ] **Step 2: Add visible overlay clock controls**

Create `RecoveryClockCluster` beside `RuleSummaryLabel`; attach two `RecoveryClock` controls with text labels. Refresh from the `recovery_clock` dictionary and use `set_clock()` / `play_feedback()` without writing save data.

- [ ] **Step 3: Expose current scene presentation, not legacy node state**

```gdscript
func get_recovery_clock_presentation() -> Dictionary:
    return {
        "stability_segments": _stability_segments(),
        "stability_total": 8,
        "danger_segments": int(GameState.get_recovery_clock_state().get("danger", 0)),
        "danger_total": 6,
        "danger_urgent": int(GameState.get_recovery_clock_state().get("danger", 0)) >= 6,
    }
```

Make `_build_overlay_state(mode, current_scene)` include this data only for Recovery. Change `_refresh_recovery_clock_hud()` into an immediate overlay refresh helper, then remove the old HUD clock variables and nodes.

- [ ] **Step 4: Run focused overlay, bridge, and dual-clock tests**

Run: `canon_v2_operation_overlay_test.gd`, `canon_v2_runtime_bridge_test.gd`, `recovery_clock_state_test.gd`, and `recovery_dual_clock_scene_test.gd`.

### Task 3: Replace obsolete Recovery controls with direct-lead auto-completion

**Files:**
- Modify: `scenes/battle_scene.tscn`
- Modify: `scripts/scenes/battle_scene.gd`
- Modify: `scripts/ui/canon_v2_runtime_bridge.gd`
- Modify: `tests/m04/m04_playable_investigation_recovery_route_test.gd`
- Modify: `tests/canon_v2_runtime/canon_v2_result_termination_test.gd`

**Interfaces:**
- Consumes: `_can_recover() -> bool`, `GameState.save_recovery_result(...)`.
- Produces: `is_recovery_ready_for_resolution() -> bool`, `request_manual_quick_open() -> void`, and a once-only deferred `_complete_recovery_when_ready()`.

- [ ] **Step 1: Write the failing automatic-completion regression**

```gdscript
_expect(current_scene.find_child("RepresentativeSwitchButton", true, false) == null, "direct command lead cannot be switched")
_expect(current_scene.find_child("RecoverButton", true, false) == null, "recovery finishes automatically")
current_scene.call("_complete_recovery_when_ready")
await get_tree().process_frame
_expect(get_tree().current_scene.scene_file_path.ends_with("result_scene.tscn"), "reached threshold must transition once")
```

- [ ] **Step 2: Remove redundant scene nodes and event wiring**

Delete the hidden `RecoveryHud` status row, `ClueDrawer` toggle path, `RepresentativeSwitchButton`, and `RecoverButton`. Add exactly one footer `ManualQuickButton` whose callback invokes the overlay’s public manual toggle.

- [ ] **Step 3: Make Kwon Narae the deterministic direct lead**

Resolve the selected agent with `GameState.get_protagonist_agent_id()` when present, falling back only when data is incomplete. Remove the switch method and index-mutating UI path. Keep teammate support target selection separate.

- [ ] **Step 4: Implement idempotent automatic result transition**

When a view refresh first observes `_can_recover()` and `_recovery_completed == false`, set the completed guard, write the existing recovery result packet, disable responses/supports, and defer the existing scene change once. Make bridge termination preview use `is_recovery_ready_for_resolution()` rather than a deleted node.

- [ ] **Step 5: Run M04 full route and Canon v2 termination tests**

Run: M04 investigation-to-recovery route, manual UX validation, and Canon v2 result termination tests. Confirm the response result remains observable before deferred scene replacement.

### Task 4: Rebuild shared dialogue as text-first procedure communication

**Files:**
- Modify: `scripts/ui/log_guide.gd`
- Modify: `scripts/ui/ui_asset_catalog.gd`
- Modify: `tests/test_mvp035_log_companion.gd`
- Modify: `tests/ui_asset_catalog_test.gd`
- Delete after readback: `assets/log/log_normal.png`, `assets/log/log_focus.png`, `assets/log/log_warning.png`, and their generated import artifacts if tracked

**Interfaces:**
- Consumes: existing `LogGuide.present_lines`, `present_tutorial`, `advance`, `get_current_text`, `get_current_expression`, and `make_signature_stream` APIs.
- Produces: no `get_log_expression` catalog API and no portrait texture consumer.

- [ ] **Step 1: Assert existing guide behavior without portrait dependency**

```gdscript
guide.present_lines([{"speaker": "루메", "text": "전조를 기록하세요.", "expression": "warning"}], "warning", false)
_check(guide.get_current_text() == "전조를 기록하세요.", "procedure text survives portrait removal")
_check(guide.find_child("Portrait", true, false) == null, "no deprecated portrait node")
```

- [ ] **Step 2: Replace portrait layout with semantic header/status layout**

Use a left accent/status marker, a header label `루메 · 절차 통신`, tutorial body, and existing next/close interaction. Preserve expression as an accessible status label and audio mode only.

- [ ] **Step 3: Remove catalog mapping and exact unused asset files**

First prove the only consumers were `UiAssetCatalog` and `LogGuide`. Then delete the three approved-for-removal legacy log PNGs and their generated `.import` files by exact path, with no glob deletion.

- [ ] **Step 4: Run shared-scene LogGuide regression**

Run `test_mvp035_log_companion.gd`, UI asset catalog test, and all affected scene instantiation tests.

### Task 5: Fix field composition and stage the menu candidate

**Files:**
- Modify: `scenes/battle_scene.tscn`
- Modify: `tests/m04/m04_recovery_bc_anomaly_capture_test.gd`
- Create: `docs/visual/candidates/BUREAU_MAIN_MENU_HQ_CANDIDATE_01_20260831.png`
- Create: `docs/visual/candidates/BUREAU_MAIN_MENU_HQ_CANDIDATE_01_20260831.md`
- Defer until user lock: `ASSET_MANIFEST.yml`, `scripts/ui/ui_asset_catalog.gd`, `scripts/ui/main_menu.gd`

**Interfaces:**
- Consumes: existing full-body transparent `AnomalyVisual` cutouts and built-in generated image output.
- Produces: no stage/dock overlap, contained cutouts, and one fully receipted candidate with no runtime consumer yet.

- [ ] **Step 1: Make the new composition test fail on old anchors**

```gdscript
_expect(stage.anchor_bottom <= dock.anchor_top, "anomaly stage must end before action dock begins")
_expect(visual.stretch_mode == TextureRect.STRETCH_KEEP_ASPECT_CENTERED, "cutout must preserve full body")
```

- [ ] **Step 2: Adjust only Stage/Dock bounds and cutout stretch mode**

End `CinematicStage` at or before `ActionDock.anchor_top`, keep `AnomalyPanel` within that stage, and set `AnomalyVisual` to `STRETCH_KEEP_ASPECT_CENTERED`. Do not crop, replace, or edit the approved cutout PNG.

- [ ] **Step 3: Copy the generated menu candidate into the project and create its receipt**

Record source tool, prompt, SHA-256, dimensions, intended `MainMenu` consumer, `GENERATED_CANDIDATE`, and `FINAL_USER_LOCK_REQUIRED`. Do not alter the asset manifest or runtime catalog yet.

- [ ] **Step 4: Run the visual target test and inspect candidate dimensions/readback**

Run the M04 anomaly consumer test at its target profiles; inspect the candidate PNG and receipt. Record any live screen clipping issue separately from automated node assertions.

### Task 6: Verify, clean generated cache noise, and update current handoff

**Files:**
- Modify: `docs/superpowers/specs/2026-08-31-recovery-dual-clock-design.md`
- Modify: `docs/CURRENT_DECISION_OVERLAY.md`
- Modify: `docs/CURRENT_HANDOFF.md`
- Modify only if status is true: `TEST_CHECKLIST.md`
- Delete: exact untracked diagnostic capture and generated `.import` files created by this task but not runtime source

**Interfaces:**
- Consumes: completed source changes and test outputs.
- Produces: exact evidence boundary, candidate lock gate, cleanup record, and next safe action.

- [ ] **Step 1: Run focused GUT suite and Godot import**

Run the state, overlay, bridge, recovery route, LogGuide, asset catalog, and anomaly visual tests, then one `--headless --import` after source changes.

- [ ] **Step 2: Run static checks and inspect exact diff**

Run `git diff --check`, `git status --short`, and explicit `rg` checks proving removed names/asset paths have no active source consumer.

- [ ] **Step 3: Capture live Recovery at 1280×720 and 1920×1080**

Use only the Urban Legend Godot editor instance. Verify visible clock cluster, lower-right manual opening, absent redundant controls, no anomaly crop, and text-first procedure panel. This is runtime evidence only; Human QA remains unrun.

- [ ] **Step 4: Remove exact cache/diagnostic outputs and re-read status**

Remove only task-created diagnostic captures, generated import metadata, and `.godot` cache entries after all tests. Retain source, tests, candidate PNG, candidate receipt, and required Godot `.uid` files.

- [ ] **Step 5: Reconcile docs and perform five adversarial passes**

For each pass: re-read the full diff, test state flow, visual ownership, deletion impact, save compatibility, and candidate promotion boundary. Stop only after five passes have no new blocking finding. Update current docs with `MACHINE_VERIFIED`, `RUNTIME_VERIFIED`, and separately `HUMAN_QA_NOT_RUN` only when evidence supports those labels.

## Plan self-review

- **Spec coverage:** Tasks 1–3 cover visible clocks, manual relocation, removed controls, direct lead, automatic transition, and bridge ownership. Task 4 covers deprecated global Lume art and dialogue appearance. Task 5 covers image containment and the one new main-menu candidate. Task 6 covers validation, cleanup, document lifecycle, and evidence boundaries.
- **Placeholder scan:** no unspecified implementation methods or test-only acceptance steps remain; runtime asset promotion is intentionally deferred behind the exact user-result lock.
- **Interface consistency:** `get_recovery_clock_presentation`, `is_recovery_ready_for_resolution`, and the public manual-toggle entry are introduced in Task 2/3 before their bridge and test consumers. `LogGuide` public tutorial/audio API is preserved across Task 4.
