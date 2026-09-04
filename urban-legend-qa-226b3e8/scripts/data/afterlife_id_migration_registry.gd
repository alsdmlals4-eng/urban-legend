class_name AfterlifeIdMigrationRegistry
extends RefCounted


const TARGET_CONTRACT := "afterlife-station-canon-v2"
const MIGRATION_ID := "afterlife-station-canon-v2-001"
const ALLOWED_DISPOSITIONS := [
	"KEEP_ID",
	"ALIAS",
	"SPLIT",
	"MERGE",
	"HISTORICAL_ONLY",
	"DISCARD_SEMANTICS"
]
const NON_RUNTIME_DISPOSITIONS := ["HISTORICAL_ONLY", "DISCARD_SEMANTICS"]

var _entries_by_id: Dictionary = {}
var _registry_checksum := ""
var _migration_id := ""
var _target_contract := ""


func load_registry(path: String) -> Dictionary:
	_entries_by_id.clear()
	_registry_checksum = ""
	_migration_id = ""
	_target_contract = ""

	if not FileAccess.file_exists(path):
		return _result(false, "MISSING_REGISTRY")
	var bytes := FileAccess.get_file_as_bytes(path)
	var parsed: Variant = JSON.parse_string(bytes.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY:
		return _result(false, "CORRUPT_REGISTRY")
	var root := parsed as Dictionary
	_migration_id = String(root.get("migration_id", ""))
	_target_contract = String(root.get("target_contract", ""))
	if _migration_id != MIGRATION_ID or _target_contract != TARGET_CONTRACT:
		return _result(false, "INCOMPATIBLE_REGISTRY")

	var entries_value: Variant = root.get("entries")
	if typeof(entries_value) != TYPE_ARRAY:
		return _result(false, "CORRUPT_REGISTRY")
	var effect_ids: Dictionary = {}
	for entry_value in entries_value as Array:
		if typeof(entry_value) != TYPE_DICTIONARY:
			return _result(false, "CORRUPT_REGISTRY")
		var entry := entry_value as Dictionary
		var validation_code := _validate_entry(entry, effect_ids)
		if validation_code != "OK":
			return _result(false, validation_code, {"legacy_id": entry.get("legacy_id", "")})
		var legacy_id := String(entry.get("legacy_id", ""))
		var effect_id := String(entry.get("effect_id", ""))
		_entries_by_id[legacy_id] = entry.duplicate(true)
		effect_ids[effect_id] = true

	_registry_checksum = _sha256(bytes)
	if _registry_checksum.length() != 64:
		return _result(false, "CHECKSUM_FAILED")
	return {
		"ok": true,
		"code": "EXACT",
		"migration_id": _migration_id,
		"target_contract": _target_contract,
		"registry_checksum": _registry_checksum,
		"entry_count": _entries_by_id.size()
	}


func map_value(
	legacy_id: String,
	source_location: String,
	raw_value: Variant,
	applied_effect_ids: Dictionary = {}
) -> Dictionary:
	if _entries_by_id.is_empty():
		return _result(false, "REGISTRY_NOT_LOADED")
	if not _entries_by_id.has(legacy_id):
		return {
			"ok": false,
			"code": "UNMAPPED_LEGACY_ID",
			"runtime_apply": false,
			"orphan": {
				"id": legacy_id,
				"source_contract": "unknown",
				"source_location": source_location,
				"raw_value": _copy_variant(raw_value),
				"reason": "UNMAPPED_LEGACY_ID"
			}
		}

	var entry := (_entries_by_id.get(legacy_id) as Dictionary).duplicate(true)
	var effect_id := String(entry.get("effect_id", ""))
	var disposition := String(entry.get("disposition", ""))
	var target_ids := (entry.get("target_ids", []) as Array).duplicate(true)
	if applied_effect_ids.has(effect_id) and bool(applied_effect_ids.get(effect_id, false)):
		return {
			"ok": true,
			"code": "ALREADY_APPLIED",
			"legacy_id": legacy_id,
			"disposition": disposition,
			"target_ids": target_ids,
			"effect_id": effect_id,
			"runtime_apply": false,
			"preserve_in_history": bool(entry.get("preserve_in_history", true))
		}

	var runtime_apply := bool(entry.get("runtime_apply", false))
	var targets: Array = []
	if runtime_apply:
		for target_id_value in target_ids:
			targets.append({
				"id": String(target_id_value),
				"state": "migrated_unverified",
				"source_legacy_id": legacy_id,
				"source_location": source_location,
				"source_contract": String(entry.get("source_contract", ""))
			})

	return {
		"ok": true,
		"code": "MAPPED",
		"legacy_id": legacy_id,
		"disposition": disposition,
		"target_ids": target_ids,
		"targets": targets,
		"source_contract": String(entry.get("source_contract", "")),
		"target_contract": String(entry.get("target_contract", "")),
		"runtime_apply": runtime_apply,
		"preserve_in_history": bool(entry.get("preserve_in_history", true)),
		"effect_id": effect_id,
		"reason": String(entry.get("reason", "")),
		"raw_value": _copy_variant(raw_value)
	}


func lookup(legacy_id: String) -> Dictionary:
	if not _entries_by_id.has(legacy_id):
		return {}
	return (_entries_by_id.get(legacy_id) as Dictionary).duplicate(true)


func make_history_entry(source_version: String, target_version: String, effect_ids: Array) -> Dictionary:
	return {
		"migration_id": _migration_id if not _migration_id.is_empty() else MIGRATION_ID,
		"registry_checksum": _registry_checksum,
		"source_version": source_version,
		"target_version": target_version,
		"effect_ids": effect_ids.duplicate(true),
		"state": "pending",
		"applied_at_utc": Time.get_datetime_string_from_system(true, true)
	}


func get_registry_checksum() -> String:
	return _registry_checksum


func _validate_entry(entry: Dictionary, effect_ids: Dictionary) -> String:
	var legacy_id := String(entry.get("legacy_id", ""))
	var disposition := String(entry.get("disposition", ""))
	var effect_id := String(entry.get("effect_id", ""))
	if legacy_id.is_empty() or _entries_by_id.has(legacy_id):
		return "DUPLICATE_OR_EMPTY_LEGACY_ID"
	if disposition not in ALLOWED_DISPOSITIONS:
		return "INVALID_DISPOSITION"
	if effect_id.is_empty() or effect_ids.has(effect_id):
		return "DUPLICATE_OR_EMPTY_EFFECT_ID"
	if String(entry.get("target_contract", "")) != TARGET_CONTRACT:
		return "INCOMPATIBLE_REGISTRY"
	if typeof(entry.get("target_ids")) != TYPE_ARRAY:
		return "CORRUPT_REGISTRY"
	var runtime_apply := bool(entry.get("runtime_apply", false))
	if disposition in NON_RUNTIME_DISPOSITIONS and runtime_apply:
		return "INVALID_RUNTIME_POLICY"
	if disposition in NON_RUNTIME_DISPOSITIONS and not (entry.get("target_ids", []) as Array).is_empty():
		return "INVALID_RUNTIME_POLICY"
	if not bool(entry.get("preserve_in_history", false)):
		return "INVALID_HISTORY_POLICY"
	return "OK"


func _copy_variant(value: Variant) -> Variant:
	if typeof(value) == TYPE_DICTIONARY:
		return (value as Dictionary).duplicate(true)
	if typeof(value) == TYPE_ARRAY:
		return (value as Array).duplicate(true)
	return value


func _sha256(bytes: PackedByteArray) -> String:
	var context := HashingContext.new()
	if context.start(HashingContext.HASH_SHA256) != OK:
		return ""
	if context.update(bytes) != OK:
		return ""
	return context.finish().hex_encode()


func _result(ok: bool, code: String, extra: Dictionary = {}) -> Dictionary:
	var result := {"ok": ok, "code": code}
	for key in extra.keys():
		result[key] = extra[key]
	return result
