extends Node2D

var text: String

# Called when the node enters the scene tree for the first time.
func _ready():
	$Control/Label.text = text
	$Tween.interpolate_property($Control, "rect_scale", Vector2(0, 0), Vector2(1, 1), 0.5, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	$Tween.interpolate_property(self, "modulate", Color.white, Color.transparent, 0.2, Tween.TRANS_CUBIC, Tween.EASE_OUT, 0.5)
	
	$CPUParticles2D.emitting = true
	$Tween.start()
	$AudioStreamPlayer2D.play()
	
	yield($Tween, "tween_all_completed")
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
