extends SceneTree

const Data = preload("res://scripts/poc/annual_mvp_001/annual_mvp_001_data.gd")

func _init() -> void:
	var valid := Data.load_config("res://data/poc/annual_mvp_001/spring_vertical_slice.json")
	assert(not valid.is_empty())
	assert(Data.validate_config(valid).is_empty())
	assert(Data.load_config("res://missing.json").is_empty())
	var broken_days := valid.duplicate(true)
	broken_days["campaign"]["days_per_week"] = 6
	assert(not Data.validate_config(broken_days).is_empty())
	var broken_cost := valid.duplicate(true)
	broken_cost["activities"][0]["day_cost"] = 0
	assert(not Data.validate_config(broken_cost).is_empty())
	var broken_rest := valid.duplicate(true)
	broken_rest["activities"][6]["status_recovery_eligible"] = false
	assert(not Data.validate_config(broken_rest).is_empty())
	print("ANNUAL MVP 001 DATA: PASS")
	quit()
