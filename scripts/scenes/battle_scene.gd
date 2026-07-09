# 전투 씬의 기본 행동 버튼과 지원군 UI를 관리한다.
extends Control

var _player_hp := 100
var _enemy_hp := 100
var _player_bar: ProgressBar
var _enemy_bar: ProgressBar
var _result_label: Label


func _ready() -> void:
	_build_ui()
	_update_bars("괴담 조우가 시작되었습니다. 행동을 선택하세요.")


func _build_ui() -> void:
	var background := ColorRect.new()
	background.color = Color(0.075, 0.05, 0.06, 1.0)
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 20)
	margin.add_theme_constant_override("margin_top", 20)
	margin.add_theme_constant_override("margin_right", 20)
	margin.add_theme_constant_override("margin_bottom", 20)
	add_child(margin)

	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation", 10)
	margin.add_child(root)

	_add_navigation(root)

	var title := Label.new()
	title.text = "전투 씬 placeholder: 신입 요원 vs 괴담 현상"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	root.add_child(title)

	var resolution_phase_label := Label.new()
	resolution_phase_label.text = _make_resolution_phase_text()
	resolution_phase_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	resolution_phase_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	root.add_child(resolution_phase_label)

	var status_panel := PanelContainer.new()
	root.add_child(status_panel)

	var status := VBoxContainer.new()
	status.add_theme_constant_override("separation", 8)
	status_panel.add_child(status)

	status.add_child(_make_label("신입 요원 체력"))
	_player_bar = _make_bar()
	status.add_child(_player_bar)

	status.add_child(_make_label("괴담 위험도"))
	_enemy_bar = _make_bar()
	status.add_child(_enemy_bar)

	var actions := GridContainer.new()
	actions.columns = 1
	actions.add_theme_constant_override("v_separation", 6)
	root.add_child(actions)

	_add_action(actions, "기록 스캔", 18, 4, "단말기로 괴담의 약점을 스캔했습니다.")
	_add_action(actions, "임시 봉인지", 26, 8, "봉인지가 괴담의 발동 조건을 늦췄습니다.")
	_add_action(actions, "거리 유지", 10, -8, "거리를 벌려 요원의 피해를 줄였습니다.")

	var support_panel := PanelContainer.new()
	root.add_child(support_panel)

	var support := VBoxContainer.new()
	support.add_theme_constant_override("separation", 6)
	support_panel.add_child(support)

	support.add_child(_make_label("지원군 UI: 대기 중인 요원"))
	var support_button := Button.new()
	support_button.text = "연하린 지원 스킬: 부적 봉인"
	support_button.pressed.connect(func() -> void:
		_enemy_hp = max(0, _enemy_hp - 22)
		_update_bars("연하린이 부적 봉인으로 괴담 위험도를 낮췄습니다.")
	)
	support.add_child(support_button)

	_result_label = Label.new()
	_result_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	root.add_child(_result_label)


func _make_label(text: String) -> Label:
	var label := Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return label


func _make_bar() -> ProgressBar:
	var bar := ProgressBar.new()
	bar.min_value = 0
	bar.max_value = 100
	bar.value = 100
	return bar


func _make_resolution_phase_text() -> String:
	var selected_label: String = GameState.get_selected_resolution_label()
	if selected_label.is_empty():
		return "해결 페이즈: 직접 진입하지 않은 전투 테스트입니다."

	return "해결 페이즈 진입 등급: %s / 저장된 단서 수집률: %.0f%%" % [
		selected_label,
		GameState.get_selected_resolution_rate()
	]


func _add_action(parent: Control, label: String, enemy_damage: int, player_damage: int, message: String) -> void:
	var button := Button.new()
	button.text = label
	button.pressed.connect(func() -> void:
		_enemy_hp = max(0, _enemy_hp - enemy_damage)
		_player_hp = clampi(_player_hp - player_damage, 0, 100)
		_update_bars(message)
	)
	parent.add_child(button)


func _update_bars(message: String) -> void:
	if _player_bar != null:
		_player_bar.value = _player_hp
	if _enemy_bar != null:
		_enemy_bar.value = _enemy_hp
	if _enemy_hp <= 0:
		_result_label.text = "전투 종료: 괴담 현상을 약화시키고 기록국 봉인 절차로 넘겼습니다."
	else:
		_result_label.text = message


func _add_navigation(parent: Control) -> void:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 6)
	parent.add_child(row)
	_add_scene_button(row, "메뉴", "res://scenes/main_menu.tscn")
	_add_scene_button(row, "조사", "res://scenes/investigation_scene.tscn")
	_add_scene_button(row, "대화", "res://scenes/dialogue_scene.tscn")
	_add_scene_button(row, "미니게임", "res://scenes/minigame_scene.tscn")


func _add_scene_button(parent: Control, label: String, scene_path: String) -> void:
	var button := Button.new()
	button.text = label
	button.pressed.connect(func() -> void:
		get_tree().change_scene_to_file(scene_path)
	)
	parent.add_child(button)
