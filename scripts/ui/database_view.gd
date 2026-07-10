# 데이터베이스 화면의 섹션 선택과 완료 사건 기록 표시를 관리한다.
extends Control

var _section_list: VBoxContainer
var _detail_title: Label
var _detail_summary: Label
var _detail_items: VBoxContainer


func _ready() -> void:
	if GameState.get_current_episode().is_empty():
		GameState.load_episode()
	_build_ui()
	_show_section("overview")


func _build_ui() -> void:
	var background := ColorRect.new()
	background.color = Color(0.045, 0.047, 0.055, 1.0)
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_top", 24)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_bottom", 24)
	add_child(margin)

	var layout := VBoxContainer.new()
	layout.add_theme_constant_override("separation", 12)
	margin.add_child(layout)

	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 8)
	layout.add_child(header)

	var back_button := Button.new()
	back_button.text = "뒤로"
	back_button.pressed.connect(_back_to_menu)
	header.add_child(back_button)

	var prepare_button := Button.new()
	prepare_button.text = "사건 준비"
	prepare_button.pressed.connect(_open_preparation)
	header.add_child(prepare_button)

	var title := Label.new()
	title.text = "기록국 데이터베이스"
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	header.add_child(title)

	var body := HBoxContainer.new()
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 10)
	layout.add_child(body)

	var left_panel := PanelContainer.new()
	left_panel.custom_minimum_size = Vector2(170, 0)
	body.add_child(left_panel)

	_section_list = VBoxContainer.new()
	_section_list.add_theme_constant_override("separation", 6)
	left_panel.add_child(_section_list)

	var right_panel := PanelContainer.new()
	right_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	body.add_child(right_panel)

	var detail := VBoxContainer.new()
	detail.add_theme_constant_override("separation", 10)
	right_panel.add_child(detail)

	_detail_title = Label.new()
	_detail_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_detail_title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	detail.add_child(_detail_title)

	_detail_summary = Label.new()
	_detail_summary.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	detail.add_child(_detail_summary)

	_detail_items = VBoxContainer.new()
	_detail_items.add_theme_constant_override("separation", 6)
	detail.add_child(_detail_items)

	_build_section_buttons()


func _build_section_buttons() -> void:
	for section in UrbanLegendState.get_sections():
		var button := Button.new()
		button.text = section.get("title", "섹션")
		button.pressed.connect(func() -> void:
			_show_section(section.get("id", "overview"))
		)
		_section_list.add_child(button)

	var mvp13_button := Button.new()
	mvp13_button.text = "MVP-013 보상"
	mvp13_button.pressed.connect(func() -> void:
		_show_section("mvp13_rewards")
	)
	_section_list.add_child(mvp13_button)

	var completed_reports_button := Button.new()
	completed_reports_button.text = "완료 사건 기록"
	completed_reports_button.pressed.connect(func() -> void:
		_show_section("completed_case_reports")
	)
	_section_list.add_child(completed_reports_button)


func _show_section(section_id: String) -> void:
	if section_id == "mvp13_rewards":
		_show_mvp13_rewards()
		return
	if section_id == "completed_case_reports":
		_show_completed_case_reports()
		return

	var section := UrbanLegendState.get_section(section_id)
	_detail_title.text = section.get("title", "섹션")
	_detail_summary.text = section.get("summary", "")
	_clear_detail_items()

	for item in section.get("items", []):
		var label := Label.new()
		label.text = "- %s" % item
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		_detail_items.add_child(label)


func _show_mvp13_rewards() -> void:
	_detail_title.text = "MVP-013 기록물 / 연구 보상 / 장비"
	_detail_summary.text = "회수 결과로 해금된 기록국 보상 상태입니다. 완성형 도감이 아니라 현재 해금 여부를 확인하는 1차 DB 화면입니다."
	_clear_detail_items()
	_add_dynamic_entry_list("해금 기록물", GameState.get_unlocked_record_entries(), "title", "description")
	_add_dynamic_entry_list("연구 보상", GameState.get_unlocked_research_reward_entries(), "ability_name", "ability_description")
	_add_dynamic_entry_list("해금 장비", GameState.get_unlocked_equipment_entries(), "name", "description")
	_add_dynamic_entry_list("장착 장비", GameState.get_equipped_equipment_entries(), "name", "description")
	var modifier_label := Label.new()
	modifier_label.text = "- 다음 조사 보정: %s" % GameState.get_next_investigation_modifier_text()
	modifier_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_detail_items.add_child(modifier_label)


func _show_completed_case_reports() -> void:
	_detail_title.text = "완료 사건 기록"
	_detail_summary.text = "회수에 성공한 사건 보고서를 다시 확인합니다. 각 사건은 최신 기록 1개만 보관합니다."
	_clear_detail_items()

	var reports := GameState.get_completed_case_reports()
	if reports.is_empty():
		_add_detail_text("아직 저장된 완료 사건 보고서가 없습니다. 괴이 핵 회수에 성공하면 결과 화면에서 자동 기록됩니다.")
		return

	var report_detail := VBoxContainer.new()
	report_detail.add_theme_constant_override("separation", 6)
	_detail_items.add_child(report_detail)
	for report in reports:
		if typeof(report) != TYPE_DICTIONARY:
			continue
		var report_data: Dictionary = report.duplicate(true)
		var report_button := Button.new()
		report_button.text = "%s / %s" % [
			String(report_data.get("episode_title", "완료 사건")),
			String(report_data.get("resolution_label", "해결 기록"))
		]
		report_button.pressed.connect(func() -> void:
			_show_completed_case_report(report_data, report_detail)
		)
		_detail_items.add_child(report_button)

	_show_completed_case_report(reports[0], report_detail)


func _show_completed_case_report(report: Dictionary, parent: VBoxContainer) -> void:
	_clear_children(parent)
	_add_detail_text("선택 보고서: %s" % String(report.get("episode_title", "완료 사건")), parent)
	_add_detail_text("기록 시각: %s / 해결 등급: %s / 단서 수집률: %.0f%%" % [
		String(report.get("completed_at_label", "기록 시각 없음")),
		String(report.get("resolution_label", "해결 불가")),
		float(report.get("clue_collection_rate", 0.0))
	], parent)
	_add_report_entries("수집 단서", report.get("collected_clues", []), "title", "description", parent)
	_add_minigame_entries(report.get("minigame_results", {}), parent)
	_add_detail_text("괴이 핵 회수 결과: %s" % _make_recovery_text(report.get("recovery_result", {})), parent)
	_add_report_entries("연구 보상", report.get("unlocked_research_rewards", []), "ability_name", "ability_description", parent)
	_add_report_entries("해금 기록물", report.get("unlocked_records", []), "title", "description", parent)
	_add_report_entries("해금 장비", report.get("unlocked_equipment", []), "name", "description", parent)
	_add_agent_entries(report.get("selected_agents", []), parent)
	_add_report_entries("발생한 요원 이벤트", report.get("triggered_agent_events", []), "title", "text", parent)
	_add_text_entries("요원 보조 안내", report.get("agent_support_texts", []), parent)
	_add_text_entries("다음 사건 참고", report.get("next_case_notes", []), parent)

	var records: Array = report.get("unlocked_records", [])
	var equipment: Array = report.get("unlocked_equipment", [])
	if not records.is_empty() or not equipment.is_empty():
		_add_detail_text("연결 안내: 이 사건의 기록물은 다음 사건 준비에서 참고할 수 있고, 해금 장비는 준비 화면에서 장착할 수 있습니다.", parent)


func _add_minigame_entries(results: Dictionary, parent: VBoxContainer) -> void:
	var lines: Array = []
	for minigame_id in results:
		var result: Variant = results.get(minigame_id, {})
		if typeof(result) == TYPE_DICTIONARY:
			var minigame := GameState.get_minigame(String(minigame_id))
			var state := "성공" if bool(result.get("successful", false)) else "실패"
			lines.append("%s: %s - %s" % [
				String(minigame.get("title", minigame_id)),
				state,
				String(result.get("result_text", "결과가 기록되었습니다."))
			])
	_add_text_entries("미니게임 기록", lines, parent)


func _add_agent_entries(agents: Array, parent: VBoxContainer) -> void:
	var lines: Array = []
	for agent in agents:
		if typeof(agent) == TYPE_DICTIONARY:
			lines.append("%s (%s): 수사 파트너 신뢰도 %+d" % [
				String(agent.get("name", "요원")),
				String(agent.get("temperament_label", "")),
				int(agent.get("trust", 0))
			])
	_add_text_entries("선택 요원", lines, parent)


func _add_report_entries(title: String, entries: Array, name_key: String, description_key: String, parent: VBoxContainer) -> void:
	var lines: Array = []
	for entry in entries:
		if typeof(entry) == TYPE_DICTIONARY:
			lines.append("%s: %s" % [String(entry.get(name_key, "")), String(entry.get(description_key, ""))])
	_add_text_entries(title, lines, parent)


func _make_recovery_text(result: Dictionary) -> String:
	if result.is_empty() or not bool(result.get("successful", false)):
		return "회수 기록 없음"
	return "%s / 상태: %s / 안정도 %d" % [
		String(result.get("description", "회수 성공")),
		String(result.get("result_status", "기록됨")),
		int(result.get("anomaly_stability", 100))
	]


func _add_text_entries(title: String, lines: Array, parent: VBoxContainer) -> void:
	if lines.is_empty():
		_add_detail_text("%s: 없음" % title, parent)
		return
	_add_detail_text("%s\n- %s" % [title, "\n- ".join(lines)], parent)


func _add_detail_text(text: String, parent: VBoxContainer = _detail_items) -> void:
	var label := Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	parent.add_child(label)


func _add_dynamic_entry_list(title: String, entries: Array, name_key: String, description_key: String) -> void:
	var title_label := Label.new()
	title_label.text = title
	title_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_detail_items.add_child(title_label)
	if entries.is_empty():
		var empty_label := Label.new()
		empty_label.text = "- 아직 해금된 항목이 없습니다."
		empty_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		_detail_items.add_child(empty_label)
		return

	for entry in entries:
		if typeof(entry) != TYPE_DICTIONARY:
			continue
		var label := Label.new()
		label.text = "- %s: %s" % [
			String(entry.get(name_key, "")),
			String(entry.get(description_key, ""))
		]
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		_detail_items.add_child(label)


func _clear_detail_items() -> void:
	_clear_children(_detail_items)


func _clear_children(parent: Node) -> void:
	for child in parent.get_children():
		child.queue_free()


func _back_to_menu() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _open_preparation() -> void:
	GameState.set_current_scene_path(GameState.SCENE_PREPARATION)
	GameState.save_game()
	get_tree().change_scene_to_file(GameState.SCENE_PREPARATION)
