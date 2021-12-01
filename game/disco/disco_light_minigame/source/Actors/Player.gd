extends Actor

export var light_give_speed: = 40
var give_light_true = false
var deltaLightGive = 100

func _physics_process(delta: float) -> void:
	var is_jump_interrupted: = Input.is_action_just_released("jump") and _velocity.y < 0.0
	var direction: = get_direction()
	_velocity = calculate_move_velocity(_velocity, speed, direction, is_jump_interrupted)
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
	if deltaLightGive >= 0.1:
		for bodies in $RefillArea2D.get_overlapping_bodies():
			if bodies.has_method("light_damage") == true:
				bodies.light_damage(float(-light_give_speed * deltaLightGive))
		deltaLightGive *= 0
	deltaLightGive += delta

func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), 
		-1.0 if Input.is_action_just_pressed("jump") and is_on_floor() else 1.0
	)

func calculate_move_velocity(
		linear_velocity: Vector2, 
		speed: Vector2, 
		direction: Vector2,
		is_jump_interrupted: bool
	) -> Vector2:
	var out_velocity: = linear_velocity
	out_velocity.x = speed.x * direction.x
	out_velocity.y += gravity * get_physics_process_delta_time()
	if direction.y == -1.0:
		out_velocity.y = speed.y * direction.y
	if is_jump_interrupted:
		out_velocity.y = 0.0
	return out_velocity

func give_light(body):
	pass

func _on_RefillArea2D_body_entered(body: Node) -> void:
	#if body.has_method("light_damage") == true:
		#body.light_damage(-light_give_speed * get_physics_process_delta_time())
	pass

func _on_RefillArea2D_body_exited(body: Node) -> void:
	give_light_true = false
	pass # Replace with function body.

