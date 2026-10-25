@tool
extends Button
class_name LevelButton

@onready var SFXSelect = $SFXSelect

@export var level_num : int:
	set(val):
		level_num = val
		$LevelNum.text = str(level_num)
	
func _on_pressed() -> void:
	SFXSelect.play(0.15)
	await get_tree().create_timer(0.25).timeout
	Level.load_level(level_num)
