extends RefCounted
## Observe actual retirement; never stop, mute, free or retain production resources.

var _tracked: Array[Dictionary] = []

func capture(scene: Node) -> void:
	var players := scene.find_children("*", "AudioStreamPlayer", true, false)
	if scene is AudioStreamPlayer:
		players.append(scene)
	for player in players:
		_track(player, "%s player" % player.name)
		if player.stream != null:
			_track(player.stream, "%s stream" % player.name)
		if player.has_stream_playback():
			_track(player.get_stream_playback(), "%s playback" % player.name)

func _track(value: Object, label: String) -> void:
	_tracked.append({"reference": weakref(value), "label": label})

func remaining() -> Array[String]:
	var labels: Array[String] = []
	for entry in _tracked:
		if entry.reference.get_ref() != null:
			labels.append(entry.label)
	return labels

func wait_for_release(tree: SceneTree, timeout_seconds: float = 1.0) -> Array[String]:
	var deadline := Time.get_ticks_msec() + int(maxf(0.0, timeout_seconds) * 1000.0)
	while not remaining().is_empty() and Time.get_ticks_msec() < deadline:
		await tree.create_timer(0.01, true, false, true).timeout
	return remaining()
