extends SceneTree

var failures: Array[String] = []

func _init() -> void:
	call_deferred("run")

func check(value: bool, message: String) -> void:
	if not value:
		failures.append(message)

func run() -> void:
	var state := root.get_node("GameState")
	var path: String = state.get_save_file_path()
	var pending := path + ".pending"
	# Do not overwrite any pre-existing stage, even in a test workspace.
	if FileAccess.file_exists(pending) or DirAccess.dir_exists_absolute(pending):
		push_error("Test requires an unused stage path: " + pending)
		quit(1)
		return
	var guard = load("res://tests/test_save_guard.gd").new()
	var error: String = guard.prepare(path)
	if not error.is_empty():
		push_error(error)
		quit(1)
		return
	state.reset_run_state()
	state.start_episode_from_preparation("res://data/episodes/episode_002_red_umbrella_alley.json")
	check(state.save_game(), "initial save succeeds")
	var before := FileAccess.get_file_as_bytes(path)
	check(DirAccess.make_dir_absolute(pending) == OK, "create owned stage obstacle")
	state.add_flag("staging-roundtrip-test")
	check(not state.save_game(), "unwritable stage must fail, not overwrite primary")
	check(FileAccess.get_file_as_bytes(path) == before, "failed staging must preserve primary bytes")
	check(DirAccess.remove_absolute(pending) == OK, "remove only owned empty stage obstacle")
	check(state.save_game(), "retry after stage becomes writable succeeds")
	check(not FileAccess.file_exists(pending), "successful promotion consumes staging file")
	check(state.load_game(), "new primary reloads")
	check(state.has_flag("staging-roundtrip-test"), "retried progress is persisted")
	check(FileAccess.get_file_as_bytes(path) != before, "new primary contains new progress")
	if OS.get_name() == "Windows":
		before = FileAccess.get_file_as_bytes(path)
		check(FileAccess.set_read_only_attribute(path, true) == OK, "protect isolated test primary")
		state.add_flag("promotion-roundtrip-test")
		check(not state.save_game(), "protected primary must refuse replacement")
		check(FileAccess.get_file_as_bytes(path) == before, "failed promotion preserves primary bytes")
		check(FileAccess.set_read_only_attribute(path, false) == OK, "restore isolated primary permissions")
		check(state.save_game(), "retry after replacement permission restored succeeds")
		check(state.load_game() and state.has_flag("promotion-roundtrip-test"), "promotion retry round trip")
	check(guard.restore().is_empty(), "restore guarded save")
	for message in failures:
		push_error(message)
	print("Generic save staging: ", failures.size(), " failures")
	quit(0 if failures.is_empty() else 1)
