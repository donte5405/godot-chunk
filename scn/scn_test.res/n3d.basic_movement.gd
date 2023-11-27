extends Spatial


export var speed := 10.0


func _process(delta: float) -> void:
	translation += Vector3(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"), 0, Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")) * speed * delta * (1024 if Input.is_action_just_pressed("ui_accept") else 1)
