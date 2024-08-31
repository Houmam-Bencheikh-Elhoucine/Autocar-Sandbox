extends RayCast2D
class_name Sensor

func _process(_delta):
	queue_redraw()

func _draw():
	if not is_colliding(): return
	#draw_line(Vector2.ZERO, end_point, clr)
	draw_circle(to_local(get_collision_point()), 20, Color.ORANGE_RED)
