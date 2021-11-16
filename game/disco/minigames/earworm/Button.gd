extends Node2D

var mouse_over = false
onready var button = get_node("TextureButton")
var timer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#
	
func _on_Area2D_input_event(viewport, event, shape_idx):
	print("yay")
	$AudioStreamPlayer2D.play()


func _on_TextureButton_pressed():
	$AudioStreamPlayer2D.play()
	button.pressed = true
	button.focus_mode = Control.FOCUS_CLICK
	yield(get_tree().create_timer(0.5), "timeout")
	button.pressed = false
	button.focus_mode = Control.FOCUS_NONE
