extends AudioStreamPlayer

enum Type{
	MM,
	LEVEL
}

var type : Type = Type.MM

func play_level() -> void:
	type = Type.LEVEL
	#stream = 
