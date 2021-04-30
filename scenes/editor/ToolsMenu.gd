extends PopupMenu

signal color_entire_pet

func _on_ToolsMenu_id_pressed(id):
	if id == 0: # color entire pet
		get_parent().get_node("ColorPopup").rect_position = get_global_mouse_position()
		get_parent().get_node("ColorPopup").popup()


func _on_LineEdit_gui_input(event):
	if event is InputEventKey and event.pressed and event.scancode == KEY_ENTER:
		emit_signal("color_entire_pet", get_parent().get_node("ColorPopup/LineEdit").text)
