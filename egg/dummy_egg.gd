extends Node2D
class_name DummyEgg

@export var parachute_terminal_velocity: float

@export var stiffness: float = 10.0
@export var damping: float = 5

@export var tilt_factor: float = -5000.0
@export var drag_x: float = 20.0
@export var bomb_impulse: float = 800

@export var modifications: Array[Modification]

var omega: float = 0.0
var fan_force = 0
var parachute_open: bool
var theta: float = 0.0

func add_modification(mod: Modification):
	modifications.append(mod)
	_refresh_mods()
	
func remove_modification(mod: Modification):
	modifications.erase(mod)
	_refresh_mods()
	
func set_modifications(mods: Array[Modification]):
	modifications = mods.duplicate()
	_refresh_mods()

func _refresh_mods() -> void:
	for child in get_children():
		if child != $Egg:
			child.queue_free()
	for mod : Modification in modifications:
		mod.used = false
		mod.toggled = false
		if mod.icon_off:
			var icon := Sprite2D.new()
			icon.texture = mod.icon_off
			icon.name = mod.name + "_sprite_off"
			add_child(icon)
		if has_node(mod.name + "_sprite"):
			get_node(mod.name + "_sprite").hide()

func _ready() -> void:
	_refresh_mods()
