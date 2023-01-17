extends AspectRatioContainer


func _input(event: InputEvent) -> void:
	if(event is InputEventJoypadMotion):
		visible = true
		$A3.offset = 10*Vector2(Input.get_axis("joylookxn", "joylookxp"),Input.get_axis("joylookyp", "joylookyn"))
		$A4.offset = 10*Vector2(int(Input.is_action_pressed('ui_right')) - int(Input.is_action_pressed('ui_left')),int(Input.is_action_pressed('ui_down')) - int(Input.is_action_pressed('ui_up')))
	elif(event is InputEventJoypadButton):
		visible = true
		if(Input.is_action_pressed('ui_accept')):
			$A.scale = Vector2.ONE*0.6
		else:
			$A.scale = Vector2.ONE*0.42
		if(Input.is_action_pressed('interact')):
			$A2.scale = Vector2.ONE*0.6
		else:
			$A2.scale = Vector2.ONE*0.42
	else:
		visible = false

