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
	Level.load_level(level_number+1)

func restart_level() -> void:
	Level.load_level(level_number,false)

static func load_level(level_num : int, reset_active_modifications : bool = true) -> void:
	if reset_active_modifications:
		active_modifications.clear()
	SceneChanger.change_to_file(levels[level_num-1])
#endregion
