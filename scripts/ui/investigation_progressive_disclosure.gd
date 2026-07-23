class_name InvestigationProgressiveDisclosure
extends Node

var _scene: Control
var _manual_panel: Control
var _manual_button: Button
var _record_drawer: Control
var _record_button: Button


func bind(scene: Control) -> void:
	_scene = scene
	call_deferred("_configure")


func _configure() -> void:
	if _scene == null or not is_instance_valid(_scene):
		return
	_manual_panel = _scene.find_child("ManualPanel", true, false) as Control
	_manual_button = _scene.find_child("ManualToggleButton", true, false) as Button
	_record_drawer = _scene.find_child("RecordDrawer", true, false) as Control
	_record_button = _scene.find_child("RecordButton", true, false) as Button
	if _manual_panel == null or _manual_button == null or _record_drawer == null or _record_button == null:
		return
	# 비저승역 사건은 기존 직접 대응 레이아웃을 보존한다.
	if not _manual_panel.visible:
		return
	_manual_panel.visible = false
	_manual_button.visible = true
	_manual_button.text = "괴이 매뉴얼 열기"
	_manual_button.tooltip_text = "현재 관측을 유지한 채 확보한 규칙 기록을 확인합니다."
	if not _manual_button.pressed.is_connected(_toggle_manual):
		_manual_button.pressed.connect(_toggle_manual)
	_record_button.text = "현장 기록 열기"
	if not _record_button.pressed.is_connected(_sync_record_visibility):
		_record_button.pressed.connect(_sync_record_visibility)


func _toggle_manual() -> void:
	var next_visible := not _manual_panel.visible
	if next_visible and _record_drawer.visible:
		_record_drawer.visible = false
		_record_button.text = "현장 기록 열기"
	_manual_panel.visible = next_visible
	_manual_button.text = "괴이 매뉴얼 닫기" if next_visible else "괴이 매뉴얼 열기"
	if next_visible and _scene.has_method("_refresh_manual_drawer"):
		_scene.call("_refresh_manual_drawer", false)


func _sync_record_visibility() -> void:
	if _record_drawer.visible and _manual_panel.visible:
		_manual_panel.visible = false
		_manual_button.text = "괴이 매뉴얼 열기"
	_record_button.text = "현장 기록 닫기" if _record_drawer.visible else "현장 기록 열기"
