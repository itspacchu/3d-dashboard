extends Spatial

export var rel_tele = Vector3.ZERO

func _on_Area_body_entered(body):
	body.translate(Vector3.UP*0.1)
	body.vertical_velocity = rel_tele
	$AudioStreamPlayer3D.play()
