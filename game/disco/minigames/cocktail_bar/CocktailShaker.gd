extends KinematicBody2D


onready var content_area = $Content
onready var shaker = $CocktailShaker
onready var glass = $CocktailGlass

var is_cocktail := false

var _content := {}


func _physics_process(delta: float):
	move_and_slide(get_local_mouse_position() * 10)
	rotation_degrees = clamp(get_local_mouse_position().x * 0.1, -20, 20)


func _input(event: InputEvent) -> void:
	if event.is_action("finish_drink") and event.is_pressed():
		create_cocktail()


func create_cocktail() -> void:
	_content = get_content(true)
	set_collision_mask_bit(0, false)
	shaker.visible = false
	glass.visible = true
	is_cocktail = true


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

