extends Node

var units
# Called when the node enters the scene tree for the first time.
func _ready():
	units = get_tree().get_nodes_in_group("unit")

func _process(delta):
	pass
