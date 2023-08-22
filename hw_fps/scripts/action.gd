extends RayCast3D


func _ready():
	pass


func _process(delta):
	HUD.interactive = is_colliding()
