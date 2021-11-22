extends "res://game/disco/disco_light_minigame/source/Actors/Actor.gd"

func _ready() -> void:
	_velocity.y = speed.y
	_velocity.x = speed.x

func _physics_process(delta: float) -> void:
	if is_on_ceiling() or is_on_floor():
		_velocity.y *= -1.0
	_velocity.x = 0.0  #i just want them to go up and down for now.
	move_and_slide(_velocity, FLOOR_NORMAL)

