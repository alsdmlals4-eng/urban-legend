# Post-clear Return Pointer Passthrough Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:executing-plans` to implement this plan task-by-task. Every runtime behavior slice uses `superpowers:test-driven-development`, and any completion claim requires `superpowers:verification-before-completion`.
>
> **Existing owner Decision:** `D-2026-08-10-ROUTE-RESTORE-ENDPOINT-CONNECTIVITY`
> **Observed blocker:** `POST_CLEAR_RETURN_INPUT_BLOCKED`
> **Planning baseline:** project `main` `cba130ee156c89710d3ddef33ed677bf99aa0716`
> **Isolated branch:** `agent/post-clear-return-pointer-passthrough-20260811`
> **Godot target:** 4.7.1 stable

**Goal:** Allow a real mouse click on the underlying post-clear `현장 기록으로 복귀` control to pass through Canon v2 read-only result detail panels while keeping confirmation/backdrop layers pointer-blocking.

**Architecture:** Keep the existing `CanonV2OperationOverlay` and result flow. Extend the existing real-input regression so it clicks an underlying button at coordinates covered by a visible result detail panel; then make only the read-only detail panel subtree pointer-transparent. Do not change route logic, save semantics, confirmation behavior, scene ownership, or visual hierarchy.

**Tech Stack:** Godot 4.7.1, GDScript, existing SceneTree regression scripts, GitHub Actions `Validate Canon v2 Runtime UX`.

## Global Constraints

- Preserve `scripts/scenes/minigame_scene.gd` return-flow ownership and callback behavior.
- Preserve confirmation/backdrop pointer blocking; active confirmation must remain the full-screen blocker.
- Preserve the interactive manual drawer/toggle behavior; do not make `ManualDetailPanel` pointer-transparent.
- Change no route reachability, endpoint, reward, save payload, scene path, data, asset, or `project.godot` behavior.
- Do not claim Human QA from automated evidence.
- Product GDScript mutation must respect the approved HiGodot authoring authority. Test scripts may be written by a code-authoring agent under the existing authority matrix.
- No production code before a failing regression has been observed on the exact RED head.

---

### Task 1: Reproduce the result-mode pointer blocker with a real input regression

**Files:**
- Modify: `tests/canon_v2_runtime/canon_v2_operation_overlay_test.gd`
- Verify through: `tests/run_canon_v2_runtime_ux_tests.sh`

**Interfaces:**
- Consumes: `CanonV2OperationOverlay.configure_for_test(runtime_state: Dictionary, mode: String)` and the existing `ObligationPanel` node path.
- Produces: a regression that fails when a visible read-only result detail subtree intercepts a real mouse press/release intended for an underlying button.

- [ ] **Step 1: Add a result-mode real-click helper**

Add a helper that receives the configured overlay, places a real `Button` behind the visible `ObligationPanel`, clicks the overlapping center coordinate through `Viewport.push_input()`, and expects exactly one `pressed` signal.

```gdscript
func _verify_result_detail_pointer_passthrough(overlay: Control) -> void:
	var obligation_panel := overlay.get_node_or_null("SafeArea/RootLayout/DetailStack/ObligationPanel") as Control
	_expect(obligation_panel != null and obligation_panel.visible, "result pointer test requires a visible obligation panel")
	if obligation_panel == null or not obligation_panel.visible:
		return

	var panel_rect := obligation_panel.get_global_rect()
	_expect(panel_rect.size.x > 0.0 and panel_rect.size.y > 0.0, "result pointer test requires a laid-out obligation panel")
	if panel_rect.size.x <= 0.0 or panel_rect.size.y <= 0.0:
		return

	var action_button := Button.new()
	action_button.name = "UnderlyingPostClearReturnAction"
	action_button.text = "현장 기록으로 복귀"
	action_button.position = panel_rect.position
	action_button.size = panel_rect.size
	_underlying_pressed_count = 0
	action_button.pressed.connect(func() -> void: _underlying_pressed_count += 1)
	root.add_child(action_button)
	root.move_child(action_button, 0)
	await process_frame

	var click_position := panel_rect.get_center()
	var press := InputEventMouseButton.new()
	press.position = click_position
	press.button_index = MOUSE_BUTTON_LEFT
	press.pressed = true
	root.get_viewport().push_input(press, true)
	var release := InputEventMouseButton.new()
	release.position = click_position
	release.button_index = MOUSE_BUTTON_LEFT
	release.pressed = false
	root.get_viewport().push_input(release, true)
	await process_frame

	_expect(_underlying_pressed_count == 1, "read-only result detail must allow actual mouse press/release to reach the underlying post-clear return action")
	action_button.queue_free()
```

- [ ] **Step 2: Invoke the helper in result mode before any production change**

After the existing investigation passthrough checks, configure `runtime_state` with mode `"result"`, wait one frame, and call the new helper.

```gdscript
	overlay.configure_for_test(runtime_state, "result")
	await process_frame
	await _verify_result_detail_pointer_passthrough(overlay)
```

- [ ] **Step 3: Verify RED on the exact test-only head**

Focused command:

```bash
godot --headless --path . --script res://tests/canon_v2_runtime/canon_v2_operation_overlay_test.gd
```

Maintained focused-suite command:

```bash
GODOT_BIN=godot bash tests/run_canon_v2_runtime_ux_tests.sh
```

Expected result before implementation: **FAIL** with `read-only result detail must allow actual mouse press/release to reach the underlying post-clear return action`. The failure must be caused by the visible result overlay intercepting the real click, not by missing nodes, zero layout size, syntax errors, or import errors.

- [ ] **Step 4: Commit the RED regression without production code**

```bash
git add tests/canon_v2_runtime/canon_v2_operation_overlay_test.gd
git commit -m "test: reproduce post-clear return pointer blocker"
```

---

### Task 2: Make only read-only detail panels pointer-transparent

**Files:**
- Modify: `scripts/ui/canon_v2_operation_overlay.gd`
- Test: `tests/canon_v2_runtime/canon_v2_operation_overlay_test.gd`

**Interfaces:**
- Consumes: `_make_detail_panel(panel_name: String, border_color: Color) -> PanelContainer`.
- Produces: read-only detail panel subtrees whose effective mouse filter is ignore, without changing confirmation or manual-interaction layers.

- [ ] **Step 1: Apply the smallest runtime policy that can satisfy the RED behavior**

In `_make_detail_panel()`, keep the existing style and identity but disable mouse behavior recursively for that read-only subtree:

```gdscript
func _make_detail_panel(panel_name: String, border_color: Color) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.name = panel_name
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_DISABLED
	panel.add_theme_stylebox_override("panel", _panel_style(Color(0.045, 0.05, 0.065, 0.94), border_color))
	return panel
```

This is intentionally limited to `_make_detail_panel()`. `RuleStripPanel`, `ManualDetailPanel`, `ConfirmationLayer`, `Backdrop`, and confirmation buttons keep their current interaction contracts.

- [ ] **Step 2: Verify GREEN on the focused regression**

```bash
godot --headless --path . --script res://tests/canon_v2_runtime/canon_v2_operation_overlay_test.gd
```

Expected: `CANON V2 OPERATION OVERLAY: PASS` and exit 0.

- [ ] **Step 3: Verify the maintained Canon v2 runtime/UX suite**

```bash
GODOT_BIN=godot bash tests/run_canon_v2_runtime_ux_tests.sh
```

Expected: every listed Canon v2 runtime/UX script exits 0.

- [ ] **Step 4: Preserve blocking confirmation semantics**

The existing assertions must still prove:

```text
active ConfirmationLayer = visible + MOUSE_FILTER_STOP
closed ConfirmationLayer = hidden + MOUSE_FILTER_IGNORE
Backdrop = MOUSE_FILTER_STOP
```

Do not weaken or delete these assertions to obtain GREEN.

- [ ] **Step 5: Commit the minimal GREEN implementation**

```bash
git add scripts/ui/canon_v2_operation_overlay.gd tests/canon_v2_runtime/canon_v2_operation_overlay_test.gd
git commit -m "fix: let post-clear return clicks pass read-only overlay details"
```

---

### Task 3: Exact-head validation and integration gate

**Files:**
- No additional product files expected.
- PR metadata/evidence only after code is GREEN.

**Interfaces:**
- Consumes: Task 2 exact head.
- Produces: a Draft PR and evidence boundary that PR #186 can safely consume after this isolated fix merges.

- [ ] **Step 1: Run static diff checks**

```bash
git diff --check cba130ee156c89710d3ddef33ed677bf99aa0716..HEAD
git diff --name-only cba130ee156c89710d3ddef33ed677bf99aa0716..HEAD
```

Expected changed runtime/test scope: `scripts/ui/canon_v2_operation_overlay.gd`, `tests/canon_v2_runtime/canon_v2_operation_overlay_test.gd`, plus this implementation plan.

- [ ] **Step 2: Open a Draft PR against current `main`**

PR must state that this is the isolated blocker fix for PR #186 and that PR #186 itself remains unmerged.

- [ ] **Step 3: Require exact-head `Validate Canon v2 Runtime UX` success**

The workflow must run because both changed runtime/test paths are included in `.github/workflows/validate-canon-v2-runtime-ux.yml`.

- [ ] **Step 4: Run Windows Human QA after automated GREEN**

Required actual flow:

```text
route clear succeeds
→ saved-result UI shows 성공
→ click 현장 기록으로 복귀 with a real pointer
→ next battle/recovery flow opens
→ no confirmation/backdrop click leaks through
```

Human QA remains `NOT_RUN` until this is performed on the Windows project.

- [ ] **Step 5: Rebase/update PR #186 only after this isolated fix is integrated**

Re-run route focused tests, maintained suites, exact-head CI, and the route Human QA gate. Do not use the blocker-fix PR's PASS as a substitute for PR #186 exact-head evidence.
