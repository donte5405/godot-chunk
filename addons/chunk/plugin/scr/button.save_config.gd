extends Node
tool


const CONFIG_PATH = "res://chunk_config.json"

var save_indicator_animation: SceneTreeTween

export var parent_path := NodePath(".")
export var le_size_path: NodePath
export var le_directory_path: NodePath
export var save_indicator_path: NodePath


func _ready() -> void:
	get_node(parent_path).connect("pressed", self, "_button_pressed")


func _button_pressed() -> void:
	var file := File.new()
	var le_size := get_node(le_size_path) as LineEdit
	var le_directory := get_node(le_directory_path) as LineEdit
	file.open(CONFIG_PATH, File.WRITE)
	file.store_string(JSON.print({
		chunk_size = int(le_size.text),
		directory = le_directory.text,
	}))
	file.close()
	Chunk.set_directory(le_directory.text)
	Chunk.set_size(int(le_size.text))
	play_save_indicator_animation()


func play_save_indicator_animation() -> void:
	var indicator := get_node(save_indicator_path) as CanvasItem
	indicator.show()
	if is_instance_valid(save_indicator_animation):
		save_indicator_animation.kill()
	save_indicator_animation = indicator.create_tween()
	save_indicator_animation.tween_property(indicator, "modulate", Color.transparent, 1).from(Color.white)
