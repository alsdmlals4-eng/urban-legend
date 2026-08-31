extends SceneTree

## Guards the approved M04 costume from falling back to the CASE-01 station
## outfit or an untracked image. A wrong path, missing source, or changed bytes
## is a player-visible scenario-continuity regression.

const ASSET_PATH := "res://assets/ui/guides/lume_red_umbrella_alley.png"
const SOURCE_PATH := "res://docs/visual/blueprint-reference-pack/2026-08-31/10-lume-red-umbrella-alley-guide.png"
const MANIFEST_PATH := "res://ASSET_MANIFEST.yml"
const EXPECTED_SHA256 := "22f39deaf1a0a538159b465b21f43e8e48f0727e2a25b6eaf04658055158b050"

var _failures: Array[String] = []


func _init() -> void:
	_expect(FileAccess.file_exists(ASSET_PATH), "approved CASE-04 Lume runtime asset missing")
	_expect(FileAccess.file_exists(SOURCE_PATH), "approved CASE-04 Lume source reference missing")
	_expect(FileAccess.file_exists(MANIFEST_PATH), "root asset manifest missing")
	if FileAccess.file_exists(ASSET_PATH):
		var runtime_image := Image.load_from_file(ASSET_PATH)
		_expect(runtime_image != null, "CASE-04 Lume runtime image failed to load")
		if runtime_image != null:
			_expect(runtime_image.get_width() == 1024 and runtime_image.get_height() == 1536, "CASE-04 Lume runtime image dimensions changed")
			_expect(runtime_image.detect_alpha() == Image.ALPHA_NONE, "CASE-04 Lume runtime image must retain its opaque dossier background")
		_expect(_sha256_file(ASSET_PATH) == EXPECTED_SHA256, "CASE-04 Lume runtime image does not match approved bytes")
	if FileAccess.file_exists(SOURCE_PATH):
		_expect(_sha256_file(SOURCE_PATH) == EXPECTED_SHA256, "CASE-04 Lume source reference hash changed")
	if FileAccess.file_exists(MANIFEST_PATH):
		var receipt := _asset_entry(FileAccess.get_file_as_string(MANIFEST_PATH), "M04-LUME-GUIDE-001")
		_expect(not receipt.is_empty(), "CASE-04 Lume asset receipt id missing")
		_expect(receipt.get("canonical_path", "") == "assets/ui/guides/lume_red_umbrella_alley.png", "CASE-04 Lume runtime path missing from receipt")
		_expect(receipt.get("source_path", "") == "docs/visual/blueprint-reference-pack/2026-08-31/10-lume-red-umbrella-alley-guide.png", "CASE-04 Lume source path missing from receipt")
		_expect(receipt.get("sha256", "") == EXPECTED_SHA256, "CASE-04 Lume source hash missing from receipt")
		_expect(receipt.get("runtime_path", "") == "scenes/ui/manual_deduction_workbench.tscn -> LumeGuidePanel/LumePortrait (CASE-04 view model)", "CASE-04 Lume workbench consumer missing from receipt")
		_expect(receipt.get("approval_scope", "").contains("CASE-04"), "CASE-04 Lume receipt is not scenario scoped")
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
		print("M04 LUME GUIDE ASSET RECEIPT: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
