extends "res://scripts/ui/main_menu.gd"

const ANNUAL_MVP_002_SCENE := "res://scenes/poc/annual_mvp_002/annual_mvp_002_scene.tscn"


func _ready() -> void:
	super()
	var dev_panel := find_child("DevToolsPanel", true, false) as VBoxContainer
	if dev_panel == null:
		push_warning("ANNUAL-MVP-002 개발자 도구 버튼을 추가할 DevToolsPanel을 찾지 못했습니다.")
		return
	_add_scene_button(
		dev_panel,
		"ANNUAL-MVP-002 동료·장비·연구 PoC",
		ANNUAL_MVP_002_SCENE
	)
