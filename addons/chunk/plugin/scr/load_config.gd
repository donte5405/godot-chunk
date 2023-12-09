extends Node
tool


const CONFIG_PATH = "res://chunk_config.json"

export var le_size_path: NodePath
export var le_directory_path: NodePath


func _ready() -> void:
	var file := File.new()
	if not file.file_exists(CONFIG_PATH):
		file.open(CONFIG_PATH, File.WRITE)
		file.store_string(JSON.print({
			chunk_size = 16,
			directory = "res://world",
		}))
		file.close()
	file.open(CONFIG_PATH, File.READ)
	var json: Dictionary = JSON.parse(file.get_as_text()).result
	var le_size := get_node(le_size_path) as LineEdit
	var le_directory := get_node(le_directory_path) as LineEdit
	le_size.set("text", String(json["chunk_size"]))
	le_directory.set("text", json["directory"])
	Chunk.set_directory(le_directory.text)
	Chunk.set_size(int(le_size.text))
	file.close()
