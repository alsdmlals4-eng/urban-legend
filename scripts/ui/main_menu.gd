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

var _start_episode_button: Button
var _continue_button: Button
var _save_status_label: Label
var _legacy_new_campaign_button: Button
var _legacy_continue_button: Button
var _legacy_status_label: Label
var _validation_primary_button: Button
var _validation_secondary_button: Button
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
	if _legacy_continue_button != null:
		_legacy_continue_button.call_deferred("grab_focus")


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
	backdrop.texture = AssetCatalog.new().get_texture("afterlife_entrance")
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	backdrop.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	backdrop.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	backdrop.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(backdrop)
	var background := ColorRect.new()
	background.color = Color(0.025, 0.035, 0.05, 0.68)
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 28)
	margin.add_theme_constant_override("margin_top", 36)
	margin.add_theme_constant_override("margin_right", 28)
	margin.add_theme_constant_override("margin_bottom", 36)
	add_child(margin)

	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	margin.add_child(panel)

	var scroll := ScrollContainer.new()
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	panel.add_child(scroll)

	var content := VBoxContainer.new()
	content.custom_minimum_size = Vector2(960, 0)
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.add_theme_constant_override("separation", 14)
	scroll.add_child(content)

	var title_row := HBoxContainer.new()
	title_row.alignment = BoxContainer.ALIGNMENT_CENTER
	title_row.add_theme_constant_override("separation", 14)
	content.add_child(title_row)

	var title := Label.new()
	title.text = "괴이 기록국"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_row.add_child(title)

	var version_label := Label.new()
	version_label.name = "VersionLabel"
	version_label.text = ProductVersion.display_text()
	version_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	version_label.add_theme_font_size_override("font_size", 10)
	title_row.add_child(version_label)

	var subtitle := Label.new()
	subtitle.text = "현대 오컬트 미스터리"
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(subtitle)

	var body := Label.new()
	body.text = "괴이의 규칙을 조사하고 현재 출현을 안정화한 뒤, 다음 피해를 막을 괴이 매뉴얼을 기록합니다."
	body.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(body)

	_log_guide = LogGuideScript.new()
	_log_guide.set_compact(true)
	content.add_child(_log_guide)
	_present_log_entry()

	_build_entry_cards(content)

	var columns := HBoxContainer.new()
	columns.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	columns.size_flags_vertical = Control.SIZE_EXPAND_FILL
	columns.add_theme_constant_override("separation", 16)
	content.add_child(columns)

	var overview_column := VBoxContainer.new()
	overview_column.custom_minimum_size = Vector2(560, 0)
	overview_column.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	overview_column.add_theme_constant_override("separation", 12)
	columns.add_child(overview_column)

	var control_column := VBoxContainer.new()
	control_column.custom_minimum_size = Vector2(360, 0)
	control_column.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	control_column.add_theme_constant_override("separation", 12)
	columns.add_child(control_column)

	var case_image := TextureRect.new()
	case_image.texture = AssetCatalog.new().get_texture("afterlife_platform")
	case_image.custom_minimum_size = Vector2(0, 240)
	case_image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	case_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	overview_column.add_child(case_image)
	var case_focus := Label.new()
	case_focus.text = "첫 기록 · 저승역\n막차 이후 존재하지 않는 승강장에서 반복 규칙을 추적합니다."
	case_focus.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	overview_column.add_child(case_focus)

	var database_content := _add_section(
		control_column,
		"기록 열람",
		"확보한 사건·요원·괴이 기록을 확인합니다."
	)
	_database_button = Button.new()
	_database_button.name = "DatabaseButton"
	_database_button.text = "기록국 DB"
	_database_button.focus_mode = Control.FOCUS_ALL
	_database_button.pressed.connect(_open_database)
	database_content.add_child(_database_button)

	_add_accessibility_panel(control_column)

	var dev_content := _add_section(
		control_column,
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

	var scene_label := Label.new()
	scene_label.text = "MVP-001 핵심 씬 테스트"
	scene_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	dev_content.add_child(scene_label)

	_add_scene_button(
		dev_content,
		"CORE-MVP-001 조사→전조→포획 PoC",
		"res://scenes/poc/core_mvp_001/core_mvp_001_scene.tscn"
	)
	_add_scene_button(
		dev_content,
		"ANNUAL-MVP-001 육성→사건→연구 PoC",
		"res://scenes/poc/annual_mvp_001/annual_mvp_001_scene.tscn"
	)
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

	_build_validation_dialogs()
	_configure_entry_focus()


func _build_entry_cards(parent: Control) -> void:
	var entry_cards := HBoxContainer.new()
	entry_cards.name = "EntryCards"
	entry_cards.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	entry_cards.add_theme_constant_override("separation", 16)
	parent.add_child(entry_cards)

	var legacy_content := _add_section(
		entry_cards,
		"기존 진행",
		"본편 캠페인 기록입니다. Validation 기록과 서로 영향을 주지 않습니다."
	)
	_legacy_status_label = Label.new()
	_legacy_status_label.name = "LegacyStatusLabel"
	_legacy_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
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
	_validation_badge_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	validation_content.add_child(_validation_badge_label)

	_validation_status_label = Label.new()
	_validation_status_label.name = "ValidationStatusLabel"
	_validation_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
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
	if _legacy_continue_button == null or _legacy_new_campaign_button == null:
		return
	_legacy_continue_button.focus_neighbor_bottom = _legacy_continue_button.get_path_to(_legacy_new_campaign_button)
	_legacy_new_campaign_button.focus_neighbor_top = _legacy_new_campaign_button.get_path_to(_legacy_continue_button)
	_legacy_new_campaign_button.focus_neighbor_right = _legacy_new_campaign_button.get_path_to(_validation_primary_button)
	_validation_primary_button.focus_neighbor_left = _validation_primary_button.get_path_to(_legacy_continue_button)
	_validation_primary_button.focus_neighbor_bottom = _validation_primary_button.get_path_to(_validation_secondary_button)
	_validation_secondary_button.focus_neighbor_top = _validation_secondary_button.get_path_to(_validation_primary_button)
	_validation_secondary_button.focus_neighbor_bottom = _validation_secondary_button.get_path_to(_database_button)
	_database_button.focus_neighbor_top = _database_button.get_path_to(_validation_primary_button)


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
	if _validation_primary_button != null:
		_validation_primary_button.disabled = not enabled
	if _validation_secondary_button != null:
		_validation_secondary_button.disabled = not enabled


func _change_scene_for_validation(scene_path: String) -> int:
	return get_tree().change_scene_to_file(scene_path)


func _add_accessibility_panel(parent: Control) -> void:
	var content := _add_section(parent, "연출 강도", "화면 연출을 편한 수준으로 조절합니다.")
	_add_effect_slider(content, "화면 흔들림", "screen_shake")
	_add_effect_slider(content, "섬광", "flash")
	_add_effect_slider(content, "공포 왜곡", "horror_distortion")


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
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	content.add_child(title)

	if not description_text.is_empty():
		var description := Label.new()
		description.text = description_text
		description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
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
