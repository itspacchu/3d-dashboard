extends Spatial

export var node_vertical = "AE-AQ"
export var node_name = "AQ-AD95-00"

export (Texture) var emoji;
export (Vector3) var tgtpos
export (Vector3) var tgtrot;
export (float) var max_distance_thresh = 20;

export var showable = true

var windowd = null
var BUFF = 30;
var zoom = 1
var is_window_open = false

var y_offset = 0

#warn
var inner_count = 0

var colors;

var last_pos = null
var last_size = null

# data to be shown
var data = null;
var labels = Array();
var oneshot = true
var controller_show = true
var on_screen = false
var currently_hovering = false


static func rand_color(c=0):
	var colcon = [
		Color.aquamarine,
		Color.coral,
		Color.hotpink,
		Color.lightcoral,
		Color.lightgreen,
		Color.lightpink,
		Color.lightsteelblue,
		Color.blueviolet,
		Color.brown,
		Color.deeppink
	]
	return colcon[c%len(colcon)]
	
# Called when the node enters the scene tree for the first time.
func _ready():
	get_node('Control/logo').texture = emoji;
	get_node('Control/WindowDialog/logo').texture = emoji;
	windowd = get_node('Control/WindowDialog')
	$Control/logo/Label.text = node_name

func do_request():
	get_node('HTTPRequest').get_data(node_vertical,node_name)

func _process(delta):
	var pos = self.global_translation
	var camera = get_viewport().get_camera()
	var screenpos = camera.unproject_position(pos)
	on_screen = not camera.is_position_behind(pos)
	get_node('Control/logo').visible = on_screen
	if(on_screen):
		get_node('Control/logo').position = screenpos
		$Control/logo/dist.text = str(int(get_dst())) + " m"
		var logo = get_node("Control/logo")
		if(not currently_hovering):
			if(is_closeby()):
				logo.modulate.a = 0.75;
				logo.self_modulate = Color.white
				logo.scale = Vector2.ONE * 0.75
			else:
				logo.modulate.a = 0.1;
				logo.self_modulate = Color.white
				logo.scale = Vector2.ONE * 0.5

func _on_WindowDialog_popup_hide():
	var camera = get_viewport().get_camera()
	is_window_open = false
	camera.get_parent().get_parent().get_parent().set_process_input(true)
	get_node('Control/WindowDialog').visible = false and showable
	last_pos = get_node('Control/WindowDialog').rect_position
	last_size = get_node('Control/WindowDialog').rect_size
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	

func is_closeby():
	return get_dst() < max_distance_thresh


func get_dst():
	return get_viewport().get_camera().global_translation.distance_squared_to(global_translation)

func _input(event):
	var logo = get_node("Control/logo")
	if(event is InputEventJoypadMotion or event is InputEventJoypadButton):
		controller_show = true
	else:
		controller_show = false
		
	if(controller_show):
		if(is_closeby()):
			for i in range(0,2):
				Input.start_joy_vibration(i, 0.5, 1, 1)
		else:
			for i in range(0,2):
				Input.stop_joy_vibration(i)
	
	if(event is InputEventMouseMotion or event is InputEventJoypadMotion):
		if(on_screen and logo.get_rect().has_point(logo.to_local(get_viewport().size/2))):
			currently_hovering = true
			if(is_closeby()):
				$Control/logo/dist.visible = false and showable
				logo.self_modulate = Color.white
				logo.modulate.a = 1;
				logo.scale = Vector2.ONE*1.5
				logo.get_node("Label").visible = true and showable
				logo.get_node("Panel").visible = true and showable
				$Control/logo/controller.visible = true and controller_show
				if(oneshot == true):
					do_request()
					oneshot = false
			else:
				logo.self_modulate = Color.orangered
				logo.scale = Vector2.ONE*0.5
				$Control/logo/dist.rect_scale = Vector2.ONE*1.25
				logo.modulate.a = 0.2
				get_viewport().get_camera().get_parent().get_parent().get_parent().is_on_node = 1
			if(Input.is_action_just_pressed("settings")):
				$Control/WindowDialog.visible = not $Control/WindowDialog.visible
		else:
			currently_hovering = false
			get_viewport().get_camera().get_parent().get_parent().get_parent().is_on_node = 1
			$Control/logo/dist.rect_scale = Vector2.ONE
			$Control/logo/dist.visible = true and showable
			$Control/logo/controller.visible = false and showable and controller_show
			logo.get_node("Label").visible = false and showable
			logo.get_node("Panel").visible = false and showable
			
	if (Input.is_action_just_pressed('interact')) or (event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT):
		if(is_closeby() and !is_window_open and data != null):
			var camera = get_viewport().get_camera()
			if(logo.get_rect().has_point(logo.to_local(get_viewport().size/2))):
				onSpritePressed()

	
	
	
func onSpritePressed():
	is_window_open = true
	get_viewport().get_camera().get_parent().get_parent().get_parent().get_parent().is_attacking = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	var camera = get_viewport().get_camera()
	camera.get_parent().get_parent().get_parent().set_process_input(false)
	var windiag = get_node('Control/WindowDialog');
	var recto = get_viewport().size
	var super = get_parent().get_parent().get_parent();
	
	windiag.popup_centered()
	windiag.window_title = node_name
	if(last_size != null):
		windiag.rect_size = last_size
	if(last_pos != null):
		windiag.rect_position = last_pos
		
	var lbl = labels.slice(1,len(labels))
	var timestamps = Array()
	var restructured_data = Array()
	for i in len(lbl):
		restructured_data.append(Array())
	$Control/logo/Panel/VBoxContainer/nodata.visible = false and showable
	
	if(data == null):
		$Control/logo/Panel/VBoxContainer/nodata.visible = true	and showable
		$Control/logo/controller.visible = false and showable
		$Control/err.popup_centered()
		get_node('Control/err').window_title = "No Data Available"
		get_node('Control/err/RichTextLabel').text = "No Data Available"
		return
		
	for datapoints in data:
		var dp = strtolist(datapoints["con"]);
		for val in len(labels):
			if(val < 1):
				var ts = OS.get_datetime_from_unix_time(19800+int(dp[val]))
				if(0 == int(dp[val])):
					ts = OS.get_datetime()
				timestamps.append("%02d:%02d|%02d-%02d"%[ts.hour,ts.minute,ts.day,ts.month])
			else:
				if('nan' in dp[val]):
					if(val-1 > len(dp)):
						continue
					restructured_data[val-1].append(0.0)
				else:
					if(val-1 > len(dp)):
						continue
					restructured_data[val-1].append(float(dp[val]))

	var sc = $Control/WindowDialog/VBoxContainer/SuperChart
	sc.read_data(timestamps,restructured_data,lbl)
	sc.init_all()

func strtolist(tstr):
	return tstr.replace('nan','0.0').replace("[","").replace("]","").split(',')

	
func _on_Button_pressed() -> void:
	var random_lines = [
		"Spamming Onem2m server sucessfully failed",
		"Dude onem2m is already unoptimised hell",
		"Stop slamming the fudging button!!!!!!",
		"Onem2m is not on your father's server"
	]
	inner_count += 1;
	if(inner_count > 10):
		random_lines.shuffle()
		get_node('Control/err/RichTextLabel').text = random_lines[0]
		get_node('Control/err').popup_centered()
		get_node('Control/err').window_title = "Warn!"
		inner_count = 0;
		return
	do_request()
	get_node('Control/WindowDialog/VBoxContainer/RichTextLabel').text = str(data)
	$Control/WindowDialog.visible = false and showable
	if(showable):
		onSpritePressed()
