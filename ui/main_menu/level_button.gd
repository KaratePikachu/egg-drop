@tool
extends Button
class_name LevelButton

@export var level_num : int:
	set(val):
		level_num = val
		$LevelNum.text = level_num
	
func _on_pressed() -> void:
	Level.load_level(level_num-1)
