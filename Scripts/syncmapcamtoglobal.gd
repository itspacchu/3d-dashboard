extends ViewportContainer

export (NodePath) var target;
onready var player = get_node(target)

func _physics_process(delta):
	$Viewport/mapcam.translation = Vector3(player.translation.x,30,player.translation.y)
	$Viewport/Sprite3D.translation = Vector3(player.translation.x,30,player.translation.y)
