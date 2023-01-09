extends Panel



# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/AQ2.pressed = get_parent().get_parent().get_node("WorldEnvironment/DirectionalLight").shadow_enabled
	$VBoxContainer/RenderDistance/renderd.value = get_viewport().get_camera().far

func _on_back_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	var camera = get_viewport().get_camera()
	camera.get_parent().get_parent().get_parent().set_process_input(true)
	get_parent().get_parent().settings_open = false
	queue_free()

func _input(event):
	if(Input.is_action_just_pressed("ui_cancel")):
		_on_back_pressed()

func _on_AQ2_toggled(button_pressed):
	get_parent().get_parent().get_node("WorldEnvironment/DirectionalLight").shadow_enabled = button_pressed


func _on_renderd_value_changed(value):
	get_viewport().get_camera().far = value


func _on_reload_pressed():
	get_tree().change_scene_to(load("res://Scenes/TestBed.tscn"))


func _on_CheckButton_toggled(button_pressed: bool) -> void:
	var animplayer:AnimationPlayer = get_parent().get_parent().get_node("WorldEnvironment/AnimationPlayer")
	if(button_pressed):
		animplayer.play("dn")
		animplayer.seek(1)
	else:
		animplayer.play("RESET")
		animplayer.seek(0)

func _on_LineEdit_text_entered(new_text: String) -> void:
	get_parent().get_parent().get_node("DynamicNodeLoader").queue_free()
	var node_loader = load('res://Prefabs/DynamicNodeLoader.tscn').instance()
	node_loader.Node_json_url = new_text
	get_parent().get_parent().add_child(node_loader)
