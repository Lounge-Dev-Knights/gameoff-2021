extends KinematicBody2D


onready var content_area = $Content


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	move_and_slide(get_local_mouse_position() * 10)
	rotation_degrees = clamp(get_local_mouse_position().x * 0.1, -20, 20)


func get_content() -> Array:
	var content = []
	for body in content_area.get_overlapping_bodies():
		content.append(body.filename.get_file().trim_suffix(".tscn"))
		body.queue_free()
	
	return content
