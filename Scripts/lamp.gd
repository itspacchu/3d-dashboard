extends Spatial

export var status:bool = true
export var node_name = "WN-LPXX-XX";
export var phase = 0.0;
var data = null
export var max_distance_thresh = 10
var currently_hovering = false
var on_screen = false
#func get_data(node_v,node_n,type_da='la'):
func _ready() -> void:
	$CONTACT_ONEM2M.get_data("AE-WN",node_name)
	$Control/logo/Label.text = node_name


func _process(delta):
	var pos = self.global_translation + Vector3(0,0.2,0)
	var camera = get_viewport().get_camera()
	var screenpos = camera.unproject_position(pos)
	on_screen = not camera.is_position_behind(pos)
	get_node('Control/logo').visible = on_screen
	if(on_screen):
		get_node('Control/logo').position = screenpos
		var logo = get_node("Control/logo")
		if(not currently_hovering):
			if(is_closeby()):
				logo.modulate.a = 0.5;
				logo.self_modulate = Color.white
				logo.scale = Vector2.ONE * 0.75
			else:
				logo.modulate.a = 0.1;
				logo.self_modulate = Color.white
				logo.scale = Vector2.ONE * 0.5

func strtolist(tstr):
	return tstr.replace("[","").replace("]","").split(',')

func process_data(data,labels):
	labels = labels
	var ret = []
	var indx = 0
	for ri in data:
		var dat = strtolist(ri["con"])
		ret.append(dat)
	return ret

func _on_CONTACT_ONEM2M_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var response =  parse_json(body.get_string_from_utf8())
	if(typeof(response)==TYPE_DICTIONARY):
		var dlist = response["m2m:cin"]["con"]
		$Control/logo/Panel/VBoxContainer/Status/status.text = "wisun active"
		if("on" in dlist):
			$lamp/SpotLight.visible = true
			$lamp/lightshader.visible = true
			$Control/logo/Panel/VBoxContainer/nodata.text = "Lamp On"
		elif("off" in dlist):
			$lamp/SpotLight.visible = false
			$lamp/lightshader.visible = false
			$Control/logo/Panel/VBoxContainer/nodata.text = "Lamp Off"

func is_closeby():
	return get_dst() < max_distance_thresh

func get_dst():
	return get_viewport().get_camera().global_translation.distance_squared_to(global_translation)
	
func _input(event):
	var logo = get_node("Control/logo")
	if(event is InputEventMouseMotion or event is InputEventJoypadMotion):
		if(on_screen and logo.get_rect().has_point(logo.to_local(get_viewport().size/2))):
			currently_hovering = true
			if(is_closeby()):
				logo.self_modulate = Color.white
				logo.modulate.a = 1;
				logo.scale = Vector2.ONE*1.4
				logo.get_node("Label").visible = true
				logo.get_node("Panel").visible = true
			else:
				logo.self_modulate = Color.orangered
				logo.scale = Vector2.ONE*0.5
				logo.modulate.a = 0.8
		else:
			logo.get_node("Label").visible = false
			logo.get_node("Panel").visible = false
			logo.self_modulate = Color.white
			logo.modulate.a = 0.2
			logo.scale = Vector2.ONE * 0.3	
	else:
		currently_hovering = false
