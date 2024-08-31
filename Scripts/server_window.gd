extends Window

signal start(ip: String, port: int)



func _on_cancel_button_pressed():
	hide()

func _on_start_button_pressed():
	var ip = $Control/IPEdit.text
	var port = $Control/PortEdit.text
	if ip == "": ip = $Control/IPEdit.placeholder_text
	if port == "": port = $Control/PortEdit.placeholder_text
	print(ip, ":", port)
	if (not port.is_valid_int()):# or (not ip.is_valid_ip_address()):
		return
	emit_signal("start",ip, int(port))
