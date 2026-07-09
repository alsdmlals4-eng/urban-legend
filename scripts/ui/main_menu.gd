# 시작 화면에서 프로젝트 소개와 데이터베이스 진입을 관리한다.
extends Control

const GAME_VERSION := "Ver 1.5"

var _continue_button: Button
var _save_status_label: Label


func _ready() -> void:
	GameState.set_current_scene_path("res://scenes/main_menu.tscn")
	_build_ui()
	_refresh_save_controls()


func _build_ui() -> void:
	var background := ColorRect.new()
	background.color = Color(0.055, 0.06, 0.075, 1.0)
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
	margin.add_child(panel)

	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 14)
	panel.add_child(content)

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
	subtitle.text = "비주얼노벨 / 호러 미스터리 Godot 이관 프로젝트"
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(subtitle)

	var body := Label.new()
	body.text = "HTML 데이터베이스의 세력, 요원, 장비, 기술, 에피소드, 분기, 대화문, 제작 점검 구조를 Godot에서 재현합니다."
	body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(body)

	_save_status_label = Label.new()
	_save_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_save_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(_save_status_label)

	var open_button := Button.new()
	open_button.text = "기록국 데이터베이스 열기"
	open_button.pressed.connect(_open_database)
	content.add_child(open_button)

	var start_episode_button := Button.new()
	start_episode_button.text = "새 게임 / 저승역 시작"
	start_episode_button.pressed.connect(_start_afterlife_station)
	content.add_child(start_episode_button)

	_continue_button = Button.new()
	_continue_button.text = "이어하기"
	_continue_button.pressed.connect(_continue_saved_game)
	content.add_child(_continue_button)

	var clear_save_button := Button.new()
	clear_save_button.text = "저장 초기화"
	clear_save_button.pressed.connect(_clear_saved_game)
	content.add_child(clear_save_button)

	_add_scene_button(content, "MVP-002 데이터 확인", "res://scenes/case_data_scene.tscn")

	var scene_label := Label.new()
	scene_label.text = "MVP-001 핵심 씬 테스트"
	scene_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	content.add_child(scene_label)

	_add_scene_button(content, "조사씬 열기", "res://scenes/investigation_scene.tscn")
	_add_scene_button(content, "대화씬 열기", "res://scenes/dialogue_scene.tscn")
	_add_scene_button(content, "전투씬 열기", "res://scenes/battle_scene.tscn")
	_add_scene_button(content, "미니게임씬 열기", "res://scenes/minigame_scene.tscn")


func _open_database() -> void:
	get_tree().change_scene_to_file("res://scenes/database_view.tscn")


func _start_afterlife_station() -> void:
	GameState.clear_save_file()
	GameState.restart_afterlife_station_flow()
	GameState.set_current_scene_path("res://scenes/dialogue_scene.tscn")
	GameState.save_game()
	get_tree().change_scene_to_file("res://scenes/dialogue_scene.tscn")


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
		_save_status_label.text = "저장 파일: %s\n경로: %s" % [
			"있음" if has_save else "없음",
			GameState.get_save_file_path()
		]


func _add_scene_button(parent: Control, label: String, scene_path: String) -> void:
	var button := Button.new()
	button.text = label
	button.pressed.connect(func() -> void:
		get_tree().change_scene_to_file(scene_path)
	)
	parent.add_child(button)
