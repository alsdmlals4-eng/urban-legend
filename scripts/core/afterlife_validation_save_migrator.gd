class_name AfterlifeValidationSaveMigrator
extends RefCounted


const TARGET_VERSION := "validation-save-v2"
const TARGET_SCHEMA := 2
const TARGET_CONTRACT := "afterlife-station-canon-v2"
const SAFE_CHECKPOINT_ID := "afterlife:v2:safe-investigation-entry"
const SAFE_RETURN_TARGET := "res://scenes/investigation_scene.tscn"
const SUPPORTED_STAGES := [
	"VALIDATION_ACTIVE",
	"VALIDATION_SUSPENDED",
	"VALIDATION_COMPLETED"
]


func migrate(inspected: Dictionary, registry: Object) -> Dictionary:
	if String(inspected.get("code", "")) != "MIGRATABLE_VALIDATION":
		return _result(false, "INVALID_INSPECTION_RESULT")
	if registry == null or not registry.has_method("map_value") or not registry.has_method("make_history_entry"):
		return _result(false, "INVALID_MIGRATION_REGISTRY")
	var stage := String(inspected.get("run_stage", ""))
	if stage not in SUPPORTED_STAGES:
		return _result(false, "AMBIGUOUS_LEGACY_STAGE")
	var source_value: Variant = inspected.get("payload")
	if typeof(source_value) != TYPE_DICTIONARY:
		return _result(false, "CORRUPT_MIGRATION_SOURCE")

	var source := source_value as Dictionary
	var payload := source.duplicate(true)
	var source_copy := source.duplicate(true)
	var session := _dictionary_copy(payload.get("session"))
	var snapshots := _dictionary_copy(payload.get("snapshots"))
	var result_block := _dictionary_copy(payload.get("result"))
	var reasoning := _dictionary_copy(snapshots.get("reasoning"))
	var route := _dictionary_copy(snapshots.get("route"))
	var recovery := _dictionary_copy(snapshots.get("recovery"))
	var evidence_by_id: Dictionary = {}
	var notes: Array = []
	var orphans: Array = []
	var effect_ids: Array = []
	var applied: Dictionary = {}

	for source_location in ["collected_clue_ids", "hypothesis_ids"]:
		var ids_value: Variant = reasoning.get(source_location, [])
		if typeof(ids_value) != TYPE_ARRAY:
			continue
		for legacy_value in ids_value as Array:
			var legacy_id := String(legacy_value)
			if legacy_id.is_empty():
				continue
			var mapped: Dictionary = registry.map_value(legacy_id, "snapshots.reasoning.%s" % source_location, legacy_value, applied)
			var code := String(mapped.get("code", ""))
			if code == "UNMAPPED_LEGACY_ID":
				var orphan_value: Variant = mapped.get("orphan")
				if typeof(orphan_value) == TYPE_DICTIONARY:
					orphans.append((orphan_value as Dictionary).duplicate(true))
				continue
			if code == "ALREADY_APPLIED":
				continue
			if code != "MAPPED":
				return _result(false, "MIGRATION_VALIDATION_FAILED", {"legacy_id": legacy_id, "mapping_code": code})
			var effect_id := String(mapped.get("effect_id", ""))
			if not effect_id.is_empty() and not effect_ids.has(effect_id):
				effect_ids.append(effect_id)
				applied[effect_id] = true
			if bool(mapped.get("runtime_apply", false)):
				for target_value in mapped.get("targets", []) as Array:
					if typeof(target_value) != TYPE_DICTIONARY:
						continue
					var target := (target_value as Dictionary).duplicate(true)
					var target_id := String(target.get("id", ""))
					if not target_id.is_empty() and not evidence_by_id.has(target_id):
						evidence_by_id[target_id] = target
			else:
				notes.append(_note_from_mapping(mapped, source_location, legacy_value))

	var legacy_lifecycle := String(session.get("lifecycle", ""))
	var legacy_correct_response := String(route.get("correct_response_id", ""))
	var legacy_snapshot := {
		"read_only": true,
		"source_version": String(inspected.get("source_version", "")),
		"source_checksum": String(inspected.get("source_checksum", "")),
		"lifecycle": legacy_lifecycle,
		"flow_stage": String(session.get("flow_stage", "")),
		"checkpoint_id": String(session.get("checkpoint_id", "")),
		"return_target": String(session.get("return_target", "")),
		"correct_response_id": legacy_correct_response,
		"reasoning": reasoning.duplicate(true),
		"route": route.duplicate(true),
		"recovery": recovery.duplicate(true),
		"result": result_block.duplicate(true)
	}
	if not legacy_correct_response.is_empty():
		notes.append({
			"legacy_id": legacy_correct_response,
			"source_location": "snapshots.route.correct_response_id",
			"disposition": "HISTORICAL_ONLY",
			"reason": "구형 correct_response_id를 Canon v2 정답으로 사용하지 않는다.",
			"raw_value": legacy_correct_response
		})

	if stage == "VALIDATION_COMPLETED":
		session["lifecycle"] = "completed"
	else:
		session["lifecycle"] = "suspended"
		session["flow_stage"] = "SIT-V2-SAFE-INVESTIGATION"
		session["checkpoint_id"] = SAFE_CHECKPOINT_ID
		session["return_target"] = SAFE_RETURN_TARGET
		session["focus_token"] = ""

	var migrated_runtime := _dictionary_copy(snapshots.get("runtime"))
	if stage != "VALIDATION_COMPLETED":
		migrated_runtime["current_scene_path"] = SAFE_RETURN_TARGET
		migrated_runtime["current_recovery_pattern_id"] = ""
		migrated_runtime["forced_recovery_phase"] = false

	snapshots["runtime"] = migrated_runtime
	snapshots["reasoning"] = {
		"migration_notes": notes.duplicate(true),
		"orphan_legacy_ids": orphans.duplicate(true)
	}
	snapshots["route"] = {}
	snapshots["recovery"] = {}

	result_block["applied_effect_ids"] = {}
	result_block["candidate_records"] = {}
	payload["version"] = TARGET_VERSION
	payload["payload_schema"] = TARGET_SCHEMA
	payload["content_contract_id"] = TARGET_CONTRACT
	payload["session"] = session
	payload["snapshots"] = snapshots
	payload["result"] = result_block
	payload["legacy_validation_snapshot"] = legacy_snapshot
	payload["afterlife_canon_v2"] = {
		"run_state": "legacy_validation_completed_history" if stage == "VALIDATION_COMPLETED" else "safe_reinvestigation_ready",
		"manual": {
			"state": "historical_read_only" if stage == "VALIDATION_COMPLETED" else "draft_active",
			"filled_slots": {},
			"evidence_records": evidence_by_id.values()
		},
		"legacy_migration_notes": notes.duplicate(true),
		"orphan_legacy_ids": orphans.duplicate(true)
	}

	var history := _array_copy(payload.get("migration_history"))
	history.append(registry.make_history_entry("validation-save-v1", TARGET_VERSION, effect_ids))
	payload["migration_history"] = history

	if source != source_copy:
		return _result(false, "MIGRATION_VALIDATION_FAILED", {"field": "source_mutated"})
	if not _validate_target(payload, stage):
		return _result(false, "MIGRATION_VALIDATION_FAILED")
	return {
		"ok": true,
		"code": "MIGRATED_FROM_VALIDATION_V1",
		"payload": payload,
		"source_version": "validation-save-v1",
		"target_version": TARGET_VERSION,
		"effect_ids": effect_ids.duplicate(true),
		"orphan_count": orphans.size()
	}


func _validate_target(payload: Dictionary, stage: String) -> bool:
	if String(payload.get("version", "")) != TARGET_VERSION or int(payload.get("payload_schema", 0)) != TARGET_SCHEMA:
		return false
	if String(payload.get("content_contract_id", "")) != TARGET_CONTRACT:
		return false
	var session := _dictionary_copy(payload.get("session"))
	if stage == "VALIDATION_COMPLETED":
		if String(session.get("lifecycle", "")) != "completed":
			return false
	elif String(session.get("lifecycle", "")) != "suspended" or String(session.get("checkpoint_id", "")) != SAFE_CHECKPOINT_ID:
		return false
	var snapshots := _dictionary_copy(payload.get("snapshots"))
	if not _dictionary_copy(snapshots.get("route")).is_empty() or not _dictionary_copy(snapshots.get("recovery")).is_empty():
		return false
	var manual := _dictionary_copy(_dictionary_copy(payload.get("afterlife_canon_v2")).get("manual"))
	if not _dictionary_copy(manual.get("filled_slots")).is_empty():
		return false
	for record_value in _array_copy(manual.get("evidence_records")):
		if typeof(record_value) != TYPE_DICTIONARY or String((record_value as Dictionary).get("state", "")) != "migrated_unverified":
			return false
	var result_block := _dictionary_copy(payload.get("result"))
	var effects := _dictionary_copy(result_block.get("applied_effect_ids"))
	return not effects.has("validation:afterlife:completion:v2")


func _note_from_mapping(mapped: Dictionary, source_location: String, raw_value: Variant) -> Dictionary:
	return {
		"legacy_id": String(mapped.get("legacy_id", "")),
		"source_location": "snapshots.reasoning.%s" % source_location,
		"disposition": String(mapped.get("disposition", "")),
		"effect_id": String(mapped.get("effect_id", "")),
		"reason": String(mapped.get("reason", "")),
		"raw_value": _copy_variant(raw_value)
	}


func _dictionary_copy(value: Variant) -> Dictionary:
	return (value as Dictionary).duplicate(true) if typeof(value) == TYPE_DICTIONARY else {}


func _array_copy(value: Variant) -> Array:
	return (value as Array).duplicate(true) if typeof(value) == TYPE_ARRAY else []


func _copy_variant(value: Variant) -> Variant:
	if typeof(value) == TYPE_DICTIONARY:
		return (value as Dictionary).duplicate(true)
	if typeof(value) == TYPE_ARRAY:
		return (value as Array).duplicate(true)
	return value


func _result(ok: bool, code: String, extra: Dictionary = {}) -> Dictionary:
	var result := {"ok": ok, "code": code}
	for key in extra.keys():
		result[key] = extra[key]
	return result
