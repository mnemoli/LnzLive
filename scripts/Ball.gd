tool
extends Spatial

export var ball_size = 10 setget set_ball_size
export var fuzz_amount = 0 setget set_fuzz_amount
export var outline = -1 setget set_outline
export var color = Color.white setget set_color
export var outline_color = Color.black setget set_outline_color
export var z_add = 0.0 setget set_z_add
export var ball_no = 0
export var base_ball_no = -1

func set_ball_size(new_value):
	ball_size = new_value
	$MeshInstance.material_override.set_shader_param("ball_size", new_value)
	var a = ball_size * 0.025
	scale = Vector3(a,a,a)
	
func set_fuzz_amount(new_value):
	fuzz_amount = new_value
	$MeshInstance.material_override.set_shader_param("fuzz_amount", new_value)
	
func set_outline(new_value):
	outline = new_value
	$MeshInstance.material_override.set_shader_param("outline", new_value)

func set_color(new_value):
	color = new_value
	$MeshInstance.material_override.set_shader_param("color", new_value)
	
func set_outline_color(new_value):
	outline_color = new_value
	$MeshInstance.material_override.set_shader_param("outline_color", new_value)
	
func set_z_add(new_value):
	z_add = new_value
	$MeshInstance.material_override.set_shader_param("z_add", new_value)
