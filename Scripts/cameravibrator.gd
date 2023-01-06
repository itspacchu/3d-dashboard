extends Camera

export var scale_max = 1.0
func _process(delta):
	rotation_degrees.y = 166.296 + 5*sin(1.0*OS.get_ticks_msec()/1200)
