extends CharacterBody2D
class_name Egg

@export var radius: float
@export var parachute_terminal_velocity: float
@export var mass: float = 200
@onready var sprite: Sprite2D = $Egg

var stiffness: float = 20.0
var omega: float = 0.0
var damping: float = 3

var tilt_factor: float = -5000.0
var drag_x: float = 20.0

var fan_force = -5

var parachute_open: bool

var theta: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("main_mod"):
		parachute_open = not parachute_open
	
	if Input.is_action_just_pressed("mod_1"):
		fan_force *= -1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:

	var torque = fan_force
	var omega_accel = torque - stiffness * theta - damping * omega
	omega += omega_accel * delta
	theta += omega * delta
	sprite.rotation = theta

	var accel = sin(theta) * tilt_factor - drag_x * velocity.x
	velocity.x += accel * delta

	if parachute_open:
		velocity.y += (parachute_terminal_velocity - velocity.y) * delta * 3
	else:
		velocity.y += (200 * delta)
	move_and_slide()
