extends CharacterBody3D

var speed = 2
var accel = 10

@export_category("Config")
@onready var nav := $NavigationAgent3D
@export var marker3D: Marker3D

func _physics_process(delta):
	var direction = Vector3()
	
	nav.target_position = marker3D.global_position
	
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	
	velocity = velocity.lerp(direction * speed, accel * delta)
	
	move_and_slide()
