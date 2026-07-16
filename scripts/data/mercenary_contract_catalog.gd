class_name MercenaryContractCatalog
extends RefCounted

const DATA_PATH := "res://data/mercenary_contracts.json"

var _loaded := false
var _contracts: Array = []


func get_contracts() -> Array:
	_ensure_loaded()
	return _contracts.duplicate(true)


func get_contract(contract_id: String) -> Dictionary:
	_ensure_loaded()
	var clean_id := contract_id.strip_edges()
	for contract_value in _contracts:
		if typeof(contract_value) == TYPE_DICTIONARY and String((contract_value as Dictionary).get("id", "")) == clean_id:
			return (contract_value as Dictionary).duplicate(true)
	return {}


func _ensure_loaded() -> void:
	if _loaded:
		return
	_loaded = true
	var file := FileAccess.open(DATA_PATH, FileAccess.READ)
	if file == null:
		push_error("Mercenary contract data cannot be opened: %s" % DATA_PATH)
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		push_error("Mercenary contract data root must be a Dictionary")
		return
	for contract_value in (parsed as Dictionary).get("contracts", []):
		if typeof(contract_value) != TYPE_DICTIONARY:
			continue
		var contract: Dictionary = (contract_value as Dictionary).duplicate(true)
		if String(contract.get("id", "")).is_empty() or String(contract.get("required_research_project_id", "")).is_empty() or int(contract.get("fragment_cost", 0)) <= 0:
			continue
		_contracts.append(contract)
