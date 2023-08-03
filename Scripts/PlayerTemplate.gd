extends KinematicBody

# Allows to pick your animation tree from the inspector
export (NodePath) var PlayerAnimationTree 
export onready var animation_tree = get_node(PlayerAnimationTree)
onready var playback = animation_tree.get("parameters/playback");
var temp = 0
# Allows to pick your chracter's mesh from the inspector
export (NodePath) var PlayerCharacterMesh
export onready var player_mesh = get_node(PlayerCharacterMesh)

# Gamplay mechanics and Inspector tweakables
export var gravity = 9.8
export var jump_force = 9
export var walk_speed = 1.3
export var run_speed = 5.5
export var dash_power = 12 # Controls roll and big attack speed boosts



# Animation node names
var roll_node_name = "Roll"
var idle_node_name = "Idle"
var walk_node_name = "Walk"
var run_node_name = "Run"
var jump_node_name = "Jump"
var attack1_node_name = "Attack1"
var attack2_node_name = "Attack1"
var bigattack_node_name = "Attack1"
var dance_shit = "DPLSWORKOMG"


# Condition States
var is_attacking = bool()
var is_rolling = bool()
var is_walking = bool()
var is_running = bool()
var is_dancing = bool()
var count_indx = 0

# Physics values
var direction = Vector3()
var horizontal_velocity = Vector3()
var aim_turn = float()
var movement = Vector3()
var vertical_velocity = Vector3()
var movement_speed = int()
var angular_acceleration = int()
var acceleration = int()

var old_onfloor = true

func _ready(): # Camera based Rotation
	direction = Vector3.BACK.rotated(Vector3.UP, $Camroot/h.global_transform.basis.get_euler().y)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event): # All major mouse and button input events
	attack1()
	if event is InputEventMouseMotion:
		aim_turn = -event.relative.x * 0.015 # animates player with mouse movement while aiming 

func roll():
## Dodge button input with dash and interruption to basic actions
	if Input.is_action_just_pressed("roll"):
		if !roll_node_name in playback.get_current_node() and !jump_node_name in playback.get_current_node() and !bigattack_node_name in playback.get_current_node():
			playback.start(roll_node_name) #"start" not "travel" to speedy teleport to the roll!
			horizontal_velocity = direction * dash_power
			
func attack1(): # If not doing other things, start attack1
	if (idle_node_name in playback.get_current_node() or walk_node_name in playback.get_current_node()) and is_on_floor():
		if Input.is_action_just_pressed("attack"):
			if (is_attacking == false):
				playback.travel(attack1_node_name)
				
func _physics_process(delta):
	attack1()
	roll()
	
	var on_floor = is_on_floor() # State control for is jumping/falling/landing
	if(on_floor and not old_onfloor):
		$walkrun.stream = load("res://Resources/Music/human-impact-on-ground-6982.mp3")
		$walkrun.play()
		$AnimatedSprite3D.visible = true
		$AnimatedSprite3D.frame = 0
		$AnimatedSprite3D.play("impact")
	var h_rot = $Camroot/h.global_transform.basis.get_euler().y
	movement_speed = 0
	angular_acceleration = 10
	acceleration = 15

	# Gravity mechanics and prevent slope-sliding
	if not is_on_floor(): 
		vertical_velocity += Vector3.DOWN * gravity * 2 * delta
	else: 
		vertical_velocity = -get_floor_normal() * gravity / 3
	
	# Defining attack state: Add more attacks animations here as you add more!
	if (attack1_node_name in playback.get_current_node()) or (attack2_node_name in playback.get_current_node()) or (bigattack_node_name in playback.get_current_node()): 
		is_attacking = true
	else: 
		is_attacking = false

# Giving BigAttack some Slide
	if bigattack_node_name in playback.get_current_node(): 
		acceleration = 3

	# Defining Roll state and limiting movment during rolls
	if roll_node_name in playback.get_current_node(): 
		is_rolling = true
		acceleration = 2
		angular_acceleration = 2
	else: 
		is_rolling = false
	
#	Jump input and Mechanics
	if Input.is_action_just_pressed("ui_accept") and ((is_dancing != true) and (is_attacking != true) and (is_rolling != true)) and is_on_floor():
		vertical_velocity = Vector3.UP * jump_force
	if(Input.is_action_just_pressed("ui_page_down")):
		is_dancing = !is_dancing
	# Movement input, state and mechanics. *Note: movement stops if attacking
	if (Input.is_action_pressed("ui_up") ||  Input.is_action_pressed("ui_down") ||  Input.is_action_pressed("ui_left") ||  Input.is_action_pressed("ui_right")):
		direction = Vector3(Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right"),
					0,
					Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down"))
		direction = direction.rotated(Vector3.UP, h_rot).normalized()
		is_walking = true
		
	# Sprint input, state and speed
		if (Input.is_action_pressed("sprint")) and (is_walking == true): 
			movement_speed = run_speed
			is_running = true
			$newchar/AnimationPlayer.playback_speed = run_speed/2
		else: # Walk State and speed
			$newchar/AnimationPlayer.playback_speed = walk_speed/2
			movement_speed = walk_speed
			is_running = false
	else: 
		is_walking = false
		is_running = false
		
	if Input.is_action_pressed("aim"):  # Aim/Strafe input and  mechanics
		player_mesh.rotation.y = lerp_angle(player_mesh.rotation.y, $Camroot/h.rotation.y, delta * angular_acceleration)

	else: # Normal turn movement mechanics
		player_mesh.rotation.y = lerp_angle(player_mesh.rotation.y, atan2(direction.x, direction.z) - rotation.y, delta * angular_acceleration)
	
	# Movment mechanics with limitations during rolls/attacks
	if ((is_attacking == true) or (is_rolling == true)): 
		horizontal_velocity = horizontal_velocity.linear_interpolate(direction.normalized() * .01 , acceleration * delta)
	else: # Movement mechanics without limitations 
		horizontal_velocity = horizontal_velocity.linear_interpolate(direction.normalized() * movement_speed, acceleration * delta)
	
	# The Physics Sauce. Movement, gravity and velocity in a perfect dance.
	if(is_dancing!=true):
		movement.z = horizontal_velocity.z + vertical_velocity.z
		movement.x = horizontal_velocity.x + vertical_velocity.x
		movement.y = vertical_velocity.y
		move_and_slide(movement, Vector3.UP)

	# ========= State machine controls =========
	# The booleans of the on_floor, is_walking etc, trigger the 
	# advanced conditions of the AnimationTree, controlling animation paths
	
	# on_floor manages jumps and falls
	animation_tree["parameters/conditions/IsOnFloor"] = on_floor
	animation_tree["parameters/conditions/IsInAir"] = !on_floor
	# Moving and running respectively
	animation_tree["parameters/conditions/IsWalking"] = is_walking
	animation_tree["parameters/conditions/IsNotWalking"] = !is_walking
	animation_tree["parameters/conditions/IsRunning"] = is_running
	animation_tree["parameters/conditions/IsNotRunning"] = !is_running
	animation_tree["parameters/conditions/IsDancing"] = is_dancing
	animation_tree["parameters/conditions/IsNotDancing"] = !is_dancing
	
	#animation_tree["parameters/conditions/IsRunningOnGround"] = on_floor and is_running
	#animation_tree["parameters/conditions/IsWalkingOnGround"] = on_floor and is_walking
	
	# Attacks and roll don't use these boolean conditions, instead
	# they use "travel" or "start" to one-shot their animations.
	old_onfloor = on_floor


func _on_AnimatedSprite3D_animation_finished():
	$AnimatedSprite3D.visible = false
