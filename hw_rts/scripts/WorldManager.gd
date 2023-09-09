extends Node3D

var selected_units = []

func select_unit(unit):
	if not selected_units.has(unit):
		selected_units.append(unit)
		print("Unit %s selected" % unit.name)
	
func deselect_unit(unit):
	if selected_units.has(unit):
		selected_units.erase(unit)
		print("Unit %s deselected" % unit.name)

# Called when the node enters the scene tree for the first time.
func _ready():
	KernelMouse.area_selection.connect(draw_area)
	KernelMouse.area_selected.connect(select_area)
	KernelMouse.right_click.connect(clear_selection)
#	KernelMouse.left_click.connect(move_units)
	pass
	
func draw_area(selectionView):
	var areas = area_to_projection(selectionView)
	var selection = $selection
	selection.mesh.size.x = areas.maior.x - areas.menor.x
	selection.mesh.size.z = areas.maior.z - areas.menor.z
	selection.mesh.size.y = areas.maior.y
	selection.position.x = areas.menor.x + selection.mesh.size.x/2
	selection.position.z = areas.menor.z + selection.mesh.size.z/2

func _process(delta):
	pass

func area_to_projection(selectionView):
	var c3D = get_viewport().get_camera_3d()
	var rayOrigin1 = c3D.project_ray_origin(selectionView[0])
	var rayEnd1 = rayOrigin1 + c3D.project_ray_normal(selectionView[0]) * 2000
	var rayOrigin2 = c3D.project_ray_origin(selectionView[1])
	var rayEnd2 = rayOrigin2 + c3D.project_ray_normal(selectionView[1]) * 2000
	var space_state = get_world_3d().direct_space_state
	var query1 = PhysicsRayQueryParameters3D.create(rayOrigin1, rayEnd1)
	var query2 = PhysicsRayQueryParameters3D.create(rayOrigin2, rayEnd2)
	var intersection1 = space_state.intersect_ray(query1)
	var intersection2 = space_state.intersect_ray(query2)
	if not $selection.visible:
		$selection.visible = true
	if not intersection1.is_empty() and not intersection2.is_empty():
		var down = Vector3(
			min(intersection1.position.x,intersection2.position.x),
			1,
			min(intersection1.position.z,intersection2.position.z),
		)
		var upper = Vector3(
			max(intersection1.position.x,intersection2.position.x),
			3,
			max(intersection1.position.z,intersection2.position.z),
		)
		return {
			"menor": down,
			"maior": upper
		}

func select_area(selectionView):
	var areas = area_to_projection(selectionView)
	$selection.visible = false
	var unidades = get_tree().get_nodes_in_group("unit")
	for unit in unidades:
		if unit.is_in(areas):
			selected_units.append(unit)
			unit.set_select(true)

func clear_selection():
	while selected_units.size() > 0:
		selected_units[0].set_select(false)

#func move_units(destination):
#	if selected_units.size() > 0:
#		for unit in selected_units:
#			unit.move_to(destination)
