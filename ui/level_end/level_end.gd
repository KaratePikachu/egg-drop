extends Control
class_name EndScreen

@export var level: Level
@export var did_win: bool

func _ready() -> void:
	if not did_win:
		$"VBoxContainer/Next Level".queue_free()
		$VBoxContainer/Status.text = "Try Again!"

func _on_retry_pressed() -> void:
	get_tree().reload_current_scene()

func _on_next_level_pressed() -> void:
	level.next_level()

func _on_level_select_pressed() -> void:
	get_tree().change_scene_to_file("res://ui/main_menu/main_menu.tscn")
