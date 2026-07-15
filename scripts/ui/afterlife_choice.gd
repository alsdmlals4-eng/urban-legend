# 저승역 추리 후보를 한 줄로 표시하고 선택 ID만 전달한다.
class_name AfterlifeChoice
extends PanelContainer

signal choice_requested(choice_id: String)

var _choice_id := ""


func configure(id: String, ordinal: int, title: String, enabled: bool, danger: bool, elimination_reason: String) -> void:
	_choice_id = id
	%Ordinal.text = "%02d" % ordinal
	%Title.text = title
	%Danger.visible = danger and enabled
	%EliminationReasonLabel.visible = not elimination_reason.is_empty()
	%EliminationReasonLabel.text = elimination_reason
	%ActionButton.disabled = not enabled
	%ActionButton.text = "선택" if enabled else "제외"
	modulate = Color.WHITE if enabled else Color(0.62, 0.58, 0.58, 0.78)
	theme_type_variation = &"AfterlifeRisk" if danger and enabled else &"AfterlifePanel"


func _ready() -> void:
	%ActionButton.pressed.connect(func() -> void: choice_requested.emit(_choice_id))
