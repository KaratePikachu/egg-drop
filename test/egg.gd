extends CharacterBody2D
class_name Egg

@export var radius: float
@export var parachute_terminal_velocity: float
@export var mass: float = 200

@export var stiffness: float = 20.0
@export var damping: float = 3

@export var tilt_factor: float = -5000.0
@export var drag_x: float = 20.0

@export var modifications: Array[Modification]

var omega: float = 0.0
var fan_force = 0
var parachute_open: bool
var theta: float = 0.0

func _refresh_mods() -> void:
	for mod : Modification in modifications:
		mod.used = false
		mod.toggled = false

func _ready() -> void:
	_refresh_mods()

func _input(event: InputEvent) -> void:
	for mod in modifications:
		if not event.is_action_pressed(mod.input):
			continue
		
		if mod.is_single_use and mod.used:
			continue
		
		if mod.is_single_use:
			activate_mod(mod)
			mod.used = true
		else:
			if not mod.toggled:
				activate_mod(mod)
			else:
				deactivate_mod(mod)
		return

func deactivate_mod(mod: Modification) -> void:
	mod.toggled = false
	match mod.name:
		"left_fan":
			fan_force -= -5	
		"right_fan":
			fan_force -= 5
		"basic_umbrella":
			parachute_open = false
	
func activate_mod(mod: Modification) -> void:
	mod.toggled = true
	match mod.name:
		"left_fan":
			fan_force += -5	
		"right_fan":
			fan_force += 5
		"basic_umbrella":
			parachute_open = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:

	var torque = fan_force
	var omega_accel = torque - stiffness * theta - damping * omega
	omega += omega_accel * delta
	theta += omega * delta
	rotation = theta

	var accel = sin(theta) * tilt_factor - drag_x * velocity.x
	velocity.x += accel * delta

	if parachute_open:
		velocity.y += (parachute_terminal_velocity - velocity.y) * delta * 3
	else:
		velocity.y += (200 * delta)
	move_and_slide()
