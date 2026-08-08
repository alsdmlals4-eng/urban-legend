extends SceneTree

const AnomalyManualDrawerScript = preload("res://scripts/ui/anomaly_manual_drawer.gd")

var _failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var host := Control.new()
	root.add_child(host)
	var button := Button.new()
	host.add_child(button)
	var prior_action := Button.new()
	host.add_child(prior_action)
	var drawer: AnomalyManualDrawer = AnomalyManualDrawerScript.new()
	host.add_child(drawer)
	drawer.set_sections([{"title": "확보 단서", "text": "안전 노선 검증 기록"}])
	drawer.bind_toggle_button(button)
	await process_frame
	_expect(not drawer.visible, "manual drawer should start closed")
	_expect(button.text == "괴이 매뉴얼", "manual button should use the shared label")
	drawer.mark_new_entries()
	_expect("새 기록" in button.text, "new detail should mark the button without opening the drawer")
	prior_action.grab_focus()
	await process_frame
	drawer.open_drawer()
	await process_frame
	_expect(drawer.visible, "manual drawer should open programmatically")
	drawer.close_drawer()
	await process_frame
	_expect(root.gui_get_focus_owner() == prior_action, "manual drawer should restore the previous meaningful focus")
	button.emit_signal("pressed")
	_expect(drawer.visible, "manual button should open the drawer")
	_expect(button.text == "괴이 매뉴얼 닫기", "opened drawer should offer close state")
	button.emit_signal("pressed")
	_expect(not drawer.visible, "manual button should close the drawer")
	_expect(root.gui_get_focus_owner() == button, "manual toggle should remain the fallback focus target")
	_finish()


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("ANOMALY MANUAL DRAWER: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
