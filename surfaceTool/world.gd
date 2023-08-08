extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.add_color(Color(1, 0, 0))
	st.add_uv(Vector2(0, 0))
	st.add_vertex(Vector3(0, 0, 0))
	st.set_normal(Vector3(0, 0, 1))
	st.set_uv(Vector2(0, 0))
	st.add_vertex(Vector3(-1, -1, 0))
	st.set_normal(Vector3(0, 0, 1))
	st.set_uv(Vector2(0, 1))
	st.add_vertex(Vector3(-1, 1, 0))
	st.set_normal(Vector3(0, 0, 1))
	st.set_uv(Vector2(1, 1))
	st.add_vertex(Vector3(1, 1, 0))
	var mesh = st.commit()
	$MeshInstance3D.mesh = mesh

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass
