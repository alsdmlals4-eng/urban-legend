# Main Menu Control-Room + Product Versioning Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the menu-local `Ver 4.2` literal with one canonical `4.3` product-version owner and rebuild the main menu as the approved left-identity / center-actions / right-intelligence control-room layout without changing Legacy/Validation persistence semantics.

**Architecture:** Keep `scenes/main_menu.tscn` as the existing root `Control`; do not introduce a second scene or menu state machine. Add one focused `scripts/core/product_version.gd` owner, then refactor only `scripts/ui/main_menu.gd` presentation into named rails. The intelligence rail mirrors existing public episode and persistence summaries read-only; Package 2 coordinator/inspector behavior remains authoritative.

**Tech Stack:** Godot 4.7.1, GDScript, `UiThemeFactory`, `UiAssetCatalog`, Package 2 Validation coordinator/inspector, SceneTree headless tests, Python `unittest`, adopted GUT 9.7.1 regression authority, GitHub Actions.

## Global Constraints

- Decision: `D-2026-08-09-MAIN-MENU-CONTROL-ROOM-VERSIONING`.
- Product/UI version is exactly `4.3`; display text is exactly `Ver 4.3`.
- Future `4.4 → 4.5 → …` steps change only the canonical version owner after separate approval.
- The approved mockup is `REFERENCE_ONLY`; never add it to Git, `assets/**`, or `ASSET_MANIFEST.yml`.
- `PROJECT_ASSET_APPROVED = 0` remains unchanged.
- Mockup-only dates, investigator names, risk labels, save-slot values, system-alert text, and other illustrative fiction are non-canonical.
- Preserve `LegacyContinueButton`, `LegacyNewCampaignButton`, `ValidationPrimaryButton`, `ValidationSecondaryButton`, `DatabaseButton`, `LegacyStatusLabel`, `ValidationStatusLabel`, `ValidationBadgeLabel`, and existing Validation dialogs.
- Preserve Validation fail-closed behavior, Legacy/Validation persistence isolation, coordinator semantics, and existing debug F1 access.
- Do not modify `scripts/core/game_state.gd`, `data/episodes/**`, save schemas, campaign/economy/ending semantics, `project.godot`, `scenes/main_menu.tscn`, PR #180, or product assets.
- If persistent Scene/Node/Resource/Project Settings mutation becomes necessary, stop that mutation and route it through HiGodot, the sole persistent Godot authoring authority.
- GUT is non-authoring test authority. Hera is outside this Decision and may not author product source.
- 1280×720 keeps title/version, meaningful primary action, Legacy/Validation distinction, status/error feedback, and keyboard route visible without a document-wall `ScrollContainer`.
- 1920×1080 may expose existing secondary preview/summary content.
- Human/UI/Android remain `NOT_RUN` until actual evidence exists.

---

## Prerequisite: Merge Planning Canon, Then Use an Isolated Worktree

Do not implement from the planning PR branch. After PR #182 is merged, create the runtime branch from the then-current `origin/main` using `superpowers:using-git-worktrees`:

```powershell
Set-Location 'C:\Users\user\Documents\GitHub\Ninza\urban-legend'
git fetch origin
$impl = 'C:\Users\user\Documents\GitHub\Ninza\urban-legend-main-menu-v43'
if (Test-Path $impl) { throw "Implementation worktree path already exists: $impl" }
git worktree add -b agent/main-menu-control-room-v43-implementation-20260809 $impl origin/main
Set-Location $impl
git status --short --branch
git grep -n 'D-2026-08-09-MAIN-MENU-CONTROL-ROOM-VERSIONING' -- docs
git grep -n 'Status: `APPROVED`' -- docs/superpowers/specs/2026-08-09-main-menu-control-room-versioning-design.md
```

Expected: clean worktree and both approved canon references present.

## File Map

**Create**
- `scripts/core/product_version.gd` — one product/UI version owner.
- `tests/test_main_menu_control_room_static_contract.py` — one-source/version/reference/layout static guard.

**Modify**
- `scripts/ui/main_menu.gd` — version consumer, three rails, utilities, read-only intelligence, focus/responsive behavior.
- `tests/validation/validation_main_menu_contract_test.gd` — extend the existing Package 2 menu contract.

**Potential Godot-generated sidecar**
- `scripts/core/product_version.gd.uid` — include only if Godot 4.7.1 actually generates it; never hand-author it.

**Remain unchanged**
- `scenes/main_menu.tscn`
- `project.godot`
- `scripts/core/game_state.gd`
- `data/episodes/**`
- `assets/**`
- `ASSET_MANIFEST.yml`
- `tests/run_godot_regression.sh` — the existing main-menu contract is already registered in the maintained suite.

---

### Task 1: TDD RED — Version, Three-Rail, Focus, and Reference-Boundary Contracts

**Files:**
- Create: `tests/test_main_menu_control_room_static_contract.py`
- Modify: `tests/validation/validation_main_menu_contract_test.gd`

**Interfaces:**
- Consumes: current main-menu scene/script and existing Package 2 fixtures.
- Produces: genuine failing assertions for the approved behavior; no production mutation.

- [ ] **Step 1: Create the static contract**

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
        self.assertNotIn('"4.3"', menu, "main_menu.gd must not duplicate the version literal")

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

- [ ] **Step 2: Add new required-node assertions to the existing Godot contract**

Immediately after the current required-node loop in `tests/validation/validation_main_menu_contract_test.gd`, add only this loop:

```gdscript
	for node_name in [
		"MenuShell", "IdentityRail", "ActionRail", "IntelligenceRail",
		"VersionLabel", "PrimaryActionHint", "CurrentCaseTitle",
		"CurrentCaseMeta", "CurrentCaseSummary", "CurrentCasePreview",
		"LegacyIntelStatus", "ValidationIntelStatus",
		"SettingsButton", "SettingsPanel", "ExitButton"
	]:
		_expect(menu.find_child(node_name, true, false) != null, "%s must exist" % node_name)
```

Do not reference `legacy_new_button` here; its declaration occurs later in the existing test.

- [ ] **Step 3: Add runtime assertions only after the existing typed control declarations**

After the existing declarations for `badge`, `legacy_button`, `legacy_new_button`, `validation_button`, `validation_secondary`, `validation_status`, and `db_button`, and after their null/type guard, add:

```gdscript
	var version_label := menu.find_child("VersionLabel", true, false) as Label
	var primary_hint := menu.find_child("PrimaryActionHint", true, false) as Label
	var current_case_title := menu.find_child("CurrentCaseTitle", true, false) as Label
	var settings_button := menu.find_child("SettingsButton", true, false) as Button
	var settings_panel := menu.find_child("SettingsPanel", true, false) as Control
	var exit_button := menu.find_child("ExitButton", true, false) as Button

	_expect(version_label != null and version_label.text == "Ver 4.3", "menu must display canonical Ver 4.3")
	_expect(primary_hint != null and "새 캠페인 시작" in primary_hint.text, "no-save state must name new campaign as primary")
	_expect(current_case_title != null and "저승역" in current_case_title.text, "current case must use loaded canonical episode data")
	_expect(settings_button != null and settings_button.focus_mode == Control.FOCUS_ALL, "settings must accept keyboard focus")
	_expect(settings_panel != null and not settings_panel.visible, "settings panel must start collapsed")
	_expect(exit_button != null and exit_button.focus_mode == Control.FOCUS_ALL, "exit must accept keyboard focus")
	_expect(menu.find_children("*", "ScrollContainer", true, false).is_empty(), "main menu must not contain a document-wall ScrollContainer")

	await process_frame
	_expect(root.gui_get_focus_owner() == legacy_new_button, "no-save initial focus must match the primary new-campaign action")
	_expect(_inside_viewport(version_label), "Ver 4.3 must fit inside 1280x720")
	_expect(_inside_viewport(legacy_new_button), "primary Legacy action must fit inside 1280x720")
```

Before the existing cleanup, after the existing EMPTY/active/completed/corrupt assertions have run, add:

```gdscript
	settings_button.pressed.emit()
	_expect(settings_panel.visible, "settings must expose the existing accessibility surface")
	settings_button.pressed.emit()
	_expect(not settings_panel.visible, "settings must collapse the accessibility surface")

	var case_preview := menu.find_child("CurrentCasePreview", true, false) as Control
	var case_summary := menu.find_child("CurrentCaseSummary", true, false) as Control
	_expect(case_preview != null and not case_preview.visible, "1280x720 must compact secondary preview first")
	_expect(case_summary != null and not case_summary.visible, "1280x720 must compact secondary summary first")

	root.size = Vector2i(1920, 1080)
	await process_frame
	await process_frame
	_expect(case_preview.visible, "1920x1080 may expose the existing case preview")
	_expect(case_summary.visible, "1920x1080 may expose the existing case summary")
```

Add this helper near the test helpers:

```gdscript
func _inside_viewport(control: Control) -> bool:
	if control == null:
		return false
	return Rect2(Vector2.ZERO, Vector2(root.size)).encloses(control.get_global_rect())
```

Do not remove or weaken any existing Package 2 assertion.

- [ ] **Step 4: Run genuine RED**

```bash
python tests/test_main_menu_control_room_static_contract.py -v
GODOT_TEST_TMP="$(mktemp -d)" godot --headless --path . --script res://tests/validation/validation_main_menu_contract_test.gd
```

Expected:
- Python fails on absent `product_version.gd`, old `GAME_VERSION`/`Ver 4.2`, and `ScrollContainer.new()`.
- Godot loads the current menu successfully and fails the new named-node/version/focus/layout assertions.
- Parse errors, fixture failures, or missing pre-existing Package 2 nodes are invalid RED and must be corrected before continuing.

- [ ] **Step 5: Commit tests only**

```bash
git add tests/test_main_menu_control_room_static_contract.py tests/validation/validation_main_menu_contract_test.gd
git commit -m "test: define main menu control-room contracts"
```

---

### Task 2: GREEN 1 — Canonical Product Version 4.3

**Files:**
- Create: `scripts/core/product_version.gd`
- Modify: `scripts/ui/main_menu.gd`
- Potential generated: `scripts/core/product_version.gd.uid`

**Interfaces:**
- Produces: `ProductVersion.CURRENT: String`; `ProductVersion.display_text() -> String`.
- Consumed by: all main-menu product-version display text.

- [ ] **Step 1: Create the owner**

```gdscript
class_name ProductVersion
extends RefCounted

const CURRENT := "4.3"


static func display_text() -> String:
	return "Ver %s" % CURRENT
```

- [ ] **Step 2: Replace local ownership in `main_menu.gd`**

Add:

```gdscript
const ProductVersion = preload("res://scripts/core/product_version.gd")
```

Delete:

```gdscript
const GAME_VERSION := "Ver 4.2"
```

Use:

```gdscript
	var version_label := Label.new()
	version_label.name = "VersionLabel"
	version_label.text = ProductVersion.display_text()
```

and change `_add_update_notice()` to:

```gdscript
	title.text = "%s 변경사항" % ProductVersion.display_text()
```

No `"4.3"` or `"Ver 4.3"` literal belongs in `main_menu.gd`.

- [ ] **Step 3: Import through the approved Godot path and inspect UID output**

```bash
godot --headless --path . --import
git status --short scripts/core/product_version.gd scripts/core/product_version.gd.uid
```

If Godot generates `product_version.gd.uid`, keep exactly that generated sidecar. Never copy a UID from another script.

- [ ] **Step 4: Prove the version slice**

```bash
python tests/test_main_menu_control_room_static_contract.py MainMenuControlRoomStaticContract.test_product_version_has_one_owner -v
```

Expected: PASS. Other static layout assertions remain RED until Task 3.

- [ ] **Step 5: Commit**

```bash
git add scripts/core/product_version.gd scripts/ui/main_menu.gd
if [ -f scripts/core/product_version.gd.uid ]; then git add scripts/core/product_version.gd.uid; fi
git commit -m "feat: centralize product version 4.3"
```

---

### Task 3: GREEN 2 — Three-Rail Shell, Utilities, and Existing Debug Surface

**Files:**
- Modify: `scripts/ui/main_menu.gd`

**Interfaces:**
- Produces: `MenuShell`, `IdentityRail`, `ActionRail`, `IntelligenceRail`, `PrimaryActionHint`, `SettingsButton`, `SettingsPanel`, `ExitButton`.
- Reuses: existing Legacy/Validation controls, database handler, accessibility setters, log guide, debug scene buttons.

- [ ] **Step 1: Add rail/utility fields**

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

- [ ] **Step 2: Replace the `ScrollContainer` shell while retaining the existing backdrop**

After the current backdrop and dark overlay, build:

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
	_build_debug_panel(_intelligence_rail)
	_build_validation_dialogs()
	_configure_entry_focus()
	resized.connect(_apply_responsive_layout)
	_apply_responsive_layout()
```

Add:

```gdscript
func _make_menu_rail(parent: Control, node_name: String, minimum_width: float, stretch_ratio: float, accent: Color) -> VBoxContainer:
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	panel.size_flags_stretch_ratio = stretch_ratio
	panel.custom_minimum_size.x = minimum_width
	panel.add_theme_stylebox_override("panel", ThemeFactory.panel_style(accent, 0.90))
	parent.add_child(panel)

	var rail := VBoxContainer.new()
	rail.name = node_name
	rail.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	rail.size_flags_vertical = Control.SIZE_EXPAND_FILL
	rail.add_theme_constant_override("separation", 12)
	panel.add_child(rail)
	return rail
```

- [ ] **Step 3: Build the identity rail without mockup fiction**

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

Do not add government affiliation, clearance numbers, barcodes, user names, dates, or other mockup-only facts.

- [ ] **Step 4: Make `EntryCards` a vertical domain stack without changing action semantics**

At the start of `_build_entry_cards` use:

```gdscript
	var entry_cards := VBoxContainer.new()
	entry_cards.name = "EntryCards"
	entry_cards.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	entry_cards.add_theme_constant_override("separation", 10)
	parent.add_child(entry_cards)
```

Use `본편` for the Legacy section heading and keep the Validation section explicitly separate. Preserve every existing button name, handler, status label, and alias assignment.

- [ ] **Step 5: Build center utilities**

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

Change `_add_accessibility_panel` to return its panel:

```gdscript
func _add_accessibility_panel(parent: Control) -> Control:
	var content := _add_section(parent, "설정 / 접근성", "화면 연출을 편한 수준으로 조절합니다.")
	_add_effect_slider(content, "화면 흔들림", "screen_shake")
	_add_effect_slider(content, "섬광", "flash")
	_add_effect_slider(content, "공포 왜곡", "horror_distortion")
	return content.get_parent()


func _toggle_settings_panel() -> void:
	if _settings_panel != null:
		_settings_panel.visible = not _settings_panel.visible
```

- [ ] **Step 6: Preserve the existing F1 debug/test controls exactly as debug-only behavior**

Move the existing debug construction into this helper; do not remove any existing debug route:

```gdscript
func _build_debug_panel(parent: Control) -> void:
	var dev_content := _add_section(
		parent,
		"개발 / 테스트",
		"플레이 루프 검증용 보조 버튼입니다. 실제 진행은 주요 행동에서 시작합니다."
	)
	_dev_panel = dev_content.get_parent()
	_dev_panel.visible = false

	var clear_save_button := Button.new()
	clear_save_button.text = "저장 초기화"
	clear_save_button.pressed.connect(_clear_saved_game)
	dev_content.add_child(clear_save_button)

	_add_scene_button(dev_content, "MVP-002 데이터 확인", "res://scenes/case_data_scene.tscn")
	_add_scene_button(dev_content, "CORE-MVP-001 조사→전조→포획 PoC", "res://scenes/poc/core_mvp_001/core_mvp_001_scene.tscn")
	_add_scene_button(dev_content, "ANNUAL-MVP-001 육성→사건→연구 PoC", "res://scenes/poc/annual_mvp_001/annual_mvp_001_scene.tscn")

	var annual_mvp_002_button := Button.new()
	annual_mvp_002_button.name = "AnnualMvp002Button"
	annual_mvp_002_button.text = "ANNUAL-MVP-002 동료·장비·연구 PoC"
	annual_mvp_002_button.pressed.connect(func() -> void:
		get_tree().change_scene_to_file("res://scenes/poc/annual_mvp_002/annual_mvp_002_scene.tscn")
	)
	dev_content.add_child(annual_mvp_002_button)

	_add_scene_button(dev_content, "조사씬 열기", "res://scenes/investigation_scene.tscn")
	_add_scene_button(dev_content, "준비 화면 열기", GameState.SCENE_PREPARATION)
	_add_scene_button(dev_content, "대화씬 열기", "res://scenes/dialogue_scene.tscn")
	_add_scene_button(dev_content, "회수 페이즈 열기", "res://scenes/battle_scene.tscn")
	_add_scene_button(dev_content, "미니게임씬 열기", "res://scenes/minigame_scene.tscn")
```

The existing `_input` F1 toggle remains unchanged.

- [ ] **Step 7: Run shell/static checks**

```bash
python tests/test_main_menu_control_room_static_contract.py -v
GODOT_TEST_TMP="$(mktemp -d)" godot --headless --path . --script res://tests/validation/validation_main_menu_contract_test.gd
```

Expected: static one-source/layout/reference tests pass. Godot may still fail only the right-intelligence and focus/responsive assertions completed by Tasks 4-5.

- [ ] **Step 8: Commit**

```bash
git add scripts/ui/main_menu.gd
git commit -m "feat: rebuild main menu as control-room rails"
```

---

### Task 4: GREEN 3 — Read-Only Canonical Intelligence Rail

**Files:**
- Modify: `scripts/ui/main_menu.gd`

**Interfaces:**
- Consumes: `GameState.get_current_episode() -> Dictionary`, existing Legacy status label, existing `_validation_summary`, and episode-provided visual asset IDs.
- Produces: read-only `CurrentCase*`, `LegacyIntelStatus`, `ValidationIntelStatus` controls.

- [ ] **Step 1: Build the intelligence controls**

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

- [ ] **Step 2: Mirror only existing public data**

```gdscript
func _refresh_intelligence_rail() -> void:
	if _current_case_title == null:
		return

	var current: Dictionary = GameState.get_current_episode()
	var episode: Dictionary = {}
	var episode_value: Variant = current.get("episode", {})
	if typeof(episode_value) == TYPE_DICTIONARY:
		episode = episode_value as Dictionary

	_current_case_title.text = String(episode.get("title", "현재 사건 정보 없음"))
	_current_case_meta.text = String(episode.get("legend_type", "분류 정보 없음"))
	_current_case_summary.text = String(episode.get("summary", ""))

	var visuals: Dictionary = {}
	var visuals_value: Variant = episode.get("visuals", {})
	if typeof(visuals_value) == TYPE_DICTIONARY:
		visuals = visuals_value as Dictionary
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

No new risk/protection/investigator/date/save-slot domain is added merely to fill the mockup.

- [ ] **Step 3: Refresh mirrors after the existing authorities**

At the end of `_refresh_entry_cards()` after `_render_validation_summary(_validation_summary)`, call:

```gdscript
	_refresh_intelligence_rail()
	_apply_primary_action_emphasis()
	_rebuild_focus_chain()
	_apply_responsive_layout()
```

The final responsive call is required so a game launched directly at 1920×1080 exposes the preview/summary after their data has been populated; it must not rely on a later resize event.

- [ ] **Step 4: Run focused contracts**

```bash
python tests/test_main_menu_control_room_static_contract.py MainMenuControlRoomStaticContract.test_reference_mockup_fiction_is_not_baked_into_runtime -v
GODOT_TEST_TMP="$(mktemp -d)" godot --headless --path . --script res://tests/validation/validation_main_menu_contract_test.gd
```

Expected: canonical case title is `저승역`; all original EMPTY/active/completed/corrupt Validation behaviors remain intact.

- [ ] **Step 5: Commit**

```bash
git add scripts/ui/main_menu.gd
git commit -m "feat: add canonical main menu intelligence rail"
```

---

### Task 5: GREEN 4 — Meaningful Primary Action, Focus Chain, and Responsive Collapse

**Files:**
- Modify: `scripts/ui/main_menu.gd`

**Interfaces:**
- Produces: `_meaningful_primary_action()`, `_apply_primary_action_emphasis()`, `_rebuild_focus_chain()`, `_focus_initial_action()`, `_apply_responsive_layout()`.

- [ ] **Step 1: Replace fixed neighbors with the visible/enabled vertical chain**

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

- [ ] **Step 2: Define and expose the same meaningful primary action visually and in text**

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
		button.add_theme_stylebox_override("focus", ThemeFactory.panel_style(ThemeFactory.COLOR_AMBER, 0.98))

	var primary := _meaningful_primary_action()
	if primary == null:
		_primary_action_hint.text = "현재 사용 가능한 시작 행동이 없습니다."
		return
	primary.custom_minimum_size.y = 62
	primary.add_theme_font_size_override("font_size", 20)
	primary.add_theme_stylebox_override("normal", ThemeFactory.panel_style(ThemeFactory.COLOR_AMBER, 0.96))
	_primary_action_hint.text = "현재 권장 행동 · %s" % primary.text
```

The `PrimaryActionHint` is the required non-color cue.

- [ ] **Step 3: Initial focus must use that same action and must not steal focus on every refresh**

```gdscript
func _focus_initial_action() -> void:
	var primary := _meaningful_primary_action()
	if primary != null:
		primary.call_deferred("grab_focus")
```

At the end of `_ready()`, after `_refresh_entry_cards()`, call only:

```gdscript
	_focus_initial_action()
```

Remove the old unconditional deferred focus on `LegacyContinueButton`. Do not call `_focus_initial_action()` from normal refreshes; existing Validation dialog focus restore remains authoritative.

- [ ] **Step 4: Implement secondary-first responsive behavior**

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

Keep current-case title/meta and both record-status mirrors visible in compact mode.

- [ ] **Step 5: Run full focused GREEN**

```bash
python tests/test_main_menu_control_room_static_contract.py -v
GODOT_TEST_TMP="$(mktemp -d)" godot --headless --path . --script res://tests/validation/validation_main_menu_contract_test.gd
```

Expected: PASS. Existing Package 2 assertions remain green; no-save focus is New Campaign; at 1280×720 preview/long summary are collapsed; at 1920×1080 they are visible.

- [ ] **Step 6: Commit**

```bash
git add scripts/ui/main_menu.gd
git commit -m "fix: align main menu focus and responsive hierarchy"
```

---

### Task 6: Regression and Protected-Scope Verification

**Files:**
- No production changes expected.

- [ ] **Step 1: Re-run focused Package 2 menu contract**

```bash
GODOT_TEST_TMP="$(mktemp -d)" godot --headless --path . --script res://tests/validation/validation_main_menu_contract_test.gd
```

Expected: `VALIDATION MAIN MENU CONTRACT: PASS`.

- [ ] **Step 2: Run adopted GUT non-authoring regression**

```bash
godot --headless -d -s --path "$PWD" addons/gut/gut_cmdln.gd -gdir=res://tests/gut -ginclude_subdirs -gexit
```

Expected: GUT success. No redundant GUT test is required for the constant because version ownership is already covered by static and runtime contracts.

- [ ] **Step 3: Run all Python contracts**

```bash
python -m unittest discover -s tests -p "test_*.py"
```

Expected: PASS.

- [ ] **Step 4: Import and run maintained full Godot regression**

```bash
godot --headless --path . --import
bash tests/run_godot_regression.sh
```

Expected: no new menu regression. If a local unrelated failure appears, reproduce it on current `origin/main` under the same isolated environment before attribution; do not edit unrelated minigame/save/domain code for this Decision.

- [ ] **Step 5: Audit exact changed paths**

```bash
git diff --name-only origin/main...HEAD
```

Allowed runtime/test paths:

```text
scripts/core/product_version.gd
scripts/core/product_version.gd.uid   # only if Godot generated it
scripts/ui/main_menu.gd
tests/test_main_menu_control_room_static_contract.py
tests/validation/validation_main_menu_contract_test.gd
```

Protected audit:

```bash
git diff --name-only origin/main...HEAD -- project.godot scenes/main_menu.tscn scripts/core/game_state.gd data/episodes ASSET_MANIFEST.yml assets
```

Expected: no output.

- [ ] **Step 6: Verify no reference image entered the branch**

```bash
git diff --name-only origin/main...HEAD -- assets .reference
git status --short
```

Expected: no generated mockup or newly promoted image. Never delete/move/stage pre-existing user images from another checkout.

---

### Task 7: Draft Implementation PR, Exact-Head CI, and Human-QA Ceiling

**Files:**
- No additional runtime files.

- [ ] **Step 1: Push exact implementation head**

```bash
git status --short --branch
git log --oneline --decorate -8
git push -u origin agent/main-menu-control-room-v43-implementation-20260809
```

Expected: tracked worktree clean and local/remote head identical.

- [ ] **Step 2: Open a separate Draft implementation PR**

Base: `main`.

Head: `agent/main-menu-control-room-v43-implementation-20260809`.

PR body must state these exact boundaries:

```text
Decision D-2026-08-09-MAIN-MENU-CONTROL-ROOM-VERSIONING
Ver 4.3 single owner
left identity / center actions / right read-only intelligence
Package 2 semantics preserved
REFERENCE_ONLY mockup not included
PROJECT_ASSET_APPROVED = 0
PR #180 separate
Human/UI/Android NOT_RUN
```

- [ ] **Step 3: Verify every workflow triggered by the exact head**

`Validate full matrix` must run because `scripts/**` and `tests/**` changed. Inspect all exact-head workflows rather than reusing previous-head runs. Required review facts:

```text
no project.godot
no scenes/main_menu.tscn
no data/episodes
no assets / ASSET_MANIFEST
stable Legacy/Validation controls preserved
no unresolved review threads
no P0/P1 code-review finding
```

- [ ] **Step 4: Keep Human/UI/Android evidence-gated**

Automated GREEN does not imply Human PASS. Actual Windows QA must still cover:

```text
1280×720
1920×1080
mouse
keyboard
gamepad
meaningful initial focus
Legacy/Validation separation comprehension
settings/accessibility discoverability
non-color primary/status cues
```

Until actually run, record `HUMAN_UI_ANDROID_NOT_RUN` and do not claim merge-ready.

---

## Plan Self-Review

**Spec coverage**
- One `4.3` owner and removal of `4.2`: Tasks 1-2.
- Approved three-rail composition and existing utilities: Task 3.
- Canonical/read-only intelligence only: Task 4.
- Package 2 semantics, primary focus/emphasis, non-color cue, 720p/1080p: Tasks 1 and 5.
- Reference-only/no asset promotion: Tasks 1, 4, 6.
- GUT/Python/full Godot/protected diff/exact-head CI: Tasks 6-7.
- Human/UI/Android ceiling: Task 7.

**Placeholder scan**
- No `TBD`, `TODO`, unnamed test, or unspecified error-handling step remains.
- UID handling is explicit and evidence-based: only the sidecar actually generated by Godot 4.7.1 may be included.

**Type/signature consistency**
- `ProductVersion.display_text() -> String` is defined once and consumed by `main_menu.gd`.
- Right rail consumes `GameState.get_current_episode() -> Dictionary` and existing menu status objects without changing `GameState`.
- Settings reuse the existing `_accessibility` object and `_add_effect_slider` path.
- Test snippets reference `legacy_new_button` only after the existing declaration/type guard, avoiding parse/setup RED.
- `_refresh_entry_cards()` reapplies responsive layout after intelligence data arrives, so 1920×1080 initial launch does not depend on a resize event.
- Existing F1 debug routes are explicitly preserved through `_build_debug_panel()`.