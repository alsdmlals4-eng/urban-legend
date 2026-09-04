# 준비 화면에서 요원 상태를 표시하고 선택·상세 요청만 부모에 전달한다.
class_name AgentSelectionCard
extends PanelContainer

signal selection_requested(agent_id: String)
signal detail_requested(agent_id: String)
signal protagonist_requested(agent_id: String)

const ABILITY_KEYS := ["suppression", "analysis", "protection", "treatment", "rapport"]

@onready var _selection_button: Button = %SelectionButton
@onready var _role_button: Button = %RoleButton
@onready var _name_label: Label = %NameLabel
@onready var _hp_bar: ProgressBar = %HpBar
@onready var _hp_value: Label = %HpValue
@onready var _mental_bar: ProgressBar = %MentalBar
@onready var _mental_value: Label = %MentalValue
@onready var _ability_row: HFlowContainer = %AbilityRow
@onready var _description_label: Label = %DescriptionLabel
@onready var _detail_button: Button = %DetailButton

var _agent_id := ""


func _ready() -> void:
	_selection_button.pressed.connect(_on_selection_pressed)
	_role_button.pressed.connect(func() -> void: protagonist_requested.emit(_agent_id))
	_detail_button.pressed.connect(_on_detail_pressed)


func configure(agent: Dictionary, view_state: Dictionary) -> bool:
	var next_agent_id := String(agent.get("id", "")).strip_edges()
	if next_agent_id.is_empty():
		return false

	_agent_id = next_agent_id
	var selected := bool(view_state.get("selected", false))
	var is_protagonist := bool(view_state.get("protagonist", false))
	theme_type_variation = &"AgentCardSelected" if selected else &"AgentCard"
	_selection_button.text = ("주인공 해제" if is_protagonist else "서포트 해제") if selected else ("서포트 선택" if bool(view_state.get("has_protagonist", false)) else "주인공 선택")
	_selection_button.disabled = bool(view_state.get("selection_disabled", false))
	_role_button.visible = selected and not is_protagonist
	_role_button.disabled = not selected
	_name_label.text = "%s%s [%s] · %s / %s" % [
		String(agent.get("name", "")),
		" · 주인공" if is_protagonist else (" · 서포트" if selected else ""),
		String(agent.get("temperament_label", "")),
		String(agent.get("class", "")),
		String(agent.get("role", ""))
	]

	var current_hp := int(view_state.get("current_hp", 0))
	var max_hp := int(view_state.get("max_hp", 0))
	_hp_bar.max_value = max(1, max_hp)
	_hp_bar.value = clampi(current_hp, 0, max_hp)
	_hp_value.text = "%d/%d" % [current_hp, max_hp]

	var current_mental := int(view_state.get("current_mental", 0))
	var max_mental := int(view_state.get("max_mental", 0))
	_mental_bar.max_value = max(1, max_mental)
	_mental_bar.value = clampi(current_mental, 0, max_mental)
	_mental_value.text = "%d/%d" % [current_mental, max_mental]

	_clear_children(_ability_row)
	var abilities: Dictionary = view_state.get("abilities", {})
	var ability_labels: Dictionary = view_state.get("ability_labels", {})
	for key in ABILITY_KEYS:
		var ability_label := Label.new()
		ability_label.text = "%s %d" % [String(ability_labels.get(key, key)), int(abilities.get(key, 0))]
		ability_label.add_theme_font_size_override("font_size", 12)
		_ability_row.add_child(ability_label)

	_description_label.text = String(agent.get("description", ""))
	return true


func _on_selection_pressed() -> void:
	selection_requested.emit(_agent_id)


func _on_detail_pressed() -> void:
	detail_requested.emit(_agent_id)


func _clear_children(parent: Node) -> void:
	for child in parent.get_children():
		child.queue_free()
