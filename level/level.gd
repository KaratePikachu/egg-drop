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
	print(active_modifications)

#region Changing Active Modifications
static func add_mod(modification : Modification) -> void:
	var i : int = find_modification(modification)
	if i != -1:
		return
	active_modifications.append(modification)

static func remove_mod(modification : Modification) -> void:
	var i : int = find_modification(modification)
	if i == -1:
		return
	active_modifications.remove_at(i)

static func find_modification(modification : Modification) -> int:
	for i : int in range(active_modifications.size()):
		var mod : Modification = active_modifications[i]
		if mod.name == modification.name:
			return i
	return -1
#endregion

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
