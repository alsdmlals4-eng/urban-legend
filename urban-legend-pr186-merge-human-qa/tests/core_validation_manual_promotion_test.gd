# CORE-VALIDATION-001 1C의 후보·공식 규칙·위험 사례 저장과 이어하기를 검증한다.
extends SceneTree

const TestSaveGuard = preload("res://tests/test_save_guard.gd")
const AFTERLIFE_PATH := "res://data/episodes/episode_001_afterlife_station.json"
const PATTERN_ID := "pattern_station_false_terminal"
const CORRECT_RESPONSE_ID := "cut_false_broadcast"
const WRONG_RESPONSE_ID := "follow_terminal"

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
	_game_state.reset_run_state()
	_expect(_game_state.load_episode(AFTERLIFE_PATH), "afterlife station loads")

	_game_state.record_recovery_pattern_outcome(PATTERN_ID, CORRECT_RESPONSE_ID, true, "현장 대응 성공 / 근거 일부", _context(false, CORRECT_RESPONSE_ID, "대응 확인·근거 일부"))
	var manual: Dictionary = _game_state.get_current_anomaly_manual_record()
	_expect(Dictionary(manual.get("verified_rules", {})).is_empty(), "partial correct response is not promoted to official rule")
	_expect(Dictionary(manual.get("candidate_rules", {})).has(PATTERN_ID), "partial correct response remains a candidate")

	_game_state.record_recovery_pattern_outcome(PATTERN_ID, WRONG_RESPONSE_ID, false, "공식 기록으로 검증되지 않은 목적지를 따르면 개인 기억이 괴이 노선으로 고정된다.", _context(false, WRONG_RESPONSE_ID, "현장 대응 실패"))
	_game_state.record_recovery_pattern_outcome(PATTERN_ID, WRONG_RESPONSE_ID, false, "공식 기록으로 검증되지 않은 목적지를 따르면 개인 기억이 괴이 노선으로 고정된다.", _context(false, WRONG_RESPONSE_ID, "현장 대응 실패"))
	manual = _game_state.get_current_anomaly_manual_record()
	var danger_cases: Array = manual.get("danger_cases", [])
	_expect(danger_cases.size() == 1, "duplicate danger case is deduplicated")
	if not danger_cases.is_empty():
		_expect(int(Dictionary(danger_cases[0]).get("attempts", 0)) == 2, "duplicate danger case increments attempts")

	_game_state.record_recovery_pattern_outcome(PATTERN_ID, CORRECT_RESPONSE_ID, true, "가설·근거·대응 검증 완료", _context(true, CORRECT_RESPONSE_ID, "검증 완료"))
	manual = _game_state.get_current_anomaly_manual_record()
	_expect(Dictionary(manual.get("verified_rules", {})).has(PATTERN_ID), "fully supported correct response promotes an official rule")
	_expect(not Dictionary(manual.get("candidate_rules", {})).has(PATTERN_ID), "official promotion removes the provisional candidate")
	_expect(Array(manual.get("danger_cases", [])).size() == 1, "official promotion preserves earlier danger cases")

	_game_state.record_recovery_pattern_outcome(PATTERN_ID, CORRECT_RESPONSE_ID, true, "재시도는 성공했지만 근거 일부", _context(false, CORRECT_RESPONSE_ID, "대응 확인·근거 일부"))
	manual = _game_state.get_current_anomaly_manual_record()
	_expect(Dictionary(manual.get("verified_rules", {})).has(PATTERN_ID), "a later partial replay never downgrades the official rule")
	_expect(not Dictionary(manual.get("candidate_rules", {})).has(PATTERN_ID), "a later partial replay does not recreate a duplicate candidate")

	var report: Dictionary = _game_state.get_case_report_summary()
	_expect(not Dictionary(report.get("anomaly_manual_record", {})).is_empty(), "case report includes the player-authored manual snapshot")
	_expect(_game_state.save_game(), "manual record saves")
	_game_state.reset_run_state()
	_expect(_game_state.get_anomaly_manual_records().is_empty(), "run reset clears in-memory manual records")
	_expect(_game_state.load_game(), "manual record save reloads")
	manual = _game_state.get_current_anomaly_manual_record()
	_expect(Dictionary(manual.get("verified_rules", {})).has(PATTERN_ID), "official rule survives save and load")
	_expect(Array(manual.get("danger_cases", [])).size() == 1, "danger case survives save and load")
	_expect(String(_game_state.get_save_state_summary().get("save_version", "")) == "mvp-039", "additive manual field keeps save schema mvp-039")
	_finish()


func _context(verified: bool, response_id: String, verification_label: String) -> Dictionary:
	var selected_ids := ["clue_repeating_announcement", "clue_missing_terminal_sign"] if verified else ["clue_repeating_announcement"]
	var selected_titles := ["반복 안내방송 원본", "목적지 표기 공백"] if verified else ["반복 안내방송 원본"]
	return {
		"guided": true,
		"episode_id": "episode_001_afterlife_station",
		"episode_title": "저승역",
		"pattern_name": "목적지 기록 충돌",
		"question": "사라지는 전광판 표기를 실제 목적지로 믿어도 되는가?",
		"manual_draft": "개인에게 들리는 목적지와 공식 운행 기록을 분리해 검증한다.",
		"response_label": "방송 공백과 전광판 차이를 대조해 안내 신호를 차단한다" if response_id == CORRECT_RESPONSE_ID else "전광판이 가리키는 승강장을 실제 종착지로 보고 이동한다",
		"selected_hypothesis_response_id": response_id,
		"hypothesis": "전광판의 목적지는 객관적 노선이 아니라 방송 공백을 개인 기억이 채운 결과다." if response_id == CORRECT_RESPONSE_ID else "사라지기 전 마지막 표기가 안전한 실제 종착지다.",
		"authored_supporting_clue_ids": ["clue_repeating_announcement", "clue_missing_terminal_sign"],
		"authored_supporting_clue_titles": ["반복 안내방송 원본", "목적지 표기 공백"],
		"selected_evidence_ids": selected_ids,
		"selected_evidence_titles": selected_titles,
		"selected_contradicted_clue_ids": [],
		"reasoning": "방송 원본과 같은 시각의 표기를 대조한다.",
		"verification_label": verification_label,
		"verified": verified
	}


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	var restore_error := _guard.restore()
	if not restore_error.is_empty():
		_failures.append(restore_error)
	if _failures.is_empty():
		print("CORE VALIDATION MANUAL PROMOTION: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
