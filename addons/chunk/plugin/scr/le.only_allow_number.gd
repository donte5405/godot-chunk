extends Node
tool


var old_text := ""

export var parent_path := NodePath(".")

onready var parent := get_node(parent_path) as LineEdit


func _ready() -> void:
	parent.connect("text_changed", self, "_line_edit_text_changed")


func _line_edit_text_changed(new_text: String) -> void:
	for c in new_text:
		if not c in "0123456789":
			parent.text = old_text
			return
	old_text = new_text
