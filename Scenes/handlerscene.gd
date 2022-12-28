extends Spatial
var settings_open = false

var settings_page = preload("res://Prefabs/settingspage.tscn")

func _input(event):
	if(Input.is_action_just_pressed("ui_cancel")):
		if(not settings_open):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			var camera = get_viewport().get_camera()
			camera.get_parent().get_parent().get_parent().set_process_input(false)
			var sp = settings_page.instance()
			add_child(sp)
