@tool
extends Area2D

@export var collision_shape : CollisionShape2D

@export var wind_speed : float:
	set(val):
		wind_speed = val
		if Engine.is_editor_hint():
			_update_shape()
@export var size : Vector2:
	set(val):
		size = val
		if Engine.is_editor_hint():
			_update_shape()

func _ready() -> void:
	if not Engine.is_editor_hint():
		_update_shape()

func _update_shape() -> void:
	var shape : RectangleShape2D = RectangleShape2D.new()
	shape.size = size
	collision_shape.shape = shape
	if wind_speed > 0:
		$CPUParticles2D.position.x = -0.5*size.x
		$CPUParticles2D.direction = Vector2.RIGHT
	else:
		$CPUParticles2D.position.x = 0.5*size.x
		$CPUParticles2D.direction = Vector2.LEFT
	
	$CPUParticles2D.emission_rect_extents.y = 0.5*size.y
	$CPUParticles2D.initial_velocity_min = absf(75 * wind_speed)
	$CPUParticles2D.initial_velocity_max = absf(200 * wind_speed)

func _on_body_entered(body: Node2D) -> void:
	if body is Egg:
		body.fan_force += -wind_speed


func _on_body_exited(body: Node2D) -> void:
	if body is Egg:
		body.fan_force -= -wind_speed
