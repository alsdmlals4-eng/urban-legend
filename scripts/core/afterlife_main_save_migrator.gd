class_name AfterlifeMainSaveMigrator
extends RefCounted


const TARGET_VERSION := "mvp-040"
const TARGET_CONTRACT := "afterlife-station-canon-v2"
const SAFE_CHECKPOINT_ID := "afterlife:v2:safe-investigation-entry"
const SAFE_SCENE_PATH := "res://scenes/investigation_scene.tscn"
const SUPPORTED_SOURCE_VERSIONS := ["mvp-038", "mvp-039"]
const PROTECTED_KEYS := [
	"campaign_state",
	"echo_fragments",
	"granted_reward_ids",
	"faction_relations",
	"consumable_inventory",
	"unlocked_equipment",
	"agent_trust",
	"completed_case_reports"
]


func migrate(inspected: Dictionary, registry: Object) -> Dictionary:
	if String(inspected.get("code", "")) != "MIGRATABLE_MAIN":
		return _result(false, "INVALID_INSPECTION_RESULT")
	if registry == null or not registry.has_method("map_value") or not registry.has_method("make_history_entry"):
		return _result(false, "INVALID_MIGRATION_REGISTRY")

	var source_version := String(inspected.get("source_version", ""))
	if source_version not in SUPPORTED_SOURCE_VERSIONS:
		return _result(false, "UNSUPPORTED_SOURCE_VERSION")
	var source_payload_value: Variant = inspected.get("payload")
	if typeof(source_payload_value) != TYPE_DICTIONARY:
		return _result(false, "CORRUPT_MIGRATION_SOURCE")

	var source_payload := source_payload_value as Dictionary
	var payload := source_payload.duplicate(true)
	var protected_before := _protected_snapshot(source_payload)
	var run_stage := String(inspected.get("run_stage", ""))
	var effect_ids: Array = []
	var evidence_by_id: Dictionary = {}
	var notes: Array = []
	var orphans: Array = []
	var applied_effect_ids := _existing_applied_effect_ids(payload)

	for source_location in ["collected_clue_ids", "unlocked_records"]:
		var source_ids_value: Variant = payload.get(source_location, [])
		if typeof(source_ids_value) != TYPE_ARRAY:
			continue
		for legacy_id_value in source_ids_value as Array:
			var legacy_id := String(legacy_id_value)
			if legacy_id.is_empty():
				continue
			var mapped: Dictionary = registry.map_value(
				legacy_id,
				source_location,
				legacy_id_value,
				applied_effect_ids
			)
			var mapped_code := String(mapped.get("code", ""))
			if mapped_code == "UNMAPPED_LEGACY_ID":
				var orphan_value: Variant = mapped.get("orphan")
				if typeof(orphan_value) == TYPE_DICTIONARY:
					orphans.append((orphan_value as Dictionary).duplicate(true))
				continue
			if mapped_code == "ALREADY_APPLIED":
				continue
			if mapped_code != "MAPPED":
				return _result(false, "MIGRATION_VALIDATION_FAILED", {"legacy_id": legacy_id, "mapping_code": mapped_code})

			var effect_id := String(mapped.get("effect_id", ""))
			if not effect_id.is_empty() and not effect_ids.has(effect_id):
				effect_ids.append(effect_id)
				applied_effect_ids[effect_id] = true

			if bool(mapped.get("runtime_apply", false)):
				var targets_value: Variant = mapped.get("targets", [])
				if typeof(targets_value) == TYPE_ARRAY:
					for target_value in targets_value as Array:
						if typeof(target_value) != TYPE_DICTIONARY:
							continue
						var target := (target_value as Dictionary).duplicate(true)
						var target_id := String(target.get("id", ""))
						if not target_id.is_empty() and not evidence_by_id.has(target_id):
							evidence_by_id[target_id] = target
			else:
				notes.append(_make_note(mapped, source_location, legacy_id_value))

	var manual_state := "draft_active" if run_stage == "INVESTIGATION_ACTIVE" else "unstarted"
	var afterlife_v2 := {
		"content_contract_id": TARGET_CONTRACT,
		"source_version": source_version,
		"source_checksum": String(inspected.get("source_checksum", "")),
		"run_state": "new_run_ready",
		"manual": {
			"state": manual_state,
			"filled_slots": {},
			"evidence_records": evidence_by_id.values()
		}
	}

	var result_code := _source_result_code(source_version)
	match run_stage:
		"PRE_RUN":
			afterlife_v2["run_state"] = "new_run_ready"
		"INVESTIGATION_ACTIVE":
			afterlife_v2["run_state"] = "draft_active"
		"LEGACY_RESCUE_OR_RECOVERY_ACTIVE":
			afterlife_v2["run_state"] = "legacy_case_restart_required"
			afterlife_v2["restart_penalty"] = 0
			afterlife_v2["safe_checkpoint_id"] = SAFE_CHECKPOINT_ID
			notes.append({
				"legacy_id": String(payload.get("current_recovery_pattern_id", "")),
				"source_location": "current_recovery_pattern_id",
				"disposition": "HISTORICAL_ONLY",
				"reason": "진행 중 구형 구출·회수는 직접 변환하지 않고 안전 조사 체크포인트에서 재시작한다.",
				"raw_value": String(payload.get("current_recovery_pattern_id", ""))
			})
			payload["current_scene_path"] = SAFE_SCENE_PATH
			payload["current_recovery_pattern_id"] = ""
			payload["forced_recovery_phase"] = false
			result_code = "LEGACY_CASE_RESTART_REQUIRED"
		"LEGACY_COMPLETED":
			afterlife_v2["run_state"] = "legacy_completed_history"
			payload["legacy_resolution_snapshot"] = _make_legacy_resolution_snapshot(source_payload)
			payload["first_v2_investigation"] = {
				"status": "not_started",
				"s_rank_awarded": false,
				"campaign_canon_overwrite": false,
				"reward_reissued": false
			}
		_:
			return _result(false, "AMBIGUOUS_LEGACY_STAGE")

	payload["save_version"] = TARGET_VERSION
	payload["content_contract_id"] = TARGET_CONTRACT
	payload["afterlife_canon_v2"] = afterlife_v2
	payload["legacy_migration_notes"] = notes
	payload["orphan_legacy_ids"] = orphans
	payload["applied_migration_effect_ids"] = applied_effect_ids

	var history := _existing_history(payload)
	history.append(registry.make_history_entry(source_version, TARGET_VERSION, effect_ids))
	payload["migration_history"] = history

	if _protected_snapshot(payload) != protected_before:
		return _result(false, "MIGRATION_VALIDATION_FAILED", {"field": "protected_state"})
	if not _manual_contract_is_safe(payload):
		return _result(false, "MIGRATION_VALIDATION_FAILED", {"field": "manual"})

	return {
		"ok": true,
		"code": result_code,
		"payload": payload,
		"source_version": source_version,
		"target_version": TARGET_VERSION,
		"effect_ids": effect_ids.duplicate(true),
		"orphan_count": orphans.size()
	}


func _make_note(mapped: Dictionary, source_location: String, raw_value: Variant) -> Dictionary:
	return {
		"legacy_id": String(mapped.get("legacy_id", "")),
		"source_location": source_location,
		"disposition": String(mapped.get("disposition", "")),
		"effect_id": String(mapped.get("effect_id", "")),
		"reason": String(mapped.get("reason", "")),
		"raw_value": _copy_variant(raw_value)
	}


func _make_legacy_resolution_snapshot(source_payload: Dictionary) -> Dictionary:
	return {
		"read_only": true,
		"content_contract_id": String(source_payload.get("content_contract_id", "afterlife-station-legacy-v1")),
		"capture_success": bool(source_payload.get("capture_success", false)),
		"capture_result_state": String(source_payload.get("capture_result_state", "")),
		"grade": String(source_payload.get("selected_resolution_grade", "")),
		"completed_case_reports": _copy_variant(source_payload.get("completed_case_reports", [])),
		"granted_reward_ids": _copy_variant(source_payload.get("granted_reward_ids", []))
	}


func _manual_contract_is_safe(payload: Dictionary) -> bool:
	var v2_value: Variant = payload.get("afterlife_canon_v2")
	if typeof(v2_value) != TYPE_DICTIONARY:
		return false
	var manual_value: Variant = (v2_value as Dictionary).get("manual")
	if typeof(manual_value) != TYPE_DICTIONARY:
		return false
	var manual := manual_value as Dictionary
	if typeof(manual.get("filled_slots")) != TYPE_DICTIONARY or not (manual.get("filled_slots") as Dictionary).is_empty():
		return false
	var evidence_value: Variant = manual.get("evidence_records")
	if typeof(evidence_value) != TYPE_ARRAY:
		return false
	for record_value in evidence_value as Array:
		if typeof(record_value) != TYPE_DICTIONARY:
			return false
		if String((record_value as Dictionary).get("state", "")) != "migrated_unverified":
			return false
	return true


func _protected_snapshot(payload: Dictionary) -> Dictionary:
	var result := {}
	for key in PROTECTED_KEYS:
		result[key] = _copy_variant(payload.get(key))
	return result


func _existing_history(payload: Dictionary) -> Array:
	var value: Variant = payload.get("migration_history", [])
	return (value as Array).duplicate(true) if typeof(value) == TYPE_ARRAY else []


func _existing_applied_effect_ids(payload: Dictionary) -> Dictionary:
	var value: Variant = payload.get("applied_migration_effect_ids", {})
	return (value as Dictionary).duplicate(true) if typeof(value) == TYPE_DICTIONARY else {}


func _source_result_code(source_version: String) -> String:
	return "MIGRATED_FROM_MVP_038" if source_version == "mvp-038" else "MIGRATED_FROM_MVP_039"


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
