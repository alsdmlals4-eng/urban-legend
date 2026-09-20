# CCTV observation timing. Authored hypotheses never enter this world simulation.
extends Control

signal completed(successful: bool, details: Dictionary)
signal status_changed(text: String, progress: float)

var _elapsed := 0.0
var _duration := 12.0
var _mistakes := 0
var _max_mistakes := 3
var _protection := 0
var _started := false
var _finished := false
var _input_locked := false
var _attempts: Array[Dictionary] = []
var _cue_label: Label
var _observation: Label
var _capture_button: Button

func configure(config: Dictionary, equipment_assisted: bool) -> void:
	_duration = maxf(4.0, float(config.get("duration", 12.0)))
	_max_mistakes = maxi(1, int(config.get("max_hits", 3)))
	_protection = 1 if equipment_assisted else 0
	custom_minimum_size = Vector2(600, 430)
	focus_mode = Control.FOCUS_ALL
	var layout := VBoxContainer.new()
	add_child(layout)
	layout.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	layout.add_theme_constant_override("separation", 24)
	_cue_label = Label.new()
	_cue_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_cue_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_cue_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_cue_label.add_theme_font_size_override("font_size", 26)
	layout.add_child(_cue_label)
	_observation = Label.new()
	_observation.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_observation.custom_minimum_size.y = 100
	_observation.text = "CCTV의 끊긴 영상과 빗소리를 대조하세요.\n영상 고정 시점은 직접 선택합니다.\n매뉴얼을 열면 현장이 일시정지됩니다."
	layout.add_child(_observation)
	_capture_button = Button.new()
	_capture_button.name = "CaptureFrameButton"
	_capture_button.custom_minimum_size.y = 52
	# Host's field focus owns Enter/Space, avoiding duplicate GUI activation.
	_capture_button.focus_mode = Control.FOCUS_NONE
	_capture_button.pressed.connect(_capture_frame)
	layout.add_child(_capture_button)
	_refresh()
	set_process(true)
	call_deferred("grab_focus")

func set_input_locked(locked: bool) -> void:
	_input_locked = locked
	_capture_button.disabled = locked or _finished

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and not event.is_echo():
		_capture_frame()
		get_viewport().set_input_as_handled()

func _process(delta: float) -> void:
	if _input_locked or not _started or _finished:
		return
	_elapsed = minf(_duration, _elapsed + maxf(0.0, delta))
	if _elapsed >= _duration:
		_observation.text = "녹화 구간이 끝났습니다. 고정된 영상이 없습니다."
		_complete(false)
		return
	_refresh()

func _capture_frame() -> void:
	if _input_locked or _finished:
		return
	if not _started:
		_started = true
		_refresh()
		return
	var cue := int(fmod(_elapsed, 4.0))
	var clear_frame := cue == 3 and _elapsed < _duration
	var protected := not clear_frame and _protection > 0
	_attempts.append({"active_seconds": _elapsed, "cue": cue + 1, "clear_frame": clear_frame, "protected": protected})
	if clear_frame:
		_observation.text = "영상 고정: 빗소리가 끝난 뒤, 물웅덩이의 길이 먼저 이어졌습니다."
		_complete(true)
		return
	if protected:
		_protection -= 1
		_observation.text = "보조 장비가 끊긴 영상을 보존했습니다. 고정은 되지 않았습니다."
	else:
		_mistakes += 1
		_observation.text = "고정 실패: 빗소리 %d회째에 표지판과 발자국이 이전 위치로 겹칩니다.\n현재 관측을 기록과 다시 비교할 수 있습니다." % (cue + 1)
	if _mistakes >= _max_mistakes:
		_complete(false)
	else:
		_refresh()

func _refresh() -> void:
	var cue := int(fmod(_elapsed, 4.0))
	_cue_label.text = "CCTV · 재생 대기" if not _started else ("빗소리 · %d\n영상이 겹칩니다" % (cue + 1) if cue < 3 else "빗소리가 멎었습니다\n물웅덩이의 길이 먼저 이어집니다")
	_capture_button.text = "재생 시작 · Enter / Space" if not _started else "영상 고정 · Enter / Space"
	status_changed.emit("녹화 %.1f / %.0f초 · 고정 실패 %d / %d" % [_elapsed, _duration, _mistakes, _max_mistakes], _elapsed / _duration)

func _complete(successful: bool) -> void:
	if _finished:
		return
	_finished = true
	set_process(false)
	_capture_button.disabled = true
	completed.emit(successful, {"game_type": "rain_frame_sync", "elapsed": _elapsed, "mistakes": _mistakes, "attempts": _attempts.duplicate(true), "observation": _observation.text, "input_summary": "%.1f초 · 영상 고정 %d회 / 실패 %d회 · %s" % [_elapsed, _attempts.size(), _mistakes, _observation.text]})
