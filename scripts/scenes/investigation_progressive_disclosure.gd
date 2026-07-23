# 조사 화면에서 현재 관측·선택을 우선하고 매뉴얼·과거 기록을 보조 패널로 분리한다.
extends "res://scripts/scenes/investigation_scene.gd"


func _build_ui() -> void:
	super._build_ui()
	_configure_investigation_hierarchy()


func _configure_investigation_hierarchy() -> void:
	if not _is_afterlife_layout:
		return
	_manual_panel.visible = false
	_manual_toggle_button.visible = true
	_manual_toggle_button.text = "괴이 매뉴얼 열기"
	_manual_toggle_button.tooltip_text = "현재 관측을 유지한 채 확보한 규칙 기록을 확인합니다."
	if not _manual_toggle_button.pressed.is_connected(_toggle_manual_panel):
		_manual_toggle_button.pressed.connect(_toggle_manual_panel)
	_record_button.text = "현장 기록 열기"
	if not _record_button.pressed.is_connected(_on_record_visibility_changed):
		_record_button.pressed.connect(_on_record_visibility_changed)


func _toggle_manual_panel() -> void:
	var next_visible := not _manual_panel.visible
	if next_visible and _record_drawer.visible:
		_record_drawer.visible = false
		_record_button.text = "현장 기록 열기"
	_manual_panel.visible = next_visible
	_manual_visible_by_user = next_visible
	_manual_toggle_button.text = "괴이 매뉴얼 닫기" if next_visible else "괴이 매뉴얼 열기"
	if next_visible:
		_refresh_manual_drawer(false)


func _on_record_visibility_changed() -> void:
	if _record_drawer.visible and _manual_panel.visible:
		_manual_panel.visible = false
		_manual_visible_by_user = false
		_manual_toggle_button.text = "괴이 매뉴얼 열기"
	_record_button.text = "현장 기록 닫기" if _record_drawer.visible else "현장 기록 열기"
