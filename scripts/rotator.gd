tool
extends Spatial

var time = 0.0
export var enabled = false
export var enabled_in_editor = false

func _process(delta):
	if (Engine.editor_hint and enabled_in_editor) or (!Engine.editor_hint and enabled):
		rotate_object_local(Vector3.UP, delta)


func _on_HSlider_value_changed(value):
	get_tree().root.get_node("Spatial/ViewportContainer/Viewport/Camera").size = 1.0 / value


func _on_HSlider2_value_changed(value):
	rotation_degrees.y = value;
