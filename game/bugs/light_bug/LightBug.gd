extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	$AnimationPlayer.seek(randf() * $AnimationPlayer.current_animation_length)
	$WingAnimationPlayer.seek(randf() * $WingAnimationPlayer.current_animation_length)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
