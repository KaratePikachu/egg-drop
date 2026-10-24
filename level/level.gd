@tool
extends Node2D
class_name Level

enum Phase{
	MODIFY,
	DROP,
}

static var active_modifications : Array[Modification]
static var levels : Array[String]
@export var level_number : int
@export var win_floor_y : float = 2400:
	set(val):
		win_floor_y = val
		win_floor.position.y = win_floor_y

@export var win_floor : Node2D

@onready var camera : Camera2D = $Camera2D
@onready var mod_menu : ModificationMenu = $CanvasLayer/ModificationMenu

func _ready() -> void:
	camera.limit_top = 0
	camera.limit_bottom = win_floor_y + 100

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("restart_level"):
		restart_level()

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
