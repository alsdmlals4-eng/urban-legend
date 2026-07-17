## 모든 플레이 씬에서 쓰는 화면·연출 설정 창이다.
class_name GameSettingsDialog
extends AcceptDialog

const DisplaySettingsScript = preload("res://scripts/ui/display_settings.gd")
const AccessibilitySettingsScript = preload("res://scripts/ui/accessibility_settings.gd")

var _display_settings
var _accessibility := AccessibilitySettingsScript.new()
var _resolution_option: OptionButton
var _window_mode_option: OptionButton
var _status_label: Label


func _ready() -> void:
	set_meta("game_settings_dialog", true)
	title = "화면 및 연출 설정"
	ok_button_text = "닫기"
	_build_contents()


static func open_for(host: Node) -> AcceptDialog:
	var dialog: AcceptDialog
	for child in host.get_children():
		if child is AcceptDialog and child.has_meta("game_settings_dialog"):
			dialog = child as AcceptDialog
			break
	if dialog == null:
		dialog = load("res://scripts/ui/game_settings_dialog.gd").new() as AcceptDialog
		host.add_child(dialog)
	dialog.call("_refresh_values")
	dialog.popup_centered(Vector2i(500, 430))
	return dialog


func _build_contents() -> void:
	if _resolution_option != null:
		return
	_display_settings = DisplaySettingsScript.new()
	var content := VBoxContainer.new()
	content.custom_minimum_size = Vector2(420, 0)
	content.add_theme_constant_override("separation", 10)
	add_child(content)

	var explanation := Label.new()
	explanation.text = "화면 크기와 창 모드는 이 컴퓨터에만 저장됩니다. 게임 진행과 기록은 바뀌지 않습니다."
	explanation.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(explanation)

	_resolution_option = _add_option(content, "화면 크기", ["1280 × 720", "1920 × 1080"])
	_window_mode_option = _add_option(content, "표시 방식", ["창 모드", "전체 화면"])

	var apply_button := Button.new()
	apply_button.text = "화면 설정 적용"
	apply_button.pressed.connect(_apply_display_settings)
	content.add_child(apply_button)

	_status_label = Label.new()
	_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(_status_label)

	var divider := HSeparator.new()
	content.add_child(divider)
	var effects_title := Label.new()
	effects_title.text = "연출 강도"
	content.add_child(effects_title)
	for entry in [
		{"id": "screen_shake", "label": "화면 흔들림"},
		{"id": "flash", "label": "섬광"},
		{"id": "horror_distortion", "label": "공포 왜곡"}
	]:
		_add_effect_slider(content, String(entry.label), String(entry.id))
	_refresh_values()


func _add_option(parent: Control, label_text: String, labels: Array[String]) -> OptionButton:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	parent.add_child(row)
	var label := Label.new()
	label.text = label_text
	label.custom_minimum_size.x = 100
	row.add_child(label)
	var option := OptionButton.new()
	option.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for item in labels:
		option.add_item(item)
	row.add_child(option)
	return option


func _add_effect_slider(parent: Control, label_text: String, effect_id: String) -> void:
	var row := HBoxContainer.new()
	parent.add_child(row)
	var label := Label.new()
	label.text = label_text
	label.custom_minimum_size.x = 100
	row.add_child(label)
	var slider := HSlider.new()
	slider.min_value = 0
	slider.max_value = 100
	slider.step = 10
	slider.value = _accessibility.get_strength(effect_id) * 100.0
	slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	slider.value_changed.connect(func(value: float) -> void: _accessibility.set_strength(effect_id, value / 100.0))
	row.add_child(slider)


func _refresh_values() -> void:
	if _display_settings == null:
		return
	var resolution: Vector2i = _display_settings.get_resolution()
	_resolution_option.select(1 if resolution == DisplaySettingsScript.RESOLUTIONS[1] else 0)
	_window_mode_option.select(1 if _display_settings.get_window_mode() == DisplaySettingsScript.FULLSCREEN else 0)
	_status_label.text = "현재 설정: %s · %s" % [
		DisplaySettingsScript.resolution_to_id(resolution),
		"전체 화면" if _display_settings.get_window_mode() == DisplaySettingsScript.FULLSCREEN else "창 모드"
	]


func _apply_display_settings() -> void:
	var resolution: Vector2i = DisplaySettingsScript.RESOLUTIONS[_resolution_option.selected]
	var window_mode := DisplaySettingsScript.FULLSCREEN if _window_mode_option.selected == 1 else DisplaySettingsScript.WINDOWED
	var error: Error = _display_settings.apply_preferences(resolution, window_mode)
	if error == OK:
		_status_label.text = "적용됨: %s · %s" % [DisplaySettingsScript.resolution_to_id(resolution), "전체 화면" if window_mode == DisplaySettingsScript.FULLSCREEN else "창 모드"]
	else:
		_status_label.text = "화면 설정을 저장하지 못했습니다. (%d)" % error
