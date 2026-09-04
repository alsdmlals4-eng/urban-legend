# 보고서와 DB가 같은 미니게임 플레이 요약을 표시하는지 검증한다.
extends SceneTree

const Formatter = preload("res://scripts/minigames/minigame_result_formatter.gd")


func _init() -> void:
	var line := Formatter.make_report_line("폐주파수 동기화", {
		"successful": true,
		"result_text": "이름 파형을 고정했습니다.",
		"input_summary": "5박자 중 4회 동기화",
		"effect_summary": "위험도 -5"
	})
	var passed := line.contains("폐주파수 동기화: 성공") and line.contains("플레이: 5박자 중 4회 동기화") and line.contains("상태 변화: 위험도 -5")
	if passed:
		print("MINIGAME FORMATTER: assertions passed")
		quit(0)
		return
	push_error("Formatted report line is missing outcome, play summary, or effect summary: %s" % line)
	quit(1)
