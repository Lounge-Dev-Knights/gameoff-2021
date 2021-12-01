extends "res://game/disco/disco_light_minigame/source/Actors/ActorBug.gd"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	$AnimationPlayer.seek(randf() * $AnimationPlayer.current_animation_length)
	$WingAnimationPlayer.seek(randf() * $WingAnimationPlayer.current_animation_length)
	_velocity.y = speed.y
	_velocity.x = speed.x
	current_light_hp = max_light_hp
	$LightHPbar/theBar.max_value = max_light_hp
	$bug/TailLight/Light2D.energy = 1

func _physics_process(delta: float) -> void:
	if is_on_ceiling() or is_on_floor():
		_velocity.y *= -1.0
		light_damage(light_loss_speed)
	_velocity.x = 0.0  #i just want them to go up and down for now.
	move_and_slide(_velocity, FLOOR_NORMAL)

func light_damage(light_damage):
	current_light_hp -= light_damage
	$bug/TailLight/Light2D.energy = float(current_light_hp)/max_light_hp*0.8 + 0.3
	$bug/TailLight/Light2D.texture_scale = float(current_light_hp)/max_light_hp*0.6 + 0.3
	if current_light_hp <= 0:
		$bug/TailLight/Light2D.energy = 0
	$LightHPbar.set_percent_value(float(current_light_hp)/max_light_hp*100)
	$LightHPbar.assign_color(current_light_hp)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
