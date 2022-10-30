extends MeshInstance

onready var the_ball: Spatial = get_parent().get_parent()
var start_mouse_pos
var start_pos

signal ball_move_start(ball)
signal ball_move_end(ball)
signal ball_moving(ball)

func _ready():
	var generator = get_tree().root.get_node("Root/PetRoot/Node")
	connect("ball_move_start", generator, "ball_move_start")
	connect("ball_move_end", generator, "ball_move_end")
	connect("ball_moving", generator, "ball_moving")

func focus():
	for c in get_parent().get_children():
		c.unfocus()
	material_override.albedo_color.a = 1.0
	
func unfocus():
	material_override.albedo_color.a = 0.3

func _on_Area_input_event(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		# picked up
		start_mouse_pos = event.global_position
		start_pos = the_ball.global_transform.origin
		emit_signal("ball_move_start", the_ball)
	elif event is InputEventMouseButton and !event.pressed and event.button_index == BUTTON_LEFT:
		emit_signal("ball_move_end", the_ball)
	elif event is InputEventMouseMotion and Input.is_mouse_button_pressed(BUTTON_LEFT) and start_pos != null:
		var mouse_delta = event.relative.x * 0.1
		the_ball.global_transform.origin += (mouse_delta * -global_transform.basis.z).snapped(Vector3.ONE * 0.002)
		emit_signal("ball_moving", the_ball)
		
func dropped():
	if start_pos != null and start_pos.distance_to(the_ball.global_transform.origin) > 0.01:
		emit_signal("ball_move_end", the_ball)
	start_pos = null
	start_mouse_pos = null
