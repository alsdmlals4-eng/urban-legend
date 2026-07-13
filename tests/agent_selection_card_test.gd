# 준비 화면 요원 카드가 표시와 입력만 담당하는지 검증한다.
extends SceneTree

const CARD_SCENE_PATH := "res://scenes/ui/agent_selection_card.tscn"


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	if not ResourceLoader.exists(CARD_SCENE_PATH):
		_fail("agent selection card scene is missing")
		return

	var packed := load(CARD_SCENE_PATH) as PackedScene
	var card := packed.instantiate()
	root.add_child(card)

	var agent := {
		"id": "agent_test",
		"name": "아주 긴 이름을 가진 현장 분석 요원",
		"temperament_label": "분석형",
		"class": "선임 조사관",
		"role": "현장 분석 및 기록 검증",
		"description": "긴 한국어 설명도 카드 바깥으로 넘치지 않고 여러 줄로 읽을 수 있어야 합니다."
	}
	var state := {
		"selected": true,
		"selection_disabled": false,
		"current_hp": 75,
		"max_hp": 100,
		"current_mental": 60,
		"max_mental": 90,
		"abilities": {"suppression": 2, "analysis": 5, "protection": 3, "treatment": 1, "rapport": 4},
		"ability_labels": {"suppression": "제압", "analysis": "분석", "protection": "보호", "treatment": "치료", "rapport": "교감"}
	}
	if not card.configure(agent, state):
		_fail("valid agent data was rejected")
		return

	var selection_button := card.get_node("%SelectionButton") as Button
	var detail_button := card.get_node("%DetailButton") as Button
	var name_label := card.get_node("%NameLabel") as Label
	var description_label := card.get_node("%DescriptionLabel") as Label
	if selection_button.text != "해제" or selection_button.disabled:
		_fail("selected state was not rendered")
		return
	if selection_button.focus_mode != Control.FOCUS_ALL or detail_button.focus_mode != Control.FOCUS_ALL:
		_fail("mouse and keyboard focus is not enabled")
		return
	if card.theme_type_variation != "AgentCardSelected":
		_fail("selected card style was not applied")
		return
	if name_label.autowrap_mode != TextServer.AUTOWRAP_WORD_SMART or description_label.autowrap_mode != TextServer.AUTOWRAP_WORD_SMART:
		_fail("long Korean text wrapping is not enabled")
		return

	var selection_requests: Array[String] = []
	var detail_requests: Array[String] = []
	card.selection_requested.connect(func(agent_id: String) -> void: selection_requests.append(agent_id))
	card.detail_requested.connect(func(agent_id: String) -> void: detail_requests.append(agent_id))
	selection_button.pressed.emit()
	detail_button.pressed.emit()
	if selection_requests != ["agent_test"] or detail_requests != ["agent_test"]:
		_fail("card signals did not preserve the agent id")
		return

	state.selected = false
	state.selection_disabled = true
	card.configure(agent, state)
	if selection_button.text != "선택" or not selection_button.disabled:
		_fail("selection-disabled state was not rendered")
		return
	if card.theme_type_variation != "AgentCard":
		_fail("default card style was not restored")
		return

	if card.configure({"id": ""}, state):
		_fail("empty agent id should be rejected")
		return

	print("agent_selection_card_test: PASS")
	quit(0)


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
