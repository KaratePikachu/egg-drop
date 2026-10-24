@tool
extends Control
class_name ModificationMenu

@export var available_mods : Array[Modification]:
	set(val):
		available_mods = val
		_reload_available_mods()

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var grid_container : GridContainer = $SlidingArea/Panel/MarginContainer/VBoxContainer/Modifications

func _on_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		animation_player.play("show",0.1)
	else:
		animation_player.play("hide",0.1)

func _reload_available_mods() -> void:
	var mod_buttons : Array[Node] = grid_container.get_children()
	for i : int in grid_container.get_child_count():
		var mb : ModificationButton = mod_buttons[i]
		if i < available_mods.size():
			mb.modification = available_mods[i]
		else:
			mb.modification = null
