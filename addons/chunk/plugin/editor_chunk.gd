extends Spatial
class_name EditorChunk
tool


export var size := 16
export var distance := 4
export var position := Vector2()


func _init() -> void:
	set_meta("is_editor_chunk", true)

