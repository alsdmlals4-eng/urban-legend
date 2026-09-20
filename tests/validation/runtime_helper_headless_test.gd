extends SceneTree

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	var failures := 0
	var helper: Node
	for child in root.get_children():
		var script: Script = child.get_script()
		if script != null and script.resource_path == "res://addons/godot_ai/runtime/game_helper.gd":
			helper = child
	if helper == null:
		push_error("configured runtime helper autoload must be present")
		quit(1)
		return
	var expected := "--expect-enabled" in OS.get_cmdline_user_args()
	# Observe the configured autoload and its actual implementation, not the
	# retired monolithic helper's private fields (missing fields return null).
	var implementation := helper.get_node_or_null("GameHelperImplementation")
	if expected:
		if implementation == null:
			push_error("opt-in must instantiate the runtime implementation")
			failures += 1
		elif implementation.get("_registered") != true or implementation.get("_logger_attached") != true:
			push_error("opt-in implementation must register capture and logger")
			failures += 1
	elif implementation != null or helper.get_child_count() != 0:
		push_error("disabled headless wrapper must not instantiate the implementation")
		failures += 1
	if not expected and helper.is_processing():
		push_error("disabled headless helper must not tick")
		failures += 1
	print("Runtime helper launch: %d failures" % failures)
	quit(0 if failures == 0 else 1)
