@tool
extends Button
class_name ModificationButton

@onready var SFX = $SFX

@export var modification : Modification:
	set(val):
		modification = val
		if modification != null:
			$TextureRect.texture = modification.icon
		visible = modification != null


func _on_toggled(toggled_on: bool) -> void:
	if modification == null:
		printerr("No modification attached to button")
		return
	SFX.play()
	if toggled_on:
		Level.add_mod(modification)
	else:
		Level.remove_mod(modification)
