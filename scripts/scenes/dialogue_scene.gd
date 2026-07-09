# 대화 씬의 대사 진행과 선택지 테스트를 관리한다.
extends Control

const LINES: Array[Dictionary] = [
	{"name": "연하린", "text": "이 역은 지도에도, 기록국 데이터에도 남아 있지 않아요."},
	{"name": "신입 요원", "text": "그럼 지금 우리가 보고 있는 전광판은 뭘 기준으로 움직이는 거죠?"},
	{"name": "연하린", "text": "괴담은 믿는 사람의 기억을 노선처럼 씁니다. 선택해야 해요."}
]

var _line_index := 0
var _name_label: Label
var _dialogue_label: Label
var _choice_box: VBoxContainer


func _ready() -> void:
	_build_ui()
	_show_line()


func _build_ui() -> void:
	var background := ColorRect.new()
	background.color = Color(0.055, 0.055, 0.075, 1.0)
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 20)
	margin.add_theme_constant_override("margin_top", 20)
	margin.add_theme_constant_override("margin_right", 20)
	margin.add_theme_constant_override("margin_bottom", 20)
	add_child(margin)

	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation", 10)
	margin.add_child(root)

	_add_navigation(root)

	var title := Label.new()
	title.text = "대화 씬"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	root.add_child(title)

	var stage := PanelContainer.new()
	stage.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_child(stage)

	var stage_layout := VBoxContainer.new()
	stage_layout.add_theme_constant_override("separation", 10)
	stage.add_child(stage_layout)

	var bg_label := Label.new()
	bg_label.text = "배경 placeholder: 사라진 승강장"
	bg_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	stage_layout.add_child(bg_label)

	var standing := PanelContainer.new()
	standing.size_flags_vertical = Control.SIZE_EXPAND_FILL
	stage_layout.add_child(standing)

	var standing_label := Label.new()
	standing_label.text = "캐릭터 스탠딩 placeholder: 연하린"
	standing_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	standing_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	standing.add_child(standing_label)

	_name_label = Label.new()
	_name_label.text = "이름"
	stage_layout.add_child(_name_label)

	_dialogue_label = Label.new()
	_dialogue_label.text = "대사"
	_dialogue_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	stage_layout.add_child(_dialogue_label)

	var next_button := Button.new()
	next_button.text = "다음 대사"
	next_button.pressed.connect(_advance_line)
	stage_layout.add_child(next_button)

	_choice_box = VBoxContainer.new()
	_choice_box.visible = false
	_choice_box.add_theme_constant_override("separation", 6)
	stage_layout.add_child(_choice_box)


func _show_line() -> void:
	var line := LINES[_line_index]
	_name_label.text = line.get("name", "")
	_dialogue_label.text = line.get("text", "")
	_choice_box.visible = false


func _advance_line() -> void:
	if _line_index < LINES.size() - 1:
		_line_index += 1
		_show_line()
	else:
		_show_choices()


func _show_choices() -> void:
	_choice_box.visible = true
	for child in _choice_box.get_children():
		child.queue_free()
	_add_choice("전광판을 촬영한다", "선택 결과: 진실도 단서가 추가됩니다.")
	_add_choice("역무원실로 향한다", "선택 결과: 2차 분기 테스트가 열립니다.")


func _add_choice(label: String, result: String) -> void:
	var button := Button.new()
	button.text = label
	button.pressed.connect(func() -> void:
		_name_label.text = "선택"
		_dialogue_label.text = result
		_choice_box.visible = false
	)
	_choice_box.add_child(button)


func _add_navigation(parent: Control) -> void:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 6)
	parent.add_child(row)
	_add_scene_button(row, "메뉴", "res://scenes/main_menu.tscn")
	_add_scene_button(row, "조사", "res://scenes/investigation_scene.tscn")
	_add_scene_button(row, "전투", "res://scenes/battle_scene.tscn")
	_add_scene_button(row, "미니게임", "res://scenes/minigame_scene.tscn")


func _add_scene_button(parent: Control, label: String, scene_path: String) -> void:
	var button := Button.new()
	button.text = label
	button.pressed.connect(func() -> void:
		get_tree().change_scene_to_file(scene_path)
	)
	parent.add_child(button)

