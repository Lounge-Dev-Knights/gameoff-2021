extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Hide quit button on html/mobile
	if not OS.has_feature("pc"):
		$CenterContainer/VBoxContainer/Quit.hide()



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Quit_pressed() -> void:
	get_tree().quit()
	SoundEngine.play_sound("MenuButtonSound")

func _on_NewGame_pressed() -> void:
	SceneLoader.goto_scene("res://game/intro/Intro.tscn")
	SoundEngine.play_sound("MenuButtonSound")

func _on_Earworm_pressed() -> void:
	SceneLoader.goto_scene("res://game/disco/minigames/earworm/Earworm.tscn")
	SoundEngine.play_sound("MenuButtonSound")

func _on_Disco_Light_pressed():
	SceneLoader.goto_scene("res://game/disco/disco_light_minigame/LightMinigame.tscn")
	SoundEngine.play_sound("MenuButtonSound")

func _on_Cocktail_Bar_pressed():
	SceneLoader.goto_scene("res://game/disco/minigames/cocktail_bar/CocktailBar.tscn")
	SoundEngine.play_sound("MenuButtonSound")

func _on_Button_mouse_entered():
	SoundEngine.play_sound("MenuButtonHoverSound")
