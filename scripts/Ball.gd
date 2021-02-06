extends Spatial

export var ball_size = 10 setget set_ball_size
export var fuzz_amount = 0 setget set_fuzz_amount
export var outline = -1 setget set_outline

func set_ball_size(new_value):
	ball_size = new_value;
	$MeshInstance.material_override.set_shader_param("ball_size", new_value);
	
func set_fuzz_amount(new_value):
	fuzz_amount = new_value;
	$MeshInstance.material_override.set_shader_param("fuzz_amount", new_value);
	
func set_outline(new_value):
	outline = new_value;
	$MeshInstance.material_override.set_shader_param("outline", new_value);
