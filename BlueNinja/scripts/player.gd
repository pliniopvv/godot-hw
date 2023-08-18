extends CharacterBody3D

@export_category("Básicas")
@export var SPEED = 5.0
@export var JUMP_VELOCITY = 8

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	#cálculos de direções e animações
	var direction = Vector3.ZERO
	var run_speed = 0
	$sword.visible = false
	var animation = "walking"
	if Input.is_action_pressed("ui_up"):
		direction.z = 1
	if Input.is_action_pressed("ui_down"):
		direction.z = -1
	if Input.is_action_pressed("ui_left"):
		direction.x = 1
	if Input.is_action_pressed("ui_right"):
		direction.x = -1
	
	if Input.is_action_pressed("run"):
		run_speed = 1
		animation = "fast_run"
	
	if Input.is_action_pressed("attack"):
		$sword.visible = true
		$anim.play("attack2")
		$sword/anim.play("sworldattack2")
	elif direction != Vector3.ZERO:
		direction = direction.normalized()
		$anim.play(animation)
		$mesh.look_at(position + direction, Vector3.UP)
		$sword.look_at(position + direction, Vector3.UP)
		if Input.is_action_pressed("run"):
			$sword.visible = true
			$sword/anim.play("swordfast_run")
	else:
		$anim.play("idle")
	
	
	# rotação
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction:
		velocity.x = direction.x * (SPEED + (SPEED*run_speed))
		velocity.z = direction.z * (SPEED + (SPEED*run_speed))
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()
