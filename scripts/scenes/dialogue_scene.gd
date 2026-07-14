# 대화 씬의 JSON 기반 대사 노드와 선택지 분기를 관리한다.
extends Control

const SceneVisuals = preload("res://scripts/ui/scene_presentation.gd")
const AssetCatalog = preload("res://scripts/ui/ui_asset_catalog.gd")
const ThemeFactory = preload("res://scripts/ui/ui_theme_factory.gd")
const RuntimeEditor = preload("res://scripts/ui/runtime_ui_editor.gd")

const FALLBACK_LINES: Array[Dictionary] = [
	{"speaker": "기록국 관제", "text": "이 역은 지도에도, 기록국 데이터에도 남아 있지 않아요.", "expression": "default"},
	{"speaker": "신입 요원", "text": "그럼 지금 우리가 보고 있는 전광판은 뭘 기준으로 움직이는 거죠?", "expression": "question"},
	{"speaker": "기록국 관제", "text": "괴담은 믿는 사람의 기억을 노선처럼 씁니다. 선택해야 해요.", "expression": "serious"}
]

var _line_index := 0
var _hint_index := 0
var _dialogue_node: Dictionary = {}
var _waiting_for_result_continue := false
var _pending_next_node_id := ""
var _pending_next_scene_path := ""

var _stage_label: Label
var _standing_label: Label
var _agent_status_label: Label
var _agent_reaction_label: Label
var _name_label: Label
var _dialogue_label: Label
var _condition_label: Label
var _next_button: Button
var _choice_box: VBoxContainer
var _hint_label: Label
var _clue_status_label: Label
var _agent_strip: HBoxContainer
var _dialogue_panel: PanelContainer
var _support_panel: PanelContainer
var _runtime_editor: RuntimeUiEditor


func _ready() -> void:
	if GameState.get_current_episode().is_empty():
		GameState.load_episode()
	# 저승역의 신규 캠페인 오프닝은 기존 JSON 대화 노드를 직접 사용한다.
	_legacy_ready()


func _redirect_to_unified_field() -> void:
	get_tree().change_scene_to_file("res://scenes/investigation_scene.tscn")


func _legacy_ready() -> void:

	GameState.set_current_scene_path("res://scenes/dialogue_scene.tscn")
	_dialogue_node = GameState.get_current_dialogue_node()
	SceneVisuals.apply_background(self, "dialogue")
	_build_vn_ui()
	_setup_runtime_editor()
	_show_line()
	_refresh_clue_status()
	_refresh_condition_label()


func _build_vn_ui() -> void:
	var shade := get_node_or_null("ArtLayer/Shade") as ColorRect
	if shade != null:
		shade.color = Color(0.025, 0.035, 0.05, 0.16)

	var scene_title := Label.new()
	scene_title.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	scene_title.offset_left = 18
	scene_title.offset_top = 12
	scene_title.offset_right = -18
	scene_title.offset_bottom = 46
	scene_title.text = GameState.get_current_episode_title()
	scene_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(scene_title)
	_stage_label = scene_title
	_standing_label = Label.new()
	_standing_label.visible = false
	add_child(_standing_label)

	_agent_strip = HBoxContainer.new()
	_agent_strip.anchor_left = 0.06
	_agent_strip.anchor_top = 0.1
	_agent_strip.anchor_right = 0.94
	_agent_strip.anchor_bottom = 0.74
	_agent_strip.add_theme_constant_override("separation", 18)
	_agent_strip.alignment = BoxContainer.ALIGNMENT_CENTER
	_agent_strip.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_agent_strip)

	_dialogue_panel = PanelContainer.new()
	_dialogue_panel.anchor_left = 0.04
	_dialogue_panel.anchor_top = 0.68
	_dialogue_panel.anchor_right = 0.96
	_dialogue_panel.anchor_bottom = 0.98
	_dialogue_panel.add_theme_stylebox_override("panel", ThemeFactory.panel_style(Color("17242c"), 0.86))
	add_child(_dialogue_panel)
	var dialogue_content := VBoxContainer.new()
	dialogue_content.add_theme_constant_override("separation", 7)
	_dialogue_panel.add_child(dialogue_content)
	_name_label = Label.new()
	_name_label.text = "현장 요원"
	dialogue_content.add_child(_name_label)
	_dialogue_label = Label.new()
	_dialogue_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_dialogue_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	dialogue_content.add_child(_dialogue_label)
	_condition_label = Label.new()
	_condition_label.visible = false
	_condition_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	dialogue_content.add_child(_condition_label)
	_choice_box = VBoxContainer.new()
	_choice_box.visible = false
	_choice_box.add_theme_constant_override("separation", 6)
	dialogue_content.add_child(_choice_box)
	var command_row := HBoxContainer.new()
	command_row.add_theme_constant_override("separation", 8)
	dialogue_content.add_child(command_row)
	_next_button = Button.new()
	_next_button.text = "다음 대화"
	_next_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_next_button.pressed.connect(_advance_line)
	command_row.add_child(_next_button)
	var investigation_button := Button.new()
	investigation_button.text = "조사로 이동"
	investigation_button.visible = GameState.get_current_episode_id() != "episode_001_afterlife_station"
	investigation_button.pressed.connect(func() -> void:
		_go_to_scene("res://scenes/investigation_scene.tscn")
	)
	command_row.add_child(investigation_button)
	var support_button := Button.new()
	support_button.text = "기록국 지원"
	support_button.pressed.connect(func() -> void:
		_support_panel.visible = not _support_panel.visible
	)
	command_row.add_child(support_button)

	_support_panel = PanelContainer.new()
	_support_panel.anchor_left = 0.68
	_support_panel.anchor_top = 0.12
	_support_panel.anchor_right = 0.97
	_support_panel.anchor_bottom = 0.66
	_support_panel.visible = false
	_support_panel.add_theme_stylebox_override("panel", ThemeFactory.panel_style(Color("293943"), 0.9))
	add_child(_support_panel)
	var support_scroll := ScrollContainer.new()
	support_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_support_panel.add_child(support_scroll)
	var hint_content := VBoxContainer.new()
	hint_content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hint_content.add_theme_constant_override("separation", 6)
	support_scroll.add_child(hint_content)
	hint_content.add_child(_make_vn_label("기록국 지원 정보"))
	var hint_button := Button.new()
	hint_button.text = "힌트 확인"
	hint_button.pressed.connect(_show_next_hint)
	hint_content.add_child(hint_button)
	_hint_label = _make_vn_label("힌트는 단서 수집률을 바꾸지 않고 조사 방향만 알려줍니다.")
	hint_content.add_child(_hint_label)
	hint_content.add_child(_make_vn_label("단서 목록"))
	_clue_status_label = _make_vn_label("")
	hint_content.add_child(_clue_status_label)
	_agent_status_label = Label.new()
	_agent_status_label.visible = false
	add_child(_agent_status_label)
	_agent_reaction_label = Label.new()
	_agent_reaction_label.visible = false
	add_child(_agent_reaction_label)


func _make_vn_label(text: String) -> Label:
	var label := Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return label


func _populate_vn_agents(speaker_name: String) -> void:
	for child in _agent_strip.get_children():
		child.queue_free()
	var catalog := AssetCatalog.new()
	for agent in GameState.get_selected_agents():
		if typeof(agent) != TYPE_DICTIONARY:
			continue
		var agent_name := String(agent.get("name", ""))
		var portrait := TextureRect.new()
		portrait.texture = catalog.get_agent_expression(String(agent.get("id", "")), 1 if agent_name == speaker_name else 0)
		portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		portrait.custom_minimum_size = Vector2(220, 360)
		portrait.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		portrait.modulate = Color.WHITE if agent_name == speaker_name else Color(0.52, 0.58, 0.64, 0.72)
		portrait.tooltip_text = agent_name
		_agent_strip.add_child(portrait)


func _build_ui() -> void:
	var background := ColorRect.new()
	background.color = Color(0.025, 0.035, 0.05, 0.2)
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
	root.custom_minimum_size = Vector2(960, 0)
	root.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	root.add_theme_constant_override("separation", 10)
	margin.add_child(root)

	var title := Label.new()
	title.text = "현장 브리핑 / 요원 팀 대화"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	root.add_child(title)

	var upper_row := HBoxContainer.new()
	upper_row.add_theme_constant_override("separation", 12)
	upper_row.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_child(upper_row)

	var stage := PanelContainer.new()
	stage.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	stage.size_flags_stretch_ratio = 1.7
	upper_row.add_child(stage)

	var stage_layout := VBoxContainer.new()
	stage_layout.add_theme_constant_override("separation", 10)
	stage.add_child(stage_layout)

	_stage_label = Label.new()
	_stage_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	stage_layout.add_child(_stage_label)

	var standing := PanelContainer.new()
	standing.size_flags_vertical = Control.SIZE_EXPAND_FILL
	stage_layout.add_child(standing)

	_agent_strip = HBoxContainer.new()
	_agent_strip.add_theme_constant_override("separation", 10)
	_agent_strip.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	standing.add_child(_agent_strip)
	_standing_label = Label.new()
	_standing_label.visible = false
	standing.add_child(_standing_label)

	var agent_panel := PanelContainer.new()
	agent_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	agent_panel.size_flags_stretch_ratio = 1.0
	upper_row.add_child(agent_panel)

	var agent_content := VBoxContainer.new()
	agent_content.add_theme_constant_override("separation", 6)
	agent_panel.add_child(agent_content)

	var agent_title := Label.new()
	agent_title.text = "현장 투입 요원"
	agent_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	agent_content.add_child(agent_title)

	_agent_status_label = Label.new()
	_agent_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	agent_content.add_child(_agent_status_label)

	_agent_reaction_label = Label.new()
	_agent_reaction_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	agent_content.add_child(_agent_reaction_label)

	_dialogue_panel = PanelContainer.new()
	root.add_child(_dialogue_panel)
	var dialogue_content := VBoxContainer.new()
	dialogue_content.add_theme_constant_override("separation", 8)
	_dialogue_panel.add_child(dialogue_content)

	_name_label = Label.new()
	_name_label.text = "발화 요원"
	dialogue_content.add_child(_name_label)

	_dialogue_label = Label.new()
	_dialogue_label.text = "대사"
	_dialogue_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	dialogue_content.add_child(_dialogue_label)

	_condition_label = Label.new()
	_condition_label.visible = false
	_condition_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	dialogue_content.add_child(_condition_label)

	_choice_box = VBoxContainer.new()
	_choice_box.visible = false
	_choice_box.add_theme_constant_override("separation", 6)
	dialogue_content.add_child(_choice_box)

	var command_row := HBoxContainer.new()
	command_row.add_theme_constant_override("separation", 8)
	dialogue_content.add_child(command_row)

	_next_button = Button.new()
	_next_button.text = "다음 대사"
	_next_button.pressed.connect(_advance_line)
	command_row.add_child(_next_button)

	var investigation_button := Button.new()
	investigation_button.text = "팀 조사 투입"
	investigation_button.pressed.connect(func() -> void:
		_go_to_scene("res://scenes/investigation_scene.tscn")
	)
	command_row.add_child(investigation_button)
	var support_button := Button.new()
	support_button.text = "기록"
	support_button.pressed.connect(func() -> void: _support_panel.visible = not _support_panel.visible)
	command_row.add_child(support_button)

	_support_panel = PanelContainer.new()
	_support_panel.visible = false
	root.add_child(_support_panel)

	var hint_content := VBoxContainer.new()
	hint_content.add_theme_constant_override("separation", 6)
	_support_panel.add_child(hint_content)

	var hint_title := Label.new()
	hint_title.text = "기록국 지원 정보"
	hint_content.add_child(hint_title)

	var hint_button := Button.new()
	hint_button.text = "기록국 힌트 확인"
	hint_button.pressed.connect(_show_next_hint)
	hint_content.add_child(hint_button)

	_hint_label = Label.new()
	_hint_label.text = "힌트는 아직 찾지 못한 단서의 방향만 알려주며, 단서 수집률에는 반영되지 않습니다."
	_hint_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	hint_content.add_child(_hint_label)

	var clue_title := Label.new()
	clue_title.text = "단서 목록"
	hint_content.add_child(clue_title)

	_clue_status_label = Label.new()
	_clue_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	hint_content.add_child(_clue_status_label)


func _show_line() -> void:
	var lines := _get_current_lines()
	if lines.is_empty():
		return

	_line_index = clampi(_line_index, 0, lines.size() - 1)
	var line: Dictionary = lines[_line_index]
	_stage_label.text = GameState.get_current_episode_title()
	_standing_label.text = "현장 상황 / 통신 대상: %s" % String(_dialogue_node.get("standing_id", "bureau_control"))
	_name_label.text = String(line.get("speaker", line.get("name", "")))
	_dialogue_label.text = _get_line_text(line)
	_populate_vn_agents(_name_label.text)
	_choice_box.visible = false
	_waiting_for_result_continue = false
	_pending_next_node_id = ""
	_pending_next_scene_path = ""
	_next_button.disabled = false
	_next_button.text = "다음 대사"
	_refresh_agent_reactions()


func _get_line_text(line: Dictionary) -> String:
	var source := String(line.get("text", ""))
	if _runtime_editor == null:
		return source
	var node_id := String(_dialogue_node.get("id", "dialogue"))
	var key := "%s/dialogue/%s/%d/text" % [GameState.get_current_episode_id(), node_id, _line_index]
	return _runtime_editor.update_text_binding("dialogue_text", key, source)


func _setup_runtime_editor() -> void:
	_runtime_editor = RuntimeEditor.new()
	add_child(_runtime_editor)
	_runtime_editor.setup("dialogue", self)
	_runtime_editor.register_element("dialogue_panel", _dialogue_panel, {
		"minimum_size": Vector2(520, 150),
		"free_layout": true,
		"text_control": _dialogue_label,
		"style_target": _dialogue_panel,
		"content_key": "%s/dialogue/initial/text" % GameState.get_current_episode_id(),
		"source_text": _dialogue_label.text
	})
	_runtime_editor.register_element("support_panel", _support_panel, {"minimum_size": Vector2(320, 120)})
	_runtime_editor.register_element("background", get_node_or_null("ArtLayer/Background"), {
		"minimum_size": Vector2(640, 360),
		"image_target": get_node_or_null("ArtLayer/Background")
	})


func _advance_line() -> void:
	if _waiting_for_result_continue:
		_continue_after_result()
		return

	var lines := _get_current_lines()
	if _line_index < lines.size() - 1:
		_line_index += 1
		_show_line()
		return

	_show_choices()


func _show_choices() -> void:
	_choice_box.visible = true
	_clear_children(_choice_box)

	var choices := _get_current_choices()
	if choices.is_empty():
		var label := Label.new()
		label.text = "표시할 선택지가 없습니다. 조사 시작 버튼으로 이동하세요."
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		_choice_box.add_child(label)
		_next_button.disabled = true
		return

	for choice in choices:
		if typeof(choice) == TYPE_DICTIONARY:
			_add_choice(choice)

	_next_button.disabled = true


func _add_choice(choice: Dictionary) -> void:
	var button := Button.new()
	var conditions: Dictionary = choice.get("conditions", {})
	var can_select := GameState.check_conditions(conditions)
	button.text = String(choice.get("text", "선택지"))
	if not can_select:
		button.text += " (조건 미충족)"
		button.disabled = true
	button.pressed.connect(func() -> void:
		_select_choice(choice)
	)
	_choice_box.add_child(button)


func _select_choice(choice: Dictionary) -> void:
	GameState.apply_story_effects(choice)
	_name_label.text = "선택"
	_dialogue_label.text = _make_choice_result_text(choice)
	_choice_box.visible = false
	_pending_next_node_id = String(choice.get("next_node_id", ""))
	_pending_next_scene_path = String(choice.get("next_scene_path", ""))
	_waiting_for_result_continue = true
	_next_button.disabled = false
	_next_button.text = _make_next_button_text()
	_refresh_clue_status()
	_refresh_condition_label()
	_refresh_agent_reactions()
	GameState.save_game()


func _continue_after_result() -> void:
	if not _pending_next_scene_path.is_empty():
		_go_to_scene(_pending_next_scene_path)
		return

	if not _pending_next_node_id.is_empty():
		_load_dialogue_node(_pending_next_node_id)
		return

	_waiting_for_result_continue = false
	_show_choices()


func _load_dialogue_node(dialogue_node_id: String) -> void:
	var next_node := GameState.get_dialogue_node(dialogue_node_id)
	if next_node.is_empty():
		_dialogue_label.text = "다음 대화 노드를 찾지 못했습니다: %s" % dialogue_node_id
		return

	_dialogue_node = next_node
	GameState.set_current_dialogue_node_id(dialogue_node_id)
	GameState.save_game()
	_line_index = 0
	_show_line()
	_refresh_condition_label()
	_refresh_agent_reactions()


func _show_next_hint() -> void:
	var hints := GameState.get_available_hints()
	if hints.is_empty():
		_hint_label.text = "현재 조건에서 표시할 힌트가 없습니다. 조사나 선택으로 플래그를 더 확보하세요."
		return

	var hint: Dictionary = hints[_hint_index % hints.size()]
	_hint_index += 1
	var hint_id := String(hint.get("id", ""))
	var was_seen := GameState.has_seen_hint(hint_id)
	GameState.mark_hint_seen(hint_id)
	_hint_label.text = "힌트: %s\n단서 수집률 변화 없음: %.0f%%" % [
		hint.get("text", ""),
		GameState.get_clue_collection_rate()
	]
	if was_seen:
		_hint_label.text += "\n힌트 상태: 이미 확인한 힌트"
	else:
		_hint_label.text += "\n힌트 상태: 새로 확인함"
	_refresh_clue_status()


func _refresh_clue_status() -> void:
	var text := "단서 수집률: %.0f%% (%d/%d)\n" % [
		GameState.get_clue_collection_rate(),
		GameState.get_collected_clue_count(),
		GameState.get_total_clue_count()
	]
	for clue in GameState.get_clues():
		if typeof(clue) != TYPE_DICTIONARY:
			continue

		var state_text := "수집됨" if clue.get("collected", false) else "미수집"
		text += "%s - %s\n" % [state_text, clue.get("title", "")]

	_clue_status_label.text = text.strip_edges()


func _refresh_condition_label() -> void:
	if _condition_label == null:
		return

	_condition_label.text = "현재 대화 노드: %s\n보유 플래그: %s" % [
		String(_dialogue_node.get("id", "fallback")),
		", ".join(GameState.get_flags()) if not GameState.get_flags().is_empty() else "없음"
	]


func _refresh_agent_reactions() -> void:
	if _agent_status_label == null or _agent_reaction_label == null:
		return

	var selected_agents := GameState.get_selected_agents()
	if selected_agents.is_empty():
		_agent_status_label.text = "투입 요원: 없음"
		_agent_reaction_label.text = "메인 메뉴에서 요원 2~3명을 편성하면 팀의 성향별 현장 반응이 표시됩니다."
		return

	_agent_status_label.text = "투입 팀: %s" % GameState.get_selected_agent_summary()

	var reactions := GameState.get_selected_agent_reactions()
	if reactions.is_empty():
		_agent_reaction_label.text = "현재 조건에서 표시할 요원 반응이 없습니다."
		return

	var lines: Array = []
	for reaction in reactions:
		if typeof(reaction) != TYPE_DICTIONARY:
			continue

		lines.append("%s [%s]: %s" % [
			String(reaction.get("agent_name", reaction.get("agent_id", ""))),
			String(reaction.get("temperament_label", reaction.get("temperament", ""))),
			String(reaction.get("text", ""))
		])

	_agent_reaction_label.text = "\n\n".join(lines)


func _make_choice_result_text(choice: Dictionary) -> String:
	var text := String(choice.get("result_text", "선택 결과가 기록되었습니다."))
	var hint_texts := GameState.get_hint_texts_by_ids(choice.get("show_hint_ids", []))
	if not hint_texts.is_empty():
		text += "\n\n기록된 힌트\n- %s" % "\n- ".join(hint_texts)
	return text


func _make_next_button_text() -> String:
	if not _pending_next_scene_path.is_empty():
		return "다음 장면"
	if not _pending_next_node_id.is_empty():
		return "다음 대화"
	return "선택지 보기"


func _go_to_scene(scene_path: String) -> void:
	GameState.set_current_scene_path(scene_path)
	GameState.save_game()
	get_tree().change_scene_to_file(scene_path)


func _get_current_lines() -> Array:
	var lines: Variant = _dialogue_node.get("lines", [])
	if typeof(lines) == TYPE_ARRAY and not lines.is_empty():
		return lines
	return FALLBACK_LINES


func _get_current_choices() -> Array:
	var choices: Variant = _dialogue_node.get("choices", [])
	if typeof(choices) == TYPE_ARRAY:
		return choices
	return []


func _clear_children(parent: Node) -> void:
	for child in parent.get_children():
		child.queue_free()


func _add_navigation(parent: Control) -> void:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 6)
	parent.add_child(row)
	_add_scene_button(row, "메뉴", "res://scenes/main_menu.tscn")
	_add_scene_button(row, "조사", "res://scenes/investigation_scene.tscn")
	_add_scene_button(row, "데이터", "res://scenes/case_data_scene.tscn")
	_add_scene_button(row, "회수", "res://scenes/battle_scene.tscn")


func _add_scene_button(parent: Control, label: String, scene_path: String) -> void:
	var button := Button.new()
	button.text = label
	button.pressed.connect(func() -> void:
		_go_to_scene(scene_path)
	)
	parent.add_child(button)
