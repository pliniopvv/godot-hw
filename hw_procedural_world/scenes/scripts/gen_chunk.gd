@tool
extends Node3D


@export var x_size = 30
@export var z_size = 30
@export var y_weight = 5
@export var chunk_size = 3
@export var texture: Texture2D

var map = [[]]
var sf: SurfaceTool
var chunk: MeshInstance3D

func _ready():
	noise = get_noise()
	Kernel.new_vertex_y.connect(self.set_heigth)
	generate_chunk(noise)

func generate_chunk(_noise):
	chunk = MeshInstance3D.new()
	var st = SurfaceTool.new()
	sf = st
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	for z in range(z_size+1):
		var line = []
		for x in range(x_size+1):
			
			var y
			if _noise != null:
				y = _noise.get_noise_2d(x,z) * y_weight
			else:
				y = 0
			
			var uv = Vector2()
			uv.x = inverse_lerp(0,x_size,x) * x_size
			uv.y = inverse_lerp(0,z_size,z) * z_size
			
			st.set_uv(uv)
			var xyz = Vector3(x,y,z)
			line.append(xyz)
			st.add_vertex(xyz)
		map.append(line)

	var vert=0
	for z in z_size:
		for x in x_size:
			st.add_index(vert+0)
			st.add_index(vert+1)
			st.add_index(vert+x_size+1)
			st.add_index(vert+x_size+1)
			st.add_index(vert+1)
			st.add_index(vert+x_size+2)
			vert+=1
		vert+=1
		
	chunk.mesh = st.commit()
	
	var mat = StandardMaterial3D.new()
	mat.albedo_texture = texture
	chunk.set_surface_override_material(0,mat)
	
	add_child(chunk)

func _process(delta):
	pass

var noise
func get_noise():
	var n = FastNoiseLite.new()
	n.frequency = 0.1
	n.noise_type = FastNoiseLite.TYPE_PERLIN
	return n

func set_heigth(value: int):
	if value != null:
		y_weight = value
		chunk.mesh = null
		generate_chunk(noise)

