# 시작 화면에서 프로젝트 소개와 데이터베이스 진입을 관리한다.
extends Control

const AfterlifeTheme = preload("res://scripts/ui/afterlife_station_theme.gd")
const AssetCatalog = preload("res://scripts/ui/ui_asset_catalog.gd")
const LogGuideScript = preload("res://scripts/ui/log_guide.gd")
const LogTutorialCatalog = preload("res://scripts/ui/log_tutorial_catalog.gd")
const GameSettingsDialogScript = preload("res://scripts/ui/game_settings_dialog.gd")
const DisplaySettingsScript = preload("res://scripts/ui/display_settings.gd")

const GAME_VERSION := "Ver 4.1"

var _start_episode_button: Button
var _continue_button: Button
var _save_status_label: Label
var _dev_panel: Control
var _log_guide: LogGuide


func _ready() -> void:
	theme = AfterlifeTheme.create_theme()
	DisplaySettingsScript.new().apply_saved_preferences()
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
	background.color = Color(0.008, 0.007, 0.011, 0.72)
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_top", 12)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_bottom", 12)
	add_child(margin)

	var content := VBoxContainer.new()
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content.add_theme_constant_override("separation", 8)
	margin.add_child(content)

	var header := PanelContainer.new()
	header.name = "MainMenuHeader"
	header.custom_minimum_size.y = 48
	header.theme_type_variation = &"AfterlifeHeader"
	content.add_child(header)
	var title_row := HBoxContainer.new()
	title_row.add_theme_constant_override("separation", 8)
	header.add_child(title_row)
	var title := Label.new()
	title.text = "괴이 기록국"
	title.custom_minimum_size.x = 170
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.theme_type_variation = &"AfterlifeTitle"
	title_row.add_child(title)
	var team := Label.new()
	team.text = "팀 상태 · 기록국 대기"
	team.theme_type_variation = &"AfterlifeMeta"
	team.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title_row.add_child(team)
	var stage := Label.new()
	stage.text = "신규 캠페인 준비"
	stage.theme_type_variation = &"AfterlifeTitle"
	stage.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	stage.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_row.add_child(stage)
	var version_label := Label.new()
	version_label.text = GAME_VERSION
	version_label.theme_type_variation = &"AfterlifeMeta"
	version_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title_row.add_child(version_label)
	var settings_button := Button.new()
	settings_button.name = "DisplaySettingsButton"
	settings_button.text = "설정"
	settings_button.pressed.connect(func() -> void: GameSettingsDialogScript.open_for(self))
	title_row.add_child(settings_button)

	var status := PanelContainer.new()
	status.custom_minimum_size.y = 32
	status.theme_type_variation = &"AfterlifeHeader"
	content.add_child(status)
	var status_label := Label.new()
	status_label.text = "기록국 관제  ·  마음과 기억에서 되살아나는 괴이의 규칙을 조사하고, 현재 출현을 안정화합니다."
	status_label.theme_type_variation = &"AfterlifeMeta"
	status.add_child(status_label)

	var columns := HBoxContainer.new()
	columns.name = "MainMenuColumns"
	columns.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	columns.size_flags_vertical = Control.SIZE_EXPAND_FILL
	columns.add_theme_constant_override("separation", 8)
	content.add_child(columns)

	var overview_column := VBoxContainer.new()
	overview_column.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	overview_column.size_flags_stretch_ratio = 0.26
	overview_column.add_theme_constant_override("separation", 8)
	columns.add_child(overview_column)

	var control_column := VBoxContainer.new()
	control_column.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	control_column.size_flags_stretch_ratio = 0.48
	control_column.add_theme_constant_override("separation", 8)
	columns.add_child(control_column)
	var archive_column := VBoxContainer.new()
	archive_column.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	archive_column.size_flags_stretch_ratio = 0.26
	archive_column.add_theme_constant_override("separation", 8)
	columns.add_child(archive_column)

	var image_panel := PanelContainer.new()
	image_panel.name = "FieldPreviewPanel"
	image_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	image_panel.theme_type_variation = &"AfterlifePanel"
	overview_column.add_child(image_panel)
	var image_box := VBoxContainer.new()
	image_panel.add_child(image_box)
	var image_title := Label.new()
	image_title.text = "현장 이미지"
	image_title.theme_type_variation = &"AfterlifeSection"
	image_box.add_child(image_title)
	var case_image := TextureRect.new()
	case_image.texture = AssetCatalog.new().get_texture("afterlife_platform")
	case_image.size_flags_vertical = Control.SIZE_EXPAND_FILL
	case_image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	case_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	image_box.add_child(case_image)
	var case_focus := Label.new()
	case_focus.text = "첫 기록 · 저승역\n플랫폼 진입부 · 현장 연결 대기"
	case_focus.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	case_focus.theme_type_variation = &"AfterlifeMeta"
	image_box.add_child(case_focus)

	var action_panel := PanelContainer.new()
	action_panel.name = "CampaignPanel"
	action_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	action_panel.theme_type_variation = &"AfterlifePanel"
	control_column.add_child(action_panel)
	var action_content := VBoxContainer.new()
	action_content.add_theme_constant_override("separation", 10)
	action_panel.add_child(action_content)
	var bureau_title := Label.new()
	bureau_title.text = "기록국 관제"
	bureau_title.theme_type_variation = &"AfterlifeSection"
	action_content.add_child(bureau_title)
	var briefing := Label.new()
	briefing.text = "사람의 마음과 기억이 남아 있는 한, 괴이는 다른 장소와 모습으로 다시 나타날 수 있습니다. 기록국은 처치가 아니라 조사·안정화·잔향 회수로 다음 피해를 막습니다."
	briefing.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	action_content.add_child(briefing)
	_log_guide = LogGuideScript.new()
	_log_guide.set_compact(true)
	action_content.add_child(_log_guide)
	_present_log_entry()
	var action_title := Label.new()
	action_title.text = "수사 선택"
	action_title.theme_type_variation = &"AfterlifeTitle"
	action_content.add_child(action_title)

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

	_save_status_label = Label.new()
	_save_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_save_status_label.theme_type_variation = &"AfterlifeMeta"
	action_content.add_child(_save_status_label)

	var archive_panel := PanelContainer.new()
	archive_panel.name = "ArchivePanel"
	archive_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	archive_panel.theme_type_variation = &"AfterlifePanel"
	archive_column.add_child(archive_panel)
	var archive_content := VBoxContainer.new()
	archive_content.add_theme_constant_override("separation", 12)
	archive_panel.add_child(archive_content)
	var archive_title := Label.new()
	archive_title.text = "이상 정보"
	archive_title.theme_type_variation = &"AfterlifeSection"
	archive_content.add_child(archive_title)
	var archive_glyph := Label.new()
	archive_glyph.text = "◇\n기록 대기"
	archive_glyph.size_flags_vertical = Control.SIZE_EXPAND_FILL
	archive_glyph.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	archive_glyph.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	archive_glyph.add_theme_color_override("font_color", AfterlifeTheme.VIOLET)
	archive_content.add_child(archive_glyph)
	var archive_text := Label.new()
	archive_text.text = "확보한 규칙과 안정화 기록은 괴이 매뉴얼과 기록국 DB에 남습니다."
	archive_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	archive_text.theme_type_variation = &"AfterlifeMeta"
	archive_content.add_child(archive_text)

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
	GameState.restart_afterlife_station_flow(["agent_oh_hyun", "agent_kwon_narae", "agent_kang_ijun"])
	GameState.save_game()
	get_tree().change_scene_to_file(GameState.SCENE_DIALOGUE)


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
