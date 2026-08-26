# M04 Recovery 전조 절차음의 패턴 매핑과 생성 스트림을 headless로 검증한다.
extends SceneTree

const AUDIO_POLICY := preload("res://scripts/ui/recovery_telegraph_audio.gd")

var _failures: Array[String] = []


func _init() -> void:
	_expect(AUDIO_POLICY.mode_for_pattern("pattern_red_rain_rewind") == "warning", "M04 third-rain rewind must use warning cue")
	_expect(AUDIO_POLICY.mode_for_pattern("pattern_red_reverse_reflection") == "focus", "M04 non-rewind telegraph must use focus cue")
	_expect(AUDIO_POLICY.mode_for_pattern("unknown") == "normal", "unknown pattern must use safe normal cue")
	var stream: AudioStreamWAV = AUDIO_POLICY.make_stream("pattern_red_rain_rewind")
	_expect(stream != null, "telegraph cue must create a stream")
	if stream != null:
		_expect(stream.mix_rate == 22050, "telegraph cue must preserve project procedural mix rate")
		_expect(stream.format == AudioStreamWAV.FORMAT_16_BITS, "telegraph cue must preserve PCM format")
		_expect(not stream.data.is_empty(), "telegraph cue must contain PCM data")
	_finish()


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("RECOVERY TELEGRAPH AUDIO: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
