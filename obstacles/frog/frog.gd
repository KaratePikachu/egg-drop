@tool
extends Node2D

@export var swing_freq : float
@export var swing_amp : float
@export var freq_offset : float

var time : float = 0

func _process(delta: float) -> void:
	time += delta
	
	$Node2D.rotation_degrees = swing_amp * sin((freq_offset + time) * swing_freq)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Egg:
		body.death()
