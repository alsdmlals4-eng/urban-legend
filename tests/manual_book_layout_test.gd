extends SceneTree

const AnomalyManualDrawerScript = preload("res://scripts/ui/anomaly_manual_drawer.gd")

var _failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var host := Control.new()
	host.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.add_child(host)
	var manual: AnomalyManualDrawer = AnomalyManualDrawerScript.new()
	manual.set_persistent_book(true)
	manual.set_sections([
		{"title": "관찰 기록", "text": "현재 현장과 기록을 대조합니다."}
	])
	host.add_child(manual)
	await process_frame
	_expect(manual.visible, "persistent manual should stay visible")
	_expect(manual.find_child("BookFrame", true, false) is TextureRect, "persistent manual should render the book frame")
	_expect(manual.find_child("BookScroll", true, false) is ScrollContainer, "persistent manual should scroll its page content")
	_finish()


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("MANUAL BOOK LAYOUT: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
