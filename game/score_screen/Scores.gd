extends "res://util/PersistentProperties.gd"



var earworm_score = 0
var cocktail_score = 0
var light_score = 0

var maximum_score = 300


func _ready() -> void:
	filepath = "user://scores.json"


func calculate_total() -> int:
	return earworm_score + cocktail_score + light_score
