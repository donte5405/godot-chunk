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
	var dir := Directory.new()
	var direction_inv := -direction
	var chunk_position := Chunk.get_position()
	var chunk_new_position := chunk_position + direction
	var chunks_circle := Chunk.get_iteratable_circle(chunk_new_position, distance)
	var chunks_circle_center := Chunk.get_chunk_circle_centered()
	var container := Chunk.get_container()
	size = size * 2

	get_tree().call_group_flags(SceneTree.GROUP_CALL_REALTIME, "chunk", "add_to_group", "chunk_to_be_removed")
	for node in get_tree().get_nodes_in_group("chunk") + [ following ]:
		node.translation = node.translation + Vector3(direction_inv.x, 0, direction_inv.y) * size
	for i in range(chunks_circle.size()):
		var chunk: Array = chunks_circle[i]
		var node: Spatial = container.get_node_or_null("_%d_%d" % chunk)
		if is_instance_valid(node):
			node.remove_from_group("chunk_to_be_removed")
		else:
			var chunk_center: Array = chunks_circle_center[i]
			container.add_child(Chunk.load_chunk(dir, chunk[0], chunk[1], chunk_center[0], chunk_center[1], size))
	for node in get_tree().get_nodes_in_group("chunk_to_be_removed"):
		Chunk.unload_chunk_node(node)
	Chunk.set_position(chunk_new_position, false)
