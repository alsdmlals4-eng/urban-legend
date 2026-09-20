extends SceneTree

func _initialize() -> void:
	var tool = load("res://addons/hera_agent_godot/tools/game_tool.gd").new()
	if not tool.has_method("_select_game"):
		push_error("Explicit runtime targeting must survive scene transitions without selecting another game")
		quit(1)
		return
	var rows := [{"pid": 11, "scene": "res://scenes/preparation_scene.tscn"}, {"pid": 12, "scene": "res://scenes/main_menu.tscn"}]
	var failed := 0
	var selected: Dictionary = tool.call("_select_game", rows, "res://scenes/main_menu.tscn", 11)
	if int(selected.get("pid", 0)) != 11:
		failed += 1
	if not tool.call("_select_game", rows, "res://scenes/main_menu.tscn", 99).has("error"):
		failed += 1
	if not tool.call("_select_game", [], "res://scenes/main_menu.tscn", 11).has("error"):
		failed += 1
	if int(tool.call("_select_game", rows, "res://scenes/main_menu.tscn", 0).get("pid", 0)) != 12:
		failed += 1
	if not tool.call("_select_game", rows, "", 0).has("error"):
		failed += 1
	print("Hera explicit runtime target: %d failures" % failed)
	quit(0 if failed == 0 else 1)
