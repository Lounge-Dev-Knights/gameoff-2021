extends Node2D

const BUGS = [
	preload("res://game/bugs/doctor_bug/DoctorBug.tscn"),
	preload("res://game/bugs/chandelier_bug/ChandelierBUg.tscn"),
	preload("res://game/bugs/bug_queen/BugQueen.tscn"),
	preload("res://game/bugs/bug_pack/BugPack.tscn"),
	preload("res://game/bugs/light_bug/LightBug.tscn"),
	preload("res://game/bugs/light_bug/LightBug.tscn"),
	preload("res://game/bugs/nose_bug/NoseBug.tscn"),
	preload("res://game/bugs/bug_bunny/BugBunny.tscn"),
	preload("res://game/bugs/Bug_Vamp/Vamp.tscn"),
	preload("res://game/bugs/Bug_Cute/BugCute.tscn"),
	preload("res://game/bugs/Bug_Ant/BugAnt.tscn")
]



onready var background = $CanvasLayer/TextureRect
onready var party_audience = $PartyAudience


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SceneLoader.fade_color = Color.black
	MusicEngine.play_song("Club1")
	
	
	var guest_count = int(BUGS.size() * (float(TotalScore.calculate_total()) / float(TotalScore.maximum_score)))
	guest_count = min(guest_count, BUGS.size())
	
	BUGS.shuffle()
	
	for i in range(guest_count):
		var guest = BUGS[i].instance()
		guest.position = Vector2(rand_range(-800, 800), rand_range(-300, 300))
		party_audience.add_child(guest)
	



func _process(delta: float) -> void:
	
	background.modulate.h = wrapf(background.modulate.h + delta * 0.2, 0.0, 1.0)
	#print(modulate.h)


func _on_FinalScoreButton_pressed():
	SceneLoader.goto_scene("res://game/score_screen/ScoreScreen.tscn")


func _on_FinalScoreButton_mouse_entered():
	SoundEngine.play_sound("MenuButtonHoverSound")
