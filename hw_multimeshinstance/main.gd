extends Node3D

@onready var terrain = $terrain
@onready var grass = $grass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#var mm = MultiMesh.new()
	#mm.transform_format = MultiMesh.TRANSFORM_3D
	#mm.instance_count = 512
	#mm.visible_instance_count = 200
	#mm.mesh = preload("res://nodes/terrain/grass/grass.res")
#
	#grass.multimesh = mm
#
	#randomize()
	#for x in range(500):
		#mm.set_instance_transform(x, Transform3D(Basis(), Vector3(randf()*20-10, 0, randf()*20-10)))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
