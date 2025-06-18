extends Control

@onready var TextLabel = $RichTextLabel
@onready var TextInput = $LineEdit
@onready var ConnectButton = $Button
@onready var MessageString = $StringSend
@onready var GyroCoolDown = $Timer

var PastGyro = Vector3.ZERO
var PORT = 7183
var multiplayer_peer = ENetMultiplayerPeer.new()


func _ready():
	set_process(true)

func _on_button_pressed() -> void:
	var err = multiplayer_peer.create_client(str(TextInput.text), PORT)
	if err != OK:
		print("❌ Failed to connect to WebSocket server | URL = " + str(TextInput.text))
	else:
		print("🔌 Connecting...")
		multiplayer.multiplayer_peer = multiplayer_peer
		await get_tree().create_timer(1).timeout
		send_print.rpc_id(1)
		send_string.rpc_id(1, "Recieved connection")
		TextLabel.text = "Connected secesfully to " + TextInput.text

@rpc("any_peer")
func send_print():
	pass

@rpc("any_peer")
func send_string():
	pass

@rpc("any_peer")
func send_gyro(Gyro):
	pass

func _on_send_pressed() -> void:
	send_string.rpc_id(1, MessageString.text)
	TextLabel.text = "Sent message: " + MessageString.text

func _process(delta: float) -> void:
	var Gyro = Input.get_gyroscope()
	send_gyro.rpc_id(1, Gyro)
