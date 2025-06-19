extends Control

var PastGyro = Vector3.ZERO
var PORT = 7183
var multiplayer_peer = ENetMultiplayerPeer.new()
var storedIPs = []
var Removing = false

@onready var ServerList = $ServerList

func _ready():
	load_ips(true)
	set_process(true)

func load_ips(first_started):
	var file = FileAccess.open("res://ips.txt", FileAccess.READ)
	storedIPs = []
	storedIPs = file.get_as_text().split("\n")
	storedIPs.resize(storedIPs.size() - 1)
	file.close()
	
	if first_started:
		ServerList.remove_item(0)
	else:
		ServerList.clear()
	
	for ip in storedIPs:
		ServerList.add_item(ip)
		print("Loaded ips: " + ip)
	print("Loaded ips")


@rpc("any_peer")
func send_print():
	pass

@rpc("any_peer")
func send_gyro(Gyro):
	pass


func _process(delta: float) -> void:
	var Gyro = Input.get_gyroscope()
	send_gyro.rpc_id(1, Gyro)



func _on_serveradd_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/ServerSelect/ServerAdd.tscn")

func _on_server_list_item_activated(index: int) -> void:
	if not Removing:
		var SelectedIP = $ServerList.get_item_text(index)
		Globals.connected_IP = SelectedIP
		print("Connecting to " + Globals.connected_IP)
		get_tree().change_scene_to_file("res://Scenes/ControllingGUI/MainScreen.tscn")
	else:
		var file = FileAccess.open("res://ips.txt", FileAccess.WRITE)
		if file:
			for ip in storedIPs:
				if ip == storedIPs[index]:
					print("Removed ip")
				else:
					file.store_line(ip)
			file.close()
			load_ips(false)
			Removing = false
			$RemoveButton.text = "Remove server"


func _on_remove_button_pressed() -> void:
	if Removing:
		Removing = false
		$RemoveButton.text = "Remove server"
	else:
		Removing = true
		$RemoveButton.text = "Double tap to remove"
