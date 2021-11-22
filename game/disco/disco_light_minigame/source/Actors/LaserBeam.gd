extends Node2D

const MAX_LENGTH = 2000

onready var beam = $LaserBeam
onready var laserend = $LaserEnd
onready var rayCast2D = $RayCast2D

func _physics_process(delta: float) -> void:
	var aim_position = Vector2(50, 500)
	var mouse_position = get_local_mouse_position()
	var max_cast_to = mouse_position.normalized() * MAX_LENGTH
	rayCast2D.cast_to = max_cast_to
	if rayCast2D.is_colliding():
		laserend.global_position = rayCast2D.get_collision_point()
	else:
		laserend.global_position = rayCast2D.cast_to
	beam.rotation = rayCast2D.cast_to.angle()
	beam.region_rect.end.x = laserend.position.length()
	
