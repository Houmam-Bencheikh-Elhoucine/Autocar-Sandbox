extends Control


@onready var up_button = $ButtonUP
@onready var down_button = $ButtonDOWN
@onready var left_button = $ButtonLEFT
@onready var right_button = $ButtonRIGHT

func update(ctrl):
	up_button.modulate = Color.WHITE
	down_button.modulate = Color.WHITE
	left_button.modulate = Color.WHITE
	right_button.modulate = Color.WHITE
	
	if ctrl[0] > 0:
		up_button.modulate = Color("#00b661")
	elif ctrl[0] < 0:
		down_button.modulate = Color("#00b661")
	if ctrl[1] > 0:
		right_button.modulate = Color("#00b661")
	if ctrl[1] < 0:
		left_button.modulate = Color("#00b661")
