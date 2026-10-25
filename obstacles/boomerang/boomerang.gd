extends Node2D
class_name Boomerang

var in_motion: bool = false
var motion_timer: float = 0.0

@export var jump_duration: float

@onready var warning = $Warning

@onready var shark: PhysicsBody2D = $Boomerang

@export var direction: float = 1.0

@export var fall_speed: float

var initial_height: float
@export var throw_distance: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initial_height = shark.position.x

func _trigger_jump() -> void:
	in_motion = true
	motion_timer = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if in_motion:
		motion_timer += delta
		$Boomerang/BoomSprite.rotation += delta * 5
		shark.position.x = initial_height - ((-(throw_distance/jump_duration ** 2.0) * ((motion_timer-jump_duration)**2) + throw_distance) * direction)
		shark.position.y += delta * fall_speed
		if motion_timer >= jump_duration * 2.0 + 1.0:
			queue_free() 

func _on_warning_body_entered(body: Node2D) -> void:
	if body is Egg:
		_trigger_jump()

func _on_shark_area_body_entered(body: Node2D) -> void:
	if body is Egg:
		body.die.emit()
