extends PanelContainer

onready var camera_holder: Spatial = get_tree().root.get_node("Root/PetRoot/petholder/Viewport/CameraHolder") as Spatial
onready var camera = camera_holder.get_node("Camera")

func _gui_input(event):
	if event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(BUTTON_LEFT):
			var motion = event.relative as Vector2
			camera_holder.rotation.x += motion.y * 0.01
			camera_holder.rotation.y += motion.x * -0.01
		if Input.is_mouse_button_pressed(BUTTON_RIGHT) or Input.is_mouse_button_pressed(BUTTON_MIDDLE):
			var motion = event.relative as Vector2
			camera.transform.origin.x += motion.x * 0.001 * camera.size
			camera.transform.origin.y += motion.y * 0.001 * camera.size
			
	elif event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_WHEEL_DOWN:
			camera.size *= 2.0
		elif event.button_index == BUTTON_WHEEL_UP:
			camera.size /= 2.0
	
