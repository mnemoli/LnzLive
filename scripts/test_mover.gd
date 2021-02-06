tool
extends Spatial

var time = 0
export var enabled = false
export var set_camera_limit = false setget do_camera

func _process(delta):
	if enabled:
		time += 0.01
		var movement = sin(time) / 10.0 * delta
		transform.origin += Vector3(movement, 0, 0)

func do_camera(new_value):
	get_parent().get_node("Camera").size = 0.125
