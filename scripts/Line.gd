extends Spatial

export var line_width = 10 setget set_line_width
export var fuzz_amount = 0 setget set_fuzz_amount

func set_line_width(new_value):
	line_width = new_value;
	$MeshInstance.material_override.set_shader_param("line_width_in_pixels", new_value);
	
func set_fuzz_amount(new_value):
	fuzz_amount = new_value;
	$MeshInstance.material_override.set_shader_param("fuzz_amount", new_value);
