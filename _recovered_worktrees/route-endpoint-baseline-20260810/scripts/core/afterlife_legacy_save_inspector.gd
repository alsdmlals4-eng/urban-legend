class_name AfterlifeLegacySaveInspector
extends RefCounted


const TARGET_EPISODE_ID := "episode_001_afterlife_station"
const MAIN_READABLE_VERSIONS := ["mvp-038", "mvp-039"]
const VALIDATION_READABLE_VERSIONS := ["validation-save-v1"]
const VALIDATION_FORMAT := "urban-legend-validation-save"
const MAIN_PRE_RUN_SCENES := [
	"res://scenes/main_menu.tscn",
	"res://scenes/preparation_scene.tscn"
]
const MAIN_INVESTIGATION_SCENES := [
	"res://scenes/dialogue_scene.tscn",
	"res://scenes/investigation_scene.tscn"
]
const MAIN_RECOVERY_SCENES := ["res://scenes/battle_scene.tscn"]
const MAIN_RESULT_SCENES := ["res://scenes/result_scene.tscn"]


func inspect_main_bytes(bytes: PackedByteArray) -> Dictionary:
	var parsed_result := _parse_bytes(bytes)
	if not bool(parsed_result.get("ok", false)):
		return parsed_result
	var payload := parsed_result.get("payload", {}) as Dictionary
	var source_version := String(payload.get("save_version", ""))
	if source_version not in MAIN_READABLE_VERSIONS:
		return _inspection_error("UNSUPPORTED_SOURCE_VERSION", bytes, source_version, payload)
	var episode_id := String(payload.get("episode_id", ""))
	if episode_id != TARGET_EPISODE_ID:
		return _inspection_error("CONTENT_EPISODE_MISMATCH", bytes, source_version, payload, episode_id)
	var stage_result := _classify_main_stage(payload)
	if not bool(stage_result.get("ok", false)):
		return _inspection_error(String(stage_result.get("code", "AMBIGUOUS_LEGACY_STAGE")), bytes, source_version, payload, episode_id)
	return {
		"ok": true,
		"code": "MIGRATABLE_MAIN",
		"source_kind": "main",
		"source_version": source_version,
		"source_checksum": _sha256(bytes),
		"episode_id": episode_id,
		"content_contract_id": String(payload.get("content_contract_id", "afterlife-station-legacy-v1")),
		"run_stage": String(stage_result.get("stage", "")),
		"payload": payload.duplicate(true)
	}


func inspect_validation_bytes(bytes: PackedByteArray) -> Dictionary:
	var parsed_result := _parse_bytes(bytes)
	if not bool(parsed_result.get("ok", false)):
		return parsed_result
	var payload := parsed_result.get("payload", {}) as Dictionary
	if String(payload.get("format", "")) != VALIDATION_FORMAT:
		return _inspection_error("CORRUPT_MIGRATION_SOURCE", bytes, String(payload.get("version", "")), payload)
	var source_version := String(payload.get("version", ""))
	if source_version not in VALIDATION_READABLE_VERSIONS:
		return _inspection_error("UNSUPPORTED_SOURCE_VERSION", bytes, source_version, payload)
	var session_value: Variant = payload.get("session")
	var integrity_value: Variant = payload.get("integrity")
	if typeof(session_value) != TYPE_DICTIONARY or typeof(integrity_value) != TYPE_DICTIONARY:
		return _inspection_error("CORRUPT_MIGRATION_SOURCE", bytes, source_version, payload)
	var session := session_value as Dictionary
	var integrity := integrity_value as Dictionary
	var episode_id := String(session.get("episode_id", ""))
	if episode_id != TARGET_EPISODE_ID or String(integrity.get("content_episode_id", "")) != episode_id:
		return _inspection_error("CONTENT_EPISODE_MISMATCH", bytes, source_version, payload, episode_id)
	var lifecycle := String(session.get("lifecycle", ""))
	if lifecycle not in ["active", "suspended", "completed"]:
		return _inspection_error("AMBIGUOUS_LEGACY_STAGE", bytes, source_version, payload, episode_id)
	return {
		"ok": true,
		"code": "MIGRATABLE_VALIDATION",
		"source_kind": "validation",
		"source_version": source_version,
		"source_checksum": _sha256(bytes),
		"episode_id": episode_id,
		"content_contract_id": String(payload.get("content_contract_id", "afterlife-station-legacy-v1")),
		"run_stage": "VALIDATION_%s" % lifecycle.to_upper(),
		"payload": payload.duplicate(true)
	}


func _classify_main_stage(payload: Dictionary) -> Dictionary:
	var scene_path := String(payload.get("current_scene_path", ""))
	var completed := bool(payload.get("capture_success", false)) or _has_completed_afterlife_report(payload)
	var recovery := (
		scene_path in MAIN_RECOVERY_SCENES
		or bool(payload.get("forced_recovery_phase", false))
		or not String(payload.get("current_recovery_pattern_id", "")).is_empty()
	)
	var pre_run := scene_path in MAIN_PRE_RUN_SCENES
	var investigation := scene_path in MAIN_INVESTIGATION_SCENES
	var result_scene := scene_path in MAIN_RESULT_SCENES

	if completed:
		return {"ok": true, "code": "OK", "stage": "LEGACY_COMPLETED"}
	if pre_run and recovery:
		return {"ok": false, "code": "AMBIGUOUS_LEGACY_STAGE"}
	if recovery:
		return {"ok": true, "code": "OK", "stage": "LEGACY_RESCUE_OR_RECOVERY_ACTIVE"}
	if pre_run:
		return {"ok": true, "code": "OK", "stage": "PRE_RUN"}
	if investigation:
		return {"ok": true, "code": "OK", "stage": "INVESTIGATION_ACTIVE"}
	if result_scene:
		return {"ok": false, "code": "AMBIGUOUS_LEGACY_STAGE"}
	return {"ok": false, "code": "AMBIGUOUS_LEGACY_STAGE"}


func _has_completed_afterlife_report(payload: Dictionary) -> bool:
	var reports_value: Variant = payload.get("completed_case_reports", [])
	if typeof(reports_value) != TYPE_ARRAY:
		return false
	for report_value in reports_value as Array:
		if typeof(report_value) != TYPE_DICTIONARY:
			continue
		var report := report_value as Dictionary
		if String(report.get("episode_id", "")) == TARGET_EPISODE_ID:
			return true
	return false


func _parse_bytes(bytes: PackedByteArray) -> Dictionary:
	var parsed: Variant = JSON.parse_string(bytes.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY:
		return {
			"ok": false,
			"code": "CORRUPT_MIGRATION_SOURCE",
			"source_checksum": _sha256(bytes)
		}
	return {"ok": true, "code": "OK", "payload": parsed as Dictionary}


func _inspection_error(
	code: String,
	bytes: PackedByteArray,
	source_version: String,
	payload: Dictionary,
	episode_id: String = ""
) -> Dictionary:
	return {
		"ok": false,
		"code": code,
		"source_version": source_version,
		"source_checksum": _sha256(bytes),
		"episode_id": episode_id,
		"payload": payload.duplicate(true)
	}


func _sha256(bytes: PackedByteArray) -> String:
	var context := HashingContext.new()
	if context.start(HashingContext.HASH_SHA256) != OK:
		return ""
	if context.update(bytes) != OK:
		return ""
	return context.finish().hex_encode()
