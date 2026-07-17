class_name NarrativeStageShell
extends PanelContainer

## Presentation-only shell shared by optional narrative scenes.  It deliberately
## owns no choices, save fields, or GameState mutations.
func _ready() -> void:
	var style := StyleBoxFlat.new()
	style.bg_color = Color("0b0a0d")
	style.border_color = Color("6f5c36")
	style.set_border_width_all(1)
	style.set_corner_radius_all(2)
	style.content_margin_left = 22
	style.content_margin_right = 22
	style.content_margin_top = 16
	style.content_margin_bottom = 16
	add_theme_stylebox_override("panel", style)
