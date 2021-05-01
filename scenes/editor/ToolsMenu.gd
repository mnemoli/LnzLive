extends PopupMenu

signal color_entire_pet(color_index)
signal color_part_pet(core_ball_nos, color_index)
signal copy_l_to_r
var current_action

enum RecolorAction { ENTIRE, LEGS, TAIL, HEAD, SNOUT }

func _ready():
	add_submenu_item("Color...", "RecolorMenu")

func _on_LineEdit_gui_input(event):
	if event is InputEventKey and event.pressed and event.scancode == KEY_ENTER:
		if current_action == RecolorAction.ENTIRE:
			emit_signal("color_entire_pet", get_parent().get_node("ColorPopup/LineEdit").text)
		else:
			var core_ball_nos = []
			if current_action == RecolorAction.LEGS:
				if KeyBallsData.species == KeyBallsData.Species.DOG:
					core_ball_nos.append_array(KeyBallsData.legs_dog[0])
					core_ball_nos.append_array(KeyBallsData.legs_dog[1])
				else:
					core_ball_nos.append_array(KeyBallsData.legs_cat[0])
					core_ball_nos.append_array(KeyBallsData.legs_cat[1])
			elif current_action == RecolorAction.TAIL:
				if KeyBallsData.species == KeyBallsData.Species.DOG:
					core_ball_nos.append_array(KeyBallsData.tail_dog)
				else:
					core_ball_nos.append_array(KeyBallsData.tail_cat)
			elif current_action == RecolorAction.HEAD:
				if KeyBallsData.species == KeyBallsData.Species.DOG:
					core_ball_nos.append_array(KeyBallsData.head_ext_dog)
				else:
					core_ball_nos.append_array(KeyBallsData.head_ext_cat)
			elif current_action == RecolorAction.SNOUT:
				if KeyBallsData.species == KeyBallsData.Species.DOG:
					core_ball_nos.append_array(KeyBallsData.face_ext_dog)
				else:
					core_ball_nos.append_array(KeyBallsData.face_ext_cat)
			emit_signal("color_part_pet", core_ball_nos, get_parent().get_node("ColorPopup/LineEdit").text)

func _on_RecolorMenu_id_pressed(id):
	current_action = id
	get_parent().get_node("ColorPopup").rect_position = get_global_mouse_position()
	get_parent().get_node("ColorPopup").popup()


func _on_ToolsMenu_index_pressed(index):
	if index == 0: #copy l to r
		emit_signal("copy_l_to_r")
