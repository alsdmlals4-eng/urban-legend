extends SceneTree

const EPISODES := [
	"res://data/episodes/episode_001_afterlife_station.json",
	"res://data/episodes/episode_002_red_umbrella_alley.json",
]


func _init() -> void:
	for path in EPISODES:
		var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(path))
		assert(typeof(parsed) == TYPE_DICTIONARY)
		var episode: Dictionary = parsed.get("episode", {})
		assert(not (episode.get("visuals", {}) as Dictionary).is_empty())
		assert(not (episode.get("anomaly_profile", {}) as Dictionary).is_empty())
		var agents: Array = parsed.get("agents", [])
		assert(agents.size() >= 3)
		for agent in agents:
			assert(not String(agent.get("specialty", "")).is_empty())
			assert(not String(agent.get("magic_lineage", "")).is_empty())
			assert(not String(agent.get("visual_asset_id", "")).is_empty())
	print("post_mvp_visual_data_test: PASS")
	quit()
