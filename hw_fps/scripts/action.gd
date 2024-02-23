extends RayCast3D

var state: bool = false;

func _ready():
	pass


func _process(delta):
	if (state != is_colliding()):
		state = is_colliding();
		HUD.interact.emit(state);

