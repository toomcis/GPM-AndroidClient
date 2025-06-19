extends Control

var rotationOfPlayer = 0


func _ready() -> void:
	updatePlayerColor()


func _process(delta: float) -> void:
	$Player.rotation = rotationOfPlayer
	rotationOfPlayer += 0.1


func updatePlayerColor():
	$Player/PlayerMesh.texture.gradient.set_color(0, Globals.color)
	$Player/PlayerMesh/Trail.default_color = Globals.color
	sentPlayerColor.rpc_id(1, Globals.color)

@rpc
func sentPlayerColor():
	pass

func _on_color_picker_color_changed(color: Color) -> void:
	Globals.color = color
	print("Changed color to: " + str(Globals.color))
	updatePlayerColor()


func _on_back_button_pressed() -> void:
	if $Elements.visible == true:
		$Buttons.visible = true
		$Elements.visible = false
	elif $Confirm.visible == true:
		$Confirm.visible = false
		$Buttons.visible = true
	else:
		get_tree().change_scene_to_file("res://Scenes/ControllingGUI/MainScreen.tscn")


func _on_change_color_pressed() -> void:
	$Elements/ColorPicker.color = Globals.color
	$Buttons.visible = false
	$Elements.visible = true


func _on_disconnect_pressed() -> void:
	$Buttons.visible = false
	$Elements.visible = false
	$Confirm.visible = true


func _on_yes_pressed() -> void:
	Globals.connected_IP = null
	get_tree().change_scene_to_file("res://Scenes/ServerSelect/ServerSelectScreen.tscn")


func _on_confirm_pressed() -> void:
	$Confirm.text = "Press Confirm not me!"
