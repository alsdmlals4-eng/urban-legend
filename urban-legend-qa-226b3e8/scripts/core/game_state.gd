# 현재 사건 데이터, 플래그, 조건, 저장 상태를 관리한다.
extends Node

const DEFAULT_EPISODE_PATH := "res://data/episodes/episode_001_afterlife_station.json"
const RED_UMBRELLA_ALLEY_EPISODE_PATH := "res://data/episodes/episode_002_red_umbrella_alley.json"
const DEAD_FREQUENCY_STATION_EPISODE_PATH := "res://data/episodes/episode_003_dead_frequency_station.json"
const SAVE_FILE_PATH := "user://urban_legend_save.json"
const SAVE_VERSION := "mvp-039"
const DEFAULT_DIALOGUE_NODE_ID := "dialogue_intro"
const DEFAULT_FIELD_NODE_ID := "dialogue_intro"
const STABILITY_SCHEMA_VERSION := 2
const DEFAULT_MINIGAME_ID := "minigame_frequency_sync"
const EQUIP_FREQUENCY_FILTER := "equip_frequency_filter"
const SCENE_MAIN_MENU := "res://scenes/main_menu.tscn"
const SCENE_DIALOGUE := "res://scenes/dialogue_scene.tscn"
const SCENE_PREPARATION := "res://scenes/preparation_scene.tscn"
const SCENE_INVESTIGATION := "res://scenes/investigation_scene.tscn"
const SCENE_BATTLE := "res://scenes/battle_scene.tscn"
const SCENE_RESULT := "res://scenes/result_scene.tscn"
const SCENE_MARKET := "res://scenes/market_scene.tscn"
const SCENE_DAILY_EPISODE := "res://scenes/daily_episode_scene.tscn"
const FLAG_CAPTURE_SUCCESS := "capture_success"
const MIN_SELECTED_AGENTS := 1
const MAX_SELECTED_AGENTS := 3
const AGENT_TRUST_MIN := -3
const AGENT_TRUST_MAX := 3
const ALLOWED_AGENT_TEMPERAMENTS := ["analytical", "empathetic", "breakthrough", "balanced"]
const ABILITY_KEYS := ["suppression", "analysis", "protection", "treatment", "rapport"]
const ABILITY_LABELS := {
	"suppression": "제압",
	"analysis": "분석",
	"protection": "방호",
	"treatment": "치료",
	"rapport": "교감"
}
const FACTION_IDS := ["rumor_market", "mage_society", "exorcist_lineage"]
const MARKET_ITEMS: Array[Dictionary] = [
	{"id": "gear_resonance_prism", "name": "잔향 분광경", "category": "permanent", "price": 100, "description": "회수 첫 예측률 +10%"},
	{"id": "gear_inverse_listener", "name": "역위상 청음기", "category": "permanent", "price": 90, "description": "전조와 연결된 확보 단서 하나를 강조"},
	{"id": "gear_sealing_pin", "name": "봉인선 고정핀", "category": "permanent", "price": 80, "description": "사건 최초 오대응 피해 10 감소"},
	{"id": "gear_resonance_buffer", "name": "공명 완충기", "category": "permanent", "price": 110, "description": "교감 자동행동 발동률 +10%"},
	{"id": "consumable_prediction_film", "name": "전조 기록 필름", "category": "consumable", "price": 30, "description": "다음 예측률 +20%"},
	{"id": "consumable_temporary_seal", "name": "임시 봉인지", "category": "consumable", "price": 30, "description": "다음 정답 대응 안정도 +10"},
	{"id": "consumable_mental_incense", "name": "정신 안정 향", "category": "consumable", "price": 25, "description": "대표 요원 정신력 25 회복"},
	{"id": "consumable_first_aid", "name": "응급 지혈부", "category": "consumable", "price": 25, "description": "대표 요원 체력 25 회복"},
	{"id": "consumable_shielding_cloth", "name": "잔향 차폐포", "category": "consumable", "price": 35, "description": "다음 괴이 행동 피해 12 흡수"}
]
const RECOVERY_ACTION_FORMULAS := {
	"suppression": { "base": 4, "multiplier": 2, "description": "제압으로 괴이 안정도를 낮추고 위험을 억제합니다." },
	"analysis": { "base": 3, "multiplier": 2, "description": "분석으로 괴이 패턴을 읽고 안정화 근거를 확보합니다." },
	"protection": { "base": 5, "multiplier": 3, "description": "방호로 팀원을 보호하고 적대적 반응을 막습니다." },
	"treatment": { "base": 6, "multiplier": 4, "description": "치료로 부상당한 요원의 체력을 회복합니다." },
	"rapport": { "base": 6, "multiplier": 4, "description": "교감으로 패닉 상태 요원의 정신력을 회복합니다." }
}
const INVESTIGATION_METHOD_KEYS := ["destruction", "observation", "analysis"]
const AGENT_TRUST_EVENTS: Array[Dictionary] = [
	{
		"id": "agent_event_kang_pattern_note_01",
		"agent_id": "agent_kang_ijun",
		"required_trust": 2,
		"title": "강이준의 패턴 메모",
		"text": "강이준: 반복 간격을 분리해 두었습니다. 다음 예측 판단에서 이 기록을 먼저 대조하세요.",
		"support_text": "강이준의 패턴 메모: 다음 예측 판단에서 참고 가능한 기록이 추가됩니다."
	},
	{
		"id": "agent_event_kwon_victim_trace_01",
		"agent_id": "agent_kwon_narae",
		"required_trust": 2,
		"title": "권나래의 피해자 흔적",
		"text": "권나래: 피해자의 흔적이 아직 남아 있어요. 다음 조사에서는 급하게 결론내리지 말고 반응을 확인하죠.",
		"support_text": "권나래의 피해자 흔적: 다음 조사에서 피해자 관련 기록을 우선 참고할 수 있습니다."
	},
	{
		"id": "agent_event_oh_breakthrough_warning_01",
		"agent_id": "agent_oh_hyun",
		"required_trust": 2,
		"title": "오현의 돌파 경고",
		"text": "오현: 길을 열었으면 바로 빠져나갈 경로도 확보해야 합니다. 다음 회수 판단 때는 제가 앞을 보겠습니다.",
		"support_text": "오현의 돌파 경고: 다음 조사 또는 회수 판단에서 진입 경로를 참고할 수 있습니다."
	}
]
const EpisodeLoaderScript := preload("res://scripts/data/episode_loader.gd")
const CaseDataScript := preload("res://scripts/data/case_data.gd")
const CampaignStateScript := preload("res://scripts/core/campaign_state.gd")
const AgentCatalogScript := preload("res://scripts/data/agent_catalog.gd")
const DailyEpisodeCatalogScript := preload("res://scripts/data/daily_episode_catalog.gd")

var current_episode_path := DEFAULT_EPISODE_PATH
var current_episode_data: Dictionary = {}
var current_scene_path := SCENE_MAIN_MENU
var current_dialogue_node_id := DEFAULT_DIALOGUE_NODE_ID
var current_field_node_id := DEFAULT_FIELD_NODE_ID
var current_minigame_id := DEFAULT_MINIGAME_ID
var minigame_results: Dictionary = {}
var selected_agent_ids: Array = []
var flags: Array = []
var seen_hint_ids: Array = []
var seen_log_tutorial_ids: Array = []
var selected_resolution_grade := ""
var selected_resolution_label := ""
var selected_resolution_rate := 0.0
var recovery_successful := false
var recovery_result_status := ""
var recovery_result_stability := 100
var investigation_risk := 0
var case_understanding := 0
var victim_understanding := 0
var case_anomaly_stability := 0
var mental_stamina := 100
var prediction_success_streak := 0
var prediction_failure_streak := 0
var current_recovery_pattern_id := ""
var last_recovery_pattern_id := ""
var confirmed_recovery_pattern_id := ""
var seen_recovery_pattern_ids: Array = []
var recovery_pattern_learning: Dictionary = {}
var last_random_event_id := ""
var last_random_event_result: Dictionary = {}
var forced_recovery_phase := false
var method_results: Dictionary = {}
var agent_trust_changes: Dictionary = {}
var agent_trust: Dictionary = {}
var triggered_agent_event_ids: Array = []
var used_agent_supports: Array = []
var unlocked_records: Array = []
var unlocked_equipment: Array = []
var unlocked_research_rewards: Array = []
var equipped_items: Array = []
var used_equipment_effects: Array = []
var completed_case_reports: Array = []
var anomaly_manual_records: Dictionary = {}
var completed_daily_episode_records: Array = []
var active_daily_episode: Dictionary = {}
var agent_case_states: Dictionary = {}
var victim_state: Dictionary = {}
var echo_fragments := 30
var granted_reward_ids: Array = []
var faction_relations: Dictionary = {}
var triggered_faction_event_ids: Array = []
var completed_faction_request_ids: Array = []
var purchased_market_item_ids: Array = []
var consumable_inventory: Dictionary = {}
var consumable_loadout: Dictionary = {}
var active_consumable_effects: Dictionary = {}
var rewarded_resolution_grades: Dictionary = {}
var campaign_state = CampaignStateScript.new()
var daily_episode_catalog = DailyEpisodeCatalogScript.new()
var agent_catalog = AgentCatalogScript.new()


func _ready() -> void:
	load_episode(DEFAULT_EPISODE_PATH)


## Loads an episode JSON file as the active case.
func load_episode(file_path: String = DEFAULT_EPISODE_PATH) -> bool:
	var loader = EpisodeLoaderScript.new()
	var loaded_data: Dictionary = loader.load_episode(file_path)
	if loaded_data.is_empty():
		return false

	current_episode_path = file_path
	current_episode_data = CaseDataScript.refresh_resolution_progress(loaded_data)
	_clear_resolution_phase_selection()
	_clear_recovery_result()
	return true


## Returns the active episode Dictionary.
func get_current_episode() -> Dictionary:
	return current_episode_data


## Restarts the afterlife station MVP from the beginning.
func restart_afterlife_station_flow(agent_ids: Array = []) -> bool:
	reset_run_state()
	var tutorial_team := agent_ids if not agent_ids.is_empty() else ["agent_kwon_narae", "agent_oh_hyun", "agent_kang_ijun"]
	set_selected_agent_ids(tutorial_team)
	_ensure_kwon_protagonist()
	current_scene_path = SCENE_DIALOGUE
	return not current_episode_data.is_empty()


## Starts another episode while preserving unlocked preparation rewards and the current team.
func start_episode_from_preparation(file_path: String) -> bool:
	if not load_episode(file_path):
		return false

	flags.clear()
	seen_hint_ids.clear()
	minigame_results.clear()
	used_equipment_effects.clear()
	active_consumable_effects.clear()
	agent_case_states.clear()
	victim_state.clear()
	_clear_investigation_method_state()
	current_dialogue_node_id = DEFAULT_DIALOGUE_NODE_ID
	current_field_node_id = DEFAULT_FIELD_NODE_ID
	reset_recovery_pattern_state(false)
	current_minigame_id = DEFAULT_MINIGAME_ID
	current_scene_path = SCENE_PREPARATION
	return true


## Clears the current run state and reloads the default episode.
func reset_run_state() -> void:
	flags.clear()
	seen_hint_ids.clear()
	seen_log_tutorial_ids.clear()
	minigame_results.clear()
	selected_agent_ids.clear()
	agent_trust.clear()
	triggered_agent_event_ids.clear()
	unlocked_records.clear()
	unlocked_equipment.clear()
	unlocked_research_rewards.clear()
	equipped_items.clear()
	used_equipment_effects.clear()
	completed_case_reports.clear()
	anomaly_manual_records.clear()
	completed_daily_episode_records.clear()
	active_daily_episode.clear()
	agent_case_states.clear()
	victim_state.clear()
	echo_fragments = 30
	granted_reward_ids.clear()
	faction_relations.clear()
	triggered_faction_event_ids.clear()
	completed_faction_request_ids.clear()
	purchased_market_item_ids.clear()
	consumable_inventory.clear()
	consumable_loadout.clear()
	active_consumable_effects.clear()
	rewarded_resolution_grades.clear()
	reset_campaign_state()
	current_scene_path = SCENE_DIALOGUE
	current_dialogue_node_id = DEFAULT_DIALOGUE_NODE_ID
	current_field_node_id = DEFAULT_FIELD_NODE_ID
	current_minigame_id = DEFAULT_MINIGAME_ID
	load_episode(DEFAULT_EPISODE_PATH)
	set_selected_agent_ids(["agent_kwon_narae", "agent_oh_hyun", "agent_kang_ijun"])
	_clear_investigation_method_state()
	reset_recovery_pattern_state(false)


## Returns the active episode title.
func get_current_episode_title() -> String:
	var episode: Dictionary = current_episode_data.get("episode", {})
	return String(episode.get("title", "저승역"))


## Returns the active episode id.
func get_current_episode_id() -> String:
	var episode: Dictionary = current_episode_data.get("episode", {})
	return String(episode.get("id", ""))


## Resets the 10-day demo campaign without changing episode content.
func reset_campaign_state() -> void:
	campaign_state.reset()


## Returns a defensive copy of the 10-day campaign state.
func get_campaign_snapshot() -> Dictionary:
	return campaign_state.get_snapshot()


## Assigns one agent activity to the current day's morning or afternoon slot.
func set_campaign_schedule(agent_id: String, time_slot: String, activity_id: String) -> bool:
	return campaign_state.set_schedule(agent_id, time_slot, activity_id)


## Returns one agent's assignments for the current campaign day.
func get_campaign_agent_schedule(agent_id: String) -> Dictionary:
	return campaign_state.get_agent_schedule(agent_id)


## Returns whether every supplied agent has both daily slots assigned.
func is_campaign_schedule_complete(agent_ids: Array) -> bool:
	return campaign_state.is_schedule_complete(agent_ids)


func get_campaign_slot_phase() -> String:
	return campaign_state.get_slot_phase()


func get_campaign_slot_result() -> Dictionary:
	return campaign_state.get_slot_result()


func set_campaign_planned_case(case_id: String) -> bool:
	return campaign_state.set_planned_case(case_id)


func get_campaign_planned_case() -> String:
	return campaign_state.get_planned_case()


## Marks the current case as the operation that may consume this campaign day.
func begin_campaign_operation(case_id: String) -> bool:
	return campaign_state.begin_operation(case_id)


func suspend_campaign_operation() -> bool:
	return campaign_state.suspend_operation()


func resume_campaign_operation() -> bool:
	return campaign_state.resume_operation()


func get_active_campaign_operation() -> Dictionary:
	return campaign_state.get_active_operation()


## Completes the active operation and advances at most one campaign day.
func finish_campaign_operation_day() -> Dictionary:
	return campaign_state.finish_operation_day()


func complete_campaign_slot(result: Dictionary = {}) -> bool:
	return campaign_state.complete_current_slot(result)


func acknowledge_campaign_slot_result() -> Dictionary:
	return campaign_state.acknowledge_slot_result(campaign_state.has_high_spread())


func get_faction_request_board() -> Array:
	return campaign_state.get_request_board()


func accept_faction_request(instance_id: String) -> bool:
	return campaign_state.accept_request(instance_id)


func decline_faction_request(instance_id: String) -> bool:
	return campaign_state.decline_request(instance_id)


func cancel_faction_request(instance_id: String) -> bool:
	var request := campaign_state.cancel_request(instance_id)
	if request.is_empty():
		return false
	change_faction_relation(String(request.get("faction_id", "")), -1, "request_cancel:%s" % instance_id)
	return true


## Removes a successfully resolved case from future daily-risk rotation.
func resolve_campaign_case(case_id: String, resolution_grade: String) -> bool:
	return campaign_state.resolve_case(case_id, resolution_grade)


## Advances one campaign day and rotates risk across unresolved anomalies.
func advance_campaign_day(high_spread: bool = false) -> Dictionary:
	return campaign_state.advance_day(high_spread)


## Applies campaign-level anomaly risk and discovery/outbreak thresholds.
func apply_campaign_case_risk(case_id: String, delta: int) -> int:
	return campaign_state.apply_case_risk(case_id, delta)


## Grants the optional once-per-day case-understanding bonus.
func grant_daily_case_understanding(case_id: String, reward_type: String, content_id: String = "") -> int:
	return campaign_state.grant_daily_understanding(case_id, reward_type, content_id)


## Returns optional HQ-only daily episodes that are unlocked by a discovered unresolved case.
func get_available_daily_episodes() -> Array:
	if not active_daily_episode.is_empty() or get_campaign_slot_phase() != "planning":
		return []
	var campaign := get_campaign_snapshot()
	if bool(campaign.get("demo_ended", false)):
		return []
	var case_states: Dictionary = campaign.get("cases", {})
	var available: Array = []
	for episode_value in daily_episode_catalog.get_all():
		if typeof(episode_value) != TYPE_DICTIONARY:
			continue
		var episode: Dictionary = episode_value
		var episode_id := String(episode.get("id", ""))
		var case_id := String(episode.get("case_id", ""))
		var case_state: Dictionary = case_states.get(case_id, {})
		if episode_id.is_empty() or _has_completed_daily_episode(episode_id):
			continue
		if String(case_state.get("discovery_state", "unknown")) != "lead":
			continue
		if String(case_state.get("resolution_state", "unresolved")) != "unresolved":
			continue
		available.append(episode)
	return available


func get_daily_episode(episode_id: String) -> Dictionary:
	return daily_episode_catalog.get_by_id(episode_id)


func get_active_daily_episode() -> Dictionary:
	return active_daily_episode.duplicate(true)


func get_active_daily_episode_data() -> Dictionary:
	return get_daily_episode(String(active_daily_episode.get("episode_id", "")))


func get_completed_daily_episode_records() -> Array:
	return completed_daily_episode_records.duplicate(true)


## Starts a daily episode without changing campaign schedule, time, risk, or field assignment.
func begin_daily_episode(episode_id: String) -> Dictionary:
	var clean_id := episode_id.strip_edges()
	if clean_id.is_empty():
		return {"successful": false, "error": "일상 에피소드 ID가 비어 있습니다."}
	for available_value in get_available_daily_episodes():
		if typeof(available_value) == TYPE_DICTIONARY and String((available_value as Dictionary).get("id", "")) == clean_id:
			var campaign := get_campaign_snapshot()
			active_daily_episode = {
				"episode_id": clean_id,
				"day": int(campaign.get("day", 1)),
				"time_slot": String(campaign.get("time_slot", "morning"))
			}
			set_current_scene_path(SCENE_DAILY_EPISODE)
			save_game()
			return {"successful": true, "episode": (available_value as Dictionary).duplicate(true)}
	return {"successful": false, "error": "현재 HQ에서 열 수 없는 일상 에피소드입니다."}


## Records one selected daily episode outcome and returns to HQ without completing a campaign slot.
func resolve_daily_episode_choice(choice_id: String) -> Dictionary:
	if active_daily_episode.is_empty():
		return {"successful": false, "error": "진행 중인 일상 에피소드가 없습니다."}
	var episode := get_active_daily_episode_data()
	if episode.is_empty():
		active_daily_episode.clear()
		set_current_scene_path(SCENE_PREPARATION)
		save_game()
		return {"successful": false, "error": "일상 에피소드 데이터를 찾지 못했습니다."}
	var selected_choice: Dictionary = {}
	for choice_value in episode.get("choices", []):
		if typeof(choice_value) == TYPE_DICTIONARY and String((choice_value as Dictionary).get("id", "")) == choice_id:
			selected_choice = (choice_value as Dictionary).duplicate(true)
			break
	if selected_choice.is_empty():
		return {"successful": false, "error": "선택 결과를 찾지 못했습니다."}
	var episode_id := String(episode.get("id", ""))
	if _has_completed_daily_episode(episode_id):
		active_daily_episode.clear()
		set_current_scene_path(SCENE_PREPARATION)
		save_game()
		return {"successful": false, "error": "이미 기록된 일상 에피소드입니다."}
	var reward := grant_daily_case_understanding(String(episode.get("case_id", "")), "first_view", episode_id)
	var record := {
		"episode_id": episode_id,
		"title": String(episode.get("title", "일상 에피소드")),
		"agent_id": String(episode.get("agent_id", "")),
		"agent_name": String(episode.get("agent_name", "요원")),
		"case_id": String(episode.get("case_id", "")),
		"case_title": String(episode.get("case_title", "관련 사건")),
		"choice_id": String(selected_choice.get("id", "")),
		"choice_label": String(selected_choice.get("label", "선택")),
		"result_text": String(selected_choice.get("result_text", "")),
		"agent_reaction": String(selected_choice.get("agent_reaction", "")),
		"record_summary": String(selected_choice.get("record_summary", "")),
		"understanding_reward": reward,
		"day": int(active_daily_episode.get("day", 1)),
		"time_slot": String(active_daily_episode.get("time_slot", "morning"))
	}
	completed_daily_episode_records.append(record)
	active_daily_episode.clear()
	set_current_scene_path(SCENE_PREPARATION)
	save_game()
	return {"successful": true, "record": record.duplicate(true)}


func _has_completed_daily_episode(episode_id: String) -> bool:
	for value in completed_daily_episode_records:
		if typeof(value) == TYPE_DICTIONARY and String((value as Dictionary).get("episode_id", "")) == episode_id:
			return true
	return false


## Stores the scene path that should be used by Continue.
func set_current_scene_path(scene_path: String) -> void:
	if scene_path.strip_edges().is_empty():
		return

	current_scene_path = scene_path


## Returns the saved or current scene path.
func get_current_scene_path() -> String:
	if current_scene_path.strip_edges().is_empty():
		return SCENE_DIALOGUE
	return current_scene_path


## Stores the current dialogue node for Continue and save data.
func set_current_dialogue_node_id(dialogue_node_id: String) -> void:
	var clean_id := dialogue_node_id.strip_edges()
	if clean_id.is_empty():
		return

	current_dialogue_node_id = clean_id


## Returns the current dialogue node id.
func get_current_dialogue_node_id() -> String:
	if current_dialogue_node_id.strip_edges().is_empty():
		return DEFAULT_DIALOGUE_NODE_ID
	return current_dialogue_node_id


## Stores the continuous field node used by the unified dialogue/investigation scene.
func set_current_field_node_id(field_node_id: String) -> void:
	var clean_id := field_node_id.strip_edges()
	if clean_id.is_empty():
		return
	current_field_node_id = clean_id


## Returns the current continuous field node id.
func get_current_field_node_id() -> String:
	if current_field_node_id.strip_edges().is_empty():
		return DEFAULT_FIELD_NODE_ID
	return current_field_node_id


## Stores the current minigame id for minigame scene loading.
func set_current_minigame_id(minigame_id: String) -> void:
	var clean_id := minigame_id.strip_edges()
	if clean_id.is_empty():
		return

	current_minigame_id = clean_id


## Returns the current minigame id.
func get_current_minigame_id() -> String:
	if current_minigame_id.strip_edges().is_empty():
		return DEFAULT_MINIGAME_ID
	return current_minigame_id


## Adds one run flag if it is not already present.
func add_flag(flag_id: String) -> void:
	var clean_flag := flag_id.strip_edges()
	if clean_flag.is_empty() or flags.has(clean_flag):
		return

	flags.append(clean_flag)


## Removes one run flag.
func remove_flag(flag_id: String) -> void:
	flags.erase(flag_id)


## Returns true when one flag is present.
func has_flag(flag_id: String) -> bool:
	return flags.has(flag_id)


## Returns true when every supplied flag is present.
func has_all_flags(flag_ids: Array) -> bool:
	for flag_id in flag_ids:
		if not has_flag(String(flag_id)):
			return false
	return true


## Returns true when at least one supplied flag is present.
func has_any_flag(flag_ids: Array) -> bool:
	for flag_id in flag_ids:
		if has_flag(String(flag_id)):
			return true
	return false


## Returns a copy of current flags.
func get_flags() -> Array:
	return flags.duplicate()


## Clears every run flag.
func clear_flags() -> void:
	flags.clear()


## Marks one hint as seen for save data.
func mark_hint_seen(hint_id: String) -> void:
	var clean_hint_id := hint_id.strip_edges()
	if clean_hint_id.is_empty() or seen_hint_ids.has(clean_hint_id):
		return

	seen_hint_ids.append(clean_hint_id)
	save_game()


## Returns true when a hint has been seen.
func has_seen_hint(hint_id: String) -> bool:
	return seen_hint_ids.has(hint_id)


## Returns a copy of seen hint ids.
func get_seen_hint_ids() -> Array:
	return seen_hint_ids.duplicate()


## Clears every seen hint id.
func clear_seen_hint_ids() -> void:
	seen_hint_ids.clear()


## Returns true when one Log tutorial has already shown its full sequence.
func has_seen_log_tutorial(tutorial_id: String) -> bool:
	return seen_log_tutorial_ids.has(tutorial_id)


## Atomically claims one first-time Log tutorial.
func claim_log_tutorial(tutorial_id: String, save_after: bool = true) -> bool:
	var clean_id := tutorial_id.strip_edges()
	if clean_id.is_empty() or has_seen_log_tutorial(clean_id):
		return false
	seen_log_tutorial_ids.append(clean_id)
	if save_after:
		save_game()
	return true


## Returns a copy of claimed Log tutorial ids.
func get_seen_log_tutorial_ids() -> Array:
	return seen_log_tutorial_ids.duplicate()


## Checks simple flag, clue, resolution, and capture conditions.
func check_conditions(conditions: Dictionary) -> bool:
	if conditions.is_empty():
		return true

	if not has_all_flags(_to_string_array(conditions.get("required_flags", []))):
		return false

	if has_any_flag(_to_string_array(conditions.get("blocked_flags", []))):
		return false

	for clue_id in _to_string_array(conditions.get("required_clues", [])):
		if not has_collected_clue(clue_id):
			return false

	if conditions.has("min_clue_collection_rate"):
		if get_clue_collection_rate() < float(conditions.get("min_clue_collection_rate", 0.0)):
			return false

	if conditions.has("min_anomaly_risk"):
		if get_anomaly_risk() < int(conditions.get("min_anomaly_risk", 0)):
			return false

	if conditions.has("min_anomaly_understanding"):
		if get_anomaly_understanding() < int(conditions.get("min_anomaly_understanding", 0)):
			return false

	if conditions.has("min_mental_stamina"):
		if get_mental_stamina() < int(conditions.get("min_mental_stamina", 0)):
			return false

	if conditions.has("forced_recovery_phase"):
		if forced_recovery_phase != bool(conditions.get("forced_recovery_phase", false)):
			return false

	if conditions.has("required_resolution_grade"):
		var required_grade := String(conditions.get("required_resolution_grade", ""))
		if _get_resolution_rank(get_result_resolution_grade()) < _get_resolution_rank(required_grade):
			return false

	if conditions.has("capture_success"):
		if recovery_successful != bool(conditions.get("capture_success", false)):
			return false

	return true


## Applies branch result data from dialogue choices or investigation points.
func apply_story_effects(result_data: Dictionary) -> void:
	_apply_status_deltas(result_data)

	for flag_id in _to_string_array(result_data.get("add_flags", [])):
		add_flag(flag_id)

	for flag_id in _to_string_array(result_data.get("remove_flags", [])):
		remove_flag(flag_id)

	var clue_ids := _to_string_array(result_data.get("collect_clues", []))
	var direct_clue_id := String(result_data.get("clue_id", "")).strip_edges()
	if not direct_clue_id.is_empty() and not clue_ids.has(direct_clue_id):
		clue_ids.append(direct_clue_id)

	for clue_id in clue_ids:
		var was_collected := has_collected_clue(clue_id)
		_set_clue_collected_without_save(clue_id, true)
		if not was_collected and has_collected_clue(clue_id):
			grant_echo_reward("clue:%s:%s" % [get_current_episode_id(), clue_id], 5)

	for hint_id in _to_string_array(result_data.get("show_hint_ids", [])):
		mark_hint_seen(hint_id)

	var minigame_id := String(result_data.get("start_minigame_id", result_data.get("minigame_id", ""))).strip_edges()
	if not minigame_id.is_empty():
		set_current_minigame_id(minigame_id)

	save_game()


## Applies a minigame success or failure result and stores it for save/load.
func save_minigame_result(minigame_id: String, successful: bool, details: Dictionary = {}) -> void:
	var minigame := get_minigame(minigame_id)
	if minigame.is_empty():
		return

	var result_state := "success" if successful else "failure"
	var result_text_key := "success_result_text" if successful else "failure_result_text"
	var result_text := String(minigame.get(result_text_key, ""))
	var opposite_flags: Variant = minigame.get("failure_flags", []) if successful else minigame.get("success_flags", [])
	for flag_id in _to_string_array(opposite_flags):
		remove_flag(flag_id)

	var result := {
		"successful": successful,
		"result_state": result_state,
		"result_text": result_text,
		"last_updated_at": Time.get_datetime_string_from_system(false, true)
	}
	for key in details:
		result[key] = details[key]
	minigame_results[minigame_id] = result

	apply_story_effects(_make_minigame_effect_data(minigame, successful))
	save_game()


## Tries to consume the frequency filter for one minigame hint.
func try_use_frequency_filter_hint(minigame_id: String) -> Dictionary:
	if not has_equipped_item(EQUIP_FREQUENCY_FILTER):
		return {}

	var effect_key := "%s:%s" % [EQUIP_FREQUENCY_FILTER, minigame_id]
	if has_used_equipment_effect(effect_key):
		return {}

	mark_equipment_effect_used(effect_key)
	var item := get_equipment_by_id(EQUIP_FREQUENCY_FILTER)
	return {
		"equipment_id": EQUIP_FREQUENCY_FILTER,
		"equipment_name": String(item.get("name", "폐주파수 필터")),
		"effect_text": String(item.get("effect_text", "폐주파수 필터가 잡음을 분리합니다. 다음 타이밍은 세 번째 파형이 가장 안정적입니다."))
	}


## Returns true when a minigame was completed successfully.
func has_minigame_success(minigame_id: String) -> bool:
	var result: Dictionary = minigame_results.get(minigame_id, {})
	return bool(result.get("successful", false))


## Returns true when a minigame was completed with failure.
func has_minigame_failure(minigame_id: String) -> bool:
	var result: Dictionary = minigame_results.get(minigame_id, {})
	return not result.is_empty() and not bool(result.get("successful", false))


## Returns the saved result for one minigame.
func get_minigame_result(minigame_id: String) -> Dictionary:
	var result: Variant = minigame_results.get(minigame_id, {})
	if typeof(result) == TYPE_DICTIONARY:
		return result
	return {}


## Returns all saved minigame results.
func get_minigame_results() -> Dictionary:
	return minigame_results.duplicate(true)


## Returns display text for hint ids stored in branch result data.
func get_hint_texts_by_ids(hint_ids: Array) -> Array:
	var texts: Array = []
	for hint_id in _to_string_array(hint_ids):
		var hint := get_hint_by_id(hint_id)
		if hint.is_empty():
			continue

		texts.append("%s: %s" % [
			String(hint.get("target_clue_id", "")),
			String(hint.get("text", ""))
		])
	return texts


## Marks one clue as collected and updates the resolution state.
func collect_clue(clue_id: String) -> bool:
	if current_episode_data.is_empty():
		return false

	var before_count := CaseDataScript.get_collected_clue_count(current_episode_data)
	_set_clue_collected_without_save(clue_id, true)
	var collected_now := CaseDataScript.get_collected_clue_count(current_episode_data) > before_count
	if collected_now:
		save_game()
	return collected_now


## Sets one clue collected state for tests and simple UI prototypes.
func set_clue_collected(clue_id: String, collected: bool) -> bool:
	if current_episode_data.is_empty():
		return false

	_set_clue_collected_without_save(clue_id, collected)
	save_game()
	return true


## Resets all clue collection states in the active episode.
func reset_clue_collection() -> void:
	if current_episode_data.is_empty():
		return

	current_episode_data = CaseDataScript.reset_clue_collection(current_episode_data)
	_clear_resolution_phase_selection()
	_clear_recovery_result()
	save_game()


## Returns active victim records.
func get_victims() -> Array:
	return CaseDataScript.get_victims(current_episode_data)


## Returns recruitable agent records.
func get_agents() -> Array:
	return agent_catalog.merge_agents(CaseDataScript.get_agents(current_episode_data))


## Returns one recruitable agent by id.
func get_agent_by_id(agent_id: String) -> Dictionary:
	return agent_catalog.get_agent(CaseDataScript.get_agents(current_episode_data), agent_id)


## Returns the player's base investigation stats.
func get_player_investigation_stats() -> Dictionary:
	var stats: Variant = current_episode_data.get("player_investigation_stats", {})
	if typeof(stats) == TYPE_DICTIONARY:
		return stats.duplicate(true)
	return {
		"destruction": 2,
		"observation": 2,
		"analysis": 2
	}


## Returns one agent's investigation stat value.
func get_agent_investigation_stat(agent_id: String, stat_key: String) -> int:
	var agent := get_agent_by_id(agent_id)
	if agent.is_empty():
		return 0

	var stats := _to_dictionary(agent.get("investigation_stats", {}))
	return int(stats.get(stat_key, 0))


## Selects one agent for the current mission formation.
func select_agent(agent_id: String) -> bool:
	var clean_agent_id := agent_id.strip_edges()
	if clean_agent_id.is_empty():
		return false
	if selected_agent_ids.has(clean_agent_id):
		return true
	if selected_agent_ids.size() >= MAX_SELECTED_AGENTS:
		return false

	var agent := get_agent_by_id(clean_agent_id)
	if agent.is_empty() or not _is_allowed_agent_temperament(agent):
		return false

	selected_agent_ids.append(clean_agent_id)
	if not agent_trust.has(clean_agent_id):
		agent_trust[clean_agent_id] = 0
	_ensure_agent_case_state(clean_agent_id)
	return true


## Removes one agent from the current mission formation.
func deselect_agent(agent_id: String) -> void:
	if agent_id == "agent_kwon_narae":
		return
	selected_agent_ids.erase(agent_id)


## Replaces the current formation with valid agent ids.
func set_selected_agent_ids(agent_ids: Array) -> void:
	selected_agent_ids.clear()
	var ordered: Array[String] = ["agent_kwon_narae"]
	for agent_id in _to_string_array(agent_ids):
		if agent_id != "agent_kwon_narae" and not ordered.has(agent_id):
			ordered.append(agent_id)
	for agent_id in ordered:
		if selected_agent_ids.size() >= MAX_SELECTED_AGENTS:
			break
		select_agent(agent_id)


## Clears the current mission formation.
func clear_selected_agents() -> void:
	selected_agent_ids.clear()


## Returns true when the agent is currently selected.
func is_agent_selected(agent_id: String) -> bool:
	return selected_agent_ids.has(agent_id)


## Returns selected agent ids for save data.
func get_selected_agent_ids() -> Array:
	return selected_agent_ids.duplicate()


## Interprets the first valid selected id as the protagonist without adding a save field.
func get_protagonist_agent_id() -> String:
	for agent_id in selected_agent_ids:
		var clean_id := String(agent_id)
		if not get_agent_by_id(clean_id).is_empty():
			return clean_id
	return ""


## Moves one valid selected agent to the first position while preserving the saved array format.
func set_protagonist_agent_id(agent_id: String) -> bool:
	var clean_id := agent_id.strip_edges()
	if clean_id != "agent_kwon_narae":
		return false
	if get_agent_by_id(clean_id).is_empty():
		return false
	if not selected_agent_ids.has(clean_id) and not select_agent(clean_id):
		return false
	selected_agent_ids.erase(clean_id)
	selected_agent_ids.push_front(clean_id)
	return true


func _ensure_kwon_protagonist() -> void:
	const KWON_ID := "agent_kwon_narae"
	var reordered: Array = [KWON_ID]
	for value in selected_agent_ids:
		var agent_id := String(value)
		if agent_id == KWON_ID or reordered.has(agent_id) or get_agent_by_id(agent_id).is_empty():
			continue
		reordered.append(agent_id)
		if reordered.size() >= MAX_SELECTED_AGENTS:
			break
	set_selected_agent_ids(reordered)


## Returns up to two selected agents after the protagonist.
func get_support_agent_ids() -> Array:
	var result: Array = []
	var protagonist_id := get_protagonist_agent_id()
	for agent_id in selected_agent_ids:
		var clean_id := String(agent_id)
		if clean_id != protagonist_id and not get_agent_by_id(clean_id).is_empty():
			result.append(clean_id)
			if result.size() >= 2:
				break
	return result


## Rebuilds the formation as protagonist followed by zero to two supports.
func set_support_agent_ids(agent_ids: Array) -> bool:
	var protagonist_id := get_protagonist_agent_id()
	if protagonist_id.is_empty():
		return false
	var reordered: Array = [protagonist_id]
	for agent_id in _to_string_array(agent_ids):
		if agent_id == protagonist_id or reordered.has(agent_id) or get_agent_by_id(agent_id).is_empty():
			continue
		reordered.append(agent_id)
		if reordered.size() >= MAX_SELECTED_AGENTS:
			break
	set_selected_agent_ids(reordered)
	return true


## Returns the fixed MVP-043 support behavior for one agent id.
func get_agent_support_role(agent_id: String) -> String:
	return {
		"agent_kwon_narae": "field_reconstruction",
		"agent_yoon_seoha": "forced_reaction",
		"agent_oh_hyun": "official_comparison",
		"agent_kang_ijun": "safety_line",
		"agent_han_yuri": "memory_echo"
	}.get(agent_id, "")


## Returns selected agent records only.
func get_selected_agents() -> Array:
	var selected_agents: Array = []
	for agent_id in selected_agent_ids:
		var agent := get_agent_by_id(String(agent_id))
		if not agent.is_empty():
			selected_agents.append(agent)
	return selected_agents


## Returns true when the current formation can start a mission.
func can_start_mission_with_agents() -> bool:
	return selected_agent_ids.size() >= MIN_SELECTED_AGENTS and selected_agent_ids.size() <= MAX_SELECTED_AGENTS


## Returns a short Korean status text for the current formation.
func get_agent_selection_status_text() -> String:
	var count := selected_agent_ids.size()
	if count < MIN_SELECTED_AGENTS:
		return "요원 %d명을 더 선택해야 임무를 시작할 수 있습니다." % (MIN_SELECTED_AGENTS - count)
	if count > MAX_SELECTED_AGENTS:
		return "요원은 최대 %d명까지만 편성할 수 있습니다." % MAX_SELECTED_AGENTS
	return "임무 시작 가능: 요원 %d명 편성됨" % count


## Returns readable selected agent names and temperaments.
func get_selected_agent_summary() -> String:
	var names: Array = []
	for agent in get_selected_agents():
		names.append("%s(%s)" % [
			String(agent.get("name", "")),
			String(agent.get("temperament_label", ""))
		])
	if names.is_empty():
		return "선택 요원 없음"
	return ", ".join(names)


## Returns selected agents' dialogue reactions whose conditions are met.
func get_selected_agent_reactions() -> Array:
	var visible_reactions: Array = []
	for reaction in CaseDataScript.get_agent_reactions(current_episode_data):
		if typeof(reaction) != TYPE_DICTIONARY:
			continue

		var agent_id := String(reaction.get("agent_id", ""))
		if not selected_agent_ids.has(agent_id):
			continue

		var conditions := _to_dictionary(reaction.get("conditions", {}))
		if not check_conditions(conditions):
			continue

		var agent := get_agent_by_id(agent_id)
		if agent.is_empty():
			continue

		var entry: Dictionary = reaction.duplicate(true)
		entry["agent_name"] = String(agent.get("name", agent_id))
		entry["temperament_label"] = String(agent.get("temperament_label", ""))
		visible_reactions.append(entry)
	return visible_reactions


## Returns recovery support records for selected agents only.
func get_selected_recovery_supports() -> Array:
	var supports: Array = []
	for agent in get_selected_agents():
		var support := _to_dictionary(agent.get("recovery_support", {}))
		if support.is_empty():
			continue

		var support_id := String(support.get("id", "support_%s" % String(agent.get("id", "")))).strip_edges()
		if support_id.is_empty():
			continue

		var entry := support.duplicate(true)
		entry["id"] = support_id
		entry["agent_id"] = String(agent.get("id", ""))
		entry["agent_name"] = String(agent.get("name", ""))
		entry["temperament"] = String(agent.get("temperament", ""))
		entry["temperament_label"] = String(agent.get("temperament_label", ""))
		supports.append(entry)
	return supports


## Returns true when an agent recovery support has already been used.
func has_used_agent_support(support_id: String) -> bool:
	return used_agent_supports.has(support_id)


## Marks an agent recovery support as used once.
func mark_agent_support_used(support_id: String) -> void:
	var clean_support_id := support_id.strip_edges()
	if clean_support_id.is_empty() or used_agent_supports.has(clean_support_id):
		return

	used_agent_supports.append(clean_support_id)
	save_game()


## Returns used recovery support ids for save data.
func get_used_agent_supports() -> Array:
	return used_agent_supports.duplicate()


func _migrate_mvp043_support_aliases() -> void:
	var aliases: Array[String] = []
	for value in used_agent_supports:
		var support_id := String(value)
		if support_id.begins_with("mvp043_analysis:"):
			aliases.append(support_id.replace("mvp043_analysis:", "mvp043_official_comparison:"))
		elif support_id.begins_with("mvp043_observation:"):
			aliases.append(support_id.replace("mvp043_observation:", "mvp043_field_reconstruction:"))
		elif support_id.begins_with("mvp043_protection:"):
			aliases.append(support_id.replace("mvp043_protection:", "mvp043_safety_line:"))
	for alias in aliases:
		if not used_agent_supports.has(alias):
			used_agent_supports.append(alias)


## Returns the current investigation partner trust delta for one agent.
func get_agent_trust_delta(agent_id: String) -> int:
	return get_agent_trust(agent_id)


## Returns all investigation partner trust deltas.
func get_agent_trust_changes() -> Dictionary:
	return get_agent_trust_values()


## Returns one selected agent's bounded investigation-partner trust.
func get_agent_trust(agent_id: String) -> int:
	return clampi(int(agent_trust.get(agent_id, 0)), AGENT_TRUST_MIN, AGENT_TRUST_MAX)


## Returns the current investigation-partner trust state for saving and UI display.
func get_agent_trust_values() -> Dictionary:
	return agent_trust.duplicate(true)


## Returns one-time trust events that have already been shown.
func get_triggered_agent_event_ids() -> Array:
	return triggered_agent_event_ids.duplicate()


## Returns small follow-up investigation notices unlocked by trust events.
func get_agent_trust_support_texts() -> Array:
	var lines: Array = []
	for event in AGENT_TRUST_EVENTS:
		var event_id := String(event.get("id", ""))
		var agent_id := String(event.get("agent_id", ""))
		if selected_agent_ids.has(agent_id) and triggered_agent_event_ids.has(event_id):
			lines.append(String(event.get("support_text", "")))
	return lines


## Returns an agent's ability value (1..5) from episode data.
func get_agent_ability(agent_id: String, ability_key: String) -> int:
	var agent := get_agent_by_id(agent_id)
	if agent.is_empty():
		return 0
	var abilities := _to_dictionary(agent.get("abilities", {}))
	return clampi(int(abilities.get(ability_key, 0)), 0, 5)


## Returns an agent's max HP from profile data.
func get_agent_max_hp(agent_id: String) -> int:
	var agent := get_agent_by_id(agent_id)
	if agent.is_empty():
		return 100
	return clampi(int(agent.get("max_health", agent.get("hp_max", 100))), 1, 200)


## Returns an agent's max mental from profile data.
func get_agent_max_mental(agent_id: String) -> int:
	var agent := get_agent_by_id(agent_id)
	if agent.is_empty():
		return 100
	return clampi(int(agent.get("max_mental", agent.get("mental_max", 100))), 1, 200)


## Returns an agent's current HP for the active case (defaults to max).
func get_agent_current_hp(agent_id: String) -> int:
	var state := get_agent_case_state(agent_id)
	var current := int(state.get("hp", get_agent_max_hp(agent_id)))
	return clampi(current, 0, get_agent_max_hp(agent_id))


## Returns an agent's current mental for the active case (defaults to max).
func get_agent_current_mental(agent_id: String) -> int:
	var state := get_agent_case_state(agent_id)
	var current := int(state.get("mental", get_agent_max_mental(agent_id)))
	return clampi(current, 0, get_agent_max_mental(agent_id))


## Changes one agent's HP by delta, clamped to [0, max_hp].
func change_agent_hp(agent_id: String, delta: int) -> void:
	var state := _ensure_agent_case_state(agent_id)
	var current := int(state.get("hp", get_agent_max_hp(agent_id)))
	state["hp"] = clampi(current + delta, 0, get_agent_max_hp(agent_id))
	agent_case_states[agent_id] = state


## Changes one agent's mental by delta, clamped to [0, max_mental].
func change_agent_mental(agent_id: String, delta: int) -> void:
	var state := _ensure_agent_case_state(agent_id)
	var current := int(state.get("mental", get_agent_max_mental(agent_id)))
	state["mental"] = clampi(current + delta, 0, get_agent_max_mental(agent_id))
	agent_case_states[agent_id] = state


## Returns true when the agent is neither incapacitated (HP 0) nor panicked (mental 0).
func is_agent_active(agent_id: String) -> bool:
	return get_agent_current_hp(agent_id) > 0 and get_agent_current_mental(agent_id) > 0


## Returns true when all selected agents are inactive.
func are_all_agents_inactive() -> bool:
	for agent_id in selected_agent_ids:
		if is_agent_active(String(agent_id)):
			return false
	return not selected_agent_ids.is_empty()


## Activates single-use protection on one agent.
func activate_protection(agent_id: String, amount: int = 1) -> void:
	var state := _ensure_agent_case_state(agent_id)
	state["protection_amount"] = maxi(0, amount)
	agent_case_states[agent_id] = state


## Returns true when the agent currently has active protection.
func has_protection(agent_id: String) -> bool:
	var state := get_agent_case_state(agent_id)
	return int(state.get("protection_amount", 1 if bool(state.get("protection_active", false)) else 0)) > 0


## Consumes shield points and returns the unabsorbed incoming damage.
func consume_protection(agent_id: String, amount: int) -> int:
	var state := _ensure_agent_case_state(agent_id)
	var shield := int(state.get("protection_amount", 1 if bool(state.get("protection_active", false)) else 0))
	var remaining := maxi(0, amount - shield)
	state["protection_amount"] = maxi(0, shield - amount)
	state.erase("protection_active")
	agent_case_states[agent_id] = state
	return remaining


## Finds the best active selected agent for a given ability key.
func find_best_agent_for_ability(ability_key: String) -> Dictionary:
	var best_agent: Dictionary = {}
	var best_value := -1
	for agent_id in selected_agent_ids:
		var sid := String(agent_id)
		if not is_agent_active(sid):
			continue
		var value := get_agent_ability(sid, ability_key)
		if value > best_value:
			best_value = value
			best_agent = get_agent_by_id(sid)
	return best_agent


## Returns aspect modifier info for an agent using a given ability in a context.
func get_aspect_modifier(agent_id: String, ability_key: String, tags: Array) -> Dictionary:
	var agent := get_agent_by_id(agent_id)
	if agent.is_empty():
		return { "value": 0, "reason": "", "aspect_name": "" }

	var aspects: Array = agent.get("aspects", [])
	var clean_tags := _to_string_array(tags)
	for aspect in aspects:
		if typeof(aspect) != TYPE_DICTIONARY:
			continue
		var bonus_ability := String(aspect.get("bonus_ability", ""))
		if bonus_ability != ability_key:
			continue
		for conflict_tag in _to_string_array(aspect.get("conflict_tags", [])):
			if clean_tags.has(conflict_tag):
				return {
					"value": -1,
					"reason": String(aspect.get("description", "")),
					"aspect_name": String(aspect.get("name", ""))
				}
		var match_tags: Array = aspect.get("match_tags", [])
		for tag in _to_string_array(match_tags):
			if clean_tags.has(tag):
				return {
					"value": 2,
					"reason": String(aspect.get("description", "")),
					"aspect_name": String(aspect.get("name", ""))
				}
	return { "value": 0, "reason": "", "aspect_name": "" }


## Resolves one recovery action for a given ability and agent.
func resolve_recovery_action(ability_key: String, agent_id: String) -> Dictionary:
	if not ABILITY_KEYS.has(ability_key):
		return { "error": "지원하지 않는 회수 행동입니다: %s" % ability_key }

	var formula: Dictionary = RECOVERY_ACTION_FORMULAS.get(ability_key, {})
	var ability_value := get_agent_ability(agent_id, ability_key)
	var base := int(formula.get("base", 0))
	var mult := int(formula.get("multiplier", 0))
	var agent := get_agent_by_id(agent_id)
	var equipment_bonus := _get_agent_loadout_bonus(agent, "equipment", ability_key)
	var skill_bonus := _get_agent_loadout_bonus(agent, "skills", ability_key)
	var effect_value := base + ability_value * mult + equipment_bonus + skill_bonus

	var label := String(ABILITY_LABELS.get(ability_key, ability_key))
	return {
		"ability_key": ability_key,
		"ability_label": label,
		"agent_id": agent_id,
		"agent_name": String(agent.get("name", "")),
		"ability_value": ability_value,
		"effect_value": effect_value,
		"equipment_bonus": equipment_bonus,
		"skill_bonus": skill_bonus,
		"formula": "%d + %d × %d + 장비 %d + 기술 %d" % [base, ability_value, mult, equipment_bonus, skill_bonus],
		"description": String(formula.get("description", ""))
	}


func _get_agent_loadout_bonus(agent: Dictionary, field: String, ability_key: String) -> int:
	var total := 0
	for entry in agent.get(field, []):
		if typeof(entry) == TYPE_DICTIONARY and String(entry.get("ability", "")) == ability_key:
			total += int(entry.get("bonus", 0))
	return total


## Returns the saved case state for one agent.
func get_agent_case_state(agent_id: String) -> Dictionary:
	var state: Variant = agent_case_states.get(agent_id, {})
	if typeof(state) == TYPE_DICTIONARY:
		return state.duplicate(true)
	return {}


## Clears all per-case agent state (HP, mental, protection).
func clear_agent_case_states() -> void:
	agent_case_states.clear()
	victim_state.clear()


## Initializes an agent's case state to profile defaults.
func _ensure_agent_case_state(agent_id: String) -> Dictionary:
	var state: Variant = agent_case_states.get(agent_id, {})
	if typeof(state) != TYPE_DICTIONARY or state.is_empty():
		state = {
			"hp": get_agent_max_hp(agent_id),
			"mental": get_agent_max_mental(agent_id),
			"protection_amount": 0
		}
		agent_case_states[agent_id] = state
	return state


## Collects only the current case records needed by the result-screen case report.
func get_case_report_summary() -> Dictionary:
	var selected_agents: Array = []
	var trust_values: Dictionary = {}
	for agent in get_selected_agents():
		var agent_entry: Dictionary = agent.duplicate(true)
		var agent_id := String(agent_entry.get("id", ""))
		var trust_value := get_agent_trust(agent_id)
		agent_entry["trust"] = trust_value
		selected_agents.append(agent_entry)
		trust_values[agent_id] = trust_value

	var recovery_result := get_current_recovery_result().duplicate(true)
	recovery_result["successful"] = is_recovery_successful()
	recovery_result["result_status"] = get_recovery_result_status()
	recovery_result["anomaly_stability"] = get_recovery_result_stability()

	var record_entries := get_current_result_unlocked_records()
	var reward_entries := get_current_result_unlocked_research_rewards()
	var equipment_entries := get_current_result_unlocked_equipment()
	return {
		"episode_id": get_current_episode_id(),
		"episode_title": get_current_episode_title(),
		"resolution_label": get_result_resolution_label(),
		"clue_collection_rate": get_clue_collection_rate(),
		"collected_clues": get_collected_clues(),
		"seen_hint_count": get_seen_hint_ids().size(),
		"minigame_results": get_minigame_results(),
		"recovery_result": recovery_result,
		"anomaly_manual_record": get_current_anomaly_manual_record(),
		"unlocked_records": record_entries,
		"unlocked_research_rewards": reward_entries,
		"unlocked_equipment": equipment_entries,
		"selected_agents": selected_agents,
		"agent_trust": trust_values,
		"triggered_agent_events": _get_triggered_agent_event_entries(),
		"agent_support_texts": get_agent_trust_support_texts(),
		"next_case_notes": _get_case_report_next_notes(record_entries, equipment_entries, selected_agents)
	}


## Saves the current successful recovery as one completed-case report per episode.
func record_current_case_report() -> bool:
	if not is_recovery_successful():
		return false

	var report := get_case_report_summary()
	var episode_id := String(report.get("episode_id", ""))
	if episode_id.is_empty():
		return false

	var existing_index := -1
	for index in range(completed_case_reports.size()):
		var existing: Variant = completed_case_reports[index]
		if typeof(existing) == TYPE_DICTIONARY and String(existing.get("episode_id", "")) == episode_id:
			existing_index = index
			report["completed_at_label"] = String(existing.get("completed_at_label", ""))
			break

	if String(report.get("completed_at_label", "")).is_empty():
		report["completed_at_label"] = Time.get_datetime_string_from_system(false, true)
	if existing_index >= 0:
		completed_case_reports[existing_index] = report
	else:
		completed_case_reports.append(report)
	resolve_campaign_case(episode_id, selected_resolution_grade)
	save_game()
	return true


## Returns saved completed-case report snapshots for the database screen.
func get_completed_case_reports() -> Array:
	return completed_case_reports.duplicate(true)


## Returns all persistent player-authored anomaly manual records keyed by episode id.
func get_anomaly_manual_records() -> Dictionary:
	return anomaly_manual_records.duplicate(true)


## Returns one persistent player-authored anomaly manual record.
func get_anomaly_manual_record(episode_id: String = "") -> Dictionary:
	var target_id := episode_id.strip_edges()
	if target_id.is_empty():
		target_id = get_current_episode_id()
	var value: Variant = anomaly_manual_records.get(target_id, {})
	return value.duplicate(true) if typeof(value) == TYPE_DICTIONARY else {}


## Returns the current episode's player-authored manual record.
func get_current_anomaly_manual_record() -> Dictionary:
	return get_anomaly_manual_record(get_current_episode_id())


func _ensure_anomaly_manual_record(episode_id: String, episode_title: String) -> Dictionary:
	var value: Variant = anomaly_manual_records.get(episode_id, {})
	var record: Dictionary = value.duplicate(true) if typeof(value) == TYPE_DICTIONARY else {}
	record["episode_id"] = episode_id
	record["episode_title"] = episode_title
	record["verified_rules"] = _to_dictionary(record.get("verified_rules", {}))
	record["candidate_rules"] = _to_dictionary(record.get("candidate_rules", {}))
	record["danger_cases"] = _to_dictionary_array(record.get("danger_cases", []))
	return record


func _record_anomaly_manual_decision(pattern_id: String, response_id: String, correct: bool, reason: String, context: Dictionary) -> void:
	if context.is_empty() or not bool(context.get("guided", false)):
		return
	var episode_id := String(context.get("episode_id", get_current_episode_id())).strip_edges()
	if episode_id.is_empty():
		return
	var episode_title := String(context.get("episode_title", get_current_episode_title()))
	var manual := _ensure_anomaly_manual_record(episode_id, episode_title)
	var verified_rules: Dictionary = manual.get("verified_rules", {})
	var candidate_rules: Dictionary = manual.get("candidate_rules", {})
	var danger_cases: Array = manual.get("danger_cases", [])
	var now_label := Time.get_datetime_string_from_system(false, true)
	var entry := {
		"pattern_id": pattern_id,
		"pattern_name": String(context.get("pattern_name", pattern_id)),
		"question": String(context.get("question", "")),
		"manual_draft": String(context.get("manual_draft", "")),
		"response_id": response_id,
		"response_label": String(context.get("response_label", response_id)),
		"selected_hypothesis_response_id": String(context.get("selected_hypothesis_response_id", "")),
		"hypothesis": String(context.get("hypothesis", "")),
		"authored_supporting_clue_ids": _to_unique_string_array(context.get("authored_supporting_clue_ids", [])),
		"authored_supporting_clue_titles": _to_unique_string_array(context.get("authored_supporting_clue_titles", [])),
		"selected_evidence_ids": _to_unique_string_array(context.get("selected_evidence_ids", [])),
		"selected_evidence_titles": _to_unique_string_array(context.get("selected_evidence_titles", [])),
		"selected_contradicted_clue_ids": _to_unique_string_array(context.get("selected_contradicted_clue_ids", [])),
		"reasoning": String(context.get("reasoning", "")),
		"response_reasoning": String(context.get("response_reasoning", context.get("reasoning", ""))),
		"verification_label": String(context.get("verification_label", "미검증")),
		"correct": correct,
		"verified": bool(context.get("verified", false)),
		"reason": reason,
		"updated_at_label": now_label
	}
	if correct and bool(entry.get("verified", false)):
		var previous_verified := _to_dictionary(verified_rules.get(pattern_id, {}))
		entry["attempts"] = int(previous_verified.get("attempts", 0)) + 1
		entry["record_status"] = "verified"
		verified_rules[pattern_id] = entry
		candidate_rules.erase(pattern_id)
	elif correct:
		# 이미 공식 규칙으로 승격된 패턴은 이후의 근거 부족 재시도로 강등하지 않는다.
		# 공식 지식은 유지하고, 후보는 공식 규칙이 없을 때만 최신 시도를 보관한다.
		if not verified_rules.has(pattern_id):
			var previous_candidate := _to_dictionary(candidate_rules.get(pattern_id, {}))
			entry["attempts"] = int(previous_candidate.get("attempts", 0)) + 1
			entry["record_status"] = "candidate"
			candidate_rules[pattern_id] = entry
	else:
		var danger_id := "%s:%s:%s" % [pattern_id, response_id, String(entry.get("selected_hypothesis_response_id", ""))]
		entry["danger_case_id"] = danger_id
		entry["record_status"] = "danger_case"
		var existing_index := -1
		for index in range(danger_cases.size()):
			var existing: Variant = danger_cases[index]
			if typeof(existing) == TYPE_DICTIONARY and String(existing.get("danger_case_id", "")) == danger_id:
				existing_index = index
				entry["attempts"] = int(existing.get("attempts", 0)) + 1
				entry["first_recorded_at_label"] = String(existing.get("first_recorded_at_label", now_label))
				break
		if existing_index < 0:
			entry["attempts"] = 1
			entry["first_recorded_at_label"] = now_label
			danger_cases.append(entry)
		else:
			danger_cases[existing_index] = entry
	manual["verified_rules"] = verified_rules
	manual["candidate_rules"] = candidate_rules
	manual["danger_cases"] = danger_cases
	manual["updated_at_label"] = now_label
	anomaly_manual_records[episode_id] = manual


## Returns a read-only summary of the save payload that Continue should preserve.
func get_save_state_summary() -> Dictionary:
	return {
		"save_version": SAVE_VERSION,
		"save_path": SAVE_FILE_PATH,
		"current_scene_path": get_current_scene_path(),
		"completed_report_count": completed_case_reports.size(),
		"anomaly_manual_count": anomaly_manual_records.size(),
		"completed_daily_episode_count": completed_daily_episode_records.size(),
		"agent_trust_count": agent_trust.size(),
		"unlocked_record_count": unlocked_records.size(),
		"unlocked_equipment_count": unlocked_equipment.size(),
		"equipped_item_count": equipped_items.size(),
		"echo_fragments": echo_fragments,
		"completed_faction_request_count": completed_faction_request_ids.size(),
		"recovery_saved": recovery_successful,
		"recovery_status": recovery_result_status
	}


## Returns active hint records. Hints are separate from clues.
func get_hints() -> Array:
	return CaseDataScript.get_hints(current_episode_data)


## Returns one hint by id.
func get_hint_by_id(hint_id: String) -> Dictionary:
	return CaseDataScript.get_hint_by_id(current_episode_data, hint_id)


## Returns hints whose condition flags are currently satisfied.
func get_available_hints() -> Array:
	var available_hints: Array = []
	for hint in get_hints():
		if typeof(hint) != TYPE_DICTIONARY:
			continue

		var condition_flags := _to_string_array(hint.get("condition_flags", []))
		if check_conditions({"required_flags": condition_flags}):
			available_hints.append(hint)
	return available_hints


## Returns dialogue nodes defined in the active episode data.
func get_dialogue_nodes() -> Array:
	return CaseDataScript.get_dialogue_nodes(current_episode_data)


## Returns one dialogue node by id.
func get_dialogue_node(dialogue_node_id: String) -> Dictionary:
	return CaseDataScript.get_dialogue_node_by_id(current_episode_data, dialogue_node_id)


## Returns the current dialogue node, falling back to the first node.
func get_current_dialogue_node() -> Dictionary:
	var node := get_dialogue_node(get_current_dialogue_node_id())
	if not node.is_empty():
		return node

	var nodes := get_dialogue_nodes()
	if nodes.is_empty() or typeof(nodes[0]) != TYPE_DICTIONARY:
		return {}

	var first_node: Dictionary = nodes[0]
	set_current_dialogue_node_id(String(first_node.get("id", DEFAULT_DIALOGUE_NODE_ID)))
	return first_node


## Returns authored continuous field nodes.
func get_field_nodes() -> Array:
	return CaseDataScript.get_field_nodes(current_episode_data)


## Returns one continuous field node.
func get_field_node(field_node_id: String) -> Dictionary:
	return CaseDataScript.get_field_node_by_id(current_episode_data, field_node_id)


## Maps an old dialogue save id to a field node without discarding the old id.
func map_legacy_dialogue_node_to_field_node(dialogue_node_id: String) -> String:
	var clean_id := dialogue_node_id.strip_edges()
	if not get_field_node(clean_id).is_empty():
		return clean_id
	for node in get_field_nodes():
		if typeof(node) != TYPE_DICTIONARY:
			continue
		if _to_string_array(node.get("legacy_dialogue_node_ids", [])).has(clean_id):
			return String(node.get("id", DEFAULT_FIELD_NODE_ID))
	var nodes := get_field_nodes()
	if not nodes.is_empty() and typeof(nodes[0]) == TYPE_DICTIONARY:
		return String(nodes[0].get("id", DEFAULT_FIELD_NODE_ID))
	return DEFAULT_FIELD_NODE_ID


## Returns the current field node, falling back through the legacy dialogue id.
func get_current_field_node() -> Dictionary:
	var node := get_field_node(get_current_field_node_id())
	if not node.is_empty():
		return node
	var mapped := map_legacy_dialogue_node_to_field_node(get_current_dialogue_node_id())
	set_current_field_node_id(mapped)
	return get_field_node(mapped)


## Resolves a field choice exactly once and returns its aftermath dialogue.
func resolve_field_choice(field_node_id: String, choice_id: String) -> Dictionary:
	var node := get_field_node(field_node_id)
	if node.is_empty():
		return {"error": "통합 현장 노드를 찾지 못했습니다."}
	for choice in node.get("choices", []):
		if typeof(choice) != TYPE_DICTIONARY or String(choice.get("id", "")) != choice_id:
			continue
		var effect_key := "field_choice_applied:%s:%s" % [field_node_id, choice_id]
		if not has_flag(effect_key):
			var point_id := String(choice.get("point_id", ""))
			if not point_id.is_empty():
				var point := get_investigation_point_by_id(point_id)
				if not point.is_empty() and point.get("method_options", []).is_empty():
					apply_story_effects(point)
			apply_story_effects(choice.get("effects", choice))
			add_flag(effect_key)
		set_current_field_node_id(String(choice.get("next_field_node_id", field_node_id)))
		save_game()
		return choice.duplicate(true)
	return {"error": "통합 현장 선택지를 찾지 못했습니다."}


## Returns investigation points defined in the active episode data.
func get_investigation_points() -> Array:
	return CaseDataScript.get_investigation_points(current_episode_data)


## Returns one investigation point by id.
func get_investigation_point_by_id(point_id: String) -> Dictionary:
	return CaseDataScript.get_investigation_point_by_id(current_episode_data, point_id)


## Resolves one investigation method with the shared 1d100 ability check.
func resolve_investigation_method(point_id: String, method: Dictionary) -> Dictionary:
	var stat_key := String(method.get("stat_key", method.get("method_type", ""))).strip_edges()
	if not INVESTIGATION_METHOD_KEYS.has(stat_key):
		return {
			"successful": false,
			"error": "지원하지 않는 조사 방법입니다: %s" % stat_key
		}

	var player_stats := get_player_investigation_stats()
	var player_stat := int(player_stats.get(stat_key, 0))
	var approach_type := String(method.get("approach_type", _legacy_method_to_ability(stat_key)))
	if not ABILITY_KEYS.has(approach_type):
		return {"successful": false, "error": "지원하지 않는 요원 능력입니다: %s" % approach_type}
	var helper_agent := find_best_agent_for_ability(approach_type)
	var helper_agent_id := String(helper_agent.get("id", ""))
	var helper_stat := get_agent_ability(helper_agent_id, approach_type) if not helper_agent_id.is_empty() else 0
	var aspect_modifier := get_aspect_modifier(helper_agent_id, approach_type, _to_string_array(method.get("situation_tags", [])))
	var aspect_value := int(aspect_modifier.get("value", 0))
	var score := player_stat + helper_stat + aspect_value
	var difficulty := int(method.get("difficulty", 0))
	var check := resolve_percentile_check(score, difficulty)
	var dice := int(check.get("roll", 100))
	var successful := bool(check.get("successful", false))
	var effects := _to_dictionary(method.get("success_effects", {})) if successful else _to_dictionary(method.get("failure_effects", {}))
	var before_clue_ids := get_collected_clue_ids()

	apply_story_effects(effects)
	var trust_changes := _apply_method_trust_rules(method, successful, helper_agent_id)
	var triggered_agent_events := _try_trigger_agent_trust_events()
	var random_event_result := check_random_event(_to_string_array(method.get("situation_tags", [])))
	var new_clue_ids := _get_new_string_ids(before_clue_ids, get_collected_clue_ids())
	var method_result := {
		"point_id": point_id,
		"method_id": String(method.get("id", "")),
		"method_label": String(method.get("label", "조사 방법")),
		"method_type": String(method.get("method_type", stat_key)),
		"stat_key": stat_key,
		"approach_type": approach_type,
		"difficulty": difficulty,
		"player_stat": player_stat,
		"helper_agent_id": helper_agent_id,
		"helper_agent_name": String(helper_agent.get("name", "도우미 없음")),
		"helper_temperament_label": String(helper_agent.get("temperament_label", "")),
		"helper_stat": helper_stat,
		"aspect_modifier": aspect_modifier,
		"dice": dice,
		"total": score,
		"chance": int(check.get("chance", 0)),
		"result_grade": String(check.get("grade", "failure")),
		"successful": successful,
		"result_text": String(method.get("success_text", "")) if successful else String(method.get("failure_text", "")),
		"effect_data": effects,
		"new_clue_ids": new_clue_ids,
		"requested_clue_ids": _to_string_array(effects.get("collect_clues", [])),
		"hint_texts": get_hint_texts_by_ids(effects.get("show_hint_ids", [])),
		"trust_changes": trust_changes,
		"triggered_agent_events": triggered_agent_events,
		"random_event_result": random_event_result,
		"case_status": get_anomaly_status_summary(),
		"last_updated_at": Time.get_datetime_string_from_system(false, true)
	}

	method_results[point_id] = method_result
	save_game()
	return method_result


func resolve_percentile_check(score: int, difficulty: int, roll_override: int = 0) -> Dictionary:
	var chance := clampi(50 + (score - difficulty) * 10, 5, 95)
	var roll := clampi(roll_override, 1, 100) if roll_override > 0 else randi_range(1, 100)
	var grade := "failure"
	if roll <= chance and roll <= 5:
		grade = "critical"
	elif roll <= chance:
		grade = "success"
	elif roll <= mini(100, chance + 15):
		grade = "partial"
	return {
		"score": score,
		"difficulty": difficulty,
		"chance": chance,
		"roll": roll,
		"grade": grade,
		"successful": grade in ["critical", "success"]
	}


func _legacy_method_to_ability(stat_key: String) -> String:
	match stat_key:
		"destruction": return "suppression"
		"analysis": return "analysis"
		_: return "analysis"


## Returns saved investigation method results.
func get_method_results() -> Dictionary:
	return method_results.duplicate(true)


## Returns one saved method result by investigation point id.
func get_method_result(point_id: String) -> Dictionary:
	var result: Variant = method_results.get(point_id, {})
	if typeof(result) == TYPE_DICTIONARY:
		return result.duplicate(true)
	return {}


## Returns current investigation risk.
func get_investigation_risk() -> int:
	return investigation_risk


## Returns current anomaly risk for MVP-012 UI.
func get_anomaly_risk() -> int:
	return investigation_risk


## Returns current case understanding.
func get_case_understanding() -> int:
	return case_understanding


## Returns current anomaly understanding for prediction.
func get_anomaly_understanding() -> int:
	return case_understanding


## Returns current victim understanding.
func get_victim_understanding() -> int:
	return victim_understanding


## Returns current anomaly stability carried from investigation.
func get_case_anomaly_stability() -> int:
	return case_anomaly_stability


## Returns current anomaly stability for recovery UI.
func get_anomaly_stability() -> int:
	return case_anomaly_stability


## Returns current mental stamina.
func get_mental_stamina() -> int:
	return mental_stamina


## Returns true when risk forced the run toward recovery.
func is_forced_recovery_phase() -> bool:
	return forced_recovery_phase


## Returns current anomaly prediction rate with success suppression and failure recovery.
func get_current_prediction_rate() -> float:
	return clampf(float(case_understanding - prediction_success_streak * 15 + prediction_failure_streak * 10), 5.0, 95.0)


## Rolls one anomaly prediction and updates decay state.
func roll_anomaly_prediction(pattern: Dictionary = {}) -> Dictionary:
	var rate := get_current_prediction_rate()
	if seen_recovery_pattern_ids.size() <= 1 and has_equipped_item("gear_resonance_prism") and not has_used_equipment_effect("market:first_prediction:%s" % get_current_episode_id()):
		rate = clampf(rate + 10.0, 5.0, 95.0)
		mark_equipment_effect_used("market:first_prediction:%s" % get_current_episode_id())
	if int(consumable_loadout.get("consumable_prediction_film", 0)) > 0:
		use_loaded_consumable("consumable_prediction_film")
		consume_active_consumable_effect("consumable_prediction_film")
		rate = clampf(rate + 20.0, 5.0, 95.0)
	var successful := randf() * 100.0 <= rate
	var next_action := "괴이의 다음 움직임을 안정적으로 읽지 못했습니다."
	if successful:
		next_action = "%s — %s" % [String(pattern.get("name", "행동 확인")), String(pattern.get("description", _get_prediction_success_text()))]
		confirmed_recovery_pattern_id = String(pattern.get("id", ""))
	else:
		confirmed_recovery_pattern_id = ""

	apply_prediction_result(successful)
	var result := {
		"successful": successful,
		"rate": rate,
		"next_action": next_action,
		"prediction_success_streak": prediction_success_streak,
		"prediction_failure_streak": prediction_failure_streak,
		"mental_stamina": mental_stamina
	}
	save_game()
	return result


## Applies prediction success or failure to the decay counter.
func apply_prediction_result(successful: bool) -> void:
	if successful:
		prediction_success_streak += 1
		prediction_failure_streak = 0
		add_flag("prediction_success")
	else:
		prediction_failure_streak += 1
		prediction_success_streak = 0
		add_flag("prediction_failed")


## Resets consecutive prediction decay.
func reset_prediction_decay() -> void:
	prediction_success_streak = 0
	prediction_failure_streak = 0
	save_game()


func get_prediction_streaks() -> Dictionary:
	return {"success": prediction_success_streak, "failure": prediction_failure_streak}


## Test/content authoring helper that keeps understanding bounded.
func set_anomaly_understanding_for_test(value: int) -> void:
	case_understanding = clampi(value, 0, 100)


func change_anomaly_understanding(delta: int) -> int:
	case_understanding = clampi(case_understanding + delta, 0, 100)
	return case_understanding


func change_anomaly_stability(delta: int) -> int:
	case_anomaly_stability = clampi(case_anomaly_stability + delta, 0, 100)
	return case_anomaly_stability


func get_recovery_patterns() -> Array:
	return CaseDataScript.get_recovery_patterns(current_episode_data)


func get_recovery_pattern(pattern_id: String) -> Dictionary:
	return CaseDataScript.get_recovery_pattern_by_id(current_episode_data, pattern_id)


## Selects unseen patterns in authored order, then weighted random without an immediate repeat.
func select_next_recovery_pattern() -> Dictionary:
	var patterns := get_recovery_patterns()
	if patterns.is_empty():
		return {}
	var unseen: Array = []
	for pattern in patterns:
		if typeof(pattern) == TYPE_DICTIONARY and not seen_recovery_pattern_ids.has(String(pattern.get("id", ""))):
			unseen.append(pattern)
	var selected: Dictionary = {}
	if not unseen.is_empty():
		unseen.sort_custom(func(a: Dictionary, b: Dictionary) -> bool: return int(a.get("order", 0)) < int(b.get("order", 0)))
		selected = unseen[0]
	else:
		var candidates: Array = []
		for pattern in patterns:
			if typeof(pattern) == TYPE_DICTIONARY and String(pattern.get("id", "")) != last_recovery_pattern_id:
				candidates.append(pattern)
		selected = candidates.pick_random() if not candidates.is_empty() else patterns[0]
	var selected_id := String(selected.get("id", ""))
	current_recovery_pattern_id = selected_id
	last_recovery_pattern_id = selected_id
	if not seen_recovery_pattern_ids.has(selected_id):
		seen_recovery_pattern_ids.append(selected_id)
	return selected.duplicate(true)


func reset_recovery_pattern_state(save_after: bool = true) -> void:
	current_recovery_pattern_id = ""
	last_recovery_pattern_id = ""
	confirmed_recovery_pattern_id = ""
	seen_recovery_pattern_ids.clear()
	recovery_pattern_learning.clear()
	prediction_success_streak = 0
	prediction_failure_streak = 0
	if save_after:
		save_game()


func record_recovery_pattern_outcome(pattern_id: String, response_id: String, correct: bool, reason: String, decision_context: Dictionary = {}) -> void:
	var record := {
		"pattern_id": pattern_id,
		"response_id": response_id,
		"correct": correct,
		"reason": reason,
		"attempts": int(_to_dictionary(recovery_pattern_learning.get(pattern_id, {})).get("attempts", 0)) + 1
	}
	recovery_pattern_learning[pattern_id] = record
	_record_anomaly_manual_decision(pattern_id, response_id, correct, reason, decision_context)
	if correct:
		grant_echo_reward("pattern:%s:%s" % [get_current_episode_id(), pattern_id], 5)


func get_recovery_pattern_learning() -> Dictionary:
	return recovery_pattern_learning.duplicate(true)


func get_agent_auto_action_chance(agent_id: String, ability_key: String, bonus_chance: float = 0.0, maximum_chance: float = 70.0) -> float:
	if not is_agent_active(agent_id):
		return 0.0
	var cap := clampf(maximum_chance, 1.0, 99.0)
	var chance := clampf(float(15 + get_agent_ability(agent_id, ability_key) * 8 + get_agent_trust(agent_id) * 3) + bonus_chance, 15.0, cap)
	if ability_key == "rapport" and has_equipped_item("gear_resonance_buffer"):
		chance = minf(cap, chance + 10.0)
	if get_agent_current_mental(agent_id) * 4 <= get_agent_max_mental(agent_id):
		chance *= 0.5
	return chance


func roll_agent_auto_action(agent_id: String, ability_key: String, roll_override: float = -1.0, bonus_chance: float = 0.0, maximum_chance: float = 70.0) -> Dictionary:
	var chance := get_agent_auto_action_chance(agent_id, ability_key, bonus_chance, maximum_chance)
	var roll := randf() * 100.0 if roll_override < 0.0 else clampf(roll_override, 0.0, 100.0)
	return {
		"agent_id": agent_id,
		"agent_name": String(get_agent_by_id(agent_id).get("name", "요원")),
		"ability": ability_key,
		"chance": chance,
		"roll": roll,
		"triggered": chance > 0.0 and roll <= chance
	}


## Returns the latest random event result.
func get_last_random_event_result() -> Dictionary:
	return last_random_event_result.duplicate(true)


## Checks whether a risk-based random event happens after investigation.
func check_random_event(trigger_tags: Array = []) -> Dictionary:
	if investigation_risk >= 100:
		return _make_forced_recovery_event()

	var chance := _get_random_event_chance()
	if chance <= 0 or randi_range(1, 100) > chance:
		last_random_event_result = {
			"triggered": false,
			"message": "이번 조사에서는 추가 이상 현상이 발생하지 않았습니다."
		}
		return last_random_event_result.duplicate(true)

	var candidates := _get_random_event_candidates(trigger_tags)
	if candidates.is_empty():
		last_random_event_result = {
			"triggered": false,
			"message": "조건에 맞는 랜덤 이벤트가 없습니다."
		}
		return last_random_event_result.duplicate(true)

	var event := _pick_weighted_random_event(candidates)
	var effects := _to_dictionary(event.get("effects", {}))
	last_random_event_id = String(event.get("id", ""))
	last_random_event_result = {
		"triggered": true,
		"id": last_random_event_id,
		"event_type": String(event.get("event_type", "")),
		"title": String(event.get("title", "랜덤 이벤트")),
		"message": String(event.get("text", "")),
		"effects": effects.duplicate(true)
	}
	apply_story_effects(effects)
	return last_random_event_result.duplicate(true)


## Returns a compact summary of investigation status values.
func get_case_status_summary() -> Dictionary:
	return get_anomaly_status_summary()


## Returns a compact summary of MVP-012 anomaly loop status values.
func get_anomaly_status_summary() -> Dictionary:
	return {
		"investigation_risk": investigation_risk,
		"case_understanding": case_understanding,
		"victim_understanding": victim_understanding,
		"anomaly_risk": investigation_risk,
		"anomaly_understanding": case_understanding,
		"anomaly_stability": case_anomaly_stability,
		"mental_stamina": mental_stamina,
		"prediction_rate": get_current_prediction_rate(),
		"prediction_success_streak": prediction_success_streak,
		"prediction_failure_streak": prediction_failure_streak,
		"forced_recovery_phase": forced_recovery_phase
	}


## Returns minigames defined in the active episode data.
func get_minigames() -> Array:
	return CaseDataScript.get_minigames(current_episode_data)


## Returns record definitions.
func get_records() -> Array:
	return CaseDataScript.get_records(current_episode_data)


## Returns one record definition.
func get_record_by_id(record_id: String) -> Dictionary:
	return CaseDataScript.get_record_by_id(current_episode_data, record_id)


## Returns equipment definitions.
func get_equipment() -> Array:
	var result := CaseDataScript.get_equipment(current_episode_data).duplicate(true)
	for item in MARKET_ITEMS:
		if String(item.get("category", "")) == "permanent":
			result.append(item.duplicate(true))
	return result


## Returns one equipment definition.
func get_equipment_by_id(equipment_id: String) -> Dictionary:
	var item := CaseDataScript.get_equipment_by_id(current_episode_data, equipment_id)
	if not item.is_empty():
		return item
	return get_market_item(equipment_id)


func get_echo_fragments() -> int:
	return echo_fragments


## Grants currency once for a globally unique reward id.
func grant_echo_reward(reward_id: String, amount: int) -> bool:
	var clean_id := reward_id.strip_edges()
	if clean_id.is_empty() or amount <= 0 or granted_reward_ids.has(clean_id):
		return false
	granted_reward_ids.append(clean_id)
	echo_fragments += amount
	return true


func get_granted_reward_ids() -> Array:
	return granted_reward_ids.duplicate()


func get_faction_relation(faction_id: String) -> int:
	return clampi(int(faction_relations.get(faction_id, 0)), -100, 100)


func get_faction_tier(faction_id: String) -> String:
	var value := get_faction_relation(faction_id)
	if value <= -50: return "hostile"
	if value <= -20: return "wary"
	if value < 20: return "neutral"
	if value < 50: return "favorable"
	return "trusted"


func get_faction_tier_label(faction_id: String) -> String:
	return {"hostile": "적대", "wary": "경계", "neutral": "중립", "favorable": "우호", "trusted": "신뢰"}.get(get_faction_tier(faction_id), "중립")


func change_faction_relation(faction_id: String, delta: int, event_id: String = "") -> int:
	if not FACTION_IDS.has(faction_id):
		return 0
	var clean_event := event_id.strip_edges()
	if not clean_event.is_empty() and triggered_faction_event_ids.has(clean_event):
		return get_faction_relation(faction_id)
	if not clean_event.is_empty():
		triggered_faction_event_ids.append(clean_event)
	faction_relations[faction_id] = clampi(get_faction_relation(faction_id) + delta, -100, 100)
	return get_faction_relation(faction_id)


func complete_faction_request(request_id: String, faction_id: String) -> bool:
	var clean_id := request_id.strip_edges()
	if clean_id.is_empty() or completed_faction_request_ids.has(clean_id):
		return false
	completed_faction_request_ids.append(clean_id)
	change_faction_relation(faction_id, 10, "request_relation:%s" % clean_id)
	grant_echo_reward("request_reward:%s" % clean_id, 20)
	return true


func resolve_faction_request(instance_id: String, agent_id: String, roll_override: int = 0) -> Dictionary:
	var request := campaign_state.get_request(instance_id)
	if request.is_empty() or String(request.get("status", "")) != "accepted":
		return {"error": "진행 중인 의뢰가 아닙니다."}
	var ability_key := String(request.get("ability_key", ""))
	var agent := get_agent_by_id(agent_id)
	if agent.is_empty() or not ABILITY_KEYS.has(ability_key):
		return {"error": "담당 요원 또는 요구 능력을 확인할 수 없습니다."}
	var score := get_agent_ability(agent_id, ability_key)
	score += _get_agent_loadout_bonus(agent, "equipment", ability_key)
	score += _get_agent_loadout_bonus(agent, "skills", ability_key)
	var check := resolve_percentile_check(score, int(request.get("difficulty", 0)), roll_override)
	var grade := String(check.get("grade", "failure"))
	var reward: Dictionary = {
		"critical": {"fragments": 12, "relation": 4},
		"success": {"fragments": 8, "relation": 3},
		"partial": {"fragments": 4, "relation": 1},
		"failure": {"fragments": 0, "relation": 0}
	}.get(grade, {"fragments": 0, "relation": 0})
	var completed: Dictionary = campaign_state.complete_request(instance_id, grade, check)
	if completed.is_empty():
		return {"error": "의뢰 결과를 저장하지 못했습니다."}
	if not completed_faction_request_ids.has(instance_id):
		completed_faction_request_ids.append(instance_id)
	var relation_delta := int(reward.get("relation", 0))
	var fragments := int(reward.get("fragments", 0))
	if relation_delta > 0:
		change_faction_relation(String(request.get("faction_id", "")), relation_delta, "request_relation:%s" % instance_id)
	if fragments > 0:
		grant_echo_reward("request_reward:%s" % instance_id, fragments)
	var result_text := String(request.get("%s_text" % grade, ""))
	return {"request": completed, "check": check, "fragments": fragments, "relation": relation_delta, "result_text": result_text}


func try_resolve_recovery_faction_requests(ability_key: String, agent_id: String) -> Array:
	var results: Array = []
	for request in get_faction_request_board():
		if typeof(request) != TYPE_DICTIONARY:
			continue
		if String(request.get("status", "")) != "accepted" or String(request.get("kind", "")) != "recovery_action":
			continue
		if String(request.get("ability_key", "")) != ability_key:
			continue
		results.append(resolve_faction_request(String(request.get("instance_id", "")), agent_id))
	return results


func resolve_non_investigation_campaign_slot(agent_ids: Array) -> Dictionary:
	if not is_campaign_schedule_complete(agent_ids):
		return {"error": "현재 반일의 전 요원 일정을 먼저 정하세요."}
	var slot := String(get_campaign_snapshot().get("time_slot", "morning"))
	var results: Array = []
	var assigned_request_ids: Array = []
	for agent_id_value in agent_ids:
		var activity := String(get_campaign_agent_schedule(String(agent_id_value)).get(slot, ""))
		if not activity.begins_with("request:"):
			continue
		var request_id := activity.trim_prefix("request:")
		if assigned_request_ids.has(request_id):
			return {"error": "같은 의뢰에는 요원 한 명만 배치할 수 있습니다."}
		assigned_request_ids.append(request_id)
	for agent_id_value in agent_ids:
		var agent_id := String(agent_id_value)
		var activity := String(get_campaign_agent_schedule(agent_id).get(slot, ""))
		if activity == "investigation":
			return {"error": "조사 일정은 사건을 선택해 현장에서 완료해야 합니다."}
		if activity.begins_with("request:"):
			var instance_id := activity.trim_prefix("request:")
			if not campaign_state.assign_request(instance_id, agent_id):
				return {"error": "의뢰 담당 요원을 배정하지 못했습니다."}
			results.append(resolve_faction_request(instance_id, agent_id))
		else:
			results.append({"agent_id": agent_id, "activity": "rest", "message": "대기·회복 일정을 마쳤습니다."})
	if not complete_campaign_slot({"kind": "schedule", "results": results}):
		return {"error": "현재 반일 결과를 저장하지 못했습니다."}
	save_game()
	return {"successful": true, "results": results}


func get_completed_faction_requests() -> Array:
	return completed_faction_request_ids.duplicate()


func get_market_catalog() -> Array:
	return MARKET_ITEMS.duplicate(true)


func get_market_item(item_id: String) -> Dictionary:
	for item in MARKET_ITEMS:
		if String(item.get("id", "")) == item_id:
			return item.duplicate(true)
	return {}


func get_market_price(item_id: String) -> int:
	var item := get_market_item(item_id)
	if item.is_empty():
		return 0
	var multiplier := 1.0
	match get_faction_tier("rumor_market"):
		"wary": multiplier = 1.1
		"favorable": multiplier = 0.9
		"trusted": multiplier = 0.8
	return int(round(float(item.get("price", 0)) * multiplier))


func purchase_market_item(item_id: String) -> Dictionary:
	var item := get_market_item(item_id)
	if item.is_empty():
		return {"successful": false, "message": "상품을 찾지 못했습니다."}
	if get_faction_tier("rumor_market") == "hostile":
		return {"successful": false, "message": "소문시장이 거래를 거부합니다."}
	var category := String(item.get("category", ""))
	if category == "permanent" and purchased_market_item_ids.has(item_id):
		return {"successful": false, "message": "이미 구매한 영구 장비입니다."}
	if category == "consumable" and int(consumable_inventory.get(item_id, 0)) >= 3:
		return {"successful": false, "message": "소모품은 종류별로 최대 3개까지 보유할 수 있습니다."}
	var price := get_market_price(item_id)
	if echo_fragments < price:
		return {"successful": false, "message": "잔향 파편이 부족합니다."}
	echo_fragments -= price
	if category == "permanent":
		purchased_market_item_ids.append(item_id)
		_unlock_unique(unlocked_equipment, item_id)
	else:
		consumable_inventory[item_id] = int(consumable_inventory.get(item_id, 0)) + 1
	save_game()
	return {"successful": true, "message": "%s 구매 완료" % String(item.get("name", item_id)), "price": price}


func get_consumable_inventory() -> Dictionary:
	return consumable_inventory.duplicate(true)


func get_consumable_loadout() -> Dictionary:
	return consumable_loadout.duplicate(true)


func set_consumable_loadout(item_id: String, amount: int) -> bool:
	var item := get_market_item(item_id)
	if String(item.get("category", "")) != "consumable":
		return false
	var bounded := clampi(amount, 0, mini(3, int(consumable_inventory.get(item_id, 0))))
	var types := 0
	for loaded_id in consumable_loadout:
		if int(consumable_loadout.get(loaded_id, 0)) > 0 and String(loaded_id) != item_id:
			types += 1
	if bounded > 0 and types >= 2:
		return false
	if bounded <= 0:
		consumable_loadout.erase(item_id)
	else:
		consumable_loadout[item_id] = bounded
	return true


func use_loaded_consumable(item_id: String) -> bool:
	var loaded := int(consumable_loadout.get(item_id, 0))
	var owned := int(consumable_inventory.get(item_id, 0))
	if loaded <= 0 or owned <= 0:
		return false
	consumable_loadout[item_id] = loaded - 1
	consumable_inventory[item_id] = owned - 1
	active_consumable_effects[item_id] = int(active_consumable_effects.get(item_id, 0)) + 1
	if int(consumable_loadout[item_id]) <= 0: consumable_loadout.erase(item_id)
	if int(consumable_inventory[item_id]) <= 0: consumable_inventory.erase(item_id)
	save_game()
	return true


func consume_active_consumable_effect(item_id: String) -> bool:
	var count := int(active_consumable_effects.get(item_id, 0))
	if count <= 0:
		return false
	if count == 1: active_consumable_effects.erase(item_id)
	else: active_consumable_effects[item_id] = count - 1
	return true


## Grants only the positive difference when an episode improves its best resolution grade.
func grant_resolution_echo_reward(episode_id: String, grade: String) -> int:
	var amounts := {"temporary": 30, "standard": 55, "complete": 75}
	var clean_episode := episode_id.strip_edges()
	if clean_episode.is_empty() or not amounts.has(grade):
		return 0
	var previous_grade := String(rewarded_resolution_grades.get(clean_episode, ""))
	var previous_amount := int(amounts.get(previous_grade, 0))
	var next_amount := int(amounts.get(grade, 0))
	if next_amount <= previous_amount:
		return 0
	var delta := next_amount - previous_amount
	if not grant_echo_reward("resolution:%s:%s" % [clean_episode, grade], delta):
		return 0
	rewarded_resolution_grades[clean_episode] = grade
	return delta


## Returns one minigame by id.
func get_minigame(minigame_id: String) -> Dictionary:
	return CaseDataScript.get_minigame_by_id(current_episode_data, minigame_id)


## Returns the current minigame, falling back to the first minigame.
func get_current_minigame() -> Dictionary:
	var minigame := get_minigame(get_current_minigame_id())
	if not minigame.is_empty():
		return minigame

	var minigames := get_minigames()
	if minigames.is_empty() or typeof(minigames[0]) != TYPE_DICTIONARY:
		return {}

	var first_minigame: Dictionary = minigames[0]
	set_current_minigame_id(String(first_minigame.get("id", DEFAULT_MINIGAME_ID)))
	return first_minigame


## Returns active clue records.
func get_clues() -> Array:
	return CaseDataScript.get_clues(current_episode_data)


## Returns only collected clues. Hints are intentionally excluded.
func get_collected_clues() -> Array:
	var collected_clues: Array = []
	for clue in get_clues():
		if typeof(clue) == TYPE_DICTIONARY and bool(clue.get("collected", false)):
			collected_clues.append(clue)
	return collected_clues


## Returns collected clue ids for save data and condition checks.
func get_collected_clue_ids() -> Array:
	var clue_ids: Array = []
	for clue in get_collected_clues():
		clue_ids.append(String(clue.get("id", "")))
	return clue_ids


## Returns true when one clue has been collected.
func has_collected_clue(clue_id: String) -> bool:
	return get_collected_clue_ids().has(clue_id)


## Returns collected clue count for the active episode.
func get_collected_clue_count() -> int:
	return CaseDataScript.get_collected_clue_count(current_episode_data)


## Returns total clue count for the active episode.
func get_total_clue_count() -> int:
	return CaseDataScript.get_total_clue_count(current_episode_data)


## Returns current clue collection rate as a 0 to 100 percentage.
func get_clue_collection_rate() -> float:
	return CaseDataScript.get_collection_rate(current_episode_data)


## Returns current resolution grade key.
func get_resolution_grade() -> String:
	return CaseDataScript.get_resolution_grade(current_episode_data)


## Returns current resolution grade display label.
func get_resolution_label() -> String:
	return CaseDataScript.get_resolution_label(current_episode_data)


## Returns the battle auto-effect linked to one clue.
func get_battle_effect_for_clue(clue_id: String) -> Dictionary:
	return CaseDataScript.get_battle_effect_for_clue(current_episode_data, clue_id)


## Returns battle effects for collected clues only. Hints and uncollected clues are excluded.
func get_collected_battle_effects() -> Array:
	var effects: Array = []
	for clue in get_collected_clues():
		var clue_id := String(clue.get("id", ""))
		var effect := get_battle_effect_for_clue(clue_id)
		if effect.is_empty():
			continue

		var effect_entry := effect.duplicate(true)
		effect_entry["clue_title"] = String(clue.get("title", ""))
		effects.append(effect_entry)
	return effects


## Returns the research reward for the current resolution grade.
func get_current_research_reward() -> Dictionary:
	return CaseDataScript.get_research_reward_for_grade(current_episode_data, get_resolution_grade())


## Returns unlocked record ids for save data and DB UI.
func get_unlocked_records() -> Array:
	return unlocked_records.duplicate()


## Returns whether a recovered record is available for preparation references.
func has_unlocked_record(record_id: String) -> bool:
	return unlocked_records.has(record_id)


## Returns unlocked research reward ids for save data and DB UI.
func get_unlocked_research_rewards() -> Array:
	return unlocked_research_rewards.duplicate()


## Returns unlocked equipment ids for save data and DB UI.
func get_unlocked_equipment() -> Array:
	return unlocked_equipment.duplicate()


## Returns equipped item ids for save data.
func get_equipped_items() -> Array:
	return equipped_items.duplicate()


## Returns used equipment effect keys for save data.
func get_used_equipment_effects() -> Array:
	return used_equipment_effects.duplicate()


## Returns true when one equipment item is equipped.
func has_equipped_item(equipment_id: String) -> bool:
	return equipped_items.has(equipment_id)


## Returns true when one equipment item is unlocked.
func has_unlocked_equipment(equipment_id: String) -> bool:
	return unlocked_equipment.has(equipment_id)


## Equips one unlocked equipment item into the MVP tool slot.
func equip_item(equipment_id: String) -> bool:
	var clean_id := equipment_id.strip_edges()
	if clean_id.is_empty() or not has_unlocked_equipment(clean_id):
		return false

	equipped_items.clear()
	equipped_items.append(clean_id)
	save_game()
	return true


## Unequips one equipment item from the MVP tool slot.
func unequip_item(equipment_id: String) -> bool:
	var clean_id := equipment_id.strip_edges()
	if clean_id.is_empty() or not equipped_items.has(clean_id):
		return false

	equipped_items.erase(clean_id)
	save_game()
	return true


## Returns true when an equipment effect key has already been consumed.
func has_used_equipment_effect(effect_key: String) -> bool:
	return used_equipment_effects.has(effect_key)


## Marks one equipment effect as used once.
func mark_equipment_effect_used(effect_key: String) -> void:
	var clean_key := effect_key.strip_edges()
	if clean_key.is_empty() or used_equipment_effects.has(clean_key):
		return

	used_equipment_effects.append(clean_key)
	save_game()


## Returns unlocked record data.
func get_unlocked_record_entries() -> Array:
	return _get_entries_by_ids(get_records(), unlocked_records)


## Returns unlocked equipment data.
func get_unlocked_equipment_entries() -> Array:
	return _get_entries_by_ids(get_equipment(), unlocked_equipment)


## Returns equipped equipment data.
func get_equipped_equipment_entries() -> Array:
	return _get_entries_by_ids(get_equipment(), equipped_items)


## Returns unlocked research reward data.
func get_unlocked_research_reward_entries() -> Array:
	return _get_entries_by_ids(CaseDataScript.get_research_rewards(current_episode_data), unlocked_research_rewards)


## Returns current result grade record unlocks.
func get_current_result_unlocked_records() -> Array:
	return _get_entries_by_ids(get_records(), _get_result_record_ids_for_grade(get_result_resolution_grade()))


## Returns current result grade research unlocks.
func get_current_result_unlocked_research_rewards() -> Array:
	return _get_entries_by_ids(CaseDataScript.get_research_rewards(current_episode_data), _get_result_research_reward_ids_for_grade(get_result_resolution_grade()))


## Returns current result grade equipment unlocks.
func get_current_result_unlocked_equipment() -> Array:
	return _get_entries_by_ids(get_equipment(), _get_result_equipment_ids_for_grade(get_result_resolution_grade()))


## Returns next investigation modifier text for current unlocks.
func get_next_investigation_modifier_text() -> String:
	if has_equipped_item(EQUIP_FREQUENCY_FILTER):
		var item := get_equipment_by_id(EQUIP_FREQUENCY_FILTER)
		return String(item.get("next_investigation_modifier", "주파수 계열 미니게임에서 힌트 1회 제공"))
	if has_unlocked_equipment(EQUIP_FREQUENCY_FILTER):
		return "폐주파수 필터가 해금되어 있습니다. 사건 준비 화면에서 장착하면 주파수 계열 힌트 1회가 적용됩니다."
	return "이번 회수 결과로 적용되는 다음 조사 보정은 아직 없습니다."


## Returns the episode choices exposed by the MVP preparation screen.
func get_preparation_episode_entries() -> Array:
	var entries: Array = []
	var episode_paths := [DEFAULT_EPISODE_PATH, RED_UMBRELLA_ALLEY_EPISODE_PATH]
	var dead_frequency_state: Dictionary = get_campaign_snapshot().get("cases", {}).get("episode_003_dead_frequency_station", {})
	if String(dead_frequency_state.get("discovery_state", "unknown")) != "unknown":
		episode_paths.append(DEAD_FREQUENCY_STATION_EPISODE_PATH)
	for episode_path in episode_paths:
		var loader = EpisodeLoaderScript.new()
		var data: Dictionary = loader.load_episode(episode_path)
		var episode: Dictionary = data.get("episode", {})
		if not episode.is_empty():
			entries.append({
				"path": episode_path,
				"id": String(episode.get("id", "")),
				"title": String(episode.get("title", "사건")),
				"summary": String(episode.get("summary", ""))
			})
	return entries


## Builds Log's current-case briefing from the active episode data.
func get_episode_log_lines() -> Array:
	var briefing: Dictionary = current_episode_data.get("preparation_briefing", {})
	if briefing.is_empty():
		return []

	var lines: Array = []
	var briefing_text := String(briefing.get("briefing", ""))
	if not briefing_text.is_empty():
		lines.append("사건 브리핑: %s" % briefing_text)

	if has_equipped_item(EQUIP_FREQUENCY_FILTER):
		var equipment_text := String(briefing.get("equipped_frequency_filter", ""))
		if not equipment_text.is_empty():
			lines.append("장비 보정: %s" % equipment_text)

	if has_unlocked_record("record_repeating_announcement") or has_unlocked_record("record_black_ticket_core"):
		var record_text := String(briefing.get("record_reference", ""))
		if not record_text.is_empty():
			lines.append("기록물 참고: %s" % record_text)

	var warning_text := String(briefing.get("risk_warning", ""))
	if not warning_text.is_empty():
		lines.append("위험 경고: %s" % warning_text)
	return lines


## Returns active equipment and record notices for an investigation point.
func get_investigation_point_support_text(point: Dictionary) -> Array:
	var lines: Array = []
	var tags := _to_string_array(point.get("tags", []))
	if tags.has("frequency_related") and has_equipped_item(EQUIP_FREQUENCY_FILTER):
		lines.append("아카 장비 안내: 폐주파수 필터가 잡음을 분리할 준비를 마쳤습니다. 이 조사 포인트의 주파수 패턴에서 힌트 1회를 사용할 수 있습니다.")

	if has_unlocked_record("record_repeating_announcement"):
		lines.append("아카 기록물 참고: 저승역의 반복 안내방송 기록과 유사한 잡음 패턴입니다.")
	elif has_unlocked_record("record_black_ticket_core"):
		lines.append("아카 기록물 참고: 검은 승차권의 핵 기록에서 확인한 반복 경로 규칙을 대조하세요.")
	return lines


## Returns the project core sentence.
func get_project_core_sentence() -> String:
	return "괴담은 죽이는 게 아니라, 규칙을 밝혀 봉인하는 것이다."


## Returns mascot guide lines for the case preparation screen.
func get_preparation_log_lines() -> Array:
	var lines: Array = [
		"기록관 아카: 괴이 기록국 관제 AI입니다. 장비, 기록물, 위험 안내를 조사 시작 전에 정리합니다.",
		"핵심 원칙: %s" % get_project_core_sentence()
	]
	if has_equipped_item(EQUIP_FREQUENCY_FILTER):
		lines.append("장비 장착 확인: 폐주파수 필터가 주파수 계열 미니게임 힌트 1회를 준비합니다.")
	elif has_unlocked_equipment(EQUIP_FREQUENCY_FILTER):
		lines.append("장비 안내: 폐주파수 필터가 해금되어 있습니다. 장착하면 다음 조사 보정이 활성화됩니다.")
	else:
		lines.append("장비 안내: 아직 해금된 주파수 보정 장비가 없습니다.")

	var unlocked_record_count := get_unlocked_record_entries().size()
	if unlocked_record_count >= 2:
		lines.append("기록물 안내: 저승역 회수 기록 %d건을 참고할 수 있습니다. 반복 패턴과 매개체 규칙을 먼저 확인하세요." % unlocked_record_count)
	else:
		lines.append("기록물 안내: 참고 가능한 회수 기록이 부족합니다. 조사 중 단서와 힌트를 우선 확보하세요.")

	if has_equipped_item(EQUIP_FREQUENCY_FILTER):
		lines.append("위험 안내: 필터 힌트는 같은 미니게임에서 한 번만 발동합니다. 가장 불안정한 파형 앞에서 쓰세요.")
	else:
		lines.append("위험 안내: 장착 장비가 없으면 미니게임 보정 없이 조사에 들어갑니다.")
	return lines


## Returns true when the current clue rate allows entering the resolution phase.
func can_enter_resolution_phase() -> bool:
	return forced_recovery_phase or get_resolution_grade() != "unavailable"


## Returns a warning message for the current resolution grade.
func get_resolution_phase_warning() -> String:
	if forced_recovery_phase:
		return "괴이 위험도가 한계에 도달해 강제 회수전으로 밀려나고 있습니다. 단서가 부족하면 피해자 후유증과 회수 부담이 커집니다."

	var grade := get_resolution_grade()
	match grade:
		"temporary":
			return "단서가 부족해 피해자에게 후유증이 남을 수 있고, 회수 난이도가 높습니다."
		"standard":
			return "충분한 단서를 확보했습니다. 피해자 구조와 괴이 회수를 안정적으로 시도할 수 있습니다."
		"complete":
			return "모든 핵심 단서를 확보했습니다. 피해자 구조, 진상 기록, 특수 연구 보상을 노릴 수 있습니다."
		_:
			return "아직 괴이의 핵에 접근할 근거가 부족합니다. 단서를 더 수집해야 합니다."


## Stores the current resolution grade before moving to the battle scene.
func start_resolution_phase() -> bool:
	if not can_enter_resolution_phase():
		return false

	if forced_recovery_phase and get_resolution_grade() == "unavailable":
		selected_resolution_grade = "temporary"
		selected_resolution_label = "강제 회수전"
	else:
		selected_resolution_grade = get_resolution_grade()
		selected_resolution_label = get_resolution_label()
	selected_resolution_rate = get_clue_collection_rate()
	_clear_recovery_result()
	add_flag("resolution_phase_started")
	save_game()
	return true


## Returns the saved resolution grade key from the latest resolution attempt.
func get_selected_resolution_grade() -> String:
	return selected_resolution_grade


## Returns the saved resolution grade label from the latest resolution attempt.
func get_selected_resolution_label() -> String:
	return selected_resolution_label


## Returns the clue collection rate saved when the resolution attempt started.
func get_selected_resolution_rate() -> float:
	return selected_resolution_rate


## Returns the selected resolution grade, falling back to the current grade for scene tests.
func get_result_resolution_grade() -> String:
	if selected_resolution_grade.is_empty():
		return get_resolution_grade()
	return selected_resolution_grade


## Returns the selected resolution label, falling back to the current label for scene tests.
func get_result_resolution_label() -> String:
	if selected_resolution_label.is_empty():
		return get_resolution_label()
	return selected_resolution_label


## Returns the recovery result that matches the selected resolution grade.
func get_current_recovery_result() -> Dictionary:
	return CaseDataScript.get_recovery_result_for_grade(current_episode_data, get_result_resolution_grade())


## Returns the victim rescue result text for the selected resolution grade.
func get_current_victim_rescue_result() -> String:
	var result := get_current_recovery_result()
	return String(result.get("description", "피해자 구조 결과가 아직 기록되지 않았습니다."))


## Returns the victim after-story for the selected resolution grade.
func get_current_victim_after_story() -> String:
	var result := get_current_recovery_result()
	return String(result.get("after_story", "피해자 후일담이 아직 기록되지 않았습니다."))


## Returns the research result text for the selected resolution grade.
func get_current_research_result() -> String:
	var result := get_current_recovery_result()
	return String(result.get("research_result", "연구 결과가 아직 기록되지 않았습니다."))


## Returns the research reward that matches the selected resolution grade.
func get_current_result_research_reward() -> Dictionary:
	return CaseDataScript.get_research_reward_for_grade(current_episode_data, get_result_resolution_grade())


## Saves the recovery result after the anomaly core is stabilized.
func save_recovery_result(successful: bool, result_status: String, anomaly_stability: int) -> void:
	recovery_successful = successful
	recovery_result_status = result_status
	recovery_result_stability = anomaly_stability
	if successful:
		add_flag(FLAG_CAPTURE_SUCCESS)
		add_flag("capture_result_%s" % result_status)
		var grade := get_result_resolution_grade()
		_apply_resolution_unlocks(grade)
		grant_resolution_echo_reward(get_current_episode_id(), grade)
	save_game()


## Returns true after a successful anomaly core recovery.
func is_recovery_successful() -> bool:
	return recovery_successful


## Returns the saved recovery result status key.
func get_recovery_result_status() -> String:
	return recovery_result_status


## Returns the anomaly stability value saved at recovery.
func get_recovery_result_stability() -> int:
	return recovery_result_stability


## Saves the current MVP run to user://urban_legend_save.json.
func save_game() -> bool:
	if current_episode_data.is_empty() and not load_episode(DEFAULT_EPISODE_PATH):
		return false

	var file := FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("Save file cannot be opened: %s" % SAVE_FILE_PATH)
		return false

	file.store_string(JSON.stringify(_make_save_data(), "\t"))
	return true


## Loads the current MVP run from user://urban_legend_save.json.
func load_game() -> bool:
	if not has_save_file():
		return false

	var file := FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	if file == null:
		push_error("Save file cannot be opened: %s" % SAVE_FILE_PATH)
		return false

	var parsed_data: Variant = JSON.parse_string(file.get_as_text())
	if typeof(parsed_data) != TYPE_DICTIONARY:
		push_error("Save file root must be a Dictionary: %s" % SAVE_FILE_PATH)
		return false

	var save_data: Dictionary = parsed_data
	var loaded_save_version := String(save_data.get("save_version", ""))
	campaign_state.load_save_data(save_data.get("campaign_state", {}), loaded_save_version == "mvp-037")
	var saved_team := _to_string_array(save_data.get("selected_agent_ids", []))
	var previous_protagonist := String(saved_team[0]) if not saved_team.is_empty() else ""
	if not previous_protagonist.is_empty() and previous_protagonist != "agent_kwon_narae":
		campaign_state.copy_current_slot_schedule(previous_protagonist, "agent_kwon_narae")
	var episode_path := String(save_data.get("episode_path", DEFAULT_EPISODE_PATH))
	if episode_path.is_empty():
		episode_path = DEFAULT_EPISODE_PATH
	if not load_episode(episode_path):
		return false

	set_selected_agent_ids(saved_team if not saved_team.is_empty() else ["agent_kwon_narae", "agent_oh_hyun", "agent_kang_ijun"])
	_ensure_kwon_protagonist()
	flags = _to_unique_string_array(save_data.get("flags", []))
	seen_hint_ids = _to_unique_string_array(save_data.get("seen_hint_ids", []))
	seen_log_tutorial_ids = _to_unique_string_array(save_data.get("seen_log_tutorial_ids", []))
	minigame_results = _to_dictionary(save_data.get("minigame_results", {}))
	method_results = _to_dictionary(save_data.get("method_results", {}))
	agent_trust = _to_dictionary(save_data.get("agent_trust", save_data.get("agent_trust_changes", {})))
	for agent_id in agent_trust.keys():
		agent_trust[agent_id] = clampi(int(agent_trust.get(agent_id, 0)), AGENT_TRUST_MIN, AGENT_TRUST_MAX)
	agent_trust_changes = agent_trust.duplicate(true)
	triggered_agent_event_ids = _to_unique_string_array(save_data.get("triggered_agent_event_ids", []))
	used_agent_supports = _to_unique_string_array(save_data.get("used_agent_supports", []))
	_migrate_mvp043_support_aliases()
	unlocked_records = _to_unique_string_array(save_data.get("unlocked_records", []))
	unlocked_equipment = _to_unique_string_array(save_data.get("unlocked_equipment", []))
	unlocked_research_rewards = _to_unique_string_array(save_data.get("unlocked_research_rewards", []))
	equipped_items = _to_unique_string_array(save_data.get("equipped_items", []))
	for equipment_id in equipped_items.duplicate():
		if not unlocked_equipment.has(String(equipment_id)):
			equipped_items.erase(equipment_id)
	used_equipment_effects = _to_unique_string_array(save_data.get("used_equipment_effects", []))
	completed_case_reports = _to_dictionary_array(save_data.get("completed_case_reports", []))
	anomaly_manual_records = _to_dictionary(save_data.get("anomaly_manual_records", {}))
	completed_daily_episode_records = _to_dictionary_array(save_data.get("completed_daily_episode_records", []))
	active_daily_episode = _to_dictionary(save_data.get("active_daily_episode", {}))
	echo_fragments = maxi(0, int(save_data.get("echo_fragments", 30)))
	granted_reward_ids = _to_unique_string_array(save_data.get("granted_reward_ids", []))
	faction_relations = _to_dictionary(save_data.get("faction_relations", {}))
	for faction_id in faction_relations:
		faction_relations[faction_id] = clampi(int(faction_relations[faction_id]), -100, 100)
	triggered_faction_event_ids = _to_unique_string_array(save_data.get("triggered_faction_event_ids", []))
	completed_faction_request_ids = _to_unique_string_array(save_data.get("completed_faction_request_ids", []))
	purchased_market_item_ids = _to_unique_string_array(save_data.get("purchased_market_item_ids", []))
	consumable_inventory = _to_dictionary(save_data.get("consumable_inventory", {}))
	consumable_loadout = _to_dictionary(save_data.get("consumable_loadout", {}))
	active_consumable_effects = _to_dictionary(save_data.get("active_consumable_effects", {}))
	rewarded_resolution_grades = _to_dictionary(save_data.get("rewarded_resolution_grades", {}))
	investigation_risk = clampi(int(save_data.get("anomaly_risk", save_data.get("investigation_risk", 0))), 0, 100)
	case_understanding = clampi(int(save_data.get("anomaly_understanding", save_data.get("case_understanding", 0))), 0, 100)
	victim_understanding = clampi(int(save_data.get("victim_understanding", 0)), 0, 100)
	var loaded_stability := clampi(int(save_data.get("anomaly_stability", 100)), 0, 100)
	var loaded_stability_schema := int(save_data.get("stability_schema_version", 1))
	case_anomaly_stability = loaded_stability if loaded_stability_schema >= STABILITY_SCHEMA_VERSION else 100 - loaded_stability
	mental_stamina = clampi(int(save_data.get("mental_stamina", 100)), 0, 100)
	prediction_success_streak = max(0, int(save_data.get("prediction_success_streak", 0)))
	prediction_failure_streak = max(0, int(save_data.get("prediction_failure_streak", 0)))
	last_random_event_id = String(save_data.get("last_random_event_id", ""))
	last_random_event_result = _to_dictionary(save_data.get("last_random_event_result", {}))
	forced_recovery_phase = bool(save_data.get("forced_recovery_phase", false)) or investigation_risk >= 100
	if forced_recovery_phase:
		add_flag("forced_recovery_phase")
	_apply_collected_clue_ids(_to_string_array(save_data.get("collected_clue_ids", [])))

	selected_resolution_grade = String(save_data.get("selected_resolution_grade", ""))
	selected_resolution_label = String(save_data.get("selected_resolution_label", ""))
	if selected_resolution_label.is_empty() and not selected_resolution_grade.is_empty():
		selected_resolution_label = _get_resolution_label_for_grade(selected_resolution_grade)
	selected_resolution_rate = float(save_data.get("selected_resolution_rate", get_clue_collection_rate()))

	recovery_successful = bool(save_data.get("capture_success", false))
	recovery_result_status = String(save_data.get("capture_result_state", ""))
	recovery_result_stability = int(save_data.get("capture_result_stability", 100))
	if recovery_successful:
		add_flag(FLAG_CAPTURE_SUCCESS)

	current_scene_path = String(save_data.get("current_scene_path", SCENE_DIALOGUE))
	if current_scene_path.is_empty():
		current_scene_path = SCENE_DIALOGUE
	if current_scene_path == SCENE_DAILY_EPISODE and get_active_daily_episode_data().is_empty():
		current_scene_path = SCENE_PREPARATION

	current_dialogue_node_id = String(save_data.get("current_dialogue_node_id", DEFAULT_DIALOGUE_NODE_ID))
	if current_dialogue_node_id.is_empty():
		current_dialogue_node_id = DEFAULT_DIALOGUE_NODE_ID
	current_field_node_id = String(save_data.get("current_field_node_id", ""))
	if current_field_node_id.is_empty():
		current_field_node_id = map_legacy_dialogue_node_to_field_node(current_dialogue_node_id)
	current_recovery_pattern_id = String(save_data.get("current_recovery_pattern_id", ""))
	last_recovery_pattern_id = String(save_data.get("last_recovery_pattern_id", ""))
	confirmed_recovery_pattern_id = String(save_data.get("confirmed_recovery_pattern_id", ""))
	seen_recovery_pattern_ids = _to_unique_string_array(save_data.get("seen_recovery_pattern_ids", []))
	recovery_pattern_learning = _to_dictionary(save_data.get("recovery_pattern_learning", {}))

	current_minigame_id = String(save_data.get("current_minigame_id", DEFAULT_MINIGAME_ID))
	if current_minigame_id.is_empty():
		current_minigame_id = DEFAULT_MINIGAME_ID

	agent_case_states = _to_dictionary(save_data.get("agent_case_states", {}))
	if agent_case_states.is_empty():
		for agent_id in selected_agent_ids:
			_ensure_agent_case_state(String(agent_id))
	else:
		for agent_id in selected_agent_ids:
			var sid := String(agent_id)
			if not agent_case_states.has(sid):
				_ensure_agent_case_state(sid)
			else:
				var state := _to_dictionary(agent_case_states.get(sid, {}))
				state["hp"] = clampi(int(state.get("hp", get_agent_max_hp(sid))), 0, get_agent_max_hp(sid))
				state["mental"] = clampi(int(state.get("mental", get_agent_max_mental(sid))), 0, get_agent_max_mental(sid))
				state["protection_amount"] = maxi(0, int(state.get("protection_amount", 1 if bool(state.get("protection_active", false)) else 0)))
				state.erase("protection_active")
				agent_case_states[sid] = state
	victim_state = _to_dictionary(save_data.get("victim_state", {}))
	return true


## Returns true when the save file exists.
func has_save_file() -> bool:
	return FileAccess.file_exists(SAVE_FILE_PATH)


## Deletes the save file if it exists.
func clear_save_file() -> bool:
	if not has_save_file():
		return true

	var error := DirAccess.remove_absolute(SAVE_FILE_PATH)
	return error == OK


## Returns the user:// save file path.
func get_save_file_path() -> String:
	return SAVE_FILE_PATH


func _make_save_data() -> Dictionary:
	return {
		"save_version": SAVE_VERSION,
		"campaign_state": campaign_state.to_save_data(),
		"last_updated_at": Time.get_datetime_string_from_system(false, true),
		"episode_id": get_current_episode_id(),
		"episode_path": current_episode_path,
		"current_scene_path": get_current_scene_path(),
		"current_dialogue_node_id": get_current_dialogue_node_id(),
		"current_field_node_id": get_current_field_node_id(),
		"current_minigame_id": get_current_minigame_id(),
		"selected_agent_ids": get_selected_agent_ids(),
		"flags": get_flags(),
		"minigame_results": get_minigame_results(),
		"method_results": get_method_results(),
		"agent_trust_changes": get_agent_trust_changes(),
		"agent_trust": get_agent_trust_values(),
		"triggered_agent_event_ids": get_triggered_agent_event_ids(),
		"used_agent_supports": get_used_agent_supports(),
		"unlocked_records": get_unlocked_records(),
		"unlocked_equipment": get_unlocked_equipment(),
		"unlocked_research_rewards": get_unlocked_research_rewards(),
		"equipped_items": get_equipped_items(),
		"used_equipment_effects": get_used_equipment_effects(),
		"completed_case_reports": get_completed_case_reports(),
		"anomaly_manual_records": get_anomaly_manual_records(),
		"completed_daily_episode_records": get_completed_daily_episode_records(),
		"active_daily_episode": get_active_daily_episode(),
		"echo_fragments": echo_fragments,
		"granted_reward_ids": granted_reward_ids.duplicate(),
		"faction_relations": faction_relations.duplicate(true),
		"triggered_faction_event_ids": triggered_faction_event_ids.duplicate(),
		"completed_faction_request_ids": completed_faction_request_ids.duplicate(),
		"purchased_market_item_ids": purchased_market_item_ids.duplicate(),
		"consumable_inventory": consumable_inventory.duplicate(true),
		"consumable_loadout": consumable_loadout.duplicate(true),
		"active_consumable_effects": active_consumable_effects.duplicate(true),
		"rewarded_resolution_grades": rewarded_resolution_grades.duplicate(true),
		"investigation_risk": investigation_risk,
		"case_understanding": case_understanding,
		"victim_understanding": victim_understanding,
		"anomaly_risk": investigation_risk,
		"anomaly_understanding": case_understanding,
		"anomaly_stability": case_anomaly_stability,
		"stability_schema_version": STABILITY_SCHEMA_VERSION,
		"mental_stamina": mental_stamina,
		"prediction_success_streak": prediction_success_streak,
		"prediction_failure_streak": prediction_failure_streak,
		"current_recovery_pattern_id": current_recovery_pattern_id,
		"last_recovery_pattern_id": last_recovery_pattern_id,
		"confirmed_recovery_pattern_id": confirmed_recovery_pattern_id,
		"seen_recovery_pattern_ids": seen_recovery_pattern_ids.duplicate(),
		"recovery_pattern_learning": recovery_pattern_learning.duplicate(true),
		"last_random_event_id": last_random_event_id,
		"last_random_event_result": last_random_event_result,
		"forced_recovery_phase": forced_recovery_phase,
		"collected_clue_ids": get_collected_clue_ids(),
		"seen_hint_ids": get_seen_hint_ids(),
		"seen_log_tutorial_ids": get_seen_log_tutorial_ids(),
		"selected_resolution_grade": selected_resolution_grade,
		"selected_resolution_label": selected_resolution_label,
		"selected_resolution_rate": selected_resolution_rate,
		"capture_success": recovery_successful,
		"capture_result_state": recovery_result_status,
		"capture_result_stability": recovery_result_stability,
		"agent_case_states": agent_case_states.duplicate(true),
		"victim_state": victim_state.duplicate(true)
	}


func _set_clue_collected_without_save(clue_id: String, collected: bool) -> void:
	current_episode_data = CaseDataScript.set_clue_collected(current_episode_data, clue_id, collected)


func _apply_collected_clue_ids(clue_ids: Array) -> void:
	current_episode_data = CaseDataScript.reset_clue_collection(current_episode_data)
	for clue_id in clue_ids:
		_set_clue_collected_without_save(String(clue_id), true)


func _make_minigame_effect_data(minigame: Dictionary, successful: bool) -> Dictionary:
	var prefix := "success" if successful else "failure"
	return {
		"add_flags": minigame.get("%s_flags" % prefix, []),
		"collect_clues": minigame.get("%s_collect_clues" % prefix, []),
		"show_hint_ids": minigame.get("%s_show_hint_ids" % prefix, []),
		"anomaly_risk_delta": int(minigame.get("%s_anomaly_risk_delta" % prefix, 0)),
		"anomaly_understanding_delta": int(minigame.get("%s_anomaly_understanding_delta" % prefix, 0)),
		"anomaly_stability_delta": int(minigame.get("%s_anomaly_stability_delta" % prefix, 0)),
		"mental_stamina_delta": int(minigame.get("%s_mental_stamina_delta" % prefix, 0))
	}


func _clear_resolution_phase_selection() -> void:
	selected_resolution_grade = ""
	selected_resolution_label = ""
	selected_resolution_rate = 0.0


func _clear_recovery_result() -> void:
	recovery_successful = false
	recovery_result_status = ""
	recovery_result_stability = 100
	remove_flag(FLAG_CAPTURE_SUCCESS)


func _is_allowed_agent_temperament(agent: Dictionary) -> bool:
	return ALLOWED_AGENT_TEMPERAMENTS.has(String(agent.get("temperament", "")))


func _find_best_selected_agent_for_stat(stat_key: String) -> Dictionary:
	var best_agent: Dictionary = {}
	var best_value := -1
	for agent in get_selected_agents():
		var agent_id := String(agent.get("id", ""))
		var value := get_agent_investigation_stat(agent_id, stat_key)
		if value > best_value:
			best_value = value
			best_agent = agent
	return best_agent


func _get_effect_int(effect_data: Dictionary, keys: Array) -> int:
	for key in keys:
		var text_key := String(key)
		if effect_data.has(text_key):
			return int(effect_data.get(text_key, 0))
	return 0


func _get_prediction_decay_multiplier() -> float:
	if prediction_success_streak <= 0:
		return 1.0
	if prediction_success_streak == 1:
		return 0.5
	if prediction_success_streak == 2:
		return 0.25
	return 0.125


func _get_prediction_success_text() -> String:
	var candidates := [
		"다음 변화는 안내방송의 잡음 직후에 옵니다. 안정화 타이밍을 맞출 수 있습니다.",
		"전광판의 글자가 바뀌기 전에 괴이 안정도가 흔들립니다. 그 순간을 노리면 됩니다.",
		"승강장 조명이 꺼지는 순서가 반복됩니다. 다음 흔들림을 미리 방어할 수 있습니다."
	]
	return candidates[randi_range(0, candidates.size() - 1)]


func _get_random_event_chance() -> int:
	if investigation_risk >= 75:
		return 65
	if investigation_risk >= 50:
		return 45
	if investigation_risk >= 25:
		return 25
	if investigation_risk > 0:
		return 10
	return 5


func _get_random_event_candidates(trigger_tags: Array) -> Array:
	var candidates: Array = []
	var clean_trigger_tags := _to_string_array(trigger_tags)
	var events: Variant = current_episode_data.get("random_events", [])
	if typeof(events) != TYPE_ARRAY:
		return candidates

	for event in events:
		if typeof(event) != TYPE_DICTIONARY:
			continue

		var event_id := String(event.get("id", ""))
		if event_id == last_random_event_id:
			continue
		if investigation_risk < int(event.get("min_anomaly_risk", 0)):
			continue
		if not _event_tags_match(_to_string_array(event.get("trigger_tags", [])), clean_trigger_tags):
			continue
		if not check_conditions(_to_dictionary(event.get("conditions", {}))):
			continue

		candidates.append(event)
	return candidates


func _event_tags_match(event_tags: Array, trigger_tags: Array) -> bool:
	if event_tags.is_empty() or trigger_tags.is_empty():
		return true

	for tag in event_tags:
		if trigger_tags.has(tag):
			return true
	return false


func _pick_weighted_random_event(events: Array) -> Dictionary:
	var total_weight := 0
	for event in events:
		if typeof(event) == TYPE_DICTIONARY:
			total_weight += max(1, int(event.get("weight", 1)))

	var roll := randi_range(1, max(1, total_weight))
	var cursor := 0
	for event in events:
		if typeof(event) != TYPE_DICTIONARY:
			continue

		cursor += max(1, int(event.get("weight", 1)))
		if roll <= cursor:
			return event
	return events[0] if not events.is_empty() else {}


func _make_forced_recovery_event() -> Dictionary:
	forced_recovery_phase = true
	add_flag("forced_recovery_phase")
	last_random_event_id = "forced_recovery_phase"
	last_random_event_result = {
		"triggered": true,
		"id": last_random_event_id,
		"event_type": "threat_event",
		"title": "강제 회수전",
		"message": "괴이 위험도가 100에 도달했습니다. 더 조사하기보다 회수 페이즈 진입을 준비해야 합니다.",
		"effects": {}
	}
	save_game()
	return last_random_event_result.duplicate(true)


func _apply_status_deltas(effect_data: Dictionary) -> void:
	investigation_risk = clampi(
		investigation_risk + _get_effect_int(effect_data, ["anomaly_risk_delta", "investigation_risk_delta"]),
		0,
		100
	)
	case_understanding = clampi(
		case_understanding + _get_effect_int(effect_data, ["anomaly_understanding_delta", "case_understanding_delta"]),
		0,
		100
	)
	victim_understanding = clampi(
		victim_understanding + _get_effect_int(effect_data, ["victim_understanding_delta"]),
		0,
		100
	)
	case_anomaly_stability = clampi(
		case_anomaly_stability - _get_effect_int(effect_data, ["anomaly_stability_delta"]),
		0,
		100
	)
	mental_stamina = clampi(
		mental_stamina + _get_effect_int(effect_data, ["mental_stamina_delta"]),
		0,
		100
	)
	if investigation_risk >= 100:
		forced_recovery_phase = true
		add_flag("forced_recovery_phase")


func _apply_method_trust_rules(method: Dictionary, successful: bool, helper_agent_id: String) -> Array:
	var changes: Array = []
	var rules: Array = method.get("trust_rules", [])
	var agent := get_agent_by_id(helper_agent_id)
	if agent.is_empty() or not selected_agent_ids.has(helper_agent_id):
		return changes

	var temperament := String(agent.get("temperament", ""))
	var rule := _find_trust_rule_for_temperament(rules, temperament)
	if rule.is_empty():
		return changes

	var delta_key := "success_delta" if successful else "failure_delta"
	var text_key := "success_text" if successful else "failure_text"
	var delta := int(rule.get(delta_key, 0))
	var reaction_text := String(rule.get(text_key, ""))
	if delta != 0:
		_add_agent_trust_delta(helper_agent_id, delta)

	if delta != 0 or not reaction_text.is_empty():
		changes.append({
			"agent_id": helper_agent_id,
			"agent_name": String(agent.get("name", "")),
			"temperament": temperament,
			"temperament_label": String(agent.get("temperament_label", "")),
			"is_helper": true,
			"delta": delta,
			"total": get_agent_trust_delta(helper_agent_id),
			"text": reaction_text
		})
	return changes


func _find_trust_rule_for_temperament(rules: Array, temperament: String) -> Dictionary:
	for rule in rules:
		if typeof(rule) == TYPE_DICTIONARY and String(rule.get("temperament", "")) == temperament:
			return rule
	return {}


func _add_agent_trust_delta(agent_id: String, delta: int) -> void:
	if agent_id.strip_edges().is_empty() or not selected_agent_ids.has(agent_id):
		return

	var next_value := clampi(get_agent_trust(agent_id) + delta, AGENT_TRUST_MIN, AGENT_TRUST_MAX)
	agent_trust[agent_id] = next_value
	agent_trust_changes[agent_id] = next_value


func _try_trigger_agent_trust_events() -> Array:
	var triggered_events: Array = []
	for event in AGENT_TRUST_EVENTS:
		var event_id := String(event.get("id", ""))
		var agent_id := String(event.get("agent_id", ""))
		if event_id.is_empty() or not selected_agent_ids.has(agent_id):
			continue
		if triggered_agent_event_ids.has(event_id):
			continue
		if get_agent_trust(agent_id) < int(event.get("required_trust", 2)):
			continue
		triggered_agent_event_ids.append(event_id)
		triggered_events.append(event.duplicate(true))
	return triggered_events


func _get_triggered_agent_event_entries() -> Array:
	var events: Array = []
	for event in AGENT_TRUST_EVENTS:
		var event_id := String(event.get("id", ""))
		var agent_id := String(event.get("agent_id", ""))
		if selected_agent_ids.has(agent_id) and triggered_agent_event_ids.has(event_id):
			events.append(event.duplicate(true))
	return events


func _get_case_report_next_notes(records: Array, equipment: Array, agents: Array) -> Array:
	var notes: Array = []
	for record in records:
		if typeof(record) == TYPE_DICTIONARY:
			var effect := String(record.get("next_investigation_effect", ""))
			if not effect.is_empty():
				notes.append("%s: %s" % [String(record.get("title", "기록물")), effect])
	for item in equipment:
		if typeof(item) == TYPE_DICTIONARY:
			var modifier := String(item.get("next_investigation_modifier", ""))
			if not modifier.is_empty():
				notes.append("%s: %s" % [String(item.get("name", "장비")), modifier])
	if not agents.is_empty():
		notes.append("선택 요원의 수사 파트너 신뢰도는 후속 사건의 반응과 보조 안내에 기록됩니다.")
	return notes.slice(0, 3)


func _get_new_string_ids(before_ids: Array, after_ids: Array) -> Array:
	var new_ids: Array = []
	for after_id in _to_string_array(after_ids):
		if not before_ids.has(after_id):
			new_ids.append(after_id)
	return new_ids


func _clear_investigation_method_state() -> void:
	_apply_initial_anomaly_status()
	method_results.clear()
	agent_trust_changes.clear()
	agent_trust.clear()
	triggered_agent_event_ids.clear()
	used_agent_supports.clear()


func _apply_resolution_unlocks(resolution_grade: String) -> void:
	for record_id in _get_result_record_ids_for_grade(resolution_grade):
		_unlock_unique(unlocked_records, record_id)

	for reward_id in _get_result_research_reward_ids_for_grade(resolution_grade):
		_unlock_unique(unlocked_research_rewards, reward_id)

	for equipment_id in _get_result_equipment_ids_for_grade(resolution_grade):
		_unlock_unique(unlocked_equipment, equipment_id)
		_unlock_unique(equipped_items, equipment_id)


func _get_result_record_ids_for_grade(resolution_grade: String) -> Array:
	return _get_result_unlock_ids_for_grade(resolution_grade, "unlocks_records")


func _get_result_research_reward_ids_for_grade(resolution_grade: String) -> Array:
	return _get_result_unlock_ids_for_grade(resolution_grade, "unlocks_research_rewards")


func _get_result_equipment_ids_for_grade(resolution_grade: String) -> Array:
	return _get_result_unlock_ids_for_grade(resolution_grade, "unlocks_equipment")


func _get_result_unlock_ids_for_grade(resolution_grade: String, unlock_key: String) -> Array:
	var result := CaseDataScript.get_recovery_result_for_grade(current_episode_data, resolution_grade)
	return _to_string_array(result.get(unlock_key, []))


func _unlock_unique(target: Array, item_id: String) -> void:
	var clean_id := item_id.strip_edges()
	if clean_id.is_empty() or target.has(clean_id):
		return

	target.append(clean_id)


func _get_entries_by_ids(entries: Array, ids: Array) -> Array:
	var result: Array = []
	for item_id in _to_string_array(ids):
		for entry in entries:
			if typeof(entry) == TYPE_DICTIONARY and String(entry.get("id", "")) == item_id:
				result.append(entry)
				break
	return result


func _apply_initial_anomaly_status() -> void:
	var status := _to_dictionary(current_episode_data.get("anomaly_status", {}))
	investigation_risk = clampi(int(status.get("anomaly_risk", 0)), 0, 100)
	case_understanding = clampi(int(status.get("anomaly_understanding", 0)), 0, 100)
	victim_understanding = clampi(int(status.get("victim_understanding", 0)), 0, 100)
	# Episode data before MVP-033 authored stability as 100 unstable -> 0 stable.
	case_anomaly_stability = 100 - clampi(int(status.get("anomaly_stability", 100)), 0, 100)
	mental_stamina = clampi(int(status.get("mental_stamina", 100)), 0, 100)
	prediction_success_streak = max(0, int(status.get("prediction_success_streak", 0)))
	prediction_failure_streak = 0
	last_random_event_id = ""
	last_random_event_result.clear()
	forced_recovery_phase = bool(status.get("forced_recovery_phase", false))


func _to_unique_string_array(value: Variant) -> Array:
	var result: Array = []
	for item in _to_string_array(value):
		if not result.has(item):
			result.append(item)
	return result


func _to_string_array(value: Variant) -> Array:
	var result: Array = []
	if typeof(value) != TYPE_ARRAY:
		return result

	for item in value:
		var text := String(item).strip_edges()
		if not text.is_empty():
			result.append(text)
	return result


func _to_dictionary(value: Variant) -> Dictionary:
	if typeof(value) == TYPE_DICTIONARY:
		return value.duplicate(true)
	return {}


func _to_dictionary_array(value: Variant) -> Array:
	var dictionaries: Array = []
	if typeof(value) != TYPE_ARRAY:
		return dictionaries
	for item in value:
		if typeof(item) == TYPE_DICTIONARY:
			dictionaries.append(item.duplicate(true))
	return dictionaries


func _get_resolution_rank(grade: String) -> int:
	match grade:
		"temporary":
			return 1
		"standard":
			return 2
		"complete":
			return 3
		_:
			return 0


func _get_resolution_label_for_grade(grade: String) -> String:
	match grade:
		"temporary":
			return "임시 해결 가능"
		"standard":
			return "정식 해결 가능"
		"complete":
			return "완전 해결 가능"
		_:
			return "해결 불가"
