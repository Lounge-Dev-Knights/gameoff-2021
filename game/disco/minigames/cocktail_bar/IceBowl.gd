extends Area2D




func spawn_ice_cube() -> void:
	var ice_cube = preload("res://game/disco/minigames/cocktail_bar/ingredients/IceCube.tscn").instance()
	#ice_cube.position = get_local_mouse_position()
	ice_cube.apply_central_impulse(Vector2(rand_range(-100, 100), -250))
	#ce_cube.apply_torque(rand_range(-1, 1))
	
	add_child(ice_cube)


func _on_IceBowl_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		spawn_ice_cube()


func _on_Timer_timeout():
	call_deferred("spawn_ice_cube")
