extends KinematicBody2D
class_name ActorBug

const FLOOR_NORMAL: = Vector2.UP

export var speed: = Vector2(500,0)
export var gravity: = 2000
var _velocity: = Vector2.ZERO

export var max_light_hp: = 100
export var light_loss_speed: = 5
var current_light_hp: = 0
	
