extends Control

var PastGyro = Vector3.ZERO
var PORT = 7183
var multiplayer_peer = ENetMultiplayerPeer.new()


func _ready() -> void:
	set_process(true)
	await get_tree().create_timer(5).timeout
	connectToServer()

func connectToServer():
	$Label.text = "Connecting to ip: " + Globals.connected_IP
	var err = multiplayer_peer.create_client(str(Globals.connected_IP), PORT)
	if err != OK:
		pass
	else:
		multiplayer.multiplayer_peer = multiplayer_peer
		await get_tree().create_timer(1).timeout
		send_print.rpc_id(1)
		$Label.text = "Establishing connection ..."
		sentPlayerColor.rpc_id(1, Globals.color)

@rpc("any_peer")
func send_print():
	pass

@rpc("any_peer")
func send_gyro(Gyro):
	pass

@rpc("any_peer")
func recieveInformation(information):
	$Label.text = information

@rpc("any_peer")
func sentPlayerColor(color):
	pass


func _process(delta: float) -> void:
	var Gyro = Input.get_gyroscope()
	$Label.text = str(Gyro)
	send_gyro.rpc_id(1, Gyro)


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/ControllingGUI/Settings.tscn")
