extends SceneTree

const ASSET_PATH := "res://assets/ui/guides/lume_afterlife_station.png"
const SOURCE_PATH := "res://docs/visual/blueprint-reference-pack/2026-08-30/09-lume-afterlife-station-guide-candidate.png"
const MANIFEST_PATH := "res://ASSET_MANIFEST.yml"
const EXPECTED_SHA256 := "4d22f0eaeff23c9ecdcbc5bc40678fab4b7185a01c2572b650ab6e68771bccf4"

var _failures: Array[String] = []


func _init() -> void:
	_expect(FileAccess.file_exists(ASSET_PATH), "approved CASE-01 Lume runtime asset missing")
	_expect(FileAccess.file_exists(SOURCE_PATH), "approved Lume source reference missing")
	_expect(FileAccess.file_exists(MANIFEST_PATH), "root asset manifest missing")
	if FileAccess.file_exists(ASSET_PATH):
		var runtime_image := Image.load_from_file(ASSET_PATH)
		_expect(runtime_image != null, "Lume runtime image failed to load")
		if runtime_image != null:
			_expect(runtime_image.get_width() == 1024 and runtime_image.get_height() == 1536, "Lume runtime image dimensions changed")
			_expect(runtime_image.detect_alpha() == Image.ALPHA_NONE, "Lume runtime image must retain the approved opaque background")
		_expect(_sha256_file(ASSET_PATH) == EXPECTED_SHA256, "Lume runtime image does not match approved bytes")
	if FileAccess.file_exists(SOURCE_PATH):
		_expect(_sha256_file(SOURCE_PATH) == EXPECTED_SHA256, "Lume source reference hash changed")
	if FileAccess.file_exists(MANIFEST_PATH):
		var receipt := _asset_entry(FileAccess.get_file_as_string(MANIFEST_PATH), "M01-LUME-GUIDE-001")
		_expect(not receipt.is_empty(), "Lume asset receipt id missing")
		_expect(receipt.get("canonical_path", "") == "assets/ui/guides/lume_afterlife_station.png", "Lume runtime path missing from receipt")
		_expect(receipt.get("source_path", "") == "docs/visual/blueprint-reference-pack/2026-08-30/09-lume-afterlife-station-guide-candidate.png", "Lume source path missing from receipt")
		_expect(receipt.get("sha256", "") == EXPECTED_SHA256, "Lume source hash missing from receipt")
		_expect(receipt.get("runtime_path", "") == "scenes/ui/manual_deduction_workbench.tscn -> LumeGuidePanel/LumePortrait", "Lume workbench consumer missing from receipt")
		_expect(receipt.get("approval_scope", "").contains("CASE-01"), "Lume receipt is not CASE-01 scoped")
	_finish()


func _asset_entry(manifest: String, target_asset_id: String) -> Dictionary:
	var entry_started := false
	var entry: Dictionary = {}
	for raw_line in manifest.split("\n"):
		var line := raw_line.rstrip("\r")
		if line.begins_with("  - asset_id:"):
			if entry_started:
				break
			entry_started = line.contains('"%s"' % target_asset_id)
			continue
		if not entry_started or not line.begins_with("    "):
			continue
		var separator := line.find(":")
		if separator <= 0:
			continue
		var key := line.left(separator).strip_edges()
		var value := line.substr(separator + 1).strip_edges()
		if value.begins_with('"') and value.ends_with('"') and value.length() >= 2:
			value = value.substr(1, value.length() - 2)
		entry[key] = value
	return entry


func _sha256_file(path: String) -> String:
	var context := HashingContext.new()
	if context.start(HashingContext.HASH_SHA256) != OK:
		return ""
	if context.update(FileAccess.get_file_as_bytes(path)) != OK:
		return ""
	return context.finish().hex_encode()


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("LUME GUIDE ASSET RECEIPT: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
