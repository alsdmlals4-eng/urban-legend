class_name AfterlifeCanonV2Loader
extends RefCounted


const CONTRACT_ID := "afterlife-station-canon-v2"
const TARGET_EPISODE_ID := "episode_001_afterlife_station"
const CONTENT_SCHEMA := 2
const DEFAULT_SIDECAR_PATH := "res://data/episodes/episode_001_afterlife_station_canon_v2.json"
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
	sidecar_path: String = DEFAULT_SIDECAR_PATH
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
		"layer_checksums": layer_checksums
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
