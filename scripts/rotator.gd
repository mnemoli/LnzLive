extends Spatial

var time = 0.0
export var enabled = false
export var enabled_in_editor = false
export var cam_dist = 0.947
onready var cam = get_tree().root.get_node("Spatial/ViewportContainer/Viewport/Camera")

func _process(delta):
	if (Engine.editor_hint and enabled_in_editor) or (!Engine.editor_hint and enabled):
		rotate_object_local(Vector3.UP, delta)

func _on_HSlider_value_changed(value):
	get_tree().root.get_node("Spatial/ViewportContainer/Viewport/Camera").size = 1.0 / value

func _on_HSlider2_value_changed(value):
	cam.transform.origin = Vector3(0,0,0)
	cam.rotation_degrees.y = value + 180
	cam.translate_object_local(Vector3.BACK * cam_dist)

func _on_HSlider3_value_changed(value):
	cam.transform.origin = Vector3(0,0,0)
	cam.rotation_degrees.x = value
	cam.translate_object_local(Vector3.BACK * cam_dist)
