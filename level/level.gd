extends Node2D
class_name Level

static var levels : Array[String]
@export var level_number : int


static func load_level(level_num : int) -> void:
	SceneChanger.change_to_file(levels[level_num-1])

func next_level() -> void:
	SceneChanger.change_to_file(levels[level_number-1+1])
