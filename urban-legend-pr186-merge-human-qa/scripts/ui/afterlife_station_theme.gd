# 저승역 전용의 얇은 금속 프레임·명조 제목·보라 강조 테마를 만든다.
class_name AfterlifeStationTheme
extends RefCounted

const VOID := Color("08080b")
const PANEL := Color("101014")
const PANEL_SOFT := Color("17151a")
const INK := Color("ddd7cb")
const MUTED := Color("968e86")
const GOLD := Color("9b8157")
const VIOLET := Color("80609e")
const DANGER := Color("a43b3d")


static func create_theme() -> Theme:
	var theme := Theme.new()
	var sans := load("res://assets/fonts/noto/NotoSansKR-VF.ttf") as Font
	var serif := load("res://assets/fonts/noto/NotoSerifKR-VF.ttf") as Font
	theme.default_font = sans
	theme.default_font_size = 14
	theme.set_font("font", "Label", sans)
	theme.set_font("font", "Button", sans)
	theme.set_font_size("font_size", "Label", 14)
	theme.set_font_size("font_size", "Button", 14)
	theme.set_color("font_color", "Label", INK)
	theme.set_color("font_color", "Button", INK)
	theme.set_color("font_hover_color", "Button", Color("fff7e8"))
	theme.set_color("font_pressed_color", "Button", Color("d7bb8b"))
	theme.set_color("font_disabled_color", "Button", Color("5e5956"))
	theme.set_stylebox("normal", "Button", _style(Color("111116"), Color("3e3938"), 0, 9, 1))
	theme.set_stylebox("hover", "Button", _style(Color("1a171e"), VIOLET, 0, 9, 1))
	theme.set_stylebox("pressed", "Button", _style(Color("201a24"), GOLD, 0, 9, 1))
	theme.set_stylebox("disabled", "Button", _style(Color("0b0b0e"), Color("2a2728"), 0, 9, 1))
	theme.set_stylebox("panel", "PanelContainer", _style(Color(0.035, 0.032, 0.039, 0.97), Color("443c37"), 0, 10, 1))
	theme.set_type_variation("AfterlifeHeader", "PanelContainer")
	theme.set_stylebox("panel", "AfterlifeHeader", _style(Color(0.018, 0.017, 0.021, 0.98), Color("5b4c3c"), 0, 8, 1))
	theme.set_type_variation("AfterlifePanel", "PanelContainer")
	theme.set_stylebox("panel", "AfterlifePanel", _style(Color(0.025, 0.023, 0.028, 0.96), Color("51463b"), 0, 10, 1))
	theme.set_type_variation("AfterlifePanelSelected", "PanelContainer")
	theme.set_stylebox("panel", "AfterlifePanelSelected", _style(Color("17121c"), VIOLET, 0, 10, 2))
	theme.set_type_variation("AfterlifeRisk", "PanelContainer")
	theme.set_stylebox("panel", "AfterlifeRisk", _style(Color("1b0b0d"), DANGER, 0, 9, 1))
	theme.set_type_variation("AfterlifeBook", "PanelContainer")
	theme.set_stylebox("panel", "AfterlifeBook", _style(Color(0, 0, 0, 0), Color(0, 0, 0, 0), 0, 0, 0))
	theme.set_type_variation("AfterlifeTitle", "Label")
	theme.set_font("font", "AfterlifeTitle", serif)
	theme.set_font_size("font_size", "AfterlifeTitle", 21)
	theme.set_color("font_color", "AfterlifeTitle", Color("c7b18d"))
	theme.set_type_variation("AfterlifeSection", "Label")
	theme.set_font("font", "AfterlifeSection", serif)
	theme.set_font_size("font_size", "AfterlifeSection", 18)
	theme.set_color("font_color", "AfterlifeSection", Color("b89bd0"))
	theme.set_type_variation("AfterlifeMeta", "Label")
	theme.set_font_size("font_size", "AfterlifeMeta", 12)
	theme.set_color("font_color", "AfterlifeMeta", MUTED)
	return theme


static func panel_style(accent: Color = GOLD, alpha: float = 0.97, margin: int = 10) -> StyleBoxFlat:
	return _style(Color(PANEL, alpha), accent, 0, margin, 1)


static func risk_style() -> StyleBoxFlat:
	return _style(Color("1b0b0d"), DANGER, 0, 8, 1)


static func _style(background: Color, border: Color, radius: int, margin: int, width: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = background
	style.border_color = border
	style.set_border_width_all(width)
	style.set_corner_radius_all(radius)
	style.content_margin_left = margin
	style.content_margin_top = margin
	style.content_margin_right = margin
	style.content_margin_bottom = margin
	return style
