extends Node2D


func _process(_delta):
	if Input.is_action_just_pressed("record"):
		$SaveFile.set_filename()
		$SaveFile.show()
		get_tree().paused = true
	if Input.is_action_just_pressed("abort"):
		get_tree().change_scene_to_file("res://Menu/menu.tscn")

func _on_save_file_file_selected(path):
	GlobalVars.save_recordings(path)
	$SaveFile.hide()

	get_tree().paused = false
	get_tree().change_scene_to_file("res://Menu/menu.tscn")

func _on_save_file_canceled():
	get_tree().paused = false
	$SaveFile.hide()
