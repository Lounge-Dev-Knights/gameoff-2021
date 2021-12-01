extends Node2D

const MAX_LENGTH = 2000

onready var beam = $LaserBeam
onready var laserend = $LaserEnd
onready var rayCast2D = $RayCast2D
var interpolatedpoint: = Vector2.ZERO
var totalDelta: = 0.0

func _ready() -> void:
	interpolatedpoint = _setRandomPoint()
	laserend.global_position = interpolatedpoint
	#print("ready func finished")

func _physics_process(delta: float) -> void:
	totalDelta += delta
	if totalDelta >= 0.08:
		if interpolatedpoint.x <= laserend.global_position.x + 8 and interpolatedpoint.y >= laserend.global_position.y - 8:
			interpolatedpoint = _setRandomPoint()
		#interpolatedpoint = lerp(interpolatedpoint, laserend.global_position, 0.1)
		#rayCast2D.cast_to = interpolatedpoint #max_cast_to
		rayCast2D.cast_to = rayCast2D.cast_to.linear_interpolate(interpolatedpoint, 0.2)
		#if rayCast2D.is_colliding():
		#	laserend.global_position = rayCast2D.get_collision_point()
		#else:
		laserend.global_position = rayCast2D.cast_to
		#print(rayCast2D.cast_to)
		beam.rotation = rayCast2D.cast_to.angle()
		beam.region_rect.end.x = laserend.position.length()
		totalDelta = 0

func _setRandomPoint() -> Vector2:
	randomize()
	var randomVector: = Vector2.ZERO
	randomVector.x = randi() % 1000 + 5
	randomVector.y = randi() % 590 + 5
	
	#print("random number:")
	#print(randomVector)
	return randomVector
	
