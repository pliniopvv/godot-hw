extends MeshInstance3D


var angle_rotate = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate_y(deg_to_rad(angle_rotate)*delta)
	rotate_x(deg_to_rad(angle_rotate)*delta)
	pass


func set_angle(value):
	angle_rotate = value
