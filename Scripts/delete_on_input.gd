extends TextureRect

func _input(event: InputEvent) -> void:
	if(event is InputEventKey):
		queue_free()
