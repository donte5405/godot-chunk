extends EditorPlugin
tool


var plugin_panel: Control


func _enter_tree() -> void:
	Engine.set_meta("chunk_tool_plugin", self)
	plugin_panel = load("res://addons/chunk/plugin/plugin_panel.tscn").instance()
	add_control_to_dock(DOCK_SLOT_LEFT_BL, plugin_panel)

	add_custom_type("EditorChunk", "Spatial", preload("res://addons/chunk/plugin/editor_chunk.gd"), preload("res://addons/chunk/plugin/img/chunk.png"))


func _exit_tree() -> void:
	Engine.remove_meta("chunk_tool_plugin")
	remove_control_from_docks(plugin_panel)
	plugin_panel.free()
