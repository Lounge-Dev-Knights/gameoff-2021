extends Node2D


# Declare member variables here. Examples:
# var a: int =2
# var b: String = "text"
export var GameTime: = 60.0
var TimeCounter: = 0.0
var _time_left: = 100
var TotalLightPercentage: = 0

var countCurrentBugLight = 0.0
var countTotalBugLight = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Game_Over.visible = false
	for lightBugCounters in get_tree().get_nodes_in_group("light_bugs"):
			countCurrentBugLight += lightBugCounters.current_light_hp
	for lightBugCounters in get_tree().get_nodes_in_group("light_bugs"):
		countTotalBugLight += lightBugCounters.max_light_hp
	$GameTimer.start(GameTime)
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
func _physics_process(delta: float) -> void:
	TimeCounter += delta
	if TimeCounter >= 1.0:
		
		print("countCurrentBugLight:")
		print(countCurrentBugLight)
		print("countTotalBugLight:")
		print(countTotalBugLight)
		TotalLightPercentage = countCurrentBugLight/countTotalBugLight*100
		print("TotaleLightPercentage:")
		print(TotalLightPercentage)
		_time_left = int($GameTimer.time_left)
		$GameInfo/CanvasLayer/HBoxContainer/NameCard/VBoxContainer/HBoxContainer2/Time.text = str(_time_left)
		$GameInfo/CanvasLayer/HBoxContainer/NameCard/VBoxContainer/HBoxContainer/Light.text = str(TotalLightPercentage)
		TimeCounter = 0
		countCurrentBugLight = 0
		for lightBugCounters in get_tree().get_nodes_in_group("light_bugs"):
			countCurrentBugLight += lightBugCounters.current_light_hp
	

func _on_GameTimer_timeout() -> void:
	get_tree().paused = true
	TotalScore.light_score = TotalLightPercentage
	$Game_Over/CenterContainer/NameCard/VBoxContainer/Score.text = str(TotalLightPercentage)
	$Game_Over.visible = true
	pass # Replace with function body.
	
