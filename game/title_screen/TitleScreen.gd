extends Control


onready var background = $Background


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#MusicEngine.play_song("Club2")
	
	# Hide quit button on html/mobile
	if not OS.has_feature("pc"):
		$CenterContainer/VBoxContainer/Quit.hide()
	


func _process(delta: float) -> void:
	
	background.modulate.h = wrapf(background.modulate.h + delta * 0.2, 0.0, 1.0)
	#print(modulate.h)


func _on_Quit_pressed() -> void:
	get_tree().quit()
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


func _on_StartGameButton_pressed():
	SceneLoader.goto_scene("res://game/intro/DiscoArrival.tscn")
	SoundEngine.play_sound("MenuButtonSound")
