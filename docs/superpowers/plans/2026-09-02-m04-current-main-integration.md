# M04 Current-main Recovery and Main-menu Integration Plan

> **For agentic workers:** Execute this plan inline in the isolated `codex/m04-current-main-integration-20260902` worktree. Each production behavior starts with a focused failing regression and ends with the named focused verification.

**Goal:** Reconcile the approved M04 recovery dual-clock operation surface and the bureau main-menu identity into current `main`, while preserving M04's text-only Archivist Aka guide, existing save compatibility, and the player-authored manual contract.

**Architecture:** `GameState` retains existing stability as its sole source and adds only the recovery-only danger-clock snapshot with safe legacy defaults. `battle_scene` owns recovery turn outcomes and single automatic resolution; the visible `CanonV2OperationOverlay` owns the clock presentation and its lower-right manual entry. `main_menu.gd` owns native accessible menu labels and action plates, while the approved bureau background, emblem, and wordmark remain cataloged visual inputs rather than baked UI.

**Tech Stack:** Godot 4.7.1, GDScript, native Godot `Control` nodes, existing GUT/SceneTree regression scripts, Python document contracts, and the repository asset manifest.

**Spec:** `docs/design/URBAN_LEGEND_HUMAN_GAME_BLUEPRINT_20260830.md` §§8 and 12; `docs/CURRENT_DECISION_OVERLAY.md`; `docs/visual/receipts/ULAB_MAIN_MENU_BACKGROUND_20260831.md`; `docs/visual/receipts/ULAB_MAIN_MENU_EMBLEM_20260831.md`; `docs/visual/receipts/ULAB_MAIN_MENU_WORDMARK_20260901.md` on the preserved M04 reference branch.

## Global Constraints

- Start from `origin/main` commit `e7ff8139984c7117dc6b6259fbb482ccc2e6880c`; do not merge the historical M04 worktree wholesale.
- Keep `INVESTIGATION → player-authored MANUAL → RESCUE → RECOVERY → COMPOSITE_RESULT`, all M01/M04 clue and response IDs, the 10-day dispatch context, and result axes unchanged.
- Keep `case_anomaly_stability` and `_recovery_threshold` as the sole stability source; never reuse `investigation_risk` for recovery danger.
- Persist only additive `recovery_clock_state: { danger, turn_count, surge_count }`; unversioned/legacy saves read a clamped zero-default state.
- M04's guide is `기록관 아카` text-only. Do not import or surface `lume_red_umbrella_alley.png`, and do not let a compact procedure panel reveal an answer.
- Reuse only the already user-locked bureau background, emblem, and wordmark with their exact receipt/source paths and hashes. Do not generate a replacement image unless a real consumer gap is found during implementation.
- Preserve current keyboard focus, 1280×720 and 1920×1080 containment, legacy/Validation route isolation, and all human/accessibility/release states as `NOT_RUN`.
- Do not delete the legacy log images until `rg` proves there are no runtime or test consumers after the text-only Aka panel implementation; retain historical source bytes in Git history.

---

### Task 1: Introduce a recovery-only danger-clock state contract

**Files:**
- Create: `tests/recovery/recovery_clock_state_test.gd`
- Modify: `scripts/core/game_state.gd`

**Interfaces:**
- Produces `get_recovery_clock_state() -> Dictionary`, `begin_recovery_clock_turn() -> Dictionary`, `resolve_recovery_clock_outcome(correct: bool, verified: bool) -> Dictionary`, `change_recovery_clock_danger(delta: int) -> Dictionary`, and `reset_recovery_clock_state() -> void`.
- Consumes the existing save serializer/loader and existing recovery pattern reset boundary.

- [ ] **Step 1: Write the failing state regression**

```gdscript
GameState.reset_run_state()
_expect(int(GameState.get_recovery_clock_state().get("danger", -1)) == 0, "new recovery starts at danger zero")
GameState.begin_recovery_clock_turn()
_expect(int(GameState.get_recovery_clock_state().get("danger", -1)) == 0, "first telegraph is free")
GameState.begin_recovery_clock_turn()
_expect(int(GameState.get_recovery_clock_state().get("danger", -1)) == 1, "second telegraph advances danger")
var outcome := GameState.resolve_recovery_clock_outcome(true, true)
_expect(int(outcome.get("danger", -1)) == 0, "verified response relieves danger")
```

- [ ] **Step 2: Run the state regression and verify RED**

Run: `Godot_v4.7.1-stable_win64_console.exe --headless --path . --script res://tests/recovery/recovery_clock_state_test.gd`

Expected: the public clock API is absent.

- [ ] **Step 3: Add the smallest additive state implementation**

Add a clamped `{ danger: 0, turn_count: 0, surge_count: 0 }` snapshot. The first turn increments only `turn_count`; later telegraphs add one danger. A correct response subtracts one, a fully verified response subtracts a second, and an incorrect response adds two. Include the snapshot in save/load with a safe empty default and reset it with recovery pattern state.

- [ ] **Step 4: Extend the failing regression for save and surge behavior**

```gdscript
GameState.change_recovery_clock_danger(6)
var surge := GameState.resolve_recovery_clock_outcome(false, false)
_expect(bool(surge.get("surge_triggered", false)), "danger six plus wrong response surges")
_expect(int(surge.get("danger", -1)) == 3, "surge returns danger to three")
GameState.save_game()
GameState.reset_run_state()
_expect(GameState.load_game(), "clock state reloads")
_expect(GameState.get_recovery_clock_state().has("turn_count"), "legacy-safe clock schema loads")
```

- [ ] **Step 5: Run GREEN and focused save guard**

Run the state regression and `tests/test_save_guard.gd`-using focused recovery scripts. Expect the new state contract to pass without changing `SAVE_VERSION`.

- [ ] **Step 6: Commit the isolated state slice**

```powershell
git add scripts/core/game_state.gd tests/recovery/recovery_clock_state_test.gd
git commit -m "feat: add recovery danger clock state"
```

### Task 2: Render both clocks in the visible recovery overlay

**Files:**
- Create: `scripts/ui/recovery_clock.gd`
- Create: `tests/recovery/recovery_dual_clock_scene_test.gd`
- Modify: `scripts/ui/canon_v2_operation_overlay.gd`
- Modify: `scripts/ui/canon_v2_runtime_bridge.gd`
- Modify: `scripts/scenes/battle_scene.gd`
- Modify: `scenes/battle_scene.tscn`
- Modify: `tests/canon_v2_runtime/canon_v2_operation_overlay_test.gd`
- Modify: `tests/canon_v2_runtime/canon_v2_runtime_bridge_test.gd`

**Interfaces:**
- `battle_scene.get_recovery_clock_presentation() -> Dictionary` returns stability 0–8 and danger 0–6 values.
- `CanonV2OperationOverlay.set_recovery_clock_presentation(state: Dictionary)` and `set_recovery_clock_feedback(kind: String)` render, but do not mutate, clock state.
- The bridge supplies `recovery_clock` only for recovery-mode overlay state.

- [ ] **Step 1: Write failing visible-owner assertions**

```gdscript
_expect(overlay.get_node_or_null("SafeArea/RootLayout/RuleStripPanel/RuleStrip/RecoveryClockCluster/StabilityClock") != null, "visible overlay owns stability clock")
_expect(overlay.get_node_or_null("SafeArea/RootLayout/RuleStripPanel/RuleStrip/RecoveryClockCluster/DangerClock") != null, "visible overlay owns danger clock")
_expect(scene.get_node_or_null("RecoveryHud/StabilityBar") == null, "hidden linear stability bar is removed")
_expect(scene.get_node_or_null("RecoveryHud/FearBar") == null, "investigation risk bar is not shown as recovery danger")
```

- [ ] **Step 2: Run scene/overlay tests and verify RED**

Run the new scene test and the existing overlay test. Expected missing-cluster and retained-linear-HUD failures.

- [ ] **Step 3: Implement the minimum view-only clock path**

Create native `RecoveryClock` drawing segmented rings plus text labels. Derive stability segments from existing `_anomaly_stability / _recovery_threshold`; derive danger from `GameState`. Move the recovery clock cluster into the visible overlay rule strip, remove the hidden linear bar nodes, and refresh after telegraph, response, support, and state restore.

- [ ] **Step 4: Verify interaction boundary**

```gdscript
overlay.configure_for_test({
  "recovery_clock": {"stability_segments": 5, "stability_total": 8, "danger_segments": 3, "danger_total": 6, "danger_urgent": false}
}, "recovery")
_expect(stability_label.text == "5/8", "stability clock exposes numeric meaning")
_expect(danger_label.text == "3/6", "danger clock exposes numeric meaning")
```

Confirm the clock does not show a recommended answer or mutate state when rendered.

- [ ] **Step 5: Run GREEN and commit the overlay slice**

Run the focused state, overlay, bridge, and scene regressions; then commit the listed source/tests.

### Task 3: Replace redundant recovery controls with a direct-lead flow

**Files:**
- Modify: `scenes/battle_scene.tscn`
- Modify: `scripts/scenes/battle_scene.gd`
- Modify: `scripts/ui/canon_v2_runtime_bridge.gd`
- Modify: `tests/recovery/recovery_dual_clock_scene_test.gd`
- Create: `tests/m04/m04_playable_investigation_recovery_route_test.gd`
- Modify: `tests/canon_v2_runtime/canon_v2_result_termination_test.gd`

**Interfaces:**
- `is_recovery_ready_for_resolution() -> bool` is the bridge's read-only readiness query.
- `request_manual_quick_open() -> void` opens the overlay detail from the action-dock footer.
- `_complete_recovery_when_ready() -> void` is deferred and idempotent.

- [ ] **Step 1: Write failing direct-flow tests**

```gdscript
_expect(scene.find_child("RepresentativeSwitchButton", true, false) == null, "recovery has no representative switch")
_expect(scene.find_child("RecoverButton", true, false) == null, "recovery has no execute button")
var manual := scene.get_node_or_null("ActionDock/Content/Footer/ManualQuickButton") as Button
_expect(manual != null, "manual is reachable from lower-right action footer")
manual.emit_signal("pressed")
_expect(overlay.get_node_or_null("SafeArea/RootLayout/ManualDetailPanel").visible, "manual quick button opens field reference")
```

- [ ] **Step 2: Run and verify RED**

Run the scene test. Expected old controls remain and the footer quick button is absent.

- [ ] **Step 3: Implement the direct command path**

Remove `RepresentativeSwitchButton`, `RecoverButton`, `ClueDrawerButton`, and the old drawer route. Use the existing protagonist as direct lead, add one `ManualQuickButton` in the footer, and have it request the overlay panel. When the threshold first becomes true, save the existing recovery result and defer one transition to `result_scene`; no second action cost or confirmation channel may be created.

- [ ] **Step 4: Prove an automatic result transition only once**

Set the existing stability to threshold in the route test, await frames, assert exactly one change to `result_scene`, then re-run the refresh path and assert no second record/transition.

- [ ] **Step 5: Run M04 route and termination GREEN, then commit**

Run the M04 investigation→manual→rescue→recovery→result route and Canon v2 termination regression. Commit only after both pass.

### Task 4: Keep M04 procedure communication as Aka text, not a portrait asset

**Files:**
- Modify: `scripts/ui/log_guide.gd`
- Modify: `scripts/ui/ui_asset_catalog.gd`
- Modify: `tests/test_mvp035_log_companion.gd`
- Modify: `tests/ui_asset_catalog_test.gd`
- Delete after consumer-zero readback: `assets/log/log_normal.png`, `assets/log/log_focus.png`, `assets/log/log_warning.png` and their tracked `.import` files only

**Interfaces:**
- Existing `present_lines`, `present_tutorial`, `advance`, `get_current_text`, `get_current_expression`, and `make_signature_stream` stay compatible.
- The visible header identifies the text-only guide as `기록관 아카 · 절차 통신`.

- [ ] **Step 1: Write failing no-portrait assertions**

```gdscript
var guide := LogGuide.new()
add_child(guide)
guide.present_lines([{"text": "전조를 기록하세요.", "expression": "warning"}], "warning", false)
_check(guide.get_current_text() == "전조를 기록하세요.", "procedure text remains available")
_check(guide.find_child("Portrait", true, false) == null, "M04 procedure guide has no portrait")
_check(guide.find_child("ProcedureSpeaker", true, false).text.contains("기록관 아카"), "M04 guide is Aka text")
```

- [ ] **Step 2: Run and verify RED**

Run `test_mvp035_log_companion.gd`; expected portrait/catalog assertions show the old UI dependency.

- [ ] **Step 3: Implement text-first procedure panel**

Replace the portrait frame with a compact status/accent column. Preserve tutorial sequencing, close/advance focus, and audio signatures. Remove `log_*` catalog mapping only after static search proves `LogGuide` is the final runtime consumer.

- [ ] **Step 4: Perform exact deletion only after readback**

```powershell
rg -n "log_(normal|focus|warning)|get_log_expression" scripts scenes tests
```

If the only remaining references are the old map/test expectations being changed in this task, delete the three exact image paths and their exact tracked import files. Do not delete `lume_afterlife_station.png`; it is a separate CASE-01-only approved asset.

- [ ] **Step 5: Run GREEN and commit**

Run log-guide, asset catalog, investigation/battle instantiation, and manual UX regression before committing.

### Task 5: Integrate user-locked bureau menu identity with separated action plates

**Files:**
- Reuse: `assets/backgrounds/bureau_archive_menu.png`
- Reuse: `assets/source/wordmarks/ULAB-MAIN-MENU-WORDMARK-001-locked-source.png`
- Reuse: `assets/ui/bureau_archive_wordmark.png`
- Reuse: `assets/ui/bureau_archive_emblem.png`
- Modify: `ASSET_MANIFEST.yml`
- Modify: `scripts/ui/ui_asset_catalog.gd`
- Modify: `scripts/ui/main_menu.gd`
- Modify: `tests/test_main_menu_control_room_static_contract.py`
- Modify: `tests/validation/validation_main_menu_contract_test.gd`
- Modify: `tests/validation/main_menu_window_breakpoint_test.gd`

**Interfaces:**
- `UiAssetCatalog.get_texture("bureau_archive_menu")`, `get_texture("bureau_archive_wordmark")`, and `get_texture("bureau_archive_emblem")` resolve approved canonical paths.
- `main_menu.gd` retains native `WorldTitle` and `WorldTitleSuffix` semantic fallback and accessible focus owners.

- [ ] **Step 1: Add failing menu-consumer and layout tests**

```python
self.assertIn('"bureau_archive_menu"', catalog)
self.assertIn('MainMenuBackdrop', menu)
self.assertIn('WorldTitleWordmark', menu)
self.assertIn('WorldTitleEmblem', menu)
self.assertIn('괴이기록국: 잔향 보고서', menu)
```

```gdscript
_expect(menu.find_child("MainMenuBackdrop", true, false) != null, "bureau background is a menu consumer")
_expect(menu.find_child("WorldTitleWordmark", true, false) != null, "wordmark has a runtime consumer")
_expect(menu.find_child("WorldTitleEmblem", true, false) != null, "emblem has a runtime consumer")
_expect(menu.find_child("M04CampaignEntryButton", true, false) != null, "M04 entry remains reachable")
```

- [ ] **Step 2: Run and verify RED**

Run the Python static contract and the two Godot main-menu tests. Expected missing catalog/identity nodes.

- [ ] **Step 3: Restore only receipted binary assets and record them**

Bring the three locked visual derivatives and the approved background from `codex/m04-playable-vertical-slice-20260831` by exact Git path. Add manifest entries containing the receipt SHA-256, source, consumer, approval scope, and `HUMAN_QA_NOT_RUN`. Do not import Lume M04 art or any old log asset deletion as part of this transfer.

- [ ] **Step 4: Implement accessible 3-rail menu and individual action plates**

Add the textless `MainMenuBackdrop`, compact emblem, and wordmark lockup. Keep native title/suffix labels hidden only visually for semantic fallback. Use explicit vertical gaps and separate button plates for `본편 시작`, `이어서 하기`, `Validation`, `기록 보관실`, `설정`, and `종료`; preserve M04 entry without fusing it into a dense control wall. Keep labels/data in Godot rather than inside the background.

- [ ] **Step 5: Verify both target resolutions and commit**

Run main-menu static/Godot contracts at 1280×720 and 1920×1080. Confirm focus order, no clipped title, and action reachability before committing.

### Task 6: Reconcile authority, run the full implementation evidence loop, and publish safely

**Files:**
- Modify: `docs/CURRENT_DECISION_OVERLAY.md`
- Modify: `docs/CURRENT_HANDOFF.md`
- Modify: `docs/design/PROJECT_AI_PRODUCTION_SPEC.md`
- Modify: `docs/design/URBAN_LEGEND_HUMAN_GAME_BLUEPRINT_20260830.md`
- Create: `docs/operations/receipts/2026-09-02-m04-current-main-integration.json`
- Modify: any generated current operating view only through the pinned project generator if its source changes require it

- [ ] **Step 1: Record direct user authorization and exact scope**

State that the 2026-09-02 user instruction authorizes the M04 current-main integration and necessary consumer-backed image creation, but does not convert machine evidence into Human QA or release rights clearance.

- [ ] **Step 2: Reconcile the human blueprint with actual merged branch facts**

Replace `PENDING_MAIN_RECONCILIATION` only after the exact current integration branch has passing evidence. Preserve separate `HUMAN_QA_NOT_RUN` and `PRODUCT_REFERENCE_ASSET` boundaries.

- [ ] **Step 3: Run focused evidence**

Run state, overlay, bridge, termination, M04 full route, LogGuide, asset catalog, main-menu Python/Godot, `test_mvp039_manual_ux_validation.gd`, `git diff --check`, reference-freshness checks, and `Godot --headless --import`.

- [ ] **Step 4: Run full regression and five adversarial loops**

Run `bash tests/run_godot_regression.sh`. Then perform five whole-scope passes over save compatibility, M01/M04 meaning, no-answer-reveal UI, clock state duplication, asset provenance, Lume/Aka boundary, focus/layout, and deleted-file references. Correct any valid finding before the next pass.

- [ ] **Step 5: Capture runtime evidence and retain only required artifacts**

Use the project-specific Godot runtime workflow for both 1280×720 and 1920×1080. Confirm clock visibility, lower-right manual access, automatic single resolution, no representative/recover buttons, Aka text-only procedure UI, menu background/title/action-plate containment. Keep only captures that are receipt consumers; remove task-created cache and temporary diagnostics by exact path.

- [ ] **Step 6: Commit, push, PR, exact-head CI, and postmerge readback**

Commit coherent slices, push the integration branch, open one PR, wait for exact-head required checks, and merge only if the current task PR meets protected-branch requirements. Re-fetch `main`, validate the merged SHA, and report machine/runtime evidence separately from Human QA.

## Plan self-review

- **Coverage:** Tasks 1–3 implement the clock, manual placement, obsolete-control removal, and automatic transition. Task 4 keeps the M04 Aka/Lume identity boundary and prevents stale portrait consumption. Task 5 imports only user-locked menu assets into true consumers. Task 6 handles canonical records, verification, cleanup, and protected delivery.
- **Reuse decision:** `ADOPT` the M04 branch's dual-clock state/view contract and receipted menu assets; `ADAPT` it to current main and Aka text-only guidance; `REJECT` its M04 Lume portrait transfer and its unverified broad deletions.
- **No-placeholder check:** all production surfaces, public interfaces, tests, and verification commands are named. Human/accessibility/release validation remains deliberately unclaimed.
