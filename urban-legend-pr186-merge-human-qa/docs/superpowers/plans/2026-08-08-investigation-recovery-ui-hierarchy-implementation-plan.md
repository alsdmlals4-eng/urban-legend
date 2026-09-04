# Investigation / Recovery UI Hierarchy Implementation Plan

> **Required execution skill:** `superpowers:test-driven-development` for implementation, followed by `superpowers:verification-before-completion` before any completion claim.
>
> **Decision:** `D-2026-08-08-INVESTIGATION-RECOVERY-UI-HIERARCHY-REFINEMENT`
> **Spec:** `docs/superpowers/specs/2026-08-08-investigation-recovery-ui-hierarchy-design.md`
> **Planning PR:** #176 (`agent/investigation-recovery-ui-spec-20260808`)
> **Planning baseline project main:** `09c187bf7bd4eb69fa19558d069d46f411d93951`
> **Project-adopted Base baseline:** `fa69a77a14f923a756064f6ae151d34cadb374f7`
> **Current Base remote main observed during planning:** `eee98a930219065e30b4d7d14d99d5ac7db44c60`
> **Base freshness rule:** the newer Base remote main is recorded as current upstream state only; this plan does not silently promote the project-adopted Base baseline.
> **Godot authoring authority:** persistent Godot mutation must be performed in a HiGodot-authorized execution environment. GUT remains deterministic non-authoring test authority. Hera remains live-QA/observability-only and inactive for persistent mutation.

## Goal

Reorder the existing investigation and stabilization/recovery presentation hierarchy so players see the field, anomaly, and next meaningful action before optional documentation panels, while preserving all existing domain truth, save semantics, IDs, Canon v2 protection/termination logic, and current episode data.

The implementation must specifically remove the current interaction blocker where the Afterlife Station investigation keeps a large manual panel permanently visible, make the first available investigation action discoverable by pointer and keyboard, reduce Canon v2 investigation overlay occupancy without losing rule continuity, and make the recovery battlefield anomaly-centered with ally visuals contextual rather than persistent.

## Architecture

Use **ADAPT_EXISTING**, not a parallel replacement scene.

```text
existing domain state / GameState / episode data
        ↓ read-only presentation inputs
existing investigation_scene + existing action/manual components
        ↓ presentation hierarchy only
mode-specific Canon v2 overlay presentation
        ↓
existing battle_scene + TeamStrip + ActionDock + AnomalyVisual
```

Implementation boundaries:

- Preserve `GameState` as the state owner.
- Preserve episode JSON, clue IDs, action IDs, hypothesis truth, recovery outcome, protection obligations, termination eligibility, rewards, and save schema.
- Preserve stable scene node identities where existing tests/runtime editor depend on them.
- Reuse `ActionChoiceCard`, `AnomalyManualDrawer`, `TeamStatusChip`, `RecoveryHud`, `CinematicStage`, `ActionDock`, `ClueDrawer`, and Canon v2 confirmation APIs.
- Keep `RepresentativeVisual` as a compatibility/stable node but change its normal presentation role from persistent battlefield presence to contextual cut-in.
- Do not add or promote image assets. `PROJECT_ASSET_APPROVED` remains `0` until a separate asset approval workflow says otherwise.

## Tech Stack

- Godot 4.7.1 stable
- GDScript
- Godot `Control` / `Container` / `Theme`
- Existing SceneTree regression scripts under `tests/`
- Adopted GUT 9.7.1 suite under `tests/gut/` for non-authoring regression authority
- GitHub Actions exact-head regression
- Windows `START_HUMAN_QA.cmd` for final human/save/UI validation

## Global Constraints

1. **No domain changes:** do not edit `scripts/core/game_state.gd`, `data/episodes/**`, save schema, economy, endings, or campaign meaning.
2. **No project settings changes:** do not edit `project.godot` for this feature.
3. **No asset mutation:** do not generate, delete, replace, promote, or newly track image bytes; do not modify root `ASSET_MANIFEST.yml` except in a separate approved asset workflow.
4. **HiGodot boundary:** Scene/Node/Resource persistent edits must be made through the approved HiGodot authoring path. If that authority is unavailable, stop before scene mutation and report `BLOCKED_HIGODOT_UNAVAILABLE`.
5. **TDD:** every behavior slice starts with a failing deterministic test. Do not weaken an existing test merely because the old layout changed; replace obsolete assertions with the newly approved contract.
6. **Stable nodes:** keep existing unique/stable nodes unless a test and runtime-consumer audit proves removal safe. In particular, preserve `ManualPanel` and `RepresentativeVisual` identities if compatibility requires them, but they may be hidden/reinterpreted.
7. **Human truth:** automated layout checks are not Human QA. 1280×720, 1920×1080, keyboard, gamepad, accessibility, and actual-save judgments remain `NOT_RUN` until performed by a person in the actual Windows flow.
8. **Separate PRs:** PR #176 remains planning/canon only. Runtime implementation starts on a separate implementation branch/PR from the latest approved main after the planning PR merge gate.

---

## Task 1 — Freeze the new interaction contract in failing tests

**Purpose:** establish RED evidence before changing any production UI.

**Modify:**
- `tests/anomaly_manual_drawer_test.gd`
- `tests/mvp043_investigation_ui_test.gd`
- `tests/canon_v2_runtime/canon_v2_operation_overlay_test.gd`
- `tests/cinematic_ui_redesign_test.gd`

**Do not modify yet:** production scene/script files.

### Step 1.1 — Add drawer focus-return RED coverage

In `tests/anomaly_manual_drawer_test.gd`, add a meaningful control distinct from the manual toggle, focus it, open the drawer programmatically, close the drawer, and assert focus returns to the pre-open control when it is still valid. Preserve the existing toggle-button fallback assertion.

Target contract:

```gdscript
var prior_action := Button.new()
host.add_child(prior_action)
prior_action.grab_focus()
await process_frame

drawer.open_drawer()
await process_frame
_expect(drawer.visible, "manual drawer should open")

drawer.close_drawer()
await process_frame
_expect(root.gui_get_focus_owner() == prior_action, "manual drawer should restore the previous meaningful focus")
```

Expected result before implementation: **FAIL** because the current drawer always returns focus to the toggle button.

Run:

```bash
godot --headless --path . --script res://tests/anomaly_manual_drawer_test.gd
```

### Step 1.2 — Replace persistent-manual assertions with approved investigation assertions

In `tests/mvp043_investigation_ui_test.gd`:

- Keep viewport coverage for 1280×720, 1920×1080, and 1918×943.
- Replace `ManualPanel must be visible` with:
  - `ManualPanel` may remain as a compatibility node but must not be persistently visible in the normal Afterlife investigation state.
  - a visible manual/record entry point must remain available.
  - the first enabled investigation action must be inside the viewport and must receive or be reachable by actual keyboard focus.
- Assert primary investigation action controls remain visible at 1280×720 even when secondary context collapses.
- Keep the existing evidence-preservation and return-flow assertions.

Target assertions:

```gdscript
_expect(manual_panel != null, "compatibility manual node should remain addressable")
_expect(not manual_panel.visible, "afterlife manual must not permanently occupy the investigation workspace")

var manual_toggle := scene.find_child("ManualToggleButton", true, false) as Button
_expect(manual_toggle != null and manual_toggle.visible, "investigation must expose a manual entry point")

var focus_owner := root.gui_get_focus_owner()
_expect(focus_owner != null, "investigation must establish a first meaningful keyboard focus")
```

Expected result before implementation: **FAIL** because current Afterlife investigation sets `ManualPanel.visible = true`, keeps `ManualToggleButton.visible = false`, and does not explicitly grab first-action focus.

Run:

```bash
godot --headless --path . --script res://tests/mvp043_investigation_ui_test.gd
```

### Step 1.3 — Add investigation-mode Canon overlay RED coverage

In `tests/canon_v2_runtime/canon_v2_operation_overlay_test.gd`, keep the existing recovery-mode coverage and add a second overlay configured as `investigation` with non-empty follow-up/protection/termination fixtures.

Assert:

- `ObligationPanel` hidden in investigation.
- `TerminationPreviewPanel` hidden in investigation.
- `FollowUpPanel` hidden in investigation even when follow-up records exist.
- overlay root and full-screen safe-area surfaces do not consume pointer input outside actual interactive panels (`MOUSE_FILTER_IGNORE` or an equivalent non-blocking contract).
- compact rule continuity text remains visible.
- recovery-mode confirmation behavior remains unchanged.

Expected result before implementation: **FAIL** because the current follow-up visibility can escape mode filtering and the full-screen overlay uses `MOUSE_FILTER_PASS`.

Run:

```bash
godot --headless --path . --script res://tests/canon_v2_runtime/canon_v2_operation_overlay_test.gd
```

### Step 1.4 — Update cinematic contract for contextual representative visual

In `tests/cinematic_ui_redesign_test.gd`:

- Keep `RepresentativeVisual` as a required stable node.
- Add assertion that it is not persistently visible at recovery idle/start.
- Keep `AnomalyVisual`, `TeamStrip`, `ActionDock`, `ResponseGrid`, and representative switching available.
- Replace the old fixed investigation middle-column ratio assertion with contract assertions for primary action visibility and secondary-panel collapse. Do not assert exact pixel ratios unless required to catch a real regression.

Expected result before implementation: **FAIL** because `RepresentativeVisual` is currently persistent and the old investigation layout still uses the three-column manual-heavy workspace.

Run:

```bash
godot --headless --path . --script res://tests/cinematic_ui_redesign_test.gd
```

### Step 1.5 — Record RED evidence

All four focused tests must fail for the intended new-contract reasons, not parse errors or missing fixtures. If a test passes unexpectedly, inspect the actual current behavior before changing production code.

**Commit after RED contract is valid:**

```bash
git add tests/anomaly_manual_drawer_test.gd \
        tests/mvp043_investigation_ui_test.gd \
        tests/canon_v2_runtime/canon_v2_operation_overlay_test.gd \
        tests/cinematic_ui_redesign_test.gd
git commit -m "test: define investigation and recovery hierarchy contract"
```

---

## Task 2 — Fix the investigation interaction blocker first

**Purpose:** make the existing Afterlife investigation usable before the larger hierarchy rearrangement.

**Modify:**
- `scripts/ui/anomaly_manual_drawer.gd`
- `scenes/investigation_scene.tscn` — **HiGodot persistent Scene mutation only**
- `scripts/scenes/investigation_scene.gd`
- tests from Task 1

### Step 2.1 — Implement focus-preserving manual drawer

In `scripts/ui/anomaly_manual_drawer.gd`:

- Add `_previous_focus: Control`.
- Capture the current focus owner in `open_drawer()` before moving focus into the drawer.
- In `close_drawer()`, restore `_previous_focus` when valid; otherwise use `_toggle_button` as fallback.
- Clear the stored reference after close.
- Do not change game state.

Minimal interface:

```gdscript
var _previous_focus: Control

func open_drawer() -> void:
    _previous_focus = get_viewport().gui_get_focus_owner()
    visible = true
    # existing unread/button behavior
    _close_button.grab_focus()

func close_drawer() -> void:
    visible = false
    # existing button refresh
    if is_instance_valid(_previous_focus):
        _previous_focus.grab_focus()
    elif _toggle_button != null:
        _toggle_button.grab_focus()
    _previous_focus = null
```

Run and expect PASS:

```bash
godot --headless --path . --script res://tests/anomaly_manual_drawer_test.gd
```

### Step 2.2 — Convert the Afterlife persistent manual into the shared drawer path

In HiGodot, edit `scenes/investigation_scene.tscn` while preserving unique node identities:

- Keep `%ManualPanel` for compatibility but make it non-persistent/hidden in the normal layout.
- Make `%ManualToggleButton` a visible entry point labeled through `AnomalyManualDrawer.bind_toggle_button()`.
- Do not delete the existing manual textures or assets in this task; they are not being promoted or replaced.
- Do not add a full-screen input-blocking backdrop.

In `scripts/scenes/investigation_scene.gd`:

- Instantiate `AnomalyManualDrawer` for Afterlife as well as non-Afterlife layouts.
- Bind `%ManualToggleButton` to the shared drawer.
- Move Afterlife manual presentation into a helper such as `_refresh_afterlife_manual_drawer()` that reads `AfterlifeManualCatalog` and the existing read/attempt state without changing truth.
- Preserve case-dialog access and page semantics; drawer sections may replace the permanent book surface, but all information must remain reachable.
- Implement `_refresh_manual_layout()` rather than leaving it `pass`.
- Make `ui_cancel` close the open manual/record layer before offering HQ return.

Recommended precedence:

```text
ui_cancel
→ close action/result/modal layer if owned by current scene
→ close manual/record drawer
→ restore meaningful focus
→ only then show HQ return confirmation
```

Do not create a new save field for UI visibility.

### Step 2.3 — Establish explicit first-action focus

Add a presentation helper in `scripts/scenes/investigation_scene.gd`, for example:

```gdscript
func _focus_first_enabled_action(container: Node) -> void:
    # find ActionButton descendants in visual order
    # grab first visible, enabled, focusable button
```

Call it after:

- `_show_field_choices()` finishes creating cards.
- `_render_investigation_points()` finishes creating point cards.
- `_show_method_options()` finishes creating method cards.
- returning from a drawer/modal when the previous control is no longer valid.

Use `call_deferred()` when needed so the controls are in-tree before focus is assigned.

### Step 2.4 — Verify blocker correction without broader layout work

Run:

```bash
godot --headless --path . --script res://tests/anomaly_manual_drawer_test.gd
godot --headless --path . --script res://tests/mvp043_investigation_ui_test.gd
godot --headless --path . --script res://tests/investigation_return_flow_test.gd
godot --headless --path . --script res://tests/mvp043_reasoning_ui_test.gd
```

Expected: drawer/focus tests PASS; investigation flow/evidence tests remain PASS.

**Commit:**

```bash
git add scripts/ui/anomaly_manual_drawer.gd \
        scenes/investigation_scene.tscn \
        scripts/scenes/investigation_scene.gd \
        tests/anomaly_manual_drawer_test.gd \
        tests/mvp043_investigation_ui_test.gd
git commit -m "fix: restore investigation action discoverability"
```

---

## Task 3 — Recompose the investigation screen around field → context → action

**Purpose:** implement the approved environment-first hierarchy without changing investigation rules.

**Modify:**
- `scenes/investigation_scene.tscn` — **HiGodot persistent Scene mutation only**
- `scripts/scenes/investigation_scene.gd`
- `tests/mvp043_investigation_ui_test.gd`
- `tests/cinematic_ui_redesign_test.gd`

### Step 3.1 — Add presentation containers while preserving stable controls

Using HiGodot, recompose the scene with presentation-only containers. Exact final node names may be adjusted if existing names collide, but the roles must exist:

```text
SafeFrame/MainColumn
├─ TopHud                        # compact persistent status
├─ PrimaryWorkspace
│  ├─ FieldRow
│  │  ├─ CaseRail               # current point/stage/location navigation
│  │  ├─ EnvironmentStage       # largest visual + short prose
│  │  └─ ContextRail            # acquired context + hypothesis progress
│  └─ DecisionRow
│     ├─ DialogueSupportDock     # current speaker/support
│     └─ InvestigationActionDock # existing action cards / methods
├─ RecordDrawer
└─ ResolutionConfirmPanel
```

Reparent existing stable controls instead of duplicating their state bindings:

- Keep `%PointsBox` and `%MethodButtonBox` as the existing point/method action sources.
- Keep `%FieldDialogueLabel`, `%FieldChoiceBox`, `%ResultToast`, `%ReturnFieldButton`, `%RecordDrawer`, and `%ResolutionConfirmPanel` identities.
- Reuse `%LocationPreview` in the environment stage rather than creating a second field image source.
- Keep `%ManualPanel` hidden compatibility-only; manual content is provided through the drawer path.

Do not reimplement action resolution in new controls.

### Step 3.2 — Add a read-only context rail

In `scripts/scenes/investigation_scene.gd`, add only presentation derivation from existing state. Recommended helpers:

```gdscript
func _refresh_investigation_context() -> void
func _make_acquired_context_text() -> String
func _make_hypothesis_progress_text() -> String
```

Allowed sources:

- collected clues/keywords already exposed by `GameState`
- current field node/title
- existing `_reasoning_point`, `_reasoning_definition`, attempted/eliminated choice state
- player-authored/manual state already available

Forbidden:

- hidden clue names
- `correct_id`
- inferred correct hypothesis
- new truth or ranking calculations

The rail may say `미확정`, `검증 중`, `추가 근거 필요`, or equivalent only when derivable from current visible state.

### Step 3.3 — Implement responsive collapse rules

Add a viewport presentation helper such as:

```gdscript
func _apply_investigation_responsive_layout(viewport_size: Vector2) -> void
```

Call it from `_apply_safe_frame()` / viewport size changes.

For 1920×1080:

- case rail + environment + context rail may be simultaneously visible.
- dialogue/support + actions remain visible.

For 1280×720:

Collapse in this order:

1. reduce decorative margins/separation,
2. compact support portrait/content,
3. collapse `ContextRail` into a button/tab/drawer,
4. shorten secondary prose,
5. move detailed log/manual content to drawers.

Never collapse:

- current case/location identity,
- current danger/status cue,
- first enabled action,
- lock reason for the current action,
- a route to acquired context/manual,
- Esc/back path.

Do not store viewport mode in save data.

### Step 3.4 — Preserve lock and non-color semantics

When existing action data exposes disabled/locked requirements, ensure the visible card includes a textual reason. Do not add a new condition evaluator to UI.

Maintain multiple channels:

- risk = icon/shape + text,
- locked = lock/shape + reason text,
- selected = border/shape + label,
- new context = marker + text.

### Step 3.5 — Verify investigation hierarchy

Focused deterministic runs:

```bash
godot --headless --path . --script res://tests/mvp043_investigation_ui_test.gd
godot --headless --path . --script res://tests/cinematic_ui_redesign_test.gd
godot --headless --path . --script res://tests/mvp043_reasoning_ui_test.gd
godot --headless --path . --script res://tests/mvp043_afterlife_evidence_flow_test.gd
```

Automated checks may establish viewport containment and control state only. They must not be recorded as Human 720p/1080p approval.

**Commit:**

```bash
git add scenes/investigation_scene.tscn \
        scripts/scenes/investigation_scene.gd \
        tests/mvp043_investigation_ui_test.gd \
        tests/cinematic_ui_redesign_test.gd
git commit -m "feat: recompose investigation presentation hierarchy"
```

---

## Task 4 — Make Canon v2 presentation mode-specific and pointer-safe

**Purpose:** preserve Canon v2 rule/protection/termination truth while preventing its full-screen presentation shell from dominating investigation.

**Modify:**
- `scripts/ui/canon_v2_operation_overlay.gd`
- `tests/canon_v2_runtime/canon_v2_operation_overlay_test.gd`
- `tests/canon_v2_runtime/canon_v2_runtime_bridge_test.gd` only if existing bridge behavior must be asserted; avoid production bridge changes unless the current `configure(runtime_state, mode)` seam proves insufficient.

**Prefer not to modify:**
- `scripts/ui/canon_v2_runtime_bridge.gd` because it already classifies scenes and passes `mode` into the overlay.

### Step 4.1 — Make non-interactive full-screen surfaces ignore pointer input

In `CanonV2OperationOverlay._ensure_ui()`:

- root full-rect overlay should not consume pointer input itself.
- `SafeArea` full-rect container should not consume pointer input itself.
- actual interactive panels/buttons continue to use `STOP` as needed.
- confirmation layer remains intentionally modal and continues to use `STOP`.

This protects underlying investigation actions from transparent overlay interception.

### Step 4.2 — Tighten investigation mode visibility

In `_apply_mode_visibility()`:

```text
investigation
- compact RuleStrip: visible
- ManualDetailPanel: closed by default; overlay manual toggle hidden if scene-owned manual entry is authoritative
- ObligationPanel: hidden
- TerminationPreviewPanel: hidden
- FollowUpPanel: hidden regardless of stored follow-up records

rescue
- rule continuity visible
- obligation context allowed
- recovery-only termination hidden

recovery/result
- existing obligation/termination/follow-up behavior preserved
```

When mode changes, force-close any detail panel that is invalid in the new mode so stale visibility cannot leak across configuration refreshes.

Do not remove data from `_runtime_state`; change presentation only.

### Step 4.3 — Preserve confirmation focus and domain gate behavior

Keep unchanged:

- `request_action_confirmation()` preview data source,
- `_build_confirmation_text()`,
- confirm/cancel callbacks,
- previous-focus restoration,
- `CanonV2RuntimeBridge.request_action_gate()` semantic channels and commit flow.

Run:

```bash
godot --headless --path . --script res://tests/canon_v2_runtime/canon_v2_operation_overlay_test.gd
godot --headless --path . --script res://tests/canon_v2_runtime/canon_v2_runtime_bridge_test.gd
```

Expected: investigation presentation assertions PASS and all recovery action-gate tests remain PASS.

**Commit:**

```bash
git add scripts/ui/canon_v2_operation_overlay.gd \
        tests/canon_v2_runtime/canon_v2_operation_overlay_test.gd \
        tests/canon_v2_runtime/canon_v2_runtime_bridge_test.gd
git commit -m "fix: scope canon v2 overlay presentation by scene mode"
```

If `canon_v2_runtime_bridge.gd` requires no production edit, do not touch it merely to match this file list.

---

## Task 5 — Recompose recovery around the anomaly and contextual ally cut-in

**Purpose:** make the anomaly/telegraph the persistent battlefield subject while retaining ally state and all current recovery decisions.

**Modify:**
- `scenes/battle_scene.tscn` — **HiGodot persistent Scene mutation only**
- `scripts/scenes/battle_scene.gd`
- `tests/cinematic_ui_redesign_test.gd`
- `tests/mvp043_recovery_loop_test.gd`
- Canon v2 focused tests only where necessary for unchanged obligation/termination behavior

### Step 5.1 — Make the anomaly stage dominant

Using HiGodot, adjust the existing recovery scene without replacing it:

- Expand `AnomalyPanel` / anomaly confrontation area to become the dominant persistent stage.
- Keep `RecoveryHud` thin.
- Keep `TeamStrip` as the persistent ally representation.
- Keep `ActionDock` and `ResponseGrid` as the decision surface.
- Use the existing `ClueDrawer` / manual drawer path for expanded rules/evidence/log detail.
- Preserve existing unique names and runtime-editor registrations.

Do not create a second battle/recovery state machine.

### Step 5.2 — Reinterpret `RepresentativeVisual` as contextual cut-in

Keep `%RepresentativeVisual` but set it hidden at recovery idle/start.

Add a presentation-only helper in `battle_scene.gd`, for example:

```gdscript
var _representative_cut_in_generation := 0

func _show_representative_cut_in() -> void:
    _representative_cut_in_generation += 1
    var generation := _representative_cut_in_generation
    _refresh_representative_agent()
    _representative_agent_image.visible = true
    await get_tree().create_timer(0.9).timeout
    if generation == _representative_cut_in_generation:
        _representative_agent_image.visible = false
```

The exact implementation may use an existing animation/timer utility, but it must:

- never own or delay the recovery result,
- never block action input after the action is committed,
- tolerate rapid repeated calls without stale timers hiding a newer cut-in,
- remain understandable with motion disabled because ally identity/state is still present in `TeamStrip` and text.

Trigger only for contextual representative/support feedback, not continuously.

### Step 5.3 — Preserve the recovery decision chain

Do not change:

```text
telegraph
→ hypothesis
→ evidence
→ response
→ optional Canon v2 preview/confirmation
→ commit
→ stabilization/learning
→ termination preview/recovery
```

Keep retreat/fallback available under the existing Canon rules.

### Step 5.4 — Verify recovery hierarchy and logic

Run:

```bash
godot --headless --path . --script res://tests/cinematic_ui_redesign_test.gd
godot --headless --path . --script res://tests/mvp043_recovery_loop_test.gd
godot --headless --path . --script res://tests/canon_v2_runtime/canon_v2_operation_overlay_test.gd
godot --headless --path . --script res://tests/canon_v2_runtime/canon_v2_runtime_bridge_test.gd
```

Assertions must show:

- anomaly visual/stage remains visible and dominant,
- `RepresentativeVisual` stable node exists but is hidden at idle,
- ally status remains available in `TeamStrip`,
- telegraph/hypothesis/evidence/response flow is unchanged,
- action confirmation and termination preview remain unchanged semantically,
- no new save fields are created.

**Commit:**

```bash
git add scenes/battle_scene.tscn \
        scripts/scenes/battle_scene.gd \
        tests/cinematic_ui_redesign_test.gd \
        tests/mvp043_recovery_loop_test.gd
git commit -m "feat: center recovery presentation on anomaly state"
```

---

## Task 6 — Exact-head automated regression and authority checks

**Purpose:** prove the implementation did not change protected domain truth or test authority.

### Step 6.1 — Import with Godot 4.7.1

```bash
godot --version
godot --headless --path . --import
```

Expected:

- Godot version 4.7.x, target 4.7.1 in CI/local package.
- no unexpected edits to `project.godot`, `data/episodes/**`, asset bytes, or save authority files.

### Step 6.2 — Run the focused tests again as one set

```bash
godot --headless --path . --script res://tests/anomaly_manual_drawer_test.gd
godot --headless --path . --script res://tests/mvp043_investigation_ui_test.gd
godot --headless --path . --script res://tests/cinematic_ui_redesign_test.gd
godot --headless --path . --script res://tests/mvp043_reasoning_ui_test.gd
godot --headless --path . --script res://tests/mvp043_afterlife_evidence_flow_test.gd
godot --headless --path . --script res://tests/mvp043_recovery_loop_test.gd
godot --headless --path . --script res://tests/canon_v2_runtime/canon_v2_operation_overlay_test.gd
godot --headless --path . --script res://tests/canon_v2_runtime/canon_v2_runtime_bridge_test.gd
```

All must PASS.

### Step 6.3 — Run adopted GUT authority suite

Use the repository's current authority command:

```bash
godot --headless -d -s --path "$PWD" addons/gut/gut_cmdln.gd \
  -gdir=res://tests/gut \
  -ginclude_subdirs \
  -gexit
```

GUT is non-authoring. Capture repository state before/after and require no protected source delta caused by the test run.

### Step 6.4 — Run maintained full Godot regression

```bash
GODOT_BIN=godot bash tests/run_godot_regression.sh
```

The exact total may evolve; use the script's current summary instead of hard-coding a pass count in new current docs.

### Step 6.5 — Check protected diff

```bash
git diff --check
git diff -- project.godot data/episodes ASSET_MANIFEST.yml assets
```

Expected for this feature:

- `project.godot`: no diff
- `data/episodes/**`: no diff
- root `ASSET_MANIFEST.yml`: no diff
- image/audio asset bytes: no feature-driven diff

If any protected diff appears, stop and classify it before continuing.

### Step 6.6 — Push implementation PR and require exact-head CI

The implementation PR must be separate from PR #176. Before readiness/merge:

- verify exact head SHA,
- verify all triggered required checks,
- verify review threads,
- verify protected diff,
- verify no unauthorized image or save/schema mutation,
- keep Human/UI validation `NOT_RUN`.

Do not merge a red, stale-head, or unreviewed implementation candidate.

---

## Task 7 — Actual Windows Human/UI QA after automated green

**Purpose:** validate the rendered experience; this cannot be inferred from CI.

**Files/tools:**
- repository-root `START_HUMAN_QA.cmd`
- existing one-click QA package under `tools/qa/`
- actual user save copied through the approved Prepare → isolated Launch → Collect flow

### Step 7.1 — Run on the actual Windows checkout

From repository root on the user's Windows PC:

```text
START_HUMAN_QA.cmd
```

Do not substitute a GitHub-hosted Windows runner for this Human gate.

### Step 7.2 — Judge the investigation screen

At minimum record `PASS / FAIL / BLOCKED / NOT_RUN` for:

- first 3-second attention goes to field/anomaly rather than a documentation wall,
- first meaningful investigation action is obvious with pointer,
- keyboard focus starts on or reaches the first meaningful action naturally,
- manual opens on request and closes to the previous meaningful focus,
- transparent overlay regions do not eat pointer input,
- locked actions state the reason without color-only coding,
- acquired context/hypothesis state is understandable without exposing hidden truth,
- 1280×720 keeps primary actions visible,
- 1920×1080 uses the full hierarchy without excessive empty/blocked space,
- long Korean text does not overlap or hide actions.

### Step 7.3 — Judge the recovery screen

Record:

- anomaly/telegraph is the persistent visual subject,
- ally HUD remains readable without persistent full-body field occupancy,
- contextual cut-in does not hide telegraph/target/result,
- lower action strip remains discoverable,
- obligation/confirmation/termination information appears at the right decision moment,
- retreat/fallback remains discoverable where allowed,
- keyboard and gamepad focus order matches visual order,
- non-color cues remain sufficient.

### Step 7.4 — Actual-save restart check

Use the existing 18-item Human QA checklist and verify restart/continue behavior with the actual save package. UI layout work must not alter save semantics.

### Step 7.5 — Record without promotion

- Do not convert `NOT_RUN` to PASS without observed evidence.
- If any item fails, open a correction PR and rerun exact-head automated regression before repeating Human QA.
- Android remains a separate later gate.
- Asset approval remains a separate gate; no visual reference becomes a product asset because the UI passed Human QA.

---

## Plan Self-Review

### Spec coverage

- Interaction blocker correction: covered by Tasks 1–2.
- Environment-first investigation hierarchy: covered by Task 3.
- Compact/contextual Canon v2 investigation presentation: covered by Task 4.
- Anomaly-centered recovery hierarchy: covered by Task 5.
- 1280×720 / 1920×1080, keyboard/gamepad, accessibility, actual save: covered by Task 7.
- Human vs automated evidence separation: explicit in Tasks 6–7.
- Reference-only image handling / asset approval boundary: preserved globally and in Task 7.

### Placeholder check

No production TODO, dummy implementation, new domain data, or hidden-state assumptions are authorized by this plan. Presentation labels must be derived from existing visible state.

### Type / interface consistency

- `AnomalyManualDrawer` remains presentation-only.
- `ActionChoiceCard` continues to emit action IDs rather than resolving results.
- `CanonV2RuntimeBridge` remains the existing mode/state bridge unless tests prove a minimal presentation-only change is required.
- `GameState` remains unmodified for this feature.
- stable `ManualPanel` / `RepresentativeVisual` identities may remain for compatibility while visibility/role changes.

### Rollback

Because domain/save/data are unchanged, rollback is the implementation PR revert. The rollback must restore the previous scene/layout scripts and tests together; do not selectively revert tests while keeping the new behavior or vice versa.

## Execution Gate

The plan is complete when it is reviewed and synchronized under the same Decision ID. It does **not** authorize this ChatGPT session to bypass the HiGodot authoring boundary.

Recommended execution path:

```text
PR #176 spec + plan exact-head green
→ planning/canon merge gate
→ fresh latest-main/Base/Sheet preflight
→ new dedicated HiGodot implementation branch/PR
→ Task 1 RED tests
→ Tasks 2–5 minimal implementation slices
→ Task 6 exact-head automated regression
→ implementation PR merge only after green/review
→ Task 7 actual Windows Human/UI QA
→ correction PR if needed
```

If HiGodot is unavailable at the implementation gate, stop at the approved plan and hand off this file unchanged to a HiGodot-capable execution environment.