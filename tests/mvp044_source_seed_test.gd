extends SceneTree

var _passed := 0
var _failed := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var game_state := root.get_node("GameState")
	_expect_seed(
		game_state.get_daily_episode("DAILY-01"),
		"agent_kwon_narae",
		"episode_001_afterlife_station",
		[
			"왜 치명탄을 기본으로 쓰지 않죠?",
			"붉은 탄창은 무엇에 쓰였어요?",
			"라벨 교체를 돕는다."
		],
		"DAILY-01"
	)
	_expect_seed(
		game_state.get_daily_episode("FACTION-01"),
		"agent_kwon_narae",
		"",
		[
			"익명화한 반복 조건만 교환하죠.",
			"돈으로만 거래하겠습니다.",
			"그 문장이 왜 필요한지부터 설명해요."
		],
		"FACTION-01"
	)
	_finish()


func _expect_seed(event: Dictionary, agent_id: String, case_id: String, expected_labels: Array, event_id: String) -> void:
	_expect(not event.is_empty(), "%s is registered" % event_id)
	_expect(String(event.get("agent_id", "")) == agent_id, "%s uses the approved primary speaker" % event_id)
	if not case_id.is_empty():
		_expect(String(event.get("case_id", "")) == case_id, "%s keeps its approved case link" % event_id)
	var choices: Array = event.get("choices", [])
	_expect(choices.size() == 3, "%s exposes all three approved choices" % event_id)
	for index in range(expected_labels.size()):
		if index >= choices.size() or typeof(choices[index]) != TYPE_DICTIONARY:
			_fail("%s choice %d is missing" % [event_id, index + 1])
			continue
		_expect(String((choices[index] as Dictionary).get("label", "")) == String(expected_labels[index]), "%s choice %d keeps the approved text" % [event_id, index + 1])


func _expect(condition: bool, message: String) -> void:
	if condition:
		_passed += 1
	else:
		_fail(message)


func _fail(message: String) -> void:
	_failed += 1
	push_error(message)


func _finish() -> void:
	if _failed == 0:
		print("MVP-044 source seeds: %d passed, 0 failed" % _passed)
		quit(0)
	else:
		push_error("MVP-044 source seeds: %d passed, %d failed" % [_passed, _failed])
		quit(1)
