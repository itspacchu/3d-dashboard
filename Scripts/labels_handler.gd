extends Spatial

onready var main_cam  = get_viewport().get_camera()
var labels = null

func _ready() -> void:
	labels = get_children()
	
func _process(delta: float) -> void:
	for label in labels:
		var d = main_cam.translation.distance_to(label.translation)
		label.pixel_size = max(0.01,0.01*(d/50))

	
	

