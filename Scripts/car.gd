extends CharacterBody2D
class_name Car

const SPEED = 1000.0
var action = 1
var next_waypoint = 1
var MAX_STEERING_ANGLE = 30

var wheel_base = 70
var steering_angle = 30
var steer_direction = 0
var engine_power = 250.0
var acceleration = Vector2.ZERO
var friction = -.01
var drag = -.0001
var collision_fix = 5
var next_cp = 0
var rec_tpl = {}
var last_cp = 0
var timer = 0
var dist = 0
@onready var sensors: Array = $Sensors.get_children()
var steer_corr = Vector2()
var collided = false

func _ready():
	GlobalVars.rec = false
	GlobalVars.MAXSPEED = SPEED

func _physics_process(delta):
	acceleration = Vector2.ZERO
	var inp = get_input()
	apply_input(inp)
	apply_friction(delta)
	calc_steering(delta)
	velocity += acceleration * delta
	velocity = velocity.normalized() * min(velocity.length(), SPEED)
	collided = move_and_slide()
	if collided:
		#print(to_global(Vector2(1, 0)), Vector2(1, 0)+global_position, (Vector2(1, 0)+global_position).rotated(rotation))
		#print("cpoint: ", to_local(cpoint).rotated(rotation))
		var n = get_wall_normal()
		steer_corr = velocity.project(n.orthogonal())
		velocity = velocity.normalized() * steer_corr.length()
		print(n.dot(velocity.normalized()))
		if abs(n.dot(velocity.normalized())) < .1:
			steer_corr = Vector2.ZERO
	else:
		steer_corr = Vector2.ZERO
	steering_angle = MAX_STEERING_ANGLE * max(1-velocity.length()/SPEED, .25)

	rec_tpl["InputA"] = inp[0]
	rec_tpl["InputS"] = inp[1]
	rec_tpl["Speed"] = velocity.length()
	rec_tpl["Collided"] = collided
	rec_tpl["Last_cp"] = last_cp
	rec_tpl["Distance"] = dist
	for s in sensors:
		if not s.is_colliding():
			rec_tpl[s.name]=1
		else:
			var v = s.to_local(s.get_collision_point()).length()/(s.get_target_position().length())
			rec_tpl[s.name] = v
	
	GlobalVars.SPEED = velocity.length()
	GlobalVars.rec_tpl = rec_tpl
	timer += delta
	dist += GlobalVars.SPEED * delta
	GlobalVars.DIST = dist
	GlobalVars.TIME = timer
	GlobalVars.LAST_CP = last_cp
	return inp

func apply_friction(delta):
	if velocity.length_squared() < 25 and acceleration.length_squared() == 0:
		velocity = Vector2.ZERO
	var friction_force = velocity * friction
	var drag_force = velocity * velocity.length() * drag
	acceleration += drag_force + friction_force * delta

func get_input():
	var turn = Input.get_axis("left", "right")
	var acc_br = Input.get_axis("break", "accel")
	return [acc_br, turn]

func apply_input(inp):
	var acc_br = inp[0]
	var turn = inp[1]
	steer_direction = turn * steering_angle
	#print(acc_br)
	if acc_br >= 0:
		acceleration = transform.x * engine_power * acc_br
		#print(acceleration)
	else:
		velocity -= velocity * friction * 2 * acc_br

func calc_steering(delta):
	var rear_wheel = position - transform.x * wheel_base/2.0
	var front_wheel = position + transform.x * wheel_base/2.0
	rear_wheel += velocity * delta
	if steer_corr != Vector2.ZERO:
			front_wheel += velocity.rotated(deg_to_rad(steer_direction)).project(steer_corr) * delta
	else:
		front_wheel += velocity.rotated(deg_to_rad(steer_direction)) * delta
	
	var new_heading = (front_wheel - rear_wheel).normalized()
	velocity = new_heading * velocity.length()
	rotation = new_heading.angle()

func block_last_cp():
	last_cp = timer
