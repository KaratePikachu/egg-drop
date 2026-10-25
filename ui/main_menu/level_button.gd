@tool
extends Button
class_name LevelButton

@onready var SFXSelect = $SFXSelect

@export var level_num : int:
	set(val):
		level_num = val
		$LevelNum.text = str(level_num)
	
func _on_pressed() -> void:
	SFXSelect.play()
	await get_tree().create_timer(1.0).timeout
	Level.load_level(level_num-1)
