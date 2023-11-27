extends Node


func _ready() -> void:
	get_tree().connect("idle_frame", self, "_loop")


func _loop() -> void:
	var chunk_size := Chunk.get_size()
	var following := Chunk.get_following()
	var following_translation := following.global_translation
	if following_translation.x < -chunk_size:
		chunk(following, Vector2.LEFT, Chunk.get_distance(), chunk_size)
	elif following_translation.x > chunk_size:
		chunk(following, Vector2.RIGHT, Chunk.get_distance(), chunk_size)
	if following_translation.z < -chunk_size:
		chunk(following, Vector2.UP, Chunk.get_distance(), chunk_size)
	elif following_translation.z > chunk_size:
		chunk(following, Vector2.DOWN, Chunk.get_distance(), chunk_size)


func chunk(following: Spatial, direction: Vector2, distance: int, size: float) -> void:
	var chunk_position := Chunk.get_position()
	var chunk_new_position := chunk_position + direction
	var direction_inv := -direction
	size = size * 2

	if not following.is_in_group("chunk"):
		following.add_to_group("chunk")
	for node in get_tree().get_nodes_in_group("chunk"):
		node.translation = node.translation + Vector3(direction_inv.x, 0, direction_inv.y) * size

	chunk_unload(chunk_position, direction_inv, distance)
	load_chunk(chunk_new_position, direction, distance, size)
	Chunk.set_position(chunk_new_position, false)


func chunk_unload(chunk_position: Vector2, direction: Vector2, distance: int) -> void:
	var container := Chunk.get_container()
	for chunk in Chunk.get_iteratable_directed(chunk_position, direction * distance):
		Chunk.unload_chunk(container, chunk)


func load_chunk(chunk_position: Vector2, direction: Vector2, distance: int, size: int) -> void:
	var i := 0
	var dir := Directory.new()
	var container := Chunk.get_container()
	var directory_path := Chunk.get_directory()
	var coor := Chunk.bounds(-distance, distance)
	var default_scene := Chunk.get_default_scene()
	for chunk in Chunk.get_iteratable_directed(chunk_position, direction * distance):
		if direction.x != 0:
			container.add_child(Chunk.load_chunk(dir, chunk[0], chunk[1], distance * sign(direction.x), coor[i], size))
		elif direction.y != 0:
			container.add_child(Chunk.load_chunk(dir, chunk[0], chunk[1], coor[i], distance * sign(direction.y), size))
		i += 1
