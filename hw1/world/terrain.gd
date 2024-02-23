extends MeshInstance3D




func _ready():
	var st = SurfaceTool.new()

	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	# Prepare attributes for add_vertex.
	st.set_normal(Vector3(0, 0, 1))
	st.set_uv(Vector2(0, 0))
	# Call last for each vertex, adds the above attributes.
	st.add_vertex(Vector3(-1, -1, 0))

	st.set_normal(Vector3(0, 0, 1))
	st.set_uv(Vector2(0, 1))
	st.add_vertex(Vector3(-1, 1, 0))

	st.set_normal(Vector3(0, 0, 1))
	st.set_uv(Vector2(1, 1))
	st.add_vertex(Vector3(1, 1, 0))

	# Commit to a mesh.
	mesh = st.commit()
