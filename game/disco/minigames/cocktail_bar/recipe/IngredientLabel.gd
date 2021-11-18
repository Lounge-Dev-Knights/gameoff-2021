extends VBoxContainer


onready var progress = $ProgressBar
onready var label = $Label

var amount: int setget _set_amount
var target: int setget _set_target
var ingredient: String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_label()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func update_label() -> void:
	if progress == null:
		return
	
	progress.max_value = target
	progress.value = amount
	
	label.text = "%d/%d %s" % [amount, target, ingredient]


func _set_amount(new_amount: int) -> void:
	amount = new_amount
	update_label()


func _set_target(new_target: int) -> void:
	target = new_target
	update_label()
