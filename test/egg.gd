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

var unused: Array[Modification]
var toggled: Array[Modification]
var untoggled: Array[Modification]

var omega: float = 0.0
var fan_force = 0
var parachute_open: bool
var theta: float = 0.0

func _refresh_mods() -> void:
	unused.clear()
	toggled.clear()
	untoggled.clear()

func _ready() -> void:
	for mod in modifications:
		if mod.is_single_use:
			unused.append(mod)
		else:
			untoggled.append(mod)

func _process(delta: float) -> void:
	for mod in modifications:
		if Input.is_action_just_pressed(mod.input):
			if mod.is_single_use:
				if mod in unused:
					unused.erase(mod)
					activate_mod(mod)
			else:
				if mod in toggled:
					toggled.erase(mod)
					deactivate_mod(mod)
					untoggled.append(mod)
				elif mod in untoggled:
					untoggled.erase(mod)
					activate_mod(mod)
					toggled.append(mod)
			
func deactivate_mod(mod: Modification) -> void:
	match mod.name:
		"left_fan":
			fan_force -= -5	
		"right_fan":
			fan_force -= 5
		"basic_umbrella":
			parachute_open = false
	
func activate_mod(mod: Modification) -> void:
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
