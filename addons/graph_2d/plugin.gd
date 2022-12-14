tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("Graph2D", "Control",
					preload("res://addons/graph_2d/graph_2d.gd"),
					preload("res://addons/graph_2d/graph_2d.svg"))


func _exit_tree():
	remove_custom_type("Graph2D")
