# 미니게임 씬의 간단한 상호작용과 성공 실패 결과를 관리한다.
extends Control

var _sync_count := 0
var _result_label: Label
var _progress_bar: ProgressBar


func _ready() -> void:
	GameState.set_current_scene_path("res://scenes/minigame_scene.tscn")
	_build_ui()
	_update_result("파형을 세 번 맞추면 기억 표찰이 안정화됩니다.")


func _build_ui() -> void:
	var background := ColorRect.new()
	background.color = Color(0.04, 0.065, 0.075, 1.0)
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
	title.text = "미니게임 씬 placeholder: 폐주파수 파형 맞추기"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	root.add_child(title)

	var panel := PanelContainer.new()
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_child(panel)

	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 10)
	panel.add_child(content)

	var description := Label.new()
	description.text = "상호작용: 기록국 단말기의 폐주파수 파형을 맞춰 괴담 신호를 고정합니다."
	description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(description)

	_progress_bar = ProgressBar.new()
	_progress_bar.min_value = 0
	_progress_bar.max_value = 3
	_progress_bar.value = 0
	content.add_child(_progress_bar)

	var success_button := Button.new()
	success_button.text = "파형 맞추기"
	success_button.pressed.connect(_match_wave)
	content.add_child(success_button)

	var fail_button := Button.new()
	fail_button.text = "잘못된 주파수 선택"
	fail_button.pressed.connect(func() -> void:
		_sync_count = 0
		_progress_bar.value = _sync_count
		GameState.add_flag("minigame_frequency_failed")
		GameState.save_game()
		_update_result("실패: 잡음이 커져 신호가 흩어졌습니다. 다시 시도하세요.")
	)
	content.add_child(fail_button)

	_result_label = Label.new()
	_result_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(_result_label)


func _match_wave() -> void:
	_sync_count += 1
	_progress_bar.value = _sync_count
	if _sync_count >= 3:
		GameState.add_flag("minigame_frequency_success")
		GameState.add_flag("heard_station_noise")
		GameState.save_game()
		_update_result("성공: 폐주파수 신호가 고정되고 다음 단서가 열립니다.")
	else:
		_update_result("파형 동기화 중: %d/3" % _sync_count)


func _update_result(text: String) -> void:
	if _result_label != null:
		_result_label.text = text


func _add_navigation(parent: Control) -> void:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 6)
	parent.add_child(row)
	_add_scene_button(row, "메뉴", "res://scenes/main_menu.tscn")
	_add_scene_button(row, "조사", "res://scenes/investigation_scene.tscn")
	_add_scene_button(row, "대화", "res://scenes/dialogue_scene.tscn")
	_add_scene_button(row, "전투", "res://scenes/battle_scene.tscn")


func _add_scene_button(parent: Control, label: String, scene_path: String) -> void:
	var button := Button.new()
	button.text = label
	button.pressed.connect(func() -> void:
		GameState.set_current_scene_path(scene_path)
		GameState.save_game()
		get_tree().change_scene_to_file(scene_path)
	)
	parent.add_child(button)
