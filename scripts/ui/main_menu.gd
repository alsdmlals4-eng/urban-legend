# 시작 화면에서 프로젝트 소개와 데이터베이스 진입을 관리한다.
extends Control

const ThemeFactory = preload("res://scripts/ui/ui_theme_factory.gd")
const Accessibility = preload("res://scripts/ui/accessibility_settings.gd")
const AssetCatalog = preload("res://scripts/ui/ui_asset_catalog.gd")
const LogGuideScript = preload("res://scripts/ui/log_guide.gd")
const LogTutorialCatalog = preload("res://scripts/ui/log_tutorial_catalog.gd")

const GAME_VERSION := "Ver 3.8"

var _start_episode_button: Button
var _continue_button: Button
var _save_status_label: Label
var _dev_panel: Control
var _accessibility := Accessibility.new()
var _log_guide: LogGuide


func _ready() -> void:
	theme = ThemeFactory.create_theme()
	if GameState.get_current_episode().is_empty():
		GameState.load_episode()

	GameState.set_current_scene_path("res://scenes/main_menu.tscn")
	set_process_input(true)
	_build_ui()
	_refresh_save_controls()


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
	margin.add_theme_constant_override("margin_top", 72)
	margin.add_theme_constant_override("margin_right", 28)
	margin.add_theme_constant_override("margin_bottom", 72)
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
	title.text = "도시괴담 기록국"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_row.add_child(title)

	var version_label := Label.new()
	version_label.text = GAME_VERSION
	version_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	version_label.add_theme_font_size_override("font_size", 10)
	title_row.add_child(version_label)

	var subtitle := Label.new()
	subtitle.text = "현대 오컬트 미스터리"
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(subtitle)

	var body := Label.new()
	body.text = "괴담기록국 요원 팀을 편성해 두 도시괴담의 규칙을 조사하고, 단서를 근거로 괴이를 안정화·회수합니다."
	body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(body)

	_log_guide = LogGuideScript.new()
	_log_guide.set_compact(true)
	content.add_child(_log_guide)
	_present_log_entry()

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
	case_image.custom_minimum_size = Vector2(0, 360)
	case_image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	case_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	overview_column.add_child(case_image)
	var case_focus := Label.new()
	case_focus.text = "첫 기록 · 저승역\n막차 이후 존재하지 않는 승강장에서 반복 규칙을 추적합니다."
	case_focus.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	overview_column.add_child(case_focus)

	var action_content := _add_section(
		control_column,
		"주요 행동",
		"새 수사를 시작하거나 저장된 진행을 이어가고, 기록국 DB에서 확보한 정보를 다시 확인합니다."
	)

	_start_episode_button = Button.new()
	_start_episode_button.text = "새 캠페인 시작"
	_start_episode_button.pressed.connect(_start_afterlife_station)
	action_content.add_child(_start_episode_button)

	_continue_button = Button.new()
	_continue_button.text = "이어하기"
	_continue_button.pressed.connect(_continue_saved_game)
	action_content.add_child(_continue_button)

	var open_button := Button.new()
	open_button.text = "기록국 DB"
	open_button.pressed.connect(_open_database)
	action_content.add_child(open_button)

	var status_content := _add_section(
		control_column,
		"저장 상태",
		"이어하기 가능 여부를 확인합니다."
	)

	_save_status_label = Label.new()
	_save_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_save_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	status_content.add_child(_save_status_label)

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

	_add_scene_button(dev_content, "조사씬 열기", "res://scenes/investigation_scene.tscn")
	_add_scene_button(dev_content, "준비 화면 열기", GameState.SCENE_PREPARATION)
	_add_scene_button(dev_content, "대화씬 열기", "res://scenes/dialogue_scene.tscn")
	_add_scene_button(dev_content, "회수 페이즈 열기", "res://scenes/battle_scene.tscn")
	_add_scene_button(dev_content, "미니게임씬 열기", "res://scenes/minigame_scene.tscn")


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
	title.text = "%s 변경사항" % GAME_VERSION
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
	GameState.reset_run_state()
	GameState.set_current_scene_path(GameState.SCENE_PREPARATION)
	GameState.save_game()
	get_tree().change_scene_to_file(GameState.SCENE_PREPARATION)


func _continue_saved_game() -> void:
	if not GameState.load_game():
		_refresh_save_controls()
		return

	var scene_path := GameState.get_current_scene_path()
	if scene_path == "res://scenes/main_menu.tscn":
		scene_path = "res://scenes/dialogue_scene.tscn"
	get_tree().change_scene_to_file(scene_path)


func _clear_saved_game() -> void:
	GameState.clear_save_file()
	GameState.reset_run_state()
	GameState.set_current_scene_path("res://scenes/main_menu.tscn")
	_refresh_save_controls()


func _refresh_save_controls() -> void:
	var has_save := GameState.has_save_file()
	if _continue_button != null:
		_continue_button.disabled = not has_save
	if _save_status_label != null:
		_save_status_label.text = "이어하기: %s" % ("있음" if has_save else "없음")


func _add_scene_button(parent: Control, label: String, scene_path: String) -> void:
	var button := Button.new()
	button.text = label
	button.pressed.connect(func() -> void:
		get_tree().change_scene_to_file(scene_path)
	)
	parent.add_child(button)
