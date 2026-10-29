extends AudioStreamPlayer

enum Type{
	MM,
	LEVEL
}

var type : Type = Type.MM

func play_level() -> void:
	type = Type.LEVEL
	stream = preload("res://assets/music/egg theme.ogg")
	play()

func play_mm() -> void:
	type = Type.MM
	stream = preload("res://No Clipping.wav")
	play()
