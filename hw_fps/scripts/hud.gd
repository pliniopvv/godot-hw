extends Node

@export_category("Elementos")
@export var action: VBoxContainer

func _ready():
	HUD.interact.connect(newState);

func _process(delta):
	pass

func newState(state):
	if (action):
		if (action.visible != state):
			action.visible = state;
