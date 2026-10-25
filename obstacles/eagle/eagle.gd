extends Node2D
class_name Eagle

@export var eagle_velocity: float
@onready var eagle: CharacterBody2D = $Eagle
	
func _physics_process(delta: float) -> void:
	eagle.move_and_slide()

func _on_eagle_trigger_body_entered(body: Node2D) -> void:
	eagle.velocity = Vector2(eagle_velocity, 0)

func _on_eagle_hitbox_body_entered(body: Node2D) -> void:
	if body is Egg:
		body.death()
