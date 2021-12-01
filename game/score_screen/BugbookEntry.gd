extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_BugbookEntry_mouse_entered():
	rect_scale = Vector2(1.5, 1.5)

	


func _on_BugbookEntry_mouse_exited():
	rect_scale = Vector2(1.0, 1.0)
