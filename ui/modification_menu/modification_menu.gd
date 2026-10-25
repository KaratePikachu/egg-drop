@tool
extends Control
class_name ModificationMenu

@export var mod_button_container : GridContainer
@export var available_mods : Array[Modification]:
	set(val):
		available_mods = val
		_reload_available_mods()

var mod_menu_out : bool = false

@onready var animation_player : AnimationPlayer = $AnimationPlayer

func play_appear_animation() -> bool:
	animation_player.play("appear")
	await animation_player.animation_finished
	return true

func _on_tab_pressed() -> void:
	mod_menu_out = !mod_menu_out
	if mod_menu_out:
		animation_player.play("show",0.1)
	else:
		animation_player.play("hide",0.1)

func _reload_available_mods() -> void:
	var mod_buttons : Array[Node] = mod_button_container.get_children()
	for i : int in mod_buttons.size():
		var mb : ModificationButton = mod_buttons[i]
		if i < available_mods.size():
			mb.modification = available_mods[i]
			if Level.find_modification(available_mods[i]) != -1:
				mb.button_pressed = true
		else:
			mb.modification = null
		
	
