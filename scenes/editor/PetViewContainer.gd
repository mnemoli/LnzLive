extends Control

onready var camera_holder = get_tree().root.get_node("Root/SceneRoot/ViewportContainer/Viewport/CameraHolder") as Spatial
onready var camera = camera_holder.get_node("Camera") as Camera
onready var label = get_tree().root.get_node("Root/SceneRoot/Label")
onready var cube = get_tree().root.get_node("Root/PetRoot/MeshInstance") as Spatial
onready var tex = get_tree().root.get_node("Root/SceneRoot/ViewportContainer") as ViewportContainer
onready var popup = get_tree().root.get_node("Root/SceneRoot/PopupDialog") as WindowDialog
onready var mode_option = get_tree().root.get_node("Root/SceneRoot/HSplitContainer/HSplitContainer/PetViewContainer/VBoxContainer/HBoxContainer3/ModeOption") as OptionButton
onready var text_panel = get_tree().root.get_node("Root/SceneRoot/HSplitContainer/HSplitContainer/TextPanelContainer") as PanelContainer

var last_selected
var selected_ball_for_move
var selected_gizmo
var mode = SELECT
var mode_on = false
enum { SELECT, MOVE }

func _gui_input(event):
	if event is InputEventMouseMotion:
		if selected_gizmo_is_valid() and Input.is_mouse_button_pressed(BUTTON_LEFT):
			selected_gizmo._on_Area_input_event(event)
			return
		if Input.is_mouse_button_pressed(BUTTON_LEFT):
			var motion = event.relative as Vector2
			camera_holder.rotation.x += motion.y * 0.01
			camera_holder.rotation.y += motion.x * -0.01
		elif Input.is_mouse_button_pressed(BUTTON_RIGHT) or Input.is_mouse_button_pressed(BUTTON_MIDDLE):
			var motion = event.relative as Vector2
			camera.transform.origin.x += motion.x * 0.001 / tex.rect_scale.x
			camera.transform.origin.y += motion.y * 0.001 / tex.rect_scale.x

		label.rect_global_position = event.global_position

		# try and do a raycast
		# the center of the actual texture == (500,500)
		if (mode == SELECT or mode == MOVE) and mode_on:
			var real_center = rect_position + rect_size / 2.0
			var real_mouse_pos = event.position
			var offset = real_mouse_pos - real_center
			offset /= tex.rect_scale
			var final_pos = Vector2(500,500) + offset

			var from = camera.project_ray_origin(final_pos)
			var to = from + camera.project_ray_normal(final_pos) * 950
			var space_state = camera.get_world().direct_space_state
			
			if mode == MOVE and selected_ball_for_move != null:
				# see if we're near a gizmo
				var result = space_state.intersect_ray(from, to, [], 0x2, false, true)
				if !result.empty():
					result.collider.get_parent().focus()
					selected_gizmo = result.collider.get_parent()
					return
					
			var mask
			if mode == SELECT:
				# include paintballs
				mask = 0x7FFFFFFD
			elif mode == MOVE:
				# exclude paintballs
				mask = 0x7FFFFFF9
			var result = space_state.intersect_ray(from, to, [], mask, false, true)
			if !result.empty():
				if mode == SELECT:
					label.show()
				deal_with_last_selected()
				result.collider.get_parent()._on_Area_mouse_entered(mode)
				last_selected = result.collider.get_parent()
			else:
				deal_with_last_selected()
				last_selected = null
				label.hide()

	elif event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_WHEEL_DOWN:
			tex.rect_pivot_offset = tex.rect_size / 2.0
			tex.rect_scale = tex.rect_scale / 2.0
		elif event.button_index == BUTTON_WHEEL_UP:
			tex.rect_pivot_offset = tex.rect_size / 2.0
			tex.rect_scale = tex.rect_scale * 2.0
		elif selected_gizmo_is_valid():
			selected_gizmo._on_Area_input_event(event)
		elif last_selected_is_valid():
			last_selected._on_Area_input_event(event, mode)
			
	elif event is InputEventMouseButton and !event.pressed and event.button_index == BUTTON_LEFT:
		if selected_gizmo_is_valid():
			selected_gizmo.dropped()
		selected_gizmo = null
			
func _unhandled_key_input(event):
	if event.pressed and last_selected_is_valid():
		last_selected._input(event)
		
func last_selected_is_valid():
	return last_selected != null and is_instance_valid(last_selected)
	
func selected_gizmo_is_valid():
	return selected_gizmo != null and is_instance_valid(selected_gizmo)

func deal_with_last_selected():
	if last_selected != null and is_instance_valid(last_selected):
		last_selected._on_Area_mouse_exited(mode)
				
func _on_Node_ball_mouse_enter(ball_info):
	label.text = str(ball_info.ball_no)

func _on_Mode_toggled(button_pressed):
	mode_on = button_pressed
	if mode == SELECT:
		toggle_selecting(button_pressed)
	elif mode == MOVE:
		toggle_moving(button_pressed)

func toggle_selecting(new_value):
	if !new_value:
		if last_selected_is_valid():
			last_selected._on_Area_mouse_exited(mode)
		last_selected = null
		label.hide()

func toggle_moving(new_value):
	text_panel.get_node("LnzTextEdit").readonly = new_value
	pass

func _on_HelpButton_pressed():
	popup.popup_centered()

func _on_LnzTextEdit_mouse_entered():
	if last_selected_is_valid():
		last_selected._on_Area_mouse_exited(mode)
	last_selected = null
	label.hide()

func _on_PetViewContainer_resized():
	var size_diff = tex.rect_size / 2.0 - self.rect_size / 2.0
	tex.rect_global_position = self.rect_global_position - size_diff

func _on_PetViewContainer_sort_children():
	_on_PetViewContainer_resized()

func _on_ModeOption_item_selected(index):
	var old_mode = mode
	mode = index
	if old_mode == SELECT:
		toggle_selecting(false)
	elif old_mode == MOVE:
		toggle_moving(false)
	if mode_on:
		_on_Mode_toggled(true)


func _on_ball_selected_for_move(ball_no):
	selected_ball_for_move = ball_no
