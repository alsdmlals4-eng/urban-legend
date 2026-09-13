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
	for sample in [
		{"args": [], "display": "windows", "allow": "", "disabled": false},
		{"args": ["--headless"], "display": "windows", "allow": "false", "disabled": true},
		{"args": ["--display-driver", "headless"], "display": "windows", "allow": "", "disabled": true},
		{"args": ["--display-driver=headless"], "display": "windows", "allow": "0", "disabled": true},
		{"args": [], "display": "headless", "allow": "", "disabled": true},
		{"args": ["--headless"], "display": "headless", "allow": "true", "disabled": false},
	]:
		if helper.has_method("_disabled_for_headless") and helper.call("_disabled_for_headless", PackedStringArray(sample.args), sample.display, sample.allow) != sample.disabled:
			push_error("launch policy mismatch: " + str(sample))
			failures += 1
	if bool(helper.get("_registered")) != expected or bool(helper.get("_logger_attached")) != expected:
		push_error("actual helper capture/logger registration must follow launch opt-in")
		failures += 1
	if not expected and helper.is_processing():
		push_error("disabled headless helper must not tick")
		failures += 1
	print("Runtime helper launch: %d failures" % failures)
	quit(0 if failures == 0 else 1)
