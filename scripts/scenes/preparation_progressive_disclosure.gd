# 사건 준비 화면의 정보 위계만 조정하고 기존 준비 상태·경제·진행은 부모 화면에 맡긴다.
extends "res://scripts/scenes/preparation_scene.gd"

const SECONDARY_TOOLS_HINT_ID := "preparation_secondary_tools_opened"
const FIRST_SECONDARY_TAB_INDEX := 2

var _reveal_secondary_tools_button: Button
var _external_request_button: Button


func _ready() -> void:
	super._ready()
	_configure_progressive_disclosure()


func _configure_progressive_disclosure() -> void:
	var action_grid := find_child("DashboardActionGrid", true, false) as GridContainer
	if _dashboard_tabs == null or action_grid == null or action_grid.get_child_count() < 4:
		push_warning("Preparation progressive disclosure controls were not found; preserving the full preparation UI.")
		return

	_external_request_button = action_grid.get_child(3) as Button
	if _external_request_button == null:
		push_warning("External request shortcut was not a button; preserving the full preparation UI.")
		return
	_external_request_button.name = "ExternalRequestButton"

	_reveal_secondary_tools_button = Button.new()
	_reveal_secondary_tools_button.name = "RevealSecondaryToolsButton"
	_reveal_secondary_tools_button.text = "보조 준비 도구"
	_reveal_secondary_tools_button.tooltip_text = "장비·외부 접점·기록을 즉시 표시합니다. 해금 조건이나 비용은 없습니다."
	_reveal_secondary_tools_button.custom_minimum_size = _external_request_button.custom_minimum_size
	_reveal_secondary_tools_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_reveal_secondary_tools_button.pressed.connect(_on_reveal_secondary_tools_pressed)
	action_grid.add_child(_reveal_secondary_tools_button)
	action_grid.move_child(_reveal_secondary_tools_button, 3)

	_apply_secondary_tools_visibility(_should_reveal_secondary_tools_automatically())


func _should_reveal_secondary_tools_automatically() -> bool:
	if GameState.has_seen_hint(SECONDARY_TOOLS_HINT_ID):
		return true
	if not GameState.get_completed_case_reports().is_empty():
		return true
	if not GameState.get_unlocked_equipment().is_empty():
		return true
	if not GameState.get_unlocked_records().is_empty():
		return true
	if not GameState.get_equipped_items().is_empty():
		return true
	for amount in GameState.get_consumable_inventory().values():
		if int(amount) > 0:
			return true
	for request_value in GameState.get_faction_request_board():
		if request_value is Dictionary and String(request_value.get("status", "")) == "accepted":
			return true
	return false


func _on_reveal_secondary_tools_pressed() -> void:
	GameState.mark_hint_seen(SECONDARY_TOOLS_HINT_ID)
	GameState.save_game()
	_apply_secondary_tools_visibility(true)
	if _status_label != null:
		_status_label.text = "장비·외부 접점·기록을 표시했습니다."


func _apply_secondary_tools_visibility(revealed: bool) -> void:
	for tab_index in range(FIRST_SECONDARY_TAB_INDEX, _dashboard_tabs.get_tab_count()):
		_dashboard_tabs.set_tab_hidden(tab_index, not revealed)
	_external_request_button.visible = revealed
	_reveal_secondary_tools_button.visible = not revealed
	if not revealed and _dashboard_tabs.current_tab >= FIRST_SECONDARY_TAB_INDEX:
		_dashboard_tabs.current_tab = 0
