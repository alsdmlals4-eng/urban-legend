from pathlib import Path

path = Path("scripts/poc/annual_mvp_001/annual_mvp_001_state.gd")
text = path.read_text(encoding="utf-8")
if "func build_save_payload()" in text:
    raise SystemExit(0)
needle = '''func confirm_quarter_summary() -> Dictionary:
\tif _phase != "QUARTER_SUMMARY":
\t\treturn _response(false, "확인할 분기 결산이 없다.", false)
\t_phase = "COMPLETE"
\treturn _response(true, "", true, [{"event": "annual_mvp_001_completed"}])


func _refresh_institution_unlocks() -> void:
'''
insert = '''func confirm_quarter_summary() -> Dictionary:
\tif _phase != "QUARTER_SUMMARY":
\t\treturn _response(false, "확인할 분기 결산이 없다.", false)
\t_phase = "COMPLETE"
\treturn _response(true, "", true, [{"event": "annual_mvp_001_completed"}])


func build_save_payload() -> Dictionary:
\tif _phase in ["BOOT", "INCIDENT_ACTIVE"]:
\t\treturn {}
\treturn {
\t\t"save_version": "annual-mvp-001-save-v1",
\t\t"state": get_snapshot()
\t}


func restore(config: Dictionary, payload: Dictionary) -> Dictionary:
\tif String(payload.get("save_version", "")) != "annual-mvp-001-save-v1":
\t\treturn _response(false, "지원하지 않는 연도제 저장 버전이다.", false)
\tvar saved_value: Variant = payload.get("state")
\tif typeof(saved_value) != TYPE_DICTIONARY:
\t\treturn _response(false, "연도제 저장 상태가 없다.", false)
\tvar saved := saved_value as Dictionary
\tvar saved_phase := String(saved.get("phase", ""))
\tvar allowed_phases := [
\t\t"WEEK_PLANNING", "WEEK_RESULT", "DEPLOYMENT_DECISION", "PREPARATION",
\t\t"INCIDENT_RESULT", "POST_INCIDENT_RESEARCH", "QUARTER_SUMMARY", "COMPLETE"
\t]
\tif not allowed_phases.has(saved_phase):
\t\treturn _response(false, "저장할 수 없는 연도제 단계다.", false)
\tvar started := start(config, int(saved.get("run_seed", 2001)))
\tif not bool(started.get("ok", false)):
\t\treturn started
\t_phase = saved_phase
\t_week = int(saved.get("week", 1))
\t_planned_activity_ids = _string_array(saved.get("planned_activity_ids", []))
\t_last_week_result = (saved.get("last_week_result", {}) as Dictionary).duplicate(true)
\t_competencies = (saved.get("competencies", {}) as Dictionary).duplicate(true)
\t_fatigue = clampi(int(saved.get("fatigue", 0)), 0, 100)
\t_institution_support = clampi(int(saved.get("institution_support", 0)), 0, 3)
\t_residual_data = maxi(0, int(saved.get("residual_data", 0)))
\t_companion_trust = (saved.get("companion_trust", {}) as Dictionary).duplicate(true)
\t_research_progress = (saved.get("research_progress", {}) as Dictionary).duplicate(true)
\t_completed_research_ids = _string_array(saved.get("completed_research_ids", []))
\t_unlocked_module_ids = _string_array(saved.get("unlocked_module_ids", []))
\t_unlocked_skill_ids = _string_array(saved.get("unlocked_skill_ids", []))
\t_selected_companion_id = String(saved.get("selected_companion_id", ""))
\t_selected_public_skill_id = String(saved.get("selected_public_skill_id", ""))
\t_equipped_module_ids = _string_array(saved.get("equipped_module_ids", []))
\t_deployment_risk = clampi(int(saved.get("deployment_risk", 0)), 0, 100)
\t_forced_deployment = bool(saved.get("forced_deployment", false))
\t_incident_result = (saved.get("incident_result", {}) as Dictionary).duplicate(true)
\t_manual_delta = (saved.get("manual_delta", {}) as Dictionary).duplicate(true)
\t_support_log = _dictionary_array(saved.get("support_log", []))
\t_quarter_summary = (saved.get("quarter_summary", {}) as Dictionary).duplicate(true)
\t_run_seed = int(saved.get("run_seed", 2001))
\t_refresh_institution_unlocks()
\treturn _response(true, "", true, [{"event": "annual_mvp_001_restored"}])


func _string_array(value: Variant) -> Array[String]:
\tvar result: Array[String] = []
\tif typeof(value) != TYPE_ARRAY:
\t\treturn result
\tfor item in value as Array:
\t\tresult.append(String(item))
\treturn result


func _dictionary_array(value: Variant) -> Array[Dictionary]:
\tvar result: Array[Dictionary] = []
\tif typeof(value) != TYPE_ARRAY:
\t\treturn result
\tfor item in value as Array:
\t\tif typeof(item) == TYPE_DICTIONARY:
\t\t\tresult.append((item as Dictionary).duplicate(true))
\treturn result


func _refresh_institution_unlocks() -> void:
'''
if needle not in text:
    raise SystemExit("annual state save insertion point not found")
path.write_text(text.replace(needle, insert), encoding="utf-8")
