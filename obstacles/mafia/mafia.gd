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
	
	if $Crosshair.visible:
		var pos : Vector2 = $Crosshair.global_position
		$Crosshair.global_position = pos.move_toward(egg.global_position,500*delta)
	
	if absf(egg.global_position.y-global_position.y) < detection_dist:
		if has_ammo:
			$Crosshair.global_position = egg.global_position
			$Crosshair.show()
			has_ammo = false
			await get_tree().create_timer(1.0).timeout
			var bodies :Array[Node2D]= $Crosshair.get_overlapping_bodies()
			if bodies.has(egg):
				egg.death()
			$Crosshair.hide()
	
	var x_diff := egg.global_position.x-global_position.x
	if x_diff > 0:
		$MafiaGuyBodyArt.flip_h = false
		$Arm/MafiaGuyArmArt.flip_h = false
	else:
		$MafiaGuyBodyArt.flip_h = true
		$Arm/MafiaGuyArmArt.flip_h = true

#
#func _on_crosshair_body_entered(body: Node2D) -> void:
	#if not $Crosshair.visible:
		#return
	#
	#egg.death()
