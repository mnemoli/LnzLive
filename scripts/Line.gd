extends Spatial

export var line_widths = Vector2(10, 10) setget set_line_width
export var fuzz_amount = 0 setget set_fuzz_amount
export var color_index = 0 setget set_color_index
export var l_color_index = 0 setget set_l_color_index
export var r_color_index = 0 setget set_r_color_index
export var ball_world_pos1 = Vector3.ZERO setget set_ball_world_pos1
export var ball_world_pos2 = Vector3.ZERO setget set_ball_world_pos2
export var texture: Texture setget set_texture
export var transparent_color = 0 setget set_transparent_color

var palette = preload("res://resources/textures/petzpalette.png")

func _ready():
	$MeshInstance.material_override.set_shader_param("palette", palette)

func set_line_width(new_value):
	line_widths = new_value;
	$MeshInstance.material_override.set_shader_param("line_width_in_pixels_start", new_value.x);
	$MeshInstance.material_override.set_shader_param("line_width_in_pixels_end", new_value.y);
	
func set_fuzz_amount(new_value):
	fuzz_amount = new_value;
	$MeshInstance.material_override.set_shader_param("fuzz_amount", new_value);

func set_r_color_index(new_value):
	r_color_index = new_value
	$MeshInstance.material_override.set_shader_param("r_color_index", new_value);

func set_l_color_index(new_value):
	l_color_index = new_value
	$MeshInstance.material_override.set_shader_param("l_color_index", new_value);

func set_ball_world_pos1(new_value):
	ball_world_pos1 = new_value
	$MeshInstance.material_override.set_shader_param("ball_world_pos1", new_value);
	
func set_ball_world_pos2(new_value):
	ball_world_pos2 = new_value
	$MeshInstance.material_override.set_shader_param("ball_world_pos2", new_value);

func set_color_index(new_value):
	color_index = new_value
	$MeshInstance.material_override.set_shader_param("color_index", new_value)
	
func set_texture(new_value):
	texture = new_value
	$MeshInstance.material_override.set_shader_param("line_texture", new_value)
	$MeshInstance.material_override.set_shader_param("has_texture", true)
	if new_value != null:
		$MeshInstance.material_override.set_shader_param("texture_size", new_value.get_size())
	else:
		$MeshInstance.material_override.set_shader_param("has_texture", false)

func set_transparent_color(new_value):
	transparent_color = new_value
	$MeshInstance.material_override.set_shader_param("transparent_index", new_value)
