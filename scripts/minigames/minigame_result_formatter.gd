# 보고서와 기록국 DB가 같은 미니게임 결과 형식을 사용하도록 관리한다.
class_name MinigameResultFormatter
extends RefCounted


static func make_report_line(title: String, result: Dictionary) -> String:
	var state := "성공" if bool(result.get("successful", false)) else "실패"
	var line := "%s: %s - %s" % [title, state, String(result.get("result_text", "결과가 기록되었습니다."))]
	var input_summary := String(result.get("input_summary", "")).strip_edges()
	if not input_summary.is_empty():
		line += "\n플레이: %s" % input_summary
	var effect_summary := String(result.get("effect_summary", "")).strip_edges()
	if not effect_summary.is_empty():
		line += "\n상태 변화: %s" % effect_summary
	return line
