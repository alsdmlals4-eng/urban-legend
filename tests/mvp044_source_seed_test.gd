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
	_expect_seed(
		game_state.get_daily_episode("AFTER-02"),
		"agent_kwon_narae",
		"episode_001_afterlife_station",
		[
			"두 해석에서 일치하는 부분부터 기록하죠.",
			"누가 이걸 붙였는지 확인할 수 있어요?",
			"이 부적은 성공사례인가요, 위험 사례인가요?"
		],
		"AFTER-02"
	)
	_expect_seed(
		game_state.get_daily_episode("DAILY-02"),
		"agent_kwon_narae",
		"",
		[
			"말리는 방식도 술식에 영향을 줘요?",
			"한 장 정도는 시험해 보면 안 돼요?",
			"한유리가 묶은 은실을 조용히 푼다."
		],
		"DAILY-02"
	)
	_expect_seed(
		game_state.get_daily_episode("FACTION-02"),
		"agent_kwon_narae",
		"",
		[
			"비활성 복제본을 만들고 원본은 봉인하죠.",
			"현재 피해 가능성이 남아 있으면 보존할 수 없어요.",
			"누가 보존 가치를 결정하죠?"
		],
		"FACTION-02"
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
