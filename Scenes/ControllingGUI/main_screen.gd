extends Control

var PORT = 7183
var multiplayer_peer = ENetMultiplayerPeer.new()
var TimeoutTime


func _ready() -> void:
	if not Globals.settingsOpen:
		$Label.text = "Connecting to ip: " + Globals.connected_IP
		var err = multiplayer_peer.create_client(str(Globals.connected_IP), PORT)
		if err != OK:
			pass
		else:
			multiplayer.multiplayer_peer = multiplayer_peer
			$Label.text = "Establishing connection ..."
			$Timeout.start()
			await get_tree().create_timer(1).timeout
			send_print.rpc_id(1)
			sentPlayerColor.rpc_id(1, Globals.color)
	elif Globals.settingsOpen:
		pass
	
	set_process(true)

@rpc("any_peer")
func send_print():
	pass

@rpc("any_peer")
func send_gyro(_Gyro):
	pass

@rpc("authority")
func getInfo(information):
	if information == "Established connection!":
		if OS.get_name() != "Android":
			$tester.visible = true
		Globals.connected = true
	$Label.text = information

@rpc("any_peer")
func sentPlayerColor(_color):
	pass



func _on_settings_pressed() -> void:
	Globals.settingsOpen = true
	if not Globals.connected:
		get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
	else:
		get_tree().change_scene_to_file("res://Scenes/ControllingGUI/Settings.tscn")

func _process(_delta: float) -> void:
	if OS.get_name() == "Android":
		var Gyro = Input.get_gyroscope()
		send_gyro.rpc_id(1, Gyro)

func _on_tester_pressed() -> void:
	var Gyro = Vector3(randi_range(-5, 5), randi_range(-5, 5), randi_range(-5, 5))
	send_gyro.rpc_id(1, Gyro)


func _timer_timeout() -> void:
	if not Globals.connected:
		$Label.text = "Connection timed out!"
		$Settings.text = "Main Menu"
