# 조사 씬의 단서 선택과 결과 표시를 관리한다.
extends Control

var _result_label: Label
var _hint_label: Label


func _ready() -> void:
	_build_ui()


func _build_ui() -> void:
	var background := ColorRect.new()
	background.color = Color(0.07, 0.08, 0.1, 1.0)
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
	_add_title(root)

	var scene_panel := PanelContainer.new()
	scene_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_child(scene_panel)

	var scene_layout := VBoxContainer.new()
	scene_layout.add_theme_constant_override("separation", 10)
	scene_panel.add_child(scene_layout)

	var location := Label.new()
	location.text = "배경 placeholder: 자정 이후의 무인 역사"
	location.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	location.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	scene_layout.add_child(location)

	var points := GridContainer.new()
	points.columns = 1
	points.add_theme_constant_override("v_separation", 8)
	scene_layout.add_child(points)

	_add_investigation_point(points, "낡은 승차권", "승차권 뒤에 없는 역명이 적혀 있다.", "단말기: 역명은 지도 데이터에 존재하지 않습니다.")
	_add_investigation_point(points, "꺼진 전광판", "전광판이 잠깐 켜지며 플레이어 이름을 표시한다.", "힌트: 전광판을 촬영하면 진실도 단서가 추가됩니다.")
	_add_investigation_point(points, "검은 우산", "젖지 않은 우산 아래에서 오래된 물비린내가 난다.", "동행 요원: 손잡이 안쪽의 문양을 확인해보세요.")

	var portrait := PanelContainer.new()
	scene_layout.add_child(portrait)

	var portrait_label := Label.new()
	portrait_label.text = "작은 초상화 영역: 기록국 단말기 / 동행 요원 통신"
	portrait_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	portrait_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	portrait.add_child(portrait_label)

	_result_label = Label.new()
	_result_label.text = "조사 포인트를 선택하면 결과가 표시됩니다."
	_result_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	scene_layout.add_child(_result_label)

	_hint_label = Label.new()
	_hint_label.text = "힌트 대사: 수상한 물건부터 천천히 확인하세요."
	_hint_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	scene_layout.add_child(_hint_label)


func _add_title(parent: Control) -> void:
	var title := Label.new()
	title.text = "조사 씬"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	parent.add_child(title)


func _add_investigation_point(parent: Control, title: String, result: String, hint: String) -> void:
	var button := Button.new()
	button.text = title
	button.pressed.connect(func() -> void:
		_result_label.text = "조사 결과: %s" % result
		_hint_label.text = "힌트 대사: %s" % hint
	)
	parent.add_child(button)


func _add_navigation(parent: Control) -> void:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 6)
	parent.add_child(row)
	_add_scene_button(row, "메뉴", "res://scenes/main_menu.tscn")
	_add_scene_button(row, "대화", "res://scenes/dialogue_scene.tscn")
	_add_scene_button(row, "전투", "res://scenes/battle_scene.tscn")
	_add_scene_button(row, "미니게임", "res://scenes/minigame_scene.tscn")


func _add_scene_button(parent: Control, label: String, scene_path: String) -> void:
	var button := Button.new()
	button.text = label
	button.pressed.connect(func() -> void:
		get_tree().change_scene_to_file(scene_path)
	)
	parent.add_child(button)

