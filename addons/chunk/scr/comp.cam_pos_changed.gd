extends Node


func _enter_tree() -> void:
	GlobalSignal.subscribe("chunk_position_changing", self, "_chunk_position_changing")
	pass


func _chunk_position_changing(chunk_position: Vector2) -> void:
	var dir := Directory.new()
	var distance := Chunk.get_distance()
	var container := Chunk.get_container()
	var bounds := Chunk.bounds(-distance, distance)
	var chunks := Chunk.get_iteratable(chunk_position, Chunk.get_distance())
	var size := Chunk.get_size() * 2
	var i := 0
	for node in get_tree().get_nodes_in_group("chunk"):
		Chunk.unload_chunk_node(node)
	for y in bounds:
		for x in bounds:
			var chunk: Array = chunks[i]
			container.add_child(Chunk.load_chunk(dir, chunk[0], chunk[1], x, y, size))
			i += 1
