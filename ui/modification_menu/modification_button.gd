@tool
extends Button
class_name ModificationButton

@export var modification : Modification:
	set(val):
		modification = val
		visible = modification != null


func _on_toggled(toggled_on: bool) -> void:
	if modification == null:
		printerr("No modification attached to button")
		return
	
	if toggled_on:
		Level.add_mod(modification)
	else:
		Level.remove_mod(modification)
