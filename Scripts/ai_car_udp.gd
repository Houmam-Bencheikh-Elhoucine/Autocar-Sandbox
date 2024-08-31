extends Car


var tcp_client = PacketPeerUDP.new()

var ath = 0
var sth = 0.3
var last_inp = [1, 0]
var start = false

func _ready():
	super._ready()
	var s = tcp_client.connect_to_host(GlobalVars.ip, GlobalVars.port)
	if s != OK:
		print("Error!!")
	else:
		print("Success")

func get_input():
	if not start: return last_inp
	var tpl = {}
	tpl["Speed"] = velocity.length()
	tpl["Collided"] = collided
	tpl["Distance"] = dist
	tpl["Last_cp"] = last_cp
	for s in sensors:
		if not s.is_colliding():
			tpl[s.name]=1
		else:
			var v = s.to_local(s.get_collision_point()).length()/(s.get_target_position().length())
			tpl[s.name] = v
	#tcp_client.put_var("hello there".to_utf32_buffer())
	tcp_client.put_packet(JSON.stringify(tpl).to_utf8_buffer())
	while tcp_client.get_available_packet_count() == 0:continue
	var rcv = tcp_client.get_packet()
	#print(rcv)
	#var l = rcv.decode_64(0)
	var inp_s = rcv.get_string_from_utf8()
	if inp_s == "":
		return last_inp
	#print(inp_s)
	var inp = JSON.parse_string(inp_s)
	#print(inp)
	if inp != null:
		#print("valid JSON")
		inp[0] = -1 if inp[0]<=-ath else 1 if inp[0] >= ath else 0
		inp[1] = -1 if inp[1]<=-sth else 1 if inp[1] >= sth else 0
		last_inp=inp
		return inp
	else: return last_inp


func _on_timer_timeout():
	start = true
