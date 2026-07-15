# 조사 씬의 JSON 기반 조사 포인트와 조건부 결과 처리를 관리한다.
extends Control

const SceneVisuals = preload("res://scripts/ui/scene_presentation.gd")
const RuntimeEditor = preload("res://scripts/ui/runtime_ui_editor.gd")
const AssetCatalog = preload("res://scripts/ui/ui_asset_catalog.gd")
const LogGuideScript = preload("res://scripts/ui/log_guide.gd")
const LogTutorialCatalog = preload("res://scripts/ui/log_tutorial_catalog.gd")
const ActionChoiceCardScene = preload("res://scenes/ui/action_choice_card.tscn")
const TeamStatusChipScene = preload("res://scenes/ui/team_status_chip.tscn")
const AccessibilitySettingsScript = preload("res://scripts/ui/accessibility_settings.gd")

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
var _team_label: Label
var _narrative_label: Label
var _result_panel: PanelContainer
var _runtime_editor: RuntimeUiEditor
var _record_drawer: PanelContainer
var _record_button: Button
var _learning_list: VBoxContainer
var _field_node: Dictionary = {}
var _field_lines: Array = []
var _field_speaker_label: Label
var _field_dialogue_label: Label
var _field_next_button: Button
var _field_choice_box: VBoxContainer
var _agent_reaction_box: VBoxContainer
var _log_guide: LogGuide
var _points_box: Container
var _pending_next_field_node_id := ""
var _field_log_intro_played := false
var _cinematic_stage: Control
var _agent_stage: HBoxContainer
var _team_hud: HBoxContainer
var _dialogue_dock: PanelContainer
var _point_method_dock: PanelContainer
var _method_column: VBoxContainer
var _manual_panel: PanelContainer
var _result_toast: PanelContainer
var _case_summary_label: Label
var _mode_label: Label
var _return_dialog: ConfirmationDialog
var _settings_dialog: AcceptDialog
var _return_field_button: Button
var _accessibility := AccessibilitySettingsScript.new()


func _ready() -> void:
	if GameState.get_current_episode().is_empty():
		GameState.load_episode()

	GameState.set_current_scene_path("res://scenes/investigation_scene.tscn")
	_field_node = GameState.get_current_field_node()
	SceneVisuals.apply_background(self, "investigation")
	_build_ui()
	_setup_runtime_editor()
	_refresh_case_status()


func _build_ui() -> void:
	_cinematic_stage = %CinematicStage
	_agent_stage = %AgentStage
	_team_hud = %TeamHud
	_dialogue_dock = %DialogueDock
	_point_method_dock = %PointMethodDock
	_method_column = %MethodColumn
	_manual_panel = %ManualPanel
	_result_toast = %ResultToast
	_case_summary_label = %CaseSummaryLabel
	_mode_label = %ModeLabel
	_record_button = %RecordButton
	_resolution_attempt_button = %ResolutionAttemptButton
	_record_drawer = %RecordDrawer
	_progress_label = %ProgressLabel
	_progress_bar = %ProgressBar
	_progress_bar.min_value = 0
	_progress_bar.max_value = 100
	_resolution_label = %ResolutionLabel
	_case_state_label = %CaseStateLabel
	_preparation_modifier_label = %PreparationModifierLabel
	_clue_list = %ClueList
	_hint_list = %HintList
	_learning_list = %LearningList
	_resolution_confirm_panel = %ResolutionConfirmPanel
	_resolution_confirm_label = %ResolutionConfirmLabel
	_resolution_warning_label = %ResolutionWarningLabel
	_field_speaker_label = %FieldSpeakerLabel
	_field_dialogue_label = %FieldDialogueLabel
	_field_next_button = %FieldNextButton
	_field_choice_box = %FieldChoiceBox
	_agent_reaction_box = %AgentReactionBox
	_points_box = %PointsBox
	_return_field_button = %ReturnFieldButton
	_method_panel = _point_method_dock
	_method_title_label = %MethodTitleLabel
	_method_button_box = %MethodButtonBox
	_method_result_label = %MethodResultLabel
	_result_label = %ResultLabel
	_hint_label = Label.new()
	_team_label = Label.new()
	_narrative_label = _field_dialogue_label
	_result_panel = _result_toast

	_record_button.pressed.connect(_toggle_record_drawer)
	_resolution_attempt_button.pressed.connect(_show_resolution_confirm_panel)
	_field_next_button.pressed.connect(_advance_field_dialogue)
	%ContinueInvestigationButton.pressed.connect(func() -> void: _resolution_confirm_panel.visible = false)
	%EnterRecoveryButton.pressed.connect(_start_resolution_attempt)
	%LogUtilityButton.pressed.connect(_toggle_record_drawer)
	%SettingsButton.pressed.connect(_show_settings)
	%ReturnHqButton.pressed.connect(_show_return_confirmation)
	_return_field_button.pressed.connect(_return_to_field_choice)

	_log_guide = LogGuideScript.new()
	_log_guide.set_compact(true)
	_log_guide.custom_minimum_size = Vector2.ZERO
	_log_guide.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	_log_guide.visible = false
	%LogHost.add_child(_log_guide)
	_build_utility_dialogs()
	_add_team_status_chips(_team_hud)
	_agent_stage.visible = false

	for point in _get_investigation_points():
		if typeof(point) == TYPE_DICTIONARY:
			_add_investigation_point(_points_box, point)
	_show_current_field_node()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_show_return_confirmation()
		get_viewport().set_input_as_handled()


func _build_utility_dialogs() -> void:
	_return_dialog = ConfirmationDialog.new()
	_return_dialog.title = "현장 진행 일시 중단"
	_return_dialog.dialog_text = "현재 조사 진행을 저장하고 기록국 HQ로 돌아갑니다.\n시간은 소비되지 않으며 같은 현장을 재개해야 합니다."
	_return_dialog.ok_button_text = "저장하고 복귀"
	_return_dialog.cancel_button_text = "조사 계속"
	_return_dialog.confirmed.connect(_return_to_hq)
	add_child(_return_dialog)

	_settings_dialog = AcceptDialog.new()
	_settings_dialog.title = "연출 설정"
	_settings_dialog.ok_button_text = "닫기"
	var content := VBoxContainer.new()
	content.custom_minimum_size = Vector2(420, 0)
	content.add_theme_constant_override("separation", 8)
	_settings_dialog.add_child(content)
	for entry in [
		{"id": "screen_shake", "label": "화면 흔들림"},
		{"id": "flash", "label": "섬광"},
		{"id": "horror_distortion", "label": "공포 왜곡"}
	]:
		_add_settings_slider(content, String(entry.label), String(entry.id))
	add_child(_settings_dialog)


func _add_settings_slider(parent: Control, label_text: String, effect_id: String) -> void:
	var label := Label.new()
	label.text = label_text
	parent.add_child(label)
	var slider := HSlider.new()
	slider.min_value = 0
	slider.max_value = 100
	slider.value = _accessibility.get_strength(effect_id) * 100.0
	slider.value_changed.connect(func(value: float) -> void: _accessibility.set_strength(effect_id, value / 100.0))
	parent.add_child(slider)


func _show_return_confirmation() -> void:
	if _return_dialog != null:
		_return_dialog.popup_centered()


func _show_settings() -> void:
	if _settings_dialog != null:
		_settings_dialog.popup_centered(Vector2i(480, 320))


func _return_to_hq() -> void:
	GameState.suspend_campaign_operation()
	GameState.set_current_scene_path(GameState.SCENE_PREPARATION)
	GameState.save_game()
	get_tree().change_scene_to_file(GameState.SCENE_PREPARATION)


func _add_team_portraits(parent: Control) -> void:
	var catalog := AssetCatalog.new()
	for agent in GameState.get_selected_agents():
		if typeof(agent) != TYPE_DICTIONARY:
			continue
		var agent_id := String(agent.get("id", ""))
		var card := HBoxContainer.new()
		card.add_theme_constant_override("separation", 6)
		var portrait := TextureRect.new()
		portrait.texture = catalog.get_agent_expression(agent_id, 1)
		portrait.custom_minimum_size = Vector2(64, 82)
		portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		card.add_child(portrait)
		var status := Label.new()
		status.text = "%s\n체력 %d/%d\n정신 %d/%d\n%s" % [
			String(agent.get("name", "")),
			GameState.get_agent_current_hp(agent_id), GameState.get_agent_max_hp(agent_id),
			GameState.get_agent_current_mental(agent_id), GameState.get_agent_max_mental(agent_id),
			"행동 가능" if GameState.is_agent_active(agent_id) else "행동 불능"
		]
		status.add_theme_font_size_override("font_size", 11)
		card.add_child(status)
		parent.add_child(card)


func _add_team_status_chips(parent: Control) -> void:
	var catalog := AssetCatalog.new()
	for agent in GameState.get_selected_agents():
		if typeof(agent) != TYPE_DICTIONARY:
			continue
		var agent_id := String(agent.get("id", ""))
		var chip := TeamStatusChipScene.instantiate()
		parent.add_child(chip)
		chip.configure(agent, {
			"hp": GameState.get_agent_current_hp(agent_id),
			"max_hp": GameState.get_agent_max_hp(agent_id),
			"mental": GameState.get_agent_current_mental(agent_id),
			"max_mental": GameState.get_agent_max_mental(agent_id),
			"active": GameState.is_agent_active(agent_id),
			"representative": false,
			"texture": catalog.get_agent_expression(agent_id, 1)
		})


func _setup_runtime_editor() -> void:
	_runtime_editor = RuntimeEditor.new()
	add_child(_runtime_editor)
	_runtime_editor.setup("investigation", self)
	_runtime_editor.register_element("cinematic_record_drawer", _record_drawer, {"minimum_size": Vector2(300, 220), "free_layout": false})
	_runtime_editor.register_element("cinematic_dialogue_dock", _dialogue_dock, {
		"minimum_size": Vector2(720, 220),
		"free_layout": true,
		"text_control": _narrative_label,
		"content_key": "%s/investigation/narrative" % GameState.get_current_episode_id(),
		"source_text": _narrative_label.text
	})


func _add_record_drawer(parent: Control) -> void:
	_record_drawer = PanelContainer.new()
	_record_drawer.visible = false
	parent.add_child(_record_drawer)
	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(0, 220)
	_record_drawer.add_child(scroll)
	var content := VBoxContainer.new()
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.add_theme_constant_override("separation", 8)
	scroll.add_child(content)
	var title := Label.new()
	title.text = "현장 기록"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	content.add_child(title)
	_clue_list = VBoxContainer.new()
	content.add_child(_clue_list)
	_hint_list = VBoxContainer.new()
	content.add_child(_hint_list)
	_learning_list = VBoxContainer.new()
	content.add_child(_learning_list)


func _toggle_record_drawer() -> void:
	_record_drawer.visible = not _record_drawer.visible
	_record_button.text = "기록 닫기" if _record_drawer.visible else "기록 열기"
	if _record_drawer.visible:
		_refresh_record_learning()
		_present_log_tutorial("field_first_record_drawer")


func _add_field_dialogue(parent: Control) -> void:
	var content := _add_section(parent, "현장 대화", "상황을 읽고 팀의 대화를 들은 뒤 다음 행동을 선택합니다.")
	_log_guide = LogGuideScript.new()
	_log_guide.set_compact(true)
	_log_guide.visible = false
	content.add_child(_log_guide)
	_field_speaker_label = Label.new()
	_field_speaker_label.text = "기록국 관제"
	content.add_child(_field_speaker_label)
	_field_dialogue_label = Label.new()
	_field_dialogue_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_field_dialogue_label.custom_minimum_size.y = 54
	content.add_child(_field_dialogue_label)
	_field_next_button = Button.new()
	_field_next_button.text = "계속"
	_field_next_button.pressed.connect(_advance_field_dialogue)
	content.add_child(_field_next_button)
	_field_choice_box = VBoxContainer.new()
	_field_choice_box.add_theme_constant_override("separation", 6)
	content.add_child(_field_choice_box)


func _show_current_field_node() -> void:
	_field_node = GameState.get_current_field_node()
	if _field_node.is_empty():
		_field_dialogue_label.text = "현장 기록을 불러오지 못했습니다. 기존 조사 포인트를 확인하세요."
		_field_next_button.visible = false
		_points_box.visible = true
		_configure_point_picker_escape()
		_set_ui_mode("POINT_PICKER")
		return
	_narrative_label.text = String(_field_node.get("title", GameState.get_current_episode_title()))
	_field_lines = _field_node.get("opening_dialogue", []).duplicate(true)
	if not GameState.has_seen_log_tutorial("field_first_choice"):
		var tutorial := LogTutorialCatalog.get_entry("field_first_choice")
		var tutorial_lines: Array = tutorial.get("lines", []).duplicate(true)
		for line in tutorial_lines:
			if typeof(line) == TYPE_DICTIONARY:
				line["speaker"] = "로그"
				line["tutorial_id"] = "field_first_choice"
		_field_lines = tutorial_lines + _field_lines
	_pending_next_field_node_id = ""
	_clear_children(_field_choice_box)
	_points_box.visible = false
	_present_situation_and_choices()


func _present_situation_and_choices() -> void:
	_field_speaker_label.text = "상황"
	_field_speaker_label.visible = true
	_field_dialogue_label.visible = true
	_field_dialogue_label.text = String(_field_node.get("title", GameState.get_current_episode_title()))
	_field_next_button.visible = false
	_present_support_lines(_field_lines)
	_show_field_choices()


func _present_support_lines(lines: Array) -> void:
	for child in _agent_reaction_box.get_children():
		_agent_reaction_box.remove_child(child)
		child.queue_free()
	var log_texts: Array[String] = []
	var log_expression := "normal"
	var selected_by_name := {}
	for agent in GameState.get_selected_agents():
		if typeof(agent) == TYPE_DICTIONARY:
			selected_by_name[String(agent.get("name", ""))] = agent
	for value in lines:
		if typeof(value) != TYPE_DICTIONARY:
			continue
		var line: Dictionary = value
		var tutorial_id := String(line.get("tutorial_id", ""))
		if not tutorial_id.is_empty():
			GameState.claim_log_tutorial(tutorial_id)
		var speaker := String(line.get("speaker", ""))
		if speaker == "로그":
			if log_texts.size() < 2:
				log_texts.append(String(line.get("text", "")))
				log_expression = String(line.get("expression", log_expression))
			continue
		if selected_by_name.has(speaker) and _agent_reaction_box.get_child_count() < 2:
			_agent_reaction_box.add_child(_make_agent_reaction_row(selected_by_name[speaker], String(line.get("text", ""))))
	_agent_reaction_box.visible = _agent_reaction_box.get_child_count() > 0
	if log_texts.is_empty():
		_log_guide.visible = false
		return
	_log_guide.set_internal_advance_enabled(false)
	_log_guide.present_lines([{
		"text": "\n".join(log_texts),
		"expression": log_expression
	}], log_expression, not _field_log_intro_played)
	_log_guide.visible = true
	_field_log_intro_played = true


func _make_agent_reaction_row(agent: Dictionary, text: String) -> HBoxContainer:
	var agent_id := String(agent.get("id", ""))
	var row := HBoxContainer.new()
	row.name = "AgentReaction"
	row.set_meta("agent_id", agent_id)
	row.add_theme_constant_override("separation", 10)
	var portrait := TextureRect.new()
	portrait.name = "Portrait"
	portrait.custom_minimum_size = Vector2(54, 54)
	portrait.texture = AssetCatalog.new().get_agent_face_portrait(agent_id, 1)
	portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	row.add_child(portrait)
	var reaction := Label.new()
	reaction.name = "ReactionText"
	reaction.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	reaction.text = "%s  %s" % [String(agent.get("name", "요원")), text]
	reaction.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	reaction.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	row.add_child(reaction)
	return row


func _advance_field_dialogue() -> void:
	if _pending_next_field_node_id.is_empty():
		return
	GameState.set_current_field_node_id(_pending_next_field_node_id)
	GameState.save_game()
	_show_current_field_node()


func _show_field_choices() -> void:
	_set_ui_mode("FIELD_CHOICES")
	_clear_children(_field_choice_box)
	var choices: Array = _field_node.get("choices", [])
	for choice in choices:
		if typeof(choice) != TYPE_DICTIONARY:
			continue
		var choice_copy: Dictionary = choice.duplicate(true)
		var ability := String(choice_copy.get("ability", "analysis"))
		var helper := GameState.find_best_agent_for_ability(ability)
		var card := ActionChoiceCardScene.instantiate()
		_field_choice_box.add_child(card)
		card.configure({
			"id": String(choice_copy.get("id", "field_choice")),
			"title": String(choice_copy.get("label", "현장을 확인한다")),
			"description": String(choice_copy.get("summary", "")),
			"meta": "%s · %s %d" % [String(helper.get("name", "팀")), GameState.ABILITY_LABELS.get(ability, ability), GameState.get_agent_ability(String(helper.get("id", "")), ability)]
		})
		card.action_requested.connect(func(_action_id: String) -> void: _select_field_choice(choice_copy))
	if choices.is_empty() or bool(_field_node.get("uses_investigation_points", false)):
		_points_box.visible = true
		_configure_point_picker_escape()
		_set_ui_mode("POINT_PICKER")


func _configure_point_picker_escape() -> void:
	if _return_field_button == null:
		return
	var return_field_node_id := String(_field_node.get("return_field_node_id", "")).strip_edges()
	var has_visible_point := _points_box != null and _points_box.get_child_count() > 0
	_return_field_button.visible = not return_field_node_id.is_empty() or not has_visible_point
	if not _return_field_button.visible:
		return
	_return_field_button.text = "조사 선택으로 돌아가기" if not return_field_node_id.is_empty() else "HQ로 복귀"
	_return_field_button.tooltip_text = "확보한 단서와 위험 사례는 유지됩니다." if not return_field_node_id.is_empty() else "현재 진행을 저장하고 HQ로 돌아갑니다."


func _return_to_field_choice() -> void:
	var return_field_node_id := String(_field_node.get("return_field_node_id", "")).strip_edges()
	if return_field_node_id.is_empty():
		_show_return_confirmation()
		return
	GameState.set_current_field_node_id(return_field_node_id)
	GameState.save_game()
	_show_current_field_node()


func _select_field_choice(choice: Dictionary) -> void:
	var result := GameState.resolve_field_choice(String(_field_node.get("id", "")), String(choice.get("id", "")))
	if result.has("error"):
		_field_dialogue_label.text = String(result.error)
		return
	_clear_children(_field_choice_box)
	_field_lines = result.get("after_dialogue", []).duplicate(true)
	_pending_next_field_node_id = String(result.get("next_field_node_id", ""))
	_field_speaker_label.text = "선택 결과"
	_field_dialogue_label.text = "‘%s’를 선택했습니다. 현장 기록과 팀 반응을 확인합니다." % String(choice.get("label", "행동"))
	_present_support_lines(_field_lines)
	_set_ui_mode("FIELD_DIALOGUE")
	_field_next_button.text = "다음 조사"
	_field_next_button.visible = not _pending_next_field_node_id.is_empty()
	_refresh_case_status()


func _refresh_record_learning() -> void:
	_clear_children(_learning_list)
	var title := Label.new()
	title.text = "오대응 학습 기록"
	_learning_list.add_child(title)
	var learning := GameState.get_recovery_pattern_learning()
	if learning.is_empty():
		var empty := Label.new()
		empty.text = "아직 기록된 오대응이 없습니다."
		_learning_list.add_child(empty)
		return
	for pattern_id in learning:
		var record: Dictionary = learning[pattern_id]
		var label := Label.new()
		label.text = "- %s" % String(record.get("reason", "대응 결과를 재검토해야 합니다."))
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		_learning_list.add_child(label)

func _add_title(parent: Control) -> void:
	var title := Label.new()
	title.text = "현장 조사 / 선택 진행"
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
	var point_copy := point.duplicate(true)
	var card := ActionChoiceCardScene.instantiate()
	var is_unlocked := _is_point_unlocked(point)
	var label := String(point.get("label", "조사 포인트"))
	parent.add_child(card)
	card.configure({
		"id": String(point.get("id", label)),
		"title": label if is_unlocked else "[잠김] %s" % label,
		"description": String(point.get("summary", point.get("locked_text", "조사할 지점을 선택합니다."))),
		"meta": "조사 가능" if is_unlocked else "조건 부족"
	})
	card.action_requested.connect(func(_action_id: String) -> void: _inspect_point(point_copy))


func _inspect_point(point: Dictionary) -> void:
	if not _is_point_unlocked(point):
		_result_label.text = "선택 결과: 이 수사 방식은 아직 실행할 수 없습니다.\n잠김 이유: %s\n다음 선택지: 확보한 단서를 대조하거나 다른 현장을 관찰합니다." % String(point.get("locked_text", "아직 확인할 근거가 부족합니다."))
		_hint_label.text = "이번 조사 힌트: 조건을 만족하면 이 조사 포인트를 다시 확인할 수 있습니다."
		_result_toast.visible = true
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
	if collected_now:
		_present_log_tutorial("field_first_clue")
	_refresh_case_status()

	var next_scene_path := String(point.get("next_scene_path", ""))
	if not next_scene_path.is_empty():
		GameState.set_current_scene_path(next_scene_path)
		GameState.save_game()
		get_tree().change_scene_to_file(next_scene_path)


func _make_point_result_text(point: Dictionary, clue_id: String, was_collected: bool, collected_now: bool) -> String:
	var result_text := String(point.get("result_text", "조사 결과가 기록되었습니다."))
	if clue_id.is_empty():
		return "선택 결과: %s\n새 정보: 연결된 단서 없음\n상태 변화: 없음\n요원 반응: 현장 기록을 보류합니다.\n다음 선택지: 다른 조사 포인트나 회수/안정화 조건을 확인" % result_text

	var clue := _find_clue(clue_id)
	if clue.is_empty():
		return "선택 결과: %s\n새 정보: 연결된 단서 기록을 찾지 못했습니다.\n상태 변화: 없음\n요원 반응: 기록국 단말기로 데이터 확인을 요청합니다.\n다음 선택지: 다른 조사 포인트 확인" % result_text

	if collected_now:
		return "선택 결과: %s\n새 정보: 새 단서 획득 - %s\n%s\n상태 변화: 단서 수집률이 갱신되었습니다.\n요원 반응: 팀이 이 단서를 회수 근거로 기록합니다.\n다음 선택지: 단서 추적을 확인하고 다음 조사 포인트 선택" % [
			result_text,
			clue.get("title", ""),
			clue.get("description", "")
		]

	if was_collected:
		return "선택 결과: %s\n새 정보: 이미 확인한 단서 - %s\n상태 변화: 없음\n요원 반응: 팀이 기존 기록과 대조합니다.\n다음 선택지: 남은 미수집 단서 또는 회수/안정화 조건 확인" % [
			result_text,
			clue.get("title", "")
		]

	return "선택 결과: %s\n새 정보: 단서 상태 변화 없음\n요원 반응: 다음 현장 기록을 확인합니다.\n다음 선택지: 다른 조사 포인트 확인" % result_text


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
	_set_ui_mode("METHOD_PICKER")
	_points_box.visible = true
	_clear_children(_method_button_box)
	_method_title_label.text = "%s 수사 방식 선택" % String(point.get("label", "조사 포인트"))
	_method_result_label.text = String(point.get("result_text", "어떤 방식으로 조사할지 선택하세요."))
	_result_label.text = "상황: 팀이 현장을 확인했습니다.\n선택지: 관찰·분석·강행 진입 중 한 가지 수사 방식을 고르면 결과가 기록됩니다."
	_hint_label.text = "이번 조사 힌트: 편성 요원 중 해당 능력치가 가장 높은 1명이 판단을 보조합니다."

	var method_options: Variant = point.get("method_options", [])
	if typeof(method_options) != TYPE_ARRAY:
		return

	for method in method_options:
		if typeof(method) != TYPE_DICTIONARY:
			continue

		var point_copy := point.duplicate(true)
		var method_copy: Dictionary = method.duplicate(true)
		var approach_type := String(method.get("approach_type", method.get("method_type", "")))
		var best_agent := GameState.find_best_agent_for_ability(approach_type)
		var agent_id := String(best_agent.get("id", ""))
		var card := ActionChoiceCardScene.instantiate()
		_method_button_box.add_child(card)
		card.configure({
			"id": String(method_copy.get("id", method_copy.get("method_type", "method"))),
			"title": _make_method_button_text(method_copy).get_slice("\n", 0),
			"description": String(method_copy.get("summary", "")),
			"meta": "담당 %s · %s %d · 난이도 %d" % [String(best_agent.get("name", "팀")), GameState.ABILITY_LABELS.get(approach_type, approach_type), GameState.get_agent_ability(agent_id, approach_type), int(method_copy.get("difficulty", 0))]
		})
		card.action_requested.connect(func(_action_id: String) -> void: _run_method_option(point_copy, method_copy))

		# Show responsible agent and ability info for this approach
		if not best_agent.is_empty():
			var ability_val := GameState.get_agent_ability(agent_id, approach_type)
			var tags := _to_string_array(method.get("situation_tags", []))
			var aspect := GameState.get_aspect_modifier(agent_id, approach_type, tags)
			var info_lines: Array = ["  → 담당: %s / %s 능력치 %d" % [
				String(best_agent.get("name", "")),
				GameState.ABILITY_LABELS.get(approach_type, approach_type),
				ability_val
			]]
			if aspect.value > 0:
				info_lines.append("  → 특성 보정: +%d (%s: %s)" % [aspect.value, aspect.aspect_name, aspect.reason])
			card.tooltip_text = "\n".join(info_lines)


func _run_method_option(point: Dictionary, method: Dictionary) -> void:
	var result := GameState.resolve_investigation_method(String(point.get("id", "")), method)
	if result.has("error"):
		_method_result_label.text = String(result.get("error", "조사 방법 판정에 실패했습니다."))
		return

	_method_result_label.text = _make_method_result_text(result)
	_result_label.text = _make_method_result_text(result)
	_result_toast.visible = true
	_set_ui_mode("RESULT")

	var hint_texts_value: Variant = result.get("hint_texts", [])
	var hint_texts: Array = hint_texts_value if typeof(hint_texts_value) == TYPE_ARRAY else []
	if hint_texts.is_empty():
		_hint_label.text = "이번 조사 힌트: 이번 판정으로 새로 확인한 힌트가 없습니다."
	else:
		_hint_label.text = "이번 조사 힌트\n- %s" % "\n- ".join(hint_texts)
	var new_clue_ids: Array = result.get("new_clue_ids", [])
	if not new_clue_ids.is_empty():
		_present_log_tutorial("field_first_clue")

	_refresh_case_status()


func _present_log_tutorial(tutorial_id: String) -> void:
	if _log_guide == null:
		return
	if _log_guide.is_sequence_active():
		return
	_log_guide.set_internal_advance_enabled(true)
	if not GameState.has_seen_log_tutorial(tutorial_id):
		_log_guide.present_tutorial(tutorial_id, true)
		_log_guide.sequence_finished.connect(func() -> void: GameState.claim_log_tutorial(tutorial_id), CONNECT_ONE_SHOT)
	else:
		_log_guide.show_compact_hint(LogTutorialCatalog.get_repeat_hint(tutorial_id))


func _make_method_button_text(method: Dictionary) -> String:
	var method_label := String(method.get("label", "조사 방법"))
	match String(method.get("method_type", "")):
		"observation":
			method_label = "관찰한다"
		"analysis":
			method_label = "분석한다"
		"destruction":
			method_label = "강행 진입한다"
	return "%s / 능력치: %s / 난이도: %d\n%s" % [
		method_label,
		String(method.get("stat_key", method.get("method_type", ""))),
		int(method.get("difficulty", 0)),
		String(method.get("summary", ""))
	]


func _make_method_result_text(result: Dictionary) -> String:
	var success_text := "성공" if bool(result.get("successful", false)) else "실패"
	var lines: Array = [
		"현재 상황: %s" % String(result.get("result_text", "현장 판정 결과를 기록합니다.")),
		"수사 방식: %s" % String(result.get("method_label", "")),
		"판정 결과: %s · %s" % [success_text, String(result.get("result_grade", "failure"))],
		"판정식: 플레이어 %d + 도우미 %s %d = 점수 %d / 난이도 %d · 성공률 %d%% · 1d100 %d" % [
			int(result.get("player_stat", 0)),
			String(result.get("helper_agent_name", "도우미 없음")),
			int(result.get("helper_stat", 0)),
			int(result.get("total", 0)),
			int(result.get("difficulty", 0)),
			int(result.get("chance", 0)),
			int(result.get("dice", 0))
		]
	]

	var new_clue_ids_value: Variant = result.get("new_clue_ids", [])
	var new_clue_ids: Array = new_clue_ids_value if typeof(new_clue_ids_value) == TYPE_ARRAY else []
	if new_clue_ids.is_empty():
		lines.append("확보 근거: 이번 판정에서 새 단서는 확보하지 못했습니다.")
	else:
		lines.append("확보 근거: 새 단서 %s" % ", ".join(_clue_titles(new_clue_ids)))

	var hint_texts_value: Variant = result.get("hint_texts", [])
	var hint_texts: Array = hint_texts_value if typeof(hint_texts_value) == TYPE_ARRAY else []
	if hint_texts.is_empty():
		lines.append("추론 방향: 새 힌트 없음 — 확보한 단서와 현장 상태를 다시 대조합니다.")
	else:
		lines.append("추론 방향 (힌트는 단서가 아님)\n- %s" % "\n- ".join(hint_texts))

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
		lines.append("괴이 위험도가 한계에 도달했습니다. 회수/안정화 버튼으로 강제 회수전에 진입할 수 있습니다.")

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
		lines.append("다음 판단: 기록에서 확보 근거를 다시 확인한 뒤, 회수/안정화 시도를 준비합니다.")
	else:
		lines.append("다음 판단: 조사 포인트를 더 확인해 단서 수집률을 올립니다.")

	return "\n".join(lines)


func _hide_method_panel() -> void:
	if _method_panel != null:
		_method_panel.visible = false
		_dialogue_dock.visible = true


func _set_ui_mode(mode: String) -> void:
	if _mode_label != null:
		_mode_label.text = mode
	var choice_scroll := get_node_or_null("%FieldChoiceScroll") as ScrollContainer
	if choice_scroll != null:
		choice_scroll.visible = mode == "FIELD_CHOICES"
	var uses_method_picker := mode == "METHOD_PICKER"
	if _point_method_dock != null:
		_point_method_dock.visible = true
		if uses_method_picker:
			_point_method_dock.anchor_left = 0.014
			_point_method_dock.anchor_top = 0.42
			_point_method_dock.anchor_right = 0.986
			_point_method_dock.anchor_bottom = 0.96
		else:
			_point_method_dock.anchor_left = 0.014
			_point_method_dock.anchor_top = 0.2
			_point_method_dock.anchor_right = 0.27
			_point_method_dock.anchor_bottom = 0.96
	if _method_column != null:
		_method_column.visible = uses_method_picker
	if _dialogue_dock != null:
		_dialogue_dock.visible = not uses_method_picker
	if _manual_panel != null:
		_manual_panel.visible = not uses_method_picker
	if _result_toast != null and mode != "RESULT":
		_result_toast.visible = false


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
	if _case_summary_label != null:
		_case_summary_label.text = "단서 %d/%d · %s" % [collected_count, total_count, GameState.get_resolution_label()]
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
	if _team_label != null:
		var team_text := GameState.get_selected_agent_summary()
		_team_label.text = "투입 팀: %s" % (team_text if not team_text.is_empty() else "미편성")
		if support_texts.is_empty():
			_team_label.text += "\n팀 반응: 아직 별도 보조 기록이 없습니다."
		else:
			_team_label.text += "\n팀 보조: %s" % " / ".join(support_texts)
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
		if not bool(clue.get("collected", false)):
			continue

		var label := Label.new()
		var description := String(clue.get("description", ""))
		label.text = "확보 - %s\n%s" % [clue.get("title", ""), description]
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		_clue_list.add_child(label)


func _refresh_hint_list() -> void:
	_clear_children(_hint_list)
	for hint in GameState.get_hints():
		if typeof(hint) != TYPE_DICTIONARY:
			continue

		var hint_id := String(hint.get("id", ""))
		var seen := GameState.has_seen_hint(hint_id)
		if not seen:
			continue
		var label := Label.new()
		label.text = "추론 - %s" % String(hint.get("text", ""))
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		_hint_list.add_child(label)


func _find_clue(clue_id: String) -> Dictionary:
	for clue in GameState.get_clues():
		if typeof(clue) == TYPE_DICTIONARY and clue.get("id", "") == clue_id:
			return clue
	return {}


func _clue_titles(clue_ids: Array) -> Array[String]:
	var titles: Array[String] = []
	for clue_id in clue_ids:
		var clue := _find_clue(String(clue_id))
		titles.append(String(clue.get("title", "새 단서")))
	return titles


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
	_resolution_warning_label.text = "회수 전 확인: 기록의 ‘확보’는 회수 근거이고, ‘추론’은 다시 볼 방향입니다.\n위험 안내: %s" % GameState.get_resolution_phase_warning()
	_resolution_confirm_panel.visible = true


func _start_resolution_attempt() -> void:
	if not GameState.start_resolution_phase():
		_result_label.text = "회수/안정화 불가: 단서 수집률이 40% 이상이어야 합니다."
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


func _to_string_array(value: Variant) -> Array:
	var result: Array = []
	if typeof(value) != TYPE_ARRAY:
		return result
	for item in value:
		var text := String(item).strip_edges()
		if not text.is_empty():
			result.append(text)
	return result


func _add_navigation(parent: Control) -> void:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 6)
	parent.add_child(row)
	_add_scene_button(row, "메뉴", "res://scenes/main_menu.tscn")
	_add_scene_button(row, "데이터", "res://scenes/case_data_scene.tscn")
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
