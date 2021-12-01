extends "res://game/disco/disco_light_minigame/source/Actors/ActorBug.gd"

var deltaLightLoss = 0
var _velocityFactor = 1.0

func _ready() -> void:
	current_light_hp = max_light_hp
	_velocity.y = speed.y
	_velocity.x = speed.x
	current_light_hp = max_light_hp
	$LightHPbar/theBar.max_value = max_light_hp
	$Light2D.energy = 1

func _on_LightRefillerArea2d_body_entered(body: Node) -> void:
	_velocityFactor = 0.3
	pass # Replace with function body.
	
func _on_LightRefillerArea2d_body_exited(body: Node) -> void:
	_velocityFactor = 1
	pass # Replace with function body.
	
func _physics_process(delta: float) -> void:
	deltaLightLoss += delta
	if is_on_ceiling() or is_on_floor():
		_velocity.y *= -1.0
	_velocity.x = 0.0  #i just want them to go up and down for now.
	move_and_slide(_velocity * _velocityFactor, FLOOR_NORMAL)
	if deltaLightLoss >= 0.1:
		light_damage(float(light_loss_speed * deltaLightLoss))
		deltaLightLoss *= 0
	
	

func light_damage(light_damage):
	if current_light_hp - light_damage <= 0:
		current_light_hp = 0
	elif current_light_hp - light_damage >= max_light_hp:
		current_light_hp = max_light_hp
	else:
		current_light_hp -= light_damage
	#print(light_damage)
	$Light2D.energy = float(current_light_hp)/max_light_hp*0.8 + 0.3
	$Light2D.texture_scale = float(current_light_hp)/max_light_hp*0.6 + 0.3
	if current_light_hp <= 0:
		$Light2D.energy = 0
	$LightHPbar.set_percent_value(float(current_light_hp)/max_light_hp*100)
	$LightHPbar.assign_color(current_light_hp)
	



