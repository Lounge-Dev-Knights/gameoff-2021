extends Node


var earworm_score = 95
var cocktail_score = 70
var light_score = 90

var maximum_score = 300

func calculate_total() -> int:
	return earworm_score + cocktail_score + light_score
