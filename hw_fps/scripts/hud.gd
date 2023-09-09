extends Node

@export_category("Elementos")
@export var action: VBoxContainer

func _process(delta):
	if action:
		action.visible = HUD.interactive
