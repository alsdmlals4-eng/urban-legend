# 시작 화면에서 프로젝트 소개, 독립 저장 진입과 데이터베이스 진입을 관리한다.
extends Control

const ThemeFactory = preload("res://scripts/ui/ui_theme_factory.gd")
const Accessibility = preload("res://scripts/ui/accessibility_settings.gd")
const AssetCatalog = preload("res://scripts/ui/ui_asset_catalog.gd")
const LogGuideScript = preload("res://scripts/ui/log_guide.gd")
const LogTutorialCatalog = preload("res://scripts/ui/log_tutorial_catalog.gd")
const ValidationInspectorScript = preload("res://scripts/core/validation_persistence_inspector.gd")
const ValidationEntryCoordinatorScript = preload("res://scripts/ui/validation_entry_coordinator.gd")
const ValidationRouteMapperScript = preload("res://scripts/core/validation_route_mapper.gd")
const ProductVersion = preload("res://scripts/core/product_version.gd")
const MAIN_MENU_BACKGROUND_ID := "bureau_archive_menu"
const MAIN_MENU_EMBLEM_TEXTURE := preload("res://assets/ui/bureau_archive_emblem.png")
const MAIN_MENU_WORDMARK_TEXTURE := preload("res://assets/ui/bureau_archive_wordmark.png")
const TITLE_SERIF_FONT := preload("res://assets/fonts/noto/NotoSerifKR-VF.ttf")

var _start_episode_button: Button
var _continue_button: Button
var _save_status_label: Label
var _legacy_new_campaign_button: Button
var _m04_campaign_entry_button: Button
var _legacy_continue_button: Button
var _legacy_status_label: Label
var _validation_primary_button: Button
var _validation_secondary_button: Button
var _menu_panel_style_cache: Dictionary = {}
var _validation_status_label: Label
var _validation_badge_label: Label
var _database_button: Button
var _validation_status_dialog: AcceptDialog
var _validation_replace_dialog: ConfirmationDialog
var _validation_completed_dialog: AcceptDialog
var _validation_inspector: Object
var _validation_coordinator: Object
var _validation_summary: Dictionary = {}
var _last_validation_focus: Control
var _dev_panel: Control
var _accessibility := Accessibility.new()
var _log_guide: LogGuide

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


func _ready() -> void:
	theme = ThemeFactory.create_theme()
	if GameState.get_current_episode().is_empty():
		GameState.load_episode()

	GameState.set_current_scene_path("res://scenes/main_menu.tscn")
	_validation_inspector = ValidationInspectorScript.new()
	_validation_coordinator = _make_validation_coordinator()
	set_process_input(true)
	_build_ui()
	_refresh_entry_cards()
	_focus_initial_action()


func _make_validation_coordinator() -> Object:
	return ValidationEntryCoordinatorScript.new(
		ValidationSession,
		_validation_inspector,
		GameState,
		Callable(self, "_change_scene_for_validation"),
		ValidationRouteMapperScript.new()
	)


func _build_ui() -> void:
	var backdrop := TextureRect.new()
	backdrop.name = "MainMenuBackdrop"
	backdrop.texture = AssetCatalog.new().get_texture(MAIN_MENU_BACKGROUND_ID)
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	backdrop.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	backdrop.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	backdrop.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(backdrop)

	var background := ColorRect.new()
	background.name = "MainMenuBackdropShade"
	background.color = Color(0.018, 0.026, 0.035, 0.54)
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)

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


func _build_identity_rail(parent: VBoxContainer) -> void:
	var title_lockup := VBoxContainer.new()
	title_lockup.name = "WorldTitleLockup"
	title_lockup.add_theme_constant_override("separation", 3)
	parent.add_child(title_lockup)

	var bureau_mark := Label.new()
	bureau_mark.name = "WorldTitleMark"
	bureau_mark.text = "기록 · 봉쇄 · 귀환"
	bureau_mark.add_theme_color_override("font_color", ThemeFactory.COLOR_TEAL)
	bureau_mark.add_theme_font_size_override("font_size", 12)
	title_lockup.add_child(bureau_mark)

	var bureau_emblem := TextureRect.new()
	bureau_emblem.name = "WorldTitleEmblem"
	bureau_emblem.texture = MAIN_MENU_EMBLEM_TEXTURE
	bureau_emblem.custom_minimum_size = Vector2(72, 72)
	bureau_emblem.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bureau_emblem.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	bureau_emblem.mouse_filter = Control.MOUSE_FILTER_IGNORE
	title_lockup.add_child(bureau_emblem)

	var wordmark := TextureRect.new()
	wordmark.name = "WorldTitleWordmark"
	wordmark.texture = MAIN_MENU_WORDMARK_TEXTURE
	wordmark.custom_minimum_size = Vector2(252, 102)
	wordmark.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	wordmark.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	wordmark.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	wordmark.mouse_filter = Control.MOUSE_FILTER_IGNORE
	title_lockup.add_child(wordmark)

	var title := Label.new()
	title.name = "WorldTitle"
	title.text = "괴이기록국"
	title.visible = false
	title.add_theme_font_override("font", TITLE_SERIF_FONT)
	title.add_theme_font_size_override("font_size", 46)
	title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	title_lockup.add_child(title)

	var report_title := Label.new()
	report_title.name = "WorldTitleSuffix"
	report_title.text = "잔향 보고서"
	report_title.visible = false
	report_title.add_theme_font_override("font", TITLE_SERIF_FONT)
	report_title.add_theme_font_size_override("font_size", 26)
	report_title.add_theme_color_override("font_color", ThemeFactory.COLOR_AMBER)
	report_title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	title_lockup.add_child(report_title)

	var subtitle := Label.new()
	subtitle.name = "WorldSubtitle"
	subtitle.text = "BUREAU OF ANOMALIES: ECHO REPORT"
	subtitle.add_theme_font_override("font", TITLE_SERIF_FONT)
	subtitle.add_theme_color_override("font_color", ThemeFactory.COLOR_AMBER)
	subtitle.add_theme_font_size_override("font_size", 15)
	subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	title_lockup.add_child(subtitle)

	var title_rule := HSeparator.new()
	title_lockup.add_child(title_rule)

	var version_label := Label.new()
	version_label.name = "VersionLabel"
	version_label.text = ProductVersion.display_text()
	version_label.add_theme_font_size_override("font_size", 18)
	version_label.add_theme_color_override("font_color", ThemeFactory.COLOR_AMBER)
	parent.add_child(version_label)

	var divider := HSeparator.new()
	parent.add_child(divider)

	var mission_heading := Label.new()
	mission_heading.text = "기록국 임무"
	mission_heading.add_theme_color_override("font_color", ThemeFactory.COLOR_MUTED)
	parent.add_child(mission_heading)

	var mission := Label.new()
	mission.text = "괴이의 규칙을 조사하고 현재 출현을 안정화해 다음 피해를 막을 기록을 남깁니다."
	mission.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	parent.add_child(mission)

	var identity_spacer := Control.new()
	identity_spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	parent.add_child(identity_spacer)

	var boundary := Label.new()
	boundary.text = "본편 기록과 Validation 기록은 서로 독립적으로 보존됩니다."
	boundary.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	boundary.add_theme_color_override("font_color", ThemeFactory.COLOR_MUTED)
	boundary.add_theme_font_size_override("font_size", 13)
	parent.add_child(boundary)


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


func _build_entry_cards(parent: Control) -> void:
	var entry_cards := VBoxContainer.new()
	entry_cards.name = "EntryCards"
	entry_cards.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	entry_cards.add_theme_constant_override("separation", 10)
	parent.add_child(entry_cards)

	var legacy_content := _add_section(
		entry_cards,
		"본편",
		"기존 캠페인 기록입니다. Validation 기록과 서로 영향을 주지 않습니다."
	)
	_legacy_status_label = Label.new()
	_legacy_status_label.name = "LegacyStatusLabel"
	_legacy_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_legacy_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	legacy_content.add_child(_legacy_status_label)

	_legacy_continue_button = Button.new()
	_legacy_continue_button.name = "LegacyContinueButton"
	_legacy_continue_button.text = "이어하기"
	_legacy_continue_button.focus_mode = Control.FOCUS_ALL
	_legacy_continue_button.pressed.connect(_continue_saved_game)
	legacy_content.add_child(_legacy_continue_button)

	_legacy_new_campaign_button = Button.new()
	_legacy_new_campaign_button.name = "LegacyNewCampaignButton"
	_legacy_new_campaign_button.text = "새 캠페인 시작"
	_legacy_new_campaign_button.focus_mode = Control.FOCUS_ALL
	_legacy_new_campaign_button.pressed.connect(_start_afterlife_station)
	legacy_content.add_child(_legacy_new_campaign_button)

	_m04_campaign_entry_button = Button.new()
	_m04_campaign_entry_button.name = "M04CampaignEntryButton"
	_m04_campaign_entry_button.text = "빨간 우산 현장 기록 시작"
	_m04_campaign_entry_button.tooltip_text = "새 본편 기록으로 준비실에서 시작합니다. 대기·회복 반일 뒤 M04를 선택해 조사와 회수까지 진행합니다."
	_m04_campaign_entry_button.focus_mode = Control.FOCUS_ALL
	_m04_campaign_entry_button.pressed.connect(_start_red_umbrella_campaign)
	legacy_content.add_child(_m04_campaign_entry_button)

	_start_episode_button = _legacy_new_campaign_button
	_continue_button = _legacy_continue_button
	_save_status_label = _legacy_status_label

	var validation_content := _add_section(
		entry_cards,
		"Validation 기록",
		"저승역 검증 흐름을 위한 독립 기록입니다."
	)
	_validation_badge_label = Label.new()
	_validation_badge_label.name = "ValidationBadgeLabel"
	_validation_badge_label.text = "본편과 별도 기록"
	_validation_badge_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_validation_badge_label.add_theme_color_override("font_color", ThemeFactory.COLOR_TEAL)
	validation_content.add_child(_validation_badge_label)

	_validation_status_label = Label.new()
	_validation_status_label.name = "ValidationStatusLabel"
	_validation_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_validation_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	validation_content.add_child(_validation_status_label)

	_validation_primary_button = Button.new()
	_validation_primary_button.name = "ValidationPrimaryButton"
	_validation_primary_button.focus_mode = Control.FOCUS_ALL
	_validation_primary_button.pressed.connect(_on_validation_primary_pressed)
	validation_content.add_child(_validation_primary_button)

	_validation_secondary_button = Button.new()
	_validation_secondary_button.name = "ValidationSecondaryButton"
	_validation_secondary_button.text = "새 기록 시작"
	_validation_secondary_button.focus_mode = Control.FOCUS_ALL
	_validation_secondary_button.pressed.connect(_on_validation_secondary_pressed)
	validation_content.add_child(_validation_secondary_button)


func _build_intelligence_rail(parent: VBoxContainer) -> void:
	var case_content := _add_section(parent, "현재 사건")

	_current_case_title = Label.new()
	_current_case_title.name = "CurrentCaseTitle"
	_current_case_title.add_theme_font_size_override("font_size", 28)
	_current_case_title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
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


func _build_validation_dialogs() -> void:
	_validation_status_dialog = AcceptDialog.new()
	_validation_status_dialog.name = "ValidationStatusDialog"
	_validation_status_dialog.title = "Validation 기록 상태"
	_validation_status_dialog.get_ok_button().text = "확인"
	_validation_status_dialog.confirmed.connect(_restore_validation_focus)
	_validation_status_dialog.close_requested.connect(_restore_validation_focus)
	add_child(_validation_status_dialog)

	_validation_replace_dialog = ConfirmationDialog.new()
	_validation_replace_dialog.name = "ValidationReplaceDialog"
	_validation_replace_dialog.title = "Validation 기록 교체"
	_validation_replace_dialog.get_ok_button().text = "새 기록 시작"
	_validation_replace_dialog.get_cancel_button().text = "기록 유지"
	_validation_replace_dialog.confirmed.connect(_on_validation_replace_confirmed)
	_validation_replace_dialog.canceled.connect(_on_validation_replace_canceled)
	add_child(_validation_replace_dialog)

	_validation_completed_dialog = AcceptDialog.new()
	_validation_completed_dialog.name = "ValidationCompletedDialog"
	_validation_completed_dialog.title = "완료된 Validation 기록"
	_validation_completed_dialog.get_ok_button().text = "닫기"
	_validation_completed_dialog.confirmed.connect(_restore_validation_focus)
	_validation_completed_dialog.close_requested.connect(_restore_validation_focus)
	add_child(_validation_completed_dialog)


func _configure_entry_focus() -> void:
	_rebuild_focus_chain()


func _rebuild_focus_chain() -> void:
	var candidates: Array[Button] = [
		_legacy_continue_button,
		_legacy_new_campaign_button,
		_m04_campaign_entry_button,
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
		button.focus_neighbor_left = NodePath()
		button.focus_neighbor_right = NodePath()
		if button.visible and not button.disabled:
			ordered.append(button)

	for index in range(ordered.size()):
		var button := ordered[index]
		if index > 0:
			button.focus_neighbor_top = button.get_path_to(ordered[index - 1])
		if index + 1 < ordered.size():
			button.focus_neighbor_bottom = button.get_path_to(ordered[index + 1])


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
		_m04_campaign_entry_button,
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


func _focus_initial_action() -> void:
	var primary := _meaningful_primary_action()
	if primary != null:
		primary.call_deferred("grab_focus")


func _apply_responsive_layout() -> void:
	var compact := _is_compact_layout()
	# A 1080p desktop window can have a smaller client height once its frame is
	# accounted for. Keep the information preview, but use compact control density
	# before any keyboard-reachable menu action falls below the client area.
	var dense := compact or _uses_dense_vertical_layout()
	if _current_case_preview != null:
		_current_case_preview.visible = not compact and _current_case_preview.texture != null
	if _current_case_summary != null:
		_current_case_summary.visible = not compact and not _current_case_summary.text.is_empty()
	if _identity_rail != null:
		_identity_rail.add_theme_constant_override("separation", 4 if dense else 12)
	if _action_rail != null:
		_action_rail.add_theme_constant_override("separation", 4 if dense else 12)
	if _intelligence_rail != null:
		_intelligence_rail.add_theme_constant_override("separation", 4 if dense else 12)
	_apply_compact_menu_density(dense)


func _apply_compact_menu_density(compact: bool) -> void:
	if _menu_shell != null:
		_menu_shell.add_theme_constant_override("separation", 10 if compact else 18)
	for panel_value in _menu_shell.find_children("*", "PanelContainer", true, false) if _menu_shell != null else []:
		var panel := panel_value as PanelContainer
		if panel == null:
			continue
		var panel_id := panel.get_instance_id()
		if not _menu_panel_style_cache.has(panel_id):
			var base_style := panel.get_theme_stylebox("panel") as StyleBoxFlat
			if base_style == null:
				continue
			_menu_panel_style_cache[panel_id] = base_style.duplicate() as StyleBoxFlat
		var cached_style := _menu_panel_style_cache.get(panel_id) as StyleBoxFlat
		if cached_style == null:
			continue
		var adjusted_style := cached_style.duplicate() as StyleBoxFlat
		if compact:
			adjusted_style.content_margin_top = 6
			adjusted_style.content_margin_bottom = 6
			adjusted_style.content_margin_left = 10
			adjusted_style.content_margin_right = 10
		panel.add_theme_stylebox_override("panel", adjusted_style)

	var entry_cards := _action_rail.get_node_or_null("EntryCards") as VBoxContainer if _action_rail != null else null
	if entry_cards != null:
		entry_cards.add_theme_constant_override("separation", 4 if compact else 10)
	var button_height := 36.0 if compact else 46.0
	var button_font_size := 15 if compact else 16
	for button in [
		_legacy_continue_button,
		_legacy_new_campaign_button,
		_m04_campaign_entry_button,
		_validation_primary_button,
		_validation_secondary_button,
		_database_button,
		_settings_button,
		_exit_button,
	]:
		if button == null:
			continue
		button.custom_minimum_size.y = button_height
		button.add_theme_font_size_override("font_size", button_font_size)
	var primary := _meaningful_primary_action()
	if primary != null:
		primary.custom_minimum_size.y = 48.0 if compact else 62.0
		primary.add_theme_font_size_override("font_size", 18 if compact else 20)


func _is_compact_layout() -> bool:
	return _is_compact_for_sizes(size, Vector2(DisplayServer.window_get_size()))


func _uses_dense_vertical_layout() -> bool:
	var physical_size := Vector2(DisplayServer.window_get_size())
	var effective_height := maxf(size.y, physical_size.y)
	return effective_height < 1120.0


func _is_compact_for_sizes(control_size: Vector2, window_size: Vector2) -> bool:
	var effective_size := Vector2(maxf(control_size.x, window_size.x), maxf(control_size.y, window_size.y))
	return effective_size.x < 1500.0 or effective_size.y < 850.0


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


func _present_log_entry() -> void:
	var persist_now := GameState.has_save_file()
	if not GameState.has_seen_log_tutorial("main_welcome"):
		_log_guide.present_tutorial("main_welcome", true)
		_log_guide.sequence_finished.connect(func() -> void: GameState.claim_log_tutorial("main_welcome", persist_now), CONNECT_ONE_SHOT)
	elif persist_now and not GameState.has_seen_log_tutorial("main_continue"):
		_log_guide.present_tutorial("main_continue", true)
		_log_guide.sequence_finished.connect(func() -> void: GameState.claim_log_tutorial("main_continue", true), CONNECT_ONE_SHOT)
	else:
		_log_guide.show_compact_hint(LogTutorialCatalog.get_repeat_hint("main_welcome"))


func _input(event: InputEvent) -> void:
	if not OS.is_debug_build() or not (event is InputEventKey):
		return
	var key := event as InputEventKey
	if key.pressed and not key.echo and key.keycode == KEY_F1 and _dev_panel != null:
		_dev_panel.visible = not _dev_panel.visible
		get_viewport().set_input_as_handled()


func configure_validation_repository_path_for_test(path: String) -> void:
	if _validation_inspector == null:
		_validation_inspector = ValidationInspectorScript.new()
	_validation_inspector.configure_repository_path_for_test(path)
	if _validation_coordinator == null:
		_validation_coordinator = _make_validation_coordinator()


func refresh_entry_cards_for_test() -> void:
	_refresh_entry_cards()


func _refresh_entry_cards() -> void:
	_refresh_save_controls()
	if _validation_inspector == null:
		_validation_summary = {
			"repository_code": "READ_FAILED",
			"status_label": "읽기 실패",
			"status_message": "Validation 기록을 읽을 수 없습니다. 기존 캠페인은 계속 이용할 수 있습니다."
		}
	else:
		_validation_summary = _validation_inspector.inspect_persistence()
	_render_validation_summary(_validation_summary)
	_refresh_intelligence_rail()
	_apply_primary_action_emphasis()
	_rebuild_focus_chain()
	_apply_responsive_layout()


func _render_validation_summary(summary: Dictionary) -> void:
	if _validation_status_label == null or _validation_primary_button == null:
		return
	var label := String(summary.get("status_label", "상태 확인 필요"))
	var message := String(summary.get("status_message", "Validation 기록 상태를 확인할 수 없습니다."))
	_validation_status_label.text = "%s\n%s" % [label, message]
	_validation_primary_button.disabled = false
	_validation_secondary_button.visible = false
	_validation_secondary_button.disabled = false

	if bool(summary.get("can_start", false)):
		_validation_primary_button.text = "새 기록 시작"
	elif bool(summary.get("can_continue", false)):
		_validation_primary_button.text = "이어하기"
		_validation_secondary_button.text = "새 기록 시작"
		_validation_secondary_button.visible = true
	elif bool(summary.get("can_view_completed", false)):
		_validation_primary_button.text = "완료 기록 보기"
		_validation_secondary_button.text = "새 기록 시작"
		_validation_secondary_button.visible = true
	else:
		_validation_primary_button.text = "상태 상세"


func _on_validation_primary_pressed() -> void:
	_remember_validation_focus(_validation_primary_button)
	var summary: Dictionary = _validation_inspector.inspect_persistence()
	_validation_summary = summary
	if not bool(summary.get("can_start", false)) and not bool(summary.get("can_continue", false)) and not bool(summary.get("can_view_completed", false)):
		_show_validation_status(summary)
		return

	_set_entry_mutation_enabled(false)
	var result: Dictionary
	if bool(summary.get("can_start", false)):
		result = _validation_coordinator.start_new_validation()
	elif bool(summary.get("can_continue", false)):
		result = _validation_coordinator.continue_validation()
	else:
		result = _validation_coordinator.view_completed_validation()

	if String(result.get("code", "")) == "OK":
		if result.has("summary"):
			_show_completed_validation(result.get("summary", {}) as Dictionary)
		return
	if String(result.get("code", "")) == "REPLACE_CONFIRMATION_REQUIRED":
		_show_replace_confirmation(result.get("summary", {}) as Dictionary)
		return
	_refresh_entry_cards()
	_show_validation_status(_validation_inspector.inspect_persistence(), String(result.get("code", "UNKNOWN")))


func _on_validation_secondary_pressed() -> void:
	_remember_validation_focus(_validation_secondary_button)
	_set_entry_mutation_enabled(false)
	var result: Dictionary = _validation_coordinator.start_new_validation()
	if String(result.get("code", "")) == "OK":
		return
	if String(result.get("code", "")) == "REPLACE_CONFIRMATION_REQUIRED":
		_show_replace_confirmation(result.get("summary", {}) as Dictionary)
		return
	_refresh_entry_cards()
	_show_validation_status(_validation_inspector.inspect_persistence(), String(result.get("code", "UNKNOWN")))


func _on_validation_replace_confirmed() -> void:
	_set_entry_mutation_enabled(false)
	var result: Dictionary = _validation_coordinator.confirm_replace_and_start()
	if String(result.get("code", "")) == "OK":
		return
	_refresh_entry_cards()
	_show_validation_status(_validation_inspector.inspect_persistence(), String(result.get("code", "UNKNOWN")))


func _on_validation_replace_canceled() -> void:
	_validation_coordinator.cancel_replace()
	_refresh_entry_cards()
	_restore_validation_focus()


func _show_replace_confirmation(summary: Dictionary) -> void:
	_refresh_entry_cards()
	var episode := String(summary.get("episode_title", "Validation 기록"))
	var stage := String(summary.get("flow_stage", summary.get("lifecycle", "")))
	var updated := String(summary.get("updated_at_utc", "기록 시각 없음"))
	_validation_replace_dialog.dialog_text = (
		"현재 Validation 기록을 새 기록으로 교체합니다.\n\n"
		+ "%s · %s\n마지막 저장: %s\n\n" % [episode, stage, updated]
		+ "삭제되는 것은 Validation 기록뿐입니다.\n"
		+ "기존 캠페인 기록은 변경되지 않습니다."
	)
	_validation_replace_dialog.popup_centered()
	_validation_replace_dialog.get_cancel_button().call_deferred("grab_focus")


func _show_validation_status(summary: Dictionary, override_code: String = "") -> void:
	_refresh_entry_cards()
	var title := String(summary.get("status_label", "상태 확인 필요"))
	var message := String(summary.get("status_message", "Validation 기록 상태를 확인할 수 없습니다."))
	if not override_code.is_empty():
		message += "\n\n오류 코드: %s" % override_code
	_validation_status_dialog.dialog_text = "%s\n\n%s" % [title, message]
	_validation_status_dialog.popup_centered()


func _show_completed_validation(summary: Dictionary) -> void:
	_refresh_entry_cards()
	var episode := String(summary.get("episode_title", "Validation 기록"))
	var completed := String(summary.get("completed_at_utc", "완료 시각 없음"))
	_validation_completed_dialog.dialog_text = (
		"%s\n\n완료 시각: %s\n\n" % [episode, completed]
		+ "이 화면은 읽기 전용 요약입니다. 본편 상태와 Validation 런타임을 불러오지 않았습니다."
	)
	_validation_completed_dialog.popup_centered()


func _remember_validation_focus(control: Control) -> void:
	_last_validation_focus = control


func _restore_validation_focus() -> void:
	_refresh_entry_cards()
	if _last_validation_focus != null and is_instance_valid(_last_validation_focus) and _last_validation_focus.visible and not _last_validation_focus.disabled:
		_last_validation_focus.call_deferred("grab_focus")
	elif _validation_primary_button != null:
		_validation_primary_button.call_deferred("grab_focus")


func _set_entry_mutation_enabled(enabled: bool) -> void:
	if _legacy_continue_button != null:
		_legacy_continue_button.disabled = not enabled or not GameState.has_save_file()
	if _legacy_new_campaign_button != null:
		_legacy_new_campaign_button.disabled = not enabled
	if _m04_campaign_entry_button != null:
		_m04_campaign_entry_button.disabled = not enabled
	if _validation_primary_button != null:
		_validation_primary_button.disabled = not enabled
	if _validation_secondary_button != null:
		_validation_secondary_button.disabled = not enabled


func _change_scene_for_validation(scene_path: String) -> int:
	return get_tree().change_scene_to_file(scene_path)


func _add_accessibility_panel(parent: Control) -> Control:
	var content := _add_section(parent, "설정 / 접근성", "화면 연출을 편한 수준으로 조절합니다.")
	_add_effect_slider(content, "화면 흔들림", "screen_shake")
	_add_effect_slider(content, "섬광", "flash")
	_add_effect_slider(content, "공포 왜곡", "horror_distortion")
	return content.get_parent()


func _toggle_settings_panel() -> void:
	if _settings_panel != null:
		_settings_panel.visible = not _settings_panel.visible


func _add_effect_slider(parent: Control, label_text: String, effect_id: String) -> void:
	var row := HBoxContainer.new()
	parent.add_child(row)
	var label := Label.new()
	label.text = label_text
	label.custom_minimum_size.x = 110
	row.add_child(label)
	var slider := HSlider.new()
	slider.min_value = 0
	slider.max_value = 100
	slider.step = 10
	slider.value = _accessibility.get_strength(effect_id) * 100.0
	slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	slider.value_changed.connect(func(value: float) -> void: _accessibility.set_strength(effect_id, value / 100.0))
	row.add_child(slider)


func _add_section(parent: Control, title_text: String, description_text: String = "") -> VBoxContainer:
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(panel)

	var content := VBoxContainer.new()
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.add_theme_constant_override("separation", 8)
	panel.add_child(content)

	var title := Label.new()
	title.text = title_text
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	content.add_child(title)

	if not description_text.is_empty():
		var description := Label.new()
		description.text = description_text
		description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		description.add_theme_color_override("font_color", ThemeFactory.COLOR_MUTED)
		description.add_theme_font_size_override("font_size", 13)
		content.add_child(description)

	return content


func _add_update_notice(parent: Control) -> void:
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(panel)

	var content := VBoxContainer.new()
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.add_theme_constant_override("separation", 6)
	panel.add_child(content)

	var title := Label.new()
	title.text = "%s 변경사항" % ProductVersion.display_text()
	content.add_child(title)

	var changes := Label.new()
	changes.text = "- PC 16:9 기준으로 대화·조사·회수 화면의 시선 흐름을 맞췄습니다.\n- 저승역은 Space/Enter 리듬 판정, 빨간 우산은 방향키 비 피하기로 구현하고 결과를 회수·보고서·DB에 연결했습니다."
	changes.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(changes)

	var checks := Label.new()
	checks.text = "확인할 것: 조사에서 사건별 현장 판정에 진입한 뒤 성공/실패 상태 변화가 회수 근거, 사건 보고서와 기록국 DB에 남는지 확인하세요."
	checks.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(checks)


func _open_database() -> void:
	get_tree().change_scene_to_file("res://scenes/database_view.tscn")


func _start_afterlife_station() -> void:
	GameState.clear_save_file()
	GameState.restart_afterlife_station_flow(["agent_oh_hyun", "agent_kwon_narae", "agent_kang_ijun"])
	GameState.save_game()
	get_tree().change_scene_to_file(GameState.SCENE_DIALOGUE)


func _start_red_umbrella_campaign() -> void:
	GameState.clear_save_file()
	if not GameState.begin_campaign_case_selection(["agent_kwon_narae", "agent_oh_hyun", "agent_kang_ijun"]):
		_refresh_entry_cards()
		return
	GameState.save_game()
	get_tree().change_scene_to_file(GameState.SCENE_PREPARATION)


func _continue_saved_game() -> void:
	if not GameState.load_game():
		_refresh_entry_cards()
		return

	var scene_path := GameState.get_current_scene_path()
	if scene_path == "res://scenes/main_menu.tscn":
		scene_path = "res://scenes/dialogue_scene.tscn"
	get_tree().change_scene_to_file(scene_path)


func _clear_saved_game() -> void:
	GameState.clear_save_file()
	GameState.reset_run_state()
	GameState.set_current_scene_path("res://scenes/main_menu.tscn")
	_refresh_entry_cards()
	_focus_initial_action()


func _refresh_save_controls() -> void:
	var has_save := GameState.has_save_file()
	if _continue_button != null:
		_continue_button.disabled = not has_save
	if _save_status_label != null:
		_save_status_label.text = (
			"이어할 본편 기록이 있습니다." if has_save
			else "저장된 본편 캠페인이 없습니다."
		)


func _add_scene_button(parent: Control, label: String, scene_path: String) -> void:
	var button := Button.new()
	button.text = label
	button.pressed.connect(func() -> void:
		get_tree().change_scene_to_file(scene_path)
	)
	parent.add_child(button)
