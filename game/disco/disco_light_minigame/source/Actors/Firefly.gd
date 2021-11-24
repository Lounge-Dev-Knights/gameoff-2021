extends "res://game/disco/disco_light_minigame/source/Actors/Actor.gd"

export var max_light_hp: = 100
export var light_loss_speed: = 5
var current_light_hp: = 0

func _ready() -> void:
	_velocity.y = speed.y
	_velocity.x = speed.x
	current_light_hp = max_light_hp
	$LightHPbar/theBar.max_value = max_light_hp
	$Light2D.energy = 1

func _on_LightRefillerArea2d_body_entered(body: Node) -> void:
	#if body.global_position <= get_node("LightRefillerArea2d").global_position:
	#	_velocity = Vector2.ZERO
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	if is_on_ceiling() or is_on_floor():
		_velocity.y *= -1.0
		light_damage(light_loss_speed)
	_velocity.x = 0.0  #i just want them to go up and down for now.
	move_and_slide(_velocity, FLOOR_NORMAL)
	

func light_damage(light_damage):
	current_light_hp -= light_damage
	$Light2D.energy = float(current_light_hp)/max_light_hp*0.8 + 0.3
	$Light2D.texture_scale = float(current_light_hp)/max_light_hp*0.6 + 0.3
	if current_light_hp <= 0:
		$Light2D.energy = 0
	$LightHPbar.set_percent_value(float(current_light_hp)/max_light_hp*100)
	$LightHPbar.assign_color(current_light_hp)
	
