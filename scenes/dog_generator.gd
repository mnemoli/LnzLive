tool
extends Node

var balls = [
	BallData.new(37, Vector3(0, 0, 0), 49), # butt
	BallData.new(39, Vector3(17, -4, 0), 48), # belly
	BallData.new(35, Vector3(33, -1, 0), 50), # chest
	BallData.new(25, Vector3(-4, -3, 12), 19), # Rhip
	BallData.new(25, Vector3(-4, -3, -12), 43), # Lhip
	BallData.new(19, Vector3(-3, -16, 12), 16), # Rknee
	BallData.new(19, Vector3(-3, -16, -12), 40), # Lknee
	BallData.new(11, Vector3(-6, -27, 12), 0), # Rankle
	BallData.new(11, Vector3(-6, -27, -12), 24), # Lankle
	BallData.new(15, Vector3(-4, -34, 12), 12, Color.white, Color("8b6b35"), -2), # Rfoot
	BallData.new(15, Vector3(-4, -34, -12), 36, Color.white, Color("8b6b35"), -2), # Lfoot
	BallData.new(7, Vector3(1, -37, 7), 20, Color.white, Color("8b6b35"), -2), # Rtoe1
	BallData.new(7, Vector3(0, -37, 11), 21, Color.white, Color.black, -2), # Rtoe2
	BallData.new(7, Vector3(1, -37, 17), 22, Color.white, Color("8b6b35"), -2), # Rtoe3
	BallData.new(7, Vector3(1, -37, -7), 44, Color.white, Color("8b6b35"), -2), # Ltoe1
	BallData.new(7, Vector3(0, -37, -11), 45, Color.white, Color.black, -2), # Ltoe2
	BallData.new(7, Vector3(1, -37, -17), 46, Color.white, Color("8b6b35"), -2), # Ltoe3
	BallData.new(23, Vector3(35, -1, 12), 18), # Rshoulder
	BallData.new(23, Vector3(35, -1, -12), 42), # Lshoulder
	BallData.new(17, Vector3(29, -13, 12), 7), # Relbow
	BallData.new(17, Vector3(29, -13, -12), 31), # Lelbow
	BallData.new(11, Vector3(31, -25, 12), 23), # Rwrist
	BallData.new(11, Vector3(31, -25, -12), 47), # Lwrist
	BallData.new(15, Vector3(35, -33, 12), 13, Color.white, Color("8b6b35"), -2), # Rhand
	BallData.new(15, Vector3(35, -33, -12), 37, Color.white, Color("8b6b35"), -2), # Lhand
	BallData.new(7, Vector3(36, -37, 7), 9, Color.white, Color("8b6b35"), -2), # Rfinger1
	BallData.new(7, Vector3(40, -37, 12), 10, Color.white, Color("8b6b35"), -2), # Rfinger2
	BallData.new(7, Vector3(36, -37, 17), 11, Color.white, Color.black, -2), # Rfinger3
	BallData.new(7, Vector3(36, -37, -7), 33, Color.white, Color("8b6b35"), -2), # Lfinger1
	BallData.new(7, Vector3(40, -37, -12), 34, Color.white, Color.black, -2), # Lfinger2
	BallData.new(7, Vector3(36, -37, -17), 35, Color.white, Color("8b6b35"), -2), # Lfinger3
	BallData.new(32, Vector3(40, 7, 0), 54), # Neck
	BallData.new(32, Vector3(50, 12, 0), 52), # Head
	BallData.new(17, Vector3(48, 2, 10), 78), # Rcheek
	BallData.new(17, Vector3(48, 2, -10), 79), # Lcheek
	BallData.new(13, Vector3(62, -1, 5), 15, Color.white, Color("8b6b35"), 1), # Rjowl
	BallData.new(13, Vector3(62, -1, -5), 39, Color.white, Color("8b6b35"), 1), # Ljowl
	BallData.new(15, Vector3(65, 13, -7), 8, Color.white, Color.black, 1), # Eye1
	BallData.new(15, Vector3(65, 13, 7), 32, Color.white, Color.black, 1), # Eye2
	BallData.new(9, Vector3(67, 13, -7), -1, Color.black, Color("897e66"), 2), # Iris1
	BallData.new(9, Vector3(67, 13, 7), -1, Color.black, Color("897e66"), 2), # Iris2
	BallData.new(21, Vector3(63, 5, 0), 56), # Snout
	BallData.new(10, Vector3(57, -7, 0), 51, Color.white, Color("8b6b35"), 1), # Chin
	BallData.new(9, Vector3(-13, 7, 0), 57), # Tail1
	BallData.new(9, Vector3(-20, 10, 0), 58), # Tail2
	BallData.new(7, Vector3(-26, 16, 0), 59), # Tail3
	BallData.new(7, Vector3(-27, 23, 0), 60), # Tail4
	BallData.new(5, Vector3(-23, 29, 0), 61), # Tail5
	BallData.new(5, Vector3(-16, 32, 0), 62), # Tail6
	BallData.new(9, Vector3(73, 5, 2), 17, Color.black), # Rnose
	BallData.new(9, Vector3(73, 5, -2), 41, Color.black), # Lnose
	BallData.new(7, Vector3(71, 1, 0), 55, Color.black), # NoseBottom
	BallData.new(7, Vector3(53, 15, 13), 3, Color.white, Color.black, -2), # reyebrow1
	BallData.new(9, Vector3(55, 19, 11), 2), # reyebrow2
	BallData.new(5, Vector3(53, 21, 7), 1, Color.white, Color.black, 0), # reyebrow3
	BallData.new(7, Vector3(53, 15, -13), 27, Color.white, Color.black, -2), # leyebrow1
	BallData.new(9, Vector3(55, 19, -11), 26), # leyebrow2
	BallData.new(5, Vector3(53, 21, -7), 25, Color.white, Color.black, 0), # leyebrow3
	BallData.new(11, Vector3(47, 21, 13), 6, Color.white, Color.black, 0), # rear1
	BallData.new(11, Vector3(47, 21, 15), 5), # rear2
	BallData.new(7, Vector3(43, 17, 19), 4), # rear3
	BallData.new(11, Vector3(47, 21, -13), 30, Color.white, Color.black, 0), # lear1
	BallData.new(11, Vector3(47, 21, -15), 29), # lear2
	BallData.new(7, Vector3(43, 17, -19), 28), # lear3
]

var lines = [
	# tongue
	LineData.new(63, 77, 100, 100), #
	LineData.new(77, 64, 100, 100), #
	LineData.new(63, 53, 100, 100), #
	#
	LineData.new(52, 54, 90, 95), #head/neck
	LineData.new(50, 54, 85, 95), #chest/neck
	LineData.new(50, 48, 95, 95), #chest/belly
	LineData.new(49, 48, 95, 95), #belly/butt
	LineData.new(49, 19, 95, 95), #butt/hip
	LineData.new(49, 43, 95, 95), #butt/hip
	LineData.new(50, 18, 95, 95), #chest/shoulder
	LineData.new(50, 42, 95, 95), #chest/shoulder
	LineData.new(1, 2, 100, 100), #brow
	LineData.new(3, 2, 100, 100), #brow
	LineData.new(25, 26, 100, 100), #brow
	LineData.new(27, 26, 100, 100), #brow
	LineData.new(10, 11, 95, 95), #BULLshit
	#toes & fingers
	LineData.new(9, 13, 100, 100), #
	LineData.new(10, 13, 90, 90), #
	LineData.new(11, 13, 100, 100), #
	LineData.new(33, 37, 100, 100), #
	LineData.new(34, 37, 90, 90), #
	LineData.new(35, 37, 100, 100), #
	LineData.new(44, 36, 100, 100), #
	LineData.new(45, 36, 90, 90), #
	LineData.new(46, 36, 100, 100), #
	LineData.new(20, 12, 100, 100), #
	LineData.new(21, 12, 90, 90), #
	LineData.new(22, 12, 100, 100), 
	#face
	LineData.new(56, 52, 100, 100), #snout, head
	LineData.new(51, 53, 85, 90), #jaw/chin
	LineData.new(56, 17, 100, 100), #
	LineData.new(56, 41, 100, 100), #
	LineData.new(39, 15, 95, 95), #
	LineData.new(56, 15, 100, 100), #
	LineData.new(56, 39, 100, 100), #
	LineData.new(56, 78, 100, 100), #
	LineData.new(56, 79, 100, 100), #
	LineData.new(53, 80, 90, 100), #
	LineData.new(53, 81, 90, 100), #
	LineData.new(80, 51, 100, 100), #
	LineData.new(81, 51, 100, 100), #
	LineData.new(51, 56, 0, 100), #
	LineData.new(15, 78, 70, 70), #
	LineData.new(39, 79, 70, 70), #
	LineData.new(78, 80, 95, 95), #
	LineData.new(79, 81, 95, 95), #
	LineData.new(78, 79, 95, 95), 
	#jowlz
	LineData.new(51, 78, 100, 100), #
	LineData.new(51, 79, 100, 100), 
	#ears
	LineData.new(6, 5, 100, 100), #
	LineData.new(5, 4, 100, 100), #
	LineData.new(30, 29, 100, 100), #
	LineData.new(29, 28, 100, 100), #
	LineData.new(4, 84, 100, 100), #
	LineData.new(28, 83, 100, 100), #
	LineData.new(52, 6, 100, 100), #
	LineData.new(52, 30, 100, 100), 
	#body
	LineData.new(57, 49, 100, 55), #tail/butt
	LineData.new(57, 58, 100, 100), #tail/butt
	LineData.new(58, 59, 100, 100), #tail/butt
	LineData.new(59, 60, 100, 100), #tail/butt
	LineData.new(60, 61, 100, 100), #tail/butt
	LineData.new(61, 62, 100, 100), #tail/butt
	LineData.new(7, 18, 95, 95), #LShoulder/Lelbow
	LineData.new(23, 7, 100, 80), #Lelbow/Lwrist
	LineData.new(23, 13, 80, 85), #Lwrist /Lhand
	LineData.new(42, 31, 95, 95), #RShoulder/Relbow
	LineData.new(47, 31, 100, 80), #Relbow/Rwrist
	LineData.new(47, 37, 80, 85), #Rwrist/Rhand
	LineData.new(19, 16, 95, 95), #Lthigh/Lknee
	LineData.new(16, 0, 95, 95), #Lknee/Lankle
	LineData.new(0, 12, 95, 85), #Lankle/Lfoot
	LineData.new(43, 40, 95, 95), #Rthigh/Rknee
	LineData.new(40, 24, 95, 95), #RKnee/Rankle
	LineData.new(24, 36, 95, 85), #Rankle/Rfoot
]

var ball_map = {}

export var do_something = false setget generate_pet
export var draw_balls = true

var ball_scene = preload("res://Ball.tscn")
var line_scene = preload("res://Line.tscn")

func generate_pet(_new_value):
	generate_balls()
	generate_lines()

func generate_balls():
	var root = get_tree().get_edited_scene_root()
	var parent = root.get_node("petholder/balls")
	for c in parent.get_children():
		parent.remove_child(c)
		c.queue_free()
	for ball in balls:
		var visual_ball = ball_scene.instance()
		visual_ball.ball_size = ball.size / 2
		visual_ball.transform.origin = ball.position / 1024
		visual_ball.color = ball.color
		visual_ball.outline = ball.outline
		visual_ball.outline_color = ball.outline_color
		parent.add_child(visual_ball)
		visual_ball.set_owner(root)
		ball_map[ball.ball_no] = visual_ball
		if !draw_balls:
			visual_ball.visible = false
		
func generate_lines():
	var root = get_tree().get_edited_scene_root()
	var parent = root.get_node("petholder/lines")
	for c in parent.get_children():
		parent.remove_child(c)
		c.queue_free()
	
	for line in lines:
		var start = ball_map.get(line.start)
		var end = ball_map.get(line.end)
		
		if start == null or end == null:
			print("Could not make a line between " + str(line.start) + " and " + str(line.end))
			continue
		
		var visual_line = line_scene.instance()
		var start_pos = start.global_transform.origin
		var target_pos = end.global_transform.origin
		var distance = (target_pos - start_pos).length()
		var middle_point = lerp(start.global_transform.origin, end.transform.origin, 0.5)
		visual_line.look_at_from_position(middle_point, target_pos, Vector3.UP)
		visual_line.rotation_degrees.x += 90
		visual_line.scale.y = distance
		visual_line.color = Color.white
		var final_line_width = Vector2(start.ball_size * 2 - 1, end.ball_size * 2 - 1)
		final_line_width = final_line_width * (Vector2(line.s_thick, line.e_thick) / 100)
		visual_line.line_widths = final_line_width
		
		parent.add_child(visual_line)
		visual_line.set_owner(root)


func _on_showballs_toggled(button_pressed):
	for ball in get_tree().root.get_node("Spatial/petholder/balls").get_children():
		ball.visible = button_pressed

func _on_showlines_toggled(button_pressed):
	for line in get_tree().root.get_node("Spatial/petholder/lines").get_children():
		line.visible = button_pressed
