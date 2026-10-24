extends Button

@export var modification : Modification


func _on_toggled(toggled_on: bool) -> void:
	if modification == null:
		printerr("No modification attached to button")
		return
	
	if toggled_on:
		Level.add_mod(modification)
	else:
		Level.remove_mod(modification)
