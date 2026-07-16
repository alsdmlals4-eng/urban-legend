extends SceneTree

const TestSaveGuard = preload("res://tests/test_save_guard.gd")

var _guard := TestSaveGuard.new()
var _prepared := false
var _passed := 0
var _failed := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var game_state := root.get_node("GameState")
	var guard_error := _guard.prepare(game_state.SAVE_FILE_PATH)
	if not guard_error.is_empty():
		_fail(guard_error)
		_finish()
		return
	_prepared = true
	game_state.reset_run_state()
	_expect(game_state.has_method("get_research_projects"), "research project catalog is available")
	_expect(game_state.has_method("complete_research_project"), "research completion API is available")
	_expect(game_state.has_method("craft_research_project"), "research crafting API is available")
	if not game_state.has_method("get_research_projects") or not game_state.has_method("complete_research_project") or not game_state.has_method("craft_research_project"):
		_finish()
		return

	var projects: Array = game_state.get_research_projects()
	var prism := _find_project(projects, "research_resonance_prism")
	_expect(not prism.is_empty(), "resonance prism project exists")
	_expect(int(prism.get("research_cost", 0)) == 3, "starter equipment research costs 3 points")
	_expect(int(prism.get("fragment_cost", 0)) == 35, "starter equipment crafting costs 35 fragments")

	var insufficient: Dictionary = game_state.complete_research_project("research_resonance_prism")
	_expect(not bool(insufficient.get("successful", false)), "research cannot complete without earned points")
	game_state.research_points = 3
	var completed: Dictionary = game_state.complete_research_project("research_resonance_prism")
	_expect(bool(completed.get("successful", false)), "earned research points complete the project")
	_expect(game_state.get_research_points() == 0, "completion consumes exactly the approved research cost")
	_expect(not bool(game_state.complete_research_project("research_resonance_prism").get("successful", false)), "completed research cannot consume points twice")

	_expect(game_state.grant_echo_reward("test:research-prism", 5), "test reward raises the starting fragments to the craft cost")
	var crafted: Dictionary = game_state.craft_research_project("research_resonance_prism")
	_expect(bool(crafted.get("successful", false)), "completed project crafts its unlocked equipment")
	_expect(game_state.has_unlocked_equipment("gear_resonance_prism"), "crafted research equipment enters the normal equipment inventory")
	_expect(game_state.get_echo_fragments() == 0, "crafting consumes exactly 35 fragments")
	_expect(not bool(game_state.craft_research_project("research_resonance_prism").get("successful", false)), "permanent research equipment cannot be crafted twice")

	_expect(game_state.save_game() and game_state.load_game(), "research projects use the normal save path")
	_expect(_find_project(game_state.get_completed_research_projects(), "research_resonance_prism").get("id", "") == "research_resonance_prism", "completed project survives save round-trip")
	_expect(game_state.has_unlocked_equipment("gear_resonance_prism"), "crafted equipment survives save round-trip")
	_finish()


func _find_project(projects: Array, project_id: String) -> Dictionary:
	for project in projects:
		if typeof(project) == TYPE_DICTIONARY and String(project.get("id", "")) == project_id:
			return project
	return {}


func _expect(condition: bool, message: String) -> void:
	if condition:
		_passed += 1
	else:
		_fail(message)


func _fail(message: String) -> void:
	_failed += 1
	push_error(message)


func _finish() -> void:
	if _prepared:
		var restore_error := _guard.restore()
		_prepared = false
		if not restore_error.is_empty():
			_fail(restore_error)
	if _failed == 0:
		print("MVP-047 research projects: %d passed, 0 failed" % _passed)
		quit(0)
	else:
		push_error("MVP-047 research projects: %d passed, %d failed" % [_passed, _failed])
		quit(1)
