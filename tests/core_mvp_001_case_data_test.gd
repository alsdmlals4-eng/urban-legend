extends SceneTree

const CaseData = preload("res://scripts/poc/core_mvp_001/core_mvp_001_case_data.gd")

var _failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var path := "res://data/poc/core_mvp_001/afterlife_station_poc.json"
	var data := CaseData.load_case(path)
	_expect(not data.is_empty(), "valid fixture should load")
	_expect(CaseData.validate_case(data).is_empty(), "valid fixture should pass validation")
	_expect(CaseData.load_case("res://data/poc/core_mvp_001/missing.json").is_empty(), "missing fixture should return empty dictionary")

	var duplicate := data.duplicate(true)
	duplicate["clues"].append(duplicate["clues"][0].duplicate(true))
	_expect(not CaseData.validate_case(duplicate).is_empty(), "duplicate IDs should be rejected")

	var broken_reference := data.duplicate(true)
	broken_reference["recovery_patterns"][0]["valid_action_ids"] = ["poc001_action_missing"]
	_expect(not CaseData.validate_case(broken_reference).is_empty(), "missing action references should be rejected")

	var no_mitigation := data.duplicate(true)
	no_mitigation["recovery_patterns"][2]["generic_mitigation_action_ids"] = []
	_expect(not CaseData.validate_case(no_mitigation).is_empty(), "hidden pattern without mitigation should be rejected")

	var index := CaseData.index_by_id(data["choices"])
	_expect(index.size() == 4, "choice index should include every choice")
	_expect(index.has("poc001_choice_hold_official_signal"), "choice index should use IDs as keys")
	_finish()


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("CORE MVP 001 CASE DATA: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
