extends Node


func _enter_tree() -> void:
	GlobalSignal.subscribe("chunk_position_changing", self, "_chunk_position_changing")
	pass


func _chunk_position_changing(chunk_position: Vector2) -> void:
	var dir := Directory.new()
	var distance := Chunk.get_distance()
	var container := Chunk.get_container()
	var bounds := Chunk.bounds(-distance, distance)
	var size := Chunk.get_size() * 2
	for node in get_tree().get_nodes_in_group("chunk"):
		Chunk.unload_chunk_node(node)
	var chunks_circle_center := Chunk.get_chunk_circle_centered()
	var chunks_circle := Chunk.get_iteratable_circle(chunk_position, distance)
	for i in range(chunks_circle.size()):
		var chunk: Array = chunks_circle[i]
		var chunk_center: Array = chunks_circle_center[i]
		container.add_child(Chunk.load_chunk(dir, chunk[0], chunk[1], chunk_center[0], chunk_center[1], size))
