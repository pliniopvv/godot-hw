extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var selected = false
@onready var box = $box

signal was_selected
signal was_deselected

func set_select(value):
	if selected != value:
		selected = value
		box.visible = value
		if selected:
			was_selected.emit(self)
		else:
			was_deselected.emit(self)

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	was_selected.connect(get_parent().get_parent().select_unit)
	was_deselected.connect(get_parent().get_parent().deselect_unit)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	if selected == true:
		box.visible = true
	else:
		box.visible = false

	move_and_slide()

func _on_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			set_select(true)
		if event.button_index == MOUSE_BUTTON_RIGHT:
			set_select(false)

func is_in(area):
	if (((area.menor.x <= position.x) and (position.x <= area.maior.x)) and
	((area.menor.z <= position.z) and (position.z <= area.maior.z))):
		return true
	return false
