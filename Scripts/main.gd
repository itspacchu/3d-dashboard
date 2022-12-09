extends Spatial

var labels = null

var target_pos = null
var target_rot = null
var movecam = false

onready var main_cam  = get_viewport().get_camera()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("init")

	$InterpolatedCamera/AnimationPlayer.play("CameraInit")
	labels = $CampusModel/campus_2/Labels.get_children()
	
func _process(delta: float) -> void:
	for label in labels:
		var d = $InterpolatedCamera.translation.distance_to(label.translation)
		label.pixel_size = max(0.01,0.01*(d/50))
	
	


func _on_AnimationPlayer_animation_finished(anim_name):
	print("Done Anim")
