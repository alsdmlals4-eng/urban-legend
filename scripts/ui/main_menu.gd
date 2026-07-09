# 시작 화면에서 프로젝트 소개와 데이터베이스 진입을 관리한다.
extends Control


func _ready() -> void:
	_build_ui()


func _build_ui() -> void:
	var background := ColorRect.new()
	background.color = Color(0.055, 0.06, 0.075, 1.0)
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 28)
	margin.add_theme_constant_override("margin_top", 72)
	margin.add_theme_constant_override("margin_right", 28)
	margin.add_theme_constant_override("margin_bottom", 72)
	add_child(margin)

	var panel := PanelContainer.new()
	margin.add_child(panel)

	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 14)
	panel.add_child(content)

	var title := Label.new()
	title.text = "도시괴담 기록국"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	content.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "비주얼노벨 / 호러 미스터리 Godot 이관 프로젝트"
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(subtitle)

	var body := Label.new()
	body.text = "HTML 데이터베이스의 세력, 요원, 장비, 기술, 에피소드, 분기, 대화문, 제작 점검 구조를 Godot에서 재현합니다."
	body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(body)

	var open_button := Button.new()
	open_button.text = "기록국 데이터베이스 열기"
	open_button.pressed.connect(_open_database)
	content.add_child(open_button)


func _open_database() -> void:
	get_tree().change_scene_to_file("res://scenes/database_view.tscn")

