# 조사 씬의 단서 선택과 결과 표시를 관리한다.
extends Control

const INVESTIGATION_POINTS: Array[Dictionary] = [
	{
		"label": "피해자의 휴대폰",
		"clue_id": "clue_last_message",
		"hint": "피해자가 보낸 마지막 문자는 도착지가 아니라 시간을 가리킵니다."
	},
	{
		"label": "검은 승차권 조각",
		"clue_id": "clue_black_ticket",
		"hint": "개찰구 주변의 검은 종이 조각은 괴이의 핵과 이어져 있습니다."
	},
	{
		"label": "플랫폼 스피커",
		"clue_id": "clue_repeating_announcement",
		"hint": "안내방송의 잡음 사이에 피해자의 이름이 섞여 있습니다."
	},
	{
		"label": "꺼진 종착지 표지판",
		"clue_id": "clue_missing_terminal_sign",
		"hint": "전광판이 꺼지기 직전 지도에 없는 종착지가 비칩니다."
	},
	{
		"label": "역무원실 근무 기록",
		"clue_id": "clue_staff_room_log",
		"hint": "막차 이후에도 누군가 근무한 흔적이 반복해서 남아 있습니다."
	}
]

var _result_label: Label
var _hint_label: Label
var _progress_label: Label
var _progress_bar: ProgressBar
var _resolution_label: Label
var _clue_list: VBoxContainer


func _ready() -> void:
	if GameState.get_current_episode().is_empty():
		GameState.load_episode()

	_build_ui()
	_refresh_case_status()


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

	var scene_scroll := ScrollContainer.new()
	scene_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scene_panel.add_child(scene_scroll)

	var scene_layout := VBoxContainer.new()
	scene_layout.add_theme_constant_override("separation", 10)
	scene_layout.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scene_scroll.add_child(scene_layout)

	var location := Label.new()
	location.text = "배경 placeholder: 자정 이후의 무인 역사 / 저승역 조사"
	location.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	location.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	scene_layout.add_child(location)

	var progress_panel := PanelContainer.new()
	scene_layout.add_child(progress_panel)

	var progress_content := VBoxContainer.new()
	progress_content.add_theme_constant_override("separation", 6)
	progress_panel.add_child(progress_content)

	_progress_label = Label.new()
	_progress_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	progress_content.add_child(_progress_label)

	_progress_bar = ProgressBar.new()
	_progress_bar.min_value = 0
	_progress_bar.max_value = 100
	progress_content.add_child(_progress_bar)

	_resolution_label = Label.new()
	_resolution_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	progress_content.add_child(_resolution_label)

	var points := GridContainer.new()
	points.columns = 1
	points.add_theme_constant_override("v_separation", 8)
	scene_layout.add_child(points)

	for point in INVESTIGATION_POINTS:
		_add_investigation_point(points, point)

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
	_hint_label.text = "동료 힌트: 수상한 물건부터 천천히 확인하세요."
	_hint_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	scene_layout.add_child(_hint_label)

	var clue_list_title := Label.new()
	clue_list_title.text = "단서 목록"
	scene_layout.add_child(clue_list_title)

	_clue_list = VBoxContainer.new()
	_clue_list.add_theme_constant_override("separation", 4)
	scene_layout.add_child(_clue_list)


func _add_title(parent: Control) -> void:
	var title := Label.new()
	title.text = "조사 씬"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	parent.add_child(title)


func _add_investigation_point(parent: Control, point: Dictionary) -> void:
	var button := Button.new()
	var label := String(point.get("label", "조사 포인트"))
	var clue_id := String(point.get("clue_id", ""))
	var hint := String(point.get("hint", ""))
	button.text = label
	button.pressed.connect(func() -> void:
		_inspect_point(clue_id, hint)
	)
	parent.add_child(button)


func _inspect_point(clue_id: String, hint: String) -> void:
	var clue := _find_clue(clue_id)
	if clue.is_empty():
		_result_label.text = "조사 결과: 연결된 단서 데이터를 찾지 못했습니다. clue_id: %s" % clue_id
		return

	var was_collected: bool = bool(clue.get("collected", false))
	var collected_now: bool = GameState.collect_clue(clue_id)
	if collected_now:
		_result_label.text = "새 단서 획득: %s\n%s" % [
			clue.get("title", ""),
			clue.get("description", "")
		]
	elif was_collected:
		_result_label.text = "이미 확인한 단서입니다: %s\n%s" % [
			clue.get("title", ""),
			clue.get("description", "")
		]
	else:
		_result_label.text = "조사 결과: 단서를 획득하지 못했습니다. clue_id: %s" % clue_id

	_hint_label.text = "동료 힌트: %s" % hint
	_refresh_case_status()


func _refresh_case_status() -> void:
	var collected_count: int = GameState.get_collected_clue_count()
	var total_count: int = GameState.get_total_clue_count()
	var collection_rate: float = GameState.get_clue_collection_rate()
	_progress_label.text = "단서 수집률: %.0f%% (%d/%d)" % [collection_rate, collected_count, total_count]
	_progress_bar.value = collection_rate
	_resolution_label.text = "현재 해결 단계: %s" % GameState.get_resolution_label()
	_refresh_clue_list()


func _refresh_clue_list() -> void:
	_clear_children(_clue_list)
	for clue in GameState.get_clues():
		if typeof(clue) != TYPE_DICTIONARY:
			continue

		var label := Label.new()
		var state_text := "수집됨" if bool(clue.get("collected", false)) else "미수집"
		label.text = "%s - %s" % [state_text, clue.get("title", "")]
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		_clue_list.add_child(label)


func _find_clue(clue_id: String) -> Dictionary:
	for clue in GameState.get_clues():
		if typeof(clue) == TYPE_DICTIONARY and clue.get("id", "") == clue_id:
			return clue
	return {}


func _clear_children(parent: Node) -> void:
	if parent == null:
		return

	for child in parent.get_children():
		child.queue_free()


func _add_navigation(parent: Control) -> void:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 6)
	parent.add_child(row)
	_add_scene_button(row, "메뉴", "res://scenes/main_menu.tscn")
	_add_scene_button(row, "데이터", "res://scenes/case_data_scene.tscn")
	_add_scene_button(row, "대화", "res://scenes/dialogue_scene.tscn")
	_add_scene_button(row, "전투", "res://scenes/battle_scene.tscn")


func _add_scene_button(parent: Control, label: String, scene_path: String) -> void:
	var button := Button.new()
	button.text = label
	button.pressed.connect(func() -> void:
		get_tree().change_scene_to_file(scene_path)
	)
	parent.add_child(button)
