# 시작 화면에서 프로젝트 소개와 데이터베이스 진입을 관리한다.
extends Control

const GAME_VERSION := "Ver 1.8"

var _start_episode_button: Button
var _continue_button: Button
var _save_status_label: Label
var _agent_status_label: Label
var _agent_button_by_id: Dictionary = {}


func _ready() -> void:
	if GameState.get_current_episode().is_empty():
		GameState.load_episode()

	GameState.set_current_scene_path("res://scenes/main_menu.tscn")
	_build_ui()
	_refresh_save_controls()
	_refresh_agent_controls()


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

	_add_agent_selection_panel(content)

	var open_button := Button.new()
	open_button.text = "기록국 데이터베이스 열기"
	open_button.pressed.connect(_open_database)
	content.add_child(open_button)

	_start_episode_button = Button.new()
	_start_episode_button.text = "새 게임 / 저승역 시작"
	_start_episode_button.pressed.connect(_start_afterlife_station)
	content.add_child(_start_episode_button)

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
	_add_scene_button(content, "준비 화면 열기", GameState.SCENE_PREPARATION)
	_add_scene_button(content, "대화씬 열기", "res://scenes/dialogue_scene.tscn")
	_add_scene_button(content, "전투씬 열기", "res://scenes/battle_scene.tscn")
	_add_scene_button(content, "미니게임씬 열기", "res://scenes/minigame_scene.tscn")


func _open_database() -> void:
	get_tree().change_scene_to_file("res://scenes/database_view.tscn")


func _start_afterlife_station() -> void:
	if not GameState.can_start_mission_with_agents():
		_save_status_label.text = GameState.get_agent_selection_status_text()
		_refresh_agent_controls()
		return

	var selected_agent_ids := GameState.get_selected_agent_ids()
	GameState.clear_save_file()
	GameState.restart_afterlife_station_flow(selected_agent_ids)
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
		_save_status_label.text = "저장 파일: %s\n경로: %s" % [
			"있음" if has_save else "없음",
			GameState.get_save_file_path()
		]
	_refresh_agent_controls()


func _add_agent_selection_panel(parent: Control) -> void:
	var panel := PanelContainer.new()
	parent.add_child(panel)

	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 8)
	panel.add_child(content)

	var title := Label.new()
	title.text = "임무 투입 요원 편성"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	content.add_child(title)

	_agent_status_label = Label.new()
	_agent_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_agent_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	content.add_child(_agent_status_label)

	for agent in GameState.get_agents():
		if typeof(agent) == TYPE_DICTIONARY:
			_add_agent_button(content, agent)


func _add_agent_button(parent: Control, agent: Dictionary) -> void:
	var agent_id := String(agent.get("id", ""))
	if agent_id.is_empty():
		return

	var button := Button.new()
	button.toggle_mode = true
	button.text = _make_agent_button_text(agent, false)
	button.pressed.connect(func() -> void:
		_toggle_agent_selection(agent_id)
	)
	_agent_button_by_id[agent_id] = button
	parent.add_child(button)

	var description := Label.new()
	description.text = "%s / %s\n%s" % [
		String(agent.get("class", "")),
		String(agent.get("role", "")),
		String(agent.get("description", ""))
	]
	description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	parent.add_child(description)


func _toggle_agent_selection(agent_id: String) -> void:
	if GameState.is_agent_selected(agent_id):
		GameState.deselect_agent(agent_id)
	elif not GameState.select_agent(agent_id):
		_save_status_label.text = "요원은 최대 %d명까지만 편성할 수 있습니다." % GameState.MAX_SELECTED_AGENTS
	_refresh_agent_controls()


func _refresh_agent_controls() -> void:
	if _agent_status_label == null:
		return

	var selected_count := GameState.get_selected_agent_ids().size()
	_agent_status_label.text = "%s\n선택: %d/%d\n현재 편성: %s" % [
		GameState.get_agent_selection_status_text(),
		selected_count,
		GameState.MAX_SELECTED_AGENTS,
		GameState.get_selected_agent_summary()
	]

	for agent in GameState.get_agents():
		if typeof(agent) != TYPE_DICTIONARY:
			continue

		var agent_id := String(agent.get("id", ""))
		var button: Button = _agent_button_by_id.get(agent_id, null)
		if button == null:
			continue

		var selected := GameState.is_agent_selected(agent_id)
		button.button_pressed = selected
		button.disabled = not selected and selected_count >= GameState.MAX_SELECTED_AGENTS
		button.text = _make_agent_button_text(agent, selected)

	if _start_episode_button != null:
		_start_episode_button.disabled = not GameState.can_start_mission_with_agents()


func _make_agent_button_text(agent: Dictionary, selected: bool) -> String:
	var prefix := "선택됨" if selected else "선택"
	return "%s: %s [%s]" % [
		prefix,
		String(agent.get("name", "")),
		String(agent.get("temperament_label", ""))
	]


func _add_scene_button(parent: Control, label: String, scene_path: String) -> void:
	var button := Button.new()
	button.text = label
	button.pressed.connect(func() -> void:
		get_tree().change_scene_to_file(scene_path)
	)
	parent.add_child(button)
