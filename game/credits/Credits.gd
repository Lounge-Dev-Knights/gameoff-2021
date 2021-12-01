extends Node2D


const FADE_DURATION = 0.5

onready var background = $CanvasLayer/Background
onready var tween = $Tween

var step = -1


func _ready() -> void:
	for credit in $Credits.get_children():
		credit.modulate = Color.transparent
		MusicEngine.play_song("Club1")
	next_page()


func _process(delta: float) -> void:
	# modulate background
	background.modulate.h = wrapf(background.modulate.h + delta * 0.2, 0.0, 1.0)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		SoundEngine.play_sound(SoundEngine.sounds.keys()[randi() % SoundEngine.sounds.size()])
		next_page()


func next_page() -> void:
	step = wrapi(step + 1, 0, $Credits.get_child_count())
	var credits = $Credits.get_children()
	var next = credits[step]
	
	tween.stop_all()
	tween.remove_all()
	
	for credit in credits:
		credit.visible = true
		
		if credit == next:
			tween.interpolate_property(credit, "modulate", credit.modulate, Color.white, FADE_DURATION, Tween.TRANS_CUBIC, Tween.EASE_IN, FADE_DURATION)
		else:
			tween.interpolate_property(credit, "modulate", credit.modulate, Color.transparent, FADE_DURATION, Tween.TRANS_CUBIC, Tween.EASE_IN)
		
		tween.start()
		
func _on_MenutButton_pressed() -> void:
	SoundEngine.play_sound("MenuButtonSound")
	SceneLoader.goto_scene("res://game/title_screen/TitleScreen.tscn")
	
	
func _on_MenutButton_mouse_entered() -> void:
	SoundEngine.play_sound("MenuButtonSound")
