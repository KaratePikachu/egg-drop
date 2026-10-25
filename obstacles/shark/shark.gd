extends Node2D
class_name Shark

var in_motion: bool = false
var motion_timer: float = 0.0

@export var jump_duration: float

@onready var warning = $Warning

@onready var shark: PhysicsBody2D = $Shark

var initial_height: float
var jump_height: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	jump_height = abs(warning.position.y - shark.position.y)
	initial_height = shark.position.y

func _trigger_jump() -> void:
	in_motion = true
	motion_timer = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if in_motion:
		motion_timer += delta
		shark.position.y = initial_height - (-(jump_height/jump_duration ** 2.0) * ((motion_timer-jump_duration)**2) + jump_height)
		if motion_timer >= jump_duration * 2.0:
			queue_free() 

func _on_warning_body_entered(body: Node2D) -> void:
	if body is Egg:
		_trigger_jump()

func _on_shark_area_body_entered(body: Node2D) -> void:
	if body is Egg:
		body.die.emit()
