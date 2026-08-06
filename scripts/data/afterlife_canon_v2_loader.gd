class_name AfterlifeCanonV2Loader
extends RefCounted


const CONTRACT_ID := "afterlife-station-canon-v2"
const TARGET_EPISODE_ID := "episode_001_afterlife_station"
const CONTENT_SCHEMA := 2
const RUNTIME_PROJECTION_SCHEMA := 1
const DEFAULT_SIDECAR_PATH := "res://data/episodes/episode_001_afterlife_station_canon_v2.json"
const DEFAULT_RUNTIME_PROJECTION_PATH := "res://data/episodes/episode_001_afterlife_station_canon_v2_runtime_projection.json"
const CORE_VALIDATION_OVERLAY_SUFFIX := "_core_validation.json"
const REQUIRED_CANONICAL_BLOCKS := [
	"investigation_manual",
	"rescue_protocol",
	"recovery_encounters",
	"result_contract"
]
const LEGACY_AUTHORITY_KEYS := [
	"clues",
	"hints",
	"recovery_patterns",
	"correct_response_id"
]


func load_contract(
	base_path: String,
	contract_id: String,
	sidecar_path: String = DEFAULT_SIDECAR_PATH,
	runtime_projection_path: String = DEFAULT_RUNTIME_PROJECTION_PATH
) -> Dictionary:
	if contract_id != CONTRACT_ID:
		return _result(false, "INCOMPATIBLE_CONTENT_CONTRACT")

	var base_result := _read_layer(base_path, "base_episode")
	if not bool(base_result.get("ok", false)):
		return base_result
	var base_data := base_result.get("data", {}) as Dictionary
	var episode_value: Variant = base_data.get("episode")
	if typeof(episode_value) != TYPE_DICTIONARY:
		return _result(false, "CONTENT_EPISODE_MISMATCH")
	var episode_id := String((episode_value as Dictionary).get("id", ""))
	if episode_id != TARGET_EPISODE_ID:
		return _result(false, "CONTENT_EPISODE_MISMATCH")

	var overlay_path := _overlay_path(base_path)
	var overlay_result := _read_layer(overlay_path, "legacy_core_validation")
	if not bool(overlay_result.get("ok", false)):
		return overlay_result
	var overlay_data := overlay_result.get("data", {}) as Dictionary
	if String(overlay_data.get("target_episode_id", "")) != TARGET_EPISODE_ID:
		return _result(false, "CONTENT_EPISODE_MISMATCH")
	if typeof(overlay_data.get("overrides")) != TYPE_DICTIONARY:
		return _result(false, "INCOMPATIBLE_CONTENT_CONTRACT")

	var sidecar_result := _read_layer(sidecar_path, "canonical_v2")
	if not bool(sidecar_result.get("ok", false)):
		return sidecar_result
	var sidecar := sidecar_result.get("data", {}) as Dictionary
	var sidecar_code := _validate_sidecar(sidecar)
	if sidecar_code != "OK":
		return _result(false, sidecar_code)
	var canonical := sidecar.get("canonical_v2", {}) as Dictionary

	var projection_result := _read_layer(runtime_projection_path, "canonical_v2_runtime_projection")
	if not bool(projection_result.get("ok", false)):
		return projection_result
	var runtime_projection := projection_result.get("data", {}) as Dictionary
	var projection_code := _validate_runtime_projection(runtime_projection, canonical)
	if projection_code != "OK":
		return _result(false, projection_code)

	var merged := base_data.duplicate(true)
	for key in LEGACY_AUTHORITY_KEYS:
		merged.erase(key)

	merged["target_episode_id"] = TARGET_EPISODE_ID
	merged["content_contract_id"] = CONTRACT_ID
	merged["content_schema"] = CONTENT_SCHEMA
	merged["victim_profile"] = (canonical.get("victim_profile", {}) as Dictionary).duplicate(true)
	for block_name in REQUIRED_CANONICAL_BLOCKS:
		merged[block_name] = (canonical.get(block_name, {}) as Dictionary).duplicate(true)
	merged["legacy_content_snapshot"] = {
		"contract_version": String(overlay_data.get("contract_version", "")),
		"purpose": String(overlay_data.get("purpose", "")),
		"overrides": (overlay_data.get("overrides", {}) as Dictionary).duplicate(true)
	}

	merged["clues"] = (runtime_projection.get("clues", []) as Array).duplicate(true)
	merged["clue_source"] = "canonical_v2_projection"
	merged["recovery_patterns"] = (runtime_projection.get("recovery_patterns", []) as Array).duplicate(true)
	merged["recovery_pattern_source"] = "canonical_v2_projection"
	merged["runtime_projection_checksum"] = String(projection_result.get("checksum", ""))

	var loaded_layers := ["base_episode", "legacy_core_validation", "canonical_v2"]
	var layer_checksums := {
		"base_episode": String(base_result.get("checksum", "")),
		"legacy_core_validation": String(overlay_result.get("checksum", "")),
		"canonical_v2": String(sidecar_result.get("checksum", ""))
	}
	merged["loaded_layers"] = loaded_layers.duplicate()
	merged["layer_checksums"] = layer_checksums.duplicate(true)

	return {
		"ok": true,
		"code": "EXACT_V2",
		"episode": merged,
		"loaded_layers": loaded_layers,
		"layer_checksums": layer_checksums,
		"runtime_projection_checksum": String(projection_result.get("checksum", ""))
	}


func _validate_sidecar(sidecar: Dictionary) -> String:
	if sidecar.has("loaded_layers") or sidecar.has("layer_checksums"):
		return "DISALLOWED_SELF_DECLARED_PROVENANCE"
	if String(sidecar.get("target_episode_id", "")) != TARGET_EPISODE_ID:
		return "CONTENT_EPISODE_MISMATCH"
	if String(sidecar.get("content_contract_id", "")) != CONTRACT_ID:
		return "INCOMPATIBLE_CONTENT_CONTRACT"
	if int(sidecar.get("content_schema", 0)) != CONTENT_SCHEMA:
		return "INCOMPATIBLE_CONTENT_CONTRACT"
	var canonical_value: Variant = sidecar.get("canonical_v2")
	if typeof(canonical_value) != TYPE_DICTIONARY:
		return "INCOMPATIBLE_CONTENT_CONTRACT"
	var canonical := canonical_value as Dictionary
	for block_name in REQUIRED_CANONICAL_BLOCKS:
		if typeof(canonical.get(block_name)) != TYPE_DICTIONARY:
			return "INCOMPATIBLE_CONTENT_CONTRACT"
	return "OK"


func _validate_runtime_projection(projection: Dictionary, canonical: Dictionary) -> String:
	if projection.has("loaded_layers") or projection.has("layer_checksums"):
		return "DISALLOWED_SELF_DECLARED_PROVENANCE"
	if String(projection.get("target_episode_id", "")) != TARGET_EPISODE_ID:
		return "CONTENT_EPISODE_MISMATCH"
	if String(projection.get("content_contract_id", "")) != CONTRACT_ID:
		return "INCOMPATIBLE_CONTENT_CONTRACT"
	if int(projection.get("projection_schema", 0)) != RUNTIME_PROJECTION_SCHEMA:
		return "INCOMPATIBLE_CONTENT_CONTRACT"
	if String(projection.get("projection_source", "")) != "canonical_v2_only":
		return "INCOMPATIBLE_CONTENT_CONTRACT"
	if typeof(projection.get("clues")) != TYPE_ARRAY or typeof(projection.get("recovery_patterns")) != TYPE_ARRAY:
		return "INCOMPATIBLE_CONTENT_CONTRACT"

	var manual := canonical.get("investigation_manual", {}) as Dictionary
	var encounters := canonical.get("recovery_encounters", {}) as Dictionary
	var canonical_record_ids := _id_set(manual.get("evidence_records", []))
	var canonical_pattern_ids := _id_set(encounters.get("patterns", []))
	var canonical_response_ids := _id_set(encounters.get("response_outcomes", []))
	if canonical_record_ids.is_empty() or canonical_pattern_ids.is_empty() or canonical_response_ids.is_empty():
		return "INCOMPATIBLE_CONTENT_CONTRACT"

	var projected_record_ids: Dictionary = {}
	for clue_value in projection.get("clues", []) as Array:
		if typeof(clue_value) != TYPE_DICTIONARY:
			return "INCOMPATIBLE_CONTENT_CONTRACT"
		var clue := clue_value as Dictionary
		var clue_id := String(clue.get("id", ""))
		if clue_id.is_empty() or projected_record_ids.has(clue_id):
			return "INCOMPATIBLE_CONTENT_CONTRACT"
		if not clue_id.begins_with("record_afterlife_") or not canonical_record_ids.has(clue_id):
			return "INCOMPATIBLE_CONTENT_CONTRACT"
		if String(clue.get("title", "")).strip_edges().is_empty() or String(clue.get("description", "")).strip_edges().is_empty():
			return "INCOMPATIBLE_CONTENT_CONTRACT"
		projected_record_ids[clue_id] = true
	if projected_record_ids.size() != canonical_record_ids.size():
		return "INCOMPATIBLE_CONTENT_CONTRACT"

	var projected_pattern_ids: Dictionary = {}
	for pattern_value in projection.get("recovery_patterns", []) as Array:
		if typeof(pattern_value) != TYPE_DICTIONARY:
			return "INCOMPATIBLE_CONTENT_CONTRACT"
		var pattern := pattern_value as Dictionary
		var pattern_id := String(pattern.get("id", ""))
		if pattern_id.is_empty() or projected_pattern_ids.has(pattern_id):
			return "INCOMPATIBLE_CONTENT_CONTRACT"
		if not pattern_id.begins_with("pattern_afterlife_") or not canonical_pattern_ids.has(pattern_id):
			return "INCOMPATIBLE_CONTENT_CONTRACT"
		if not _has_runtime_pattern_text(pattern):
			return "INCOMPATIBLE_CONTENT_CONTRACT"
		if not _record_refs_are_valid(pattern.get("related_clue_ids", []), projected_record_ids, true):
			return "INCOMPATIBLE_CONTENT_CONTRACT"
		var responses_value: Variant = pattern.get("responses")
		if typeof(responses_value) != TYPE_ARRAY or (responses_value as Array).size() < 2:
			return "INCOMPATIBLE_CONTENT_CONTRACT"
		var correct_response_id := String(pattern.get("correct_response_id", ""))
		if correct_response_id.is_empty() or not canonical_response_ids.has(correct_response_id):
			return "INCOMPATIBLE_CONTENT_CONTRACT"
		var response_ids: Dictionary = {}
		var correct_found := false
		for response_value in responses_value as Array:
			if typeof(response_value) != TYPE_DICTIONARY:
				return "INCOMPATIBLE_CONTENT_CONTRACT"
			var response := response_value as Dictionary
			var response_id := String(response.get("id", ""))
			if response_id.is_empty() or response_ids.has(response_id) or not response_id.begins_with("response_afterlife_"):
				return "INCOMPATIBLE_CONTENT_CONTRACT"
			if not _has_runtime_response_text(response):
				return "INCOMPATIBLE_CONTENT_CONTRACT"
			if not _record_refs_are_valid(response.get("supporting_clue_ids", []), projected_record_ids, false):
				return "INCOMPATIBLE_CONTENT_CONTRACT"
			if not _record_refs_are_valid(response.get("contradicted_clue_ids", []), projected_record_ids, false):
				return "INCOMPATIBLE_CONTENT_CONTRACT"
			response_ids[response_id] = true
			if response_id == correct_response_id:
				correct_found = true
				if (response.get("supporting_clue_ids", []) as Array).is_empty():
					return "INCOMPATIBLE_CONTENT_CONTRACT"
		if not correct_found:
			return "INCOMPATIBLE_CONTENT_CONTRACT"
		projected_pattern_ids[pattern_id] = true
	if projected_pattern_ids.size() != canonical_pattern_ids.size():
		return "INCOMPATIBLE_CONTENT_CONTRACT"
	return "OK"


func _has_runtime_pattern_text(pattern: Dictionary) -> bool:
	for key in ["name", "telegraph", "description", "question", "manual_draft", "failure_reason"]:
		if String(pattern.get(key, "")).strip_edges().is_empty():
			return false
	return true


func _has_runtime_response_text(response: Dictionary) -> bool:
	for key in ["label", "ability", "hypothesis", "reasoning", "summary"]:
		if String(response.get(key, "")).strip_edges().is_empty():
			return false
	return true


func _record_refs_are_valid(value: Variant, record_ids: Dictionary, require_nonempty: bool) -> bool:
	if typeof(value) != TYPE_ARRAY:
		return false
	var refs := value as Array
	if require_nonempty and refs.is_empty():
		return false
	for record_id_value in refs:
		var record_id := String(record_id_value)
		if record_id.is_empty() or not record_ids.has(record_id):
			return false
	return true


func _id_set(value: Variant) -> Dictionary:
	var result: Dictionary = {}
	if typeof(value) != TYPE_ARRAY:
		return result
	for item_value in value as Array:
		if typeof(item_value) != TYPE_DICTIONARY:
			continue
		var item_id := String((item_value as Dictionary).get("id", ""))
		if not item_id.is_empty():
			result[item_id] = true
	return result


func _read_layer(path: String, layer_name: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return _result(false, "MISSING_CONTENT_LAYER", {"layer": layer_name, "path": path})
	var bytes := FileAccess.get_file_as_bytes(path)
	var parsed: Variant = JSON.parse_string(bytes.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY:
		return _result(false, "INCOMPATIBLE_CONTENT_CONTRACT", {"layer": layer_name})
	return {
		"ok": true,
		"code": "OK",
		"data": parsed as Dictionary,
		"checksum": _sha256(bytes)
	}


func _sha256(bytes: PackedByteArray) -> String:
	var context := HashingContext.new()
	var started := context.start(HashingContext.HASH_SHA256)
	if started != OK:
		return ""
	var updated := context.update(bytes)
	if updated != OK:
		return ""
	return context.finish().hex_encode()


func _overlay_path(base_path: String) -> String:
	if not base_path.ends_with(".json"):
		return base_path + CORE_VALIDATION_OVERLAY_SUFFIX
	return base_path.trim_suffix(".json") + CORE_VALIDATION_OVERLAY_SUFFIX


func _result(ok: bool, code: String, extra: Dictionary = {}) -> Dictionary:
	var result := {"ok": ok, "code": code}
	for key in extra.keys():
		result[key] = extra[key]
	return result
