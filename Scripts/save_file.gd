extends FileDialog


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_filename():
	current_file = "rec_"+Time.get_datetime_string_from_system().validate_filename()
