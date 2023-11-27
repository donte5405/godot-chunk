extends Node


export(Array, NodePath) var shapes := []


func _ready() -> void:
	for path in shapes:
		get_node(path).call("hide")
	get_node(shapes[randi() % shapes.size()]).call("show")
