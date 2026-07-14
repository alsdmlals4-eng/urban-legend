# 기록국 화면에서 공유하는 현대 오컬트 UI 테마를 생성한다.
class_name UiThemeFactory
extends RefCounted

const COLOR_VOID := Color("090d13")
const COLOR_PANEL := Color("111923")
const COLOR_PANEL_SOFT := Color("18232e")
const COLOR_INK := Color("e8edf0")
const COLOR_MUTED := Color("9cacb3")
const COLOR_TEAL := Color("4fc3b5")
const COLOR_AMBER := Color("d6ad62")
const COLOR_DANGER := Color("d0505e")


static func create_theme() -> Theme:
	var theme := Theme.new()
	theme.default_font_size = 17
	theme.set_color("font_color", "Label", COLOR_INK)
	theme.set_color("font_shadow_color", "Label", Color(0, 0, 0, 0.65))
	theme.set_constant("shadow_offset_x", "Label", 1)
	theme.set_constant("shadow_offset_y", "Label", 2)
	theme.set_color("font_color", "Button", COLOR_INK)
	theme.set_color("font_hover_color", "Button", Color.WHITE)
	theme.set_color("font_pressed_color", "Button", COLOR_AMBER)
	theme.set_font_size("font_size", "Button", 16)
	theme.set_stylebox("normal", "Button", _style(COLOR_PANEL, Color("31434d"), 6, 12))
	theme.set_stylebox("hover", "Button", _style(Color("1d2a34"), COLOR_TEAL, 6, 12))
	theme.set_stylebox("pressed", "Button", _style(Color("26333a"), COLOR_AMBER, 6, 12))
	theme.set_stylebox("disabled", "Button", _style(Color("10151b"), Color("252f35"), 6, 12))
	theme.set_stylebox("panel", "PanelContainer", _style(Color(0.045, 0.065, 0.085, 0.94), Color("293943"), 6, 14))
	theme.set_type_variation("AgentCard", "PanelContainer")
	theme.set_stylebox("panel", "AgentCard", _style(Color("111923"), Color("31434d"), 6, 14))
	theme.set_type_variation("AgentCardSelected", "PanelContainer")
	theme.set_stylebox("panel", "AgentCardSelected", _style(Color("16252b"), COLOR_TEAL, 6, 14))
	theme.set_type_variation("HudStrip", "PanelContainer")
	theme.set_stylebox("panel", "HudStrip", _style(Color(0.035, 0.055, 0.07, 0.86), Color("31434d"), 4, 10))
	theme.set_type_variation("DialogueDock", "PanelContainer")
	theme.set_stylebox("panel", "DialogueDock", _style(Color(0.025, 0.035, 0.05, 0.96), Color("3a4d58"), 8, 18))
	theme.set_type_variation("OverlayDrawer", "PanelContainer")
	theme.set_stylebox("panel", "OverlayDrawer", _style(Color(0.035, 0.05, 0.065, 0.98), COLOR_TEAL, 6, 14))
	theme.set_type_variation("ActionCard", "PanelContainer")
	theme.set_stylebox("panel", "ActionCard", _style(Color(0.055, 0.08, 0.105, 0.96), Color("3a4d58"), 8, 10))
	theme.set_type_variation("ActionCardCritical", "PanelContainer")
	theme.set_stylebox("panel", "ActionCardCritical", _style(Color(0.13, 0.09, 0.055, 0.97), COLOR_AMBER, 8, 10))
	theme.set_type_variation("TeamStatusChip", "PanelContainer")
	theme.set_stylebox("panel", "TeamStatusChip", _style(Color(0.035, 0.055, 0.07, 0.9), Color("31434d"), 20, 8))
	theme.set_stylebox("background", "ProgressBar", _style(Color("0a1016"), Color("26343c"), 4, 0))
	theme.set_stylebox("fill", "ProgressBar", _style(COLOR_TEAL, COLOR_TEAL, 4, 0))
	return theme


static func panel_style(accent: Color = Color("31434d"), alpha: float = 0.94) -> StyleBoxFlat:
	return _style(Color(COLOR_PANEL, alpha), accent, 6, 14)


static func _style(background: Color, border: Color, radius: int, content_margin: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = background
	style.border_color = border
	style.set_border_width_all(1)
	style.set_corner_radius_all(radius)
	style.content_margin_left = content_margin
	style.content_margin_top = content_margin
	style.content_margin_right = content_margin
	style.content_margin_bottom = content_margin
	return style
