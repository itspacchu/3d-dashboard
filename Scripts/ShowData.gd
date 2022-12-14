extends Spatial

export var node_vertical = "AE-AQ"
export var node_name = "AQ-AD95-00"

export (Texture) var emoji;
export (Vector3) var tgtpos
export (Vector3) var tgtrot;

var windowd = null
var BUFF = 30;
var zoom = 1

var y_offset = 0

#warn
var inner_count = 0

var colors;

var last_pos = null
var last_size = null

# data to be shown
var data = null;
onready var graph2D = get_node("Control/WindowDialog/Graph2D")

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

func do_request():
	get_node('HTTPRequest').get_data(node_vertical,node_name)

func _process(delta):
	var pos = self.global_translation
	var camera = get_viewport().get_camera()
	var screenpos = camera.unproject_position(pos)
	get_node('Control/logo').visible = not camera.is_position_behind(pos)
	get_node('Control/logo').position = screenpos
	var d = camera.translation.distance_squared_to(translation)
	get_node("Control/logo").modulate.a = clamp(range_lerp(d,0,500,1,0.2),0,1)

func _on_WindowDialog_popup_hide():
	last_pos = get_node('Control/WindowDialog').rect_position
	last_size = get_node('Control/WindowDialog').rect_size
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		var logo = get_node("Control/logo")
		var camera = get_viewport().get_camera()
		if(logo.get_rect().has_point(logo.to_local(event.position))):
			onSpritePressed()

func generate_graph():
	if(len(graph2D._curves)):
		for i in range(len(graph2D._curves)):
			graph2D.remove_curve(i)
			
	if(data != null):
		var _labels = data['labels']
		var _data = data["data"]
		var graphs = []
		var idx = 0;
		for i in range(1,len(_labels)):
			var g = graph2D.add_curve(_labels[i],rand_color(i),4.0)
			graphs.append(g)
			
		#graph2D.x_axis_min_value = int(_data[0][0])
		#graph2D.x_axis_max_value = graph2D.x_axis_min_value + 1000
		
		for g in range(len(graphs)):
			var graph = graphs[g]
			var label = _labels[g]
			
			for x in range(len(_data)):
				var d = Vector2(x,_data[x][g])
				graph2D.add_point(graph,d)
				if(len(_data) < 2):
					graph2D.add_point(graph,d+Vector2(1,0))
				
		
			
		
func onSpritePressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	var camera = get_viewport().get_camera()
	var windiag = get_node('Control/WindowDialog');
	var recto = get_viewport().size
	
	var super = get_parent().get_parent().get_parent();
	
#	super.target_pos = tgtpos
#	super.target_rot = tgtrot
#	super.movecam = true;
	
#	camera.translation = tgtpos
#	camera.rotation_degrees = tgtrot
	
	do_request()
	windiag.popup_centered()
	windiag.window_title = node_name
	if(last_size != null):
		windiag.rect_size = last_size
	else:
		windiag.rect_size = Vector2(recto.x/3 - 2*BUFF,recto.y - 3*BUFF);
	if(last_pos != null):
		windiag.rect_position = last_pos
	else:
		windiag.rect_position = Vector2(recto.x/1.5 - BUFF,2*BUFF)
	
	#show data
	
func _on_Button_pressed() -> void:
	var random_lines = [
		"Spamming Onem2m server sucessfully failed",
		"Dude onem2m is already unoptimised hell",
		"Stop slamming the fudging button!!!!!!",
		"Onem2m is not on your father's server"
	]
	inner_count += 1;
	if(inner_count > 5):
		random_lines.shuffle()
		get_node('Control/err/RichTextLabel').text = random_lines[0]
		get_node('Control/err').popup_centered()
		get_node('Control/err').window_title = "Warn!"
		inner_count = 0;
		return
	do_request()
	#generate_graph()
	get_node('Control/WindowDialog/RichTextLabel').text = str(data)


func _on_ZOOMP_pressed():
	graph2D.y_axis_max_value += 3
	graph2D.y_axis_min_value += 3
	generate_graph()


func _on_ZOOMN_pressed():
	graph2D.y_axis_max_value -= 3
	graph2D.y_axis_min_value -= 3
	generate_graph()


func _on_ZOOMP2_pressed():
	if(graph2D.y_axis_max_value > 1):
		graph2D.y_axis_max_value /= 1.5
		graph2D.y_axis_min_value /= 1.5
		generate_graph()
	


func _on_ZOOMN2_pressed():
	graph2D.y_axis_max_value *= 1.5
	graph2D.y_axis_min_value *= 1.5
	generate_graph()


func _on_rst_pressed():
	graph2D.y_axis_max_value = 10
	graph2D.y_axis_min_value = 0
	generate_graph()
	
