# 결과 화면의 회수 결과, 연구 보상, 기록물과 장비 해금을 표시한다.
extends Control

const ThemeFactory = preload("res://scripts/ui/ui_theme_factory.gd")

const MinigameResultFormatter = preload("res://scripts/minigames/minigame_result_formatter.gd")
const LogGuideScript = preload("res://scripts/ui/log_guide.gd")
const LogTutorialCatalog = preload("res://scripts/ui/log_tutorial_catalog.gd")


func _ready() -> void:
	theme = ThemeFactory.create_theme()
	if GameState.get_current_episode().is_empty():
		GameState.load_episode()

	GameState.set_current_scene_path("res://scenes/result_scene.tscn")
	GameState.record_current_case_report()
	_build_ui()


func _build_ui() -> void:
	var background := ColorRect.new()
	background.color = Color(0.045, 0.048, 0.06, 1.0)
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
	title.text = "괴이 매뉴얼 갱신 / 안정화 결과" if GameState.get_current_episode_id() == "episode_001_afterlife_station" else "사건 보고서 / 잔향 회수 결과"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	root.add_child(title)
	var log_guide: LogGuide = LogGuideScript.new()
	log_guide.set_compact(true)
	root.add_child(log_guide)
	if not GameState.has_seen_log_tutorial("result_first_case"):
		log_guide.present_tutorial("result_first_case", true)
		log_guide.sequence_finished.connect(func() -> void: GameState.claim_log_tutorial("result_first_case"), CONNECT_ONE_SHOT)
	else:
		log_guide.show_compact_hint(LogTutorialCatalog.get_repeat_hint("result_first_case"))

	_add_result_panel(root)
	_add_reasoning_summary_panel(root)
	_add_case_report_panel(root)
	_add_save_state_panel(root)
	_add_navigation_buttons(root)


func _add_result_panel(parent: Control) -> void:
	var afterlife := GameState.get_current_episode_id() == "episode_001_afterlife_station"
	var content := _add_section(parent, "안정화 결과" if afterlife else "잔향 회수 결과", "현재 출현을 안정화하고 대응 절차를 기록합니다." if afterlife else "잔향 회수 뒤 현재 사건의 결말과 보상을 확인합니다.")

	content.add_child(_make_label("에피소드명: %s" % GameState.get_current_episode_title()))
	content.add_child(_make_label("회수/안정화 등급: %s" % GameState.get_result_resolution_label()))
	content.add_child(_make_label("피해자 구조 결과: %s" % GameState.get_current_victim_rescue_result()))
	content.add_child(_make_label("피해자 후일담: %s" % GameState.get_current_victim_after_story()))
	content.add_child(_make_label("저승역 반복 안내 잔향 회수 상태: %s" % _make_recovery_status_text()) if afterlife else _make_label("잔향 회수 상태: %s" % _make_recovery_status_text()))
	if afterlife:
		var route_result := GameState.get_minigame_result("minigame_frequency_sync")
		if not route_result.is_empty():
			_add_text_list(content, "안전 노선 검증 기록", [
				String(route_result.get("final_clue_title", "안전 노선 검증 기록")),
				String(route_result.get("final_clue_text", "공식 운행 기록과 현장 경로가 일치했습니다.")),
				"검증 등급: %s" % String(route_result.get("clear_grade_label", "일반 복원"))
			])
		_add_manual_record_summary(content, GameState.get_current_anomaly_manual_record())
	content.add_child(_make_label("현재 잔향 파편: %d · 사건 준비의 외부 접점에서 사용할 수 있습니다." % GameState.get_echo_fragments()))
	_add_text_list(content, "연구 결과", [GameState.get_current_research_result()])
	_add_unlock_list(content, "기록물 획득", GameState.get_current_result_unlocked_records(), "title", "description")
	_add_unlock_list(content, "연구 보상", GameState.get_current_result_unlocked_research_rewards(), "ability_name", "ability_description")
	_add_unlock_list(content, "장비 해금", GameState.get_current_result_unlocked_equipment(), "name", "description")
	_add_text_list(content, "다음 조사 연결", [GameState.get_next_investigation_modifier_text()])

	var reward := GameState.get_current_result_research_reward()
	if reward.is_empty():
		_add_text_list(content, "기존 연구 보상", [])
		return

	_add_text_list(content, "기존 연구 보상", [
		"%s - %s" % [reward.get("ability_name", ""), reward.get("ability_description", "")],
		"다음 사건 영향: %s" % reward.get("next_episode_effect", "")
	])


func _add_case_report_panel(parent: Control) -> void:
	var report := GameState.get_case_report_summary()
	var content := _add_section(parent, "사건 보고서", "기록국 DB에 저장될 완료 사건 요약입니다.")
	content.add_child(_make_label("기록 상태: 이번 회수 정보는 사건 보고서와 기록국 DB에 저장되었습니다."))
	content.add_child(_make_label("사건명: %s" % String(report.get("episode_title", ""))))
	content.add_child(_make_label("회수/안정화 등급: %s / 단서 수집률: %.0f%%" % [
		String(report.get("resolution_label", "회수 불가")),
		float(report.get("clue_collection_rate", 0.0))
	]))
	_add_text_list(content, "수집한 단서", _make_entry_lines(report.get("collected_clues", []), "title", "description"))
	content.add_child(_make_label("확인한 힌트: %d건" % int(report.get("seen_hint_count", 0))))
	_add_text_list(content, "미니게임 기록", _make_minigame_lines(report.get("minigame_results", {})))
	content.add_child(_make_label("저승역 반복 안내 잔향 회수 결과: %s" % _make_report_recovery_text(report.get("recovery_result", {}))) if GameState.get_current_episode_id() == "episode_001_afterlife_station" else _make_label("잔향 회수 결과: %s" % _make_report_recovery_text(report.get("recovery_result", {}))))
	_add_manual_record_summary(content, report.get("anomaly_manual_record", {}))
	_add_text_list(content, "해금 기록물", _make_entry_lines(report.get("unlocked_records", []), "title", "description"))
	_add_text_list(content, "연구 보상", _make_entry_lines(report.get("unlocked_research_rewards", []), "ability_name", "ability_description"))
	_add_text_list(content, "해금 장비", _make_entry_lines(report.get("unlocked_equipment", []), "name", "description"))
	_add_text_list(content, "선택 요원과 수사 파트너 신뢰도", _make_agent_trust_lines(report.get("selected_agents", [])))
	_add_text_list(content, "발생한 요원 이벤트", _make_entry_lines(report.get("triggered_agent_events", []), "title", "text"))
	_add_text_list(content, "요원 보조 안내", report.get("agent_support_texts", []))
	_add_text_list(content, "다음 사건 참고", report.get("next_case_notes", []))


func _add_reasoning_summary_panel(parent: Control) -> void:
	var report := GameState.get_case_report_summary()
	var content := _add_section(parent, "이번 판단의 근거", "결과만 나열하지 않고, 무엇을 근거로 회수했고 무엇을 다음 조사에 남겼는지 확인합니다.")
	content.name = "ReasoningSummary"
	var clue_titles: Array = []
	for clue in report.get("collected_clues", []):
		if typeof(clue) == TYPE_DICTIONARY:
			clue_titles.append(String(clue.get("title", "이름 없는 단서")))
	_add_text_list(content, "확보 근거", clue_titles)
	content.add_child(_make_label("회수 판단 결과: %s" % _make_report_recovery_text(report.get("recovery_result", {}))))
	_add_text_list(content, "요원 기여", _make_agent_contribution_lines(report.get("selected_agents", [])))
	_add_text_list(content, "다음 판단", report.get("next_case_notes", []))


func _add_manual_record_summary(parent: Control, record_value: Variant) -> void:
	var record: Dictionary = record_value if typeof(record_value) == TYPE_DICTIONARY else {}
	if record.is_empty():
		_add_text_list(parent, "괴이 매뉴얼 갱신", ["이번 사건에서 공식 승격 또는 위험 사례로 저장된 판단이 없습니다."])
		return
	var verified_rules: Dictionary = record.get("verified_rules", {})
	var candidate_rules: Dictionary = record.get("candidate_rules", {})
	var danger_cases: Array = record.get("danger_cases", [])
	_add_text_list(parent, "공식 매뉴얼 규칙", _make_manual_entry_lines(verified_rules.values(), "검증 완료"))
	_add_text_list(parent, "검증 대기 후보", _make_manual_entry_lines(candidate_rules.values(), "후보"))
	_add_text_list(parent, "위험 사례", _make_danger_case_lines(danger_cases))


func _make_manual_entry_lines(entries: Array, fallback_status: String) -> Array:
	var lines: Array = []
	for value in entries:
		if typeof(value) != TYPE_DICTIONARY:
			continue
		var entry: Dictionary = value
		var evidence_titles: Array = entry.get("selected_evidence_titles", [])
		lines.append("%s [%s]
가설: %s
근거: %s
대응: %s" % [
			String(entry.get("manual_draft", entry.get("pattern_name", "규칙"))),
			String(entry.get("verification_label", fallback_status)),
			String(entry.get("hypothesis", "")),
			", ".join(evidence_titles) if not evidence_titles.is_empty() else "선택 근거 없음",
			String(entry.get("response_label", ""))
		])
	return lines


func _make_danger_case_lines(entries: Array) -> Array:
	var lines: Array = []
	for value in entries:
		if typeof(value) != TYPE_DICTIONARY:
			continue
		var entry: Dictionary = value
		lines.append("%s / 시도 %d회
가설: %s
선택 대응: %s
확인 결과: %s" % [
			String(entry.get("pattern_name", entry.get("pattern_id", "위험 사례"))),
			int(entry.get("attempts", 1)),
			String(entry.get("hypothesis", "")),
			String(entry.get("response_label", "")),
			String(entry.get("reason", "오대응 원인을 기록했습니다."))
		])
	return lines


func _add_save_state_panel(parent: Control) -> void:
	var summary := GameState.get_save_state_summary()
	var content := _add_section(parent, "저장 / 이어하기 상태", "이어하기 후 유지되어야 하는 완료 보고서와 현재 씬 경로를 점검합니다.")
	content.add_child(_make_label("저장 버전: %s / 현재 씬: %s" % [
		String(summary.get("save_version", "")),
		String(summary.get("current_scene_path", ""))
	]))
	content.add_child(_make_label("완료 보고서: %d건 / 괴이 매뉴얼: %d건 / 요원 신뢰 기록: %d명 / 기록물: %d건 / 장비: %d건 / 장착: %d건" % [
		int(summary.get("completed_report_count", 0)),
		int(summary.get("anomaly_manual_count", 0)),
		int(summary.get("agent_trust_count", 0)),
		int(summary.get("unlocked_record_count", 0)),
		int(summary.get("unlocked_equipment_count", 0)),
		int(summary.get("equipped_item_count", 0))
	]))
	content.add_child(_make_label("회수 결과 저장: %s / 다음 행동: 사건 준비 또는 기록국 DB에서 보고서를 재확인" % [
		"유지됨" if bool(summary.get("recovery_saved", false)) else "아직 없음"
	]))


func _add_section(parent: Control, title_text: String, description_text: String = "") -> VBoxContainer:
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(panel)

	var frame := VBoxContainer.new()
	frame.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	frame.add_theme_constant_override("separation", 8)
	panel.add_child(frame)
	var should_collapse := title_text in ["사건 보고서", "이번 판단의 근거", "저장 / 이어하기 상태"]
	var toggle := Button.new()
	toggle.text = title_text
	toggle.alignment = HORIZONTAL_ALIGNMENT_LEFT
	frame.add_child(toggle)
	var content := VBoxContainer.new()
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.add_theme_constant_override("separation", 8)
	content.visible = not should_collapse
	frame.add_child(content)
	toggle.pressed.connect(func() -> void:
		content.visible = not content.visible
	)

	if not description_text.is_empty():
		content.add_child(_make_label(description_text))

	return content


func _add_unlock_list(parent: Control, title: String, entries: Array, name_key: String, description_key: String) -> void:
	_add_text_list(parent, title, _make_entry_lines(entries, name_key, description_key))


func _make_entry_lines(entries: Array, name_key: String, description_key: String) -> Array:
	var lines: Array = []
	for entry in entries:
		if typeof(entry) != TYPE_DICTIONARY:
			continue
		lines.append("%s - %s" % [
			String(entry.get(name_key, "")),
			String(entry.get(description_key, ""))
		])
	return lines


func _make_minigame_lines(results: Dictionary) -> Array:
	var lines: Array = []
	for minigame_id in results:
		var result: Variant = results.get(minigame_id, {})
		if typeof(result) != TYPE_DICTIONARY:
			continue
		var minigame := GameState.get_minigame(String(minigame_id))
		var title := String(result.get("display_title", minigame.get("title", minigame_id)))
		lines.append(MinigameResultFormatter.make_report_line(title, result))
	return lines


func _make_agent_trust_lines(agents: Array) -> Array:
	var lines: Array = []
	for agent in agents:
		if typeof(agent) == TYPE_DICTIONARY:
			lines.append("%s (%s): 수사 파트너 신뢰 %+d / 사건 기여: %s" % [
				String(agent.get("name", "요원")),
				String(agent.get("temperament_label", "")),
				int(agent.get("trust", 0)),
				String(agent.get("role", "현장 보조"))
			])
	return lines


func _make_agent_contribution_lines(agents: Array) -> Array:
	var lines: Array = []
	for agent in agents:
		if typeof(agent) == TYPE_DICTIONARY:
			lines.append("%s: %s / 수사 파트너 신뢰 %+d" % [
				String(agent.get("name", "요원")),
				String(agent.get("role", "현장 보조")),
				int(agent.get("trust", 0))
			])
	return lines


func _make_report_recovery_text(result: Dictionary) -> String:
	if result.is_empty() or not bool(result.get("successful", false)):
		return "회수 기록 없음"
	return "%s / 상태: %s / 안정도 %d" % [
		String(result.get("description", "회수 성공")),
		String(result.get("result_status", "기록됨")),
		int(result.get("anomaly_stability", 100))
	]


func _add_text_list(parent: Control, title: String, lines: Array) -> void:
	var content := VBoxContainer.new()
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.add_theme_constant_override("separation", 4)
	parent.add_child(content)

	var title_label := Label.new()
	title_label.text = title
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	content.add_child(title_label)

	if lines.is_empty():
		content.add_child(_make_label("없음"))
		return
	content.add_child(_make_label("- %s" % "\n- ".join(lines)))


func _add_navigation_buttons(parent: Control) -> void:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	parent.add_child(row)

	var menu_button := Button.new()
	menu_button.text = "메인 메뉴로"
	menu_button.pressed.connect(func() -> void:
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	)
	row.add_child(menu_button)

	var restart_button := Button.new()
	restart_button.text = "저승역 다시 시작"
	restart_button.pressed.connect(func() -> void:
		var selected_agent_ids := GameState.get_selected_agent_ids()
		GameState.clear_save_file()
		GameState.restart_afterlife_station_flow(selected_agent_ids)
		GameState.set_current_scene_path(GameState.SCENE_PREPARATION)
		GameState.save_game()
		get_tree().change_scene_to_file(GameState.SCENE_PREPARATION)
	)
	row.add_child(restart_button)

	var prepare_button := Button.new()
	prepare_button.text = "현재 반일 결과 확인"
	prepare_button.pressed.connect(func() -> void:
		GameState.complete_campaign_slot({"kind": "investigation", "episode_id": GameState.get_current_episode_id()})
		GameState.set_current_scene_path(GameState.SCENE_PREPARATION)
		GameState.save_game()
		get_tree().change_scene_to_file(GameState.SCENE_PREPARATION)
	)
	row.add_child(prepare_button)

func _make_recovery_status_text() -> String:
	if GameState.is_recovery_successful():
		return "회수 성공 / 상태: %s / 안정도 %d" % [
			GameState.get_recovery_result_status(),
			GameState.get_recovery_result_stability()
		]
	return "회수 기록 없음"


func _make_label(text: String) -> Label:
	var label := Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return label
