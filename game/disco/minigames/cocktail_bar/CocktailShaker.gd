extends KinematicBody2D


onready var content_area = $Content
onready var shaker = $CocktailShaker
onready var glass = $CocktailGlass
onready var particles := $CPUParticles2D
onready var tween := $Tween

var is_cocktail := false

var _content := {}


func _physics_process(delta: float):
	move_and_slide(get_local_mouse_position() * 10)
	rotation_degrees = clamp(get_local_mouse_position().x * 0.1, -20, 20)


func _input(event: InputEvent) -> void:
	if event.is_action("finish_drink") and event.is_pressed():
		create_cocktail()


func create_cocktail() -> void:
	if is_cocktail or get_content().size() == 0:
		return
	
	_content = get_content(true)
	set_collision_mask_bit(0, false)
	shaker.visible = false
	glass.visible = true
	is_cocktail = true
	particles.emitting = true
	
	print("Cocktail created with: %s" % str(_content))
	
	SoundEngine.play_sound("Cocktail_done")


func reset_cocktail() -> void:
	_content = {}
	set_collision_mask_bit(0, true)
	shaker.visible = true
	glass.visible = false
	
	is_cocktail = false


func get_content(clear := false) -> Dictionary:
	if is_cocktail:
		return _content
	
	var content = {}
	for body in content_area.get_overlapping_bodies():
		var ingredient = body.filename.get_file().trim_suffix(".tscn")
		if content.has(ingredient):
			content[ingredient] += 1
		else:
			content[ingredient] = 1
		
		if clear:
			body.free()
	
	return content
	
	


func _on_Content_body_entered(body: KinematicBody2D) -> void:
	tween.stop_all()
	tween.interpolate_property(
		shaker,
		"scale",
		shaker.scale,
		Vector2(0.55, 0.55),
		0.05,
		Tween.TRANS_CIRC,
		Tween.EASE_IN
	)
	tween.interpolate_property(
		shaker,
		"scale",
		Vector2(0.55, 0.55),
		Vector2(0.5, 0.5),
		0.05,
		Tween.TRANS_CIRC,
		Tween.EASE_OUT,
		0.05
	)
	tween.start()
	
	SoundEngine.play_sound("Cocktail_drop")




func _on_Content_body_exited(body: KinematicBody2D) -> void:
	tween.stop_all()
	tween.interpolate_property(
		shaker,
		"scale",
		shaker.scale,
		Vector2(0.45, 0.45),
		0.05,
		Tween.TRANS_CIRC,
		Tween.EASE_IN
	)
	tween.interpolate_property(
		shaker,
		"scale",
		Vector2(0.45, 0.45),
		Vector2(0.5, 0.5),
		0.05,
		Tween.TRANS_CIRC,
		Tween.EASE_OUT,
		0.05
	)
	tween.start()
