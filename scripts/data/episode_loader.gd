# 에피소드 JSON 파일을 읽어 사건 데이터 Dictionary로 변환한다.
class_name EpisodeLoader
extends RefCounted


## Loads one episode JSON file and returns an empty Dictionary when loading fails.
func load_episode(file_path: String) -> Dictionary:
	if not FileAccess.file_exists(file_path):
		push_error("Episode file not found: %s" % file_path)
		return {}

	var file := FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		push_error("Episode file cannot be opened: %s" % file_path)
		return {}

	var parsed_data: Variant = JSON.parse_string(file.get_as_text())
	if typeof(parsed_data) != TYPE_DICTIONARY:
		push_error("Episode JSON root must be a Dictionary: %s" % file_path)
		return {}

	return parsed_data
