# CORE-VALIDATION-001 1C 데이터베이스 상세가 작은 화면에서도 스크롤로 전부 접근되는지 검증한다.
extends SceneTree

const TestSaveGuard = preload("res://tests/test_save_guard.gd")
const AFTERLIFE_PATH := "res://data/episodes/episode_001_afterlife_station.json"

var _guard := TestSaveGuard.new()
var _failures: Array[String] = []
var _game_state: Node


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	_game_state = root.get_node_or_null("GameState")
	if _game_state == null:
		_failures.append("GameState autoload is unavailable")
		_finish()
		return
	var guard_error := _guard.prepare(_game_state.get_save_file_path())
	if not guard_error.is_empty():
		_failures.append(guard_error)
		_finish()
		return
	root.get_window().size = Vector2i(1280, 720)
	_game_state.reset_run_state()
	_expect(_game_state.load_episode(AFTERLIFE_PATH), "afterlife station loads")
	_seed_manual_records()
	if change_scene_to_file("res://scenes/database_view.tscn") != OK:
		_failures.append("database view failed to load")
		_finish()
		return
	for _frame in range(8):
		await process_frame
	current_scene.call("_show_section", "anomaly_manual_records")
	for _frame in range(8):
		await process_frame

	var section_scroll := current_scene.find_child("DatabaseSectionScroll", true, false) as ScrollContainer
	var detail_scroll := current_scene.find_child("DatabaseDetailScroll", true, false) as ScrollContainer
	var detail_items := current_scene.find_child("DatabaseDetailItems", true, false) as VBoxContainer
	_expect(section_scroll != null, "database section navigation uses its own scroll container")
	if section_scroll != null:
		_expect(section_scroll.focus_mode == Control.FOCUS_ALL, "section navigation scroll is keyboard focusable")
		_expect(section_scroll.get_v_scroll_bar().max_value > section_scroll.get_v_scroll_bar().page, "all database section buttons remain reachable at 720p")
	_expect(detail_scroll != null, "database detail uses a named scroll container")
	_expect(detail_items != null, "manual record items remain inside the detail scroll")
	if detail_scroll != null and detail_items != null:
		_expect(detail_scroll.focus_mode == Control.FOCUS_ALL, "detail scroll is keyboard focusable")
		_expect(detail_scroll.horizontal_scroll_mode == ScrollContainer.SCROLL_MODE_DISABLED, "detail scroll never hides content horizontally")
		var bar := detail_scroll.get_v_scroll_bar()
		_expect(bar != null and bar.max_value > bar.page, "long manual content produces vertical scroll range")
		var danger_panel := current_scene.find_child("AnomalyManualDangerCases", true, false) as Control
		_expect(danger_panel != null, "danger-case panel remains in the scrollable detail tree")
		if bar != null and danger_panel != null:
			detail_scroll.ensure_control_visible(danger_panel)
			for _frame in range(4):
				await process_frame
			_expect(detail_scroll.scroll_vertical > 0, "manual detail can move to the danger-case region")
			var scroll_rect := detail_scroll.get_global_rect()
			var danger_rect := danger_panel.get_global_rect()
			var viewport_rect := root.get_viewport().get_visible_rect()
			_expect(scroll_rect.end.y <= viewport_rect.end.y + 1.0, "detail scroll is constrained inside the 720p viewport")
			_expect(danger_rect.position.y >= scroll_rect.position.y - 1.0 and danger_rect.end.y <= scroll_rect.end.y + 1.0, "danger-case panel can be fully revealed inside the viewport")
		_expect(_has_text(detail_items, "위험 사례"), "danger-case heading remains available")
	_finish()


func _seed_manual_records() -> void:
	var official := _context(true, "cut_false_broadcast", "검증 완료", ["clue_repeating_announcement", "clue_missing_terminal_sign"], ["반복 안내방송 원본", "목적지 표기 공백"])
	var candidate := _context(false, "trace_victim_time", "대응 확인·근거 일부", ["clue_last_message"], ["00:00 고정 문자"])
	var danger := _context(false, "follow_terminal", "현장 대응 실패", ["clue_missing_terminal_sign"], ["목적지 표기 공백"])
	_game_state.record_recovery_pattern_outcome("pattern_station_false_terminal", "follow_terminal", false, "공식 기록으로 검증되지 않은 목적지를 따르면 개인 기억이 괴이 노선으로 고정된다.", danger)
	_game_state.record_recovery_pattern_outcome("pattern_station_false_terminal", "cut_false_broadcast", true, "가설·근거·대응 검증 완료", official)
	_game_state.record_recovery_pattern_outcome("pattern_station_gaze_lure", "trace_victim_time", true, "대응은 확인했지만 작성 근거 일부만 선택했다.", candidate)


func _context(verified: bool, response_id: String, verification_label: String, evidence_ids: Array, evidence_titles: Array) -> Dictionary:
	var is_candidate := response_id == "trace_victim_time"
	var is_wrong := response_id == "follow_terminal"
	return {
		"guided": true,
		"episode_id": "episode_001_afterlife_station",
		"episode_title": "저승역",
		"pattern_name": "시선과 동선 불일치" if is_candidate else "목적지 기록 충돌",
		"question": "현재 기록으로 어떤 규칙을 검증할 수 있는가?",
		"manual_draft": "괴이의 현재 행동보다 사건 전부터 남은 피해자 기록을 우선 대조한다." if is_candidate else "개인에게 들리는 목적지와 공식 운행 기록을 분리해 검증한다.",
		"response_label": "시선을 따르지 않고 피해자의 시간 기록으로 동선을 고정한다" if is_candidate else ("전광판이 가리키는 승강장을 실제 종착지로 보고 이동한다" if is_wrong else "방송 공백과 전광판 차이를 대조해 안내 신호를 차단한다"),
		"selected_hypothesis_response_id": response_id,
		"hypothesis": "역무원의 시선은 피해자의 실제 동선과 반대 방향으로 유도하는 현상이다." if is_candidate else ("사라지기 전 마지막 표기가 안전한 실제 종착지다." if is_wrong else "전광판의 목적지는 객관적 노선이 아니라 방송 공백을 개인 기억이 채운 결과다."),
		"authored_supporting_clue_ids": ["clue_repeating_announcement", "clue_missing_terminal_sign"],
		"authored_supporting_clue_titles": ["반복 안내방송 원본", "목적지 표기 공백"],
		"selected_evidence_ids": evidence_ids,
		"selected_evidence_titles": evidence_titles,
		"selected_contradicted_clue_ids": [],
		"reasoning": "확보 기록을 비교해 규칙과 대응의 연결을 검증한다.",
		"response_reasoning": "현장 대응 결과를 기록한다.",
		"verification_label": verification_label,
		"verified": verified
	}


func _has_text(node: Node, fragment: String) -> bool:
	for child in node.find_children("*", "Label", true, false):
		if String(child.text).contains(fragment):
			return true
	return false


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	var restore_error := _guard.restore()
	if not restore_error.is_empty():
		_failures.append(restore_error)
	if _failures.is_empty():
		print("CORE VALIDATION DATABASE SCROLL: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
