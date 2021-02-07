tool
extends Spatial

export var line_widths = Vector2(10, 10) setget set_line_width
export var fuzz_amount = 0 setget set_fuzz_amount
export var color = Color.white setget set_color

func set_line_width(new_value):
	line_widths = new_value;
	$MeshInstance.material_override.set_shader_param("line_width_in_pixels_start", new_value.x);
	$MeshInstance.material_override.set_shader_param("line_width_in_pixels_end", new_value.y);
	
func set_fuzz_amount(new_value):
	fuzz_amount = new_value;
	$MeshInstance.material_override.set_shader_param("fuzz_amount", new_value);

func set_color(new_value):
	color = new_value
	$MeshInstance.material_override.set_shader_param("color", new_value);
