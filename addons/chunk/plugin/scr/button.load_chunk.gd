extends Node
tool


var plugin: EditorPlugin

export var parent_path := NodePath(".")
export var le_size_path: NodePath
export var le_directory_path: NodePath


func create_raycast(parent: Node, size: float, trans: Vector3, cast_to: Vector3) -> RayCast:
	var r := RayCast.new()
	r.debug_shape_custom_color = Color.yellow
	r.translation = trans * size
	r.cast_to = cast_to * size
	r.enabled = true
	parent.add_child(r)
	r.owner = parent
	return r


func create_raycasts(parent: Spatial, size: float) -> void:
	var top_left := Vector3(-1, 0, -1) * size
	create_raycast(parent, size, Vector3(-1, 0, -1), Vector3(2, 0, 0))
	create_raycast(parent, size, Vector3(-1, 0, -1), Vector3(0, 0, 2))
	create_raycast(parent, size, Vector3(-1, 0, 1), Vector3(2, 0, 0))
	create_raycast(parent, size, Vector3(1, 0, -1), Vector3(0, 0, 2))


func _ready() -> void:
	if not Engine.has_meta("chunk_tool_plugin"):
		return
	plugin = Engine.get_meta("chunk_tool_plugin")
	get_node(parent_path).connect("pressed", self, "_button_pressed")


func _button_pressed() -> void:
	var scene := plugin.get_editor_interface().get_edited_scene_root() as Spatial
	if not is_instance_valid(scene):
		printerr("There is no active scene!")
		return
	if not scene.has_meta("is_editor_chunk"):
		printerr("This is not a chunk scene, will not load chunks here!")
		return

	var chunk_template := preload("res://addons/chunk/chunk_template.tscn")
	for chunk_boundary in get_tree().get_nodes_in_group("chunk_tool_boundary"):
		chunk_boundary.name = "_%d" % randi()
		chunk_boundary.queue_free()

	Chunk.set_container(scene)
	Chunk.set_distance(scene.get("distance"))
	Chunk.set_position(scene.get("position"))
	var chunk_position: Vector2 = scene.get("position")
	var size_orig := Chunk.get_size()

	# duplicate code: load chunk
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
		var chunk_node := Chunk.load_chunk(dir, chunk[0], chunk[1], chunk_center[0], chunk_center[1], size)
		container.add_child(chunk_node)
		chunk_node.owner = container

	# end duplicate code
		var chunk_boundary := Position3D.new()
		chunk_boundary.translation = Vector3(chunk_center[0] * size, 0, chunk_center[1] * size)
		chunk_boundary.name = chunk_node.name + "_boundary"
		chunk_boundary.add_to_group("chunk_tool_boundary")
		container.add_child(chunk_boundary)
		chunk_boundary.owner = container
		create_raycasts(chunk_boundary, size_orig)
		Chunk.make_local(chunk_node, container)
		yield(get_tree(), "idle_frame")
