# 사건 준비 화면의 보조 시스템 노출 순서만 조정한다.
extends "res://scripts/scenes/preparation_scene.gd"

const SECONDARY_TOOLS_HINT_ID := "preparation_secondary_tools_opened"
const SECONDARY_TAB_TITLES := ["장비", "외부 접점", "기록"]

var _secondary_tools_button: Button


func _build_ui() -> void:
	super._build_ui()
	_secondary_tools_button = _find_dashboard_action("외부 의뢰")
	if _secondary_tools_button != null:
		_secondary_tools_button.name = "SecondaryToolsButton"
		_secondary_tools_button.text = "보조 준비 도구"
		_secondary_tools_button.tooltip_text = "장비·외부 접점·기록을 펼칩니다."
		for connection in _secondary_tools_button.pressed.get_connections():
			_secondary_tools_button.pressed.disconnect(connection.callable)
		_secondary_tools_button.pressed.connect(_reveal_secondary_tools)
	_apply_progressive_disclosure()


func _refresh() -> void:
	super._refresh()
	_apply_progressive_disclosure()


func _apply_progressive_disclosure() -> void:
	if _dashboard_tabs == null:
		return
	var revealed := _should_show_secondary_tools()
	for index in range(_dashboard_tabs.get_tab_count()):
		var title := _dashboard_tabs.get_tab_title(index)
		if title in SECONDARY_TAB_TITLES:
			_dashboard_tabs.set_tab_hidden(index, not revealed)
	if _secondary_tools_button != null:
		_secondary_tools_button.visible = not revealed
	if not revealed and _dashboard_tabs.current_tab >= 2:
		_dashboard_tabs.current_tab = 0


func _reveal_secondary_tools() -> void:
	_game_state().mark_hint_seen(SECONDARY_TOOLS_HINT_ID)
	_game_state().save_game()
	_apply_progressive_disclosure()
	if _status_label != null:
		_status_label.text = "보조 준비 도구를 펼쳤습니다."


func _should_show_secondary_tools() -> bool:
	if _game_state().has_seen_hint(SECONDARY_TOOLS_HINT_ID):
		return true
	var campaign: Dictionary = _game_state().get_campaign_snapshot()
	if not Array(campaign.get("completed_episode_ids", [])).is_empty():
		return true
	if not Array(campaign.get("unlocked_equipment_ids", [])).is_empty():
		return true
	if not Array(campaign.get("unlocked_record_ids", [])).is_empty():
		return true
	if not Dictionary(campaign.get("equipped_equipment_by_agent", {})).is_empty():
		return true
	if not Dictionary(campaign.get("consumable_inventory", {})).is_empty():
		return true
	for request in Array(campaign.get("faction_requests", [])):
		if request is Dictionary and String(request.get("status", "")) == "accepted":
			return true
	return false


func _find_dashboard_action(label_text: String) -> Button:
	var grid := find_child("DashboardActionGrid", true, false)
	if grid == null:
		return null
	for child in grid.get_children():
		if child is Button and child.text == label_text:
			return child as Button
	return null


func _game_state() -> Node:
	return get_node("/root/GameState")
