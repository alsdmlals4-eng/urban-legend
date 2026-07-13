# 로그의 초상, 대사 순서, 표정과 접속 시그니처를 표시한다.
class_name LogGuide
extends PanelContainer

signal sequence_finished

const AssetCatalog = preload("res://scripts/ui/ui_asset_catalog.gd")
const ThemeFactory = preload("res://scripts/ui/ui_theme_factory.gd")
const TutorialCatalog = preload("res://scripts/ui/log_tutorial_catalog.gd")

const VALID_EXPRESSIONS := ["normal", "focus", "warning"]
const MIX_RATE := 22050

var _portrait: TextureRect
var _speaker_label: Label
var _dialogue_label: Label
var _next_button: Button
var _audio_player: AudioStreamPlayer
var _status_line: ColorRect
var _lines: Array = []
var _line_index := 0
var _current_expression := "normal"
var _built := false
var _compact := false


func _ready() -> void:
	_ensure_ui()


func present_lines(lines: Array, signature_mode: String = "normal", play_intro: bool = true) -> void:
	_ensure_ui()
	_lines.clear()
	for line in lines:
		if typeof(line) == TYPE_DICTIONARY and not String(line.get("text", "")).is_empty():
			_lines.append(Dictionary(line).duplicate(true))
	_line_index = 0
	visible = not _lines.is_empty()
	if _lines.is_empty():
		_dialogue_label.text = ""
		_next_button.visible = false
		return
	_apply_current_line()
	if play_intro:
		_play_signature(signature_mode)


func present_tutorial(tutorial_id: String, play_intro: bool = true) -> bool:
	var entry := TutorialCatalog.get_entry(tutorial_id)
	if entry.is_empty():
		return false
	present_lines(entry.get("lines", []), String(entry.get("expression", "normal")), play_intro)
	return true


func show_compact_hint(text: String) -> void:
	if text.strip_edges().is_empty():
		visible = false
		return
	set_compact(true)
	present_lines([{"text": text, "expression": "normal"}], "normal", false)


func advance() -> void:
	if _lines.is_empty():
		return
	if _line_index + 1 >= _lines.size():
		_next_button.visible = false
		sequence_finished.emit()
		return
	_line_index += 1
	_apply_current_line()


func get_current_text() -> String:
	return "" if _dialogue_label == null else _dialogue_label.text


func get_current_expression() -> String:
	return _current_expression


func set_compact(compact: bool) -> void:
	_compact = compact
	if not _built:
		return
	_portrait.custom_minimum_size = Vector2(92, 92) if compact else Vector2(156, 156)
	_dialogue_label.custom_minimum_size.y = 44 if compact else 72


func make_signature_stream(mode: String) -> AudioStreamWAV:
	var clean_mode := mode if mode in VALID_EXPRESSIONS else "normal"
	var base_frequency := 620.0
	var note_duration := 0.065
	var gap_duration := 0.035
	if clean_mode == "focus":
		base_frequency = 560.0
		gap_duration = 0.03
	elif clean_mode == "warning":
		base_frequency = 420.0
		note_duration = 0.055
		gap_duration = 0.018
	var intervals := [1.0, 1.25, 1.5]
	var total_duration: float = intervals.size() * note_duration + (intervals.size() - 1) * gap_duration
	var sample_count := int(total_duration * MIX_RATE)
	var pcm := PackedByteArray()
	pcm.resize(sample_count * 2)
	var cursor := 0.0
	for interval in intervals:
		var note_samples := int(note_duration * MIX_RATE)
		for sample_index in range(note_samples):
			var t := float(sample_index) / MIX_RATE
			var envelope := sin(PI * float(sample_index) / maxf(1.0, note_samples - 1.0))
			var value := sin(TAU * base_frequency * float(interval) * t) * envelope * 0.22
			if clean_mode == "focus":
				value += sin(float(sample_index) * 0.37) * envelope * 0.025
			var encoded := clampi(int(value * 32767.0), -32768, 32767)
			pcm.encode_s16(int(cursor) * 2, encoded)
			cursor += 1.0
		if cursor < sample_count:
			cursor += gap_duration * MIX_RATE
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = MIX_RATE
	stream.stereo = false
	stream.data = pcm
	return stream


func _ensure_ui() -> void:
	if _built:
		return
	_built = true
	theme = ThemeFactory.create_theme()
	name = "LogGuide"
	add_theme_stylebox_override("panel", ThemeFactory.panel_style(Color("3d7184"), 0.88))

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	add_child(row)

	var portrait_frame := Control.new()
	portrait_frame.custom_minimum_size = Vector2(156, 156)
	row.add_child(portrait_frame)

	_portrait = TextureRect.new()
	_portrait.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	portrait_frame.add_child(_portrait)

	_status_line = ColorRect.new()
	_status_line.set_anchors_preset(Control.PRESET_TOP_WIDE)
	_status_line.offset_bottom = 4
	_status_line.mouse_filter = Control.MOUSE_FILTER_IGNORE
	portrait_frame.add_child(_status_line)

	var copy := VBoxContainer.new()
	copy.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	copy.add_theme_constant_override("separation", 6)
	row.add_child(copy)

	_speaker_label = Label.new()
	_speaker_label.text = "로그 · 괴담기록국 AI"
	_speaker_label.add_theme_color_override("font_color", ThemeFactory.COLOR_TEAL)
	copy.add_child(_speaker_label)

	_dialogue_label = Label.new()
	_dialogue_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_dialogue_label.custom_minimum_size.y = 72
	_dialogue_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	copy.add_child(_dialogue_label)

	_next_button = Button.new()
	_next_button.text = "로그 계속"
	_next_button.pressed.connect(advance)
	copy.add_child(_next_button)

	_audio_player = AudioStreamPlayer.new()
	add_child(_audio_player)
	set_compact(_compact)


func _apply_current_line() -> void:
	var line: Dictionary = _lines[_line_index]
	_current_expression = String(line.get("expression", "normal"))
	if _current_expression not in VALID_EXPRESSIONS:
		_current_expression = "normal"
	_dialogue_label.text = String(line.get("text", ""))
	_portrait.texture = AssetCatalog.new().get_log_expression(_current_expression)
	_next_button.visible = _line_index + 1 < _lines.size()
	_status_line.color = _expression_color(_current_expression)
	_portrait.modulate = Color.WHITE


func _play_signature(mode: String) -> void:
	var clean_mode := mode if mode in VALID_EXPRESSIONS else "normal"
	_audio_player.stream = make_signature_stream(clean_mode)
	_audio_player.play()
	_current_expression = clean_mode
	_status_line.color = _expression_color(clean_mode)
	_portrait.modulate = Color(0.64, 0.86, 1.0, 0.72)
	var tween := create_tween()
	tween.tween_property(_portrait, "modulate", Color.WHITE, 0.22)


func _expression_color(expression: String) -> Color:
	if expression == "warning":
		return Color("e39b43")
	if expression == "focus":
		return Color("55d6ef")
	return Color("68b8c8")
