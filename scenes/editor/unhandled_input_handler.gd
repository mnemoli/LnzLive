extends Node

func _unhandled_key_input(event):
	if event.pressed and event.control and event.scancode == KEY_SPACE:
		$SceneRoot/ToolsMenu.popup()
		$SceneRoot/ToolsMenu.rect_global_position = get_viewport().get_mouse_position()
