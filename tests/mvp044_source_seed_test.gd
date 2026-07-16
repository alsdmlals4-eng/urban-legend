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
	_expect_seed(
		game_state.get_daily_episode("AFTER-03"),
		"agent_kwon_narae",
		"episode_001_afterlife_station",
		[
			"저승역에 이전 대응팀이 있었다는 뜻인가요?",
			"이 장비를 다시 사용할 수 있어요?",
			"말없이 작업대의 새 나사를 건넨다."
		],
		"AFTER-03"
	)
	_expect_seed(
		game_state.get_daily_episode("DAILY-03"),
		"agent_kwon_narae",
		"",
		[
			"커피 하나에도 승인 절차가 필요한 이유가 있어요?",
			"공식이 완벽하면 문제없는 것 아닌가요?",
			"컵받침을 치우고 식은 커피를 새로 따른다."
		],
		"DAILY-03"
	)
	_expect_seed(
		game_state.get_daily_episode("FACTION-03"),
		"agent_kwon_narae",
		"",
		[
			"민간인 보호 완료 전에는 철수하지 않는 조건을 추가하죠.",
			"퇴로 상실 시 계약 종료를 명시하죠.",
			"당신이 원하는 세 번째 줄을 직접 써보세요."
		],
		"FACTION-03"
	)
	_expect_seed(
		game_state.get_daily_episode("AFTER-04"),
		"agent_kwon_narae",
		"episode_002_red_umbrella_alley",
		[
			"우산을 피하는 행동도 후유증 기록에 남길게요.",
			"오늘은 우산 없이 나갈 수 있는 출구로 안내할게요.",
			"세 번째 박자를 셀 때 어떤 골목이 떠오르는지 말해줄 수 있나요?"
		],
		"AFTER-04"
	)
	_expect_seed(
		game_state.get_daily_episode("DAILY-04"),
		"agent_kwon_narae",
		"",
		[
			"당직표의 마지막 이름을 소리 내지 않고 촬영한다.",
			"모두에게 각자 보이는 글자를 적게 한다.",
			"당직실의 여섯 번째 자리를 확인한다."
		],
		"DAILY-04"
	)
	_expect_seed(
		game_state.get_daily_episode("FACTION-04"),
		"agent_kwon_narae",
		"",
		[
			"문양을 복사하고 한 층씩 분리 소각하죠.",
			"봉인 상태로 보존하고 추가 분석하죠.",
			"카밀라가 즉시 태우려는 이유를 먼저 듣죠."
		],
		"FACTION-04"
	)
	_expect_seed(
		game_state.get_daily_episode("AFTER-05"),
		"agent_kwon_narae",
		"episode_002_red_umbrella_alley",
		[
			"윤서하의 돌파 실험을 제한 조건 아래 허용한다.",
			"강이준의 안전 기준이 완성될 때까지 중단한다.",
			"둘에게 실제 목적이 속도인지 대응 훈련인지 묻는다."
		],
		"AFTER-05"
	)
	_expect_seed(
		game_state.get_daily_episode("DAILY-05"),
		"agent_kwon_narae",
		"",
		[
			"문장을 오염 기록으로 표시하고 사본을 비교한다.",
			"“맞아요. 더 일찍 움직였어야 했어요.”라고 답한다.",
			"한유리에게 더 읽지 말고 연결만 확인해 달라고 한다."
		],
		"DAILY-05"
	)
	_expect_seed(
		game_state.get_daily_episode("FACTION-05"),
		"agent_kwon_narae",
		"",
		[
			"소문이 기억을 만든 시점을 추적하죠.",
			"정정된 소문을 시장에 유통하면 지울 수 있을까요?",
			"한유리에게서 우산을 먼저 떨어뜨려요."
		],
		"FACTION-05"
	)
	_expect_seed(
		game_state.get_daily_episode("AFTER-06"),
		"agent_kwon_narae",
		"episode_003_dead_frequency_station",
		[
			"피해자가 직접 사용할 목소리를 고르게 한다.",
			"발생 시점이 가장 이른 음성을 원본으로 지정한다.",
			"세 음성을 모두 보존하되 사용 권한을 분리한다."
		],
		"AFTER-06"
	)
	_expect_seed(
		game_state.get_daily_episode("DAILY-06"),
		"agent_kwon_narae",
		"",
		[
			"윤서하의 우산을 바로 꺼낸다.",
			"17번 칸 내부 길이를 장비로 측정한다.",
			"다른 우산을 넣지 말고 다음 비까지 관찰 표식을 붙인다."
		],
		"DAILY-06"
	)
	_expect_seed(
		game_state.get_daily_episode("FACTION-06"),
		"archivist_aka",
		"",
		[
			"유출 경로를 추적하되 소문을 즉시 삭제하지 않는다.",
			"사실과 다른 규칙을 공식 정정문으로 공개한다.",
			"박도윤에게 소문 확산 속도를 늦출 거래를 제안한다."
		],
		"FACTION-06"
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
