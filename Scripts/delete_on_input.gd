extends TextureRect

func _input(event: InputEvent) -> void:
	if(event is InputEvent):
		queue_free()
