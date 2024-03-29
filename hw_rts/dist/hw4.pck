GDPC                 �                                                                         T   res://.godot/exported/133200997/export-76e0adcbc83681695885bae615f516ae-world.scn   P4      �      rgntsn;7�@��    T   res://.godot/exported/133200997/export-a763181cad695198163108dfada3c8c5-person.scn  @$            �Ko$��G&��R�	    ,   res://.godot/global_script_class_cache.cfg                 ��Р�8���8~$}P�    D   res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex      ^      2��r3��MgB�[79       res://.godot/uid_cache.bin  0\      �       ȑ7�̘B�R{�k�i       res://icon.svg  �K      N      ]��s�9^w/�����       res://icon.svg.import   p#      �       ��	>P���O�G�+       res://person.tscn.remap  K      c       p�"*a����@�       res://project.binary ]      �      ��V��z=m'�,EM       res://scripts/MouseAction.gd�            ��#T@/	������w        res://scripts/UnitsManager.gd          �       �.�,t��#\��ǹv3        res://scripts/WorldManager.gd   �      +
      �������8�����       res://scripts/camera.gd         m      l��߽
��i�t�׌       res://scripts/person.gd �            � ��O��!#��xC       res://world.tscn.remap  pK      b       �t�׵B�}��6�x    Sa���(j�list=Array[Dictionary]([])
��Ek�extends Camera3D

func _ready():
	pass

func _process(delta):
	if Input.is_action_pressed("ui_left"):
		position.x -= 1
		position.z -= 1
	if Input.is_action_pressed("ui_right"):
		position.x += 1
		position.z += 1
	if Input.is_action_pressed("ui_up"):
		position.x -= 1
		position.z += 1
	if Input.is_action_pressed("ui_down"):
		position.x += 1
		position.z -= 1
x�extends Node

var clicado
var soltado
var debounce
var is_dragging = false

signal area_selected(area)
signal area_selection(area)
signal right_click()
signal left_click(destination)

func _ready():
	pass

func _unhandled_input(event):
	if event is InputEventMouseMotion and is_dragging:
		soltado = event.position
		var diffx = abs(clicado.x - soltado.x)
		var diffy = abs(clicado.y - soltado.y)
		if (diffx > 5) and (diffy > 5):
			var area = get_area(clicado, soltado)
			area_selection.emit(area)
			return
	if Input.is_action_just_pressed("ui_fc"):
		clicado = event.position
		is_dragging = true
	if Input.is_action_just_released("ui_fc"):
		soltado = event.position
		var diffx = abs(clicado.x - soltado.x)
		var diffy = abs(clicado.y - soltado.y)
		if (diffx > 5) and (diffy > 5):
			var area = get_area(clicado,soltado)
			area_selected.emit(area)
		is_dragging = false
	if Input.is_action_pressed("mouse_right"):
		right_click.emit()
	if Input.is_action_pressed("mouse_left"):
		left_click.emit(event.position)

func get_area(clicado, soltado):
	var diffx = abs(clicado.x - soltado.x)
	var diffy = abs(clicado.y - soltado.y)
	if (diffx > 1) and (diffy > 1):
		var c3D = get_viewport().get_camera_3d()
		var area = []
		area.append(clicado)
		area.append(soltado)
		return area
����m#��*extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var selected = false
@onready var box = $box

signal was_selected
signal was_deselected

func set_select(value):
	if selected != value:
		selected = value
		box.visible = value
		if selected:
			was_selected.emit(self)
		else:
			was_deselected.emit(self)

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	was_selected.connect(get_parent().get_parent().select_unit)
	was_deselected.connect(get_parent().get_parent().deselect_unit)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	if selected == true:
		box.visible = true
	else:
		box.visible = false

	move_and_slide()

func _on_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			set_select(true)
		if event.button_index == MOUSE_BUTTON_RIGHT:
			set_select(false)

func is_in(area):
	if (((area.menor.x <= position.x) and (position.x <= area.maior.x)) and
	((area.menor.z <= position.z) and (position.z <= area.maior.z))):
		return true
	return false
kextends Node

var units
# Called when the node enters the scene tree for the first time.
func _ready():
	units = get_tree().get_nodes_in_group("unit")

func _process(delta):
	pass
��'�EL�R�j��extends Node3D

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
	KernelMouse.left_click.connect(move_units)
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

func move_units(destination):
	if selected_units.size() > 0:
		for unit in selected_units:
			unit.move_to(destination)
���yGST2   �   �      ����               � �        &  RIFF  WEBPVP8L  /������!"2�H�l�m�l�H�Q/H^��޷������d��g�(9�$E�Z��ߓ���'3���ض�U�j��$�՜ʝI۶c��3� [���5v�ɶ�=�Ԯ�m���mG�����j�m�m�_�XV����r*snZ'eS�����]n�w�Z:G9�>B�m�It��R#�^�6��($Ɓm+q�h��6�4mb�h3O���$E�s����A*DV�:#�)��)�X/�x�>@\�0|�q��m֋�d�0ψ�t�!&����P2Z�z��QF+9ʿ�d0��VɬF�F� ���A�����j4BUHp�AI�r��ِ���27ݵ<�=g��9�1�e"e�{�(�(m�`Ec\]�%��nkFC��d���7<�
V�Lĩ>���Qo�<`�M�$x���jD�BfY3�37�W��%�ݠ�5�Au����WpeU+.v�mj��%' ��ħp�6S�� q��M�׌F�n��w�$$�VI��o�l��m)��Du!SZ��V@9ד]��b=�P3�D��bSU�9�B���zQmY�M~�M<��Er�8��F)�?@`�:7�=��1I]�������3�٭!'��Jn�GS���0&��;�bE�
�
5[I��=i�/��%�̘@�YYL���J�kKvX���S���	�ڊW_�溶�R���S��I��`��?֩�Z�T^]1��VsU#f���i��1�Ivh!9+�VZ�Mr�טP�~|"/���IK
g`��MK�����|CҴ�ZQs���fvƄ0e�NN�F-���FNG)��W�2�JN	��������ܕ����2
�~�y#cB���1�YϮ�h�9����m������v��`g����]1�)�F�^^]Rץ�f��Tk� s�SP�7L�_Y�x�ŤiC�X]��r�>e:	{Sm�ĒT��ubN����k�Yb�;��Eߝ�m�Us�q��1�(\�����Ӈ�b(�7�"�Yme�WY!-)�L���L�6ie��@�Z3D\?��\W�c"e���4��AǘH���L�`L�M��G$𩫅�W���FY�gL$NI�'������I]�r��ܜ��`W<ߛe6ߛ�I>v���W�!a��������M3���IV��]�yhBҴFlr�!8Մ�^Ҷ�㒸5����I#�I�ڦ���P2R���(�r�a߰z����G~����w�=C�2������C��{�hWl%��и���O������;0*��`��U��R��vw�� (7�T#�Ƨ�o7�
�xk͍\dq3a��	x p�ȥ�3>Wc�� �	��7�kI��9F}�ID
�B���
��v<�vjQ�:a�J�5L&�F�{l��Rh����I��F�鳁P�Nc�w:17��f}u}�Κu@��`� @�������8@`�
�1 ��j#`[�)�8`���vh�p� P���׷�>����"@<�����sv� ����"�Q@,�A��P8��dp{�B��r��X��3��n$�^ ��������^B9��n����0T�m�2�ka9!�2!���]
?p ZA$\S��~B�O ��;��-|��
{�V��:���o��D��D0\R��k����8��!�I�-���-<��/<JhN��W�1���(�#2:E(*�H���{��>��&!��$| �~�+\#��8�> �H??�	E#��VY���t7���> 6�"�&ZJ��p�C_j����	P:�~�G0 �J��$�M���@�Q��Yz��i��~q�1?�c��Bߝϟ�n�*������8j������p���ox���"w���r�yvz U\F8��<E��xz�i���qi����ȴ�ݷ-r`\�6����Y��q^�Lx�9���#���m����-F�F.-�a�;6��lE�Q��)�P�x�:-�_E�4~v��Z�����䷳�:�n��,㛵��m�=wz�Ξ;2-��[k~v��Ӹ_G�%*�i� ����{�%;����m��g�ez.3���{�����Kv���s �fZ!:� 4W��޵D��U��
(t}�]5�ݫ߉�~|z��أ�#%���ѝ܏x�D4�4^_�1�g���<��!����t�oV�lm�s(EK͕��K�����n���Ӌ���&�̝M�&rs�0��q��Z��GUo�]'G�X�E����;����=Ɲ�f��_0�ߝfw�!E����A[;���ڕ�^�W"���s5֚?�=�+9@��j������b���VZ^�ltp��f+����Z�6��j�`�L��Za�I��N�0W���Z����:g��WWjs�#�Y��"�k5m�_���sh\���F%p䬵�6������\h2lNs�V��#�t�� }�K���Kvzs�>9>�l�+�>��^�n����~Ěg���e~%�w6ɓ������y��h�DC���b�KG-�d��__'0�{�7����&��yFD�2j~�����ټ�_��0�#��y�9��P�?���������f�fj6͙��r�V�K�{[ͮ�;4)O/��az{�<><__����G����[�0���v��G?e��������:���١I���z�M�Wۋ�x���������u�/��]1=��s��E&�q�l�-P3�{�vI�}��f��}�~��r�r�k�8�{���υ����O�֌ӹ�/�>�}�t	��|���Úq&���ݟW����ᓟwk�9���c̊l��Ui�̸z��f��i���_�j�S-|��w�J�<LծT��-9�����I�®�6 *3��y�[�.Ԗ�K��J���<�ݿ��-t�J���E�63���1R��}Ғbꨝט�l?�#���ӴQ��.�S���U
v�&�3�&O���0�9-�O�kK��V_gn��k��U_k˂�4�9�v�I�:;�w&��Q�ҍ�
��fG��B��-����ÇpNk�sZM�s���*��g8��-���V`b����H���
3cU'0hR
�w�XŁ�K݊�MV]�} o�w�tJJ���$꜁x$��l$>�F�EF�޺�G�j�#�G�t�bjj�F�б��q:�`O�4�y�8`Av<�x`��&I[��'A�˚�5��KAn��jx ��=Kn@��t����)�9��=�ݷ�tI��d\�M�j�B�${��G����VX�V6��f�#��V�wk ��W�8�	����lCDZ���ϖ@���X��x�W�Utq�ii�D($�X��Z'8Ay@�s�<�x͡�PU"rB�Q�_�Q6  ��[remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://df2ln847072y2"
path="res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex"
metadata={
"vram_texture": false
}
 t�a<Fh� <jV$��RSRC                     PackedScene            ��������                                                  resource_local_to_scene    resource_name    render_priority 
   next_pass    transparency    blend_mode 
   cull_mode    depth_draw_mode    no_depth_test    shading_mode    diffuse_mode    specular_mode    disable_ambient_light    vertex_color_use_as_albedo    vertex_color_is_srgb    albedo_color    albedo_texture    albedo_texture_force_srgb    albedo_texture_msdf 	   metallic    metallic_specular    metallic_texture    metallic_texture_channel 
   roughness    roughness_texture    roughness_texture_channel    emission_enabled 	   emission    emission_energy_multiplier    emission_operator    emission_on_uv2    emission_texture    normal_enabled    normal_scale    normal_texture    rim_enabled    rim 	   rim_tint    rim_texture    clearcoat_enabled 
   clearcoat    clearcoat_roughness    clearcoat_texture    anisotropy_enabled    anisotropy    anisotropy_flowmap    ao_enabled    ao_light_affect    ao_texture 
   ao_on_uv2    ao_texture_channel    heightmap_enabled    heightmap_scale    heightmap_deep_parallax    heightmap_flip_tangent    heightmap_flip_binormal    heightmap_texture    heightmap_flip_texture    subsurf_scatter_enabled    subsurf_scatter_strength    subsurf_scatter_skin_mode    subsurf_scatter_texture &   subsurf_scatter_transmittance_enabled $   subsurf_scatter_transmittance_color &   subsurf_scatter_transmittance_texture $   subsurf_scatter_transmittance_depth $   subsurf_scatter_transmittance_boost    backlight_enabled 
   backlight    backlight_texture    refraction_enabled    refraction_scale    refraction_texture    refraction_texture_channel    detail_enabled    detail_mask    detail_blend_mode    detail_uv_layer    detail_albedo    detail_normal 
   uv1_scale    uv1_offset    uv1_triplanar    uv1_triplanar_sharpness    uv1_world_triplanar 
   uv2_scale    uv2_offset    uv2_triplanar    uv2_triplanar_sharpness    uv2_world_triplanar    texture_filter    texture_repeat    disable_receive_shadows    shadow_to_opacity    billboard_mode    billboard_keep_scale    grow    grow_amount    fixed_size    use_point_size    point_size    use_particle_trails    proximity_fade_enabled    proximity_fade_distance    msdf_pixel_range    msdf_outline_size    distance_fade_mode    distance_fade_min_distance    distance_fade_max_distance    script    lightmap_size_hint 	   material    custom_aabb    flip_faces    add_uv2    uv2_padding    radius    height    radial_segments    rings    custom_solver_bias    margin    size    subdivide_width    subdivide_height    subdivide_depth 	   _bundled       Script    res://scripts/person.gd ��������   !   local://StandardMaterial3D_012l2 �         local://CapsuleMesh_mrpit ,         local://CapsuleShape3D_62rxu X      !   local://StandardMaterial3D_rws6b w         local://BoxMesh_dxxsi �         local://PackedScene_qjc80          StandardMaterial3D          ���>���> �}?  �?m         CapsuleMesh    o             m         CapsuleShape3D    m         StandardMaterial3D                            ��s?        ��?m         BoxMesh    o            z        �?���=  �?m         PackedScene    ~      	         names "         person    script    unit    CharacterBody3D    mesh 
   transform    MeshInstance3D 
   collision    shape    CollisionShape3D    box    visible    _on_input_event    input_event    	   variants                      �?              �?              �?      �?                                            node_count             nodes     +   ��������       ����                              ����                           	      ����                              
   ����                         conn_count             conns                                       node_paths              editable_instances              version       m      RSRC:RSRC                     PackedScene            ��������                                            �      resource_local_to_scene    resource_name    render_priority 
   next_pass    transparency    blend_mode 
   cull_mode    depth_draw_mode    no_depth_test    shading_mode    diffuse_mode    specular_mode    disable_ambient_light    vertex_color_use_as_albedo    vertex_color_is_srgb    albedo_color    albedo_texture    albedo_texture_force_srgb    albedo_texture_msdf 	   metallic    metallic_specular    metallic_texture    metallic_texture_channel 
   roughness    roughness_texture    roughness_texture_channel    emission_enabled 	   emission    emission_energy_multiplier    emission_operator    emission_on_uv2    emission_texture    normal_enabled    normal_scale    normal_texture    rim_enabled    rim 	   rim_tint    rim_texture    clearcoat_enabled 
   clearcoat    clearcoat_roughness    clearcoat_texture    anisotropy_enabled    anisotropy    anisotropy_flowmap    ao_enabled    ao_light_affect    ao_texture 
   ao_on_uv2    ao_texture_channel    heightmap_enabled    heightmap_scale    heightmap_deep_parallax    heightmap_flip_tangent    heightmap_flip_binormal    heightmap_texture    heightmap_flip_texture    subsurf_scatter_enabled    subsurf_scatter_strength    subsurf_scatter_skin_mode    subsurf_scatter_texture &   subsurf_scatter_transmittance_enabled $   subsurf_scatter_transmittance_color &   subsurf_scatter_transmittance_texture $   subsurf_scatter_transmittance_depth $   subsurf_scatter_transmittance_boost    backlight_enabled 
   backlight    backlight_texture    refraction_enabled    refraction_scale    refraction_texture    refraction_texture_channel    detail_enabled    detail_mask    detail_blend_mode    detail_uv_layer    detail_albedo    detail_normal 
   uv1_scale    uv1_offset    uv1_triplanar    uv1_triplanar_sharpness    uv1_world_triplanar 
   uv2_scale    uv2_offset    uv2_triplanar    uv2_triplanar_sharpness    uv2_world_triplanar    texture_filter    texture_repeat    disable_receive_shadows    shadow_to_opacity    billboard_mode    billboard_keep_scale    grow    grow_amount    fixed_size    use_point_size    point_size    use_particle_trails    proximity_fade_enabled    proximity_fade_distance    msdf_pixel_range    msdf_outline_size    distance_fade_mode    distance_fade_min_distance    distance_fade_max_distance    script    lightmap_size_hint 	   material    custom_aabb    flip_faces    add_uv2    uv2_padding    size    subdivide_width    subdivide_depth    center_offset    orientation    custom_solver_bias    margin    data    backface_collision    subdivide_height    radius    height    radial_segments    rings 	   _bundled       Script    res://scripts/WorldManager.gd ��������   PackedScene    res://person.tscn s2228�k   Script    res://scripts/camera.gd ��������
   !   local://StandardMaterial3D_i0n7k A         local://PlaneMesh_276hn �      $   local://ConcavePolygonShape3D_2jvo7 �      !   local://StandardMaterial3D_0ised 8         local://BoxMesh_k7qc7       !   local://StandardMaterial3D_iwuvl �         local://CapsuleMesh_38lq5 �      !   local://StandardMaterial3D_bc50r          local://CapsuleMesh_teujs I         local://PackedScene_udrt4 u         StandardMaterial3D          ���>���>���>  �?      R��>      ���>m      
   PlaneMesh    o             m         ConcavePolygonShape3D    {   #        �?      �?  ��      �?  �?      ��  ��      �?  ��      ��  �?      ��m         StandardMaterial3D                   ���<��p=  �?���>m         BoxMesh    o            m         StandardMaterial3D          �l>      �?  �?m         CapsuleMesh    o            m         StandardMaterial3D            �?    ��8>  �?m         CapsuleMesh    o            m         PackedScene    �      	         names "         world    script    Node3D    persons    Node    person 
   transform    person2    person3    person4    person5    floor    StaticBody3D    mesh    MeshInstance3D 
   collision    shape    CollisionShape3D    camera 	   Camera3D    sol    DirectionalLight3D 
   selection    visible    eixos    eixoZ    eixoX    	   variants                               �?              �?              �?�CA  �?�GA     �?              �?              �?��A  �?�GA     �?              �?              �?�@  �?�GA     �?              �?              �?�CA  �?@$�A     �?              �?              �?�CA  �?|@   =ID              �?            RhD                                 "�0���
���>H茳+)?�#@?9��?���<��A,%B�N��              �?            1�;�  �?      ��1�;�    ��6B                         �?             ��q�     �.A��ֲ        ,�AA            ��;�i�@    �b7�A�<=              �?cEA                       node_count             nodes     �   ��������       ����                            ����               ���                          ���                          ���                          ���	                          ���
                                 ����                     ����                                ����            	                     ����      
                           ����                           ����                                 ����                     ����                                ����                         conn_count              conns               node_paths              editable_instances              version       m      RSRCy�N� X����m[remap]

path="res://.godot/exported/133200997/export-a763181cad695198163108dfada3c8c5-person.scn"
؜=i1m� ���'[remap]

path="res://.godot/exported/133200997/export-76e0adcbc83681695885bae615f516ae-world.scn"
-�}b��D�8�z#@<svg height="128" width="128" xmlns="http://www.w3.org/2000/svg"><g transform="translate(32 32)"><path d="m-16-32c-8.86 0-16 7.13-16 15.99v95.98c0 8.86 7.13 15.99 16 15.99h96c8.86 0 16-7.13 16-15.99v-95.98c0-8.85-7.14-15.99-16-15.99z" fill="#363d52"/><path d="m-16-32c-8.86 0-16 7.13-16 15.99v95.98c0 8.86 7.13 15.99 16 15.99h96c8.86 0 16-7.13 16-15.99v-95.98c0-8.85-7.14-15.99-16-15.99zm0 4h96c6.64 0 12 5.35 12 11.99v95.98c0 6.64-5.35 11.99-12 11.99h-96c-6.64 0-12-5.35-12-11.99v-95.98c0-6.64 5.36-11.99 12-11.99z" fill-opacity=".4"/></g><g stroke-width="9.92746" transform="matrix(.10073078 0 0 .10073078 12.425923 2.256365)"><path d="m0 0s-.325 1.994-.515 1.976l-36.182-3.491c-2.879-.278-5.115-2.574-5.317-5.459l-.994-14.247-27.992-1.997-1.904 12.912c-.424 2.872-2.932 5.037-5.835 5.037h-38.188c-2.902 0-5.41-2.165-5.834-5.037l-1.905-12.912-27.992 1.997-.994 14.247c-.202 2.886-2.438 5.182-5.317 5.46l-36.2 3.49c-.187.018-.324-1.978-.511-1.978l-.049-7.83 30.658-4.944 1.004-14.374c.203-2.91 2.551-5.263 5.463-5.472l38.551-2.75c.146-.01.29-.016.434-.016 2.897 0 5.401 2.166 5.825 5.038l1.959 13.286h28.005l1.959-13.286c.423-2.871 2.93-5.037 5.831-5.037.142 0 .284.005.423.015l38.556 2.75c2.911.209 5.26 2.562 5.463 5.472l1.003 14.374 30.645 4.966z" fill="#fff" transform="matrix(4.162611 0 0 -4.162611 919.24059 771.67186)"/><path d="m0 0v-47.514-6.035-5.492c.108-.001.216-.005.323-.015l36.196-3.49c1.896-.183 3.382-1.709 3.514-3.609l1.116-15.978 31.574-2.253 2.175 14.747c.282 1.912 1.922 3.329 3.856 3.329h38.188c1.933 0 3.573-1.417 3.855-3.329l2.175-14.747 31.575 2.253 1.115 15.978c.133 1.9 1.618 3.425 3.514 3.609l36.182 3.49c.107.01.214.014.322.015v4.711l.015.005v54.325c5.09692 6.4164715 9.92323 13.494208 13.621 19.449-5.651 9.62-12.575 18.217-19.976 26.182-6.864-3.455-13.531-7.369-19.828-11.534-3.151 3.132-6.7 5.694-10.186 8.372-3.425 2.751-7.285 4.768-10.946 7.118 1.09 8.117 1.629 16.108 1.846 24.448-9.446 4.754-19.519 7.906-29.708 10.17-4.068-6.837-7.788-14.241-11.028-21.479-3.842.642-7.702.88-11.567.926v.006c-.027 0-.052-.006-.075-.006-.024 0-.049.006-.073.006v-.006c-3.872-.046-7.729-.284-11.572-.926-3.238 7.238-6.956 14.642-11.03 21.479-10.184-2.264-20.258-5.416-29.703-10.17.216-8.34.755-16.331 1.848-24.448-3.668-2.35-7.523-4.367-10.949-7.118-3.481-2.678-7.036-5.24-10.188-8.372-6.297 4.165-12.962 8.079-19.828 11.534-7.401-7.965-14.321-16.562-19.974-26.182 4.4426579-6.973692 9.2079702-13.9828876 13.621-19.449z" fill="#478cbf" transform="matrix(4.162611 0 0 -4.162611 104.69892 525.90697)"/><path d="m0 0-1.121-16.063c-.135-1.936-1.675-3.477-3.611-3.616l-38.555-2.751c-.094-.007-.188-.01-.281-.01-1.916 0-3.569 1.406-3.852 3.33l-2.211 14.994h-31.459l-2.211-14.994c-.297-2.018-2.101-3.469-4.133-3.32l-38.555 2.751c-1.936.139-3.476 1.68-3.611 3.616l-1.121 16.063-32.547 3.138c.015-3.498.06-7.33.06-8.093 0-34.374 43.605-50.896 97.781-51.086h.066.067c54.176.19 97.766 16.712 97.766 51.086 0 .777.047 4.593.063 8.093z" fill="#478cbf" transform="matrix(4.162611 0 0 -4.162611 784.07144 817.24284)"/><path d="m0 0c0-12.052-9.765-21.815-21.813-21.815-12.042 0-21.81 9.763-21.81 21.815 0 12.044 9.768 21.802 21.81 21.802 12.048 0 21.813-9.758 21.813-21.802" fill="#fff" transform="matrix(4.162611 0 0 -4.162611 389.21484 625.67104)"/><path d="m0 0c0-7.994-6.479-14.473-14.479-14.473-7.996 0-14.479 6.479-14.479 14.473s6.483 14.479 14.479 14.479c8 0 14.479-6.485 14.479-14.479" fill="#414042" transform="matrix(4.162611 0 0 -4.162611 367.36686 631.05679)"/><path d="m0 0c-3.878 0-7.021 2.858-7.021 6.381v20.081c0 3.52 3.143 6.381 7.021 6.381s7.028-2.861 7.028-6.381v-20.081c0-3.523-3.15-6.381-7.028-6.381" fill="#fff" transform="matrix(4.162611 0 0 -4.162611 511.99336 724.73954)"/><path d="m0 0c0-12.052 9.765-21.815 21.815-21.815 12.041 0 21.808 9.763 21.808 21.815 0 12.044-9.767 21.802-21.808 21.802-12.05 0-21.815-9.758-21.815-21.802" fill="#fff" transform="matrix(4.162611 0 0 -4.162611 634.78706 625.67104)"/><path d="m0 0c0-7.994 6.477-14.473 14.471-14.473 8.002 0 14.479 6.479 14.479 14.473s-6.477 14.479-14.479 14.479c-7.994 0-14.471-6.485-14.471-14.479" fill="#414042" transform="matrix(4.162611 0 0 -4.162611 656.64056 631.05679)"/></g></svg>
G    �Ƃ��i   res://icon.svgs2228�k   res://person.tscn�}���7�=   res://world.tscnPl�5�v   res://dist/hw4.icon.png��=el�Qa#   res://dist/hw4.apple-touch-icon.pngϾ���v�   res://dist/hw4.pngxn���K�`ECFG      application/config/name         hw4    application/run/main_scene         res://world.tscn   application/config/features(   "         4.0    GL Compatibility       application/config/icon         res://icon.svg     autoload/KernelMouse(         *res://scripts/MouseAction.gd      input/ui_left�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device         	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode     @    physical_keycode       	   key_label             unicode     @    echo          script            InputEventJoypadButton        resource_local_to_scene           resource_name             device            button_index         pressure          pressed           script            InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   D   	   key_label             unicode    d      echo          script         input/ui_right�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device         	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode     @    physical_keycode       	   key_label             unicode     @    echo          script            InputEventJoypadButton        resource_local_to_scene           resource_name             device            button_index         pressure          pressed           script            InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   A   	   key_label             unicode    a      echo          script         input/ui_up�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device         	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode     @    physical_keycode       	   key_label             unicode     @    echo          script            InputEventJoypadButton        resource_local_to_scene           resource_name             device            button_index         pressure          pressed           script            InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   W   	   key_label             unicode    w      echo          script         input/ui_down�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device         	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode     @    physical_keycode       	   key_label             unicode     @    echo          script            InputEventJoypadButton        resource_local_to_scene           resource_name             device            button_index         pressure          pressed           script            InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   S   	   key_label             unicode    s      echo          script         input/ui_fc�              deadzone      ?      events              InputEventMouseButton         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          button_mask          position     .C  0A   global_position      2C  XB   factor       �?   button_index         pressed          double_click          script         input/mouse_right�              deadzone      ?      events              InputEventMouseButton         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          button_mask          position     :C  �A   global_position      >C  pB   factor       �?   button_index         pressed          double_click          script         input/mouse_left�              deadzone      ?      events              InputEventMouseButton         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          button_mask          position     %C  �A   global_position      )C  tB   factor       �?   button_index         pressed          double_click          script      #   rendering/renderer/rendering_method         gl_compatibility*   rendering/renderer/rendering_method.mobile         gl_compatibility�D3Pޒ�P[�e