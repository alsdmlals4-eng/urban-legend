extends SceneTree

const LoaderScript := preload("res://scripts/data/episode_loader.gd")
const BASE_PATH := "res://data/episodes/episode_001_afterlife_station.json"
const CONTRACT_ID := "afterlife-station-canon-v2"
const CANONICAL_PATTERN_IDS := [
	"pattern_afterlife_destination_chorus",
	"pattern_afterlife_recurring_platform",
	"pattern_afterlife_nonstop_farewell"
]
const LEGACY_PATTERN_IDS := [
	"pattern_station_false_terminal",
	"pattern_station_gaze_lure",
	"pattern_station_ticket_imprint",
	"pattern_station_boundary_collapse"
]

var _failures: Array[String] = []


func _init() -> void:
	var episode: Dictionary = LoaderScript.new().load_episode_contract(BASE_PATH, CONTRACT_ID)
	_expect(not episode.is_empty(), "Canon v2 episode load failed")
	_expect(String(episode.get("recovery_pattern_source", "")) == "canonical_v2_projection", "runtime projection provenance missing")
	var patterns_value: Variant = episode.get("recovery_patterns")
	_expect(typeof(patterns_value) == TYPE_ARRAY, "Canon v2 runtime recovery projection missing")
	if typeof(patterns_value) == TYPE_ARRAY:
		var patterns := patterns_value as Array
		_expect(patterns.size() == CANONICAL_PATTERN_IDS.size(), "runtime projection pattern count mismatch")
		var seen_ids: Array[String] = []
		for pattern_value in patterns:
			_expect(typeof(pattern_value) == TYPE_DICTIONARY, "projected pattern must be Dictionary")
			if typeof(pattern_value) != TYPE_DICTIONARY:
				continue
			var pattern := pattern_value as Dictionary
			var pattern_id := String(pattern.get("id", ""))
			seen_ids.append(pattern_id)
			_expect(pattern_id in CANONICAL_PATTERN_IDS, "non-canonical pattern entered runtime: %s" % pattern_id)
			_expect(pattern_id not in LEGACY_PATTERN_IDS, "legacy pattern entered Canon v2 runtime")
			_expect(not String(pattern.get("telegraph", "")).is_empty(), "projected telegraph missing")
			_expect(not String(pattern.get("description", "")).is_empty(), "projected description missing")
			_expect(not String(pattern.get("question", "")).is_empty(), "projected question missing")
			var responses_value: Variant = pattern.get("responses")
			_expect(typeof(responses_value) == TYPE_ARRAY, "projected responses missing")
			if typeof(responses_value) == TYPE_ARRAY:
				var responses := responses_value as Array
				_expect(responses.size() >= 2, "projected pattern needs correct and wrong responses")
				var correct_id := String(pattern.get("correct_response_id", ""))
				_expect(not correct_id.is_empty(), "projected correct response missing")
				var correct_found := false
				for response_value in responses:
					if typeof(response_value) != TYPE_DICTIONARY:
						continue
					var response := response_value as Dictionary
					if String(response.get("id", "")) == correct_id:
						correct_found = true
						_expect(not (response.get("supporting_clue_ids", []) as Array).is_empty(), "correct response lacks evidence support")
				_expect(correct_found, "correct response not present in projected responses")
		for expected_id in CANONICAL_PATTERN_IDS:
			_expect(expected_id in seen_ids, "canonical pattern missing from projection: %s" % expected_id)
	var legacy_snapshot := episode.get("legacy_content_snapshot", {}) as Dictionary
	_expect(typeof((legacy_snapshot.get("overrides", {}) as Dictionary).get("recovery_patterns")) == TYPE_ARRAY, "legacy patterns not preserved as historical snapshot")
	_finish()


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("AFTERLIFE RUNTIME PROJECTION: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
