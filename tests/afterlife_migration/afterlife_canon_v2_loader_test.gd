extends SceneTree

const SIDECAR := "res://data/episodes/episode_001_afterlife_station_canon_v2.json"

var _failures: Array[String] = []


func _init() -> void:
	_expect(FileAccess.file_exists(SIDECAR), "Canon v2 sidecar missing")
	if FileAccess.file_exists(SIDECAR):
		var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(SIDECAR))
		_expect(typeof(parsed) == TYPE_DICTIONARY, "sidecar root must be Dictionary")
		if typeof(parsed) == TYPE_DICTIONARY:
			var data := parsed as Dictionary
			_expect(String(data.get("target_episode_id", "")) == "episode_001_afterlife_station", "episode identity changed")
			_expect(String(data.get("victim_id", "")) == "victim_afterlife_station_001", "victim identity changed")
			_expect(String(data.get("content_contract_id", "")) == "afterlife-station-canon-v2", "content contract mismatch")
			_expect(int(data.get("content_schema", 0)) == 2, "content schema mismatch")
			_expect(not data.has("loaded_layers"), "sidecar must not self-declare loaded_layers")
			var canonical_value: Variant = data.get("canonical_v2")
			_expect(typeof(canonical_value) == TYPE_DICTIONARY, "canonical_v2 block missing")
			if typeof(canonical_value) == TYPE_DICTIONARY:
				var canonical := canonical_value as Dictionary
				for key in ["investigation_manual", "rescue_protocol", "recovery_encounters", "result_contract"]:
					_expect(typeof(canonical.get(key)) == TYPE_DICTIONARY, "missing canonical block: %s" % key)
				_expect(_contains_id(canonical.get("investigation_manual", {}), "manual_afterlife_page_01_destination_projection"), "manual page 01 missing")
				_expect(_contains_id(canonical.get("investigation_manual", {}), "record_afterlife_r1_broadcast_original"), "canonical record missing")
				_expect(_contains_id(canonical.get("recovery_encounters", {}), "pattern_afterlife_nonstop_farewell"), "canonical pattern missing")
				_expect(_contains_id(canonical.get("recovery_encounters", {}), "response_afterlife_present_official_ticket"), "canonical response missing")
	_finish()


func _contains_id(value: Variant, target_id: String) -> bool:
	match typeof(value):
		TYPE_DICTIONARY:
			var dictionary := value as Dictionary
			if String(dictionary.get("id", "")) == target_id:
				return true
			for child in dictionary.values():
				if _contains_id(child, target_id):
					return true
		TYPE_ARRAY:
			for child in value as Array:
				if _contains_id(child, target_id):
					return true
	return false


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("AFTERLIFE CANON V2 DATA CONTRACT: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
