extends Spatial


export var chunk_size := 32.0
export var chunk_distance := 1
export var chunk_position := Vector2()
export var chunk_default_scene: PackedScene
export(String, DIR) var chunk_directory := ""
export var node_to_follow_path := NodePath(".")

onready var following := get_node(node_to_follow_path) as Spatial


func _enter_tree() -> void:
	Chunk.set_container(self)
	Chunk.set_size(chunk_size)
	Chunk.set_distance(chunk_distance)
	Chunk.set_directory(chunk_directory)
	Chunk.set_default_scene(chunk_default_scene)


func _ready() -> void:
	randomize()
	Chunk.set_following(following)
	Chunk.set_position(chunk_position)


func _physics_process(delta: float) -> void:
	# Makes Y-axis stay the same as the target.
	var trans := translation
	translation = Vector3(trans.x, following.translation.y, trans.z)
