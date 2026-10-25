extends Control
class_name MainMenu

static var go_to_level_select : bool = false

@onready var main_menu : Control = $MainMenu
@onready var level_select : Control = $LevelSelect
func _ready() -> void:
	if go_to_level_select:
		go_to_level_select = false
		_on_start_pressed()
	main_menu.show()


func _on_start_pressed() -> void:
	main_menu.hide()
	level_select.show()


func _on_h_slider_value_changed(value: float) -> void:
	print(AudioServer.get_bus_volume_linear(0))
	
	AudioServer.set_bus_volume_linear(0,value*0.01)
