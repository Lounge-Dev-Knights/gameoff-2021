extends Node2D

onready var score_text = get_node("CenterContainer/VBoxContainer/Label")
onready var tween = get_node("Tween")

var score = 0
var target_score = 0
var bug_appearances = []

onready var bugs = get_node("PartyAudience").get_children()


func _ready():
	bug_appearances = range(1, TotalScore.maximum_score, 20)
	yield(get_tree().create_timer(2.0), "timeout")
	target_score += TotalScore.earworm_score
	
	yield(get_tree().create_timer(4.0), "timeout")
	target_score += TotalScore.cocktail_score
	yield(get_tree().create_timer(4.0), "timeout")
	target_score += TotalScore.light_score
	
func _process(delta):
	score = lerp(score, target_score, 0.01)
	if len(bugs) > 0 and int(score) == bug_appearances[0]:
		bug_appearances.pop_front()
		bug_appears(bugs.pop_front())
	score_text.text = str(int(score))
	
	
func bug_appears(bug: Object):
	tween.interpolate_property(bug, "position",
		bug.position, Vector2(bug.position.x, 150), 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()


func _on_TextureButton_pressed():
	SceneLoader.goto_scene("res://game/disco/disco_overview/DiscoOverview.tscn")
