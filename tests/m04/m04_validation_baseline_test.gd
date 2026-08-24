extends SceneTree

const EPISODE_PATH := "res://data/episodes/episode_002_red_umbrella_alley.json"
const MAP_PATH := "res://data/episodes/episode_002_red_umbrella_alley_validation_map.json"
const MANUAL_POLICY_PATH := "res://scripts/core/shared_investigation_manual_policy.gd"
const EXPECTED_AXES := [
	"victim_outcome",
	"control_or_stabilization",
	"evidence_integrity",
	"protection_responsibility",
	"residual_anomaly",
	"unresolved_and_follow_up"
]
var _failures: Array[String] = []


func _init() -> void:
	_expect(FileAccess.file_exists(EPISODE_PATH), "M04 episode missing")
	_expect(FileAccess.file_exists(MAP_PATH), "M04 validation map missing")
	_expect(FileAccess.file_exists(MANUAL_POLICY_PATH), "shared manual policy missing")
	if FileAccess.file_exists(EPISODE_PATH) and FileAccess.file_exists(MAP_PATH) and FileAccess.file_exists(MANUAL_POLICY_PATH):
		var episode := _read_dict(EPISODE_PATH)
		var mapping := _read_dict(MAP_PATH)
		_test_identity_and_visual_gate(mapping)
		_test_live_reference_integrity(episode, mapping)
		_test_shared_manual_contract(mapping)
		_test_shared_rescue_adapter(mapping)
		_test_composite_result_axes(mapping)
	_finish()


func _test_identity_and_visual_gate(mapping: Dictionary) -> void:
	_expect(String(mapping.get("schema", "")) == "m04-shared-system-validation-v1", "M04 validation schema mismatch")
	_expect(String(mapping.get("case_id", "")) == "episode_002_red_umbrella_alley", "M04 case identity mismatch")
	_expect(String(mapping.get("visual_status", "")) == "PRODUCT_REFERENCE_ASSET_PENDING", "M04 final visual gate was bypassed")
	_expect(not bool(mapping.get("final_visuals_authorized", true)), "M04 final visuals must remain unauthorized")


func _test_live_reference_integrity(episode: Dictionary, mapping: Dictionary) -> void:
	var live_ids := _collect_ids(episode)
	for key in ["record_ids", "investigation_point_ids", "minigame_ids", "recovery_pattern_ids"]:
		for id_value in mapping.get(key, []) as Array:
			var identifier := String(id_value)
			_expect(identifier in live_ids, "M04 map references missing live id: %s" % identifier)
	_expect("clue_red_umbrella_fabric" in live_ids, "M04 core clue missing")
	_expect("clue_repeating_alley_sign" in live_ids, "M04 route clue missing")
	_expect("clue_reverse_rain_flow" in live_ids, "M04 timing clue missing")
	_expect("minigame_rain_sync" in live_ids, "M04 core input missing")


func _test_shared_manual_contract(mapping: Dictionary) -> void:
	var script_value: Variant = load(MANUAL_POLICY_PATH)
	_expect(script_value is Script, "shared manual policy failed to load")
	if not script_value is Script:
		return
	var result: Dictionary = (script_value as Script).new().validate_contract(mapping.get("investigation_manual", {}) as Dictionary)
	_expect(bool(result.get("ok", false)), "M04 shared investigation/manual contract invalid")


func _test_shared_rescue_adapter(mapping: Dictionary) -> void:
	var adapter := mapping.get("rescue_recovery_adapter", {}) as Dictionary
	_expect(String(adapter.get("case_id", "")) == "episode_002_red_umbrella_alley", "M04 rescue adapter case mismatch")
	_expect(String(adapter.get("protected_subject_id", "")) == "victim_alley_witness", "M04 rescue adapter victim mismatch")
	_expect(String(adapter.get("source_minigame_id", "")) == "minigame_rain_sync", "M04 rescue adapter did not reuse live core input")
	_expect(bool(adapter.get("safe_withdrawal_route", false)), "M04 fail-forward withdrawal route missing")


func _test_composite_result_axes(mapping: Dictionary) -> void:
	var axes := mapping.get("composite_result_axes", []) as Array
	_expect(axes == EXPECTED_AXES, "M04 composite result axes diverge from shared grammar")
	_expect(not mapping.has("owns_first_s_rank"), "M04 adapter reintroduced legacy grade ownership")


func _collect_ids(value: Variant) -> Array[String]:
	var result: Array[String] = []
	_collect_ids_into(value, result)
	return result


func _collect_ids_into(value: Variant, result: Array[String]) -> void:
	match typeof(value):
		TYPE_DICTIONARY:
			var dictionary := value as Dictionary
			var identifier := String(dictionary.get("id", ""))
			if not identifier.is_empty() and identifier not in result:
				result.append(identifier)
			for child in dictionary.values():
				_collect_ids_into(child, result)
		TYPE_ARRAY:
			for child in value as Array:
				_collect_ids_into(child, result)


func _read_dict(path: String) -> Dictionary:
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(path))
	return parsed as Dictionary if typeof(parsed) == TYPE_DICTIONARY else {}


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("M04 VALIDATION BASELINE: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
