class_name ValidationPersistenceInspector
extends RefCounted

const RepositoryScript := preload("res://scripts/core/validation_save_repository.gd")
const PersistenceSummaryScript := preload("res://scripts/core/validation_persistence_summary.gd")

var _repository = RepositoryScript.new()


func configure_repository_path_for_test(path: String) -> void:
	_repository = RepositoryScript.new(path)


func get_repository_paths() -> Dictionary:
	return _repository.get_paths()


func inspect_persistence() -> Dictionary:
	return PersistenceSummaryScript.build(_repository.inspect())
