extends SceneTree

const EPISODE_PATH := "res://data/episodes/episode_002_red_umbrella_alley.json"
const MAP_PATH := "res://data/episodes/episode_002_red_umbrella_alley_validation_map.json"
const EXPECTED_RECORD_IDS := [
	"clue_red_umbrella_fabric",
	"clue_repeating_alley_sign",
	"clue_reverse_rain_flow"
]
const EXPECTED_RULE_IDS := [
	"rule_m04_rain_rewind",
	"rule_m04_victim_tether"
]

var _failures: Array[String] = []


func _init() -> void:
	var episode := _read_dict(EPISODE_PATH)
	var validation_map := _read_dict(MAP_PATH)
	var manual_value: Variant = episode.get("investigation_manual", {})
	_expect(manual_value is Dictionary and not (manual_value as Dictionary).is_empty(), "M04 runtime episode must own its player-authored manual")
	if not (manual_value is Dictionary) or (manual_value as Dictionary).is_empty():
		_finish()
		return
	var manual := manual_value as Dictionary
	_test_single_source_contract(manual, validation_map)
	_test_draft_composition_contract(manual)
	_test_existing_rescue_contract(manual)
	_finish()


func _test_single_source_contract(manual: Dictionary, validation_map: Dictionary) -> void:
	_expect(not validation_map.has("investigation_manual"), "M04 validation map must not duplicate runtime manual facts")
	_expect(manual.get("record_ids", []) == EXPECTED_RECORD_IDS, "M04 manual must reuse only its three existing clue IDs")
	var rule_ids: Array[String] = []
	for rule_value in manual.get("rule_pages", []) as Array:
		if rule_value is Dictionary:
			rule_ids.append(String((rule_value as Dictionary).get("id", "")))
	_expect(rule_ids == EXPECTED_RULE_IDS, "M04 manual must preserve existing rule page IDs")
	_expect(not manual.has("answer"), "M04 manual must not store an answer")
	_expect(not manual.has("correct"), "M04 manual must not store correctness")


func _test_draft_composition_contract(manual: Dictionary) -> void:
	var composition := ManualKeywordCompositionPolicy.new()
	var result := composition.validate_manual(manual)
	_expect(bool(result.get("ok", false)), "M04 manual must satisfy draft-only composition policy")
	_expect(String(result.get("code", "")) == "VALID_MANUAL", "M04 manual must be structurally valid")
	var candidates := manual.get("candidate_keywords", []) as Array
	_expect(candidates.size() == 8, "M04 manual must expose four one-variable candidate pairs")
	for candidate_value in candidates:
		if candidate_value is Dictionary:
			var candidate := candidate_value as Dictionary
			_expect(not candidate.has("answer"), "M04 candidate cannot reveal an answer")
			_expect(not candidate.has("correct"), "M04 candidate cannot reveal correctness")
			_expect(not candidate.has("recommendation"), "M04 candidate cannot recommend a choice")


func _test_existing_rescue_contract(manual: Dictionary) -> void:
	var shared := SharedInvestigationManualPolicy.new()
	var result := shared.validate_contract(manual)
	_expect(bool(result.get("ok", false)), "M04 manual must retain existing rescue-context contract")
	var rescue_gate := manual.get("rescue_gate", {}) as Dictionary
	_expect(int(rescue_gate.get("minimum_earned_records", 0)) == 2, "M04 rescue record threshold changed")
	_expect(int(rescue_gate.get("minimum_completed_rules", 0)) == 1, "M04 rescue rule threshold changed")


func _read_dict(path: String) -> Dictionary:
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(path))
	return parsed as Dictionary if parsed is Dictionary else {}


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("M04 PLAYER-AUTHORED MANUAL CONTRACT: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
