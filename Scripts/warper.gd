extends Spatial

export var teleport_to = Vector3.ZERO
export var string_to_show = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	if(len(string_to_show) > 1):
		$Label3D.text = string_to_show


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area_body_entered(body):
	body.translation = teleport_to
