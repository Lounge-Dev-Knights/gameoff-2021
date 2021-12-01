extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#visible = false
	pass # Replace with function body.

func _on_Start_again_pressed() -> void:
	get_tree().paused = false
	SceneLoader.goto_scene("res://game/disco/disco_light_minigame/LightMinigame.tscn")
	MusicEngine.play_song("Club2")
	pass # Replace with function body.

func _on_Quit_pressed() -> void:
	get_tree().paused = false
	SceneLoader.goto_scene("res://game/title_screen/TitleScreen.tscn")
	pass # Replace with function body.
