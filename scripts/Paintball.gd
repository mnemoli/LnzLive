tool
extends Spatial

export var base_ball_position = Vector3.ZERO setget set_base_ball_position
export var base_ball_size = 10 setget set_base_ball_size
export var ball_size = 10 setget set_ball_size
export var fuzz_amount = 0 setget set_fuzz_amount
export var outline = -1 setget set_outline
export var color_index = -1 setget set_color_index
export var outline_color_index = 0 setget set_outline_color_index
export var z_add = 0.0 setget set_z_add
export var base_ball_no = 0
export var visible_override = true setget set_visible
export var override_ball_no = -1
export var texture: Texture setget set_texture
export var transparent_color = 0 setget set_transparent_color

var palette = preload("res://resources/textures/petzpalette.png")

var old_outline
var old_outline_color
var is_over

signal paintball_mouse_enter(paintball_info)
signal paintball_mouse_exit()
# only used if its an iris
signal ball_mouse_enter(ball_info)
signal ball_mouse_exit(ball_no)
signal ball_selected(ball_no, section)

func _ready():
	$MeshInstance.material_override.set_shader_param("palette", palette)

func set_visible(new_value):
	visible_override = new_value
	$Area/CollisionShape.disabled = !new_value
	$Area/CollisionShape.visible = new_value
	$MeshInstance.visible = new_value

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

func set_base_ball_position(new_value):
	base_ball_position = new_value
	$MeshInstance.material_override.set_shader_param("base_world_position", new_value)

func set_base_ball_size(new_value):
	base_ball_size = new_value
	$MeshInstance.material_override.set_shader_param("base_ball_size", new_value)

func set_ball_size(new_value):
	ball_size = new_value
	$MeshInstance.material_override.set_shader_param("ball_size", new_value)
	var a = ball_size * 0.25
	$Area/CollisionShape.shape.radius = a * 0.008
#	scale = Vector3(a,a,a)
	
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
	outline_color_index = new_value
	$MeshInstance.material_override.set_shader_param("outline_color_index", new_value)

func selected():
	if override_ball_no != -1:
		emit_signal("ball_selected", override_ball_no, Section.Section.BALL)

func _on_Area_mouse_entered():
	old_outline = outline
	old_outline_color = outline_color_index
	set_outline(3)
	set_outline_color_index(0)
	if override_ball_no != -1:
		emit_signal("ball_mouse_enter", {ball_no = override_ball_no})
	else:
		emit_signal("paintball_mouse_enter", {base_ball_no = base_ball_no})
	is_over = true

func _on_Area_mouse_exited():
	set_outline(old_outline)
	set_outline_color_index(old_outline_color)
	if override_ball_no != -1:
		emit_signal("ball_mouse_exit", override_ball_no)
	else:
		emit_signal("paintball_mouse_exit")
	is_over = false
	
func _input(event):
	if event is InputEventKey and event.pressed and is_over:
		get_tree().set_input_as_handled()
