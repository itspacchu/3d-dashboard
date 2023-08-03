extends Spatial
export var Node_json_url = "https://gist.githubusercontent.com/itspacchu/3897cefdb2e3d54ac9004cf70adea884/raw/613a5418e41ceb3d5cdf1328512578db59888a9f/thedata.json"
var node_data = {}

func _ready() -> void:
	self.call_deferred("_load_nodes")

func _load_nodes() -> void:
	$HTTPRequest.called(Node_json_url)

func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var response =  parse_json(body.get_string_from_utf8())
	if(typeof(response)==TYPE_DICTIONARY):
		var node_data = response
		for node_chan in node_data:
			var node = node_data[node_chan]
			var n = preload('res://Prefabs/ShowData.tscn').instance()
			n.node_vertical = node["NODE_VERTICAL"]
			n.node_name = node["NODE_NAME"]
			n.showable = node["SHOWABLE"]
			var pos = node["POSITION"]
			n.translation = Vector3(pos["X"],pos["Y"],pos["Z"])
			n.emoji =  load(node["EMOJI"])
			add_child(n)
			yield(get_tree().create_timer(1),"timeout")
