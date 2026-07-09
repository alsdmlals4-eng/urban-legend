# 주파수 미니게임의 성공/실패 결과와 장비 힌트를 관리한다.
extends Control

var _sync_count := 0
var _target_count := 3
var _minigame: Dictionary = {}
var _equipment_hint: Dictionary = {}
var _last_successful := false

var _title_label: Label
var _description_label: Label
var _result_label: Label
var _progress_bar: ProgressBar
var _success_button: Button
var _fail_button: Button
var _return_button: Button


func _ready() -> void:
	if GameState.get_current_episode().is_empty():
		GameState.load_episode()

	GameState.set_current_scene_path("res://scenes/minigame_scene.tscn")
	_minigame = GameState.get_current_minigame()
	_target_count = max(1, int(_minigame.get("target_count", 3)))
	_equipment_hint = GameState.try_use_frequency_filter_hint(String(_minigame.get("id", GameState.get_current_minigame_id())))
	_build_ui()
	_update_result(_make_intro_text())


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

	_title_label = Label.new()
	_title_label.text = String(_minigame.get("title", "미니게임"))
	_title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_title_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	root.add_child(_title_label)

	var panel := PanelContainer.new()
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_child(panel)

	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 10)
	panel.add_child(content)

	_description_label = Label.new()
	_description_label.text = String(_minigame.get("description", "미니게임 설명이 없습니다."))
	_description_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(_description_label)

	_progress_bar = ProgressBar.new()
	_progress_bar.min_value = 0
	_progress_bar.max_value = _target_count
	_progress_bar.value = 0
	content.add_child(_progress_bar)

	_success_button = Button.new()
	_success_button.text = "파형 맞추기"
	_success_button.pressed.connect(_match_wave)
	content.add_child(_success_button)

	_fail_button = Button.new()
	_fail_button.text = "잘못된 주파수 선택"
	_fail_button.pressed.connect(_fail_minigame)
	content.add_child(_fail_button)

	_return_button = Button.new()
	_return_button.text = "사건 흐름으로 돌아가기"
	_return_button.visible = false
	_return_button.pressed.connect(_return_to_flow)
	content.add_child(_return_button)

	_result_label = Label.new()
	_result_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(_result_label)


func _make_intro_text() -> String:
	var text := "주파수 파형을 %d번 맞추면 동기화가 완료됩니다." % _target_count
	if not _equipment_hint.is_empty():
		text += "\n\n장비 효과: %s\n%s" % [
			String(_equipment_hint.get("equipment_name", "폐주파수 필터")),
			String(_equipment_hint.get("effect_text", ""))
		]
	return text


func _match_wave() -> void:
	_sync_count += 1
	_progress_bar.value = _sync_count
	if _sync_count >= _target_count:
		_complete_minigame(true)
	else:
		_update_result("파형 동기화 중 %d/%d" % [_sync_count, _target_count])


func _fail_minigame() -> void:
	_sync_count = 0
	_progress_bar.value = _sync_count
	_complete_minigame(false)


func _complete_minigame(successful: bool) -> void:
	_last_successful = successful
	var minigame_id := String(_minigame.get("id", GameState.get_current_minigame_id()))
	GameState.save_minigame_result(minigame_id, successful)

	_success_button.disabled = true
	_fail_button.disabled = true
	_return_button.visible = true
	_update_result(_make_result_text(successful))


func _make_result_text(successful: bool) -> String:
	var text_key := "success_result_text" if successful else "failure_result_text"
	var text := String(_minigame.get(text_key, "미니게임 결과가 기록되었습니다."))
	var hint_key := "success_show_hint_ids" if successful else "failure_show_hint_ids"
	var hint_texts := GameState.get_hint_texts_by_ids(_minigame.get(hint_key, []))
	if not hint_texts.is_empty():
		text += "\n\n기록국 힌트\n- %s" % "\n- ".join(hint_texts)

	if successful:
		text += "\n\n성공 플래그: %s" % ", ".join(_minigame.get("success_flags", []))
	else:
		text += "\n\n실패 플래그: %s" % ", ".join(_minigame.get("failure_flags", []))

	var status := GameState.get_anomaly_status_summary()
	text += "\n\n현재 상태: 괴이 위험도 %d / 괴이 이해도 %d / 정신력 %d / 괴이 안정도 %d / 예측률 %.1f%%" % [
		int(status.get("anomaly_risk", 0)),
		int(status.get("anomaly_understanding", 0)),
		int(status.get("mental_stamina", 100)),
		int(status.get("anomaly_stability", 100)),
		float(status.get("prediction_rate", 0.0))
	]
	return text


func _return_to_flow() -> void:
	var scene_path := ""
	if _last_successful:
		scene_path = String(_minigame.get("success_next_scene_path", ""))
	else:
		scene_path = String(_minigame.get("failure_next_scene_path", ""))
	if scene_path.is_empty():
		scene_path = String(_minigame.get("return_scene_path", "res://scenes/investigation_scene.tscn"))

	GameState.set_current_scene_path(scene_path)
	GameState.save_game()
	get_tree().change_scene_to_file(scene_path)


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
	_add_scene_button(row, "회수", "res://scenes/battle_scene.tscn")


func _add_scene_button(parent: Control, label: String, scene_path: String) -> void:
	var button := Button.new()
	button.text = label
	button.pressed.connect(func() -> void:
		GameState.set_current_scene_path(scene_path)
		GameState.save_game()
		get_tree().change_scene_to_file(scene_path)
	)
	parent.add_child(button)
