# 현재 투입 팀의 상태를 표시하는 읽기 전용 팝오버다.
class_name TeamStatusPopover
extends PanelContainer

signal closed

@onready var _title: Label = %Title
@onready var _member_list: VBoxContainer = %MemberList
@onready var _close_button: Button = %CloseButton


func _ready() -> void:
	_close_button.pressed.connect(close)
	visibility_changed.connect(func() -> void:
		if visible:
			_close_button.grab_focus()
	)
	if has_meta("pending_entries"):
		_render(get_meta("pending_entries"))
		remove_meta("pending_entries")


func configure(entries: Array) -> void:
	if not is_node_ready():
		set_meta("pending_entries", entries.duplicate(true))
		return
	_render(entries)


func open(entries: Array) -> void:
	show()
	configure(entries)


func close() -> void:
	hide()
	closed.emit()


func _unhandled_input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("ui_cancel"):
		close()
		get_viewport().set_input_as_handled()


func _render(entries: Array) -> void:
	for child in _member_list.get_children():
		child.queue_free()
	_title.text = "현장 투입 팀"
	if entries.is_empty():
		var empty := Label.new()
		empty.text = "현재 투입된 요원이 없습니다."
		_member_list.add_child(empty)
		return
	for index in entries.size():
		var entry: Dictionary = entries[index]
		var row := VBoxContainer.new()
		row.add_theme_constant_override("separation", 2)
		var name_label := Label.new()
		name_label.text = "%s · %s" % ["주인공" if index == 0 else "서포트", String(entry.get("name", "요원"))]
		name_label.theme_type_variation = &"AfterlifeSection"
		row.add_child(name_label)
		var status_label := Label.new()
		status_label.text = "체력 %d/%d  ·  정신력 %d/%d  ·  %s" % [
			int(entry.get("hp", 0)), int(entry.get("max_hp", 0)),
			int(entry.get("mental", 0)), int(entry.get("max_mental", 0)),
			"행동 가능" if bool(entry.get("active", false)) else "행동 불가"
		]
		status_label.theme_type_variation = &"AfterlifeMeta"
		row.add_child(status_label)
		_member_list.add_child(row)
