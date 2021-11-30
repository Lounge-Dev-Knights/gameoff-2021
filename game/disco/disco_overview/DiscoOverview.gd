extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

onready var background = $CanvasLayer/TextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SceneLoader.fade_color = Color.black
	MusicEngine.play_song("Club1")



func _process(delta: float) -> void:
	
	background.modulate.h = wrapf(background.modulate.h + delta * 0.2, 0.0, 1.0)
	#print(modulate.h)
