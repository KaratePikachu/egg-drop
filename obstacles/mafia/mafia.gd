extends Node2D
class_name Mafia

@export var detection_dist : float = 500
@export var aim_dist : float = 500
var egg : Egg
var has_ammo := true

func _ready() -> void:
	$Crosshair.hide()

func _process(delta: float) -> void:
	if egg == null:
		var thing := get_tree().get_first_node_in_group("egg")
		if thing is Egg:
			egg = thing
			print(egg)
		return
	
	if absf(egg.global_position.y-global_position.y) < detection_dist:
		if has_ammo:
			$Crosshair.global_position = egg.global_position + aim_dist * Vector2.DOWN
			$Crosshair.show()
			has_ammo = false
	else:
		$Crosshair.hide()


func _on_crosshair_body_entered(body: Node2D) -> void:
	if not $Crosshair.visible:
		return
	
	egg.die.emit()
