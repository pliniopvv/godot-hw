@tool
extends MeshInstance3D

func _ready():
	var vertices = PackedVector3Array()
	var uvs = PackedVector2Array()
	
	vertices.push_back(Vector3(1, 0, 0))
	vertices.push_back(Vector3(0, 0, 1))
	vertices.push_back(Vector3(0, 1, 0))
	
#pvv	Adicionado para aprender
	vertices.push_back(Vector3(0 ,0 ,1))
	vertices.push_back(Vector3(1, 0, 0))
	vertices.push_back(Vector3(1, 0, 1))

	# Initialize the ArrayMesh.
	var arr_mesh = ArrayMesh.new()
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
#	arrays[Mesh.ARRAY_TEX_UV] = uvs

	# Create the Mesh.
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	var m = MeshInstance3D.new()
	mesh = arr_mesh


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
