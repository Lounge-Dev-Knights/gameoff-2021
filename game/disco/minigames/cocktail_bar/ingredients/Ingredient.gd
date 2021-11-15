extends RigidBody2D



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if position.y > get_viewport_rect().size.y * 2:
		queue_free()
