extends Car

var tcp_client = StreamPeerTCP.new()
var HOST = "127.0.0.1"
var PORT = 9999
var start = false

func _ready():
	super._ready()
	var s = tcp_client.connect_to_host(HOST, PORT)
	if s != OK:
		print("Error!!")
	else:
		tcp_client.set_no_delay(true)
		print("Success")


func get_input():
	var tpl = {}
	tpl["Speed"] = velocity.length()
	for s in sensors:
		if not s.is_colliding():
			tpl[s.name]=1
		else:
			var v = s.to_local(s.get_collision_point()).length()/(s.get_target_position().length())
			tpl[s.name] = v
	tcp_client.poll()
	if tcp_client.get_status() == StreamPeerTCP.STATUS_CONNECTED:
		tcp_client.put_string(JSON.stringify(tpl))
		var l = tcp_client.get_64()
		var inp = tcp_client.get_string(l)
		print(l, inp)
		return JSON.parse_string(inp)
	else: return [0, 0]



