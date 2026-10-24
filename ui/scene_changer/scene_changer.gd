extends Control

#var current_switch : String = ""

func _ready() -> void:
	hide()

func change_to_file(path : String) -> void:
	#current_switch = path
	get_tree().change_scene_to_file(path)
	

#func _process(delta: float) -> void:
	#
