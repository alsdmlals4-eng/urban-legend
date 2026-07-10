# 전투 씬의 단서 자동 발동과 괴이 핵 회수를 관리한다.
extends Control

const BASE_ANOMALY_STABILITY := 100
const BASE_RECOVERY_THRESHOLD := 40
const MAX_RECOVERY_THRESHOLD := 75
const CLUE_THRESHOLD_FACTOR := 0.5
const CLUE_START_WEAKEN_FACTOR := 0.2
var _anomaly_stability := BASE_ANOMALY_STABILITY
var _fear_level := 0
var _recovery_threshold := BASE_RECOVERY_THRESHOLD
var _total_clue_effect_value := 0
var _recovery_completed := false
var _active_effects: Array = []
var _minigame_recovery_messages: Array[String] = []
var _action_buttons: Array[Button] = []
var _agent_support_buttons: Array[Button] = []

var _stability_bar: ProgressBar
var _fear_bar: ProgressBar
var _threshold_label: Label
var _prediction_label: Label
var _auto_effect_label: Label
var _result_label: Label
var _recover_button: Button


func _ready() -> void:
	if GameState.get_current_episode().is_empty():
		GameState.load_episode()

	GameState.set_current_scene_path("res://scenes/battle_scene.tscn")
	_active_effects = GameState.get_collected_battle_effects()
	_apply_collected_clue_effects()
	_build_ui()
	_update_battle_view(_make_start_message())


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

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	margin.add_child(scroll)

	var root := VBoxContainer.new()
	root.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	root.add_theme_constant_override("separation", 10)
	scroll.add_child(root)

	_add_navigation(root)

	var title := Label.new()
	title.text = "괴이 안정화 / 회수 페이즈: %s" % GameState.get_current_episode_title()
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	root.add_child(title)

	var resolution_phase_label := Label.new()
	resolution_phase_label.text = _make_resolution_phase_text()
	resolution_phase_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	resolution_phase_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	root.add_child(resolution_phase_label)

	var effect_panel := PanelContainer.new()
	root.add_child(effect_panel)

	_auto_effect_label = Label.new()
	_auto_effect_label.text = _make_auto_effect_text()
	_auto_effect_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	effect_panel.add_child(_auto_effect_label)

	var status_panel := PanelContainer.new()
	root.add_child(status_panel)

	var status := VBoxContainer.new()
	status.add_theme_constant_override("separation", 8)
	status_panel.add_child(status)

	status.add_child(_make_label("괴이 안정도"))
	_stability_bar = _make_bar(100)
	status.add_child(_stability_bar)

	_threshold_label = _make_label("")
	status.add_child(_threshold_label)

	_prediction_label = _make_label("")
	status.add_child(_prediction_label)

	status.add_child(_make_label("현장 위험/공포도"))
	_fear_bar = _make_bar(100)
	status.add_child(_fear_bar)

	var actions := GridContainer.new()
	actions.columns = 1
	actions.add_theme_constant_override("v_separation", 6)
	root.add_child(actions)

	_add_prediction_action(actions)
	_add_stability_action(actions, "기록 스캔", 18, 6, "단말기로 괴이의 반복 규칙을 스캔했습니다.")
	_add_stability_action(actions, "임시 봉인지", 24, 9, "봉인지가 괴이의 핵 주변을 짧게 고정했습니다.")
	_add_defense_action(actions)
	_add_support_action(actions)
	_add_agent_recovery_support_actions(actions)

	_recover_button = Button.new()
	_recover_button.text = "괴이 핵 회수"
	_recover_button.pressed.connect(_recover_anomaly_core)
	root.add_child(_recover_button)

	_result_label = Label.new()
	_result_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	root.add_child(_result_label)


func _apply_collected_clue_effects() -> void:
	_total_clue_effect_value = 0
	for effect in _active_effects:
		if typeof(effect) == TYPE_DICTIONARY:
			_total_clue_effect_value += int(effect.get("effect_value", 0))

	var threshold_bonus := int(floor(float(_total_clue_effect_value) * CLUE_THRESHOLD_FACTOR))
	_recovery_threshold = clampi(
		BASE_RECOVERY_THRESHOLD + threshold_bonus,
		BASE_RECOVERY_THRESHOLD,
		MAX_RECOVERY_THRESHOLD
	)

	var start_weaken_amount := int(floor(float(_total_clue_effect_value) * CLUE_START_WEAKEN_FACTOR))
	_anomaly_stability = clampi(
		BASE_ANOMALY_STABILITY - start_weaken_amount,
		0,
		BASE_ANOMALY_STABILITY
	)

	_apply_minigame_recovery_effects()

	var investigation_stability_delta := GameState.get_anomaly_stability() - BASE_ANOMALY_STABILITY
	var risk_penalty := int(floor(float(GameState.get_anomaly_risk()) / 25.0))
	_anomaly_stability = clampi(
		_anomaly_stability + investigation_stability_delta + risk_penalty,
		0,
		BASE_ANOMALY_STABILITY
	)
	_fear_level = clampi(int(floor(float(100 - GameState.get_mental_stamina()) / 5.0)), 0, 100)


func _apply_minigame_recovery_effects() -> void:
	_minigame_recovery_messages.clear()
	for minigame_id in GameState.get_minigame_results():
		var minigame := GameState.get_minigame(String(minigame_id))
		var result := GameState.get_minigame_result(String(minigame_id))
		if minigame.is_empty() or result.is_empty():
			continue

		var prefix := "success" if bool(result.get("successful", false)) else "failure"
		_recovery_threshold = clampi(
			_recovery_threshold + int(minigame.get("%s_recovery_threshold_delta" % prefix, 0)),
			30,
			MAX_RECOVERY_THRESHOLD
		)
		_anomaly_stability = clampi(
			_anomaly_stability + int(minigame.get("%s_recovery_stability_delta" % prefix, 0)),
			0,
			BASE_ANOMALY_STABILITY
		)
		var outcome := "성공" if prefix == "success" else "실패"
		_minigame_recovery_messages.append("%s %s: %s" % [
			String(minigame.get("title", minigame_id)),
			outcome,
			String(result.get("result_text", "회수 페이즈에 결과가 반영되었습니다."))
		])


func _make_start_message() -> String:
	var minigame_text := _make_minigame_battle_text()
	var investigation_text := _make_investigation_status_text()
	if _active_effects.is_empty():
		return "수집한 단서가 없어 자동 발동 효과 없이 회수 페이즈를 시작합니다.%s%s" % [minigame_text, investigation_text]

	return "수집한 단서 %d개가 자동 발동했습니다. 현재 회수 가능 기준은 괴이 안정도 %d 이하입니다.%s%s" % [
		_active_effects.size(),
		_recovery_threshold,
		minigame_text,
		investigation_text
	]


func _make_auto_effect_text() -> String:
	if _active_effects.is_empty():
		return "자동 발동 단서: 없음\n힌트는 단서가 아니므로 전투 자동 발동에 포함되지 않습니다."

	var text := "자동 발동 단서\n"
	for effect in _active_effects:
		if typeof(effect) != TYPE_DICTIONARY:
			continue

		text += "- %s: %s (효과값 %d)\n" % [
			effect.get("clue_title", "이름 없는 단서"),
			effect.get("description", ""),
			int(effect.get("effect_value", 0))
		]

	text += "힌트는 단서가 아니므로 전투 자동 발동에 포함되지 않습니다."
	var minigame_text := _make_minigame_battle_text().strip_edges()
	if not minigame_text.is_empty():
		text += "\n\n미니게임 영향\n%s" % minigame_text
	return text.strip_edges()


func _make_minigame_battle_text() -> String:
	if _minigame_recovery_messages.is_empty():
		return ""
	return "\n%s" % "\n".join(_minigame_recovery_messages)


func _make_investigation_status_text() -> String:
	var status := GameState.get_anomaly_status_summary()
	if int(status.get("anomaly_risk", 0)) <= 0 and int(status.get("anomaly_understanding", 0)) <= 0 and int(status.get("victim_understanding", 0)) <= 0:
		return ""

	return "\n조사 루프 영향: 괴이 위험도 %d / 괴이 이해도 %d / 피해자 이해도 %d / 정신력 %d / 조사상 괴이 안정도 %d / 예측률 %.1f%%" % [
		int(status.get("anomaly_risk", 0)),
		int(status.get("anomaly_understanding", 0)),
		int(status.get("victim_understanding", 0)),
		int(status.get("mental_stamina", 100)),
		int(status.get("anomaly_stability", 100)),
		float(status.get("prediction_rate", 0.0))
	]


func _make_label(text: String) -> Label:
	var label := Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return label


func _make_bar(max_value: int) -> ProgressBar:
	var bar := ProgressBar.new()
	bar.min_value = 0
	bar.max_value = max_value
	bar.value = max_value
	return bar


func _make_resolution_phase_text() -> String:
	var selected_label: String = GameState.get_selected_resolution_label()
	if selected_label.is_empty():
		return "해결 페이즈: 직접 진입하지 않은 전투 테스트입니다."

	return "해결 페이즈 진입 등급: %s / 저장된 단서 수집률: %.0f%%" % [
		selected_label,
		GameState.get_selected_resolution_rate()
	]


func _add_stability_action(parent: Control, label: String, stability_delta: int, fear_gain: int, message: String) -> void:
	var button := Button.new()
	button.text = label
	button.pressed.connect(func() -> void:
		_anomaly_stability = max(0, _anomaly_stability - stability_delta)
		_fear_level = clampi(_fear_level + fear_gain, 0, 100)
		_update_battle_view(message)
	)
	parent.add_child(button)
	_action_buttons.append(button)


func _add_prediction_action(parent: Control) -> void:
	var button := Button.new()
	button.text = "다음 행동 예측"
	button.pressed.connect(func() -> void:
		var prediction := GameState.roll_anomaly_prediction()
		if bool(prediction.get("successful", false)):
			_fear_level = max(0, _fear_level - 6)
			_update_battle_view("예측 성공 %.1f%%\n%s" % [
				float(prediction.get("rate", 0.0)),
				String(prediction.get("next_action", ""))
			])
		else:
			_fear_level = clampi(_fear_level + 6, 0, 100)
			_update_battle_view("예측 실패 %.1f%%\n괴이의 다음 움직임을 놓쳤습니다. 연속 예측 보정이 초기화됩니다." % float(prediction.get("rate", 0.0)))
	)
	parent.add_child(button)
	_action_buttons.append(button)


func _add_defense_action(parent: Control) -> void:
	var button := Button.new()
	button.text = "방어: 위험 억제"
	button.pressed.connect(func() -> void:
		_fear_level = max(0, _fear_level - 12)
		_update_battle_view("위험 억제 자세를 유지해 공포 상승을 줄였습니다.")
	)
	parent.add_child(button)
	_action_buttons.append(button)


func _add_support_action(parent: Control) -> void:
	var button := Button.new()
	button.text = "지원 요청: 기록국 보조"
	button.pressed.connect(func() -> void:
		_anomaly_stability = max(0, _anomaly_stability - 14)
		_fear_level = max(0, _fear_level - 6)
		_update_battle_view("기록국 지원팀이 임시 봉인지로 괴이의 핵을 더 안정화했습니다.")
	)
	parent.add_child(button)
	_action_buttons.append(button)


func _add_agent_recovery_support_actions(parent: Control) -> void:
	var title := Label.new()
	title.text = "편성 요원 자동 지원"
	title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	parent.add_child(title)

	var supports := GameState.get_selected_recovery_supports()
	if supports.is_empty():
		var empty_label := Label.new()
		empty_label.text = "선택된 요원이 없어 성향별 회수 지원이 없습니다."
		empty_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		parent.add_child(empty_label)
		return

	for support in supports:
		if typeof(support) != TYPE_DICTIONARY:
			continue

		var support_copy: Dictionary = support.duplicate(true)
		var support_id := String(support_copy.get("id", ""))
		var button := Button.new()
		button.text = "%s [%s]: %s" % [
			String(support_copy.get("agent_name", "")),
			String(support_copy.get("temperament_label", "")),
			String(support_copy.get("label", "지원"))
		]
		button.tooltip_text = String(support_copy.get("description", ""))
		button.disabled = GameState.has_used_agent_support(support_id)
		button.pressed.connect(func() -> void:
			_use_agent_recovery_support(support_copy, button)
		)
		parent.add_child(button)
		_agent_support_buttons.append(button)


func _use_agent_recovery_support(support: Dictionary, button: Button) -> void:
	var support_id := String(support.get("id", ""))
	if GameState.has_used_agent_support(support_id):
		_update_battle_view("이미 사용한 요원 지원입니다. 같은 지원은 중복 적용되지 않습니다.")
		return

	GameState.mark_agent_support_used(support_id)
	_anomaly_stability = clampi(
		_anomaly_stability + int(support.get("stability_delta", 0)),
		0,
		BASE_ANOMALY_STABILITY
	)
	_fear_level = clampi(
		_fear_level + int(support.get("fear_delta", 0)),
		0,
		100
	)
	_recovery_threshold = clampi(
		_recovery_threshold + int(support.get("threshold_delta", 0)),
		30,
		MAX_RECOVERY_THRESHOLD
	)
	button.disabled = true

	_update_battle_view("%s의 %s 지원 발동\n%s" % [
		String(support.get("agent_name", "")),
		String(support.get("role", "회수")),
		String(support.get("description", ""))
	])


func _update_battle_view(message: String) -> void:
	if _stability_bar != null:
		_stability_bar.value = _anomaly_stability
	if _fear_bar != null:
		_fear_bar.value = _fear_level
	if _threshold_label != null:
		_threshold_label.text = "회수 가능 조건: 괴이 안정도 %d 이하 / 현재 %d" % [
			_recovery_threshold,
			_anomaly_stability
		]
	if _prediction_label != null:
		var status := GameState.get_anomaly_status_summary()
		_prediction_label.text = "괴이 위험도 %d / 괴이 이해도 %d / 정신력 %d / 예측률 %.1f%% / 연속 예측 %d" % [
			int(status.get("anomaly_risk", 0)),
			int(status.get("anomaly_understanding", 0)),
			int(status.get("mental_stamina", 100)),
			float(status.get("prediction_rate", 0.0)),
			int(status.get("prediction_success_streak", 0))
		]
	if _recover_button != null:
		_recover_button.disabled = _recovery_completed or not _can_recover()

	var status_message := message
	if not _recovery_completed and _can_recover():
		status_message += "\n괴이의 핵이 회수 가능한 상태입니다."

	if _result_label != null:
		_result_label.text = status_message


func _can_recover() -> bool:
	return _anomaly_stability <= _recovery_threshold


func _recover_anomaly_core() -> void:
	if not _can_recover():
		_update_battle_view("아직 괴이의 핵이 충분히 안정화되지 않았습니다.")
		return

	_recovery_completed = true
	GameState.save_recovery_result(true, "core_recovered", _anomaly_stability)
	GameState.set_current_scene_path("res://scenes/result_scene.tscn")
	GameState.save_game()
	for button in _action_buttons:
		button.disabled = true
	for button in _agent_support_buttons:
		button.disabled = true
	_recover_button.disabled = true
	get_tree().change_scene_to_file("res://scenes/result_scene.tscn")


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
		GameState.set_current_scene_path(scene_path)
		GameState.save_game()
		get_tree().change_scene_to_file(scene_path)
	)
	parent.add_child(button)
