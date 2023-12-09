class_name Chunk


static func make_local(node: Node, owner: Node = null) -> void:
	node.filename = ""
	node.owner = owner
	for child in node.get_children():
		make_local(child, owner)


static func get_chunk_circle_centered() -> Array:
	return Engine.get_meta("chunk_circle_centered", [])


static func get_container() -> Node:
	return Engine.get_meta("chunk_container")


static func set_container(value: Node, notify: bool = true) -> void:
	if notify:
		GlobalSignal.emit("chunk_container_changing", [ value ])
		Engine.set_meta("chunk_container", value)
		GlobalSignal.emit("chunk_container_changing", [ value ])
		return
	Engine.set_meta("chunk_container", value)


static func get_default_scene() -> PackedScene:
	return Engine.get_meta("chunk_default_scene")


static func set_default_scene(value: PackedScene, notify: bool = true) -> void:
	if notify:
		GlobalSignal.emit("chunk_default_scene_changing", [ value ])
		Engine.set_meta("chunk_default_scene", value)
		GlobalSignal.emit("chunk_default_scene_changed", [ value ])
		return
	Engine.set_meta("chunk_default_scene", value)
	


static func get_directory() -> String:
	return Engine.get_meta("chunk_directory", "res://")


static func set_directory(value: String, notify: bool = true) -> void:
	if notify:
		GlobalSignal.emit("chunk_directory_changing", [ value ])
		Engine.set_meta("chunk_directory", value)
		GlobalSignal.emit("chunk_directory_changed", [ value ])
		return
	Engine.set_meta("chunk_directory", value)


static func get_distance() -> int:
	return Engine.get_meta("chunk_distance", 2)


static func set_distance(value: int, notify: bool = true) -> void:
	if notify:
		GlobalSignal.emit("chunk_distance_changing", [ value ])
		Engine.set_meta("chunk_distance", value)
		GlobalSignal.emit("chunk_distance_changed", [ value ])
		return
	Engine.set_meta("chunk_distance", value)


static func get_following() -> Spatial:
	return Engine.get_meta("chunk_following")


static func set_following(value: Spatial, notify: bool = true) -> void:
	if notify:
		GlobalSignal.emit("chunk_following_changing", [ value ])
		Engine.set_meta("chunk_following", value)
		GlobalSignal.emit("chunk_following_changed", [ value ])
		return
	Engine.set_meta("chunk_following", value)


static func get_position() -> Vector2:
	return Engine.get_meta("chunk_position", Vector2())


static func set_position(value: Vector2, notify: bool = true) -> void:
	Engine.set_meta("chunk_circle_centered", get_iteratable_circle(Vector2(), get_distance()))
	if notify:
		GlobalSignal.emit("chunk_position_changing", [ value ])
		Engine.set_meta("chunk_position", value)
		GlobalSignal.emit("chunk_position_changed", [ value ])
		return
	Engine.set_meta("chunk_position", value)


static func get_size() -> float:
	return Engine.get_meta("chunk_size", 32.0)


static func set_size(value: float, notify: bool = true) -> void:
	if notify:
		GlobalSignal.emit("chunk_size_changing", [ value ])
		Engine.set_meta("chunk_size", value)
		GlobalSignal.emit("chunk_size_changed", [ value ])
		return
	Engine.set_meta("chunk_size", value)


static func bounds(a: int, b: int) -> Array:
	return range(a, b + 1)


static func get_iteratable_circle(position: Vector2, distance: int = 1, as_string: bool = false) -> Array:
	var i := 0
	var arr := []
	arr.resize(pow(2 * distance + 1, 2));
	for y in bounds(-distance, distance):
		for x in bounds(-distance, distance):
			if Vector2(x, y).length() <= distance * 1.20:
				arr[i] = [position.x + x, position.y + y]
				i += 1
	arr.resize(i)
	return arr


static func load_chunk(dir: Directory, chunk_x: int, chunk_y: int, x: int, y: int, chunk_size: float) -> Spatial:
	var node: Spatial
	var node_name := "_%d_%d" % [chunk_x, chunk_y]
	var path: String = get_directory() + "/" + node_name + ".tscn"
	if dir.file_exists(path):
		node = load(path).instance()
	elif Engine.has_meta("chunk_default_scene"):
		node = Engine.get_meta("chunk_default_scene").instance()
	else:
		node = Spatial.new()
	node.translation = Vector3(x * chunk_size, 0, y * chunk_size)
	node.set_meta("chunk_x", chunk_x)
	node.set_meta("chunk_y", chunk_y)
	node.add_to_group("chunk")
	node.name = node_name
	GlobalSignal.emit("chunk_loaded", [ chunk_x, chunk_y, node ])
	return node


static func unload_chunk_node(node: Node) -> void:
	GlobalSignal.emit("chunk_unloaded", [ node.get_meta("chunk_x"), node.get_meta("chunk_y"), node ])
	node.name = "_%d" % randi()
	node.queue_free	()
