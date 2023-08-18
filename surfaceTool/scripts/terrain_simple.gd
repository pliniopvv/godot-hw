@tool
extends MeshInstance3D

@export var xSize = 3
@export var zSize = 3

@export var update = false
@export var clear_verts = false

# Called when the node enters the scene tree for the first time.
func _ready():
	generate_terrain()
	
func generate_terrain():
	
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	var n = get_noise()
	
	for z in range(zSize+1):
		for x in range(xSize+1):
			var y = n.get_noise_2d(x,z)
			
			var uv = Vector2()
			uv.x = inverse_lerp(0,xSize,x)*3
			uv.y = inverse_lerp(0,zSize,z)*3
			
			st.set_uv(uv)
			st.add_vertex(Vector3(x,y,z))
			draw_sphere(Vector3(x,y,z))

	var vert = 0
	for z in zSize:
		for x in xSize:
			st.add_index(vert+0)
			st.add_index(vert+1)
			st.add_index(vert+xSize+1)
			st.add_index(vert+xSize+1)
			st.add_index(vert+1)
			st.add_index(vert+xSize+2)
			vert+=1
		vert+=1
		
	st.generate_normals()
	mesh = st.commit()

var noise
func get_noise():
	if noise == null:
		noise = FastNoiseLite.new()
		noise.noise_type = FastNoiseLite.TYPE_PERLIN
		noise.frequency = 0.1
	return noise

func draw_sphere(pos: Vector3):
	var ins = MeshInstance3D.new()
	add_child(ins)
	ins.position = pos
	var sphere = SphereMesh.new()
	sphere.radius = 0.1
	sphere.height = 0.2
	ins.mesh = sphere

func _process(delta):
	if update:
		generate_terrain()
		update = false
	
	if clear_verts:
		for i in get_children():
			i.free()
		clear_verts = false
