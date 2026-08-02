extends "res://scripts/core/validation_session.gd"

const PersistenceSummaryScript := preload("res://scripts/core/validation_persistence_summary.gd")


func inspect_persistence() -> Dictionary:
	var inspected: Dictionary = _repository.inspect()
	return PersistenceSummaryScript.build(inspected)
