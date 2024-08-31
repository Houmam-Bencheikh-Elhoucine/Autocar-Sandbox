extends Control

@onready var speed_label = $LeftPanel/SpeedLabel
@onready var time_label = $LeftPanel/TimeLabel
@onready var distance_label = $LeftPanel/DistanceLabel
@onready var last_cp_label = $LeftPanel/LastCPTimeLabel
@onready var control_repr = $LeftPanel/Controls

var sensor_pb = {}

func _ready():
	var rp = $RightPanel
	for i in range(2, rp.get_child_count()):
		var c = rp.get_child(i)
		sensor_pb[c.name.replace("Data", "")] = c.get_child(1)
	print(sensor_pb)

func _process(_delta):
	speed_label.text = "Speed: "+str(int(GlobalVars.SPEED))
	time_label.text = "Elapsed time: "+ get_time_repr(GlobalVars.TIME)
	if GlobalVars.LAST_CP == 0:
		last_cp_label.text = "Last checkpoint: - "
	else:
		last_cp_label.text = "Last checkpoint: "+get_time_repr(GlobalVars.LAST_CP)

	distance_label.text = "Distance: "+str(round(GlobalVars.DIST))
	for i in sensor_pb.keys():
		if i in GlobalVars.rec_tpl:
			sensor_pb[i].set_value(GlobalVars.rec_tpl[i]*100)
	control_repr.update([GlobalVars.rec_tpl["InputA"], GlobalVars.rec_tpl["InputS"]])

func get_time_repr(time):
	var mins = int(time/60)
	var secs = int(time - mins * 60)
	return str(mins) + ":" + str(secs)
