extends KinematicBody2D

signal content_changed(content)


onready var content_area = $Content


func _physics_process(delta: float):
	move_and_slide(get_local_mouse_position() * 10)
	rotation_degrees = clamp(get_local_mouse_position().x * 0.1, -20, 20)


func get_content(clear := false) -> Dictionary:
	var content = {}
	for body in content_area.get_overlapping_bodies():
		var ingredient = body.filename.get_file().trim_suffix(".tscn")
		if content.has(ingredient):
			content[ingredient] += 1
		else:
			content[ingredient] = 1
		
		if clear:
			body.free()
			call_deferred("emit_signal", "content_changed", {})
	
	return content


func _on_Content_body_entered(body: Node) -> void:
	emit_signal("content_changed", get_content())


func _on_Content_body_exited(body: Node) -> void:
	emit_signal("content_changed", get_content())
