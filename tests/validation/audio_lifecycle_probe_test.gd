extends SceneTree

const Probe = preload("res://tests/test_audio_lifecycle.gd")
const Guide = preload("res://scripts/ui/log_guide.gd")
var failures: Array[String] = []

func _initialize() -> void:
	call_deferred("run")

func check(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)

func run() -> void:
	for iteration in range(3):
		var guide := Guide.new()
		root.add_child(guide)
		guide.present_lines([{"text": "audio lifecycle fixture"}], "warning", true)
		var player: AudioStreamPlayer = guide.get("_audio_player")
		var retained_stream: AudioStream = player.stream
		var probe := Probe.new()
		probe.capture(guide)
		check(not probe.remaining().is_empty(), "live audio must be observable, not skipped")
		guide.queue_free()
		await process_frame
		await process_frame
		var held: Array[String] = await probe.wait_for_release(self, 0.05)
		check(not held.is_empty(), "retained resource must fail the retirement deadline")
		check(retained_stream != null, "negative fixture deliberately owns the actual stream")
		retained_stream = null
		var released: Array[String] = await probe.wait_for_release(self)
		check(released.is_empty(), "released scene/audio must retire without mutation: %s" % str(released))
	for failure in failures:
		push_error(failure)
	print("Audio lifecycle probe: %d failures" % failures.size())
	quit(0 if failures.is_empty() else 1)
