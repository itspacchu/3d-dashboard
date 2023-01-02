extends VBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$SuperChart.read_data(
		["loading", "data","wait","up"],
		[
			[10, 20, 30, 40],
			[0, 1, 2, 3],
			[420,69,45,22]
		],
		["Never", "gonna", "give you up"]
	)
	$SuperChart.init_all()



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
