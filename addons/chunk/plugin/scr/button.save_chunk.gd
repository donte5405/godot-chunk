extends Node
tool


var plugin: EditorPlugin

export var parent_path := NodePath(".")


func _ready() -> void:
	if not Engine.has_meta("chunk_tool_plugin"):
		return
	plugin = Engine.get_meta("chunk_tool_plugin")
	get_node(parent_path).connect("pressed", self, "_button_pressed")


func _button_pressed() -> void:
	var scene := plugin.get_editor_interface().get_edited_scene_root() as Spatial
	if not is_instance_valid(scene):
		printerr("There is no active scene to save!")
		return
	if not scene.has_meta("is_editor_chunk"):
		printerr("This is not a chunk scene, will not save chunks!")
		return
	
	var directory := Chunk.get_directory()
	for chunk in scene.get_children():
		var path: String = directory + "/" + chunk.name + ".tscn"
		var prev_trans: Vector3 = chunk.translation
		chunk.translation = Vector3.ZERO
		for child in chunk.get_children():
			Chunk.make_local(child, chunk)
		var packed_scene := PackedScene.new()
		packed_scene.pack(chunk)
		Chunk.make_local(chunk, scene)
		chunk.translation = prev_trans
		ResourceSaver.save(path, packed_scene)
		print("Saved %s " % path)
		yield(get_tree(), "idle_frame")
