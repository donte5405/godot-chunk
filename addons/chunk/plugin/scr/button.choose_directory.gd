extends Node
tool


var plugin: EditorPlugin

export var parent_path := NodePath(".")
export var le_directory_path: NodePath


func _ready() -> void:
	if not Engine.has_meta("chunk_tool_plugin"):
		return
	plugin = Engine.get_meta("chunk_tool_plugin")
	get_node(parent_path).connect("pressed", self, "_button_pressed")


func _button_pressed() -> void:
	var interface := plugin.get_editor_interface()
	var file_dialog := FileDialog.new()
	file_dialog.mode = FileDialog.MODE_OPEN_DIR
	file_dialog.rect_size = Vector2(640, 480)
	interface.get_base_control().add_child(file_dialog)
	file_dialog.popup_centered()
	var path: String = yield(file_dialog, "dir_selected")
	file_dialog.queue_free()
	get_node(le_directory_path).set("text", path)
