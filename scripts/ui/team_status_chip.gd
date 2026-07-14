# 현장에 투입된 요원의 핵심 상태를 작게 표시한다.
class_name TeamStatusChip
extends PanelContainer

@onready var _portrait: TextureRect = %Portrait
@onready var _name_label: Label = %NameLabel
@onready var _status_label: Label = %StatusLabel
@onready var _representative_badge: Label = %RepresentativeBadge


func configure(agent: Dictionary, view_state: Dictionary) -> bool:
	var agent_id := String(agent.get("id", "")).strip_edges()
	if agent_id.is_empty():
		return false
	_name_label.text = String(agent.get("name", agent_id))
	_status_label.text = "체력 %d/%d · 정신 %d/%d%s" % [
		int(view_state.get("hp", 0)), int(view_state.get("max_hp", 0)),
		int(view_state.get("mental", 0)), int(view_state.get("max_mental", 0)),
		"" if bool(view_state.get("active", true)) else " · 행동 불가"
	]
	_representative_badge.visible = bool(view_state.get("representative", false))
	var texture: Texture2D = view_state.get("texture")
	_portrait.texture = texture
	_portrait.visible = texture != null
	modulate = Color.WHITE if bool(view_state.get("active", true)) else Color(0.55, 0.58, 0.62, 0.8)
	return true
