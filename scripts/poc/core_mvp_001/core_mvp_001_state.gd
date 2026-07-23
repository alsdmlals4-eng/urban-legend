class_name CoreMvp001State
extends RefCounted

const CaseData = preload("res://scripts/poc/core_mvp_001/core_mvp_001_case_data.gd")

var _case_data: Dictionary = {}
var _choices: Dictionary = {}
var _manual_records: Dictionary = {}
var _hypotheses: Dictionary = {}
var _field_tests: Dictionary = {}
var _patterns: Dictionary = {}
var _actions: Dictionary = {}
var _phase := "BOOT"
var _health := 100
var _risk := 0
var _understanding := "unknown"
var _eliminated_choice_ids: Array[String] = []
var _active_hypothesis_ids: Array[String] = []
var _selected_hypothesis_id := ""
var _hypothesis_card: Dictionary = {}
var _danger_cases: Array[Dictionary] = []
var _observed_pattern_ids: Array[String] = []
var _capture_marks: Array[String] = []
var _turn := 0
var _current_pattern_id := ""
var _omen_result: Dictionary = {}
var _outcome_id := ""
var _rng := RandomNumberGenerator.new()


func start(case_data: Dictionary, run_seed: int = 1001) -> Dictionary:
	var errors := CaseData.validate_case(case_data)
	if not errors.is_empty():
		return _response(false, "; ".join(errors), false)
	_case_data = case_data.duplicate(true)
	_choices = CaseData.index_by_id(_case_data["choices"])
	_manual_records = CaseData.index_by_id(_case_data["manual_records"])
	_hypotheses = CaseData.index_by_id(_case_data["hypotheses"])
	_field_tests = CaseData.index_by_id(_case_data["field_tests"])
	_patterns = CaseData.index_by_id(_case_data["recovery_patterns"])
	_actions = CaseData.index_by_id(_case_data["recovery_actions"])
	_phase = "ELIMINATION"
	_health = int((_case_data.get("case", {}) as Dictionary).get("starting_health", 100))
	_risk = int((_case_data.get("case", {}) as Dictionary).get("starting_risk", 0))
	_understanding = "unknown"
	_eliminated_choice_ids.clear()
	_active_hypothesis_ids.clear()
	_selected_hypothesis_id = ""
	_hypothesis_card.clear()
	_danger_cases.clear()
	_observed_pattern_ids.clear()
	_capture_marks.clear()
	_turn = 0
	_current_pattern_id = ""
	_omen_result.clear()
	_outcome_id = ""
	_rng.seed = run_seed
	for value in _case_data.get("recovery_patterns", []):
		var pattern := value as Dictionary
		if bool(pattern.get("observed_before_recovery", false)):
			_observed_pattern_ids.append(String(pattern["id"]))
	for value in _case_data.get("choices", []):
		var choice := value as Dictionary
		var hypothesis_id := String(choice.get("hypothesis_id", ""))
		if not hypothesis_id.is_empty() and not _active_hypothesis_ids.has(hypothesis_id):
			_active_hypothesis_ids.append(hypothesis_id)
	return _response(true, "", true, [{"event": "poc_started"}])


func get_snapshot() -> Dictionary:
	return {
		"phase": _phase,
		"health": _health,
		"risk": _risk,
		"understanding": _understanding,
		"available_choice_ids": _choices.keys(),
		"eliminated_choice_ids": _eliminated_choice_ids.duplicate(),
		"active_hypothesis_ids": _active_hypothesis_ids.duplicate(),
		"selected_hypothesis_id": _selected_hypothesis_id,
		"hypothesis_card": _hypothesis_card.duplicate(true),
		"danger_cases": _danger_cases.duplicate(true),
		"observed_pattern_ids": _observed_pattern_ids.duplicate(),
		"capture_marks": _capture_marks.duplicate(),
		"turn": _turn,
		"current_pattern_id": _current_pattern_id,
		"omen_result": _omen_result.duplicate(true),
		"outcome_id": _outcome_id
	}


func link_record_to_choice(record_id: String, choice_id: String) -> Dictionary:
	if _phase != "ELIMINATION":
		return _response(false, "현재 단계에서는 선택지를 배제할 수 없다.", false)
	if not _manual_records.has(record_id) or not _choices.has(choice_id):
		return _response(false, "기록 또는 선택지를 찾을 수 없다.", false)
	var matched_rule: Dictionary = {}
	for value in _case_data.get("elimination_rules", []):
		var rule := value as Dictionary
		if String(rule.get("record_id", "")) == record_id and String(rule.get("choice_id", "")) == choice_id:
			matched_rule = rule
			break
	if matched_rule.is_empty():
		return _response(false, "이 기록은 해당 선택지를 배제하지 못한다.", false)
	if _eliminated_choice_ids.has(choice_id):
		var duplicate := _response(true, "", false)
		duplicate["feedback"] = "이미 배제한 선택지다."
		return duplicate
	_eliminated_choice_ids.append(choice_id)
	var result := _response(
		true,
		"",
		true,
		[{
			"event": "choice_eliminated",
			"choice_id": choice_id,
			"record_id": record_id
		}]
	)
	result["feedback"] = "배제: %s" % String(matched_rule.get("feedback", "근거와 충돌한다."))
	return result


func advance_to_hypothesis() -> Dictionary:
	if _phase != "ELIMINATION" or _eliminated_choice_ids.size() != 2:
		return _response(false, "정확히 두 선택지를 배제해야 한다.", false)
	_phase = "HYPOTHESIS_AUTHORING"
	return _response(true, "", true)


func submit_hypothesis(
	hypothesis_id: String,
	supporting_ids: Array[String],
	contradiction_ids: Array[String],
	unresolved_ids: Array[String]
) -> Dictionary:
	if _phase != "HYPOTHESIS_AUTHORING" and _phase != "HYPOTHESIS_REFRESH":
		return _response(false, "현재 단계에서는 가설을 제출할 수 없다.", false)
	if not _hypotheses.has(hypothesis_id) or not _active_hypothesis_ids.has(hypothesis_id):
		return _response(false, "현재 검토 가능한 가설을 찾을 수 없다.", false)
	if supporting_ids.is_empty():
		return _response(false, "지지 근거가 하나 이상 필요하다.", false)
	var hypothesis := _hypotheses[hypothesis_id] as Dictionary
	var evidence_error := _validate_hypothesis_evidence(
		hypothesis,
		supporting_ids,
		contradiction_ids,
		unresolved_ids
	)
	if not evidence_error.is_empty():
		return _response(false, evidence_error, false)
	_selected_hypothesis_id = hypothesis_id
	_hypothesis_card = {
		"hypothesis_id": hypothesis_id,
		"rule_text": String(hypothesis.get("rule_text", "")),
		"selected_supporting_clue_ids": supporting_ids.duplicate(),
		"selected_contradiction_clue_ids": contradiction_ids.duplicate(),
		"selected_unresolved_question_ids": unresolved_ids.duplicate(),
		"field_test_result": {}
	}
	var previous_understanding := _understanding
	_understanding = "clue"
	if _contains_all(supporting_ids, hypothesis.get("required_supporting_clue_ids", []) as Array) and _contains_all(contradiction_ids, hypothesis.get("required_contradiction_clue_ids", []) as Array):
		_understanding = "likely"
	_phase = "FIELD_TEST"
	var events: Array = [{
		"event": "hypothesis_submitted",
		"hypothesis_id": hypothesis_id
	}]
	if previous_understanding != _understanding:
		events.append({
			"event": "understanding_changed",
			"from": previous_understanding,
			"to": _understanding
		})
	return _response(true, "", true, events)


func resolve_field_test(field_test_id: String) -> Dictionary:
	if _phase != "FIELD_TEST" or not _field_tests.has(field_test_id):
		return _response(false, "현장 검증을 실행할 수 없다.", false)
	var test := _field_tests[field_test_id] as Dictionary
	if String(test.get("hypothesis_id", "")) != _selected_hypothesis_id:
		return _response(false, "선택한 가설과 다른 현장 검증이다.", false)
	var correct := bool(test.get("correct", false))
	var damage := int(test.get("damage", 0))
	var risk_delta := int(test.get("risk_delta", 0))
	_health = max(1, _health - damage)
	_risk = min(int((_case_data.get("case", {}) as Dictionary).get("max_risk", 100)), _risk + risk_delta)
	var reaction_clue_id := String(test.get("reaction_clue_id", ""))
	_hypothesis_card["field_test_result"] = {
		"field_test_id": field_test_id,
		"correct": correct,
		"damage": damage,
		"risk_delta": risk_delta,
		"reaction_clue_id": reaction_clue_id
	}
	var events: Array = [{
		"event": "field_test_resolved",
		"field_test_id": field_test_id,
		"correct": correct,
		"damage": damage,
		"risk_delta": risk_delta,
		"reaction_clue_id": reaction_clue_id
	}]
	if correct:
		var previous_understanding := _understanding
		_understanding = "understood"
		_phase = "RECOVERY_READY"
		if previous_understanding != _understanding:
			events.append({
				"event": "understanding_changed",
				"from": previous_understanding,
				"to": _understanding
			})
	else:
		_record_danger_case(
			"field_test:%s" % field_test_id,
			{
				"source": "field_test",
				"field_test_id": field_test_id,
				"reaction_clue_id": reaction_clue_id,
				"text": String(test.get("danger_case_text", "잘못된 가설이 위험 사례를 남겼다."))
			}
		)
		if _risk >= int((_case_data.get("case", {}) as Dictionary).get("max_risk", 100)):
			_phase = "EMERGENCY_RECOVERY"
		else:
			_phase = "HYPOTHESIS_REFRESH"
			var refresh_id := String(test.get("refresh_hypothesis_id", ""))
			_active_hypothesis_ids = [_selected_hypothesis_id]
			if not refresh_id.is_empty() and refresh_id != _selected_hypothesis_id:
				_active_hypothesis_ids.append(refresh_id)
	var result := _response(true, "", true, events)
	result["correct"] = correct
	result["damage"] = damage
	result["risk_delta"] = risk_delta
	result["reaction_clue_id"] = reaction_clue_id
	return result


func begin_recovery_turn() -> Dictionary:
	if _phase not in ["RECOVERY_READY", "EMERGENCY_RECOVERY", "RECOVERY_TURN_START"]:
		return _response(false, "회수 턴을 시작할 수 없다.", false)
	var sequence := _case_data.get("recovery_sequence", []) as Array
	if sequence.is_empty():
		return _response(false, "회수 패턴 순서가 비어 있다.", false)
	_turn += 1
	var index: int = min(_turn - 1, sequence.size() - 1)
	_current_pattern_id = String(sequence[index])
	_omen_result.clear()
	_phase = "OMEN_READ"
	return _response(
		true,
		"",
		true,
		[{
			"event": "recovery_turn_started",
			"turn": _turn,
			"pattern_id": _current_pattern_id
		}]
	)


func read_current_omen(forced_roll: int = -1) -> Dictionary:
	if _phase == "RESPONSE_SELECTION" and not _omen_result.is_empty():
		return _omen_response(false, [])
	if _phase != "OMEN_READ" or not _patterns.has(_current_pattern_id):
		var invalid := _response(false, "전조를 읽을 수 없다.", false)
		invalid["success"] = false
		invalid["text"] = ""
		return invalid
	var pattern := _patterns[_current_pattern_id] as Dictionary
	var first_hidden := bool(pattern.get("first_use_hidden", false)) and not _observed_pattern_ids.has(_current_pattern_id)
	var roll := forced_roll
	if roll < 0:
		roll = _rng.randi_range(1, 100)
	var rate := int(((_case_data.get("understanding", {}) as Dictionary).get("omen_read_rates", {}) as Dictionary).get(_understanding, 0))
	var success := not first_hidden and roll <= rate
	_omen_result = {
		"success": success,
		"roll": roll,
		"tier": _understanding,
		"pattern_id": _current_pattern_id,
		"text": "놈은 무언가 하려 한다.",
		"revealed_fields": []
	}
	if success:
		_omen_result["text"] = "놈은 %s을 하려 한다." % String(pattern.get("action_name", "무언가"))
		var revealed: Array[String] = []
		for field in pattern.get("readable_fields", []):
			var field_name := String(field)
			revealed.append(field_name)
			_omen_result[field_name] = pattern.get(field_name)
		_omen_result["revealed_fields"] = revealed
	_phase = "RESPONSE_SELECTION"
	return _omen_response(
		true,
		[{
			"event": "omen_read",
			"turn": _turn,
			"pattern_id": _current_pattern_id,
			"success": success,
			"tier": _understanding
		}]
	)


func resolve_recovery_action(action_id: String) -> Dictionary:
	if _phase != "RESPONSE_SELECTION" or not _actions.has(action_id) or not _patterns.has(_current_pattern_id):
		var invalid := _response(false, "회수 행동을 실행할 수 없다.", false)
		invalid["valid"] = false
		invalid["damage"] = 0
		invalid["risk_delta"] = 0
		return invalid
	var pattern := _patterns[_current_pattern_id] as Dictionary
	var first_hidden := bool(pattern.get("first_use_hidden", false)) and not _observed_pattern_ids.has(_current_pattern_id)
	var valid := false
	var damage := 0
	var risk_delta := 0
	if first_hidden:
		valid = (pattern.get("generic_mitigation_action_ids", []) as Array).has(action_id)
		var first_damage_cap := int(pattern.get("max_first_observation_damage", 18))
		damage = min(first_damage_cap, 6 if valid else first_damage_cap)
		risk_delta = 6 if valid else int(pattern.get("risk_on_failure", 18))
		_observed_pattern_ids.append(_current_pattern_id)
	else:
		var valid_actions: Array = pattern.get("valid_action_ids", [])
		if bool(pattern.get("first_use_hidden", false)):
			valid_actions = pattern.get("valid_action_ids_after_observation", [])
		valid = valid_actions.has(action_id)
		if valid:
			var mark := String(pattern.get("capture_mark", ""))
			if not mark.is_empty() and not _capture_marks.has(mark):
				_capture_marks.append(mark)
		else:
			damage = int(pattern.get("damage_on_failure", 12))
			risk_delta = int(pattern.get("risk_on_failure", 15))
	_health = max(1, _health - damage)
	_risk = min(100, _risk + risk_delta)
	if not valid:
		_record_danger_case(
			"recovery_action:%s:%s" % [_current_pattern_id, action_id],
			{
				"source": "recovery_action",
				"pattern_id": _current_pattern_id,
				"action_id": action_id,
				"text": "전조와 맞지 않는 대응이었다."
			}
		)
	var capture := _case_data.get("capture_rule", {}) as Dictionary
	var required_marks := capture.get("required_capture_marks", []) as Array
	var emergency := _risk >= int(capture.get("emergency_risk_threshold", 100)) or _health <= int(capture.get("emergency_health_threshold", 15)) or _turn >= int(capture.get("max_recovery_turn", 8))
	var events: Array = [{
		"event": "recovery_action_resolved",
		"turn": _turn,
		"pattern_id": _current_pattern_id,
		"action_id": action_id,
		"valid": valid,
		"damage": damage,
		"risk_delta": risk_delta
	}]
	if emergency:
		_phase = "EMERGENCY_CAPTURE"
		events.append({"event": "capture_window_opened", "emergency": true})
	elif _contains_all(_capture_marks, required_marks) and _turn >= int(capture.get("min_capture_turn", 5)):
		_phase = "CAPTURE_WINDOW"
		events.append({"event": "capture_window_opened", "emergency": false})
	else:
		_phase = "RECOVERY_TURN_START"
	var result := _response(true, "", true, events)
	result["valid"] = valid
	result["damage"] = damage
	result["risk_delta"] = risk_delta
	result["capture_mark"] = String(pattern.get("capture_mark", "")) if valid and not first_hidden else ""
	return result


func execute_capture() -> Dictionary:
	if _phase not in ["CAPTURE_WINDOW", "EMERGENCY_CAPTURE"]:
		return _response(false, "포획 창이 열리지 않았다.", false)
	var capture := _case_data.get("capture_rule", {}) as Dictionary
	var starting_health := int((_case_data.get("case", {}) as Dictionary).get("starting_health", 100))
	var damage_taken := starting_health - _health
	if _phase == "EMERGENCY_CAPTURE":
		_outcome_id = "poc001_outcome_emergency_capture"
	elif damage_taken <= int(capture.get("normal_max_damage", 20)):
		_outcome_id = "poc001_outcome_normal_capture"
	else:
		_outcome_id = "poc001_outcome_costly_capture"
	_phase = "RESULT_COMPARE"
	return _response(
		true,
		"",
		true,
		[{
			"event": "poc_completed",
			"outcome_id": _outcome_id
		}]
	)


func build_manual_delta() -> Dictionary:
	var status := "candidate"
	if _hypotheses.has(_selected_hypothesis_id):
		var hypothesis := _hypotheses[_selected_hypothesis_id] as Dictionary
		var support_complete := _contains_all(
			_hypothesis_card.get("selected_supporting_clue_ids", []) as Array,
			hypothesis.get("required_supporting_clue_ids", []) as Array
		)
		var contradiction_complete := _contains_all(
			_hypothesis_card.get("selected_contradiction_clue_ids", []) as Array,
			hypothesis.get("required_contradiction_clue_ids", []) as Array
		)
		var field_result := _hypothesis_card.get("field_test_result", {}) as Dictionary
		if _selected_hypothesis_id == "poc001_hypothesis_broadcast_blank" and support_complete and contradiction_complete and bool(field_result.get("correct", false)) and _understanding == "understood" and not _outcome_id.is_empty():
			status = "verified"
	return {
		"status": status,
		"hypothesis_id": _selected_hypothesis_id,
		"rule_text": String(_hypothesis_card.get("rule_text", "")),
		"supporting_clue_ids": (_hypothesis_card.get("selected_supporting_clue_ids", []) as Array).duplicate(),
		"contradiction_clue_ids": (_hypothesis_card.get("selected_contradiction_clue_ids", []) as Array).duplicate(),
		"unresolved_question_ids": (_hypothesis_card.get("selected_unresolved_question_ids", []) as Array).duplicate(),
		"danger_cases": _danger_cases.duplicate(true),
		"observed_pattern_ids": _observed_pattern_ids.duplicate()
	}


func build_result() -> Dictionary:
	var starting_health := int((_case_data.get("case", {}) as Dictionary).get("starting_health", 100))
	var damage := starting_health - _health
	var capture := _case_data.get("capture_rule", {}) as Dictionary
	var damage_management := "controlled"
	if damage > int(capture.get("costly_max_damage", 45)):
		damage_management = "critical"
	elif damage > int(capture.get("normal_max_damage", 20)):
		damage_management = "strained"
	var recovery_quality := "pending"
	for value in _case_data.get("outcomes", []):
		var outcome := value as Dictionary
		if String(outcome.get("id", "")) == _outcome_id:
			recovery_quality = String(outcome.get("quality", "pending"))
			break
	return {
		"outcome_id": _outcome_id,
		"recovery_quality": recovery_quality,
		"damage_management": damage_management,
		"knowledge_quality": build_manual_delta().get("status", "candidate"),
		"damage": damage,
		"risk": _risk,
		"capture_marks": _capture_marks.duplicate()
	}


func confirm_manual_promotion() -> Dictionary:
	if _phase == "RESULT_COMPARE":
		_phase = "MANUAL_PROMOTION"
		return _response(
			true,
			"",
			true,
			[{
				"event": "manual_promotion_reviewed",
				"status": build_manual_delta().get("status", "candidate")
			}]
		)
	if _phase == "MANUAL_PROMOTION":
		_phase = "COMPLETE"
		return _response(
			true,
			"",
			true,
			[{
				"event": "manual_record_confirmed",
				"status": build_manual_delta().get("status", "candidate")
			}]
		)
	return _response(false, "매뉴얼 반영 단계가 아니다.", false)


func _validate_hypothesis_evidence(
	hypothesis: Dictionary,
	supporting_ids: Array[String],
	contradiction_ids: Array[String],
	unresolved_ids: Array[String]
) -> String:
	var clue_index := CaseData.index_by_id(_case_data["clues"])
	var allowed_support := hypothesis.get("required_supporting_clue_ids", []) as Array
	var allowed_contradiction := hypothesis.get("required_contradiction_clue_ids", []) as Array
	var allowed_unresolved := hypothesis.get("unresolved_question_ids", []) as Array
	for clue_id in supporting_ids:
		if not clue_index.has(clue_id):
			return "확보하지 않은 지지 근거가 포함됐다: %s" % clue_id
		if not allowed_support.has(clue_id):
			return "선택한 가설과 무관한 지지 근거다: %s" % clue_id
	for clue_id in contradiction_ids:
		if not clue_index.has(clue_id):
			return "확보하지 않은 반박 근거가 포함됐다: %s" % clue_id
		if not allowed_contradiction.has(clue_id):
			return "선택한 가설과 무관한 반박 근거다: %s" % clue_id
	for clue_id in unresolved_ids:
		if not clue_index.has(clue_id):
			return "확보하지 않은 미해결 질문이 포함됐다: %s" % clue_id
		if not allowed_unresolved.has(clue_id):
			return "선택한 가설과 무관한 미해결 질문이다: %s" % clue_id
	return ""


func _contains_all(selected: Array, required: Array) -> bool:
	for value in required:
		if not selected.has(value):
			return false
	return true


func _record_danger_case(case_key: String, payload: Dictionary) -> void:
	for index in range(_danger_cases.size()):
		var existing := _danger_cases[index]
		if String(existing.get("case_key", "")) == case_key:
			existing["attempts"] = int(existing.get("attempts", 1)) + 1
			_danger_cases[index] = existing
			return
	var entry := payload.duplicate(true)
	entry["case_key"] = case_key
	entry["attempts"] = 1
	_danger_cases.append(entry)


func _omen_response(changed: bool, events: Array) -> Dictionary:
	var response := _response(true, "", changed, events)
	for key in _omen_result:
		response[key] = _omen_result[key]
	return response


func _response(ok: bool, error: String, changed: bool, events: Array = []) -> Dictionary:
	return {
		"ok": ok,
		"error": error,
		"state_changed": changed,
		"events": events.duplicate(true),
		"snapshot": get_snapshot()
	}
