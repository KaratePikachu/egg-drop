extends Control
class_name EndScreen

@export var level: Level
@export var did_win: bool = true

func _ready() -> void:
	hide()

func appear() -> void:
	if visible:
		return
	
	show()
	if not did_win:
		$"Panel/MarginContainer/VBoxContainer/Next Level".queue_free()
		$Panel/MarginContainer/VBoxContainer/Status.text = "Try Again!"

func _on_retry_pressed() -> void:
	get_tree().reload_current_scene()

func _on_next_level_pressed() -> void:
	level.next_level()

func _on_level_select_pressed() -> void:
	MainMenu.go_to_level_select = true
	get_tree().change_scene_to_file("res://ui/main_menu/main_menu.tscn")
