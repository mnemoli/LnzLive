extends PopupMenu

signal color_entire_pet(color_index, outline_color_index)
signal color_part_pet(core_ball_nos, color_index, outline_color_index, part)
signal add_ball(selected_ball)
signal copy_l_to_r()
signal recolor(recolor_info)
signal move_head(x,y,z)
signal print_ball_colors()

var current_action

enum RecolorAction { ENTIRE, LEGS, TAIL, HEAD, SNOUT, EARS, PAWS, NOSE }

func _ready():
	add_submenu_item("Color...", "RecolorMenu")
	add_item("Add ball")
	add_item("Copy L to R")
	add_item("Move head")
	add_item("Copy ball colors to clipboard")

func _on_LineEdit_gui_input(event):
	if event is InputEventKey and event.pressed and event.scancode == KEY_ENTER:
		var base_color = get_parent().get_node("ColorPopup/VBoxContainer/LineEdit").text
		var outline_color = get_parent().get_node("ColorPopup/VBoxContainer/LineEdit2").text
		if current_action == RecolorAction.ENTIRE:
			emit_signal("color_entire_pet", base_color, outline_color)
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
			elif current_action == RecolorAction.NOSE:
				if KeyBallsData.species == KeyBallsData.Species.DOG:
					core_ball_nos.append_array(KeyBallsData.nose_dog)
				else:
					core_ball_nos.append_array(KeyBallsData.nose_cat)
			var part = RecolorAction.keys()[RecolorAction.values()[current_action]]
			emit_signal("color_part_pet", core_ball_nos, base_color, outline_color, part)

func _on_RecolorMenu_id_pressed(id):
	current_action = id
	if id == 8: # color swap
		get_parent().get_node("RecolorPopup").popup_centered()
	else:
		get_parent().get_node("ColorPopup").rect_position = get_global_mouse_position()
		get_parent().get_node("ColorPopup").popup()

func _on_ToolsMenu_index_pressed(index):
	if index == 2: #copy l to r
		emit_signal("copy_l_to_r")
	elif index == 1: # add ball
		var view_container = get_tree().root.get_node("Root/SceneRoot/HSplitContainer/HSplitContainer/PetViewContainer")
		if view_container.last_selected_is_valid():
			emit_signal("add_ball", view_container.last_selected)
	elif index == 3: # move head
		var options = get_parent().get_node("HeadMovePopup")
		options.popup_centered()
	elif index == 4: # print colors
		emit_signal("print_ball_colors")

func _on_ToolsMenu_about_to_show():
	var view_container = get_tree().root.get_node("Root/SceneRoot/HSplitContainer/HSplitContainer/PetViewContainer")
	set_item_disabled(1, !view_container.last_selected_is_valid())

func _on_RecolorPopup_confirmed():
	# get all the recolor infos
	var popup = get_parent().get_node("RecolorPopup/VBoxContainer")
	var lines = popup.get_node("RecolorLines").get_children()
	var recolor_info = {recolors = {}}
	for l in lines:
		var original_color = l.get_child(0).text as String
		var new_color = l.get_child(2).text as String
		if original_color.empty() or new_color.empty():
			continue
		recolor_info.recolors[original_color] = new_color
	var balls_on = popup.get_node("CheckContainer/Balls").pressed
	var ball_outlines_on = popup.get_node("CheckContainer/Ball outlines").pressed
	var paintballs_on = popup.get_node("CheckContainer/Paintballs").pressed
	var lines_on = popup.get_node("CheckContainer/Lines").pressed
	recolor_info.balls_on = balls_on
	recolor_info.ball_outlines_on = ball_outlines_on
	recolor_info.paintballs_on = paintballs_on
	recolor_info.lines_on = lines_on
	emit_signal("recolor", recolor_info)
		

func _on_ClearButton_pressed():
	var popup = get_parent().get_node("RecolorPopup/VBoxContainer")
	var lines = popup.get_node("RecolorLines").get_children()
	for l in lines:
		l.get_child(0).text = ""
		l.get_child(2).text = ""
	for cb in popup.get_node("CheckContainer").get_children():
		cb.pressed = true

func _on_HeadMoveLineEdit_gui_input(event):
	if event is InputEventKey and event.pressed and event.scancode == KEY_ENTER:
		var popup = get_parent().get_node("HeadMovePopup/VBoxContainer")
		var x = popup.get_node("HeadMoveLineEditX").text.to_int()
		var y = popup.get_node("HeadMoveLineEditY").text.to_int()
		var z = popup.get_node("HeadMoveLineEditZ").text.to_int()
		emit_signal("move_head", x, y, z)
