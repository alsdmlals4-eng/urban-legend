class_name CoreMvp001CaseData
extends RefCounted


static func load_case(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {}
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		return {}
	return (parsed as Dictionary).duplicate(true)


static func validate_case(data: Dictionary) -> Array[String]:
	var errors: Array[String] = []
	if String(data.get("contract_version", "")) != "core-mvp-001-v1":
		errors.append("contract_version must be core-mvp-001-v1")

	var required_lists := [
		"clues",
		"manual_records",
		"investigation_scenes",
		"choices",
		"elimination_rules",
		"hypotheses",
		"field_tests",
		"recovery_patterns",
		"recovery_actions",
		"recovery_sequence",
		"outcomes"
	]
	for key in required_lists:
		if typeof(data.get(key)) != TYPE_ARRAY:
			errors.append("%s must be an array" % key)

	if not errors.is_empty():
		return errors

	var all_ids: Dictionary = {}
	for key in required_lists:
		if key == "recovery_sequence":
			continue
		for value in data.get(key, []):
			if typeof(value) != TYPE_DICTIONARY:
				errors.append("%s entries must be dictionaries" % key)
				continue
			var entry := value as Dictionary
			var entry_id := String(entry.get("id", ""))
			if entry_id.is_empty() or not entry_id.begins_with("poc001_"):
				errors.append("%s has invalid id %s" % [key, entry_id])
			elif all_ids.has(entry_id):
				errors.append("duplicate id %s" % entry_id)
			else:
				all_ids[entry_id] = key

	var exact_counts := {
		"investigation_scenes": 3,
		"clues": 6,
		"manual_records": 3,
		"choices": 4,
		"hypotheses": 2,
		"recovery_patterns": 3
	}
	for key in exact_counts:
		if (data.get(key, []) as Array).size() != int(exact_counts[key]):
			errors.append("%s must contain %d entries" % [key, exact_counts[key]])

	var reference_fields := [
		"scene_id",
		"clue_id",
		"record_id",
		"choice_id",
		"hypothesis_id",
		"field_test_id",
		"pattern_id",
		"action_id",
		"outcome_id"
	]
	var reference_list_fields := [
		"clue_ids",
		"required_supporting_clue_ids",
		"required_contradiction_clue_ids",
		"unresolved_question_ids",
		"generic_mitigation_action_ids",
		"valid_action_ids",
		"valid_action_ids_after_observation"
	]
	_validate_references(data, all_ids, reference_fields, reference_list_fields, errors)

	for pattern_id in data.get("recovery_sequence", []):
		if not all_ids.has(String(pattern_id)):
			errors.append("recovery sequence references missing pattern %s" % pattern_id)

	var hidden_count := 0
	for value in data.get("recovery_patterns", []):
		var pattern := value as Dictionary
		if bool(pattern.get("first_use_hidden", false)):
			hidden_count += 1
			if (pattern.get("generic_mitigation_action_ids", []) as Array).is_empty():
				errors.append("hidden pattern requires generic mitigation")
			if int(pattern.get("max_first_observation_damage", 999)) > 18:
				errors.append("hidden pattern first damage must be 18 or lower")
	if hidden_count != 1:
		errors.append("exactly one hidden recovery pattern is required")

	var capture := data.get("capture_rule", {}) as Dictionary
	if (capture.get("required_capture_marks", []) as Array).size() != 3:
		errors.append("capture rule requires three marks")
	if int(capture.get("min_capture_turn", 0)) != 5:
		errors.append("minimum capture turn must be five")
	if int(capture.get("max_recovery_turn", 0)) != 8:
		errors.append("maximum recovery turn must be eight")

	return errors


static func index_by_id(entries: Array) -> Dictionary:
	var index: Dictionary = {}
	for value in entries:
		if typeof(value) != TYPE_DICTIONARY:
			continue
		var entry := value as Dictionary
		var entry_id := String(entry.get("id", ""))
		if not entry_id.is_empty():
			index[entry_id] = entry.duplicate(true)
	return index


static func _validate_references(
	value: Variant,
	all_ids: Dictionary,
	reference_fields: Array,
	reference_list_fields: Array,
	errors: Array[String]
) -> void:
	if typeof(value) == TYPE_DICTIONARY:
		var dictionary := value as Dictionary
		for key in dictionary:
			var child: Variant = dictionary[key]
			if reference_fields.has(String(key)) and typeof(child) == TYPE_STRING:
				if not all_ids.has(String(child)):
					errors.append("%s references missing id %s" % [key, child])
			elif reference_list_fields.has(String(key)) and typeof(child) == TYPE_ARRAY:
				for reference in child:
					if not all_ids.has(String(reference)):
						errors.append("%s references missing id %s" % [key, reference])
			_validate_references(child, all_ids, reference_fields, reference_list_fields, errors)
	elif typeof(value) == TYPE_ARRAY:
		for child in value as Array:
			_validate_references(child, all_ids, reference_fields, reference_list_fields, errors)
