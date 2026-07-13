# 괴이 안정화/회수 페이즈의 단서 반영과 괴이 핵 회수를 관리한다.
extends Control

const SceneVisuals = preload("res://scripts/ui/scene_presentation.gd")
const AssetCatalog = preload("res://scripts/ui/ui_asset_catalog.gd")
const ThemeFactory = preload("res://scripts/ui/ui_theme_factory.gd")
const RuntimeEditor = preload("res://scripts/ui/runtime_ui_editor.gd")

const BASE_ANOMALY_STABILITY := 0
const BASE_RECOVERY_THRESHOLD := 70
const MAX_RECOVERY_THRESHOLD := 90
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
var _representative_agent_index := 0
var _target_agent_index := 0

var _stability_bar: ProgressBar
var _fear_bar: ProgressBar
var _threshold_label: Label
var _prediction_label: Label
var _auto_effect_label: Label
var _result_label: Label
var _recover_button: Button
var _representative_agent_label: Label
var _representative_agent_image: TextureRect
var _anomaly_panel: PanelContainer
var _anomaly_image: TextureRect
var _anomaly_stage_label: Label
var _action_panel: PanelContainer
var _runtime_editor: RuntimeUiEditor
var _current_pattern: Dictionary = {}
var _telegraph_label: Label
var _prediction_summary_label: Label
var _response_box: GridContainer
var _turn_auto_success_agents: Dictionary = {}
var _turn_locked := false


func _ready() -> void:
	if GameState.get_current_episode().is_empty():
		GameState.load_episode()

	GameState.set_current_scene_path("res://scenes/battle_scene.tscn")
	_active_effects = GameState.get_collected_battle_effects()
	_apply_collected_clue_effects()
	SceneVisuals.apply_background(self, "recovery")
	_build_scene_ui()
	_setup_runtime_editor()
	_begin_recovery_turn()


func _build_scene_ui() -> void:
	var shade := get_node_or_null("ArtLayer/Shade") as ColorRect
	if shade != null:
		shade.color = Color(0.08, 0.015, 0.025, 0.18)

	var top_panel := PanelContainer.new()
	top_panel.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	top_panel.offset_left = 12
	top_panel.offset_top = 10
	top_panel.offset_right = -12
	top_panel.offset_bottom = 64
	top_panel.add_theme_stylebox_override("panel", ThemeFactory.panel_style(Color("293943"), 0.76))
	add_child(top_panel)
	var status_row := HBoxContainer.new()
	status_row.add_theme_constant_override("separation", 10)
	top_panel.add_child(status_row)
	_representative_agent_label = _make_label("")
	_representative_agent_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	status_row.add_child(_representative_agent_label)
	var stability_title := _make_label("안정")
	stability_title.custom_minimum_size.x = 42
	status_row.add_child(stability_title)
	_stability_bar = _make_bar(100)
	_stability_bar.custom_minimum_size = Vector2(180, 22)
	status_row.add_child(_stability_bar)
	var risk_title := _make_label("위험")
	risk_title.custom_minimum_size.x = 42
	status_row.add_child(risk_title)
	_fear_bar = _make_bar(100)
	_fear_bar.custom_minimum_size = Vector2(140, 22)
	status_row.add_child(_fear_bar)

	_representative_agent_image = TextureRect.new()
	_representative_agent_image.set_anchors_and_offsets_preset(Control.PRESET_LEFT_WIDE)
	_representative_agent_image.anchor_right = 0.28
	_representative_agent_image.offset_left = 12
	_representative_agent_image.offset_top = 72
	_representative_agent_image.offset_right = -4
	_representative_agent_image.offset_bottom = -214
	_representative_agent_image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_representative_agent_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_representative_agent_image.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_representative_agent_image)

	_anomaly_panel = PanelContainer.new()
	_anomaly_panel.anchor_left = 0.24
	_anomaly_panel.anchor_top = 0.1
	_anomaly_panel.anchor_right = 0.78
	_anomaly_panel.anchor_bottom = 0.72
	_anomaly_panel.offset_left = 4
	_anomaly_panel.offset_top = 8
	_anomaly_panel.offset_right = -4
	_anomaly_panel.offset_bottom = -4
	_anomaly_panel.add_theme_stylebox_override("panel", ThemeFactory.panel_style(Color("3d2632"), 0.24))
	add_child(_anomaly_panel)
	var anomaly_box := VBoxContainer.new()
	anomaly_box.alignment = BoxContainer.ALIGNMENT_CENTER
	_anomaly_panel.add_child(anomaly_box)
	_anomaly_image = TextureRect.new()
	_anomaly_image.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_anomaly_image.custom_minimum_size = Vector2(0, 260)
	var initial_stage := SceneVisuals.apply_anomaly(_anomaly_image, GameState.get_anomaly_risk())
	anomaly_box.add_child(_anomaly_image)
	_anomaly_stage_label = _make_label("관측 위험 단계 %s" % initial_stage)
	_anomaly_stage_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	anomaly_box.add_child(_anomaly_stage_label)
	var phase_label := _make_label(_make_resolution_phase_text())
	phase_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	anomaly_box.add_child(phase_label)

	var clue_panel := PanelContainer.new()
	clue_panel.anchor_left = 0.78
	clue_panel.anchor_top = 0.1
	clue_panel.anchor_right = 1.0
	clue_panel.anchor_bottom = 0.72
	clue_panel.offset_left = 4
	clue_panel.offset_top = 8
	clue_panel.offset_right = -12
	clue_panel.offset_bottom = -4
	clue_panel.add_theme_stylebox_override("panel", ThemeFactory.panel_style(Color("293943"), 0.78))
	add_child(clue_panel)
	var clue_box := VBoxContainer.new()
	clue_box.add_theme_constant_override("separation", 8)
	clue_panel.add_child(clue_box)
	var clue_title := _make_label("확보 단서 / 회수 근거")
	clue_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	clue_box.add_child(clue_title)
	_auto_effect_label = _make_label(_make_clue_summary())
	_auto_effect_label.tooltip_text = _make_auto_effect_text()
	clue_box.add_child(_auto_effect_label)
	var detail_button := Button.new()
	detail_button.text = "상세 보기 ▼"
	clue_box.add_child(detail_button)
	var detail_scroll := ScrollContainer.new()
	detail_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	detail_scroll.visible = false
	clue_box.add_child(detail_scroll)
	var detail_box := VBoxContainer.new()
	detail_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	detail_scroll.add_child(detail_box)
	detail_box.add_child(_make_label(_make_auto_effect_text()))
	_add_agent_recovery_support_actions(detail_box)
	_add_navigation(detail_box)
	detail_button.pressed.connect(func() -> void:
		detail_scroll.visible = not detail_scroll.visible
		_auto_effect_label.visible = not detail_scroll.visible
		detail_button.text = "상세 닫기 ▲" if detail_scroll.visible else "상세 보기 ▼"
	)

	_action_panel = PanelContainer.new()
	_action_panel.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	_action_panel.offset_left = 12
	_action_panel.offset_top = -202
	_action_panel.offset_right = -12
	_action_panel.offset_bottom = -10
	_action_panel.add_theme_stylebox_override("panel", ThemeFactory.panel_style(Color("17242c"), 0.84))
	add_child(_action_panel)
	var action_box := VBoxContainer.new()
	action_box.add_theme_constant_override("separation", 8)
	_action_panel.add_child(action_box)
	_telegraph_label = _make_label("")
	action_box.add_child(_telegraph_label)
	_prediction_summary_label = _make_label("")
	action_box.add_child(_prediction_summary_label)
	_response_box = GridContainer.new()
	_response_box.columns = 2
	_response_box.add_theme_constant_override("h_separation", 8)
	_response_box.add_theme_constant_override("v_separation", 6)
	action_box.add_child(_response_box)
	var result_row := HBoxContainer.new()
	result_row.add_theme_constant_override("separation", 10)
	action_box.add_child(result_row)
	_result_label = _make_label("")
	_result_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	result_row.add_child(_result_label)
	_recover_button = Button.new()
	_recover_button.text = "강제 회수 실행"
	_recover_button.pressed.connect(_recover_anomaly_core)
	result_row.add_child(_recover_button)
	_threshold_label = _make_label("")
	_threshold_label.visible = false
	_action_panel.add_child(_threshold_label)
	_prediction_label = _make_label("")
	_prediction_label.visible = false
	_action_panel.add_child(_prediction_label)
	_refresh_representative_agent()


func _make_clue_summary() -> String:
	if _active_effects.is_empty():
		return "핵심 단서 없음\n부족 조건: 현장 규칙을 더 분석해야 합니다."
	var names: Array[String] = []
	for effect in _active_effects:
		if typeof(effect) == TYPE_DICTIONARY:
			names.append(String(effect.get("clue_title", "이름 없는 단서")))
	return "핵심 단서 %d개\n%s\n회수 기준: 안정도 %d 이상" % [
		_active_effects.size(),
		", ".join(names),
		_recovery_threshold
	]


func _build_ui() -> void:
	var background := ColorRect.new()
	background.color = Color(0.06, 0.02, 0.035, 0.2)
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
	root.custom_minimum_size = Vector2(960, 0)
	root.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	root.add_theme_constant_override("separation", 10)
	scroll.add_child(root)

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

	var top_row := HBoxContainer.new()
	top_row.add_theme_constant_override("separation", 12)
	top_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	root.add_child(top_row)

	var agent_content := _add_section(top_row, "아군 요원", "현장 지휘와 회수 담당을 정하고, 팀 지원을 확인합니다.")
	var agent_panel := agent_content.get_parent() as Control
	agent_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	agent_panel.size_flags_stretch_ratio = 1.0
	_representative_agent_label = _make_label("")
	agent_content.add_child(_representative_agent_label)
	_add_agent_recovery_support_actions(agent_content)

	var effect_content := _add_section(top_row, "해결 단서 / 회수 근거", "수집한 단서와 미니게임 결과가 회수 조건에 어떻게 반영되는지 확인합니다.")
	var effect_panel := effect_content.get_parent() as Control
	effect_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	effect_panel.size_flags_stretch_ratio = 1.0

	_auto_effect_label = Label.new()
	_auto_effect_label.text = _make_auto_effect_text()
	_auto_effect_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	effect_content.add_child(_auto_effect_label)

	var anomaly_content := _add_section(root, "중앙 관측: 인간형 괴이", "마법이 아닌 반복, 반사 오류와 공간 왜곡으로 나타나는 현상입니다.")
	_anomaly_panel = anomaly_content.get_parent() as PanelContainer
	_anomaly_image = TextureRect.new()
	_anomaly_image.custom_minimum_size = Vector2(0, 300)
	var initial_stage := SceneVisuals.apply_anomaly(_anomaly_image, GameState.get_anomaly_risk())
	anomaly_content.add_child(_anomaly_image)
	_anomaly_stage_label = _make_label("관측 위험 단계 %s · 인간형 유지" % initial_stage)
	_anomaly_stage_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	anomaly_content.add_child(_anomaly_stage_label)

	var status := _add_section(root, "안정화 상태", "괴이 안정도와 현장 위험을 보며 회수 가능선을 맞춥니다.")

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

	var action_content := _add_section(root, "회수 행동 선택", "대표 요원과 팀이 현장 지휘에 따라 안정화 절차를 선택합니다.")
	_action_panel = action_content.get_parent() as PanelContainer
	var actions := GridContainer.new()
	actions.columns = 2
	actions.add_theme_constant_override("v_separation", 6)
	action_content.add_child(actions)

	_add_prediction_action(actions)
	_add_stability_action(actions, "안정화 시도: 기록 스캔", 18, 6, "단말기로 괴이의 반복 규칙을 스캔했습니다.")
	_add_stability_action(actions, "안정화 시도: 임시 봉인지", 24, 9, "봉인지가 괴이의 핵 주변을 짧게 고정했습니다.")
	_add_defense_action(actions)
	_add_representative_switch_action(actions)
	_add_support_action(actions)

	var recovery_content := _add_section(root, "강제 회수", "조건을 만족하면 괴이 핵을 회수하고 사건 보고서로 이동합니다.")
	_recover_button = Button.new()
	_recover_button.text = "강제 회수 실행"
	_recover_button.pressed.connect(_recover_anomaly_core)
	recovery_content.add_child(_recover_button)

	_result_label = Label.new()
	_result_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	recovery_content.add_child(_result_label)
	_refresh_representative_agent()


func _setup_runtime_editor() -> void:
	_runtime_editor = RuntimeEditor.new()
	add_child(_runtime_editor)
	_runtime_editor.setup("recovery", self)
	_runtime_editor.register_element("anomaly", _anomaly_panel, {
		"minimum_size": Vector2(420, 260),
		"free_layout": true,
		"image_target": _anomaly_image,
		"style_target": _anomaly_panel
	})
	_runtime_editor.register_element("actions", _action_panel, {"minimum_size": Vector2(480, 180), "free_layout": true})
	_runtime_editor.risk_preview_changed.connect(_preview_risk_stage)


func _preview_risk_stage(stage: String) -> void:
	var preview_risk := int({"B": 20, "C": 50, "D": 85}.get(stage, GameState.get_anomaly_risk()))
	var applied_stage := SceneVisuals.apply_anomaly(_anomaly_image, preview_risk)
	_anomaly_stage_label.text = "관측 위험 단계 %s · 미리보기" % applied_stage


func _apply_collected_clue_effects() -> void:
	_total_clue_effect_value = 0
	for effect in _active_effects:
		if typeof(effect) == TYPE_DICTIONARY:
			_total_clue_effect_value += int(effect.get("effect_value", 0))

	var threshold_bonus := int(floor(float(_total_clue_effect_value) * CLUE_THRESHOLD_FACTOR))
	_recovery_threshold = clampi(
		BASE_RECOVERY_THRESHOLD - threshold_bonus,
		50,
		MAX_RECOVERY_THRESHOLD
	)

	var start_weaken_amount := int(floor(float(_total_clue_effect_value) * CLUE_START_WEAKEN_FACTOR))
	_anomaly_stability = clampi(
		GameState.get_anomaly_stability() + start_weaken_amount,
		0,
		100
	)

	_apply_minigame_recovery_effects()

	var risk_penalty := int(floor(float(GameState.get_anomaly_risk()) / 25.0))
	_anomaly_stability = clampi(
		_anomaly_stability - risk_penalty,
		0,
		100
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
			_anomaly_stability - int(minigame.get("%s_recovery_stability_delta" % prefix, 0)),
			0,
			100
		)
		var outcome := "성공" if prefix == "success" else "실패"
		_minigame_recovery_messages.append("%s %s: %s" % [
			String(minigame.get("title", minigame_id)),
			outcome,
			String(result.get("result_text", "회수 페이즈에 결과가 반영되었습니다."))
		])


func _make_start_message() -> String:
	var minigame_text := _make_minigame_recovery_text()
	var investigation_text := _make_investigation_status_text()
	if _active_effects.is_empty():
		return "수집한 단서가 없어 회수 조건 보정 없이 회수 페이즈를 시작합니다.%s%s" % [minigame_text, investigation_text]

	return "수집한 단서 %d개가 회수 조건에 반영되었습니다. 현재 회수 가능 기준은 괴이 안정도 %d 이상입니다.%s%s" % [
		_active_effects.size(),
		_recovery_threshold,
		minigame_text,
		investigation_text
	]


func _make_auto_effect_text() -> String:
	if _active_effects.is_empty():
		return "회수 자동 반영 단서: 없음\n힌트는 단서가 아니므로 회수 조건에는 직접 포함되지 않습니다."

	var text := "회수 자동 반영 단서\n"
	for effect in _active_effects:
		if typeof(effect) != TYPE_DICTIONARY:
			continue

		text += "- %s: %s (효과값 %d)\n" % [
			effect.get("clue_title", "이름 없는 단서"),
			effect.get("description", ""),
			int(effect.get("effect_value", 0))
		]

	text += "힌트는 단서가 아니므로 회수 조건에는 직접 포함되지 않습니다."
	var minigame_text := _make_minigame_recovery_text().strip_edges()
	if not minigame_text.is_empty():
		text += "\n\n미니게임 영향\n%s" % minigame_text
	return text.strip_edges()


func _make_minigame_recovery_text() -> String:
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
		content.add_child(_make_label(description_text))

	return content


func _make_bar(max_value: int) -> ProgressBar:
	var bar := ProgressBar.new()
	bar.min_value = 0
	bar.max_value = max_value
	bar.value = max_value
	return bar


func _make_resolution_phase_text() -> String:
	var selected_label: String = GameState.get_selected_resolution_label()
	if selected_label.is_empty():
		return "회수 페이즈: 직접 진입하지 않은 안정화 테스트입니다."

	return "회수/안정화 진입 등급: %s / 저장된 단서 수집률: %.0f%%" % [
		selected_label,
		GameState.get_selected_resolution_rate()
	]


func _begin_recovery_turn() -> void:
	_turn_locked = false
	_turn_auto_success_agents.clear()
	_current_pattern = GameState.select_next_recovery_pattern()
	_clear_children(_response_box)
	if _current_pattern.is_empty():
		_telegraph_label.text = "전조 데이터를 찾지 못했습니다."
		return
	var auto_lines := _run_auto_window("analysis")
	var prediction := GameState.roll_anomaly_prediction(_current_pattern)
	_telegraph_label.text = "괴이의 전조\n%s" % String(_current_pattern.get("telegraph", "현장이 불규칙하게 흔들린다."))
	if bool(prediction.get("successful", false)):
		_prediction_summary_label.text = "자동 예측 성공 %.0f%%\n%s" % [float(prediction.get("rate", 0.0)), String(prediction.get("next_action", ""))]
	else:
		_prediction_summary_label.text = "자동 예측 실패 %.0f%%\n전조와 확보한 단서만으로 대응해야 합니다." % float(prediction.get("rate", 0.0))
	if not auto_lines.is_empty():
		_prediction_summary_label.text += "\n%s" % "\n".join(auto_lines)
	if GameState.has_equipped_item("gear_inverse_listener"):
		for clue_id in _current_pattern.get("related_clue_ids", []):
			if GameState.has_collected_clue(String(clue_id)):
				_prediction_summary_label.text += "\n역위상 청음기: 확보 단서 %s가 이 전조와 연결됩니다." % String(clue_id)
				break
	for loaded_id in GameState.get_consumable_loadout():
		if String(loaded_id) in ["consumable_mental_incense", "consumable_first_aid"]:
			var consumable_id := String(loaded_id)
			var use_button := Button.new()
			use_button.text = "사용: %s" % String(GameState.get_market_item(consumable_id).get("name", consumable_id))
			use_button.pressed.connect(_use_recovery_consumable.bind(consumable_id, use_button))
			_response_box.add_child(use_button)
	for response in _current_pattern.get("responses", []):
		if typeof(response) != TYPE_DICTIONARY:
			continue
		var response_copy: Dictionary = response.duplicate(true)
		var ability := String(response_copy.get("ability", "analysis"))
		var agent := GameState.find_best_agent_for_ability(ability)
		var button := Button.new()
		button.text = "%s\n%s / %s %d" % [
			String(response_copy.get("label", "상황에 대응한다")),
			String(agent.get("name", "팀")),
			GameState.ABILITY_LABELS.get(ability, ability),
			GameState.get_agent_ability(String(agent.get("id", "")), ability)
		]
		button.pressed.connect(func() -> void: _select_pattern_response(response_copy))
		_response_box.add_child(button)
	_update_battle_view(_make_start_message())


func _select_pattern_response(response: Dictionary) -> void:
	if _turn_locked:
		return
	_turn_locked = true
	for child in _response_box.get_children():
		if child is Button:
			child.disabled = true
	var lines: Array[String] = []
	lines.append_array(_run_auto_window("suppression"))
	var response_id := String(response.get("id", ""))
	var correct := response_id == String(_current_pattern.get("correct_response_id", ""))
	if correct:
		var gain := int(response.get("stability_gain", 15))
		if int(GameState.get_consumable_loadout().get("consumable_temporary_seal", 0)) > 0 and GameState.use_loaded_consumable("consumable_temporary_seal"):
			GameState.consume_active_consumable_effect("consumable_temporary_seal")
			gain += 10
			lines.append("임시 봉인지 자동 사용: 안정도 추가 +10")
		_anomaly_stability = GameState.change_anomaly_stability(gain)
		lines.append("대응 성공: 괴이 규칙을 끊어 안정도 +%d" % gain)
	else:
		lines.append_array(_run_auto_window("protection"))
		var target := _get_representative_agent()
		var target_id := String(target.get("id", ""))
		var damage := 10 + int(GameState.get_anomaly_risk() / 20)
		var pin_key := "market:first_wrong:%s" % GameState.get_current_episode_id()
		if GameState.has_equipped_item("gear_sealing_pin") and not GameState.has_used_equipment_effect(pin_key):
			damage = maxi(0, damage - 10)
			GameState.mark_equipment_effect_used(pin_key)
			lines.append("봉인선 고정핀: 사건 최초 오대응 피해 10 감소")
		if int(GameState.get_consumable_loadout().get("consumable_shielding_cloth", 0)) > 0 and GameState.use_loaded_consumable("consumable_shielding_cloth"):
			GameState.consume_active_consumable_effect("consumable_shielding_cloth")
			damage = maxi(0, damage - 12)
			lines.append("잔향 차폐포 자동 사용: 피해 12 흡수")
		var remaining := GameState.consume_protection(target_id, damage)
		if remaining > 0:
			GameState.change_agent_mental(target_id, -remaining)
		lines.append("오대응: %s" % String(_current_pattern.get("failure_reason", "패턴과 맞지 않는 대응이었습니다.")))
		lines.append("괴이 반응: %s 정신력 -%d" % [String(target.get("name", "대표 요원")), remaining])
	var reason := "규칙에 맞는 대응을 확인했다." if correct else String(_current_pattern.get("failure_reason", "오대응 원인을 기록했다."))
	GameState.record_recovery_pattern_outcome(String(_current_pattern.get("id", "")), response_id, correct, reason)
	lines.append_array(_run_auto_window("treatment"))
	lines.append_array(_run_auto_window("rapport"))
	GameState.save_game()
	var next_button := Button.new()
	next_button.text = "다음 전조 관측"
	next_button.pressed.connect(_begin_recovery_turn)
	_response_box.add_child(next_button)
	_update_battle_view("\n".join(lines))


func _use_recovery_consumable(item_id: String, button: Button) -> void:
	if not GameState.use_loaded_consumable(item_id):
		button.disabled = true
		return
	var representative := _get_representative_agent()
	var agent_id := String(representative.get("id", ""))
	if item_id == "consumable_mental_incense":
		GameState.change_agent_mental(agent_id, 25)
		_update_battle_view("정신 안정 향 사용: %s 정신력 +25" % String(representative.get("name", "대표 요원")))
	elif item_id == "consumable_first_aid":
		GameState.change_agent_hp(agent_id, 25)
		_update_battle_view("응급 지혈부 사용: %s 체력 +25" % String(representative.get("name", "대표 요원")))
	GameState.consume_active_consumable_effect(item_id)
	GameState.save_game()
	button.disabled = int(GameState.get_consumable_loadout().get(item_id, 0)) <= 0


func _run_auto_window(ability_key: String) -> Array[String]:
	var lines: Array[String] = []
	for agent in GameState.get_selected_agents():
		if typeof(agent) != TYPE_DICTIONARY:
			continue
		var agent_id := String(agent.get("id", ""))
		if _turn_auto_success_agents.has(agent_id):
			continue
		var roll := GameState.roll_agent_auto_action(agent_id, ability_key)
		if not bool(roll.get("triggered", false)):
			continue
		_turn_auto_success_agents[agent_id] = true
		var ability := GameState.get_agent_ability(agent_id, ability_key)
		match ability_key:
			"analysis":
				GameState.change_anomaly_understanding(2 + ability)
				lines.append("%s의 분석 보조: 전조 이해도 +%d" % [String(agent.get("name", "요원")), 2 + ability])
			"suppression":
				var gain := 3 + ability
				_anomaly_stability = GameState.change_anomaly_stability(gain)
				lines.append("%s의 제압 보조: 규칙 억제 안정도 +%d" % [String(agent.get("name", "요원")), gain])
			"protection":
				var amount := 5 + ability * 3
				GameState.activate_protection(agent_id, amount)
				lines.append("%s의 방호 보조: 피해 흡수 %d" % [String(agent.get("name", "요원")), amount])
			"treatment":
				var heal := 4 + ability * 2
				GameState.change_agent_hp(agent_id, heal)
				lines.append("%s의 치료 보조: 체력 +%d" % [String(agent.get("name", "요원")), heal])
			"rapport":
				var restore := 4 + ability * 2
				GameState.change_agent_mental(agent_id, restore)
				_anomaly_stability = GameState.change_anomaly_stability(2 + ability)
				lines.append("%s의 교감 보조: 정신력 +%d, 안정도 +%d" % [String(agent.get("name", "요원")), restore, 2 + ability])
	return lines


func _clear_children(parent: Node) -> void:
	if parent == null:
		return
	for child in parent.get_children():
		child.queue_free()


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


func _add_ability_action(parent: Control, ability_key: String, display_label: String) -> void:
	var button := Button.new()
	button.text = display_label
	button.pressed.connect(func() -> void:
		var agents := GameState.get_selected_agents()
		if agents.is_empty():
			_update_battle_view("선택된 요원이 없습니다.")
			return

		var rep := _get_representative_agent()
		if rep.is_empty():
			_update_battle_view("대표 요원이 설정되지 않았습니다.")
			return

		var rep_id := String(rep.get("id", ""))
		if not GameState.is_agent_active(rep_id):
			_update_battle_view("%s는 현재 행동할 수 없는 상태입니다." % String(rep.get("name", "")))
			return

		var result := GameState.resolve_recovery_action(ability_key, rep_id)
		if result.has("error"):
			_update_battle_view(String(result.get("error", "")))
			return

		var effect := int(result.get("effect_value", 0))
		var msg := "%s: %s → %s (공식: %s, 효과값 %d)" % [
			String(result.get("agent_name", "")),
			String(result.get("ability_label", "")),
			String(result.get("description", "")),
			String(result.get("formula", "")),
			effect
		]

		match ability_key:
			"suppression":
				var fear_gain: int = maxi(1, effect / 3)
				if GameState.has_protection(rep_id):
					GameState.consume_protection(rep_id, fear_gain)
					msg += "\n[방호 소모] %s의 방호가 억제 부담을 흡수했습니다." % String(rep.get("name", ""))
				else:
					_fear_level = clampi(_fear_level + fear_gain, 0, 100)
					msg += "\n위험도 +%d" % fear_gain
				_anomaly_stability = max(0, _anomaly_stability - effect)
				msg += "\n괴이 안정도 -%d" % effect
			"analysis":
				_fear_level = max(0, _fear_level - effect)
				msg += "\n현장 위험/공포도 -%d" % effect
			"protection":
				_fear_level = max(0, _fear_level - (effect / 2))
				GameState.activate_protection(rep_id, effect)
				msg += "\n위험도 -%d, %s에게 방호 %d 부여" % [effect / 2, String(rep.get("name", "")), effect]
			"treatment":
				var target := _get_target_agent()
				if target.is_empty():
					_update_battle_view("치료할 대상 요원이 없습니다.")
					return
				var target_id := String(target.get("id", ""))
				GameState.change_agent_hp(target_id, effect)
				msg += "\n%s 체력 +%d (현재 %d/%d)" % [
					String(target.get("name", "")),
					effect,
					GameState.get_agent_current_hp(target_id),
					GameState.get_agent_max_hp(target_id)
				]
			"rapport":
				var target := _get_target_agent()
				if target.is_empty():
					_update_battle_view("교감할 대상 요원이 없습니다.")
					return
				var target_id := String(target.get("id", ""))
				GameState.change_agent_mental(target_id, effect)
				msg += "\n%s 정신력 +%d (현재 %d/%d)" % [
					String(target.get("name", "")),
					effect,
					GameState.get_agent_current_mental(target_id),
					GameState.get_agent_max_mental(target_id)
				]

		msg += _apply_anomaly_reaction(rep_id, ability_key)
		_update_battle_view(msg)
	)
	parent.add_child(button)
	_action_buttons.append(button)


func _add_target_switch_action(parent: Control) -> void:
	var button := Button.new()
	button.text = "대상 교체"
	button.pressed.connect(func() -> void:
		var agents := GameState.get_selected_agents()
		if agents.size() < 2:
			_update_battle_view("대상 교체: 전환할 다른 요원이 없습니다.")
			return
		_target_agent_index = (_target_agent_index + 1) % agents.size()
		var target := _get_target_agent()
		_update_battle_view("치료/교감 대상 전환: %s" % String(target.get("name", "없음")))
	)
	parent.add_child(button)
	_action_buttons.append(button)


func _apply_anomaly_reaction(agent_id: String, ability_key: String) -> String:
	var risk := GameState.get_anomaly_risk()
	var damage := 8 if risk < 40 else (12 if risk < 70 else 16)
	var remaining := GameState.consume_protection(agent_id, damage)
	var absorbed := damage - remaining
	var state_label := "B" if risk < 40 else ("C" if risk < 70 else "D")
	var text := "\n\n괴이 반응 [%s단계]: " % state_label
	if absorbed > 0:
		text += "방호가 %d 피해를 흡수했습니다. " % absorbed
	if remaining <= 0:
		return text + "추가 피해 없음."

	if ability_key in ["analysis", "rapport"]:
		GameState.change_agent_mental(agent_id, -remaining)
		return text + "정신력 -%d" % remaining
	GameState.change_agent_hp(agent_id, -remaining)
	return text + "체력 -%d" % remaining


func _add_prediction_action(parent: Control) -> void:
	var button := Button.new()
	button.text = "괴이 행동 예측"
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
	button.text = "보호 조치"
	button.pressed.connect(func() -> void:
		_fear_level = max(0, _fear_level - 12)
		_update_battle_view("위험 억제 자세를 유지해 공포 상승을 줄였습니다.")
	)
	parent.add_child(button)
	_action_buttons.append(button)


func _add_support_action(parent: Control) -> void:
	var button := Button.new()
	button.text = "기록국 보호 지원"
	button.pressed.connect(func() -> void:
		_anomaly_stability = max(0, _anomaly_stability - 14)
		_fear_level = max(0, _fear_level - 6)
		_update_battle_view("기록국 지원팀이 임시 봉인지로 괴이의 핵을 더 안정화했습니다.")
	)
	parent.add_child(button)
	_action_buttons.append(button)


func _add_representative_switch_action(parent: Control) -> void:
	var button := Button.new()
	button.text = "대표 요원 교체"
	button.pressed.connect(func() -> void:
		var agents := GameState.get_selected_agents()
		if agents.size() < 2:
			_update_battle_view("대표 요원 교체: 전환할 다른 요원이 없습니다.")
			return
		_representative_agent_index = (_representative_agent_index + 1) % agents.size()
		_refresh_representative_agent()
		_update_battle_view("현장 지휘 / 회수 담당을 전환했습니다. 팀 지원과 회수 조건은 유지됩니다.")
	)
	parent.add_child(button)
	_action_buttons.append(button)


func _add_agent_recovery_support_actions(parent: Control) -> void:
	var title := Label.new()
	title.text = "요원 지원"
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
	var stability_gain := -int(support.get("stability_delta", 0))
	_anomaly_stability = GameState.change_anomaly_stability(stability_gain)
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
	_refresh_representative_agent()
	if _stability_bar != null:
		_stability_bar.value = _anomaly_stability
	if _fear_bar != null:
		_fear_bar.value = _fear_level
	if _threshold_label != null:
		_threshold_label.text = "회수 가능 조건: 괴이 안정도 %d 이상 / 현재 %d" % [
			_recovery_threshold,
			_anomaly_stability
		]
	if _prediction_label != null:
		var status := GameState.get_anomaly_status_summary()
		_prediction_label.text = "괴이 위험도 %d / 괴이 이해도 %d / 정신력 %d / 예측률 %.1f%% / 성공 %d·실패 %d" % [
			int(status.get("anomaly_risk", 0)),
			int(status.get("anomaly_understanding", 0)),
			int(status.get("mental_stamina", 100)),
			float(status.get("prediction_rate", 0.0)),
			int(status.get("prediction_success_streak", 0)),
			int(status.get("prediction_failure_streak", 0))
		]
	if _recover_button != null:
		_recover_button.disabled = _recovery_completed or not _can_recover()

	var status_message := message
	if not _recovery_completed and _can_recover():
		status_message += "\n괴이의 핵이 회수 가능한 상태입니다."

	if _result_label != null:
		_result_label.text = status_message
		if GameState.are_all_agents_inactive():
			_result_label.text += "\n\n모든 요원이 행동 불능 상태입니다. 조사 화면으로 돌아가 재정비합니다."
			call_deferred("_return_to_investigation")


func _refresh_representative_agent() -> void:
	if _representative_agent_label == null:
		return

	var agents := GameState.get_selected_agents()
	if agents.is_empty():
		_representative_agent_label.text = "대표 요원: 미지정\n팀 상태: 요원 편성이 필요합니다."
		return

	_representative_agent_index = posmod(_representative_agent_index, agents.size())
	var representative: Dictionary = agents[_representative_agent_index]
	if _representative_agent_image != null:
		var catalog := AssetCatalog.new()
		_representative_agent_image.texture = catalog.get_agent_expression(String(representative.get("id", "")), 1)
		_representative_agent_image.tooltip_text = "%s [%s]" % [
			String(representative.get("name", "요원")),
			String(representative.get("temperament_label", representative.get("temperament", "")))
		]
	var rep_id := String(representative.get("id", ""))
	var hp_info := ""
	if not rep_id.is_empty():
		hp_info = " · 체력 %d/%d · 정신 %d/%d%s" % [
			GameState.get_agent_current_hp(rep_id),
			GameState.get_agent_max_hp(rep_id),
			GameState.get_agent_current_mental(rep_id),
			GameState.get_agent_max_mental(rep_id),
			" [방호]" if GameState.has_protection(rep_id) else ""
		]
	_representative_agent_label.text = "대표 요원: %s [%s]%s\n팀: %s" % [
		String(representative.get("name", representative.get("id", "요원"))),
		String(representative.get("temperament_label", representative.get("temperament", ""))),
		hp_info,
		GameState.get_selected_agent_summary()
	]


func _get_representative_agent() -> Dictionary:
	var agents := GameState.get_selected_agents()
	if agents.is_empty():
		return {}
	_representative_agent_index = posmod(_representative_agent_index, agents.size())
	var agent: Variant = agents[_representative_agent_index]
	if typeof(agent) == TYPE_DICTIONARY:
		return agent
	return {}


func _get_target_agent() -> Dictionary:
	var agents := GameState.get_selected_agents()
	if agents.is_empty():
		return {}
	_target_agent_index = posmod(_target_agent_index, agents.size())
	var agent: Variant = agents[_target_agent_index]
	if typeof(agent) == TYPE_DICTIONARY:
		return agent
	return {}


func _can_recover() -> bool:
	return _anomaly_stability >= _recovery_threshold


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


func _return_to_investigation() -> void:
	GameState.set_current_scene_path("res://scenes/investigation_scene.tscn")
	GameState.save_game()
	get_tree().change_scene_to_file("res://scenes/investigation_scene.tscn")


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
