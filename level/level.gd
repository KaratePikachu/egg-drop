extends Node2D
class_name Level

enum Phase{
	MODIFY,
	DROP,
}

static var active_modifications : Array[Modification]
static var levels : Array[String]
@export var level_number : int

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass


#region Level Loading
func next_level() -> void:
	SceneChanger.change_to_file(levels[level_number-1+1])


static func load_level(level_num : int) -> void:
	SceneChanger.change_to_file(levels[level_num-1])
#endregion
