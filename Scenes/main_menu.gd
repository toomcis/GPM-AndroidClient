extends Control

var rotationOfPlayer = 0


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/ServerSelect/ServerSelectScreen.tscn")

func _ready() -> void:
	updatePlayerColor()

func _process(delta: float) -> void:
	$Player.rotation = rotationOfPlayer
	rotationOfPlayer += 0.1

func updatePlayerColor():
	$Player/PlayerMesh.texture.gradient.set_color(0, Globals.color)
	$Player/PlayerMesh/Trail.default_color = Globals.color
