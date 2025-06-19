extends Node

var connected_IP = null
var color = Color(1, 1, 1)

func _ready():
	color = Color(randf(), randf(), randf())
	print("Global script initialized")
