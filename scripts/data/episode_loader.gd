# 에피소드 JSON 파일을 읽어 사건 데이터 Dictionary로 변환한다.
class_name EpisodeLoader
extends RefCounted


const CORE_VALIDATION_OVERLAY_SUFFIX := "_core_validation.json"


## Loads one episode JSON file and returns an empty Dictionary when loading fails.
func load_episode(file_path: String) -> Dictionary:
	var parsed_data := _read_dictionary(file_path, "Episode")
	if parsed_data.is_empty():
		return {}

	return _apply_optional_core_validation_overlay(file_path, parsed_data)


func _read_dictionary(file_path: String, label: String) -> Dictionary:
	if not FileAccess.file_exists(file_path):
		push_error("%s file not found: %s" % [label, file_path])
		return {}

	var file := FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		push_error("%s file cannot be opened: %s" % [label, file_path])
		return {}

	var parsed_data: Variant = JSON.parse_string(file.get_as_text())
	if typeof(parsed_data) != TYPE_DICTIONARY:
		push_error("%s JSON root must be a Dictionary: %s" % [label, file_path])
		return {}

	return parsed_data


func _apply_optional_core_validation_overlay(file_path: String, base_data: Dictionary) -> Dictionary:
	if not file_path.ends_with(".json") or file_path.ends_with(CORE_VALIDATION_OVERLAY_SUFFIX):
		return base_data

	var overlay_path := file_path.trim_suffix(".json") + CORE_VALIDATION_OVERLAY_SUFFIX
	if not FileAccess.file_exists(overlay_path):
		return base_data

	var overlay := _read_dictionary(overlay_path, "Core validation overlay")
	if overlay.is_empty():
		return base_data

	var episode := base_data.get("episode", {})
	var episode_id := String(episode.get("id", "")) if typeof(episode) == TYPE_DICTIONARY else ""
	var target_episode_id := String(overlay.get("target_episode_id", ""))
	if episode_id.is_empty() or target_episode_id != episode_id:
		push_error("Core validation overlay target mismatch: %s -> %s" % [overlay_path, episode_id])
		return base_data

	var overrides: Variant = overlay.get("overrides", {})
	if typeof(overrides) != TYPE_DICTIONARY:
		push_error("Core validation overlay overrides must be a Dictionary: %s" % overlay_path)
		return base_data

	var merged := base_data.duplicate(true)
	for key in overrides.keys():
		merged[key] = overrides[key]
	return merged
