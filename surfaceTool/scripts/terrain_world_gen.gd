@tool
extends Node3D


@export var x_size = 3
@export var z_size = 3
@export var chunk_size = 3
@export var texture: Texture2D

func _ready():
	generate_chunk()

func generate_chunk():
	var chunk = MeshInstance3D.new()
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	for z in range(z_size+1):
		for x in range(x_size+1):
			var y = 0
			
			var uv = Vector2()
			uv.x = inverse_lerp(0,x_size,x) * x_size
			uv.y = inverse_lerp(0,z_size,z) * z_size
			
			st.set_uv(uv)
			var xyz = Vector3(x,y,z)
#			map[x][z] = xyz.y
			st.add_vertex(xyz)

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
