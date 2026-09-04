# 저승역 전용 헤더. 화면 전환은 부모가 처리하고 이 컴포넌트는 요청만 전달한다.
class_name AfterlifeHeader
extends PanelContainer

signal record_requested
signal settings_requested
signal hq_requested
signal team_requested

@onready var case_label: Label = %CaseLabel
@onready var team_button: Button = %TeamButton
@onready var record_button: Button = %RecordButton
@onready var settings_button: Button = %SettingsButton
@onready var hq_button: Button = %HqButton


func _ready() -> void:
	team_button.pressed.connect(func() -> void: team_requested.emit())
	record_button.pressed.connect(func() -> void: record_requested.emit())
	settings_button.pressed.connect(func() -> void: settings_requested.emit())
	hq_button.pressed.connect(func() -> void: hq_requested.emit())
	if has_meta("pending_stage_text"):
		case_label.text = String(get_meta("pending_stage_text"))
		team_button.text = String(get_meta("pending_team_text"))


func configure(stage_text: String, team_text: String = "팀 상태") -> void:
	if not is_node_ready():
		set_meta("pending_stage_text", stage_text)
		set_meta("pending_team_text", team_text)
		return
	case_label.text = stage_text
	team_button.text = team_text
