extends Control


export var scale_max = 1.0
export var periodic = 1.0
export var dc_scale = 2.0
# Called every frame. 'delta' is the elapsed time since the previous frame.

export var big_ol_list_of_motd = [
	"Never gonna give you up",
	"Minecraft is superior",
	"Now with more colors",
	"Metamorphosis",
	"Made on ArchLinux btw!",
	"Wednesday Biryani",
	"Hyderabad edition",
	"Stonks!",
	"yeeeeeeeet",
	"Wildest Dreams",
	"Giggity Giggity",
	"Lateraus ~ Tool",
	"The Nights"
]

func _ready():
	randomize()
	$Label.text = big_ol_list_of_motd[rand_range(0,len(big_ol_list_of_motd))]
	#$Label.text = big_ol_list_of_motd[len(big_ol_list_of_motd)-1]

func _process(delta):
	rect_scale = Vector2.ONE * (scale_max * (sin(periodic*OS.get_ticks_msec()/100)+1)*0.5 + dc_scale)
