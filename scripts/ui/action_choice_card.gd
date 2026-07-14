# 조사와 회수 화면의 행동을 표시하고 선택 요청만 부모에 전달한다.
class_name ActionChoiceCard
extends PanelContainer

signal action_requested(action_id: String)

@onready var _action_button: Button = %ActionButton
@onready var _description_label: Label = %DescriptionLabel
@onready var _meta_label: Label = %MetaLabel

var _action_id := ""


func _ready() -> void:
	_action_button.pressed.connect(_on_action_pressed)


func configure(data: Dictionary) -> bool:
	var next_id := String(data.get("id", "")).strip_edges()
	if next_id.is_empty():
		return false
	_action_id = next_id
	theme_type_variation = &"ActionCardCritical" if bool(data.get("critical", false)) else &"ActionCard"
	_action_button.text = String(data.get("title", "행동 선택"))
	_action_button.disabled = not bool(data.get("enabled", true))
	_description_label.text = String(data.get("description", ""))
	_description_label.visible = not _description_label.text.is_empty()
	_meta_label.text = String(data.get("meta", ""))
	_meta_label.visible = not _meta_label.text.is_empty()
	return true


func _on_action_pressed() -> void:
	action_requested.emit(_action_id)
