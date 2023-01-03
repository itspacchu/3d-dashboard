extends Camera


onready var player_entity = load("res://Prefabs/PlayerTemplate.tscn")
onready var nodes_entities = load("res://Prefabs/AllTheNodes.tscn")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_playhit_button_down():
	var p_e = player_entity.instance()
	var n_e = nodes_entities.instance()
	get_parent().add_child(p_e)
	p_e.translation = Vector3(20.37,2,-30/175)
	p_e.scale = Vector3.ONE * 0.3
	current = false
	p_e.get_node("Camroot/h/v/Camera").current = true
	get_parent().add_child(n_e)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	queue_free()
