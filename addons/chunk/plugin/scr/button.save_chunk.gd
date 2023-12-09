extends Node
tool


var plugin: EditorPlugin

export var parent_path := NodePath(".")
export var le_size_path: NodePath
export var le_directory_path: NodePath


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
		var packed_scene := PackedScene.new()
		packed_scene.pack(chunk)
		ResourceSaver.save(directory + "/" + chunk.name + ".tscn", packed_scene)
