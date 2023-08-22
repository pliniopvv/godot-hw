extends Node

@export_category("Elementos")
#@export var action: VBoxContainer
@onready var action := $action

func _ready():
	HUD.interactive.connect(self.onInteractive.bind(self))
	print("Conectado")

func onInteractive(value):
	$action.visible = value
	print("onInteractive", value)
