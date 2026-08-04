extends SceneTree

const EpisodeLoaderScript := preload("res://scripts/data/episode_loader.gd")
const BASE_EPISODE := "res://data/episodes/episode_001_afterlife_station.json"
const SIDECAR := "res://data/episodes/episode_001_afterlife_station_canon_v2.json"
const LOADER_SCRIPT := "res://scripts/data/afterlife_canon_v2_loader.gd"
const CONTRACT_ID := "afterlife-station-canon-v2"
const MALICIOUS_SIDECAR := "user://afterlife_canon_v2_self_declared_layers.json"

var _failures: Array[String] = []


func _init() -> void:
	_test_data_contract()
	_test_explicit_loader_and_computed_provenance()
	_finish()


func _test_data_contract() -> void:
	_expect(FileAccess.file_exists(SIDECAR), "Canon v2 sidecar missing")
	if not FileAccess.file_exists(SIDECAR):
		return
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(SIDECAR))
	_expect(typeof(parsed) == TYPE_DICTIONARY, "sidecar root must be Dictionary")
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	var data := parsed as Dictionary
	_expect(String(data.get("target_episode_id", "")) == "episode_001_afterlife_station", "episode identity changed")
	_expect(String(data.get("victim_id", "")) == "victim_afterlife_station_001", "victim identity changed")
	_expect(String(data.get("content_contract_id", "")) == CONTRACT_ID, "content contract mismatch")
	_expect(int(data.get("content_schema", 0)) == 2, "content schema mismatch")
	_expect(not data.has("loaded_layers"), "sidecar must not self-declare loaded_layers")
	var canonical_value: Variant = data.get("canonical_v2")
	_expect(typeof(canonical_value) == TYPE_DICTIONARY, "canonical_v2 block missing")
	if typeof(canonical_value) != TYPE_DICTIONARY:
		return
	var canonical := canonical_value as Dictionary
	for key in ["investigation_manual", "rescue_protocol", "recovery_encounters", "result_contract"]:
		_expect(typeof(canonical.get(key)) == TYPE_DICTIONARY, "missing canonical block: %s" % key)
	_expect(_contains_id(canonical.get("investigation_manual", {}), "manual_afterlife_page_01_destination_projection"), "manual page 01 missing")
	_expect(_contains_id(canonical.get("investigation_manual", {}), "record_afterlife_r1_broadcast_original"), "canonical record missing")
	_expect(_contains_id(canonical.get("recovery_encounters", {}), "pattern_afterlife_nonstop_farewell"), "canonical pattern missing")
	_expect(_contains_id(canonical.get("recovery_encounters", {}), "response_afterlife_present_official_ticket"), "canonical response missing")


func _test_explicit_loader_and_computed_provenance() -> void:
	var episode_loader = EpisodeLoaderScript.new()
	var legacy: Dictionary = episode_loader.load_episode(BASE_EPISODE)
	_expect(not legacy.is_empty(), "legacy default load failed")
	_expect(not legacy.has("content_contract_id"), "implicit Canon v2 activation occurred")
	_expect(episode_loader.has_method("load_episode_contract"), "EpisodeLoader contract entrypoint missing")
	if episode_loader.has_method("load_episode_contract"):
		var v2: Dictionary = episode_loader.call("load_episode_contract", BASE_EPISODE, CONTRACT_ID)
		_expect(String(v2.get("content_contract_id", "")) == CONTRACT_ID, "explicit Canon v2 load failed")
		_expect(v2.get("loaded_layers", []) == ["base_episode", "legacy_core_validation", "canonical_v2"], "computed layer provenance mismatch")
		_expect(typeof(v2.get("layer_checksums")) == TYPE_DICTIONARY, "layer checksums missing")
		_expect(not v2.has("recovery_patterns"), "legacy and Canon v2 recovery patterns mixed")
		_expect(typeof(v2.get("recovery_encounters")) == TYPE_DICTIONARY, "Canon v2 recovery block missing")

	_expect(FileAccess.file_exists(LOADER_SCRIPT), "AfterlifeCanonV2Loader script missing")
	if not FileAccess.file_exists(LOADER_SCRIPT) or not FileAccess.file_exists(SIDECAR):
		return
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(SIDECAR))
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	var malicious := (parsed as Dictionary).duplicate(true)
	malicious["loaded_layers"] = ["base_episode", "canonical_v2"]
	_write_json(MALICIOUS_SIDECAR, malicious)
	var script_value: Variant = load(LOADER_SCRIPT)
	_expect(script_value is Script, "AfterlifeCanonV2Loader failed to load")
	if script_value is Script:
		var loader = (script_value as Script).new()
		var result: Dictionary = loader.load_contract(BASE_EPISODE, CONTRACT_ID, MALICIOUS_SIDECAR)
		_expect(String(result.get("code", "")) == "DISALLOWED_SELF_DECLARED_PROVENANCE", "sidecar forged provenance")
	_remove_path(MALICIOUS_SIDECAR)


func _write_json(path: String, value: Dictionary) -> void:
	var file := FileAccess.open(path, FileAccess.WRITE)
	_expect(file != null, "failed to open malicious fixture")
	if file != null:
		file.store_string(JSON.stringify(value))
		file.close()


func _remove_path(path: String) -> void:
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(path))


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
	_remove_path(MALICIOUS_SIDECAR)
	if _failures.is_empty():
		print("AFTERLIFE CANON V2 LOADER: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
