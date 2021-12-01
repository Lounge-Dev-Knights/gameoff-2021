extends "res://game/disco/disco_light_minigame/source/Actors/ActorBug.gd"

export var texture_scale_light: = 1

var deltaLightLoss = 0
var _velocityFactor = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	$AnimationPlayer.seek(randf() * $AnimationPlayer.current_animation_length)
	$WingAnimationPlayer.seek(randf() * $WingAnimationPlayer.current_animation_length)
	_velocity.y = speed.y
	_velocity.x = speed.x
	current_light_hp = max_light_hp
	$LightHPbar/theBar.max_value = max_light_hp
	$bug/TailLight/Light2D.energy = 1.4


func _on_LightRefillerArea2d_body_entered(body: Node) -> void:
	_velocityFactor = 0.4
	pass # Replace with function body.


func _on_LightRefillerArea2d_body_exited(body: Node) -> void:
	_velocityFactor = 1
	pass # Replace with function body.
	
func _physics_process(delta: float) -> void:
	deltaLightLoss += delta
	if is_on_ceiling() or is_on_floor():
		_velocity.y *= -1.0
	if is_on_wall():
		_velocity.x *= -1.0
	#_velocity.x = 0.0  #i just want them to go up and down for now.
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
	$bug/TailLight/Light2D.energy = float(current_light_hp)/max_light_hp*0.8 + 0.7
	$bug/TailLight/Light2D.texture_scale = float(current_light_hp)/max_light_hp*0.6 + texture_scale_light
	if current_light_hp <= 0:
		$bug/TailLight/Light2D.energy = 0
	$LightHPbar.set_percent_value(float(current_light_hp)/max_light_hp*100)
	$LightHPbar.assign_color(current_light_hp)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass



