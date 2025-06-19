extends Control

var save_path = "res://ips.txt"
@onready var addIPField = $IPText 
@onready var storedIPs = []

func _ready() -> void:
	load_array()

func save_array(addedIP):
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		for ip in storedIPs:
			file.store_line(ip)
		file.store_line(addedIP)
		file.close()
		load_array()

func load_array():
	var file = FileAccess.open(save_path, FileAccess.READ)
	if file:
		storedIPs = file.get_as_text().split("\n")
		storedIPs.resize(storedIPs.size() - 1)
		file.close()


func _on_add_button_pressed() -> void:
	if storedIPs.find(addIPField.text) != -1:
		$AddButton.text = "IP Already added, try again"
	elif addIPField.text == "":
		$AddButton.text = "IP cant be blank, try again"
	else:
		save_array(addIPField.text)
		get_tree().change_scene_to_file("res://Scenes/ServerSelect/ServerSelectScreen.tscn")


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/ServerSelect/ServerSelectScreen.tscn")


func _on_direct_pressed() -> void:
	Globals.connected_IP = addIPField.text
	get_tree().change_scene_to_file("res://Scenes/ControllingGUI/MainScreen.tscn")
