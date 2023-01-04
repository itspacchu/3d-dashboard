extends Spatial
# Allows to select the player mesh from the inspector
export (NodePath) var PlayerCharacterMesh
var temp = 0

var camrot_h = 0
var camrot_v = 0
export var cam_v_max = 75 # -75 recommended
export var cam_v_min = -55 # -55 recommended
export var joystick_sensitivity = 20
var h_sensitivity = .1
var v_sensitivity = .1
var rot_speed_multiplier = .35 #reduce this to make the rotation radius larger
var h_acceleration = 10
var v_acceleration = 10
var joyview = Vector2()
var is_on_node = 1

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$h/v/Camera.add_exception(get_parent())

	
func _input(event):
	if event is InputEventMouseMotion:
		$control_stay_delay.start()
		camrot_h += -event.relative.x * h_sensitivity * is_on_node
		camrot_v += event.relative.y * v_sensitivity * is_on_node
	if event is InputEventJoypadMotion:
		$control_stay_delay.start()
		camrot_h += -event.get_action_strength() * h_sensitivity * is_on_node
		camrot_v += event.y * v_sensitivity * is_on_node

		
		
func _physics_process(delta):
	camrot_v = clamp(camrot_v, cam_v_min, cam_v_max)
	
	var mesh_front = get_node(PlayerCharacterMesh).global_transform.basis.z
	var auto_rotate_speed =  (PI - mesh_front.angle_to($h.global_transform.basis.z)) * get_parent().horizontal_velocity.length() * rot_speed_multiplier
	
	$h.rotation_degrees.y = lerp($h.rotation_degrees.y, camrot_h, delta * h_acceleration)
	$h/v.rotation_degrees.x = lerp($h/v.rotation_degrees.x, camrot_v, delta * v_acceleration)
	
