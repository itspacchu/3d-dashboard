extends Spatial



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.call_deferred("_load_nodes")
	
func _load_nodes()->void:
	var file = File.new()
	var big_data = {}
	for children in get_children():
		for child in children.get_children():
			big_data[child.node_name] = {
				"NODE_VERTICAL":child.node_vertical,
				"NODE_NAME":child.node_name,
				"SHOWABLE":true,
				"POSITION":{
					"X":child.translation.x,
					"Y":child.translation.y,
					"Z":child.translation.z,
				},
				"EMOJI":child.emoji.get_load_path()
			}
	file.open("thedata.json",file.WRITE)
	file.store_line(to_json(big_data))
	file.close()
