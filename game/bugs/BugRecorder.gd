extends Node2D

var duration := 5.0
var fps := 30


var recording := false

var frames = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	Engine.target_fps = fps
	
	yield(get_tree().create_timer(1), "timeout")
	call_deferred("start_recording")
	

func _process(delta: float) -> void:
	if recording:
		record_image()


func record_image() -> void:
	var data := get_viewport().get_texture().get_data()
	frames.append(data)


func start_recording() -> void:
	recording = true
	yield(get_tree().create_timer(duration), "timeout")
	stop_recording()
	

func stop_recording() -> void:
	
	recording = false
	var dt = OS.get_datetime()
	var datestring = "%04d%02d%02d%02d%02d%02d" % [dt["year"], dt["month"],dt["day"], dt["hour"],dt["minute"], dt["second"]]
	var name_template = "%s_%05d.png"
	
	for i in range(frames.size()):
		var image: Image = frames[i]
		image.flip_y()
		var cropped := image.get_rect($RecordingRect.get_rect())
		
		cropped.save_png(OS.get_user_data_dir() + "/" + name_template % [datestring, i])
	

