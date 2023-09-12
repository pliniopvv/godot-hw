extends Control

@export_category("Cfg.")
@export var x : Label
@export var y : Label

func _ready():
	pass


func _process(delta):
	if Debug.show == false and visible == false:
		return
	if Debug.show == false:
		visible = false
	else:
		visible = true

	x.text = str(Debug.player.x)
	y.text = str(Debug.player.z)
