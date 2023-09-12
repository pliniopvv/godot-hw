extends Node

var show = false

var player = {
	"x": 0,
	"z": 0
}

func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		show = !show
	
