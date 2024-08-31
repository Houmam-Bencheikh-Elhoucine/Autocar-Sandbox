extends Node


var ip = ""
var port = 0


var SPEED = 0
var MAXSPEED = 100
var TIME = 0
var DIST = 0
var LAST_CP = 0
var rec = false

var recorder = {"records":{}}
var rec_tpl = {}


func _process(delta):
	if not rec: return
	for c in rec_tpl.keys():
		if c in recorder["records"]:
			recorder["records"][c].append(rec_tpl[c])
		else:
			recorder["records"][c] = [rec_tpl[c]]

func save_recordings(pth):
	print("recording stopped")
	var file = FileAccess.open(pth, FileAccess.WRITE)
	file.store_string(JSON.stringify(recorder))
	recorder = {"records":{}}
	file.close()
	rec = false
	print("File saved successfully")

