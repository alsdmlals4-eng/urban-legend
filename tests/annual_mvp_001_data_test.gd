extends SceneTree

const Data = preload("res://scripts/poc/annual_mvp_001/annual_mvp_001_data.gd")

func _init() -> void:
	var valid := Data.load_config("res://data/poc/annual_mvp_001/spring_vertical_slice.json")
	assert(not valid.is_empty())
	assert(Data.validate_config(valid).is_empty())
	assert(Data.load_config("res://missing.json").is_empty())
	var broken := valid.duplicate(true)
	broken["campaign"]["slots_per_week"] = 2
	assert(not Data.validate_config(broken).is_empty())
	print("ANNUAL MVP 001 DATA: PASS")
	quit()
