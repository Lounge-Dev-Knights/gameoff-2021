extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var dialog = Dialogic.start("Styling")
	
	add_child(dialog)
	
	yield(dialog, "timeline_end")
	
	SceneLoader.goto_scene("res://game/intro/DiscoArrival.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
