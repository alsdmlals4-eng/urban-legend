# 조사 씬의 JSON 기반 조사 포인트와 조건부 결과 처리를 관리한다.
extends Control

const FALLBACK_INVESTIGATION_POINTS: Array[Dictionary] = [
	{
		"id": "fallback_phone",
		"label": "피해자의 휴대폰",
		"clue_id": "clue_last_message",
		"result_text": "피해자가 보낸 마지막 문자는 도착지가 아니라 시간을 가리킵니다.",
		"add_flags": ["inspected_phone"]
	}
]

var _result_label: Label
var _hint_label: Label
var _hint_list: VBoxContainer
var _progress_label: Label
var _progress_bar: ProgressBar
var _resolution_label: Label
var _case_state_label: Label
var _preparation_modifier_label: Label
var _clue_list: VBoxContainer
var _resolution_attempt_button: Button
var _resolution_confirm_panel: PanelContainer
var _resolution_confirm_label: Label
var _resolution_warning_label: Label
var _method_panel: PanelContainer
var _method_title_label: Label
var _method_button_box: VBoxContainer
var _method_result_label: Label


func _ready() -> void:
	if GameState.get_current_episode().is_empty():
		GameState.load_episode()

	GameState.set_current_scene_path("res://scenes/investigation_scene.tscn")
	_build_ui()
	_refresh_case_status()


func _build_ui() -> void:
	var background := ColorRect.new()
	background.color = Color(0.07, 0.08, 0.1, 1.0)
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
	_add_title(root)

	var scene_panel := PanelContainer.new()
	scene_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_child(scene_panel)

	var scene_scroll := ScrollContainer.new()
	scene_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scene_panel.add_child(scene_scroll)

	var scene_layout := VBoxContainer.new()
	scene_layout.add_theme_constant_override("separation", 10)
	scene_layout.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scene_scroll.add_child(scene_layout)

	var location := Label.new()
	location.text = "배경 placeholder: %s" % GameState.get_current_episode_title()
	location.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	location.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	scene_layout.add_child(location)

	var columns := HBoxContainer.new()
	columns.add_theme_constant_override("separation", 12)
	columns.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	columns.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scene_layout.add_child(columns)

	var left_column := VBoxContainer.new()
	left_column.add_theme_constant_override("separation", 10)
	left_column.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	columns.add_child(left_column)

	var right_column := VBoxContainer.new()
	right_column.add_theme_constant_override("separation", 10)
	right_column.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	columns.add_child(right_column)

	var progress_content := _add_section(left_column, "사건 상태", "단서 수집률, 현장 상태, 준비 보정을 먼저 확인합니다.")

	_progress_label = Label.new()
	_progress_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	progress_content.add_child(_progress_label)

	_progress_bar = ProgressBar.new()
	_progress_bar.min_value = 0
	_progress_bar.max_value = 100
	progress_content.add_child(_progress_bar)

	_resolution_label = Label.new()
	_resolution_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	progress_content.add_child(_resolution_label)

	_case_state_label = Label.new()
	_case_state_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	progress_content.add_child(_case_state_label)

	_preparation_modifier_label = Label.new()
	_preparation_modifier_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	progress_content.add_child(_preparation_modifier_label)

	var points_content := _add_section(left_column, "조사 포인트", "포인트를 클릭하거나 조사 방법을 선택해 단서와 힌트를 갱신합니다.")
	var points := GridContainer.new()
	points.columns = 1
	points.add_theme_constant_override("v_separation", 8)
	points_content.add_child(points)

	for point in _get_investigation_points():
		if typeof(point) == TYPE_DICTIONARY:
			_add_investigation_point(points, point)

	_add_method_panel(left_column)

	var result_content := _add_section(right_column, "결과 로그", "가장 최근 조사 결과와 이번 조사에서 얻은 정보를 요약합니다.")
	_result_label = Label.new()
	_result_label.text = "조사 포인트를 선택하면 JSON 결과가 표시됩니다."
	_result_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	result_content.add_child(_result_label)

	_hint_label = Label.new()
	_hint_label.text = "이번 조사 힌트: 아직 새 힌트가 없습니다."
	_hint_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	result_content.add_child(_hint_label)

	var clue_content := _add_section(right_column, "단서 추적", "수집/미수집 상태와 이번 조사로 얻은 새 단서를 구분합니다.")
	_clue_list = VBoxContainer.new()
	_clue_list.add_theme_constant_override("separation", 4)
	clue_content.add_child(_clue_list)

	var hint_content := _add_section(right_column, "힌트 추적", "힌트는 단서 수집률에 포함되지 않는 방향 안내입니다.")
	_hint_list = VBoxContainer.new()
	_hint_list.add_theme_constant_override("separation", 4)
	hint_content.add_child(_hint_list)

	var recovery_content := _add_section(right_column, "회수 / 안정화 안내", "단서가 충분하면 괴이 핵 안정화와 회수 페이즈로 넘어갑니다.")
	_resolution_attempt_button = Button.new()
	_resolution_attempt_button.text = "회수/안정화 시도"
	_resolution_attempt_button.pressed.connect(_show_resolution_confirm_panel)
	recovery_content.add_child(_resolution_attempt_button)
	_add_resolution_confirm_panel(recovery_content)

	var portrait := PanelContainer.new()
	right_column.add_child(portrait)

	var portrait_label := Label.new()
	portrait_label.text = "작은 초상화 영역: 기록국 단말기 / 편성 요원 통신"
	portrait_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	portrait_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	portrait.add_child(portrait_label)


func _add_title(parent: Control) -> void:
	var title := Label.new()
	title.text = "조사 씬"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	parent.add_child(title)


func _add_section(parent: Control, title_text: String, description_text: String = "") -> VBoxContainer:
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(panel)

	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 8)
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
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


func _add_investigation_point(parent: Control, point: Dictionary) -> void:
	var button := Button.new()
	var is_unlocked := _is_point_unlocked(point)
	var label := String(point.get("label", "조사 포인트"))
	button.text = label if is_unlocked else "[잠김] %s" % label
	button.pressed.connect(func() -> void:
		_inspect_point(point)
	)
	parent.add_child(button)


func _inspect_point(point: Dictionary) -> void:
	if not _is_point_unlocked(point):
		_result_label.text = "다음 행동: 조건을 만족한 뒤 다시 조사\n잠김 이유: %s" % String(point.get("locked_text", "아직 확인할 근거가 부족합니다."))
		_hint_label.text = "이번 조사 힌트: 조건을 만족하면 이 조사 포인트를 다시 확인할 수 있습니다."
		return

	if _has_method_options(point):
		_show_method_options(point)
		return

	_hide_method_panel()
	var clue_id := String(point.get("clue_id", ""))
	var was_collected := GameState.has_collected_clue(clue_id) if not clue_id.is_empty() else false
	GameState.apply_story_effects(point)
	var collected_now := false
	if not clue_id.is_empty():
		collected_now = GameState.has_collected_clue(clue_id) and not was_collected

	_result_label.text = _make_point_result_text(point, clue_id, was_collected, collected_now)
	_hint_label.text = _make_point_hint_text(point)
	_refresh_case_status()

	var next_scene_path := String(point.get("next_scene_path", ""))
	if not next_scene_path.is_empty():
		GameState.set_current_scene_path(next_scene_path)
		GameState.save_game()
		get_tree().change_scene_to_file(next_scene_path)


func _make_point_result_text(point: Dictionary, clue_id: String, was_collected: bool, collected_now: bool) -> String:
	var result_text := String(point.get("result_text", "조사 결과가 기록되었습니다."))
	if clue_id.is_empty():
		return "결과: %s\n새 정보: 연결된 단서 없음\n다음 행동: 다른 조사 포인트나 회수/안정화 조건을 확인" % result_text

	var clue := _find_clue(clue_id)
	if clue.is_empty():
		return "결과: %s\n새 정보: 연결된 단서 데이터를 찾지 못했습니다. clue_id: %s\n다음 행동: 다른 조사 포인트 확인" % [result_text, clue_id]

	if collected_now:
		return "결과: %s\n새 정보: 새 단서 획득 - %s\n%s\n다음 행동: 단서 추적을 확인하고 다음 조사 포인트 선택" % [
			result_text,
			clue.get("title", ""),
			clue.get("description", "")
		]

	if was_collected:
		return "결과: %s\n새 정보: 이미 확인한 단서 - %s\n다음 행동: 남은 미수집 단서 또는 회수/안정화 조건 확인" % [
			result_text,
			clue.get("title", "")
		]

	return "결과: %s\n새 정보: 단서 상태 변화 없음\n다음 행동: 다른 조사 포인트 확인" % result_text


func _make_point_hint_text(point: Dictionary) -> String:
	var hint_texts := GameState.get_hint_texts_by_ids(point.get("show_hint_ids", []))
	var lines: Array = []
	if not hint_texts.is_empty():
		lines.append("이번 조사 힌트\n- %s" % "\n- ".join(hint_texts))
	for support_text in GameState.get_investigation_point_support_text(point):
		lines.append(String(support_text))
	if lines.is_empty():
		return "이번 조사 힌트: 새로 기록된 힌트가 없습니다."
	return "\n\n".join(lines)


func _add_method_panel(parent: Control) -> void:
	_method_panel = PanelContainer.new()
	_method_panel.visible = false
	parent.add_child(_method_panel)

	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 8)
	_method_panel.add_child(content)

	_method_title_label = Label.new()
	_method_title_label.text = "조사 방법 선택"
	_method_title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_method_title_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(_method_title_label)

	_method_button_box = VBoxContainer.new()
	_method_button_box.add_theme_constant_override("separation", 6)
	content.add_child(_method_button_box)

	_method_result_label = Label.new()
	_method_result_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(_method_result_label)


func _show_method_options(point: Dictionary) -> void:
	if _method_panel == null:
		return

	_method_panel.visible = true
	_clear_children(_method_button_box)
	_method_title_label.text = "%s 접근 방식 선택" % String(point.get("label", "조사 포인트"))
	_method_result_label.text = String(point.get("result_text", "어떤 방식으로 조사할지 선택하세요."))
	_result_label.text = "방법 선택 대기\n다음 행동: 파괴/관찰/분석 중 하나를 선택하면 결과가 요약됩니다."
	_hint_label.text = "이번 조사 힌트: 편성 요원 중 해당 능력치가 가장 높은 1명이 자동으로 도와줍니다."

	var method_options: Variant = point.get("method_options", [])
	if typeof(method_options) != TYPE_ARRAY:
		return

	for method in method_options:
		if typeof(method) != TYPE_DICTIONARY:
			continue

		var point_copy := point.duplicate(true)
		var method_copy: Dictionary = method.duplicate(true)
		var button := Button.new()
		button.text = _make_method_button_text(method_copy)
		button.pressed.connect(func() -> void:
			_run_method_option(point_copy, method_copy)
		)
		_method_button_box.add_child(button)


func _run_method_option(point: Dictionary, method: Dictionary) -> void:
	var result := GameState.resolve_investigation_method(String(point.get("id", "")), method)
	if result.has("error"):
		_method_result_label.text = String(result.get("error", "조사 방법 판정에 실패했습니다."))
		return

	_method_result_label.text = _make_method_result_text(result)
	_result_label.text = String(result.get("result_text", "조사 방법 결과가 기록되었습니다."))

	var hint_texts_value: Variant = result.get("hint_texts", [])
	var hint_texts: Array = hint_texts_value if typeof(hint_texts_value) == TYPE_ARRAY else []
	if hint_texts.is_empty():
		_hint_label.text = "이번 조사 힌트: 이번 판정으로 새로 확인한 힌트가 없습니다."
	else:
		_hint_label.text = "이번 조사 힌트\n- %s" % "\n- ".join(hint_texts)

	_refresh_case_status()


func _make_method_button_text(method: Dictionary) -> String:
	return "%s / 능력치: %s / 난이도: %d\n%s" % [
		String(method.get("label", "조사 방법")),
		String(method.get("stat_key", method.get("method_type", ""))),
		int(method.get("difficulty", 0)),
		String(method.get("summary", ""))
	]


func _make_method_result_text(result: Dictionary) -> String:
	var success_text := "성공" if bool(result.get("successful", false)) else "실패"
	var lines: Array = [
		"방법: %s" % String(result.get("method_label", "")),
		"성공/실패: %s" % success_text,
		"판정식: 플레이어 %d + 도우미 %s %d + 주사위 %d = %d / 난이도 %d" % [
			int(result.get("player_stat", 0)),
			String(result.get("helper_agent_name", "도우미 없음")),
			int(result.get("helper_stat", 0)),
			int(result.get("dice", 0)),
			int(result.get("total", 0)),
			int(result.get("difficulty", 0))
		]
	]

	var new_clue_ids_value: Variant = result.get("new_clue_ids", [])
	var new_clue_ids: Array = new_clue_ids_value if typeof(new_clue_ids_value) == TYPE_ARRAY else []
	if new_clue_ids.is_empty():
		lines.append("새 정보: 새 단서 없음")
	else:
		lines.append("새 정보: 새 단서 %s" % ", ".join(new_clue_ids))

	var hint_texts_value: Variant = result.get("hint_texts", [])
	var hint_texts: Array = hint_texts_value if typeof(hint_texts_value) == TYPE_ARRAY else []
	if hint_texts.is_empty():
		lines.append("새 힌트: 없음")
	else:
		lines.append("새 힌트\n- %s" % "\n- ".join(hint_texts))

	var case_status: Dictionary = result.get("case_status", {})
	lines.append("상태 변화: 괴이 위험도 %d / 괴이 이해도 %d / 피해자 이해도 %d / 정신력 %d / 괴이 안정도 %d / 예측률 %.1f%%" % [
		int(case_status.get("anomaly_risk", 0)),
		int(case_status.get("anomaly_understanding", 0)),
		int(case_status.get("victim_understanding", 0)),
		int(case_status.get("mental_stamina", 100)),
		int(case_status.get("anomaly_stability", 100)),
		float(case_status.get("prediction_rate", 0.0))
	])

	var random_event: Dictionary = result.get("random_event_result", {})
	if not random_event.is_empty():
		if bool(random_event.get("triggered", false)):
			lines.append("랜덤 이벤트 [%s]\n%s" % [
				String(random_event.get("title", "")),
				String(random_event.get("message", ""))
			])
		else:
			lines.append("랜덤 이벤트: %s" % String(random_event.get("message", "이상 현상 없음")))

	if bool(case_status.get("forced_recovery_phase", false)):
		lines.append("괴이 위험도가 한계에 도달했습니다. 해결 시도 버튼으로 강제 회수전에 진입할 수 있습니다.")

	var trust_lines: Array = []
	for change in result.get("trust_changes", []):
		if typeof(change) != TYPE_DICTIONARY:
			continue
		trust_lines.append("%s(%s) %s / 누적 %s - %s" % [
			String(change.get("agent_name", "")),
			String(change.get("temperament_label", "")),
			_format_delta(int(change.get("delta", 0))),
			_format_delta(int(change.get("total", 0))),
			String(change.get("text", ""))
		])
	if trust_lines.is_empty():
		lines.append("요원 반응: 수사 파트너 신뢰도 반응 없음")
	else:
		lines.append("요원 반응\n- %s" % "\n- ".join(trust_lines))

	var event_lines: Array = []
	for event in result.get("triggered_agent_events", []):
		if typeof(event) != TYPE_DICTIONARY:
			continue
		event_lines.append("[%s]\n%s\n보조 안내: %s" % [
			String(event.get("title", "요원 이벤트")),
			String(event.get("text", "")),
			String(event.get("support_text", ""))
		])
	if not event_lines.is_empty():
		lines.append("요원 이벤트\n%s" % "\n".join(event_lines))

	if GameState.can_enter_resolution_phase():
		lines.append("다음 행동: 남은 단서를 더 확인하거나 회수/안정화 시도를 준비")
	else:
		lines.append("다음 행동: 조사 포인트를 더 확인해 단서 수집률을 올림")

	return "\n".join(lines)


func _hide_method_panel() -> void:
	if _method_panel != null:
		_method_panel.visible = false


func _format_delta(value: int) -> String:
	if value > 0:
		return "+%d" % value
	return "%d" % value


func _has_method_options(point: Dictionary) -> bool:
	var method_options: Variant = point.get("method_options", [])
	return typeof(method_options) == TYPE_ARRAY and not method_options.is_empty()


func _refresh_case_status() -> void:
	var collected_count: int = GameState.get_collected_clue_count()
	var total_count: int = GameState.get_total_clue_count()
	var collection_rate: float = GameState.get_clue_collection_rate()
	_progress_label.text = "단서 수집률: %.0f%% (%d/%d)" % [collection_rate, collected_count, total_count]
	_progress_bar.value = collection_rate
	_resolution_label.text = "현재 해결 단계: %s" % GameState.get_resolution_label()
	var status := GameState.get_anomaly_status_summary()
	_case_state_label.text = "조사 상태: 괴이 위험도 %d / 괴이 이해도 %d / 피해자 이해도 %d / 정신력 %d / 괴이 안정도 %d / 예측률 %.1f%%" % [
		int(status.get("anomaly_risk", 0)),
		int(status.get("anomaly_understanding", 0)),
		int(status.get("victim_understanding", 0)),
		int(status.get("mental_stamina", 100)),
		int(status.get("anomaly_stability", 100)),
		float(status.get("prediction_rate", 0.0))
	]
	var support_texts := GameState.get_agent_trust_support_texts()
	_preparation_modifier_label.text = "로그 준비 안내: %s" % GameState.get_next_investigation_modifier_text()
	if not support_texts.is_empty():
		_preparation_modifier_label.text += "\n수사 파트너 보조: %s" % " / ".join(support_texts)
	_refresh_resolution_attempt_button()
	_refresh_clue_list()
	_refresh_hint_list()


func _refresh_clue_list() -> void:
	_clear_children(_clue_list)
	for clue in GameState.get_clues():
		if typeof(clue) != TYPE_DICTIONARY:
			continue

		var label := Label.new()
		var state_text := "수집됨" if bool(clue.get("collected", false)) else "미수집"
		var description := String(clue.get("description", ""))
		if bool(clue.get("collected", false)):
			label.text = "%s - %s\n%s" % [state_text, clue.get("title", ""), description]
		else:
			label.text = "%s - %s\n아직 기록되지 않았습니다." % [state_text, clue.get("title", "")]
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		_clue_list.add_child(label)


func _refresh_hint_list() -> void:
	_clear_children(_hint_list)
	for hint in GameState.get_hints():
		if typeof(hint) != TYPE_DICTIONARY:
			continue

		var hint_id := String(hint.get("id", ""))
		var seen := GameState.has_seen_hint(hint_id)
		var label := Label.new()
		label.text = "%s - %s\n대상 단서: %s" % [
			"확인됨" if seen else "미확인",
			String(hint.get("text", "")) if seen else "아직 확인하지 않은 방향 안내입니다.",
			String(hint.get("target_clue_id", ""))
		]
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		_hint_list.add_child(label)


func _find_clue(clue_id: String) -> Dictionary:
	for clue in GameState.get_clues():
		if typeof(clue) == TYPE_DICTIONARY and clue.get("id", "") == clue_id:
			return clue
	return {}


func _add_resolution_confirm_panel(parent: Control) -> void:
	_resolution_confirm_panel = PanelContainer.new()
	_resolution_confirm_panel.visible = false
	parent.add_child(_resolution_confirm_panel)

	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 8)
	_resolution_confirm_panel.add_child(content)

	var title := Label.new()
	title.text = "회수 / 안정화 페이즈 진입 확인"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	content.add_child(title)

	_resolution_confirm_label = Label.new()
	_resolution_confirm_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(_resolution_confirm_label)

	_resolution_warning_label = Label.new()
	_resolution_warning_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(_resolution_warning_label)

	var button_row := HBoxContainer.new()
	button_row.add_theme_constant_override("separation", 8)
	content.add_child(button_row)

	var continue_button := Button.new()
	continue_button.text = "조사 계속"
	continue_button.pressed.connect(func() -> void:
		_resolution_confirm_panel.visible = false
	)
	button_row.add_child(continue_button)

	var attempt_button := Button.new()
	attempt_button.text = "회수/안정화 진입"
	attempt_button.pressed.connect(_start_resolution_attempt)
	button_row.add_child(attempt_button)


func _refresh_resolution_attempt_button() -> void:
	var can_enter: bool = GameState.can_enter_resolution_phase()
	_resolution_attempt_button.disabled = not can_enter
	if can_enter:
		if GameState.is_forced_recovery_phase():
			_resolution_attempt_button.text = "강제 회수전 진입"
		else:
			_resolution_attempt_button.text = "회수/안정화 시도: %s" % GameState.get_resolution_label()
	else:
		_resolution_attempt_button.text = "회수/안정화 불가"


func _show_resolution_confirm_panel() -> void:
	if not GameState.can_enter_resolution_phase():
		_result_label.text = "회수/안정화 불가: 아직 괴이의 핵에 접근할 근거가 부족합니다.\n다음 행동: 단서를 더 수집해야 합니다."
		_resolution_confirm_panel.visible = false
		return

	var collection_rate: float = GameState.get_clue_collection_rate()
	var grade_text := "강제 회수전" if GameState.is_forced_recovery_phase() else GameState.get_resolution_label()
	_resolution_confirm_label.text = "현재 단서 수집률: %.0f%%\n현재 회수/안정화 등급: %s" % [
		collection_rate,
		grade_text
	]
	_resolution_warning_label.text = "위험 안내: %s" % GameState.get_resolution_phase_warning()
	_resolution_confirm_panel.visible = true


func _start_resolution_attempt() -> void:
	if not GameState.start_resolution_phase():
		_result_label.text = "해결 불가: 단서 수집률이 40% 이상이어야 합니다."
		_resolution_confirm_panel.visible = false
		_refresh_case_status()
		return

	GameState.set_current_scene_path("res://scenes/battle_scene.tscn")
	GameState.save_game()
	get_tree().change_scene_to_file("res://scenes/battle_scene.tscn")


func _get_investigation_points() -> Array:
	var points := GameState.get_investigation_points()
	if points.is_empty():
		return FALLBACK_INVESTIGATION_POINTS
	return points


func _is_point_unlocked(point: Dictionary) -> bool:
	var conditions: Dictionary = point.get("conditions", {})
	return GameState.check_conditions(conditions)


func _clear_children(parent: Node) -> void:
	if parent == null:
		return

	for child in parent.get_children():
		child.queue_free()


func _add_navigation(parent: Control) -> void:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 6)
	parent.add_child(row)
	_add_scene_button(row, "메뉴", "res://scenes/main_menu.tscn")
	_add_scene_button(row, "데이터", "res://scenes/case_data_scene.tscn")
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
