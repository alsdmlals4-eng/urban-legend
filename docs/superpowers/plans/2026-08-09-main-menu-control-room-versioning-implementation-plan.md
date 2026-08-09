# Main Menu Control-Room + Product Versioning Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the menu-local `Ver 4.2` literal with one canonical `4.3` product-version owner and rebuild the main menu as the approved left-identity / center-actions / right-intelligence control-room layout without changing Legacy/Validation persistence semantics.

**Architecture:** Keep `scenes/main_menu.tscn` as the existing minimal root `Control` and keep `scripts/ui/main_menu.gd` as the runtime presentation/controller owner. Add one small `scripts/core/product_version.gd` source owner, then refactor only the menu construction into named rail helpers; the right rail reads already-public episode and persistence summaries but never writes domain state. Extend the existing Package 2 main-menu contract test instead of creating a second competing menu test harness.

**Tech Stack:** Godot 4.7.1, GDScript, existing `UiThemeFactory`, existing `UiAssetCatalog`, existing Package 2 Validation coordinator/inspector, SceneTree headless tests, Python `unittest`, adopted GUT 9.7.1 regression authority, GitHub Actions.

## Global Constraints

- Decision: `D-2026-08-09-MAIN-MENU-CONTROL-ROOM-VERSIONING`.
- Approved product/UI version is exactly `4.3`; display text is exactly `Ver 4.3`.
- Future `4.4 → 4.5 → …` increments edit only the canonical product-version owner and require their own approved product/UI step.
- The approved control-room mockup is `REFERENCE_ONLY`; do not add it to the repository, `ASSET_MANIFEST.yml`, or any product asset path.
- `PROJECT_ASSET_APPROVED = 0` remains unchanged.
- Mockup-only dates, investigator names, risk labels, save-slot values, system-alert copy, and other illustrative fiction are non-canonical and must not be copied into runtime truth.
- Preserve `LegacyContinueButton`, `LegacyNewCampaignButton`, `ValidationPrimaryButton`, `ValidationSecondaryButton`, `DatabaseButton`, `LegacyStatusLabel`, `ValidationStatusLabel`, `ValidationBadgeLabel`, and the existing Validation dialogs.
- Preserve Validation fail-closed behavior and Legacy/Validation persistence isolation.
- `scripts/core/game_state.gd`, `data/episodes/**`, save schemas, campaign/economy/ending semantics, `project.godot`, and PR #180 are outside this implementation scope.
- Do not modify `scenes/main_menu.tscn`; the current root-Control scene is sufficient. If a later blocker proves a Scene/Node/Resource/Project Settings mutation is necessary, stop that mutation and route it through HiGodot, the sole persistent Godot authoring authority.
- GUT remains deterministic non-authoring test authority. Hera is outside this Decision and may not author product source.
- At 1280×720 the title/version, meaningful primary action, Legacy/Validation distinction, status/error feedback, and keyboard route remain usable without a document-wall `ScrollContainer`.
- At 1920×1080 the right rail may expose the existing preview/summary while core action travel stays compact.
- Human/UI/Android remain `NOT_RUN` until actual evidence exists.

---

## Prerequisite: Planning Merge and Isolated Execution Worktree

Do not execute runtime tasks from the planning PR branch. The Decision, approved spec, and this plan must first be present on current `main` through the planning merge gate.

At execution time, use `superpowers:using-git-worktrees` and create a fresh implementation worktree from the then-current `origin/main`:

```powershell
Set-Location 'C:\Users\user\Documents\GitHub\Ninza\urban-legend'
git fetch origin
$impl = 'C:\Users\user\Documents\GitHub\Ninza\urban-legend-main-menu-v43'
if (Test-Path $impl) { throw "Implementation worktree path already exists: $impl" }
git worktree add -b agent/main-menu-control-room-v43-implementation-20260809 $impl origin/main
Set-Location $impl
git status --short --branch
```

Before Task 1, verify the checkout contains:

```powershell
git grep -n "D-2026-08-09-MAIN-MENU-CONTROL-ROOM-VERSIONING" -- docs
git grep -n "Status: ``APPROVED``" -- docs/superpowers/specs/2026-08-09-main-menu-control-room-versioning-design.md
```

Expected: both commands match the merged planning canon; working tree is clean.

---

## File Structure

### Create

- `scripts/core/product_version.gd` — single canonical product/UI version owner; no engine/save/addon version coupling.
- `tests/test_main_menu_control_room_static_contract.py` — static guard for one version source, no `Ver 4.2`, no mockup fiction, no document-wall construction.

Godot 4.7.1 may create `scripts/core/product_version.gd.uid` when the new script is imported. Do not hand-author a UID. If the project import generates the sidecar, verify it is the UID for `product_version.gd` and include that exact generated file with the implementation commit.

### Modify

- `scripts/ui/main_menu.gd` — consume `ProductVersion`; build named identity/action/intelligence rails; add Settings/Exit utilities; render existing read-only case/save status; align primary emphasis, focus, and responsive behavior.
- `tests/validation/validation_main_menu_contract_test.gd` — add the approved version/layout/focus/responsive/read-only assertions while retaining all existing Package 2 persistence tests.

### Must remain unchanged

- `scenes/main_menu.tscn`
- `project.godot`
- `scripts/core/game_state.gd`
- `data/episodes/**`
- `ASSET_MANIFEST.yml`
- `assets/**`
- PR #180 branch/content

No `tests/run_godot_regression.sh` edit is needed because `validation/validation_main_menu_contract_test` is already part of the maintained 58-entry legacy suite.

---

### Task 1: TDD RED — Lock the 4.3, Control-Room, and Non-Fiction Contracts

**Files:**
- Create: `tests/test_main_menu_control_room_static_contract.py`
- Modify: `tests/validation/validation_main_menu_contract_test.gd`

**Interfaces:**
- Consumes: current `res://scenes/main_menu.tscn`, current `main_menu.gd`, existing Package 2 test fixtures.
- Produces: failing-before-fix contracts for `ProductVersion`, named three-rail layout, initial focus, responsive behavior, settings utility, and canonical-only intelligence.

- [ ] **Step 1: Add the static contract test without touching production code**

Create `tests/test_main_menu_control_room_static_contract.py`:

```python
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[1]
MENU = ROOT / "scripts" / "ui" / "main_menu.gd"
VERSION_OWNER = ROOT / "scripts" / "core" / "product_version.gd"


class MainMenuControlRoomStaticContract(unittest.TestCase):
    def test_product_version_has_one_owner(self) -> None:
        self.assertTrue(VERSION_OWNER.exists(), "canonical product_version.gd must exist")
        owner = VERSION_OWNER.read_text(encoding="utf-8")
        menu = MENU.read_text(encoding="utf-8")
        self.assertIn('const CURRENT := "4.3"', owner)
        self.assertIn('return "Ver %s" % CURRENT', owner)
        self.assertIn('preload("res://scripts/core/product_version.gd")', menu)
        self.assertNotIn("const GAME_VERSION", menu)
        self.assertNotIn("Ver 4.2", menu)
        self.assertNotIn('"4.3"', menu, "main_menu.gd must not duplicate the product version literal")

    def test_main_menu_is_not_a_document_wall(self) -> None:
        menu = MENU.read_text(encoding="utf-8")
        self.assertNotIn("ScrollContainer.new()", menu)
        for required_name in [
            'name = "MenuShell"',
            'name = "IdentityRail"',
            'name = "ActionRail"',
            'name = "IntelligenceRail"',
            'name = "VersionLabel"',
            'name = "PrimaryActionHint"',
            'name = "SettingsButton"',
            'name = "ExitButton"',
        ]:
            self.assertIn(required_name, menu)

    def test_reference_mockup_fiction_is_not_baked_into_runtime(self) -> None:
        menu = MENU.read_text(encoding="utf-8")
        for forbidden in ["김하람", "SYSTEM ALERT", "슬롯 01", "매우 높음", "2011. 08. 11"]:
            self.assertNotIn(forbidden, menu)


if __name__ == "__main__":
    unittest.main()
```

- [ ] **Step 2: Extend the existing SceneTree main-menu contract with new RED assertions**

In `tests/validation/validation_main_menu_contract_test.gd`, after the existing required-node loop, add:

```gdscript
	for node_name in [
		"MenuShell", "IdentityRail", "ActionRail", "IntelligenceRail",
		"VersionLabel", "PrimaryActionHint", "CurrentCaseTitle",
		"CurrentCaseMeta", "CurrentCaseSummary", "CurrentCasePreview",
		"LegacyIntelStatus", "ValidationIntelStatus",
		"SettingsButton", "SettingsPanel", "ExitButton"
	]:
		_expect(menu.find_child(node_name, true, false) != null, "%s must exist" % node_name)

	var version_label := menu.find_child("VersionLabel", true, false) as Label
	var primary_hint := menu.find_child("PrimaryActionHint", true, false) as Label
	var current_case_title := menu.find_child("CurrentCaseTitle", true, false) as Label
	var settings_button := menu.find_child("SettingsButton", true, false) as Button
	var settings_panel := menu.find_child("SettingsPanel", true, false) as Control
	var exit_button := menu.find_child("ExitButton", true, false) as Button
	_expect(version_label != null and version_label.text == "Ver 4.3", "menu must display canonical Ver 4.3")
	_expect(primary_hint != null and "새 캠페인 시작" in primary_hint.text, "empty Legacy state must name new campaign as primary action")
	_expect(current_case_title != null and "저승역" in current_case_title.text, "current-case title must come from the loaded canonical episode")
	_expect(settings_button != null and settings_button.focus_mode == Control.FOCUS_ALL, "settings utility must be keyboard focusable")
	_expect(settings_panel != null and not settings_panel.visible, "settings panel must start collapsed")
	_expect(exit_button != null and exit_button.focus_mode == Control.FOCUS_ALL, "exit utility must be keyboard focusable")
	_expect(menu.find_children("*", "ScrollContainer", true, false).is_empty(), "main menu must not require a document-wall ScrollContainer")

	await process_frame
	var initial_focus := root.gui_get_focus_owner()
	_expect(initial_focus == legacy_new_button, "no-save initial focus must match the visually primary new-campaign action")
	_expect(_inside_viewport(menu.find_child("VersionLabel", true, false) as Control), "Ver 4.3 must fit inside 1280x720")
	_expect(_inside_viewport(legacy_new_button), "primary Legacy action must fit inside 1280x720")
```

Before `_cleanup`, add responsive/settings assertions:

```gdscript
	settings_button.pressed.emit()
	_expect(settings_panel.visible, "settings button must expose the existing accessibility surface")
	settings_button.pressed.emit()
	_expect(not settings_panel.visible, "settings button must collapse the accessibility surface")

	var case_preview := menu.find_child("CurrentCasePreview", true, false) as Control
	var case_summary := menu.find_child("CurrentCaseSummary", true, false) as Control
	_expect(case_preview != null and not case_preview.visible, "1280x720 must compact the secondary case preview first")
	_expect(case_summary != null and not case_summary.visible, "1280x720 must compact the secondary case summary first")

	root.size = Vector2i(1920, 1080)
	await process_frame
	await process_frame
	_expect(case_preview.visible, "1920x1080 may expose the existing case preview")
	_expect(case_summary.visible, "1920x1080 may expose the existing case summary")
```

Add this helper near the bottom of the test:

```gdscript
func _inside_viewport(control: Control) -> bool:
	if control == null:
		return false
	var viewport_rect := Rect2(Vector2.ZERO, Vector2(root.size))
	return viewport_rect.encloses(control.get_global_rect())
```

Do not remove or weaken any existing Package 2 assertions.

- [ ] **Step 3: Run focused RED tests**

Run from the isolated implementation worktree:

```bash
python -m unittest tests.test_main_menu_control_room_static_contract -v
GODOT_TEST_TMP="$(mktemp -d)" godot --headless --path . --script res://tests/validation/validation_main_menu_contract_test.gd
```

Expected RED:

- Python fails because `scripts/core/product_version.gd` does not exist and `main_menu.gd` still contains `GAME_VERSION`, `Ver 4.2`, and `ScrollContainer.new()`.
- Godot contract loads successfully but reports the new named rail/version/settings nodes are absent and the new primary-focus/layout expectations are unmet.
- Parse errors, missing existing Package 2 nodes, or fixture/setup failures are not accepted as valid RED; repair the test harness only if those occur.

- [ ] **Step 4: Commit the tests-only RED state**

```bash
git add tests/test_main_menu_control_room_static_contract.py tests/validation/validation_main_menu_contract_test.gd
git commit -m "test: define main menu control-room contracts"
```

---

### Task 2: GREEN Slice 1 — Add the Single Product-Version Owner

**Files:**
- Create: `scripts/core/product_version.gd`
- Modify: `scripts/ui/main_menu.gd`
- Generated by Godot import when applicable: `scripts/core/product_version.gd.uid`

**Interfaces:**
- Produces: `ProductVersion.CURRENT: String = "4.3"`; `ProductVersion.display_text() -> String`.
- Consumed by: `main_menu.gd` version label and any menu version/update title.

- [ ] **Step 1: Create the canonical owner**

Create `scripts/core/product_version.gd` exactly as:

```gdscript
class_name ProductVersion
extends RefCounted

const CURRENT := "4.3"


static func display_text() -> String:
	return "Ver %s" % CURRENT
```

- [ ] **Step 2: Replace menu-local version ownership**

At the top of `scripts/ui/main_menu.gd`, add:

```gdscript
const ProductVersion = preload("res://scripts/core/product_version.gd")
```

Delete:

```gdscript
const GAME_VERSION := "Ver 4.2"
```

When building the version label, give it a stable name and use the owner:

```gdscript
	var version_label := Label.new()
	version_label.name = "VersionLabel"
	version_label.text = ProductVersion.display_text()
```

In `_add_update_notice`, replace the old title expression with:

```gdscript
	title.text = "%s 변경사항" % ProductVersion.display_text()
```

Do not write `"4.3"` or `"Ver 4.3"` anywhere in `main_menu.gd`.

- [ ] **Step 3: Let Godot import the new script and verify UID behavior**

Use the approved Godot/HiGodot execution path to import/reload the project. Then inspect only the new script UID state:

```bash
git status --short scripts/core/product_version.gd scripts/core/product_version.gd.uid
```

If Godot generated `scripts/core/product_version.gd.uid`, keep that exact generated sidecar. Do not synthesize or copy a UID from another script.

- [ ] **Step 4: Run the version/static contract**

```bash
python -m unittest tests.test_main_menu_control_room_static_contract.MainMenuControlRoomStaticContract.test_product_version_has_one_owner -v
```

Expected: PASS. The other static/layout test remains RED because the three-rail shell is not implemented yet.

- [ ] **Step 5: Commit the version owner**

```bash
git add scripts/core/product_version.gd scripts/ui/main_menu.gd
if [ -f scripts/core/product_version.gd.uid ]; then git add scripts/core/product_version.gd.uid; fi
git commit -m "feat: centralize product version 4.3"
```

---

### Task 3: GREEN Slice 2 — Build the Three-Rail Control-Room Shell and Utilities

**Files:**
- Modify: `scripts/ui/main_menu.gd`

**Interfaces:**
- Produces stable runtime controls: `MenuShell`, `IdentityRail`, `ActionRail`, `IntelligenceRail`, `PrimaryActionHint`, `SettingsButton`, `SettingsPanel`, `ExitButton`.
- Reuses existing `_build_entry_cards`, `_add_section`, `_add_effect_slider`, database and Validation handlers.

- [ ] **Step 1: Add rail/utility state fields**

Add typed fields near the existing control variables:

```gdscript
var _menu_shell: HBoxContainer
var _identity_rail: VBoxContainer
var _action_rail: VBoxContainer
var _intelligence_rail: VBoxContainer
var _primary_action_hint: Label
var _current_case_preview: TextureRect
var _current_case_title: Label
var _current_case_meta: Label
var _current_case_summary: Label
var _legacy_intel_status: Label
var _validation_intel_status: Label
var _settings_button: Button
var _settings_panel: Control
var _exit_button: Button
```

- [ ] **Step 2: Replace the document-wall body of `_build_ui()` with the named shell**

Keep the existing backdrop asset and dark overlay, but remove the `ScrollContainer`. Build the layout with this structure:

```gdscript
	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 24)
	margin.add_theme_constant_override("margin_top", 24)
	margin.add_theme_constant_override("margin_right", 24)
	margin.add_theme_constant_override("margin_bottom", 24)
	add_child(margin)

	_menu_shell = HBoxContainer.new()
	_menu_shell.name = "MenuShell"
	_menu_shell.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_menu_shell.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_menu_shell.add_theme_constant_override("separation", 18)
	margin.add_child(_menu_shell)

	_identity_rail = _make_menu_rail(_menu_shell, "IdentityRail", 260.0, 0.82, Color("31434d"))
	_action_rail = _make_menu_rail(_menu_shell, "ActionRail", 410.0, 1.18, ThemeFactory.COLOR_AMBER)
	_intelligence_rail = _make_menu_rail(_menu_shell, "IntelligenceRail", 320.0, 1.0, ThemeFactory.COLOR_TEAL)

	_build_identity_rail(_identity_rail)
	_build_action_rail(_action_rail)
	_build_intelligence_rail(_intelligence_rail)
	_build_validation_dialogs()
	_configure_entry_focus()
	resized.connect(_apply_responsive_layout)
	_apply_responsive_layout()
```

Add the rail helper:

```gdscript
func _make_menu_rail(
	parent: Control,
	name_value: String,
	minimum_width: float,
	stretch_ratio: float,
	accent: Color
) -> VBoxContainer:
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	panel.size_flags_stretch_ratio = stretch_ratio
	panel.custom_minimum_size.x = minimum_width
	panel.add_theme_stylebox_override("panel", ThemeFactory.panel_style(accent, 0.90))
	parent.add_child(panel)

	var rail := VBoxContainer.new()
	rail.name = name_value
	rail.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	rail.size_flags_vertical = Control.SIZE_EXPAND_FILL
	rail.add_theme_constant_override("separation", 12)
	panel.add_child(rail)
	return rail
```

- [ ] **Step 3: Build the identity rail with canonical version text**

Add:

```gdscript
func _build_identity_rail(parent: VBoxContainer) -> void:
	var title := Label.new()
	title.name = "BureauTitle"
	title.text = "괴이기록국"
	title.add_theme_font_size_override("font_size", 42)
	title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	parent.add_child(title)

	var english := Label.new()
	english.text = "Urban Legend Archive Bureau"
	english.add_theme_color_override("font_color", ThemeFactory.COLOR_MUTED)
	english.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	parent.add_child(english)

	var version_label := Label.new()
	version_label.name = "VersionLabel"
	version_label.text = ProductVersion.display_text()
	version_label.add_theme_font_size_override("font_size", 18)
	version_label.add_theme_color_override("font_color", ThemeFactory.COLOR_AMBER)
	parent.add_child(version_label)

	var mission := Label.new()
	mission.text = "괴이의 규칙을 조사하고 현재 출현을 안정화해 다음 피해를 막을 기록을 남깁니다."
	mission.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	parent.add_child(mission)
```

Do not copy the mockup's government affiliation, clearance level, barcode, dates, or user identity.

- [ ] **Step 4: Rebuild `EntryCards` as a vertical action-domain stack**

In `_build_entry_cards`, change only the container shape and compact the descriptions; preserve all stable node names and handlers:

```gdscript
	var entry_cards := VBoxContainer.new()
	entry_cards.name = "EntryCards"
	entry_cards.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	entry_cards.add_theme_constant_override("separation", 10)
	parent.add_child(entry_cards)
```

Keep the existing Legacy and Validation controls, but use section headings `본편` and `Validation 기록`. Do not change their persistence actions.

- [ ] **Step 5: Build action utilities without a new settings persistence model**

Add:

```gdscript
func _build_action_rail(parent: VBoxContainer) -> void:
	var heading := Label.new()
	heading.text = "MAIN MENU"
	heading.add_theme_color_override("font_color", ThemeFactory.COLOR_MUTED)
	parent.add_child(heading)

	_primary_action_hint = Label.new()
	_primary_action_hint.name = "PrimaryActionHint"
	_primary_action_hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_primary_action_hint.add_theme_color_override("font_color", ThemeFactory.COLOR_AMBER)
	parent.add_child(_primary_action_hint)

	_build_entry_cards(parent)

	var utility := _add_section(parent, "기록국 도구")
	_database_button = Button.new()
	_database_button.name = "DatabaseButton"
	_database_button.text = "기록 보관실"
	_database_button.focus_mode = Control.FOCUS_ALL
	_database_button.pressed.connect(_open_database)
	utility.add_child(_database_button)

	_settings_button = Button.new()
	_settings_button.name = "SettingsButton"
	_settings_button.text = "설정 / 접근성"
	_settings_button.focus_mode = Control.FOCUS_ALL
	_settings_button.pressed.connect(_toggle_settings_panel)
	utility.add_child(_settings_button)

	_exit_button = Button.new()
	_exit_button.name = "ExitButton"
	_exit_button.text = "종료"
	_exit_button.focus_mode = Control.FOCUS_ALL
	_exit_button.pressed.connect(func() -> void: get_tree().quit())
	utility.add_child(_exit_button)
```

- [ ] **Step 6: Reuse the existing accessibility sliders as a collapsed SettingsPanel**

Change `_add_accessibility_panel` to return its panel control:

```gdscript
func _add_accessibility_panel(parent: Control) -> Control:
	var content := _add_section(parent, "설정 / 접근성", "화면 연출을 편한 수준으로 조절합니다.")
	_add_effect_slider(content, "화면 흔들림", "screen_shake")
	_add_effect_slider(content, "섬광", "flash")
	_add_effect_slider(content, "공포 왜곡", "horror_distortion")
	return content.get_parent()
```

Add:

```gdscript
func _toggle_settings_panel() -> void:
	if _settings_panel == null:
		return
	_settings_panel.visible = not _settings_panel.visible
```

The panel remains backed by the existing `Accessibility` object; no new file format, save field, or preference repository is introduced.

- [ ] **Step 7: Run the focused contract and inspect remaining failures**

```bash
GODOT_TEST_TMP="$(mktemp -d)" godot --headless --path . --script res://tests/validation/validation_main_menu_contract_test.gd
python -m unittest tests.test_main_menu_control_room_static_contract -v
```

Expected after this slice: static layout/version assertions pass. The focused Godot test may still fail only on right-rail canonical data, responsive preview visibility, and primary-focus/emphasis expectations addressed by Tasks 4-5.

- [ ] **Step 8: Commit the shell**

```bash
git add scripts/ui/main_menu.gd
git commit -m "feat: rebuild main menu as control-room rails"
```

---

### Task 4: GREEN Slice 3 — Populate the Right Rail from Existing Read-Only Canon Only

**Files:**
- Modify: `scripts/ui/main_menu.gd`

**Interfaces:**
- Consumes: `GameState.get_current_episode() -> Dictionary`, `GameState.has_save_file() -> bool`, existing `_validation_summary`, existing `UiAssetCatalog` asset IDs already present in episode data.
- Produces: `CurrentCaseTitle`, `CurrentCaseMeta`, `CurrentCaseSummary`, `CurrentCasePreview`, `LegacyIntelStatus`, `ValidationIntelStatus` presentation only.

- [ ] **Step 1: Build the right-intelligence controls and the existing settings panel**

Add:

```gdscript
func _build_intelligence_rail(parent: VBoxContainer) -> void:
	var case_content := _add_section(parent, "현재 사건")

	_current_case_title = Label.new()
	_current_case_title.name = "CurrentCaseTitle"
	_current_case_title.add_theme_font_size_override("font_size", 28)
	case_content.add_child(_current_case_title)

	_current_case_meta = Label.new()
	_current_case_meta.name = "CurrentCaseMeta"
	_current_case_meta.add_theme_color_override("font_color", ThemeFactory.COLOR_MUTED)
	_current_case_meta.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	case_content.add_child(_current_case_meta)

	_current_case_preview = TextureRect.new()
	_current_case_preview.name = "CurrentCasePreview"
	_current_case_preview.custom_minimum_size = Vector2(0, 150)
	_current_case_preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_current_case_preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	_current_case_preview.mouse_filter = Control.MOUSE_FILTER_IGNORE
	case_content.add_child(_current_case_preview)

	_current_case_summary = Label.new()
	_current_case_summary.name = "CurrentCaseSummary"
	_current_case_summary.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	case_content.add_child(_current_case_summary)

	var status_content := _add_section(parent, "기록 상태")
	_legacy_intel_status = Label.new()
	_legacy_intel_status.name = "LegacyIntelStatus"
	_legacy_intel_status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	status_content.add_child(_legacy_intel_status)

	_validation_intel_status = Label.new()
	_validation_intel_status.name = "ValidationIntelStatus"
	_validation_intel_status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	status_content.add_child(_validation_intel_status)

	_settings_panel = _add_accessibility_panel(parent)
	_settings_panel.name = "SettingsPanel"
	_settings_panel.visible = false

	_log_guide = LogGuideScript.new()
	_log_guide.set_compact(true)
	parent.add_child(_log_guide)
	_present_log_entry()
```

Keep the debug/test panel hidden and outside the normal visual priority; it may remain under the intelligence rail because F1 already gates it to debug builds.

- [ ] **Step 2: Render only public canonical episode fields**

Add:

```gdscript
func _refresh_intelligence_rail() -> void:
	if _current_case_title == null:
		return
	var current: Dictionary = GameState.get_current_episode()
	var episode_value: Variant = current.get("episode", {})
	var episode: Dictionary = episode_value as Dictionary if typeof(episode_value) == TYPE_DICTIONARY else {}
	var title := String(episode.get("title", "현재 사건 정보 없음"))
	var legend_type := String(episode.get("legend_type", "분류 정보 없음"))
	var summary := String(episode.get("summary", ""))
	_current_case_title.text = title
	_current_case_meta.text = legend_type
	_current_case_summary.text = summary

	var visuals_value: Variant = episode.get("visuals", {})
	var visuals: Dictionary = visuals_value as Dictionary if typeof(visuals_value) == TYPE_DICTIONARY else {}
	var background_id := String(visuals.get("dialogue_background_id", ""))
	_current_case_preview.texture = AssetCatalog.new().get_texture(background_id)

	_legacy_intel_status.text = (
		"본편 · %s" % _legacy_status_label.text
		if _legacy_status_label != null
		else "본편 · 상태 정보 없음"
	)
	_validation_intel_status.text = (
		"Validation · %s" % _validation_status_label.text.replace("\n", " · ")
		if _validation_status_label != null
		else "Validation · 상태 정보 없음"
	)
```

Do not read or manufacture investigator identity, dates, danger rank, protection grade, or save-slot numbering for this rail.

- [ ] **Step 3: Refresh intelligence only after existing state summaries are refreshed**

At the end of `_refresh_entry_cards()` after `_render_validation_summary(_validation_summary)`, call:

```gdscript
	_refresh_intelligence_rail()
	_apply_primary_action_emphasis()
	_rebuild_focus_chain()
```

This preserves the existing inspector/coordinator as the persistence authority and makes the right rail a mirror only.

- [ ] **Step 4: Run canonical-data contracts**

```bash
python -m unittest tests.test_main_menu_control_room_static_contract.MainMenuControlRoomStaticContract.test_reference_mockup_fiction_is_not_baked_into_runtime -v
GODOT_TEST_TMP="$(mktemp -d)" godot --headless --path . --script res://tests/validation/validation_main_menu_contract_test.gd
```

Expected: no mockup-fiction static failure; current case reads `저승역`; all pre-existing EMPTY/active/completed/corrupt Validation assertions remain intact.

- [ ] **Step 5: Commit read-only intelligence**

```bash
git add scripts/ui/main_menu.gd
git commit -m "feat: add canonical main menu intelligence rail"
```

---

### Task 5: GREEN Slice 4 — Align Primary Emphasis, Focus Chain, and 720p/1080p Behavior

**Files:**
- Modify: `scripts/ui/main_menu.gd`

**Interfaces:**
- Produces: `_meaningful_primary_action() -> Button`, `_apply_primary_action_emphasis()`, `_rebuild_focus_chain()`, `_focus_initial_action()`, `_apply_responsive_layout()`.
- Consumes: existing button visibility/disabled state after `_refresh_entry_cards()`.

- [ ] **Step 1: Replace the fixed focus graph with a visible/enabled vertical chain**

Replace `_configure_entry_focus()` with:

```gdscript
func _configure_entry_focus() -> void:
	_rebuild_focus_chain()


func _rebuild_focus_chain() -> void:
	var candidates: Array[Button] = [
		_legacy_continue_button,
		_legacy_new_campaign_button,
		_validation_primary_button,
		_validation_secondary_button,
		_database_button,
		_settings_button,
		_exit_button,
	]
	var ordered: Array[Button] = []
	for button in candidates:
		if button == null:
			continue
		button.focus_neighbor_top = NodePath()
		button.focus_neighbor_bottom = NodePath()
		if button.visible and not button.disabled:
			ordered.append(button)

	for index in range(ordered.size()):
		var button := ordered[index]
		if index > 0:
			button.focus_neighbor_top = button.get_path_to(ordered[index - 1])
		if index + 1 < ordered.size():
			button.focus_neighbor_bottom = button.get_path_to(ordered[index + 1])
```

This still preserves the old Package 2 expectation that enabled Legacy Continue moves down to Legacy New Campaign, while hidden Validation secondary actions are skipped rather than becoming dead ends.

- [ ] **Step 2: Define one meaningful primary Legacy action and a non-color text cue**

Add:

```gdscript
func _meaningful_primary_action() -> Button:
	if _legacy_continue_button != null and _legacy_continue_button.visible and not _legacy_continue_button.disabled:
		return _legacy_continue_button
	if _legacy_new_campaign_button != null and _legacy_new_campaign_button.visible and not _legacy_new_campaign_button.disabled:
		return _legacy_new_campaign_button
	if _validation_primary_button != null and _validation_primary_button.visible and not _validation_primary_button.disabled:
		return _validation_primary_button
	return null


func _apply_primary_action_emphasis() -> void:
	var buttons: Array[Button] = [
		_legacy_continue_button,
		_legacy_new_campaign_button,
		_validation_primary_button,
		_validation_secondary_button,
		_database_button,
		_settings_button,
		_exit_button,
	]
	for button in buttons:
		if button == null:
			continue
		button.custom_minimum_size.y = 46
		button.add_theme_font_size_override("font_size", 16)
		button.remove_theme_stylebox_override("normal")
		button.add_theme_stylebox_override(
			"focus",
			ThemeFactory.panel_style(ThemeFactory.COLOR_AMBER, 0.98)
		)

	var primary := _meaningful_primary_action()
	if primary == null:
		_primary_action_hint.text = "현재 사용 가능한 시작 행동이 없습니다."
		return
	primary.custom_minimum_size.y = 62
	primary.add_theme_font_size_override("font_size", 20)
	primary.add_theme_stylebox_override(
		"normal",
		ThemeFactory.panel_style(ThemeFactory.COLOR_AMBER, 0.96)
	)
	_primary_action_hint.text = "현재 권장 행동 · %s" % primary.text
```

The text hint is required so primary status is not color-only.

- [ ] **Step 3: Focus the same meaningful action only on initial entry**

Add:

```gdscript
func _focus_initial_action() -> void:
	var primary := _meaningful_primary_action()
	if primary != null:
		primary.call_deferred("grab_focus")
```

At the end of `_ready()`, replace the unconditional Legacy Continue focus block with:

```gdscript
	_focus_initial_action()
```

Do not call `_focus_initial_action()` from every refresh; dialogs continue using the existing `_remember_validation_focus()` / `_restore_validation_focus()` semantics.

- [ ] **Step 4: Apply the approved secondary-first responsive collapse**

Add:

```gdscript
func _apply_responsive_layout() -> void:
	var compact := size.x < 1500.0 or size.y < 850.0
	if _current_case_preview != null:
		_current_case_preview.visible = not compact and _current_case_preview.texture != null
	if _current_case_summary != null:
		_current_case_summary.visible = not compact and not _current_case_summary.text.is_empty()
	if _identity_rail != null:
		_identity_rail.add_theme_constant_override("separation", 8 if compact else 12)
	if _action_rail != null:
		_action_rail.add_theme_constant_override("separation", 8 if compact else 12)
	if _intelligence_rail != null:
		_intelligence_rail.add_theme_constant_override("separation", 8 if compact else 12)
```

The current-case title/meta and record-status labels remain visible in compact mode; only preview/long summary collapse.

- [ ] **Step 5: Run the complete focused contract**

```bash
python -m unittest tests.test_main_menu_control_room_static_contract -v
GODOT_TEST_TMP="$(mktemp -d)" godot --headless --path . --script res://tests/validation/validation_main_menu_contract_test.gd
```

Expected: both PASS, including existing Package 2 state cases, no-save initial focus, settings toggle, 1280×720 compact secondary content, and 1920×1080 expanded secondary content.

- [ ] **Step 6: Commit focus/responsive GREEN**

```bash
git add scripts/ui/main_menu.gd
git commit -m "fix: align main menu focus and responsive hierarchy"
```

---

### Task 6: Regression — Prove Package 2, GUT, Full Godot, and Protected Scope

**Files:**
- No production changes expected.
- Test fixes are permitted only when they correct an invalid test harness without weakening the approved behavior.

**Interfaces:**
- Consumes the complete implementation.
- Produces automated evidence suitable for the implementation PR.

- [ ] **Step 1: Run the existing Package 2 focused main-menu test again in isolation**

```bash
GODOT_TEST_TMP="$(mktemp -d)" godot --headless --path . --script res://tests/validation/validation_main_menu_contract_test.gd
```

Expected: `VALIDATION MAIN MENU CONTRACT: PASS`.

- [ ] **Step 2: Run the adopted GUT suite as non-authoring regression authority**

```bash
godot --headless -d -s --path "$PWD" addons/gut/gut_cmdln.gd -gdir=res://tests/gut -ginclude_subdirs -gexit
```

Expected: GUT exits successfully; this Decision does not require adding a redundant GUT test for the pure version constant because the version is already covered by static + runtime menu contracts.

- [ ] **Step 3: Run all Python contracts**

```bash
python -m unittest discover -s tests -p "test_*.py"
```

Expected: PASS, including `test_main_menu_control_room_static_contract.py`.

- [ ] **Step 4: Run Godot import and maintained full regression**

```bash
godot --headless --path . --import
bash tests/run_godot_regression.sh
```

Expected: import succeeds and the maintained regression completes without a new main-menu failure. If a known baseline failure is observed locally, reproduce it on current `origin/main` under the same isolated environment before attributing it; do not modify unrelated minigame/save/domain code to make this UI Decision green.

- [ ] **Step 5: Run the protected diff audit**

```bash
git diff --name-only origin/main...HEAD
```

Allowed implementation paths are limited to:

```text
scripts/core/product_version.gd
scripts/core/product_version.gd.uid        # only when generated by Godot
scripts/ui/main_menu.gd
tests/test_main_menu_control_room_static_contract.py
tests/validation/validation_main_menu_contract_test.gd
```

Then prove protected paths are absent:

```bash
git diff --name-only origin/main...HEAD -- project.godot scripts/core/game_state.gd data/episodes ASSET_MANIFEST.yml assets
```

Expected: no output.

- [ ] **Step 6: Verify the reference image never entered Git**

```bash
git diff --name-only origin/main...HEAD -- assets .reference
git status --short
```

Expected: no generated mockup or newly promoted image in the diff. Pre-existing untracked user images in another checkout are not to be deleted, moved, staged, or committed.

---

### Task 7: Implementation PR, Exact-Head CI, and Human-QA Gate

**Files:**
- No new runtime file required.
- Update PR/Issue/Sheet evidence only after the actual branch SHA and CI results exist.

**Interfaces:**
- Produces: implementation branch head, Draft implementation PR, exact-head CI evidence, unchanged Human/UI/Android ceiling.

- [ ] **Step 1: Push the implementation branch**

```bash
git status --short --branch
git log --oneline --decorate -8
git push -u origin agent/main-menu-control-room-v43-implementation-20260809
```

Expected: clean tracked working tree and remote branch at the same SHA.

- [ ] **Step 2: Open a separate Draft implementation PR**

Use base `main`, head `agent/main-menu-control-room-v43-implementation-20260809`, Decision `D-2026-08-09-MAIN-MENU-CONTROL-ROOM-VERSIONING`, and explicitly state:

```text
Ver 4.3 single-owner implementation
control-room three-rail menu
Package 2 semantics preserved
REFERENCE_ONLY mockup not included
PROJECT_ASSET_APPROVED = 0
Human/UI/Android NOT_RUN
PR #180 remains separate
```

Do not mark Ready until exact-head CI and code review are green.

- [ ] **Step 3: Require exact-head GitHub Actions**

At minimum, the runtime/test changes must trigger and pass `Validate full matrix`; also inspect every workflow actually triggered by the exact implementation head. Do not substitute a previous head's runs.

The exact-head review must verify:

```text
no project.godot
affected scripts limited to product_version + main_menu
no data/episodes
no assets / ASSET_MANIFEST
stable Legacy/Validation IDs preserved
no unresolved review threads
no P0/P1 finding
```

- [ ] **Step 4: Keep the Human/UI/Android ceiling explicit**

Automated GREEN does not promote Human QA. The next real-world gate is actual Windows rendering/input validation of the new main menu at:

```text
1280×720
1920×1080
mouse
keyboard
gamepad
non-color status cues
settings/accessibility discoverability
meaningful initial focus
Legacy/Validation separation comprehension
```

Until that is actually run, record `HUMAN_UI_ANDROID_NOT_RUN` and keep the implementation PR Draft or otherwise non-merge-ready according to the current project merge gate.

---

## Plan Self-Review

### Spec coverage

- One `4.3` version owner: Tasks 1-2.
- Remove `Ver 4.2`/duplicate literals: Tasks 1-2.
- Left identity / center actions / right intelligence: Task 3.
- Existing canonical/read-only intelligence only: Task 4.
- Stable Package 2 IDs and persistence semantics: Tasks 1, 3, 4, 6.
- Primary visual action equals initial focus and has non-color cue: Task 5.
- 1280×720 secondary-first collapse and 1920×1080 expansion: Tasks 1 and 5.
- Existing settings/accessibility authority reused: Task 3.
- No product-asset promotion or mockup fiction: Tasks 1, 4, 6.
- GUT, Python, full Godot regression, protected diff, exact-head CI: Tasks 6-7.
- Human/UI/Android remains evidence-gated: Task 7.

### Placeholder scan

No `TBD`, `TODO`, unspecified error-handling step, or unnamed test is part of this plan. Conditional UID handling is explicit: keep only the exact `product_version.gd.uid` sidecar generated by Godot 4.7.1, never a hand-authored UID.

### Type/signature consistency

- `ProductVersion.display_text() -> String` is defined once and consumed by `main_menu.gd`.
- Right-rail fields consume `GameState.get_current_episode() -> Dictionary` and the already-existing `_validation_summary: Dictionary`.
- Settings reuse `_accessibility := Accessibility.new()` and `_add_effect_slider` exactly; no new persistence API is introduced.
- Focus helpers operate on the same stable `Button` fields already used by the Package 2 coordinator/menu contract.