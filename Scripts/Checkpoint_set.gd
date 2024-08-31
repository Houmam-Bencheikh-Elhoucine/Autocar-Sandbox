extends Node2D
var cnt

var car = null

func _ready():
	cnt = get_child_count()
	for i in range(cnt):
		var cp_i = get_child(i)
		if cp_i is Area2D:
			cp_i.n = i
			cp_i.connect("next_cp", next_cp)

func _process(delta):
	if Input.is_action_just_pressed("reset"):
		var n = car.next_cp
		var c = get_child(n)
		car.position = c.position
		car.velocity = Vector2.ZERO
		car.rotation_degrees = c.rotation_degrees - 90

func next_cp(car, cp_n):
	self.car = car
	car.next_cp = (cp_n+1) % cnt
	car.block_last_cp()
