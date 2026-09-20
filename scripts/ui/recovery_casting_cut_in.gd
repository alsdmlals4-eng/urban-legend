extends Control
## Presentation only. The battle owner advances time and settles effects once.
signal finished

const DURATION := 1.2
var active := false
var _elapsed := 0.0
var _image: TextureRect
var _caption: Label
var _skip: Button

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_image = TextureRect.new()
	_image.name = "CastImage"
	_image.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_image.offset_bottom = -64.0
	_image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_image.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_image)
	_caption = Label.new()
	_caption.name = "CastCaption"
	_caption.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	_caption.offset_top = -64.0
	_caption.offset_bottom = -30.0
	_caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_caption.add_theme_font_size_override("font_size", 22)
	_caption.add_theme_color_override("font_color", Color("e3d6be"))
	_caption.add_theme_color_override("font_shadow_color", Color.BLACK)
	_caption.add_theme_constant_override("shadow_offset_x", 2)
	_caption.add_theme_constant_override("shadow_offset_y", 2)
	_caption.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_caption)
	_skip = Button.new()
	_skip.name = "SkipCastButton"
	_skip.text = "연출 건너뛰기"
	_skip.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	_skip.anchor_left = 0.5
	_skip.anchor_right = 0.5
	_skip.offset_left = -90.0
	_skip.offset_right = 90.0
	_skip.offset_top = -30.0
	_skip.pressed.connect(finish)
	add_child(_skip)
	visible = false

func play(support: Dictionary, texture: Texture2D) -> void:
	_elapsed = 0.0
	active = true
	_image.texture = texture # Missing art must never retain the previous caster.
	_caption.text = "%s · %s" % [String(support.get("agent_name", "요원")), String(support.get("label", "현장 대응"))]
	visible = true
	_present()

func advance(delta: float) -> void:
	if not active:
		return
	_elapsed = minf(DURATION, _elapsed + maxf(0.0, delta))
	if _elapsed >= DURATION:
		finish()
	else:
		_present()

func _present() -> void:
	# Short slide in, readable hold, gentle exit; no screen shake or flashes.
	var entry := smoothstep(0.0, 0.22, _elapsed)
	var exit_amount := smoothstep(0.94, DURATION, _elapsed)
	var shift := -32.0 * (1.0 - entry) + 18.0 * exit_amount
	_image.offset_left = shift
	_image.offset_right = shift
	_image.modulate.a = (0.25 + 0.75 * entry) * (1.0 - exit_amount)

func finish() -> void:
	if not active:
		return
	active = false
	visible = false
	_image.texture = null
	finished.emit()
