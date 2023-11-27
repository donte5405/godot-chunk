class_name Chunk


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
	return Engine.get_meta("chunk_distance", 1)


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


static func get_iteratable(position: Vector2, distance: int = 1) -> Array:
	var i := 0
	var arr := []
	arr.resize(pow(2 * distance + 1, 2));
	for y in bounds(position.y - distance, position.y + distance):
		for x in bounds(position.x - distance, position.x + distance):
			arr[i] = [x, y]
			i += 1
	return arr


static func get_iteratable_directed(position: Vector2, direction: Vector2) -> Array:
	assert(direction.length() != 0, "\"direction\" cannot be length of zero")
	var i := 0
	var arr := []
	var length := int(direction.length())
	arr.resize(2 * length + 1);
	if direction.x != 0:
		var x := position.x + sign(direction.x) * length
		for y in bounds(position.y - length, position.y + length):
			arr[i] = [x, y]
			i += 1
		return arr
	if direction.y != 0:
		var y := position.y + sign(direction.y) * length
		for x in bounds(position.x - length, position.x + length):
			arr[i] = [x, y]
			i += 1
		return arr
	return []


static func load_chunk(dir: Directory, chunk_x: int, chunk_y: int, x: int, y: int, chunk_size: float) -> Spatial:
	var node: Spatial
	var node_name := "_%d_%d" % [chunk_x, chunk_y]
	var path: String = get_directory() + "/" + node_name + ".tscn"
	if dir.file_exists(path):
		node = load(path).instance()
	else:
		node = Engine.get_meta("chunk_default_scene").instance()
	node.translation = Vector3(x * chunk_size, 0, y * chunk_size)
	node.set_meta("chunk_x", chunk_x)
	node.set_meta("chunk_y", chunk_y)
	node.add_to_group("chunk")
	node.name = node_name
	GlobalSignal.emit("chunk_loaded", [ chunk_x, chunk_y, node ])
	return node


static func unload_chunk(container: Node, chunk: Array) -> void:
	var node := container.get_node_or_null("_%d_%d" % chunk)
	if is_instance_valid(node):
		unload_chunk_node(node)


static func unload_chunk_node(node: Node) -> void:
	GlobalSignal.emit("chunk_unloaded", [ node.get_meta("chunk_x"), node.get_meta("chunk_y"), node ])
	node.name = "_%d" % randi()
	node.queue_free	()
