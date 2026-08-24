# CASE-01 조사 디바이스가 기존 Canon v2 상태를 읽고 좁은 draft intent만 전달한다.
# UI presentation 전용이며 정답/slot fitness를 계산하거나 저장하지 않는다.
class_name Case01DeviceDataAdapter
extends RefCounted

const CatalogScript := preload("res://scripts/ui/case01_device_catalog.gd")
const SUPPORTED_CASE_ID := "episode_001_afterlife_station"
const SUPPORTED_CONTRACT_ID := "afterlife-station-canon-v2"

var _game_state: Object
var _catalog := CatalogScript.new()


func bind_game_state(game_state: Object) -> void:
	_game_state = game_state


func is_supported() -> bool:
	if _game_state == null:
		return false
	if not _game_state.has_method("get_afterlife_content_contract_id"):
		return false
	if String(_game_state.call("get_afterlife_content_contract_id")) != SUPPORTED_CONTRACT_ID:
		return false
	if _game_state.has_method("get_current_episode_id"):
		return String(_game_state.call("get_current_episode_id")) == SUPPORTED_CASE_ID
	var episode_data: Variant = _game_state.get("current_episode_data")
	return typeof(episode_data) == TYPE_DICTIONARY and String((episode_data as Dictionary).get("id", "")) == SUPPORTED_CASE_ID


func get_shell_snapshot() -> Dictionary:
	return {
		"supported": is_supported(),
		"tabs": _catalog.get_tabs(),
		"lume_copy": {
			"records": _catalog.get_lume_copy("records"),
			"manual": _catalog.get_lume_copy("manual"),
			"map": _catalog.get_lume_copy("map")
		}
	}


func get_records_snapshot() -> Dictionary:
	if not is_supported():
		return {"supported": false, "records": [], "categories": _catalog.get_record_categories()}
	var manual := _get_manual_state()
	return {
		"supported": true,
		"record_ids": _string_array(manual.get("evidence_records", [])),
		"categories": _catalog.get_record_categories()
	}


func get_manual_snapshot() -> Dictionary:
	var manual := _get_manual_state() if is_supported() else {}
	var evidence_ids := _string_array(manual.get("evidence_records", []))
	return {
		"supported": is_supported(),
		"sections": _catalog.get_manual_sections(),
		"keywords": _available_keywords(evidence_ids),
		"filled_slots": _dictionary_copy(manual.get("filled_slots", {})),
		"evidence_record_ids": evidence_ids
	}


func get_map_snapshot() -> Dictionary:
	return {
		"supported": is_supported(),
		"locations": _catalog.get_locations()
	}


func request_manual_slot_assignment(slot_id: String, keyword_id: String) -> Dictionary:
	if not is_supported():
		return {"ok": false, "reason": "unsupported_case_contract"}
	if not _game_state.has_method("apply_afterlife_manual_draft"):
		return {"ok": false, "reason": "manual_draft_api_unavailable"}
	if _catalog.find_keyword(keyword_id).is_empty():
		return {"ok": false, "reason": "unknown_keyword"}
	var current := _dictionary_copy(_get_manual_state().get("filled_slots", {}))
	current[slot_id] = keyword_id
	return _game_state.call("apply_afterlife_manual_draft", {"filled_slots": current})


func request_manual_slot_clear(slot_id: String) -> Dictionary:
	if not is_supported():
		return {"ok": false, "reason": "unsupported_case_contract"}
	if not _game_state.has_method("apply_afterlife_manual_draft"):
		return {"ok": false, "reason": "manual_draft_api_unavailable"}
	var current := _dictionary_copy(_get_manual_state().get("filled_slots", {}))
	current.erase(slot_id)
	return _game_state.call("apply_afterlife_manual_draft", {"filled_slots": current})


func _get_manual_state() -> Dictionary:
	if _game_state == null or not _game_state.has_method("get_afterlife_manual_state"):
		return {}
	var value: Variant = _game_state.call("get_afterlife_manual_state")
	return (value as Dictionary).duplicate(true) if typeof(value) == TYPE_DICTIONARY else {}


func _available_keywords(evidence_ids: Array[String]) -> Array:
	var available: Array = []
	var unlocked_ids: Dictionary = {}
	for keyword_value in _catalog.get_keywords():
		if typeof(keyword_value) != TYPE_DICTIONARY:
			continue
		var keyword := keyword_value as Dictionary
		var keyword_id := String(keyword.get("id", ""))
		var source_record_ids := _string_array(keyword.get("source_record_ids", []))
		var source_keyword_id := String(keyword.get("source_keyword_id", ""))
		var unlocked := not source_record_ids.is_empty()
		for record_id in source_record_ids:
			if not evidence_ids.has(record_id):
				unlocked = false
				break
		if source_record_ids.is_empty() and not source_keyword_id.is_empty():
			unlocked = unlocked_ids.has(source_keyword_id)
		if unlocked:
			available.append(keyword.duplicate(true))
			unlocked_ids[keyword_id] = true
	return available


func _dictionary_copy(value: Variant) -> Dictionary:
	return (value as Dictionary).duplicate(true) if typeof(value) == TYPE_DICTIONARY else {}


func _string_array(value: Variant) -> Array[String]:
	var result: Array[String] = []
	if typeof(value) != TYPE_ARRAY:
		return result
	for item in value as Array:
		if typeof(item) == TYPE_STRING or typeof(item) == TYPE_STRING_NAME:
			result.append(String(item))
	return result
