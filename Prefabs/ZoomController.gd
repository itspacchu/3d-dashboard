extends Control


var min_val = 0


func _ready():
	par = get_parent().get_parent().get_parent().get_parent()
func _process(delta):
	pass


func _on_ZOOMP_pressed():
	min_val*=3	
	


func _on_ZOOMN_pressed():
	max_val *=3


func _on_VSlider_value_changed(value):
	y_offset = value
