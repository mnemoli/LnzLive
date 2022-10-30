extends Spatial

export var ball_size = 10 setget set_ball_size
export var fuzz_amount = 0 setget set_fuzz_amount
export var outline = -1 setget set_outline
export var color_index = 0 setget set_color_index
export var outline_color_index = 0 setget set_outline_color_index
export var z_add = 0.0 setget set_z_add
export var ball_no = 0
export var base_ball_no = -1
export var texture: Texture setget set_texture
export var transparent_color = 0 setget set_transparent_color
export var visible_override = true setget set_visible
export var omitted = false
export var pet_center = Vector3(0, 0, 0) setget set_pet_center

var old_outline
var old_outline_color
var is_over = false
var highlighted = false

var palette = preload("res://resources/textures/petzpalette.png")

signal ball_mouse_enter(ball_info)
signal ball_mouse_exit(ball_no)
signal ball_selected(ball_no, section)
signal ball_deleted(ball_no)
signal ball_selected_for_move(ball_no)
signal ball_moved(ball_no, new_global_origin)

func _ready():
	$MeshInstance.material_override.set_shader_param("palette", palette)

func set_visible(new_value):
	visible_override = new_value
	if !omitted:
		$MeshInstance.visible = new_value
		$Area/CollisionShape.disabled = !new_value
		$Area/CollisionShape.visible = new_value
	else:
		$Area/CollisionShape.disabled = true
		$Area/CollisionShape.visible = false

func set_ball_size(new_value):
	ball_size = new_value
	$MeshInstance.material_override.set_shader_param("ball_size", new_value)
	var a = ball_size * 0.05
	$Area/CollisionShape.shape.radius = a * 0.02
	$Area/CollisionShape.shape.margin = 0.0001
	
func set_fuzz_amount(new_value):
	fuzz_amount = new_value
	$MeshInstance.material_override.set_shader_param("fuzz_amount", new_value)
	
func set_outline(new_value):
	outline = new_value
	$MeshInstance.material_override.set_shader_param("outline", new_value)

func set_color_index(new_value):
	color_index = new_value
	$MeshInstance.material_override.set_shader_param("color_index", new_value)
	
func set_outline_color_index(new_value):
	$MeshInstance.material_override.set_shader_param("outline_color_index", new_value)
	outline_color_index = new_value
	
func set_z_add(new_value):
	z_add = new_value
	$MeshInstance.material_override.set_shader_param("z_add", new_value)

func set_texture(new_value):
	texture = new_value
	$MeshInstance.material_override.set_shader_param("ball_texture", new_value)
	if new_value != null:
		$MeshInstance.material_override.set_shader_param("texture_size", new_value.get_size())
		$MeshInstance.material_override.set_shader_param("has_texture", true)
	else:
		$MeshInstance.material_override.set_shader_param("has_texture", false)

func set_transparent_color(new_value):
	transparent_color = new_value
	$MeshInstance.material_override.set_shader_param("transparent_index", new_value)

func set_pet_center(new_value):
	pet_center = new_value
	$MeshInstance.material_override.set_shader_param("z_center_pet_world", new_value)

func _on_Area_mouse_entered(mode):
	is_over = true
	if mode == 0:
		turn_on_highlight()
	emit_signal("ball_mouse_enter", {ball_no = ball_no})
	
func show_gizmo():
	$GizmoHolder.show_gizmo()
	
func turn_on_highlight():
	highlighted = true
	old_outline = outline
	old_outline_color = outline_color_index
	set_outline(3)
	set_outline_color_index(0)
	
func turn_off_highlight():
	if highlighted:
		highlighted = false
		set_outline(old_outline)
		set_outline_color_index(old_outline_color)

func hide_gizmo():
	$GizmoHolder.destroy_gizmo()
	
func _on_Area_mouse_exited(mode):
	is_over = false
	if mode == 0:
		turn_off_highlight()
	emit_signal("ball_mouse_exit", ball_no)
	
func selected():
	emit_signal("ball_selected", ball_no, Section.Section.BALL)
	
func selected_for_move():
	show_gizmo()
	turn_on_highlight()
	emit_signal("ball_selected_for_move", ball_no)
	
func unselect_for_move():
	hide_gizmo()
	turn_off_highlight()

func _on_Area_input_event(event, mode):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.doubleclick:
			selected()
		elif mode == 1:
			selected_for_move()

func _input(event):
	if event is InputEventKey and event.pressed and is_over:
		if event.scancode == KEY_SPACE and event.control:
			return
		if event.scancode == KEY_B or event.scancode == KEY_Z:
			get_tree().set_input_as_handled()
			emit_signal("ball_selected", ball_no, Section.Section.BALL)
		elif event.scancode == KEY_M or event.scancode == KEY_X:
			get_tree().set_input_as_handled()
			emit_signal("ball_selected", ball_no, Section.Section.MOVE)
		elif event.scancode == KEY_P or event.scancode == KEY_C:
			get_tree().set_input_as_handled()
			emit_signal("ball_selected", ball_no, Section.Section.PROJECT)
		elif event.scancode == KEY_L or event.scancode == KEY_V:
			get_tree().set_input_as_handled()
			emit_signal("ball_selected", ball_no, Section.Section.LINE)
		elif event.scancode == KEY_DELETE:
			get_tree().set_input_as_handled()
			emit_signal("ball_deleted", ball_no)

var timer_count = 0

func flash():
	timer_count = 0
	if !is_over:
		turn_on_highlight()
		$FlashTimer.start()

func _on_FlashTimer_timeout():
	timer_count += 1
	if !is_over:
		if timer_count % 2 == 1:
			turn_off_highlight()
		else:
			turn_on_highlight()
		if timer_count > 4:
			$FlashTimer.stop()
			
func ball_moved():
	emit_signal("ball_moved", ball_no, global_transform.origin)
