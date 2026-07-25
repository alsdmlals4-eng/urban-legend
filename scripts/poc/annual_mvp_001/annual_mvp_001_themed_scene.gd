extends "res://scripts/poc/annual_mvp_001/annual_mvp_001_scene.gd"

const ThemeFactory = preload("res://scripts/ui/ui_theme_factory.gd")


func _ready() -> void:
	theme = ThemeFactory.create_theme()
	super()
