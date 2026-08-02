class_name ValidationTestSupport
extends RefCounted


static func read_bytes(path: String) -> PackedByteArray:
	return FileAccess.get_file_as_bytes(path) if FileAccess.file_exists(path) else PackedByteArray()


static func read_json(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {}
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	file.close()
	return (parsed as Dictionary).duplicate(true) if typeof(parsed) == TYPE_DICTIONARY else {}


static func write_text(path: String, text: String) -> Error:
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		return FileAccess.get_open_error()
	file.store_string(text)
	file.flush()
	file.close()
	return OK


static func remove_path(path: String) -> void:
	if not path.is_empty() and FileAccess.file_exists(path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(path))


static func remove_repository_paths(paths: Dictionary) -> void:
	for key in ["primary", "backup", "temp"]:
		remove_path(String(paths.get(key, "")))


static func semantic_equal(left: Variant, right: Variant) -> bool:
	var left_type := typeof(left)
	var right_type := typeof(right)
	if left_type in [TYPE_INT, TYPE_FLOAT] and right_type in [TYPE_INT, TYPE_FLOAT]:
		return is_equal_approx(float(left), float(right))
	if left_type == TYPE_DICTIONARY and right_type == TYPE_DICTIONARY:
		var left_dict := left as Dictionary
		var right_dict := right as Dictionary
		if left_dict.size() != right_dict.size():
			return false
		for key in left_dict.keys():
			if not right_dict.has(key) or not semantic_equal(left_dict[key], right_dict[key]):
				return false
		return true
	if left_type == TYPE_ARRAY and right_type == TYPE_ARRAY:
		var left_array := left as Array
		var right_array := right as Array
		if left_array.size() != right_array.size():
			return false
		for index in range(left_array.size()):
			if not semantic_equal(left_array[index], right_array[index]):
				return false
		return true
	return left == right
