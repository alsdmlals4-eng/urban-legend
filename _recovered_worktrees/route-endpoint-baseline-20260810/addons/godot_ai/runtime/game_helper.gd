extends Node

## Headless-safe autoload wrapper for the unmodified Godot AI game helper.
## Normal editor/game runs instantiate the upstream implementation unchanged.
const GameHelperImpl := preload("res://addons/godot_ai/runtime/game_helper_impl.gd")

var _implementation: Node


func _ready() -> void:
	if _disabled_for_headless_launch():
		return
	_implementation = GameHelperImpl.new()
	_implementation.name = "GameHelperImplementation"
	add_child(_implementation)


func _disabled_for_headless_launch() -> bool:
	var opt_in := OS.get_environment("GODOT_AI_ALLOW_HEADLESS").strip_edges().to_lower()
	if opt_in in ["1", "true", "yes", "on"]:
		return false
	if DisplayServer.get_name().to_lower() == "headless":
		return true
	for argument in OS.get_cmdline_args():
		var normalized := String(argument).strip_edges().to_lower()
		if normalized == "--headless" or normalized == "--display-driver=headless":
			return true
	return false
