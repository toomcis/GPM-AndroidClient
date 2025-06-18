extends Control

@onready var TextLabel = $RichTextLabel
@onready var TextInput = $LineEdit
@onready var ConnectButton = $Button
var PastGyro = Vector3.ZERO
var multiplayer_peer := WebSocketMultiplayerPeer.new()

func _ready():
	set_process(true)

func _physics_process(delta: float) -> void:
	if multiplayer_peer.get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTED:
		var Gyro = Input.get_gyroscope()
		TextLabel.text = str(Gyro) + " | Gyro = " + str(PastGyro - Gyro)
		PastGyro = Gyro

		rpc_id(1, "send_gyro_data", Gyro)
		rpc_id(1, "send_string", "Hello World!")

func _on_button_pressed() -> void:
	var websocket_url = "ws://" + str(TextInput.text) + ":7183"
	connect_to_websocket(websocket_url)

func connect_to_websocket(url: String):
	var err = multiplayer_peer.create_client(url)
	if err != OK:
		print("❌ Failed to connect to WebSocket server | URL = " + url)
	else:
		print("🔌 Connecting...")
		multiplayer.multiplayer_peer = multiplayer_peer
		rpc_id(1, "send_string", "Hello World!")
