tool
extends Spatial

export var ball_size = 10 setget set_ball_size
export var fuzz_amount = 0 setget set_fuzz_amount
export var outline = -1 setget set_outline
export var color = Color.white setget set_color
export var color_index = 0 setget set_color_index
export var outline_color = Color.black setget set_outline_color
export var z_add = 0.0 setget set_z_add
export var ball_no = 0
export var base_ball_no = -1
export var texture: Texture setget set_texture
export var transparent_color = 0 setget set_transparent_color
export var visible_override = true setget set_visible
export var omitted = false

var palette = preload("res://resources/textures/petzpalette.png")

func _ready():
	$MeshInstance.material_override.set_shader_param("palette", palette)

func set_visible(new_value):
	visible_override = new_value
	if !omitted:
		$MeshInstance.visible = new_value

func set_ball_size(new_value):
	ball_size = new_value
	$MeshInstance.material_override.set_shader_param("ball_size", new_value)
	var a = ball_size * 0.025
#	scale = Vector3(a,a,a)
	
func set_fuzz_amount(new_value):
	fuzz_amount = new_value
	$MeshInstance.material_override.set_shader_param("fuzz_amount", new_value)
	
func set_outline(new_value):
	outline = new_value
	$MeshInstance.material_override.set_shader_param("outline", new_value)

func set_color(new_value):
	color = new_value
	$MeshInstance.material_override.set_shader_param("color", new_value)

func set_color_index(new_value):
	color_index = new_value
	$MeshInstance.material_override.set_shader_param("color_index", new_value)
	
func set_outline_color(new_value):
	outline_color = new_value
	$MeshInstance.material_override.set_shader_param("outline_color", new_value)
	
func set_z_add(new_value):
	z_add = new_value
	$MeshInstance.material_override.set_shader_param("z_add", new_value)

func set_texture(new_value):
	texture = new_value
	$MeshInstance.material_override.set_shader_param("ball_texture", new_value)

func set_transparent_color(new_value):
	transparent_color = new_value
	$MeshInstance.material_override.set_shader_param("transparent_index", new_value)
