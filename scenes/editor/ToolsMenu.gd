extends PopupMenu

signal color_entire_pet(color_index)
signal color_part_pet(core_ball_nos, color_index)
signal add_ball(selected_ball)
signal copy_l_to_r
var current_action

enum RecolorAction { ENTIRE, LEGS, TAIL, HEAD, SNOUT, EARS, PAWS }

func _ready():
	add_submenu_item("Color...", "RecolorMenu")
	add_item("Add ball")
	add_item("Copy L to R")

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
					for ar in KeyBallsData.foot_ext_dog:
						for v in ar:
							core_ball_nos.erase(v)
				else:
					core_ball_nos.append_array(KeyBallsData.legs_cat[0])
					core_ball_nos.append_array(KeyBallsData.legs_cat[1])
					for ar in KeyBallsData.foot_ext_cat:
						for v in ar:
							core_ball_nos.erase(v)
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
			elif current_action == RecolorAction.EARS:
				if KeyBallsData.species == KeyBallsData.Species.DOG:
					var v = KeyBallsData.ear_ext_dog.values()
					core_ball_nos.append_array(v[0])
					core_ball_nos.append_array(v[1])
					core_ball_nos.append_array(KeyBallsData.ear_ext_dog.keys())
				else:
					var v = KeyBallsData.ear_ext_cat.values()
					core_ball_nos.append_array(v[0])
					core_ball_nos.append_array(v[1])
					core_ball_nos.append_array(KeyBallsData.ear_ext_cat.keys())
			elif current_action == RecolorAction.PAWS:
				if KeyBallsData.species == KeyBallsData.Species.DOG:
					for ar in KeyBallsData.foot_ext_dog:
						core_ball_nos.append_array(ar)
				else:
					for ar in KeyBallsData.foot_ext_cat:
						core_ball_nos.append_array(ar)
			emit_signal("color_part_pet", core_ball_nos, get_parent().get_node("ColorPopup/LineEdit").text)

func _on_RecolorMenu_id_pressed(id):
	current_action = id
	get_parent().get_node("ColorPopup").rect_position = get_global_mouse_position()
	get_parent().get_node("ColorPopup").popup()

func _on_ToolsMenu_index_pressed(index):
	if index == 2: #copy l to r
		emit_signal("copy_l_to_r")
	elif index == 1: # add ball
		var view_container = get_tree().root.get_node("Root/SceneRoot/HSplitContainer/HSplitContainer/PetViewContainer")
		if view_container.last_selected_is_valid():
			emit_signal("add_ball", view_container.last_selected)

func _on_ToolsMenu_about_to_show():
	var view_container = get_tree().root.get_node("Root/SceneRoot/HSplitContainer/HSplitContainer/PetViewContainer")
	set_item_disabled(1, !view_container.last_selected_is_valid())
