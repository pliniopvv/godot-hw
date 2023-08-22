extends Camera3D

func _ready():
	pass

func _process(delta):
	if Input.is_action_pressed("ui_left"):
		position.x -= 1
		position.z -= 1
	if Input.is_action_pressed("ui_right"):
		position.x += 1
		position.z += 1
	if Input.is_action_pressed("ui_up"):
		position.x -= 1
		position.z += 1
	if Input.is_action_pressed("ui_down"):
		position.x += 1
		position.z -= 1
