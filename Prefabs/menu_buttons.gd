extends Spatial

func _input(event: InputEvent) -> void:
	if(Input.is_action_just_pressed('interact')):
		_on_Button_button_down()

func _on_Button_button_down():
	$Control/instruction.visible = true
	var t = Timer.new()
	t.set_wait_time(0.5)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	get_tree().change_scene("res://Scenes/TestBed.tscn")
