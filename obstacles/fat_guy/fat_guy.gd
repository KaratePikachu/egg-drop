extends Node2D

var fell : bool = false
var vel : float = 0.0
@onready var guy :Sprite2D = $Sprite2D/Guy
@onready var SFXFatguyFall = $SFXFatguyFall
@export var area_2d: Area2D

#func _ready() -> void:
	##_on_danger_zone_body_entered(Egg.new())

func _on_danger_zone_body_entered(body: Node2D) -> void:
	if body is Egg and not fell:
		fell = true
		var tween := get_tree().create_tween()
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(guy,"position:y",-22.0,0.5)
		await tween.finished
		area_2d.monitoring = true
		guy.reparent(self)
		SFXFatguyFall.play()
		$EmptyWindowArt.texture = preload("res://assets/JamfestFall2027Art/JamfestFall2027Art/BrokenWindowArt.png")
		tween = get_tree().create_tween()
		tween.set_trans(Tween.TRANS_QUAD)
		tween.tween_property(guy,"position:y",9418.0,4)
		await tween.finished
		guy.queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Egg:
		body.death()
