# 격리된 수동 QA에서 사건별 미니게임을 바로 실행한다.
extends SceneTree


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var game_state := root.get_node("GameState")
	var red_umbrella := OS.get_cmdline_user_args().has("--red-umbrella")
	var episode_path := "res://data/episodes/episode_002_red_umbrella_alley.json" if red_umbrella else "res://data/episodes/episode_001_afterlife_station.json"
	var minigame_id := "minigame_rain_sync" if red_umbrella else "minigame_frequency_sync"
	game_state.load_episode(episode_path)
	game_state.set_current_minigame_id(minigame_id)
	change_scene_to_file("res://scenes/minigame_scene.tscn")
