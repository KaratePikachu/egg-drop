@tool
extends Node2D
class_name Level

enum Phase{
	INITIAL_PAN,
	MODIFY,
	DROP,
}

static var entering_new_level : bool = true
static var active_modifications : Array[Modification]
static var levels : Array[String]
@export var level_number : int
@export var win_floor_y : float = 2400:
	set(val):
		win_floor_y = val
		win_floor.position.y = win_floor_y

@export var win_floor : Node2D

var camera_min_y : float
var camera_max_y : float
var current_phase : Phase
var panning : bool = false

@onready var camera : Camera2D = $Camera2D
@onready var mod_menu : ModificationMenu = $CanvasLayer/ModificationMenu

func _ready() -> void:
	camera_min_y = 0.5*camera.get_viewport_rect().size.y
	camera_max_y = win_floor_y-0.5*camera.get_viewport_rect().size.y + 100
	
	if entering_new_level:
		active_modifications = []
		current_phase = Phase.INITIAL_PAN
		mod_menu.hide()
		entering_new_level = false
		camera.position_smoothing_enabled = false
		camera.position.y = camera_max_y
		await get_tree().process_frame
		camera.position_smoothing_enabled = true
		await get_tree().create_timer(0.5).timeout
		var tween := get_tree().create_tween()
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(camera,"position:y",camera_min_y,(camera_max_y-camera_min_y)/500.0)
		await tween.finished
		current_phase = Phase.MODIFY
		mod_menu.play_appear_animation()
	else:
		current_phase = Phase.MODIFY
		
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("restart_level"):
		restart_level()
	
	match current_phase:
		Phase.MODIFY:
			if event.is_action_pressed("scroll_up"):
				move_camera(-50)
			elif event.is_action_pressed("scroll_down"):
				move_camera(50)
			elif event.is_action_pressed("pan"):
				panning = true
			elif event.is_action_released("pan"):
				panning = false
			elif event is InputEventMouseMotion and panning:
				move_camera(-event.relative.y)
		Phase.DROP:
			pass

func move_camera(delta : float) -> void:
	camera.position.y = clampf(
		camera.position.y + delta,
		camera_min_y,
		camera_max_y
	)
	

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
	get_tree().reload_current_scene()

static func load_level(level_num : int) -> void:
	entering_new_level = true
	SceneChanger.change_to_file(levels[level_num-1])
#endregion
