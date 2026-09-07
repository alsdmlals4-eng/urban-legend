# Recovery 전조를 기존 절차음으로 짧게 구분하는 무상태 오디오 정책이다.
class_name RecoveryTelegraphAudio
extends RefCounted

const LogGuideScript = preload("res://scripts/ui/log_guide.gd")


static func mode_for_pattern(pattern_id: String) -> String:
	if pattern_id == "pattern_red_rain_rewind":
		return "warning"
	if pattern_id in ["pattern_red_reverse_reflection", "pattern_red_victim_approach", "pattern_red_dry_footprint_transfer"]:
		return "focus"
	return "normal"


static func make_stream(pattern_id: String) -> AudioStreamWAV:
	var generator := LogGuideScript.new()
	var stream := generator.make_signature_stream(mode_for_pattern(pattern_id))
	generator.free()
	return stream
