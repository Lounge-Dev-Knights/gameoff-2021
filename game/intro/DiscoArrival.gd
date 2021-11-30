extends Node2D


export(float) var cutoff := 100.0 setget _set_cutoff

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var protagonist_name = $CanvasLayer/CenterContainer/CenterContainerRight/NameCard/VBoxContainer/Name
onready var name_card = $CanvasLayer/CenterContainer/CenterContainerRight/NameCard

# Called when the node enters the scene tree for the first time.
func _ready():
	AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index("Music"), 0, true)
	MusicEngine.play_song("Club1")
	
	Dialogic.set_variable("accessory", "Bow Tie")
	var dialog = Dialogic.start("Party Arrival")
	add_child(dialog)
	yield(dialog, "timeline_end")
	name_card.show()
	

func _exit_tree() -> void:
	AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index("Music"), 0, false)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_name_entered():
	Dialogic.set_variable("name", protagonist_name.text)
	
	var dialog = Dialogic.start("Name Entered")
	add_child(dialog)
	yield(dialog, "timeline_end")
	$AnimationPlayer.play("walk_in")
	
	yield($AnimationPlayer, "animation_finished")
	SceneLoader.fade_color = Color(10, 10, 10, 1.0)
	SceneLoader.goto_scene("res://game/disco/disco_overview/DiscoOverview.tscn")


func _on_VideoPlayer_finished() -> void:
	print("finished")
	$Background/VideoPlayer.play()


func _set_cutoff(new_value: float) -> void:
	var lowpass: AudioEffectLowPassFilter = AudioServer.get_bus_effect(AudioServer.get_bus_index("Music"), 0)
	lowpass.cutoff_hz = new_value
	cutoff = new_value
