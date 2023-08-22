extends Node

var clicado
var soltado
var debounce
var is_dragging = false

signal area_selected(area)
signal area_selection(area)
signal right_click()
signal left_click(destination)

func _ready():
	pass

func _unhandled_input(event):
	if event is InputEventMouseMotion and is_dragging:
		soltado = event.position
		var diffx = abs(clicado.x - soltado.x)
		var diffy = abs(clicado.y - soltado.y)
		if (diffx > 5) and (diffy > 5):
			var area = get_area(clicado, soltado)
			area_selection.emit(area)
			return
	if Input.is_action_just_pressed("ui_fc"):
		clicado = event.position
		is_dragging = true
	if Input.is_action_just_released("ui_fc"):
		soltado = event.position
		var diffx = abs(clicado.x - soltado.x)
		var diffy = abs(clicado.y - soltado.y)
		if (diffx > 5) and (diffy > 5):
			var area = get_area(clicado,soltado)
			area_selected.emit(area)
		is_dragging = false
	if Input.is_action_pressed("mouse_right"):
		right_click.emit()
	if Input.is_action_pressed("mouse_left"):
		left_click.emit(event.position)

func get_area(clicado, soltado):
	var diffx = abs(clicado.x - soltado.x)
	var diffy = abs(clicado.y - soltado.y)
	if (diffx > 1) and (diffy > 1):
		var c3D = get_viewport().get_camera_3d()
		var area = []
		area.append(clicado)
		area.append(soltado)
		return area
