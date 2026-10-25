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
static var levels : Array[String] = [
	"res://level/levels/level_1.tscn",
	
]
@export var level_number : int
var win_floor_y : float

@export var win_floor : Node2D

@export var egg_scene: PackedScene



var camera_min_y : float
var camera_max_y : float
var current_phase : Phase
var panning : bool = false

@onready var camera : Camera2D = $Camera2D
@onready var mod_menu : ModificationMenu = $CanvasLayer/ModificationMenu
@export var end_screen: PackedScene
static var dummy_egg: DummyEgg

var egg: Egg = null

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	dummy_egg = $DummyEgg
	dummy_egg.set_modifications(active_modifications)
	win_floor_y = win_floor.position.y
	camera_min_y = 0.5*camera.get_viewport_rect().size.y/camera.zoom.y
	camera_max_y = win_floor_y-0.5* camera.get_viewport_rect().size.y/camera.zoom.y + 100
	print(camera_min_y, " ",camera_max_y)
	
	mod_menu.drop_pressed.connect(start_drop)
	
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
		tween.tween_property(camera,"position:y",camera_min_y,(camera_max_y-camera_min_y)/1000.0)
		await tween.finished
		current_phase = Phase.MODIFY
		mod_menu.play_appear_animation()
	else:
		current_phase = Phase.MODIFY
		
func start_drop() -> void:
	egg = egg_scene.instantiate()
	egg.modifications = active_modifications.duplicate_deep()
	egg.position = dummy_egg.position
	add_child(egg)
	remove_child(dummy_egg)
	mod_menu.queue_free()
	current_phase = Phase.DROP
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("restart_level"):
		restart_level()
	
	match current_phase:
		Phase.MODIFY:
			if event.is_action_pressed("scroll_up"):
				move_camera(-100)
			elif event.is_action_pressed("scroll_down"):
				move_camera(100)
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
	if dummy_egg:
		dummy_egg.set_modifications(active_modifications)

static func remove_mod(modification : Modification) -> void:
	var i : int = find_modification(modification)
	if i == -1:
		return
	active_modifications.remove_at(i)
	if dummy_egg:
		dummy_egg.set_modifications(active_modifications)

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


func _on_win_area_body_entered(body: Node2D) -> void:
	if body != egg:
		return
		
	
	if egg.velocity.y <= egg.parachute_terminal_velocity + 10:
		$CanvasLayer/LevelEnd.did_win = true
	else:
		$CanvasLayer/LevelEnd.did_win = false
	
	$CanvasLayer/LevelEnd.appear()
	
	egg.land()
