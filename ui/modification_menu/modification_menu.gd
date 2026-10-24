extends Control
class_name ModificationMenu

@onready var animation_player : AnimationPlayer = $AnimationPlayer

func _on_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		animation_player.play("show",0.1)
	else:
		animation_player.play("hide",0.1)
