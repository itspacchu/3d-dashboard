extends Spatial

var labels = null

var target_pos = null
var target_rot = null
var movecam = false

onready var main_cam  = get_viewport().get_camera()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$WorldEnvironment/AnimationPlayer.play('DAYNIGHT')
	print("init")
	labels = $CampusModel/campus_2/Labels.get_children()
	if(OS.get_time().hour > 6 and OS.get_time().hour < 18):
		$WorldEnvironment/AnimationPlayer.seek(0)
	else:
		$WorldEnvironment/AnimationPlayer.seek(0.2)
	
func _process(delta: float) -> void:
	for label in labels:
		var d = main_cam.translation.distance_to(label.translation)
		label.pixel_size = max(0.01,0.01*(d/50))
	
	


func _on_AnimationPlayer_animation_finished(anim_name):
	print("Done Anim")
