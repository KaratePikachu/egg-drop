extends Control

@onready var main_menu : Control = $MainMenu
@onready var level_select : Control = $LevelSelect
func _ready() -> void:
	main_menu.show()
